import 'voz_personaje.dart';

/// Una opción que aparece en un [PlanoEleccion]. La Cronista (o el
/// niño en Uno Roto) toca una. Puede tener una respuesta breve del
/// personaje y activar flags narrativos persistentes.
class OpcionEleccion {
  /// Texto tal como lo ve quien juega. Puede ir entre comillas cuando
  /// es habla literal ("Vengo a entrenar.") o ser descripción de
  /// actitud ("— quedarte callado —").
  final String textoJugador;

  /// Respuesta opcional del personaje tras la elección. Si es null la
  /// elección no produce respuesta y la escena avanza al siguiente
  /// plano directamente.
  final String? textoRespuesta;

  /// Voz que dice [textoRespuesta]. Si es null, se usa la voz que
  /// estaba haciendo la pregunta en el plano contenedor.
  final VozPersonajeContrato? vozRespuesta;

  /// Flags narrativos que se activan al elegir esta opción. Cada juego
  /// los persiste donde considere — típicamente bajo el namespace de
  /// flags del juego (`uroto.flag.<nombre>` en Uno Roto,
  /// `nuevoser.lasversiones.flag.<nombre>` en Las Versiones).
  final Set<String> flagsAEstablecer;

  const OpcionEleccion({
    required this.textoJugador,
    this.textoRespuesta,
    this.vozRespuesta,
    this.flagsAEstablecer = const {},
  });
}
