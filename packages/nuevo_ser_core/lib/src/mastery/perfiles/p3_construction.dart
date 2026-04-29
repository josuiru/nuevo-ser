import '../habilidad.dart';
import '../mastery_profile.dart';

/// **P3 Construcción** — stub.
///
/// Mide si la persona produce una respuesta correcta a problema abierto
/// (no basta elegir entre opciones). Caso típico: pedir que escriba la
/// versión propia de un relato, justifique una operación con sus
/// palabras, o componga la próxima estrofa de un poema (El Cuaderno).
///
/// El cómputo previsto necesita un evaluador externo (rúbrica humana
/// asistida por IA) y por tanto carga asíncrona; el `compute` síncrono
/// del patrón se mantiene devolviendo un score parcial mientras la
/// evaluación profunda se resuelve en background.
///
/// Sin implementar. Cualquier llamada lanza `UnimplementedError`.
class P3Construction extends MasteryProfile {
  const P3Construction();

  @override
  String get id => 'P3';

  @override
  ScoreResult compute({
    required SessionPayload payload,
    required EstadoHabilidad previo,
    required ProfileConfig config,
  }) {
    throw UnimplementedError(
      'P3Construction.compute() pendiente de implementación. '
      'Requiere flujo de evaluación de respuestas abiertas — diseño '
      'todavía abierto. Mientras tanto, no marques habilidades como P3.',
    );
  }

  @override
  NivelMaestria levelFromScore({
    required ScoreResult score,
    required ProfileConfig config,
    required NivelMaestria nivelPrevio,
  }) {
    throw UnimplementedError('P3Construction.levelFromScore() pendiente.');
  }
}
