/// Observación general sobre el estado de la cepa: salud, vigor,
/// fenología (brotación, floración, envero, vendimia). No registra
/// incidencias (plagas/enfermedades) — para eso está `Incidencia`.
/// Mantenerlo separado evita inflar la tabla con dos tipos de
/// eventos muy distintos en su uso (consulta, estadística, IA por
/// foto).
///
/// `salud` es 1..5: 1 muy mala, 5 excelente. Null si no se evaluó.
/// `etiquetasJson` es lista libre de tags (catálogo BBCH adaptado a
/// vid: 'brotación', 'foliación', 'floración', 'cuajado', 'envero',
/// 'vendimia') para filtros y agregaciones.
class Observacion {
  final int? id;
  final int cepaId;
  final int fechaMs;
  final int? salud;
  final String etiquetasJson;
  final String rutasFotosJson;
  final String notas;

  Observacion({
    this.id,
    required this.cepaId,
    required this.fechaMs,
    this.salud,
    this.etiquetasJson = '[]',
    this.rutasFotosJson = '[]',
    this.notas = '',
  });

  Map<String, Object?> toMap() => {
        'id': id,
        'cepa_id': cepaId,
        'fecha_ms': fechaMs,
        'salud': salud,
        'etiquetas_json': etiquetasJson,
        'rutas_fotos_json': rutasFotosJson,
        'notas': notas,
      };

  factory Observacion.fromMap(Map<String, Object?> mapa) => Observacion(
        id: mapa['id'] as int?,
        cepaId: mapa['cepa_id'] as int,
        fechaMs: mapa['fecha_ms'] as int,
        salud: mapa['salud'] as int?,
        etiquetasJson: (mapa['etiquetas_json'] as String?) ?? '[]',
        rutasFotosJson: (mapa['rutas_fotos_json'] as String?) ?? '[]',
        notas: (mapa['notas'] as String?) ?? '',
      );
}
