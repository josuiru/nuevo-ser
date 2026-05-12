class Factura {
  final int? id;
  final String numeroFactura;
  final int fechaEmisionMs;
  final int? fechaVencimientoMs;
  final int? fechaPagoMs;
  final String clienteNombre;
  final String clienteNif;
  final String clienteDireccion;
  final String lineasJson;
  final double baseImponible;
  final double ivaPorcentaje;
  final double total;
  final String estado;
  final String notas;
  final int fechaCreacionMs;

  Factura({
    this.id,
    required this.numeroFactura,
    required this.fechaEmisionMs,
    this.fechaVencimientoMs,
    this.fechaPagoMs,
    this.clienteNombre = '',
    this.clienteNif = '',
    this.clienteDireccion = '',
    this.lineasJson = '[]',
    this.baseImponible = 0,
    this.ivaPorcentaje = 10,
    this.total = 0,
    this.estado = 'emitida',
    this.notas = '',
    required this.fechaCreacionMs,
  });

  Map<String, Object?> toMap() => {
        'id': id,
        'numero_factura': numeroFactura,
        'fecha_emision_ms': fechaEmisionMs,
        'fecha_vencimiento_ms': fechaVencimientoMs,
        'fecha_pago_ms': fechaPagoMs,
        'cliente_nombre': clienteNombre,
        'cliente_nif': clienteNif,
        'cliente_direccion': clienteDireccion,
        'lineas_json': lineasJson,
        'base_imponible': baseImponible,
        'iva_porcentaje': ivaPorcentaje,
        'total': total,
        'estado': estado,
        'notas': notas,
        'fecha_creacion_ms': fechaCreacionMs,
      };

  factory Factura.fromMap(Map<String, Object?> mapa) => Factura(
        id: mapa['id'] as int?,
        numeroFactura: (mapa['numero_factura'] as String?) ?? '',
        fechaEmisionMs: mapa['fecha_emision_ms'] as int,
        fechaVencimientoMs: mapa['fecha_vencimiento_ms'] as int?,
        fechaPagoMs: mapa['fecha_pago_ms'] as int?,
        clienteNombre: (mapa['cliente_nombre'] as String?) ?? '',
        clienteNif: (mapa['cliente_nif'] as String?) ?? '',
        clienteDireccion: (mapa['cliente_direccion'] as String?) ?? '',
        lineasJson: (mapa['lineas_json'] as String?) ?? '[]',
        baseImponible: (mapa['base_imponible'] as num?)?.toDouble() ?? 0,
        ivaPorcentaje: (mapa['iva_porcentaje'] as num?)?.toDouble() ?? 10,
        total: (mapa['total'] as num?)?.toDouble() ?? 0,
        estado: (mapa['estado'] as String?) ?? 'emitida',
        notas: (mapa['notas'] as String?) ?? '',
        fechaCreacionMs: (mapa['fecha_creacion_ms'] as int?) ?? 0,
      );
}
