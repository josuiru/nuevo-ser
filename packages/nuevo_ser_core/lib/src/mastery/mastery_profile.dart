import 'habilidad.dart';

/// Payload de un intento individual de la persona usuaria contra una
/// habilidad. Es la unidad mínima que el motor recibe; cada perfil de
/// medición decide qué hacer con ella.
///
/// `instante` lo inyecta el llamante (no se usa `DateTime.now()` dentro
/// del motor) para que los tests sean deterministas y para que la cola
/// offline pueda re-emitir intentos viejos sin distorsionar timestamps.
class SessionPayload {
  final bool acierto;

  /// Coeficiente 0.5..2.0 que pondera el peso del intento en la
  /// precisión agregada. Un puzzle más difícil pesa más cuando se
  /// acierta y más cuando se falla.
  final double dificultad;

  final int duracionSegundos;
  final DateTime instante;

  const SessionPayload({
    required this.acierto,
    required this.dificultad,
    required this.duracionSegundos,
    required this.instante,
  });
}

/// Resultado de la fase de cómputo de un perfil. Es el material que
/// `MasteryProfile.levelFromScore` usa para decidir el nivel; el motor
/// también lo proyecta al nuevo `EstadoHabilidad`.
class ScoreResult {
  final double precision;
  final double tiempoMedianoSeg;
  final int sesionesConsecutivasBuenas;
  final int totalExposiciones;
  final List<IntentoHabilidad> intentosRecientes;

  const ScoreResult({
    required this.precision,
    required this.tiempoMedianoSeg,
    required this.sesionesConsecutivasBuenas,
    required this.totalExposiciones,
    required this.intentosRecientes,
  });
}

/// Parámetros que ajustan el comportamiento de un perfil de medición
/// para una habilidad o juego concreto.
///
/// Los valores por defecto reflejan el modelo P1 actual de Uno Roto
/// (`docs/02 §16` y `docs/03 §8`). Las Versiones podrá pasar otra
/// configuración cuando arranque sus perfiles P2-P4.
class ProfileConfig {
  final double umbralPrecisionMaestria;
  final double umbralPrecisionCompetente;
  final double umbralPrecisionEnDesarrollo;
  final int exposicionesMinMaestria;
  final int sesionesConsecutivasMinMaestria;
  final int sesionesConsecutivasMinCompetente;
  final double precisionMinSesionBuena;
  final int gapHorasNuevaSesion;
  final int maxIntentosRecientes;

  const ProfileConfig({
    required this.umbralPrecisionMaestria,
    required this.umbralPrecisionCompetente,
    required this.umbralPrecisionEnDesarrollo,
    required this.exposicionesMinMaestria,
    required this.sesionesConsecutivasMinMaestria,
    required this.sesionesConsecutivasMinCompetente,
    required this.precisionMinSesionBuena,
    required this.gapHorasNuevaSesion,
    required this.maxIntentosRecientes,
  });

  /// Configuración por defecto del perfil P1 calcada de Uno Roto MVP.
  /// Cualquier juego que no proporcione su `ProfileConfig` recibirá
  /// estos valores.
  static const ProfileConfig defaultP1 = ProfileConfig(
    umbralPrecisionMaestria: 0.90,
    umbralPrecisionCompetente: 0.75,
    umbralPrecisionEnDesarrollo: 0.50,
    exposicionesMinMaestria: 20,
    sesionesConsecutivasMinMaestria: 5,
    sesionesConsecutivasMinCompetente: 3,
    precisionMinSesionBuena: 0.75,
    gapHorasNuevaSesion: 4,
    maxIntentosRecientes: 20,
  );
}

/// Patrón Strategy de la doc §6.1 — un perfil define cómo se observa la
/// maestría sobre una habilidad. Los cuatro perfiles previstos:
///
/// - **P1 Precisión**: el clásico — proporción de aciertos ponderada
///   por dificultad sobre los últimos N intentos. Usado por todas las
///   habilidades de Uno Roto MVP.
/// - **P2 Detección**: mide si la persona sabe distinguir un caso del
///   contraejemplo (p. ej. en Las Versiones, "qué versión es la
///   contemporánea, qué versión es la post-hoc").
/// - **P3 Construcción**: mide si la persona produce respuestas
///   correctas a problema abierto (no basta elegir).
/// - **P4 Calibración**: mide si la persona estima bien su propio nivel
///   antes de intentarlo (metacognición).
///
/// Cada perfil tiene `compute` (cálculo agregado) y `levelFromScore`
/// (mapeo a `NivelMaestria`). Mantenerlos separados permite a P3/P4
/// reusar el cálculo de P1 cuando convenga, y deja una superficie
/// estrecha para tests de paridad Dart/PHP (doc §6.2).
abstract class MasteryProfile {
  const MasteryProfile();

  /// Identificador estable del perfil en `skills.measurement_profile`.
  String get id;

  /// Calcula los agregados a partir del intento nuevo y el estado
  /// previo persistido. La implementación es pura (no toca tiempo real
  /// ni almacenamiento).
  ScoreResult compute({
    required SessionPayload payload,
    required EstadoHabilidad previo,
    required ProfileConfig config,
  });

  /// Decide el nivel de maestría a partir del score y el nivel previo.
  /// Recibe el nivel previo para que un perfil pueda evitar oscilación
  /// (p. ej. no bajar de competente si el siguiente intento bajó la
  /// precisión por casualidad estadística).
  NivelMaestria levelFromScore({
    required ScoreResult score,
    required ProfileConfig config,
    required NivelMaestria nivelPrevio,
  });
}
