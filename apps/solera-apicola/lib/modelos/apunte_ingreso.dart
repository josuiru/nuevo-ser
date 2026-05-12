/// Apunte económico de ingreso. Categorías apícolas concretas en
/// `tipoIngreso`: venta de productos (miel, polen, cera, propóleo,
/// jalea), **alquiler de colmenas para polinización** (ingreso
/// distintivo de la apicultura profesional ibérica), ayudas y
/// subvenciones (PAC, autonómicas — fiscalmente NO son ingreso
/// ordinario, van en categoría aparte en el extracto), otros.
///
/// `terceroId` puede ser null para ventas informales (mercadillo,
/// particular sin NIF). El resumen anual avisa de los apuntes sin
/// terceroId que no entran al modelo 347 por falta de NIF.
///
/// `apiarioId` es opcional — sirve para imputar el ingreso a un
/// colmenar concreto cuando se quiera ver rentabilidad. Si null, el
/// ingreso es general de la explotación.
///
/// Importes en céntimos de euro para evitar errores de redondeo en
/// double (la AEAT no perdona décimas).
class ApunteIngreso {
  final int? id;
  final int fechaMs;
  final String concepto;

  /// 'venta_miel' | 'venta_polen' | 'venta_cera' | 'venta_propoleo'
  /// | 'venta_jalea' | 'alquiler_polinizacion' | 'ayuda_pac'
  /// | 'subvencion_autonomica' | 'otro'
  final String tipoIngreso;

  /// Importe neto en céntimos de euro (sin IVA ni compensación).
  final int importeBaseCentimos;

  /// IVA repercutido en céntimos. 0 si REAGP o si es ayuda/subvención.
  final int ivaRepercutidoCentimos;

  /// Compensación REAGP en céntimos (12% sobre la base) cuando el
  /// titular está en REAGP y el comprador la paga. 0 si régimen
  /// general o si es ayuda/subvención.
  final int compensacionReagpCentimos;

  /// Cantidad vendida — kg para miel/polen/cera/propóleo/jalea,
  /// número de colmenas para alquiler_polinizacion, null para
  /// ayudas/subvenciones.
  final double? cantidad;

  /// Unidad de medida: 'kg' | 'colmenas' | 'unidades' | ''
  final String unidad;

  final int? terceroId;
  final int? apiarioId;
  final String rutaFotoFactura;
  final String numeroFactura;
  final String notas;

  ApunteIngreso({
    this.id,
    required this.fechaMs,
    this.concepto = '',
    this.tipoIngreso = 'otro',
    this.importeBaseCentimos = 0,
    this.ivaRepercutidoCentimos = 0,
    this.compensacionReagpCentimos = 0,
    this.cantidad,
    this.unidad = '',
    this.terceroId,
    this.apiarioId,
    this.rutaFotoFactura = '',
    this.numeroFactura = '',
    this.notas = '',
  });

  /// Importe total cobrado = base + IVA repercutido + compensación REAGP.
  int get importeTotalCentimos =>
      importeBaseCentimos +
      ivaRepercutidoCentimos +
      compensacionReagpCentimos;

  /// True para ayudas PAC y subvenciones — el extracto las separa
  /// del bloque "ingresos ordinarios" porque fiscalmente no son
  /// rendimiento ordinario de la actividad económica.
  bool get esAyudaOSubvencion =>
      tipoIngreso == 'ayuda_pac' || tipoIngreso == 'subvencion_autonomica';

  /// True para alquiler de colmenas — el extracto lo lista aparte
  /// porque tiene IVA distinto (21% general en v1) y CNAE distinto
  /// del de venta de miel.
  bool get esPolinizacion => tipoIngreso == 'alquiler_polinizacion';

  Map<String, Object?> toMap() => {
        'id': id,
        'fecha_ms': fechaMs,
        'concepto': concepto,
        'tipo_ingreso': tipoIngreso,
        'importe_base_centimos': importeBaseCentimos,
        'iva_repercutido_centimos': ivaRepercutidoCentimos,
        'compensacion_reagp_centimos': compensacionReagpCentimos,
        'cantidad': cantidad,
        'unidad': unidad,
        'tercero_id': terceroId,
        'apiario_id': apiarioId,
        'ruta_foto_factura': rutaFotoFactura,
        'numero_factura': numeroFactura,
        'notas': notas,
      };

  factory ApunteIngreso.fromMap(Map<String, Object?> mapa) => ApunteIngreso(
        id: mapa['id'] as int?,
        fechaMs: mapa['fecha_ms'] as int,
        concepto: (mapa['concepto'] as String?) ?? '',
        tipoIngreso: (mapa['tipo_ingreso'] as String?) ?? 'otro',
        importeBaseCentimos: (mapa['importe_base_centimos'] as int?) ?? 0,
        ivaRepercutidoCentimos:
            (mapa['iva_repercutido_centimos'] as int?) ?? 0,
        compensacionReagpCentimos:
            (mapa['compensacion_reagp_centimos'] as int?) ?? 0,
        cantidad: (mapa['cantidad'] as num?)?.toDouble(),
        unidad: (mapa['unidad'] as String?) ?? '',
        terceroId: mapa['tercero_id'] as int?,
        apiarioId: mapa['apiario_id'] as int?,
        rutaFotoFactura: (mapa['ruta_foto_factura'] as String?) ?? '',
        numeroFactura: (mapa['numero_factura'] as String?) ?? '',
        notas: (mapa['notas'] as String?) ?? '',
      );
}
