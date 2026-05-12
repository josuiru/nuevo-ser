import '../habilidad.dart';
import '../mastery_profile.dart';

/// **P2 Detección** — perfil de clasificación binaria con métrica F1.
///
/// Mide si la persona distingue casos positivos del contraejemplo
/// emparejado (clasificación esto-sí / esto-no). Las Versiones la usa
/// para HF.10 (detección de omisiones en una fuente: ¿la fuente A omite
/// al actor X? sí / no), entre otras habilidades del doc 02 que el
/// motor adaptativo despacha por `idPerfil = 'P2'`.
///
/// La diferencia con P1 es que el peso de los falsos positivos y
/// falsos negativos es asimétrico — fallar en "esto no es" suele ser
/// más informativo que fallar en "esto sí". F1 captura esa asimetría
/// promediando precisión (TP/(TP+FP)) y exhaustividad (TP/(TP+FN)) en
/// media armónica.
///
/// El `SessionPayload` debe llevar `senalEsperada` y `clasePredicha`
/// (no `null`); si llegan `null` el intento se ignora para el cómputo
/// pero se registra en `intentosRecientes` para preservar trazabilidad
/// (caso defensivo — call-sites correctos siempre los proveen).
///
/// Los umbrales (`ProfileConfig.umbralPrecision*`) se reinterpretan
/// como F1 — el struct se reusa por simplicidad. Defaults: ver
/// `ProfileConfig.defaultP2`.
class P2Detection extends MasteryProfile {
  const P2Detection();

  @override
  String get id => 'P2';

  @override
  ScoreResult compute({
    required SessionPayload payload,
    required EstadoHabilidad previo,
    required ProfileConfig config,
  }) {
    assert(payload.dificultad >= 0.5 && payload.dificultad <= 2.0);

    final intentoNuevo = IntentoHabilidad(
      instante: payload.instante,
      acierto: payload.acierto,
      dificultad: payload.dificultad,
      duracionSegundos: payload.duracionSegundos,
      senalEsperada: payload.senalEsperada,
      clasePredicha: payload.clasePredicha,
    );
    final intentos = [...previo.intentosRecientes, intentoNuevo];
    if (intentos.length > config.maxIntentosRecientes) {
      intentos.removeRange(0, intentos.length - config.maxIntentosRecientes);
    }

    final f1 = _f1Score(intentos);
    final tiempoMediano = _tiempoMediano(intentos);
    final totalExposiciones = previo.totalExposiciones + 1;
    final sesionesConsecutivas = _actualizarSesionesConsecutivas(
      previo: previo,
      ahora: payload.instante,
      f1Actual: f1,
      config: config,
    );

    return ScoreResult(
      precision: f1,
      tiempoMedianoSeg: tiempoMediano,
      sesionesConsecutivasBuenas: sesionesConsecutivas,
      totalExposiciones: totalExposiciones,
      intentosRecientes: intentos,
    );
  }

  @override
  NivelMaestria levelFromScore({
    required ScoreResult score,
    required ProfileConfig config,
    required NivelMaestria nivelPrevio,
  }) {
    if (score.precision >= config.umbralPrecisionMaestria &&
        score.totalExposiciones >= config.exposicionesMinMaestria &&
        score.sesionesConsecutivasBuenas >=
            config.sesionesConsecutivasMinMaestria) {
      return NivelMaestria.maestria;
    }
    if (score.precision >= config.umbralPrecisionCompetente &&
        score.sesionesConsecutivasBuenas >=
            config.sesionesConsecutivasMinCompetente) {
      return NivelMaestria.competente;
    }
    if (score.precision >= config.umbralPrecisionEnDesarrollo) {
      return NivelMaestria.enDesarrollo;
    }
    if (score.totalExposiciones > 0) return NivelMaestria.introducida;
    return NivelMaestria.inexplorada;
  }

  /// Calcula F1 sobre los intentos que tienen pareja senal/clase. F1=0
  /// cuando no hay positivos predichos o no hay positivos reales — es
  /// la convención convencional (no se imputa NaN porque rompería los
  /// umbrales y serializar nan/inf complica el JSON).
  double _f1Score(List<IntentoHabilidad> intentos) {
    var tp = 0.0;
    var fp = 0.0;
    var fn = 0.0;
    for (final intento in intentos) {
      final senal = intento.senalEsperada;
      final clase = intento.clasePredicha;
      if (senal == null || clase == null) continue;
      final peso = intento.dificultad;
      if (senal && clase) {
        tp += peso;
      } else if (!senal && clase) {
        fp += peso;
      } else if (senal && !clase) {
        fn += peso;
      }
      // !senal && !clase → TN (no contribuye a F1).
    }
    if (tp <= 0) return 0;
    final precision = tp / (tp + fp);
    final recall = tp / (tp + fn);
    if (precision + recall <= 0) return 0;
    return 2 * precision * recall / (precision + recall);
  }

  double _tiempoMediano(List<IntentoHabilidad> intentos) {
    if (intentos.isEmpty) return 0;
    final tiempos = intentos.map((i) => i.duracionSegundos).toList()..sort();
    final mitad = tiempos.length ~/ 2;
    if (tiempos.length.isOdd) return tiempos[mitad].toDouble();
    return (tiempos[mitad - 1] + tiempos[mitad]) / 2;
  }

  int _actualizarSesionesConsecutivas({
    required EstadoHabilidad previo,
    required DateTime ahora,
    required double f1Actual,
    required ProfileConfig config,
  }) {
    final gapHoras = ahora.difference(previo.ultimaPractica).inHours;
    final esNuevaSesion = gapHoras >= config.gapHorasNuevaSesion;
    if (!esNuevaSesion) return previo.sesionesConsecutivasBuenas;
    if (f1Actual >= config.precisionMinSesionBuena) {
      return previo.sesionesConsecutivasBuenas + 1;
    }
    return 0;
  }
}
