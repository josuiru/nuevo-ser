class ApunteIngreso {
  final int? id;
  final int fechaMs;
  final int terceroId; // 0 = venta directa sin NIF
  final String categoria; // venta_queso / feria / suscripcion / distribuidor / subvencion_do / otro
  final double baseImponible;
  final double ivaPorcentaje;
  final double total;
  final String numeroFactura;
  final String loteReferencia; // opcional: lote de queso vendido
  final String notas;
  final int fechaCreacionMs;

  ApunteIngreso({
    this.id,
    required this.fechaMs,
    this.terceroId = 0,
    this.categoria = 'venta_queso',
    this.baseImponible = 0,
    this.ivaPorcentaje = 10,
    required this.total,
    this.numeroFactura = '',
    this.loteReferencia = '',
    this.notas = '',
    required this.fechaCreacionMs,
  });

  Map<String, Object?> toMap() => {
        'id': id,
        'fecha_ms': fechaMs,
        'tercero_id': terceroId,
        'categoria': categoria,
        'base_imponible': baseImponible,
        'iva_porcentaje': ivaPorcentaje,
        'total': total,
        'numero_factura': numeroFactura,
        'lote_referencia': loteReferencia,
        'notas': notas,
        'fecha_creacion_ms': fechaCreacionMs,
      };

  factory ApunteIngreso.fromMap(Map<String, Object?> mapa) => ApunteIngreso(
        id: mapa['id'] as int?,
        fechaMs: mapa['fecha_ms'] as int,
        terceroId: (mapa['tercero_id'] as int?) ?? 0,
        categoria: (mapa['categoria'] as String?) ?? 'venta_queso',
        baseImponible: (mapa['base_imponible'] as num?)?.toDouble() ?? 0,
        ivaPorcentaje: (mapa['iva_porcentaje'] as num?)?.toDouble() ?? 10,
        total: (mapa['total'] as num?)?.toDouble() ?? 0,
        numeroFactura: (mapa['numero_factura'] as String?) ?? '',
        loteReferencia: (mapa['lote_referencia'] as String?) ?? '',
        notas: (mapa['notas'] as String?) ?? '',
        fechaCreacionMs: (mapa['fecha_creacion_ms'] as int?) ?? 0,
      );
}
