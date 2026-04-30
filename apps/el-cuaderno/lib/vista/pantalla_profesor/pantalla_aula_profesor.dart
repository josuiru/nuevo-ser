import 'package:flutter/material.dart';
import 'package:nuevo_ser_companion/nuevo_ser_companion.dart' as companion;
import 'package:nuevo_ser_core/nuevo_ser_core.dart';

import '../tema/colores.dart';
import '../tema/tipografia.dart';
import 'pantalla_login_profesor.dart';

/// Dashboard del aula del profesor (B7 — fallback de experto pendiente
/// de policy escolar definitiva).
///
/// Tres estados visibles:
///
/// 1. **Sin aula creada**: formulario rápido para que el profesor
///    inicie su primera (nombre del aula + checklist de juegos
///    catalogados).
/// 2. **Aula creada, esperando datos**: muestra el `code` de
///    invitación y un mensaje de "k mínimo no alcanzado todavía". La
///    voz del cuaderno (no humillar): se cuenta cuántos miembros hay,
///    sin culpar a quien falte.
/// 3. **Aula con datos**: counts agregados por juego en lectura
///    sencilla. Sin gráficos ricos — eso es decisión humana (B7-UX).
///
/// El profesor puede cerrar sesión (botón en AppBar) y volver a la
/// pantalla de login. La sesión persiste si cierra la app.
class PantallaAulaProfesor extends StatefulWidget {
  const PantallaAulaProfesor({
    super.key,
    required this.clienteCompanion,
    required this.repoCuentaProfesor,
    required this.repoAulaProfesor,
  });

  final companion.ClienteCompanion clienteCompanion;
  final RepositorioCuentaBackend repoCuentaProfesor;
  final RepositorioAulaProfesorContrato repoAulaProfesor;

  @override
  State<PantallaAulaProfesor> createState() => _EstadoPantallaAulaProfesor();
}

class _EstadoPantallaAulaProfesor extends State<PantallaAulaProfesor> {
  /// `null` mientras se carga el classroom_id activo. `0` significa
  /// "no hay aula" (no la `null` para distinguir del cargando inicial).
  int? _classroomId;
  bool _cargandoInicial = true;
  bool _crearEnVuelo = false;
  Future<companion.AgregadosAula>? _futureAgregados;
  String? _mensajeError;

  // Inputs del formulario de creación.
  final TextEditingController _controladorNombre = TextEditingController();
  final Set<String> _juegosSeleccionados = <String>{};
  static const _juegosCatalogados = <String, String>{
    'el-cuaderno': 'El Cuaderno',
    'uno-roto': 'Uno Roto',
    'las-versiones': 'Las Versiones',
  };

  @override
  void initState() {
    super.initState();
    _cargarAulaPersistida();
  }

  @override
  void dispose() {
    _controladorNombre.dispose();
    super.dispose();
  }

  Future<void> _cargarAulaPersistida() async {
    final id = await widget.repoAulaProfesor.cargar();
    if (!mounted) return;
    setState(() {
      _classroomId = id ?? 0;
      _cargandoInicial = false;
      if (id != null) {
        _futureAgregados = _pedirAgregados(id);
      }
    });
  }

  Future<companion.AgregadosAula> _pedirAgregados(int classroomId) async {
    final token = await widget.repoCuentaProfesor.cargarToken();
    if (token == null || token.isEmpty) {
      throw const ExcepcionApi(
        codigo: 401,
        mensaje: 'Sesión del profesor no encontrada.',
      );
    }
    return widget.clienteCompanion.obtenerAgregadosAula(
      token: token,
      classroomId: classroomId,
    );
  }

  Future<void> _crearAula() async {
    final nombre = _controladorNombre.text.trim();
    if (nombre.isEmpty || _juegosSeleccionados.isEmpty) {
      setState(() => _mensajeError =
          'Pon un nombre al aula y elige al menos un juego.');
      return;
    }
    setState(() {
      _crearEnVuelo = true;
      _mensajeError = null;
    });
    try {
      final token = await widget.repoCuentaProfesor.cargarToken();
      if (token == null || token.isEmpty) {
        throw const ExcepcionApi(
          codigo: 401,
          mensaje: 'Sesión del profesor no encontrada.',
        );
      }
      final aula = await widget.clienteCompanion.crearAula(
        token: token,
        name: nombre,
        gameIds: _juegosSeleccionados.toList(growable: false),
      );
      await widget.repoAulaProfesor.guardar(aula.classroomId);
      if (!mounted) return;
      setState(() {
        _classroomId = aula.classroomId;
        _crearEnVuelo = false;
        _futureAgregados = _pedirAgregados(aula.classroomId);
      });
    } on ExcepcionApi catch (e) {
      if (!mounted) return;
      setState(() {
        _crearEnVuelo = false;
        _mensajeError = _mensajeParaCrearError(e);
      });
    }
  }

