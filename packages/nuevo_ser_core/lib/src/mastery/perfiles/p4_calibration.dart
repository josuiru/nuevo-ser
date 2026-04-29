import '../habilidad.dart';
import '../mastery_profile.dart';

/// **P4 Calibración** — stub.
///
/// Mide la metacognición: si la persona estima bien su propio nivel
/// antes de intentarlo. Antes de cada bloque se le pide "¿qué crees
/// que vas a sacar?"; el score recompensa la coincidencia entre
/// estimación y resultado, no el rendimiento absoluto.
///
/// Es el perfil más experimental — sin literatura clara para 9-14 años
/// y sin urgencia de producto. Stubs por completitud del patrón.
///
/// Sin implementar. Cualquier llamada lanza `UnimplementedError`.
class P4Calibration extends MasteryProfile {
  const P4Calibration();

  @override
  String get id => 'P4';

  @override
  ScoreResult compute({
    required SessionPayload payload,
    required EstadoHabilidad previo,
    required ProfileConfig config,
  }) {
    throw UnimplementedError(
      'P4Calibration.compute() pendiente de implementación. '
      'Diseño aún abierto — no marques habilidades como P4 hasta que '
      'haya un caso de uso real.',
    );
  }

  @override
  NivelMaestria levelFromScore({
    required ScoreResult score,
    required ProfileConfig config,
    required NivelMaestria nivelPrevio,
  }) {
    throw UnimplementedError('P4Calibration.levelFromScore() pendiente.');
  }
}
