/// Incidencia — cualquier no conformidad, defecto o anomalía detectada
/// durante la producción, curación o comercialización.
///
/// `loteProduccionId` y `piezaId` son mutuamente no-exclusivos: una
/// incidencia puede referirse a todo un lote o a una pieza concreta.
class Incidencia {
  final int? id;
  final int fechaMs;
  final String tipo; // defecto / rotura / contaminacion / hinchazon /
                     // mohoIndeseado / alteracionOrganoleptica / retirada / otra
  final int? loteProduccionId;
  final int? piezaId;
  final String descripcion;
  final String rutasFotosJson;
  final String causa;
  final String accionCorrectiva;
  final bool cerrada;
  final int fechaCreacionMs;

  Incidencia({
    this.id,
    required this.fechaMs,
    required this.tipo,
    this.loteProduccionId,
    this.piezaId,
    this.descripcion = '',
    this.rutasFotosJson = '[]',
    this.causa = '',
    this.accionCorrectiva = '',
    this.cerrada = false,
    required this.fechaCreacionMs,
  });

  Map<String, Object?> toMap() => {
        'id': id,
        'fecha_ms': fechaMs,
        'tipo': tipo,
        'lote_produccion_id': loteProduccionId,
        'pieza_id': piezaId,
        'descripcion': descripcion,
        'rutas_fotos_json': rutasFotosJson,
        'causa': causa,
        'accion_correctiva': accionCorrectiva,
        'cerrada': cerrada ? 1 : 0,
        'fecha_creacion_ms': fechaCreacionMs,
      };

  factory Incidencia.fromMap(Map<String, Object?> mapa) => Incidencia(
        id: mapa['id'] as int?,
        fechaMs: mapa['fecha_ms'] as int,
        tipo: (mapa['tipo'] as String?) ?? 'otra',
        loteProduccionId: mapa['lote_produccion_id'] as int?,
        piezaId: mapa['pieza_id'] as int?,
        descripcion: (mapa['descripcion'] as String?) ?? '',
        rutasFotosJson: (mapa['rutas_fotos_json'] as String?) ?? '[]',
        causa: (mapa['causa'] as String?) ?? '',
        accionCorrectiva: (mapa['accion_correctiva'] as String?) ?? '',
        cerrada: (mapa['cerrada'] as int?) == 1,
        fechaCreacionMs: (mapa['fecha_creacion_ms'] as int?) ?? 0,
      );
}
