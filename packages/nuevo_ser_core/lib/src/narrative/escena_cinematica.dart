import 'ambiente_escena.dart';
import 'plano_escena.dart';

/// Una escena cinematográfica — secuencia ordenada de [PlanoEscena]
/// que el player recorre uno a uno. Al terminar, el orquestador del
/// juego marca [flagDeSalida] para que no vuelva a dispararse.
///
/// Es la unidad de narrativa compartida entre todos los juegos de la
/// Colección. Las escenas concretas (1.1 "El tejado" en Uno Roto, 1.0.1
/// "La evaluación" en Las Versiones) son instancias específicas; este
/// modelo es genérico.
class EscenaCinematica {
  /// Identificador estable estilo "1.1", "1.6", "3.9" — cada juego
  /// usa su propia convención.
  final String id;

  /// Nombre legible para debug (NO se muestra al jugador). Ej:
  /// "El tejado", "La evaluación".
  final String titulo;

  /// Lista ordenada de planos. Mínimo uno.
  final List<PlanoEscena> planos;

  /// Flag narrativo que se establece al terminar la escena. Ej:
  /// `escena_1_1_vista`, `evaluation_passed`. La persistencia concreta
  /// la decide cada juego.
  final String flagDeSalida;

  /// Flags narrativos que deben estar activos para que la escena pueda
  /// dispararse. Si vacío, la escena se dispara en cuanto el
  /// orquestador la considere.
  final Set<String> flagsRequeridos;

  /// Si `true`, al terminar la escena el orquestador NO intenta
  /// disparar otra escena en la misma sesión — devuelve al mapa o al
  /// flujo del jugador. Encarna el principio de cierre suave: "si
  /// necesitas irte, te vas".
  final bool esCierreAmable;

  /// Identificador opcional de un sonido catalogado que el player
  /// dispara al entrar en la escena. La capa sonora del juego decide
  /// cómo resolverlo. Si null, la escena no añade sonido propio.
  final String? sonidoDeEntrada;

  /// Identificador opcional de un loop musical que acompaña la escena
  /// entera hasta que se cierra (o hasta que otra escena la cambie).
  /// Diferente de [sonidoDeEntrada] que es un sample puntual.
  final String? loopDeFondo;

  /// Ambiente atmosférico — el `CustomPainter` o sistema de
  /// renderizado del juego sabe pintarlo. Por defecto neutro.
  final AmbienteEscenaContrato ambiente;

  const EscenaCinematica({
    required this.id,
    required this.titulo,
    required this.planos,
    required this.flagDeSalida,
    this.flagsRequeridos = const {},
    this.esCierreAmable = false,
    this.sonidoDeEntrada,
    this.loopDeFondo,
    this.ambiente = const AmbienteEscenaNeutro(),
  });
}
