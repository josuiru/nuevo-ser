/// Agregados de un aula tal y como los devuelve
/// `GET /classrooms/{id}/aggregates` para el profesor dueño del aula.
///
/// **k mínimo = 5**: el servidor responde 403 con
/// `k_minimo_no_alcanzado` cuando el aula tiene menos de 5 miembros
/// activos (o menos de 5 con datos para la semana solicitada). En ese
/// caso, este modelo no se construye — la excepción se propaga con la
/// info de cuántos miembros faltan. La voz "no humillar" del juego
/// pide que la UI explique al profesor cuántos faltan, sin culpar.
///
/// El [aggregates] mapea `game_id → counts agregados`. Cada juego puede
/// emitir su propio shape de payload (Uno Roto: `precision_total`,
/// `nivel_promedio`; El Cuaderno: `observaciones_total`,
/// `observaciones_por_misterio`, …) — el servidor suma claves enteras
/// y mergea sub-mapas string→int sin entender la semántica.
class AgregadosAula {
  const AgregadosAula({
    required this.classroomId,
    required this.code,
    required this.name,
    required this.language,
    required this.isoWeek,
    required this.memberCount,
    required this.reportingCount,
    required this.aggregates,
  });

  final int classroomId;
  final String code;
  final String name;
  final String language;
  final String isoWeek;
  final int memberCount;
  final int reportingCount;
  final Map<String, Map<String, dynamic>> aggregates;

  factory AgregadosAula.desdeJson(Map<String, dynamic> json) {
    final aggCrudo = json['aggregates'];
    final aggregates = <String, Map<String, dynamic>>{};
    if (aggCrudo is Map<String, dynamic>) {
      aggCrudo.forEach((gameId, payload) {
        if (payload is Map<String, dynamic>) {
          aggregates[gameId] = Map<String, dynamic>.from(payload);
        }
      });
    }
    return AgregadosAula(
      classroomId: (json['classroom_id'] as num).toInt(),
      code: json['code'] as String,
      name: json['name'] as String,
      language: (json['language'] as String?) ?? 'es',
      isoWeek: json['iso_week'] as String,
      memberCount: (json['member_count'] as num).toInt(),
      reportingCount: (json['reporting_count'] as num).toInt(),
      aggregates: aggregates,
    );
  }
}
