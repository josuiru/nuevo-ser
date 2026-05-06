import 'package:flutter/material.dart';

import '../datos/repositorio_reconstruccion.dart';
import '../dominio/brecha.dart';
import '../dominio/calibracion.dart';
import '../nucleo/paleta_archivo.dart';

/// Pantalla jugable de la Fase 5 — Concilio. La Cronista presenta su
/// versión y lee el feedback del oficio sobre su trabajo. La fase es
/// de **lectura y cierre**: el botón "CERRAR LA BRECHA" sigue siendo
/// el del pie de pantalla (global de `PantallaBrecha`), no propio de
/// esta fase, por eso NO está en `_faseTienePantallaPropia`.
///
/// El feedback es **automatizado y no punitivo** (doc 14 §1, §3 y
/// guion 1.1.6 referenciado en BLOQUEOS-PENDIENTES.md sección
/// "Mecánicas pedagógicas F6.5"): no se gana ni se pierde la Brecha,
/// se aprende. Tres rangos de cierre: muy bien calibrada (>= 0.85),
/// buen oficio (>= 0.5), aprender del desencaje (< 0.5).
class FaseConcilio extends StatefulWidget {
  /// Brecha cuya Fase 5 se está mostrando.
  final Brecha brecha;

  /// Repositorio de la reconstrucción (lectura). Inyectable para
  /// tests.
  final RepositorioReconstruccion repoReconstruccion;

  /// Evaluador de calibración. Inyectable para tests aunque por
  /// ahora no tiene estado configurable.
  final EvaluadorCalibracion evaluador;

  const FaseConcilio({
    super.key,
    required this.brecha,
    required this.repoReconstruccion,
    this.evaluador = const EvaluadorCalibracion(),
  });

  @override
  State<FaseConcilio> createState() => _FaseConcilioState();
}

class _FaseConcilioState extends State<FaseConcilio> {
  Map<String, NivelConfianza> _declaraciones = const {};
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarReconstruccion();
  }

  Future<void> _cargarReconstruccion() async {
    final mapa = await widget.repoReconstruccion.cargar(widget.brecha.id);
    if (!mounted) return;
    setState(() {
      _declaraciones = mapa;
      _cargando = false;
    });
  }

  @override
  Widget build(BuildContext contexto) {
    if (_cargando) return const SizedBox.expand();
    final declaradas = widget.brecha.afirmacionesCanonicas
        .where((afirmacion) => _declaraciones.containsKey(afirmacion.id))
        .toList(growable: false);
    final resultado = widget.evaluador.evaluar(
      afirmacionesDeclaradas: declaradas,
      nivelDeclaradoPorId: _declaraciones,
    );
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _IntroFase5(),
          const SizedBox(height: 16),
          if (declaradas.isEmpty)
            const _ConcilioVacio()
          else ...[
            _Resumen(resultado: resultado),
            const SizedBox(height: 16),
            _CierreSegunCalibracion(scoreMedio: resultado.scoreMedio),
            const SizedBox(height: 16),
            for (int indice = 0; indice < declaradas.length; indice++) ...[
              if (indice > 0) const SizedBox(height: 8),
              _LineaCalibracion(
                afirmacion: declaradas[indice],
                nivelDeclarado: _declaraciones[declaradas[indice].id]!,
              ),
            ],
          ],
        ],
      ),
    );
  }
}

class _IntroFase5 extends StatelessWidget {
  const _IntroFase5();

  @override
  Widget build(BuildContext contexto) {
    return Text(
      'Tu versión, en el Concilio. Esto no premia tener razón. Premia '
      'haber juzgado bien con lo disponible.',
      style: TextStyle(
        fontSize: 14,
        color: PaletaArchivo.textoPrincipal.withOpacity(0.9),
        height: 1.55,
        fontWeight: FontWeight.w300,
      ),
    );
  }
}

class _ConcilioVacio extends StatelessWidget {
  const _ConcilioVacio();

  @override
  Widget build(BuildContext contexto) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Text(
        'No has declarado ninguna afirmación. Vuelve a la fase de '
        'Reconstrucción y construye una versión — la Cronista que no '
        'sostiene nada no está en el oficio.',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 13,
          color: PaletaArchivo.textoTenue.withOpacity(0.85),
          fontStyle: FontStyle.italic,
          height: 1.5,
        ),
      ),
    );
  }
}

class _Resumen extends StatelessWidget {
  final ResultadoCalibracionBrecha resultado;

  const _Resumen({required this.resultado});

