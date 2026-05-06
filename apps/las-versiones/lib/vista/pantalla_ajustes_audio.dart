import 'package:flutter/material.dart';
import 'package:nuevo_ser_core/nuevo_ser_core.dart';

import '../nucleo/paleta_archivo.dart';

/// Ajustes de audio del perfil activo. Tres bloques:
/// - **Modo silencio** (switch global). Cuando está activo, todas las
///   capas se silencian sin perder los volúmenes guardados — al
///   apagar el silencio, los sliders vuelven al valor previo.
/// - **Volumen por capa** (4 sliders 0..100). Una fila por cada
///   `CapaAudio` del core: Ambiente / Música / Efectos / Narrativos.
/// - **Nota** — Las Versiones todavía no tiene assets sonoros
///   asignados al guion 12. Los sliders persisten la preferencia
///   por perfil para cuando entren los sonidos. Esto es deliberado
///   (igual que en uno-roto, donde el panel de ajustes existió
///   antes que algunos sonidos): así la Cronista puede dejar
///   configurado su gusto sin tener que esperar a que arranque la
///   primera Brecha sonora.
class PantallaAjustesAudio extends StatefulWidget {
  /// Repositorio del core que persiste las preferencias bajo
  /// `<ns>.perfil.<id>.audio.modo_silencio` y
  /// `<ns>.perfil.<id>.audio.volumen.<clave>`.
  final RepositorioPreferenciasAudio repoAudio;

  const PantallaAjustesAudio({super.key, required this.repoAudio});

  @override
  State<PantallaAjustesAudio> createState() => _PantallaAjustesAudioState();
}

class _PantallaAjustesAudioState extends State<PantallaAjustesAudio> {
  bool _cargando = true;
  bool _modoSilencio = false;
  late Map<CapaAudio, int> _volumenes;

  @override
  void initState() {
    super.initState();
    _volumenes = {
      for (final capa in CapaAudio.values) capa: capa.volumenPredeterminado,
    };
    _cargar();
  }

  Future<void> _cargar() async {
    final silencio = await widget.repoAudio.cargarModoSilencio();
    final volumenes = <CapaAudio, int>{};
    for (final capa in CapaAudio.values) {
      volumenes[capa] = await widget.repoAudio.cargarVolumenCapa(
        capa.clave,
        predeterminado: capa.volumenPredeterminado,
      );
    }
    if (!mounted) return;
    setState(() {
      _modoSilencio = silencio;
      _volumenes = volumenes;
      _cargando = false;
    });
  }

  Future<void> _cambiarSilencio(bool nuevo) async {
    setState(() => _modoSilencio = nuevo);
    await widget.repoAudio.guardarModoSilencio(nuevo);
  }

  Future<void> _cambiarVolumen(CapaAudio capa, double nuevo) async {
    final valor = nuevo.round();
    setState(() => _volumenes[capa] = valor);
    await widget.repoAudio.guardarVolumenCapa(capa.clave, valor);
  }

  @override
  Widget build(BuildContext contexto) {
    return Scaffold(
      backgroundColor: PaletaArchivo.fondoProfundo,
      appBar: AppBar(
        backgroundColor: PaletaArchivo.fondoProfundo,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: PaletaArchivo.textoPrincipal,
          onPressed: () => Navigator.of(contexto).maybePop(),
        ),
        title: Text(
          'AUDIO',
          style: TextStyle(
            fontSize: 13,
            letterSpacing: 5,
            color: PaletaArchivo.textoPrincipal,
            fontWeight: FontWeight.w400,
            shadows: [
              Shadow(
                color: PaletaArchivo.ambarLacre.withOpacity(0.35),
                blurRadius: 8,
              ),
            ],
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        top: false,
        child: _cargando
            ? const Center(
                child: CircularProgressIndicator(
                  color: PaletaArchivo.ambarLacre,
                ),
              )
            : ListView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      'Las Versiones todavía no tiene sonidos asignados a '
                      'todas las escenas. Los ajustes que dejes aquí se '
                      'guardan por perfil y se aplicarán cuando entren los '
                      'sonidos de las Brechas.',
                      style: TextStyle(
                        fontSize: 12,
                        color: PaletaArchivo.textoTenue.withOpacity(0.85),
                        height: 1.5,
                        fontWeight: FontWeight.w300,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                  _BloqueSilencio(
                    activo: _modoSilencio,
                    alCambiar: _cambiarSilencio,
                  ),
                  const SizedBox(height: 18),
                  const _Encabezado(texto: 'VOLUMEN POR CAPA'),
                  for (final capa in CapaAudio.values)
                    _FilaVolumen(
                      capa: capa,
                      valor: _volumenes[capa] ?? capa.volumenPredeterminado,
                      habilitado: !_modoSilencio,
                      alCambiar: (nuevo) => _cambiarVolumen(capa, nuevo),
                    ),
                ],
              ),
      ),
    );
  }
}

