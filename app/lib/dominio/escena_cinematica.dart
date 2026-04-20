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

  const EscenaCinematica({
    required this.id,
    required this.titulo,
    required this.planos,
    required this.flagDeSalida,
    this.flagsRequeridos = const {},
  });
}
