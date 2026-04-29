/// Un mosaico: trabajo final que el niño produce al cerrar un arco.
///
/// A diferencia de [EntradaCuaderno], el mosaico tiene `arcId` obligatorio
/// y `completedAt` (no `createdAt`) porque sólo se crea cuando ya está
/// terminado. `requiredAnchors`/`fulfilledAnchors` son ids de habilidades
/// (lista) o estructuras con metadatos por habilidad (objeto) — el cliente
/// elige el shape interno; el servidor sólo valida que sea una colección.
///
/// `id` y `completedAt` los rellena el servidor al crear.
class Mosaico {
  final int? id;
  final String gameId;
  final String arcId;
  final String format;
  final String title;
  final String contentRef;
  final Map<String, dynamic>? contentMeta;

  /// Habilidades o anclas requeridas por el arco. `List<String>` (ids
  /// sueltos), `List<Map>` (estructuras complejas) y `Map` (claves
  /// como ids) son todos shapes válidos.
  final Object? requiredAnchors;

  /// Habilidades o anclas efectivamente cubiertas por este mosaico.
  /// Mismo abanico de shapes que [requiredAnchors].
  final Object? fulfilledAnchors;

  /// Texto cualitativo opcional (p. ej. evaluación del tutor o
  /// comentario del profesor). El cuerpo libre del JSON se decide en la
  /// app; el servidor sólo valida que sea string si está presente.
  final String? qualitativeFeedback;

  final DateTime? completedAt;

  const Mosaico({
    this.id,
    required this.gameId,
    required this.arcId,
    this.format = '',
    required this.title,
    this.contentRef = '',
    this.contentMeta,
    this.requiredAnchors,
    this.fulfilledAnchors,
    this.qualitativeFeedback,
    this.completedAt,
  });

  /// Forma serializada que el cliente envía a `POST /companion/mosaicos`.
  /// Omite `id` y `completed_at` (los rellena el server) y los campos
  /// opcionales que sean null o vacíos.
  Map<String, dynamic> aJsonParaCrear() {
    return {
      'game_id': gameId,
      'arc_id': arcId,
      if (format.isNotEmpty) 'format': format,
      'title': title,
      if (contentRef.isNotEmpty) 'content_ref': contentRef,
      if (contentMeta != null) 'content_meta': contentMeta,
      if (requiredAnchors != null) 'required_anchors': requiredAnchors,
      if (fulfilledAnchors != null) 'fulfilled_anchors': fulfilledAnchors,
      if (qualitativeFeedback != null) 'qualitative_feedback': qualitativeFeedback,
    };
  }

  /// Construye un mosaico a partir de la respuesta 201 del servidor.
  /// El servidor devuelve el shape mínimo (`id`, `game_id`, `arc_id`,
  /// `format`, `title`, `content_ref`, `completed_at`); los campos
  /// opcionales (`content_meta`, `required_anchors`, `fulfilled_anchors`,
  /// `qualitative_feedback`) los preservamos del original que envió el
  /// cliente.
  factory Mosaico.desdeRespuestaCreacion(
    Map<String, dynamic> json, {
    Map<String, dynamic>? contentMetaOriginal,
    Object? requiredAnchorsOriginal,
    Object? fulfilledAnchorsOriginal,
    String? qualitativeFeedbackOriginal,
  }) {
    return Mosaico(
      id: (json['id'] as num).toInt(),
      gameId: json['game_id'] as String,
      arcId: json['arc_id'] as String,
      format: (json['format'] as String?) ?? '',
      title: json['title'] as String,
      contentRef: (json['content_ref'] as String?) ?? '',
      contentMeta: contentMetaOriginal,
      requiredAnchors: requiredAnchorsOriginal,
      fulfilledAnchors: fulfilledAnchorsOriginal,
      qualitativeFeedback: qualitativeFeedbackOriginal,
      completedAt: DateTime.parse(json['completed_at'] as String),
    );
  }
}
