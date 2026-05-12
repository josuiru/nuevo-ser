/// Incidencia urbana sobre un árbol. Categoría diferente a las plagas
/// — aquí entran golpes vehiculares, vandalismo, raíces que levantan
/// acera, alcorque dañado, ramas caídas por temporal, etc. Las plagas
/// fitosanitarias específicas (procesionaria, picudo) se registran como
/// `Tratamiento` o como anomalía en `Inspeccion`.
class Incidencia {
  final int? id;
  final int arbolId;
  final int? tecnicoId;
  final int fechaMs;

  /// Tipo: `golpe_vehiculo` | `vandalismo` | `temporal` | `alcorque_danado`
  /// | `raices_acera` | `riesgo_caida` | `otro`.
  final String tipo;

  final String descripcion;

  /// Severidad 1-5. Útil para priorizar intervención.
  final int? severidad;

  final bool resuelta;
  final int? fechaResolucionMs;

  final String rutasFotosJson;
  final String notas;

  Incidencia({
    this.id,
    required this.arbolId,
    this.tecnicoId,
    required this.fechaMs,
    this.tipo = 'otro',
    this.descripcion = '',
    this.severidad,
    this.resuelta = false,
    this.fechaResolucionMs,
    this.rutasFotosJson = '[]',
    this.notas = '',
  });

  Map<String, Object?> toMap() => {
        'id': id,
        'arbol_id': arbolId,
        'tecnico_id': tecnicoId,
        'fecha_ms': fechaMs,
        'tipo': tipo,
        'descripcion': descripcion,
        'severidad': severidad,
        'resuelta': resuelta ? 1 : 0,
        'fecha_resolucion_ms': fechaResolucionMs,
        'rutas_fotos_json': rutasFotosJson,
        'notas': notas,
      };

  factory Incidencia.fromMap(Map<String, Object?> mapa) => Incidencia(
        id: mapa['id'] as int?,
        arbolId: mapa['arbol_id'] as int,
        tecnicoId: mapa['tecnico_id'] as int?,
        fechaMs: mapa['fecha_ms'] as int,
        tipo: (mapa['tipo'] as String?) ?? 'otro',
        descripcion: (mapa['descripcion'] as String?) ?? '',
        severidad: mapa['severidad'] as int?,
        resuelta: (mapa['resuelta'] as int?) == 1,
        fechaResolucionMs: mapa['fecha_resolucion_ms'] as int?,
        rutasFotosJson: (mapa['rutas_fotos_json'] as String?) ?? '[]',
        notas: (mapa['notas'] as String?) ?? '',
      );
}
