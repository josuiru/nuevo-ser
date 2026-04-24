import 'package:flutter/material.dart';

import '../datos/repositorio_progreso.dart';
import '../nucleo/paleta.dart';
import '../sonido/capa_audio.dart';
import '../sonido/servicio_sonoro.dart';

/// Ajustes sonoros por perfil (doc 12 §Accesibilidad). Control
/// independiente de las cuatro capas + switch de modo sin sonido.
/// Los cambios se aplican en vivo y se persisten en el perfil activo.
class PantallaAjustesSonido extends StatefulWidget {
  final RepositorioProgreso repositorio;

  const PantallaAjustesSonido({super.key, required this.repositorio});

  @override
  State<PantallaAjustesSonido> createState() => _PantallaAjustesSonidoState();
}

class _PantallaAjustesSonidoState extends State<PantallaAjustesSonido> {
  final Map<CapaAudio, int> _volumenes = {};
  bool _modoSilencio = false;
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    // Aseguramos que el motor está activo — si no, sincronizar nada
    // sirve de poco.
    await ServicioSonoro.instancia.inicializar(widget.repositorio);
    for (final capa in CapaAudio.values) {
      _volumenes[capa] = ServicioSonoro.instancia.volumenDeCapa(capa);
    }
    _modoSilencio = ServicioSonoro.instancia.modoSilencio;
    if (!mounted) return;
    setState(() => _cargando = false);
  }

  Future<void> _alCambiarVolumen(CapaAudio capa, double valor) async {
    final entero = valor.round();
    setState(() => _volumenes[capa] = entero);
    await ServicioSonoro.instancia.fijarVolumenDeCapa(
      capa,
      entero,
      widget.repositorio,
    );
  }

  Future<void> _alCambiarModoSilencio(bool silencio) async {
    setState(() => _modoSilencio = silencio);
    await ServicioSonoro.instancia.fijarModoSilencio(
      silencio,
      widget.repositorio,
    );
  }

  @override
  Widget build(BuildContext contexto) {
    return Scaffold(
      backgroundColor: PaletaNeon.fondoProfundo,
      appBar: AppBar(
        backgroundColor: PaletaNeon.fondoMedio,
        title: const Text(
          'sonido',
          style: TextStyle(
            color: PaletaNeon.textoPrincipal,
            fontSize: 16,
            letterSpacing: 4,
            fontWeight: FontWeight.w300,
          ),
        ),
        iconTheme: const IconThemeData(color: PaletaNeon.textoTenue),
      ),
      body: _cargando
          ? const Center(
              child: CircularProgressIndicator(color: PaletaNeon.azulNeon),
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
              children: [
                _ModoSilencioTile(
                  activo: _modoSilencio,
                  alCambiar: _alCambiarModoSilencio,
                ),
                const SizedBox(height: 24),
                Text(
                  'VOLUMEN POR CAPA',
                  style: TextStyle(
                    color: PaletaNeon.textoTenue.withOpacity(0.7),
                    fontSize: 11,
                    letterSpacing: 3,
                  ),
                ),
                const SizedBox(height: 12),
                for (final capa in CapaAudio.values)
                  _SliderCapa(
                    capa: capa,
                    valor: _volumenes[capa] ??
                        capa.volumenPredeterminado,
                    habilitado: !_modoSilencio,
                    alCambiar: (v) => _alCambiarVolumen(capa, v),
                  ),
                const SizedBox(height: 24),
                const _NotaAccesibilidad(),
              ],
            ),
    );
  }
}

class _ModoSilencioTile extends StatelessWidget {
  final bool activo;
  final ValueChanged<bool> alCambiar;

  const _ModoSilencioTile({required this.activo, required this.alCambiar});

  @override
  Widget build(BuildContext contexto) {
    return Container(
      decoration: BoxDecoration(
        color: PaletaNeon.fondoMedio.withOpacity(0.6),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: activo
              ? PaletaNeon.azulNeon.withOpacity(0.7)
              : PaletaNeon.violetaBase.withOpacity(0.5),
        ),
      ),
      child: SwitchListTile(
        value: activo,
        onChanged: alCambiar,
        activeColor: PaletaNeon.azulNeon,
        title: const Text(
          'Modo sin sonido',
          style: TextStyle(
            color: PaletaNeon.textoPrincipal,
            fontSize: 14,
            letterSpacing: 0.6,
          ),
        ),
        subtitle: Text(
          'el juego es completamente jugable en silencio',
          style: TextStyle(
            color: PaletaNeon.textoTenue.withOpacity(0.8),
            fontSize: 11,
          ),
        ),
      ),
    );
  }
}

class _SliderCapa extends StatelessWidget {
  final CapaAudio capa;
  final int valor;
  final bool habilitado;
  final ValueChanged<double> alCambiar;

  const _SliderCapa({
    required this.capa,
    required this.valor,
    required this.habilitado,
    required this.alCambiar,
  });

  String _descripcionCapa(CapaAudio capa) {
    switch (capa) {
      case CapaAudio.ambient:
        return 'viento, agua, ruido rosa del mundo';
      case CapaAudio.musica:
        return 'loops de distrito y de combate';
      case CapaAudio.efectos:
        return 'taps, aciertos, errores';
      case CapaAudio.narrativos:
        return 'motivos y efectos únicos';
    }
  }

  @override
  Widget build(BuildContext contexto) {
    return Opacity(
      opacity: habilitado ? 1.0 : 0.45,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  capa.nombreVisible,
                  style: const TextStyle(
                    color: PaletaNeon.textoPrincipal,
                    fontSize: 13,
                    letterSpacing: 1.0,
                  ),
                ),
                const Spacer(),
                Text(
                  '$valor%',
                  style: TextStyle(
                    color: PaletaNeon.textoTenue.withOpacity(0.75),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            Text(
              _descripcionCapa(capa),
              style: TextStyle(
                color: PaletaNeon.textoTenue.withOpacity(0.6),
                fontSize: 10,
                letterSpacing: 0.4,
                fontStyle: FontStyle.italic,
              ),
            ),
            SliderTheme(
              data: SliderTheme.of(contexto).copyWith(
                activeTrackColor: PaletaNeon.violetaNeon,
                inactiveTrackColor:
                    PaletaNeon.violetaBase.withOpacity(0.3),
                thumbColor: PaletaNeon.azulNeon,
                overlayColor: PaletaNeon.violetaNeon.withOpacity(0.2),
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
      ),
    );
  }
}

class _NotaAccesibilidad extends StatelessWidget {
  const _NotaAccesibilidad();

  @override
  Widget build(BuildContext contexto) {
    return Text(
      'Los ajustes se guardan por perfil. Cada niño que juegue con '
      'su perfil tendrá su propia configuración de volúmenes.',
      style: TextStyle(
        color: PaletaNeon.textoTenue.withOpacity(0.6),
        fontSize: 11,
        height: 1.4,
        fontStyle: FontStyle.italic,
      ),
    );
  }
}