  String _mensajeParaCrearError(ExcepcionApi e) {
    switch (e.codigo) {
      case 401:
        return 'La sesión ha caducado. Vuelve a iniciar sesión.';
      case 422:
        return 'Algún dato del aula no es válido. Revisa el nombre y los juegos seleccionados.';
      case 503:
        return 'No se pudo generar un código único para el aula. Inténtalo en un momento.';
      default:
        return 'No se ha podido crear el aula (HTTP ${e.codigo}).';
    }
  }

  Future<void> _cerrarSesion() async {
    await widget.repoCuentaProfesor.cerrarSesion();
    await widget.repoAulaProfesor.borrar();
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => PantallaLoginProfesor(
          clienteAuth: companion.ClienteAuthAdulto(
            urlBase: widget.clienteCompanion.urlBase,
          ),
          clienteCompanion: widget.clienteCompanion,
          repoCuentaProfesor: widget.repoCuentaProfesor,
          repoAulaProfesor: widget.repoAulaProfesor,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final esquema = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aula'),
        actions: [
          IconButton(
            tooltip: 'cerrar sesión',
            onPressed: _cerrarSesion,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: SafeArea(
        child: _cargandoInicial
            ? const Center(child: CircularProgressIndicator.adaptive())
            : _classroomId == 0
                ? _formularioCrearAula(esquema)
                : _vistaAulaActiva(esquema),
      ),
    );
  }

  Widget _formularioCrearAula(ColorScheme esquema) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Crea tu primera aula',
            style: TipografiaCuaderno.serif(
              color: esquema.onSurface,
              tamano: TipografiaCuaderno.tamano17,
              peso: TipografiaCuaderno.pesoMedio,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'El servidor te dará un código que repartes a la clase. Cada '
            'niño se une desde su cuaderno con ese código.',
            style: TipografiaCuaderno.serif(
              color: PaletaCuaderno.tintaTenue,
              tamano: TipografiaCuaderno.tamano13,
              altoLinea: 1.45,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _controladorNombre,
            enabled: !_crearEnVuelo,
            decoration: const InputDecoration(
              labelText: 'nombre del aula',
              hintText: 'p. ej., 6º A · curso 2026/27',
              border: OutlineInputBorder(),
              isDense: true,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Juegos del aula',
            style: TipografiaCuaderno.sans(
              color: esquema.tertiary,
              tamano: TipografiaCuaderno.tamano12,
              peso: TipografiaCuaderno.pesoMedio,
            ),
          ),
          const SizedBox(height: 4),
          for (final entrada in _juegosCatalogados.entries)
            CheckboxListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: Text(entrada.value),
              value: _juegosSeleccionados.contains(entrada.key),
              onChanged: _crearEnVuelo
                  ? null
                  : (marcado) => setState(() {
                        if (marcado == true) {
                          _juegosSeleccionados.add(entrada.key);
                        } else {
                          _juegosSeleccionados.remove(entrada.key);
                        }
                      }),
            ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _crearEnVuelo ? null : _crearAula,
            child: Text(_crearEnVuelo ? 'Creando…' : 'Crear aula'),
          ),
          if (_mensajeError != null) ...[
            const SizedBox(height: 12),
            Text(
              _mensajeError!,
              style: TipografiaCuaderno.serif(
                color: PaletaCuaderno.sienaTenue,
                tamano: TipografiaCuaderno.tamano12,
                altoLinea: 1.45,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _vistaAulaActiva(ColorScheme esquema) {
    return FutureBuilder<companion.AgregadosAula>(
      future: _futureAgregados,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }
        if (snapshot.hasError) {
          return _mensajeKMinimoOError(snapshot.error!, esquema);
        }
        final agregados = snapshot.data!;
        return ListView(
          padding: const EdgeInsets.all(24),
          children: [
            _CabeceraAula(agregados: agregados, esquema: esquema),
            const SizedBox(height: 24),
            for (final entrada in agregados.aggregates.entries) ...[
              _BloqueAgregadoJuego(
                gameId: entrada.key,
                payload: entrada.value,
                esquema: esquema,
              ),
              const SizedBox(height: 16),
            ],
          ],
        );
      },
    );
  }

  Widget _mensajeKMinimoOError(Object error, ColorScheme esquema) {
    String texto;
    if (error is ExcepcionApi && error.codigo == 403) {
      // Reportamos el k mínimo del servidor sin culpar — la voz "no
      // humillar" pide que la presencia o ausencia de niños no se
      // haga visible nominalmente.
      texto =
          'El aula necesita al menos cinco niños con datos esta semana '
          'para que se vean los agregados. Eso protege la privacidad de '
          'la clase. Vuelve cuando haya más actividad.';
    } else if (error is ExcepcionApi && error.codigo == 401) {
      texto = 'La sesión ha caducado. Cierra sesión y vuelve a entrar.';
    } else {
      texto = 'No se han podido cargar los agregados ($error).';
    }
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            texto,
            style: TipografiaCuaderno.serif(
              color: esquema.onSurface,
              tamano: TipografiaCuaderno.tamano14,
              altoLinea: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}

class _CabeceraAula extends StatelessWidget {
  const _CabeceraAula({required this.agregados, required this.esquema});

  final companion.AgregadosAula agregados;
  final ColorScheme esquema;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          agregados.name,
          style: TipografiaCuaderno.serif(
            color: esquema.onSurface,
            tamano: TipografiaCuaderno.tamano17,
            peso: TipografiaCuaderno.pesoMedio,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Código del aula: ${agregados.code}',
          style: TipografiaCuaderno.sans(
            color: PaletaCuaderno.tintaTenue,
            tamano: TipografiaCuaderno.tamano12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Semana ${agregados.isoWeek} · '
          '${agregados.reportingCount} de ${agregados.memberCount} con datos',
          style: TipografiaCuaderno.sans(
            color: PaletaCuaderno.tintaTenue,
            tamano: TipografiaCuaderno.tamano12,
          ),
        ),
      ],
    );
  }
}

class _BloqueAgregadoJuego extends StatelessWidget {
  const _BloqueAgregadoJuego({
    required this.gameId,
    required this.payload,
    required this.esquema,
  });

  final String gameId;
  final Map<String, dynamic> payload;
  final ColorScheme esquema;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: esquema.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              gameId,
              style: TipografiaCuaderno.sans(
                color: esquema.tertiary,
                tamano: TipografiaCuaderno.tamano12,
                peso: TipografiaCuaderno.pesoMedio,
              ),
            ),
            const SizedBox(height: 8),
            for (final entrada in payload.entries)
              _LineaPayload(clave: entrada.key, valor: entrada.value),
          ],
        ),
      ),
    );
  }
}

