import 'package:flutter/material.dart';

import '../datos/catalogo_habilidades.dart';
import '../datos/cliente_api.dart';
import '../datos/config_api.dart';
import '../datos/repositorio_progreso.dart';
import '../dominio/habilidad.dart';
import '../dominio/ritmo_juego.dart';
import '../nucleo/paleta.dart';
import 'pantalla_perfiles.dart';

/// Panel que lista las 66 habilidades del mapa pedagógico y muestra
/// para cada una el nivel actual del niño y su precisión. Accesible
/// desde el mapa con long-press. Futuro dashboard de padres (doc 03 §7)
/// en forma rudimentaria.
class PantallaHabilidades extends StatefulWidget {
  final RepositorioProgreso repositorio;

  /// Callback que el orquestador proporciona para reiniciar la app
  /// completa con el perfil activo. Se invoca tras elegir perfil en el
  /// selector abierto desde esta pantalla.
  final VoidCallback? alReiniciarConPerfilActivo;

  const PantallaHabilidades({
    super.key,
    required this.repositorio,
    this.alReiniciarConPerfilActivo,
  });

  @override
  State<PantallaHabilidades> createState() => _PantallaHabilidadesState();
}

class _PantallaHabilidadesState extends State<PantallaHabilidades> {
  CatalogoHabilidades? _catalogo;
  Map<String, EstadoHabilidad> _estados = {};
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    final catalogo = await CatalogoHabilidades.cargar();
    final estados = <String, EstadoHabilidad>{};
    for (final h in catalogo.habilidades.values) {
      final estado = await widget.repositorio.cargarEstadoHabilidad(
        h.identificador,
      );
      if (estado != null) estados[h.identificador] = estado;
    }
    if (!mounted) return;
    setState(() {
      _catalogo = catalogo;
      _estados = estados;
      _cargando = false;
    });
  }

  @override
  Widget build(BuildContext contexto) {
    return Scaffold(
      backgroundColor: PaletaNeon.fondoProfundo,
      appBar: AppBar(
        backgroundColor: PaletaNeon.fondoMedio,
        title: const Text(
          'habilidades',
          style: TextStyle(
            color: PaletaNeon.textoPrincipal,
            fontSize: 16,
            letterSpacing: 4,
            fontWeight: FontWeight.w300,
          ),
        ),
        iconTheme: const IconThemeData(color: PaletaNeon.textoTenue),
        actions: [
          IconButton(
            tooltip: 'Cambiar de perfil',
            onPressed: _abrirPantallaPerfiles,
            icon: Icon(
              Icons.switch_account,
              color: PaletaNeon.textoTenue.withOpacity(0.7),
            ),
          ),
          IconButton(
            tooltip: 'Cambiar ritmo del juego',
            onPressed: _abrirDialogoRitmo,
            icon: Icon(
              Icons.speed,
              color: PaletaNeon.textoTenue.withOpacity(0.7),
            ),
          ),
          IconButton(
            tooltip: 'Probar sync con backend (debug)',
            onPressed: _probarSync,
            icon: Icon(
              Icons.cloud_upload,
              color: PaletaNeon.textoTenue.withOpacity(0.7),
            ),
          ),
          IconButton(
            tooltip: 'Reiniciar progreso (debug)',
            onPressed: _confirmarYReiniciar,
            icon: Icon(
              Icons.refresh,
              color: PaletaNeon.textoTenue.withOpacity(0.7),
            ),
          ),
        ],
      ),
      body: _cargando
          ? const Center(
              child: CircularProgressIndicator(color: PaletaNeon.azulNeon),
            )
          : _listaPorDominio(),
    );
  }

  Future<void> _abrirPantallaPerfiles() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PantallaPerfiles(
          repositorio: widget.repositorio,
          // Al elegir perfil delegamos al orquestador el reinicio
          // completo del flujo, para que la siguiente pantalla
          // corresponda al progreso del perfil recién activado.
          alPerfilSeleccionado: () {
            widget.alReiniciarConPerfilActivo?.call();
          },
        ),
      ),
    );
  }

  Future<void> _abrirDialogoRitmo() async {
    final actual = await widget.repositorio.cargarRitmo();
    if (!mounted) return;
    final elegido = await showDialog<RitmoJuego>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: PaletaNeon.fondoMedio,
        title: const Text(
          'Ritmo del juego',
          style: TextStyle(color: PaletaNeon.textoPrincipal),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final ritmo in RitmoJuego.values)
              RadioListTile<RitmoJuego>(
                value: ritmo,
                groupValue: actual,
                activeColor: PaletaNeon.violetaNeon,
                title: Text(
                  ritmo.nombreVisible,
                  style: const TextStyle(
                    color: PaletaNeon.textoPrincipal,
                    fontSize: 14,
                  ),
                ),
                subtitle: Text(
                  ritmo.descripcionCorta,
                  style: TextStyle(
                    color: PaletaNeon.textoTenue.withOpacity(0.75),
                    fontSize: 11,
                  ),
                ),
                onChanged: (v) => Navigator.of(ctx).pop(v),
              ),
          ],
        ),
      ),
    );
    if (elegido == null || elegido == actual) return;
    await widget.repositorio.guardarRitmo(elegido);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: PaletaNeon.fondoMedio,
        duration: const Duration(seconds: 3),
        content: Text(
          'Ritmo "${elegido.nombreVisible}". Se aplicará en la próxima escena.',
          style: const TextStyle(color: PaletaNeon.textoPrincipal),
        ),
      ),
    );
  }

  Future<void> _probarSync() async {
    final api = ClienteApi(
      urlBase: ConfigApi.urlBaseLocal,
      hostOverride: ConfigApi.hostLocal,
    );
    final mensajero = ScaffoldMessenger.of(context);
    try {
      mensajero.showSnackBar(
        const SnackBar(
          backgroundColor: PaletaNeon.fondoMedio,
          content: Text(
            'Registrando usuario de prueba…',
            style: TextStyle(color: PaletaNeon.textoTenue),
          ),
        ),
      );
      final sufijo = DateTime.now().millisecondsSinceEpoch;
      final nombreJugador =
          await widget.repositorio.cargarNombreJugador() ?? 'Test';
      final auth = await api.registrar(
        email: 'sync-$sufijo@test.local',
        password: 'clave-prueba-${sufijo % 10000}',
        nombreTutor: 'Tutor Prueba',
        nombreNino: nombreJugador,
      );

      final progreso =
          await widget.repositorio.exportarProgresoParaSync();
      final resp = await api.sincronizar(
        token: auth.token,
        progreso: progreso,
        habilidades: const [],
      );
      final devuelto = resp['progreso'] as Map<String, dynamic>?;
      final esquirlas = (devuelto?['esquirlas_total'] as num?)?.toInt();
      final flagsServidor = devuelto?['flags'] as Map? ?? const {};

      if (!mounted) return;
      mensajero.hideCurrentSnackBar();
      mensajero.showSnackBar(
        SnackBar(
          backgroundColor: PaletaNeon.fondoMedio,
          duration: const Duration(seconds: 8),
          content: Text(
            'Sync OK. Niño #${auth.ninoId}. '
            'Esquirlas ${esquirlas ?? 0}. '
            '${flagsServidor.length} flags en el servidor.',
            style: const TextStyle(color: PaletaNeon.exitoSuave),
          ),
        ),
      );
    } on ExcepcionApi catch (e) {
      if (!mounted) return;
      mensajero.hideCurrentSnackBar();
      mensajero.showSnackBar(
        SnackBar(
          backgroundColor: PaletaNeon.fondoMedio,
          duration: const Duration(seconds: 8),
          content: Text(
            'API ${e.codigo}: ${e.mensaje}',
            style: const TextStyle(color: PaletaNeon.rosaAcento),
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      mensajero.hideCurrentSnackBar();
      mensajero.showSnackBar(
        SnackBar(
          backgroundColor: PaletaNeon.fondoMedio,
          duration: const Duration(seconds: 8),
          content: Text(
            'Red: $e',
            style: const TextStyle(color: PaletaNeon.rosaAcento),
          ),
        ),
      );
    } finally {
      api.cerrar();
    }
  }

  Future<void> _confirmarYReiniciar() async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (contextoDialog) => AlertDialog(
        backgroundColor: PaletaNeon.fondoMedio,
        title: const Text(
          'Reiniciar progreso',
          style: TextStyle(color: PaletaNeon.textoPrincipal),
        ),
        content: const Text(
          'Borra escenas vistas, habilidades, esquirlas y rango. '
          'La próxima vez que abras la app, empezarás desde la apertura.',
          style: TextStyle(color: PaletaNeon.textoTenue),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(contextoDialog).pop(false),
            child: const Text(
              'cancelar',
              style: TextStyle(color: PaletaNeon.textoTenue, letterSpacing: 2),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(contextoDialog).pop(true),
            child: const Text(
              'reiniciar',
              style: TextStyle(
                color: PaletaNeon.rosaAcento,
                letterSpacing: 2,
              ),
            ),
          ),
        ],
      ),
    );
    if (confirmar != true) return;
    await widget.repositorio.reiniciar();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: PaletaNeon.fondoMedio,
        content: Text(
          'Progreso reiniciado. Cierra la app y vuélvela a abrir.',
          style: TextStyle(color: PaletaNeon.textoPrincipal),
        ),
        duration: Duration(seconds: 5),
      ),
    );
  }

  Widget _listaPorDominio() {
    final catalogo = _catalogo!;
    final dominiosOrdenados = catalogo.dominios.entries.toList();
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: dominiosOrdenados.length,
      itemBuilder: (_, indice) {
        final entrada = dominiosOrdenados[indice];
        final habilidadesDelDominio = catalogo
            .habilidades.values
            .where((h) => h.dominio == entrada.key)
            .toList();
        return _BloqueDominio(
          codigo: entrada.key,
          nombre: entrada.value,
          habilidades: habilidadesDelDominio,
          estados: _estados,
        );
      },
    );
  }
}

