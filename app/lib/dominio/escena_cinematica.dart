import 'plano_escena.dart';

/// Una escena es una secuencia ordenada de planos. El player recorre
/// los planos uno a uno. Al terminar, el orquestador marca [flagDeSalida]
/// para que no se reproduzca de nuevo en futuras aperturas.
class EscenaCinematica {
  /// Identificador estable estilo "1.1", "1.6", "3.9".
  final String id;

  /// Nombre legible para debug — ej: "La llegada".
  final String titulo;

  /// Lista ordenada de planos.
  final List<PlanoEscena> planos;

  /// Flag narrativo que se establece al terminar la escena. Ej:
  /// "escena_1_1_vista". Se guarda en el repositorio.
  final String flagDeSalida;

  const EscenaCinematica({
    required this.id,
    required this.titulo,
    required this.planos,
    required this.flagDeSalida,
  });
}
