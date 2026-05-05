import 'package:flutter/material.dart';

import '../../dominio/atlas.dart';
import '../../dominio/observacion.dart';
import '../../dominio/repositorio_local.dart';
import '../../nucleo/i18n/generado/textos_app.dart';
import '../tema/colores.dart';
import '../tema/tipografia.dart';

/// Pantalla "Tu atlas". Atlas personal del niño — colección de
/// identificaciones que han aparecido en su cuaderno.
///
/// **Anatomía**:
/// - Cabecera serif con el título y un subtítulo amable que
///   declara la pedagogía: "no es un trofeo. Es lo que has visto."
/// - Sección "Tus primeras veces" — listado cronológico inverso.
///   Cada tarjeta abre la observación original al pulsarla.
/// - Sección "Lo que has visto" — agrupador con conteos. Cada fila
///   abre la observación primera de su identificación.
///
/// **Estado vacío**: si todavía no hay identificaciones, una
/// microcopia amable explica que el atlas se llena solo cuando el
/// niño escribe en *"crees que es"* — sin presionar.
class PantallaAtlas extends StatefulWidget {
  const PantallaAtlas({
    super.key,
    required this.repositorio,
    this.alAbrirDetalle,
  });

  final RepositorioLocal repositorio;

  /// Closure que abre la pantalla de detalle de una observación.
  /// Si es null, las tarjetas no son pulsables — modo lectura para
  /// tests aislados.
  final void Function(Observacion observacion)? alAbrirDetalle;

  @override
  State<PantallaAtlas> createState() => _EstadoPantallaAtlas();
}

class _EstadoPantallaAtlas extends State<PantallaAtlas> {
  Atlas? _atlas;
  Map<String, Observacion> _porId = const {};
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    final observaciones =
        await widget.repositorio.obtenerObservaciones(limite: 5000);
    if (!mounted) return;
    setState(() {
      _atlas = Atlas.calcular(observaciones);
      _porId = {for (final obs in observaciones) obs.id: obs};
      _cargando = false;
    });
  }

  Future<void> _abrirObservacion(String id) async {
    final cb = widget.alAbrirDetalle;
    final obs = _porId[id];
    if (cb == null || obs == null) return;
    cb(obs);
  }

  @override
  Widget build(BuildContext context) {
    final textos = TextosApp.of(context);
    final esquema = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(textos.atlasTitulo)),
      body: SafeArea(
        child: _cargando
            ? const Center(child: CircularProgressIndicator.adaptive())
            : _atlas == null || _atlas!.estaVacio
                ? _AtlasVacio(textos: textos, esquema: esquema)
                : _AtlasLleno(
                    atlas: _atlas!,
                    textos: textos,
                    esquema: esquema,
                    alAbrir: _abrirObservacion,
                  ),
      ),
    );
  }
}

class _AtlasVacio extends StatelessWidget {
  const _AtlasVacio({required this.textos, required this.esquema});

  final TextosApp textos;
  final ColorScheme esquema;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            textos.atlasVacioCabecera,
            style: TipografiaCuaderno.serif(
              color: esquema.onSurface,
              tamano: TipografiaCuaderno.tamano16,
              peso: TipografiaCuaderno.pesoMedio,
              altoLinea: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            textos.atlasVacioCuerpo,
            style: TipografiaCuaderno.serif(
              color: PaletaCuaderno.tintaTenue,
              tamano: TipografiaCuaderno.tamano14,
              altoLinea: 1.55,
            ),
          ),
        ],
      ),
    );
  }
}

class _AtlasLleno extends StatelessWidget {
  const _AtlasLleno({
    required this.atlas,
    required this.textos,
    required this.esquema,
    required this.alAbrir,
  });

  final Atlas atlas;
  final TextosApp textos;
  final ColorScheme esquema;
  final void Function(String idObservacion) alAbrir;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
      children: [
        Text(
          textos.atlasSubtitulo,
          style: TipografiaCuaderno.serif(
            color: PaletaCuaderno.tintaTenue,
            tamano: TipografiaCuaderno.tamano13,
            altoLinea: 1.5,
          ).copyWith(fontStyle: FontStyle.italic),
        ),
        const SizedBox(height: 24),
        if (atlas.primerasVeces.isNotEmpty) ...[
          _Cabecera(textos.atlasSeccionPrimerasVeces, esquema: esquema),
          const SizedBox(height: 12),
          for (final entrada in atlas.primerasVeces) ...[
            _TarjetaPrimeraVez(
              entrada: entrada,
              alPulsar: () => alAbrir(entrada.idObservacionPrimera),
            ),
            const SizedBox(height: 8),
          ],
          const SizedBox(height: 16),
        ],
        if (atlas.loQueHasVisto.isNotEmpty) ...[
          _Cabecera(textos.atlasSeccionLoQueHasVisto, esquema: esquema),
          const SizedBox(height: 12),
          for (final entrada in atlas.loQueHasVisto) ...[
            _FilaLoQueHasVisto(
              entrada: entrada,
              textos: textos,
              alPulsar: () => alAbrir(entrada.idObservacionPrimera),
            ),
          ],
        ],
      ],
    );
  }
}

class _Cabecera extends StatelessWidget {
  const _Cabecera(this.texto, {required this.esquema});

  final String texto;
  final ColorScheme esquema;

  @override
  Widget build(BuildContext context) {
    return Text(
      texto,
      style: TipografiaCuaderno.sans(
        color: esquema.tertiary,
        tamano: TipografiaCuaderno.tamano12,
        peso: TipografiaCuaderno.pesoMedio,
      ),
    );
  }
}

class _TarjetaPrimeraVez extends StatelessWidget {
  const _TarjetaPrimeraVez({required this.entrada, required this.alPulsar});

  final EntradaAtlas entrada;
  final VoidCallback alPulsar;

  @override
  Widget build(BuildContext context) {
    final esquema = Theme.of(context).colorScheme;
    return Material(
      color: esquema.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: esquema.outline, width: 0.5),
      ),
      child: InkWell(
        onTap: alPulsar,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                entrada.creesQueEs,
                style: TipografiaCuaderno.serif(
                  color: esquema.onSurface,
                  tamano: TipografiaCuaderno.tamano14,
                  peso: TipografiaCuaderno.pesoMedio,
                  altoLinea: 1.35,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _formatearFecha(entrada.primeraVez),
                style: TipografiaCuaderno.sans(
                  color: esquema.tertiary,
                  tamano: TipografiaCuaderno.tamano11,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FilaLoQueHasVisto extends StatelessWidget {
  const _FilaLoQueHasVisto({
    required this.entrada,
    required this.textos,
    required this.alPulsar,
  });

  final EntradaAtlas entrada;
  final TextosApp textos;
  final VoidCallback alPulsar;

  @override
  Widget build(BuildContext context) {
    final esquema = Theme.of(context).colorScheme;
    return InkWell(
      onTap: alPulsar,
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Expanded(
              child: Text(
                entrada.creesQueEs,
                style: TipografiaCuaderno.serif(
                  color: esquema.onSurface,
                  tamano: TipografiaCuaderno.tamano14,
                  altoLinea: 1.35,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              entrada.conteo == 1
                  ? textos.atlasConteoSingular
                  : textos.atlasConteoPlural(entrada.conteo),
              style: TipografiaCuaderno.sans(
                color: esquema.tertiary,
                tamano: TipografiaCuaderno.tamano12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _formatearFecha(DateTime fecha) {
  final dia = fecha.day.toString().padLeft(2, '0');
  final mes = fecha.month.toString().padLeft(2, '0');
  return '$dia/$mes/${fecha.year}';
}
