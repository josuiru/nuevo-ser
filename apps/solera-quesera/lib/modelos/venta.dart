/// Venta — salida de producto terminado.
/// Cada línea de venta puede referirse a piezas individuales (venta
/// selectiva de piezas concretas, ej. en tienda) o a lotes completos
/// (venta a distribuidor).
class Venta {
  final int? id;
  final int fechaMs;
  final String clienteNombre;
  final String clienteNif;
  final String clienteDireccion;
  final String tipo; // directa / tienda / distribuidor / feria /
                     // suscripcion / online
  final String lineasJson; // [{piezaId, loteProduccionId, cantidad, precioUnitario}, ...]
  final String numeroFactura;
  final double baseImponible;
  final double ivaPorcentaje;
  final double total;
  final String rutasFotosJson; // fotos de factura o albarán
  final String notas;
  final int fechaCreacionMs;

  Venta({
    this.id,
    required this.fechaMs,
    this.clienteNombre = '',
    this.clienteNif = '',
    this.clienteDireccion = '',
    this.tipo = 'directa',
    this.lineasJson = '[]',
    this.numeroFactura = '',
    this.baseImponible = 0,
    this.ivaPorcentaje = 10,
    this.total = 0,
    this.rutasFotosJson = '[]',
    this.notas = '',
    required this.fechaCreacionMs,
  });

  Map<String, Object?> toMap() => {
        'id': id,
        'fecha_ms': fechaMs,
        'cliente_nombre': clienteNombre,
        'cliente_nif': clienteNif,
        'cliente_direccion': clienteDireccion,
        'tipo': tipo,
        'lineas_json': lineasJson,
        'numero_factura': numeroFactura,
        'base_imponible': baseImponible,
        'iva_porcentaje': ivaPorcentaje,
        'total': total,
        'rutas_fotos_json': rutasFotosJson,
        'notas': notas,
        'fecha_creacion_ms': fechaCreacionMs,
      };

  factory Venta.fromMap(Map<String, Object?> mapa) => Venta(
        id: mapa['id'] as int?,
        fechaMs: mapa['fecha_ms'] as int,
        clienteNombre: (mapa['cliente_nombre'] as String?) ?? '',
        clienteNif: (mapa['cliente_nif'] as String?) ?? '',
        clienteDireccion: (mapa['cliente_direccion'] as String?) ?? '',
        tipo: (mapa['tipo'] as String?) ?? 'directa',
        lineasJson: (mapa['lineas_json'] as String?) ?? '[]',
        numeroFactura: (mapa['numero_factura'] as String?) ?? '',
        baseImponible: (mapa['base_imponible'] as num?)?.toDouble() ?? 0,
        ivaPorcentaje: (mapa['iva_porcentaje'] as num?)?.toDouble() ?? 10,
        total: (mapa['total'] as num?)?.toDouble() ?? 0,
        rutasFotosJson: (mapa['rutas_fotos_json'] as String?) ?? '[]',
        notas: (mapa['notas'] as String?) ?? '',
        fechaCreacionMs: (mapa['fecha_creacion_ms'] as int?) ?? 0,
      );
}