class _BloqueDominio extends StatelessWidget {
  final String codigo;
  final String nombre;
  final List<Habilidad> habilidades;
  final Map<String, EstadoHabilidad> estados;

  const _BloqueDominio({
    required this.codigo,
    required this.nombre,
    required this.habilidades,
    required this.estados,
  });

  @override
  Widget build(BuildContext contexto) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              '$codigo · ${nombre.toUpperCase()}',
              style: const TextStyle(
                color: PaletaNeon.azulNeon,
                fontSize: 12,
                letterSpacing: 3,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          ...habilidades.map(
            (habilidad) => _FilaHabilidad(
              habilidad: habilidad,
              estado: estados[habilidad.identificador],
            ),
          ),
        ],
      ),
    );
  }
}

class _FilaHabilidad extends StatelessWidget {
  final Habilidad habilidad;
  final EstadoHabilidad? estado;

  const _FilaHabilidad({required this.habilidad, this.estado});

  Color _colorPorNivel(NivelMaestria nivel) {
    switch (nivel) {
      case NivelMaestria.inexplorada:
        return PaletaNeon.textoTenue.withOpacity(0.3);
      case NivelMaestria.introducida:
        return PaletaNeon.rosaAcento.withOpacity(0.7);
      case NivelMaestria.enDesarrollo:
        return const Color(0xFFFFA552);
      case NivelMaestria.competente:
        return PaletaNeon.azulNeon;
      case NivelMaestria.maestria:
        return PaletaNeon.exitoSuave;
    }
  }

  @override
  Widget build(BuildContext contexto) {
    final nivel = estado?.nivel ?? NivelMaestria.inexplorada;
    final precision = estado?.precision ?? 0;
    final exposiciones = estado?.totalExposiciones ?? 0;
    final color = _colorPorNivel(nivel);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 32,
            color: color,
            margin: const EdgeInsets.only(right: 10),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text(
                      habilidad.identificador,
                      style: const TextStyle(
                        color: PaletaNeon.textoTenue,
                        fontSize: 11,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        habilidad.nombre,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: PaletaNeon.textoPrincipal,
                          fontSize: 13,
                          height: 1.2,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  '${nivel.nombreCastellano} '
                  '· precisión ${(precision * 100).toStringAsFixed(0)}% '
                  '· $exposiciones intentos',
                  style: TextStyle(
                    color: color,
                    fontSize: 11,
                    letterSpacing: 0.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