class _LineaPayload extends StatelessWidget {
  const _LineaPayload({required this.clave, required this.valor});

  final String clave;
  final Object? valor;

  @override
  Widget build(BuildContext context) {
    if (valor is int || valor is double) {
      return Padding(
        padding: const EdgeInsets.only(top: 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              clave,
              style: TipografiaCuaderno.serif(
                color: PaletaCuaderno.tinta,
                tamano: TipografiaCuaderno.tamano13,
              ),
            ),
            Text(
              valor.toString(),
              style: TipografiaCuaderno.serif(
                color: PaletaCuaderno.tinta,
                tamano: TipografiaCuaderno.tamano13,
                peso: TipografiaCuaderno.pesoMedio,
              ),
            ),
          ],
        ),
      );
    }
    if (valor is Map) {
      return Padding(
        padding: const EdgeInsets.only(top: 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              clave,
              style: TipografiaCuaderno.serif(
                color: PaletaCuaderno.tintaTenue,
                tamano: TipografiaCuaderno.tamano12,
              ),
            ),
            for (final entrada in (valor as Map).entries)
              Padding(
                padding: const EdgeInsets.only(left: 12, top: 1),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        entrada.key.toString(),
                        style: TipografiaCuaderno.serif(
                          color: PaletaCuaderno.tinta,
                          tamano: TipografiaCuaderno.tamano12,
                        ),
                      ),
                    ),
                    Text(
                      entrada.value.toString(),
                      style: TipografiaCuaderno.serif(
                        color: PaletaCuaderno.tinta,
                        tamano: TipografiaCuaderno.tamano12,
                        peso: TipografiaCuaderno.pesoMedio,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
