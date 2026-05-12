/// Apunte económico de ingreso para viticultor/bodega. Categorías
/// vid concretas en `tipoIngreso`: venta de uva (al comprador o
/// cooperativa, IVA 4% / compensación REAGP 12%), venta de vino en
/// botella (con DOP/IGP, IVA 21%), venta de vino a granel (IVA
/// 21%), alquiler de terreno (uso agrícola exento), ayudas PAC y
/// subvenciones autonómicas (categoría aparte porque no son
/// ingreso ordinario fiscalmente).
///
/// `terceroId` puede ser null para venta directa en bodega a
/// particular. El resumen anual avisa de los apuntes sin terceroId
/// que no entran al modelo 347.
///
/// `vinedoId` es opcional — para imputar el ingreso a un viñedo
/// concreto cuando se quiera ver rentabilidad por parcela. Si null,
/// el ingreso es general de la explotación.
///
/// `variedadId` es opcional — string del catálogo de variedades de
/// uva (`catalogoVariedades`) para imputar a una variedad cuando el
/// viticultor quiere distinguir rentabilidad (tempranillo vs
/// garnacha vs verdejo…).
///
/// `loteVino` es opcional — identificador de lote del vino vendido
/// (botella o granel), útil para trazabilidad DOP/IGP. En v1 es
/// texto libre; cuando entre F1-13 con stock por lote, se enlaza a
/// la tabla de lotes.
///
/// Importes en céntimos de euro para evitar errores de redondeo en
/// double (la AEAT no perdona décimas).
class ApunteIngreso {
  final int? id;
  final int fechaMs;
  final String concepto;

  /// 'venta_uva' | 'venta_vino_botella' | 'venta_vino_granel'
  /// | 'alquiler_terreno' | 'ayuda_pac' | 'subvencion_autonomica'
  /// | 'otro'
  final String tipoIngreso;

  /// Importe neto en céntimos de euro (sin IVA ni compensación).
  final int importeBaseCentimos;

  /// IVA repercutido en céntimos. 0 si REAGP en venta de uva,
  /// alquiler agrícola, ayuda o subvención.
  final int ivaRepercutidoCentimos;

  /// Compensación REAGP en céntimos (12% sobre la base) cuando el
  /// titular está en REAGP y la operación es venta de uva. 0 en
  /// resto de casos.
  final int compensacionReagpCentimos;

  /// Cantidad vendida — kg para uva, botellas para vino_botella,
  /// litros para vino_granel, hectáreas para alquiler, null para
  /// ayudas/subvenciones.
  final double? cantidad;

  /// Unidad de medida: 'kg' | 'tn' | 'botellas' | 'l' | 'hl' | 'ha'
  /// | ''
  final String unidad;

  final int? terceroId;
  final int? vinedoId;

  /// Variedad del catálogo (id de variedad) para cuando el ingreso
  /// es imputable a un tipo de uva concreto. Vacío si no procede.
  final String variedadId;

  /// Identificador de lote del vino o de la añada. Texto libre en
  /// v1 — en F1-13 entrará la tabla de lotes con FK formal.
  final String loteVino;

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
    this.vinedoId,
    this.variedadId = '',
    this.loteVino = '',
    this.rutaFotoFactura = '',
    this.numeroFactura = '',
    this.notas = '',
  });

  /// Importe total cobrado = base + IVA repercutido + compensación REAGP.
  int get importeTotalCentimos =>
      importeBaseCentimos +
      ivaRepercutidoCentimos +
      compensacionReagpCentimos;

  bool get esAyudaOSubvencion =>
      tipoIngreso == 'ayuda_pac' || tipoIngreso == 'subvencion_autonomica';

  bool get esVentaUva => tipoIngreso == 'venta_uva';
  bool get esVentaVino =>
      tipoIngreso == 'venta_vino_botella' ||
      tipoIngreso == 'venta_vino_granel';

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
        'vinedo_id': vinedoId,
        'variedad_id': variedadId,
        'lote_vino': loteVino,
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
        vinedoId: mapa['vinedo_id'] as int?,
        variedadId: (mapa['variedad_id'] as String?) ?? '',
        loteVino: (mapa['lote_vino'] as String?) ?? '',
        rutaFotoFactura: (mapa['ruta_foto_factura'] as String?) ?? '',
        numeroFactura: (mapa['numero_factura'] as String?) ?? '',
        notas: (mapa['notas'] as String?) ?? '',
      );
}
