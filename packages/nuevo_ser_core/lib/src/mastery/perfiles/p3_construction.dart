import '../habilidad.dart';
import '../mastery_profile.dart';

/// **P3 Construcción** — perfil de respuesta abierta evaluada por
/// rúbrica compuesta de cuatro componentes (doc 02 §6.1).
///
/// Mide la calidad de una respuesta producida por la persona (no
/// elegida entre opciones): la Cronista declara un texto, el evaluador
/// — humano + IA asistencial — lo puntúa en cuatro componentes 0..1 y
/// el motor agrega.
///
/// **Pesos canónicos** (doc 02 §6.1, configurables por habilidad
/// vía un `ProfileConfig` específico cuando una habilidad lo necesite —
/// por ahora viven hardcoded para mantener simétrica la fixture
/// Dart/PHP):
/// - 0.35 anclaje (¿la afirmación está respaldada por evidencia?)
/// - 0.25 calibración (¿el nivel de confianza declarado es apropiado?)
/// - 0.25 completud (¿la respuesta cubre todo lo que debía?)
/// - 0.15 ausencia de falacias (¿hay razonamiento defectuoso?)
///
/// El `SessionPayload` debe llevar `componentesRubrica` con las cuatro
/// claves `a`, `c`, `p`, `f` (no `null`); si llegan `null` el intento
/// se ignora para el cómputo pero se registra (caso defensivo). Las
/// componentes se clipean a [0, 1] antes de promediar.
///
/// La métrica final se devuelve en `ScoreResult.precision` para reusar
/// el campo. Los umbrales (`ProfileConfig.umbralPrecision*`) se
/// reinterpretan como puntuación rúbrica. Defaults: ver
/// `ProfileConfig.defaultP3`.
class P3Construction extends MasteryProfile {
  const P3Construction();

  @override
  String get id => 'P3';

  /// Pesos canónicos del doc 02 §6.1.
  static const double pesoAnclaje = 0.35;
  static const double pesoCalibracion = 0.25;
  static const double pesoCompletud = 0.25;
  static const double pesoAusenciaFalacias = 0.15;

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
      componentesRubrica: payload.componentesRubrica,
    );
    final intentos = [...previo.intentosRecientes, intentoNuevo];
    if (intentos.length > config.maxIntentosRecientes) {
      intentos.removeRange(0, intentos.length - config.maxIntentosRecientes);
    }

    final puntuacionRubrica = _puntuacionRubricaPonderada(intentos);
    final tiempoMediano = _tiempoMediano(intentos);
    final totalExposiciones = previo.totalExposiciones + 1;
    final sesionesConsecutivas = _actualizarSesionesConsecutivas(
      previo: previo,
      ahora: payload.instante,
      puntuacionActual: puntuacionRubrica,
      config: config,
    );

    return ScoreResult(
      precision: puntuacionRubrica,
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

  /// Promedio ponderado por dificultad de la puntuación rúbrica de
  /// cada intento. Los intentos sin componentes (defensivo) se ignoran.
  double _puntuacionRubricaPonderada(List<IntentoHabilidad> intentos) {
    var numerador = 0.0;
    var denominador = 0.0;
    for (final intento in intentos) {
      final componentes = intento.componentesRubrica;
      if (componentes == null) continue;
      final puntuacion = _puntuacionPorIntento(componentes);
      numerador += puntuacion * intento.dificultad;
      denominador += intento.dificultad;
    }
    if (denominador <= 0) return 0;
    return numerador / denominador;
  }

  double _puntuacionPorIntento(Map<String, double> componentes) {
    final a = _clipUnitario(componentes['a'] ?? 0);
    final c = _clipUnitario(componentes['c'] ?? 0);
    final p = _clipUnitario(componentes['p'] ?? 0);
    final f = _clipUnitario(componentes['f'] ?? 0);
    return a * pesoAnclaje +
        c * pesoCalibracion +
        p * pesoCompletud +
        f * pesoAusenciaFalacias;
  }

  double _clipUnitario(double valor) {
    if (valor < 0) return 0;
    if (valor > 1) return 1;
    return valor;
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
    required double puntuacionActual,
    required ProfileConfig config,
  }) {
    final gapHoras = ahora.difference(previo.ultimaPractica).inHours;
    final esNuevaSesion = gapHoras >= config.gapHorasNuevaSesion;
    if (!esNuevaSesion) return previo.sesionesConsecutivasBuenas;
    if (puntuacionActual >= config.precisionMinSesionBuena) {
      return previo.sesionesConsecutivasBuenas + 1;
    }
    return 0;
  }
}
