/// Una entrada del cuaderno del niño.
///
/// Las apps deciden qué [type] usan (p. ej. `'reflexion'`, `'dibujo'`,
/// `'pregunta_eco'`) y qué guardan en [contentMeta]. El servidor sólo
/// valida formato y longitud; el shape interno es libre.
///
/// `id` y `createdAt` los rellena el servidor al crear; en el cliente
/// se construye una entrada sin ellos y se reciben tras `crearEntrada`.
class EntradaCuaderno {
  final int? id;
  final String gameId;
  final String type;
  final String title;
  final String contentRef;
  final Map<String, dynamic>? contentMeta;
  final Map<String, dynamic>? anchoredTo;
  final DateTime? createdAt;

  const EntradaCuaderno({
    this.id,
    required this.gameId,
    this.type = '',
    required this.title,
    this.contentRef = '',
    this.contentMeta,
    this.anchoredTo,
    this.createdAt,
  });

  /// Forma serializada que el cliente envía a `POST /companion/cuaderno/entries`.
  /// Omite `id` y `created_at` (los rellena el server) y los campos
  /// opcionales que sean null.
  Map<String, dynamic> aJsonParaCrear() {
    return {
      'game_id': gameId,
      if (type.isNotEmpty) 'type': type,
      'title': title,
      if (contentRef.isNotEmpty) 'content_ref': contentRef,
      if (contentMeta != null) 'content_meta': contentMeta,
      if (anchoredTo != null) 'anchored_to': anchoredTo,
    };
  }

  /// Construye una entrada a partir de la respuesta 201 del servidor.
  /// El servidor devuelve `id`, `game_id`, `type`, `title`, `content_ref`
  /// y `created_at`; los campos opcionales (`content_meta`, `anchored_to`)
  /// los preservamos del original que envió el cliente.
  factory EntradaCuaderno.desdeRespuestaCreacion(
    Map<String, dynamic> json, {
    Map<String, dynamic>? contentMetaOriginal,
    Map<String, dynamic>? anchoredToOriginal,
  }) {
    return EntradaCuaderno(
      id: (json['id'] as num).toInt(),
      gameId: json['game_id'] as String,
      type: (json['type'] as String?) ?? '',
      title: json['title'] as String,
      contentRef: (json['content_ref'] as String?) ?? '',
      contentMeta: contentMetaOriginal,
      anchoredTo: anchoredToOriginal,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}
