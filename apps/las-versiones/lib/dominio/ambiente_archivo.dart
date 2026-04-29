import 'package:nuevo_ser_core/nuevo_ser_core.dart';

/// Ambiente atmosférico de una escena de Las Versiones. Implementa el
/// contrato genérico [AmbienteEscenaContrato] del core para que el
/// player de cinemáticas lo transporte sin conocer su pintura — el
/// `CustomPainter` específico del juego lo recibe y decide cómo
/// renderizarlo.
///
/// **Provisional**: por ahora cada ambiente lleva sólo una etiqueta
/// estable (`identificador`) que el pintor puede consumir como `switch`.
/// Cuando se aborde la fase visual del juego (doc 11 + 13), esta clase
/// crecerá con campos pictóricos concretos (densidad de polvo, tono de
/// luz, intensidad de viento, ruido de papel…) — el patrón ya está
/// validado por `AmbienteCielo` en Uno Roto.
///
/// Los ambientes catalogados aquí cubren los espacios principales
/// previstos por la worldbuilding (doc 05): la sala de evaluación
/// donde Maren defiende sus reconstrucciones, el Archivo nocturno
/// donde trabaja con manuscritos, una sierra al amanecer (paisaje
/// recurrente del valle), el interior de una cueva (Brecha
/// arqueológica de la capa Cueva-Pirineo). Los juegos pueden añadir
/// más instancias `static const` sin tocar este archivo.
class AmbienteArchivo implements AmbienteEscenaContrato {
  /// Etiqueta estable que el pintor del juego usará como discriminador.
  /// Castellano, snake_case (`sala_evaluacion`, `archivo_nocturno`).
  final String identificador;

  const AmbienteArchivo._(this.identificador);

  /// Sala de evaluación del Archivo — mesa larga, luz cenital,
  /// sillas. El espacio del Concilio y de la primera entrevista de
  /// Maren con Isaura (doc 07 §1.0).
  static const AmbienteArchivo salaEvaluacion =
      AmbienteArchivo._('sala_evaluacion');

  /// Archivo nocturno — estanterías, polvo, velas. Donde Maren pasa
  /// las horas con manuscritos cuando nadie la mira.
  static const AmbienteArchivo archivoNocturno =
      AmbienteArchivo._('archivo_nocturno');

  /// Sierra al amanecer — paisaje exterior del valle, luz horizontal,
  /// niebla de mañana. Recurrente en transiciones entre Brechas.
  static const AmbienteArchivo sierraAmanecer =
      AmbienteArchivo._('sierra_amanecer');

  /// Interior de cueva — primera Brecha del MVP (capa Cueva-Pirineo,
  /// ya validada por el comité asesor histórico). Roca, humedad,
  /// hueco de luz lejano.
  static const AmbienteArchivo cuevaInterior =
      AmbienteArchivo._('cueva_interior');
}
