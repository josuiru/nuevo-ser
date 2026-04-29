/// Resultado de `POST /companion/aggregates/weekly`.
///
/// Devuelve la fila tras hacer upsert. La identidad es
/// `(user_id, game_id, iso_week)` (el `user_id` se infiere del JWT). Si
/// el cliente vuelve a subir los mismos agregados (mismo
/// [aggregatesHash]) y ya hay summary cached, `summaryText` y
/// `generatedAt` preservan el cache. Si los agregados cambiaron, el
/// servidor llama al tutor IA y devuelve un nuevo resumen.
///
/// Si el tutor IA falla (red caída, filtro de seguridad rechaza,
/// timeout), `summaryText` viene vacío — el archivado de los agregados
/// sigue adelante y el cliente puede reintentar la llamada más tarde
/// para volver a pedir el summary.
class AgregadoSemanal {
  final String gameId;
  final String isoWeek;
  final String aggregatesHash;
  final String summaryText;
  final String? conversationPrompt;
  final DateTime generatedAt;

  const AgregadoSemanal({
    required this.gameId,
    required this.isoWeek,
    required this.aggregatesHash,
    required this.summaryText,
    required this.conversationPrompt,
    required this.generatedAt,
  });

  factory AgregadoSemanal.desdeJson(Map<String, dynamic> json) {
    return AgregadoSemanal(
      gameId: json['game_id'] as String,
      isoWeek: json['iso_week'] as String,
      aggregatesHash: json['aggregates_hash'] as String,
      summaryText: (json['summary_text'] as String?) ?? '',
      conversationPrompt: json['conversation_prompt'] as String?,
      generatedAt: DateTime.parse(json['generated_at'] as String),
    );
  }
}
