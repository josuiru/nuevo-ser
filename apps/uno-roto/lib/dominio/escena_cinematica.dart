import 'ambiente_cielo.dart';
import 'plano_escena.dart';

/// Una escena es una secuencia ordenada de planos. El player recorre
/// los planos uno a uno. Al terminar, el orquestador marca [flagDeSalida]
/// para que no se reproduzca de nuevo en futuras aperturas.
class EscenaCinematica {
  /// Identificador estable estilo "1.1", "1.6", "3.9".
  final String id;

  /// Nombre legible para debug — ej: "El tejado".
  final String titulo;

  /// Lista ordenada de planos.
  final List<PlanoEscena> planos;

  /// Flag narrativo que se establece al terminar la escena. Ej:
  /// "escena_1_1_vista". Se guarda en el repositorio.
  final String flagDeSalida;

  /// Flags narrativos que deben estar activos para que la escena pueda
  /// dispararse. La escena 1.1 no requiere nada (se dispara al inicio);
  /// la 1.3 requiere que exista previamente la sesión de combate inicial
  /// (doc 07 §1.3 "activa tras 1.2").
  final Set<String> flagsRequeridos;

  /// Si es `true`, al terminar la escena el orquestador NO intenta
  /// disparar la siguiente escena encadenada en la misma sesión — va
  /// directamente al mapa. Esto respeta el principio del cierre suave
  /// (doc 01 "si necesitas irte, te vas") y la nota del doc 07
  /// "no cargar arco 2 en la misma sesión que cierra arco 1".
  final bool esCierreAmable;

  /// Identificador opcional de un sonido catalogado que el player debe
  /// disparar al entrar en la escena (doc 12 §Momentos sonoros únicos).
  /// Ejemplos: "motivo_sora" en 1.1/2.14/4.13, "motivo_montana" en
  /// 1.1/1.14/4.14, "musica_ceremonia" en 1.13/4.10, "narrativo_silbido_zafran"
  /// en 2.10/2.12. Si es `null`, la escena no añade sonido propio.
  final String? sonidoDeEntrada;

  /// Identificador opcional de un loop musical que acompañará la
  /// escena entera hasta que se cierre (o hasta que otra la cambie).
  /// Diferente de [sonidoDeEntrada], que es un sample puntual.
  final String? loopDeFondo;

  /// Ambiente atmosférico del cielo. Las variantes de entrenamiento
  /// (1.8a-e) lo usan para que el niño reconozca cada noche por su
  /// cielo. El resto de escenas usa [AmbienteCielo.neutro].
  final AmbienteCielo ambiente;

  const EscenaCinematica({
    required this.id,
    required this.titulo,
    required this.planos,
    required this.flagDeSalida,
    this.flagsRequeridos = const {},
    this.esCierreAmable = false,
    this.sonidoDeEntrada,
    this.loopDeFondo,
    this.ambiente = AmbienteCielo.neutro,
  });
}