  @override
  Widget build(BuildContext contexto) {
    final porcentaje = (resultado.scoreMedio * 100).round();
    return Container(
      decoration: BoxDecoration(
        color: PaletaArchivo.fondoMedio.withOpacity(0.5),
        border: Border.all(
          color: PaletaArchivo.ambarLacre.withOpacity(0.45),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'TU CALIBRACIÓN',
            style: TextStyle(
              fontSize: 10,
              letterSpacing: 3,
              color: PaletaArchivo.ambarLacre,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Sostuviste ${resultado.totalAfirmaciones} afirmaciones. '
            'Acertaste el nivel de confianza en ${resultado.aciertos} '
            'de ${resultado.totalAfirmaciones}.',
            style: TextStyle(
              fontSize: 14,
              color: PaletaArchivo.textoPrincipal.withOpacity(0.92),
              height: 1.5,
              fontWeight: FontWeight.w300,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Score de calibración: $porcentaje / 100',
            style: const TextStyle(
              fontSize: 11,
              letterSpacing: 2,
              color: PaletaArchivo.ambarLacre,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _CierreSegunCalibracion extends StatelessWidget {
  final double scoreMedio;

  const _CierreSegunCalibracion({required this.scoreMedio});

  @override
  Widget build(BuildContext contexto) {
    final mensaje = _mensajeSegunRango(scoreMedio);
    return Container(
      decoration: BoxDecoration(
        color: PaletaArchivo.fondoProfundo.withOpacity(0.55),
        border: Border(
          left: BorderSide(
            color: PaletaArchivo.ambarLacre.withOpacity(0.7),
            width: 2,
          ),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      child: Text(
        mensaje,
        style: TextStyle(
          fontSize: 14,
          color: PaletaArchivo.textoPrincipal.withOpacity(0.92),
          height: 1.55,
          fontWeight: FontWeight.w300,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }

  String _mensajeSegunRango(double score) {
    if (score >= 0.85) {
      return 'Buen oficio, Cronista. Has calibrado con honestidad: '
          'cuando tenías evidencia firme dijiste Sólido, y cuando no '
          'la tenías, no inflaste. Eso es lo difícil.';
    }
    if (score >= 0.5) {
      return 'Vas en el oficio. Algunos niveles los has acertado, otros '
          'no — y mirar dónde te has desencajado es lo que cierra la '
          'Brecha. No premia tener razón, premia volver al detalle.';
    }
    return 'No has calibrado bien esta vez, y eso también es oficio. '
        'Lo importante no es haberlo acertado todo: es saber por qué '
        'pensabas Sólido cuando era Disputado. Vuelve sobre las '
        'fuentes que las anclan y mira qué has dado por hecho.';
  }
}

class _LineaCalibracion extends StatelessWidget {
  final AfirmacionCanonica afirmacion;
  final NivelConfianza nivelDeclarado;

  const _LineaCalibracion({
    required this.afirmacion,
    required this.nivelDeclarado,
  });

  @override
  Widget build(BuildContext contexto) {
    final acierta = nivelDeclarado == afirmacion.calibracionCorrecta;
    final colorAcento = acierta
        ? PaletaArchivo.ambarLacre
        : PaletaArchivo.tintaTenue.withOpacity(0.65);
    return Container(
      decoration: BoxDecoration(
        color: PaletaArchivo.fondoMedio.withOpacity(0.35),
        border: Border(
          left: BorderSide(color: colorAcento, width: 2),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            afirmacion.texto,
            style: TextStyle(
              fontSize: 13,
              color: PaletaArchivo.textoPrincipal.withOpacity(0.9),
              height: 1.45,
              fontWeight: FontWeight.w300,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _Etiqueta(
                titulo: 'Tú dijiste',
                valor: _nombreNivel(nivelDeclarado),
              ),
              const SizedBox(width: 16),
              _Etiqueta(
                titulo: 'El oficio dice',
                valor: _nombreNivel(afirmacion.calibracionCorrecta),
              ),
              const SizedBox(width: 12),
              Icon(
                acierta ? Icons.check_circle_outline : Icons.adjust,
                color: colorAcento,
                size: 16,
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _nombreNivel(NivelConfianza nivel) {
    switch (nivel) {
      case NivelConfianza.solido:
        return 'Sólido';
      case NivelConfianza.probable:
        return 'Probable';
      case NivelConfianza.disputado:
        return 'Disputado';
    }
  }
}

class _Etiqueta extends StatelessWidget {
  final String titulo;
  final String valor;

  const _Etiqueta({required this.titulo, required this.valor});

  @override
  Widget build(BuildContext contexto) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titulo.toUpperCase(),
          style: TextStyle(
            fontSize: 9,
            letterSpacing: 2,
            color: PaletaArchivo.textoTenue.withOpacity(0.85),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          valor,
          style: TextStyle(
            fontSize: 12,
            color: PaletaArchivo.textoPrincipal.withOpacity(0.95),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