class _BloqueSilencio extends StatelessWidget {
  final bool activo;
  final ValueChanged<bool> alCambiar;

  const _BloqueSilencio({required this.activo, required this.alCambiar});

  @override
  Widget build(BuildContext contexto) {
    return Container(
      decoration: BoxDecoration(
        color: PaletaArchivo.fondoMedio.withOpacity(0.4),
        border: Border(
          left: BorderSide(
            color: activo
                ? PaletaArchivo.ambarLacre
                : PaletaArchivo.textoTenue.withOpacity(0.55),
            width: 2,
          ),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      child: Row(
        children: [
          Icon(
            activo ? Icons.volume_off_outlined : Icons.volume_up_outlined,
            color: activo
                ? PaletaArchivo.ambarLacre
                : PaletaArchivo.textoPrincipal.withOpacity(0.85),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activo ? 'Silencio activado' : 'Sonido activado',
                  style: TextStyle(
                    fontSize: 14,
                    color: PaletaArchivo.textoPrincipal.withOpacity(0.95),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  activo
                      ? 'Todas las capas silenciadas. Los volúmenes se '
                          'preservan para cuando vuelvas a activar.'
                      : 'Pulsa para silenciar todo sin perder los volúmenes '
                          'configurados.',
                  style: TextStyle(
                    fontSize: 11,
                    color: PaletaArchivo.textoTenue.withOpacity(0.85),
                    height: 1.4,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: activo,
            onChanged: alCambiar,
            activeColor: PaletaArchivo.ambarLacre,
            activeTrackColor: PaletaArchivo.ambarLacre.withOpacity(0.4),
          ),
        ],
      ),
    );
  }
}

class _FilaVolumen extends StatelessWidget {
  final CapaAudio capa;
  final int valor;
  final bool habilitado;
  final ValueChanged<double> alCambiar;

  const _FilaVolumen({
    required this.capa,
    required this.valor,
    required this.habilitado,
    required this.alCambiar,
  });

  @override
  Widget build(BuildContext contexto) {
    final colorTexto = habilitado
        ? PaletaArchivo.textoPrincipal.withOpacity(0.95)
        : PaletaArchivo.textoTenue.withOpacity(0.6);
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  capa.nombreVisible,
                  style: TextStyle(
                    fontSize: 13,
                    color: colorTexto,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Text(
                '$valor',
                style: TextStyle(
                  fontSize: 12,
                  letterSpacing: 1,
                  color: colorTexto,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(contexto).copyWith(
              activeTrackColor: PaletaArchivo.ambarLacre,
              inactiveTrackColor: PaletaArchivo.textoTenue.withOpacity(0.3),
              thumbColor: habilitado
                  ? PaletaArchivo.ambarLacre
                  : PaletaArchivo.textoTenue.withOpacity(0.5),
              overlayColor: PaletaArchivo.ambarLacre.withOpacity(0.2),
              trackHeight: 2,
            ),
            child: Slider(
              value: valor.toDouble(),
              min: 0,
              max: 100,
              divisions: 20,
              onChanged: habilitado ? alCambiar : null,
            ),
          ),
        ],
      ),
    );
  }
}

class _Encabezado extends StatelessWidget {
  final String texto;

  const _Encabezado({required this.texto});

  @override
  Widget build(BuildContext contexto) {
    return Padding(
      padding: const EdgeInsets.only(left: 2, bottom: 6),
      child: Text(
        texto,
        style: TextStyle(
          fontSize: 10,
          letterSpacing: 3,
          color: PaletaArchivo.ambarLacre,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
