import '../habilidad.dart';
import '../mastery_profile.dart';

/// **P1 Precisión** — perfil clásico de Uno Roto MVP.
///
/// Calcula la precisión ponderada por dificultad sobre los últimos N
/// intentos y deriva nivel por umbrales. Es la lógica que ya estaba en
/// `MotorMaestria` de Uno Roto, extraída literalmente para que el
/// refactor a Strategy no cambie comportamiento.
///
/// Sesión consecutiva buena: bloque de práctica con gap > 4 h y
/// precisión ≥ 0.75. Las umbrales y el gap viven en `ProfileConfig`
/// para que un juego pueda recalibrarlos sin reescribir el perfil.
class P1Precision extends MasteryProfile {
  const P1Precision();

  @override
  String get id => 'P1';

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
    );
    final intentos = [...previo.intentosRecientes, intentoNuevo];
    if (intentos.length > config.maxIntentosRecientes) {
      intentos.removeRange(0, intentos.length - config.maxIntentosRecientes);
    }

    final precision = _precisionPonderada(intentos);
    final tiempoMediano = _tiempoMediano(intentos);
    final totalExposiciones = previo.totalExposiciones + 1;
    final sesionesConsecutivas = _actualizarSesionesConsecutivas(
      previo: previo,
      ahora: payload.instante,
      precisionActual: precision,
      config: config,
    );

    return ScoreResult(
      precision: precision,
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
        score.sesionesConsecutivasBuenas >= config.sesionesConsecutivasMinMaestria) {
      return NivelMaestria.maestria;
    }
    if (score.precision >= config.umbralPrecisionCompetente &&
        score.sesionesConsecutivasBuenas >= config.sesionesConsecutivasMinCompetente) {
      return NivelMaestria.competente;
    }
    if (score.precision >= config.umbralPrecisionEnDesarrollo) {
      return NivelMaestria.enDesarrollo;
    }
    if (score.totalExposiciones > 0) return NivelMaestria.introducida;
    return NivelMaestria.inexplorada;
  }

  double _precisionPonderada(List<IntentoHabilidad> intentos) {
    if (intentos.isEmpty) return 0;
    var numerador = 0.0;
    var denominador = 0.0;
    for (final intento in intentos) {
      numerador += (intento.acierto ? 1 : 0) * intento.dificultad;
      denominador += intento.dificultad;
    }
    if (denominador <= 0) return 0;
    return numerador / denominador;
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
    required double precisionActual,
    required ProfileConfig config,
  }) {
    final gapHoras = ahora.difference(previo.ultimaPractica).inHours;
    final esNuevaSesion = gapHoras >= config.gapHorasNuevaSesion;
    if (!esNuevaSesion) return previo.sesionesConsecutivasBuenas;
    if (precisionActual >= config.precisionMinSesionBuena) {
      return previo.sesionesConsecutivasBuenas + 1;
    }
    return 0;
  }
}
