/// Venta — salida comercial. El aceite tiene la particularidad de que
/// el destino del cliente (España / UE / extra-UE) afecta el régimen
/// fiscal REAGP, por eso lo guardamos como campo separado.
///
/// `lineasJson` serializa la lista de items vendidos (lotes a granel
/// o envases con referencia). Formato: `[{lote_id, kg, precio_kg},…]`
/// para granel o `[{envase, unidades, precio_unidad},…]` para envasado.
/// No se modela como tabla aparte en F1-A2 porque la mayoría de ventas
/// pequeñas son lineales.
class Venta {
  final int? id;
  final int fechaMs;
  /// Uno de: `particular` / `empresa_es` / `empresa_ue` / `empresa_extra_ue`.
  final String tipoCliente;
  final String nombreCliente;
  /// NIF / CIF / VAT-UE / null para particular sin factura.
  final String identificadorFiscalCliente;
  final String numeroFactura;
  /// JSON con las líneas vendidas (ver doc clase).
  final String lineasJson;
  final double totalSinIva;
  final double ivaPorcentaje;
  final double totalConIva;
  /// Código ISO 3166-1 alfa-2. España default.
  final String destinoPaisIso;
  final String notas;

  Venta({
    this.id,
    required this.fechaMs,
    this.tipoCliente = 'particular',
    this.nombreCliente = '',
    this.identificadorFiscalCliente = '',
    this.numeroFactura = '',
    this.lineasJson = '[]',
    this.totalSinIva = 0,
    this.ivaPorcentaje = 0,
    this.totalConIva = 0,
    this.destinoPaisIso = 'ES',
    this.notas = '',
  });

  Map<String, Object?> toMap() => {
        'id': id,
        'fecha_ms': fechaMs,
        'tipo_cliente': tipoCliente,
        'nombre_cliente': nombreCliente,
        'identificador_fiscal_cliente': identificadorFiscalCliente,
        'numero_factura': numeroFactura,
        'lineas_json': lineasJson,
        'total_sin_iva': totalSinIva,
        'iva_porcentaje': ivaPorcentaje,
        'total_con_iva': totalConIva,
        'destino_pais_iso': destinoPaisIso,
        'notas': notas,
      };

  factory Venta.fromMap(Map<String, Object?> mapa) => Venta(
        id: mapa['id'] as int?,
        fechaMs: (mapa['fecha_ms'] as int?) ?? 0,
        tipoCliente: (mapa['tipo_cliente'] as String?) ?? 'particular',
        nombreCliente: (mapa['nombre_cliente'] as String?) ?? '',
        identificadorFiscalCliente: (mapa['identificador_fiscal_cliente'] as String?) ?? '',
        numeroFactura: (mapa['numero_factura'] as String?) ?? '',
        lineasJson: (mapa['lineas_json'] as String?) ?? '[]',
        totalSinIva: (mapa['total_sin_iva'] as num?)?.toDouble() ?? 0,
        ivaPorcentaje: (mapa['iva_porcentaje'] as num?)?.toDouble() ?? 0,
        totalConIva: (mapa['total_con_iva'] as num?)?.toDouble() ?? 0,
        destinoPaisIso: (mapa['destino_pais_iso'] as String?) ?? 'ES',
        notas: (mapa['notas'] as String?) ?? '',
      );
}
