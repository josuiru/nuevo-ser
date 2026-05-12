class ApunteGasto {
  final int? id;
  final int fechaMs;
  final int terceroId; // 0 = sin identificar
  final String categoria; // leche / fermentos_cuajo / energia_cava / etiquetado /
                          // analiticas / cuota_do / transporte / mano_obra /
                          // material_limpieza / seguros / otros
  final double baseImponible;
  final double ivaPorcentaje;
  final double total;
  final String numeroFactura;
  final String notas;
  final int fechaCreacionMs;

  ApunteGasto({
    this.id,
    required this.fechaMs,
    this.terceroId = 0,
    this.categoria = 'otros',
    this.baseImponible = 0,
    this.ivaPorcentaje = 21,
    required this.total,
    this.numeroFactura = '',
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
        'notas': notas,
        'fecha_creacion_ms': fechaCreacionMs,
      };

  factory ApunteGasto.fromMap(Map<String, Object?> mapa) => ApunteGasto(
        id: mapa['id'] as int?,
        fechaMs: mapa['fecha_ms'] as int,
        terceroId: (mapa['tercero_id'] as int?) ?? 0,
        categoria: (mapa['categoria'] as String?) ?? 'otros',
        baseImponible: (mapa['base_imponible'] as num?)?.toDouble() ?? 0,
        ivaPorcentaje: (mapa['iva_porcentaje'] as num?)?.toDouble() ?? 21,
        total: (mapa['total'] as num?)?.toDouble() ?? 0,
        numeroFactura: (mapa['numero_factura'] as String?) ?? '',
        notas: (mapa['notas'] as String?) ?? '',
        fechaCreacionMs: (mapa['fecha_creacion_ms'] as int?) ?? 0,
      );
}
