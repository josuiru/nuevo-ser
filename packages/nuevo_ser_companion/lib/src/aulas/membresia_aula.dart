/// Membresía del niño en un aula.
///
/// Devuelta por `POST /classrooms/{code}/join`. La operación es
/// idempotente: si el niño ya estaba dentro, [joinedAt] es la fecha
/// histórica del primer ingreso.
class MembresiaAula {
  final int classroomId;
  final String code;
  final String name;
  final List<String> gameIds;
  final String language;
  final DateTime joinedAt;

  const MembresiaAula({
    required this.classroomId,
    required this.code,
    required this.name,
    required this.gameIds,
    required this.language,
    required this.joinedAt,
  });

  factory MembresiaAula.desdeJson(Map<String, dynamic> json) {
    final ids = json['game_ids'];
    return MembresiaAula(
      classroomId: (json['classroom_id'] as num).toInt(),
      code: json['code'] as String,
      name: json['name'] as String,
      gameIds: ids is List
          ? ids.whereType<String>().toList(growable: false)
          : const [],
      language: (json['language'] as String?) ?? 'es',
      joinedAt: DateTime.parse(json['joined_at'] as String),
    );
  }
}
