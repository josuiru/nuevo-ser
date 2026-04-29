import '../habilidad.dart';
import '../mastery_profile.dart';

/// **P2 Detección** — stub.
///
/// Mide si la persona distingue casos correctos del contraejemplo
/// emparejado: clasificación de pares (esto sí / esto no), reconocer
/// la versión del relato que está sesgada vs neutra (Las Versiones),
/// detectar la operación correcta cuando se ofrece la incorrecta como
/// trampa.
///
/// La diferencia con P1 es que el peso de los falsos positivos es
/// asimétrico — fallar en "esto no es" suele ser más informativo que
/// fallar en "esto sí". El cómputo previsto agrega d-prime / sensibilidad
/// (teoría de detección de señales) en vez de precisión simple.
///
/// Sin implementar hasta que Las Versiones lo necesite. Cualquier
/// llamada lanza `UnimplementedError` para que un cableado prematuro
/// rompa visiblemente en lugar de devolver basura silenciosa.
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
    throw UnimplementedError(
      'P2Detection.compute() pendiente de implementación. '
      'Lo necesitará Las Versiones cuando arranque su catálogo de pares '
      'narrativos. Mientras tanto, declara las habilidades como P1.',
    );
  }

  @override
  NivelMaestria levelFromScore({
    required ScoreResult score,
    required ProfileConfig config,
    required NivelMaestria nivelPrevio,
  }) {
    throw UnimplementedError('P2Detection.levelFromScore() pendiente.');
  }
}
