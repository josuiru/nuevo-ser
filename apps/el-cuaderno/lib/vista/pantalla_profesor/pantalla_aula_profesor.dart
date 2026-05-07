import 'package:flutter/material.dart';
import 'package:nuevo_ser_companion/nuevo_ser_companion.dart' as companion;
import 'package:nuevo_ser_core/nuevo_ser_core.dart';

import '../../nucleo/i18n/generado/textos_app.dart';
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
    final textos = TextosApp.of(context);
    final nombre = _controladorNombre.text.trim();
    if (nombre.isEmpty || _juegosSeleccionados.isEmpty) {
      setState(() => _mensajeError = textos.aulaProfesorErrorVacio);
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
        _mensajeError = _mensajeParaCrearError(e, textos);
      });
    }
  }

  String _mensajeParaCrearError(ExcepcionApi e, TextosApp textos) {
    switch (e.codigo) {
      case 401:
        return textos.aulaProfesorErrorSesionCaducadaCrear;
      case 422:
        return textos.aulaProfesorErrorDatosInvalidos;
      case 503:
        return textos.aulaProfesorErrorCodigoUnico;
      default:
        return textos.aulaProfesorErrorGenerico(e.codigo);
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
    final textos = TextosApp.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(textos.aulaProfesorTitulo),
        actions: [
          IconButton(
            tooltip: textos.aulaProfesorTooltipCerrarSesion,
            onPressed: _cerrarSesion,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: SafeArea(
        child: _cargandoInicial
            ? const Center(child: CircularProgressIndicator.adaptive())
            : _classroomId == 0
                ? _formularioCrearAula(esquema, textos)
                : _vistaAulaActiva(esquema, textos),
      ),
    );
  }

  Widget _formularioCrearAula(ColorScheme esquema, TextosApp textos) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            textos.aulaProfesorCrearTitulo,
            style: TipografiaCuaderno.serif(
              color: esquema.onSurface,
              tamano: TipografiaCuaderno.tamano17,
              peso: TipografiaCuaderno.pesoMedio,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            textos.aulaProfesorCrearIntro,
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
            decoration: InputDecoration(
              labelText: textos.aulaProfesorPlaceholderNombre,
              hintText: textos.aulaProfesorHintNombre,
              border: const OutlineInputBorder(),
              isDense: true,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            textos.aulaProfesorJuegosCabecera,
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
            child: Text(_crearEnVuelo
                ? textos.aulaProfesorCreando
                : textos.aulaProfesorBotonCrear),
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

  Widget _vistaAulaActiva(ColorScheme esquema, TextosApp textos) {
    return FutureBuilder<companion.AgregadosAula>(
      future: _futureAgregados,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }
        if (snapshot.hasError) {
          return _mensajeKMinimoOError(snapshot.error!, esquema, textos);
        }
        final agregados = snapshot.data!;
        return ListView(
          padding: const EdgeInsets.all(24),
          children: [
            _CabeceraAula(
              agregados: agregados,
              esquema: esquema,
              textos: textos,
            ),
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

  Widget _mensajeKMinimoOError(
    Object error,
    ColorScheme esquema,
    TextosApp textos,
  ) {
    String texto;
    if (error is ExcepcionApi && error.codigo == 403) {
      // Reportamos el k mínimo del servidor sin culpar — la voz "no
      // humillar" pide que la presencia o ausencia de niños no se
      // haga visible nominalmente.
      texto = textos.aulaProfesorMensajeKMinimo;
    } else if (error is ExcepcionApi && error.codigo == 401) {
      texto = textos.aulaProfesorErrorSesionCaducadaCargar;
    } else {
      texto = textos.aulaProfesorErrorCargarAgregados(error.toString());
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
  const _CabeceraAula({
    required this.agregados,
    required this.esquema,
    required this.textos,
  });

  final companion.AgregadosAula agregados;
  final ColorScheme esquema;
  final TextosApp textos;

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
          textos.aulaProfesorCodigoEtiqueta(agregados.code),
          style: TipografiaCuaderno.sans(
            color: PaletaCuaderno.tintaTenue,
            tamano: TipografiaCuaderno.tamano12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          textos.aulaProfesorSemanaResumen(
            agregados.isoWeek,
            agregados.reportingCount,
            agregados.memberCount,
          ),
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
