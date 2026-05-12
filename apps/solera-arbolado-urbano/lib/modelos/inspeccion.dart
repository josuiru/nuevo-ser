/// Inspección rutinaria del técnico sobre un árbol urbano. Equivalente
/// a `Revision` de las hermanas. Captura estado fitosanitario, riesgo
/// VTA percibido y observaciones libres + fotos.
class Inspeccion {
  final int? id;
  final int arbolId;
  final int? tecnicoId;
  final int fechaMs;

  /// Estado global en el momento de la inspección. String para que la
  /// BD acepte valores futuros sin migración (la enum del modelo `Arbol`
  /// es la canónica; aquí se serializa al mismo formato).
  final String estado;

  /// Riesgo VTA percibido en esta visita. 1-5, null si no se evaluó.
  final int? riesgoVta;

  /// Observación: el árbol está en flor / en hoja / desnudo / con frutos.
  /// String libre — se ata al catálogo en F1U-4 si entra como controlado.
  final String fenologia;

  final String rutasFotosJson;
  final String notas;

  Inspeccion({
    this.id,
    required this.arbolId,
    this.tecnicoId,
    required this.fechaMs,
    this.estado = 'sano',
    this.riesgoVta,
    this.fenologia = '',
    this.rutasFotosJson = '[]',
    this.notas = '',
  });

  Map<String, Object?> toMap() => {
        'id': id,
        'arbol_id': arbolId,
        'tecnico_id': tecnicoId,
        'fecha_ms': fechaMs,
        'estado': estado,
        'riesgo_vta': riesgoVta,
        'fenologia': fenologia,
        'rutas_fotos_json': rutasFotosJson,
        'notas': notas,
      };

  factory Inspeccion.fromMap(Map<String, Object?> mapa) => Inspeccion(
        id: mapa['id'] as int?,
        arbolId: mapa['arbol_id'] as int,
        tecnicoId: mapa['tecnico_id'] as int?,
        fechaMs: mapa['fecha_ms'] as int,
        estado: (mapa['estado'] as String?) ?? 'sano',
        riesgoVta: mapa['riesgo_vta'] as int?,
        fenologia: (mapa['fenologia'] as String?) ?? '',
        rutasFotosJson: (mapa['rutas_fotos_json'] as String?) ?? '[]',
        notas: (mapa['notas'] as String?) ?? '',
      );
}
