/// Aula tal y como la devuelve `POST /classrooms` (con JWT del
/// profesor). El [code] es el invitar-token que el profesor reparte a
/// la clase para que los niños se unan vía
/// `POST /classrooms/{code}/join`.
class AulaCreada {
  const AulaCreada({
    required this.classroomId,
    required this.code,
    required this.name,
    required this.language,
    required this.gameIds,
    required this.active,
    required this.createdAt,
  });

  final int classroomId;
  final String code;
  final String name;
  final String language;
  final List<String> gameIds;
  final bool active;
  final DateTime createdAt;

  factory AulaCreada.desdeJson(Map<String, dynamic> json) {
    final ids = json['game_ids'];
    return AulaCreada(
      classroomId: (json['classroom_id'] as num).toInt(),
      code: json['code'] as String,
      name: json['name'] as String,
      language: (json['language'] as String?) ?? 'es',
      gameIds: ids is List
          ? ids.whereType<String>().toList(growable: false)
          : const <String>[],
      active: json['active'] == true,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}
