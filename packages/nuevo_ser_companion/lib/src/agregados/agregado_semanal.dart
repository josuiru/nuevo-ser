/// Resultado de `POST /companion/aggregates/weekly`.
///
/// Devuelve la fila tras hacer upsert. La identidad es
/// `(user_id, game_id, iso_week)` (el `user_id` se infiere del JWT). Si
/// el cliente vuelve a subir los mismos agregados (mismo
/// [aggregatesHash]), `summaryText` y `generatedAt` preservan el cache;
/// si los agregados cambiaron, `summaryText` queda en blanco a la espera
/// de que el tutor IA regenere.
///
/// **Nota**: en el slice actual el servidor no llama todavía al tutor
/// IA, así que `summaryText` será cadena vacía y `conversationPrompt`
/// `null` hasta que se conecte. El cliente puede tratar la cadena vacía
/// como "summary no disponible aún".
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
