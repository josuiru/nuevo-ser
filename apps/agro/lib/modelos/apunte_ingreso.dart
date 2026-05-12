/// Apunte económico de ingreso. Categorías agro concretas en
/// `tipoIngreso`: venta de cosecha (con `cultivoId` opcional para
/// imputación al cultivo), venta de leña/madera (forestal/dehesa),
/// alquiler de terreno (uso agrícola exento de IVA, otros usos
/// 21%), **ayudas PAC y subvenciones autonómicas** (típicas en
/// agricultor — fiscalmente NO son ingreso ordinario, van en
/// categoría aparte en el extracto), otros.
///
/// `terceroId` puede ser null para ventas informales (mercadillo,
/// vecino sin NIF). El resumen anual avisa de los apuntes sin
/// terceroId que no entran al modelo 347.
///
/// `fincaId` es opcional — para imputar el ingreso a una parcela
/// concreta cuando se quiera ver rentabilidad por parcela. Si null,
/// el ingreso es general de la explotación.
///
/// `cultivoId` es opcional — string del catálogo de cultivos
/// (`catalogoCultivos`) para imputar a un tipo de cultivo cuando
/// el agricultor tiene varios y quiere distinguir rentabilidad
/// por cultivo (frutal_pepita vs frutal_hueso vs trufa…).
///
/// Importes en céntimos de euro para evitar errores de redondeo en
/// double (la AEAT no perdona décimas).
class ApunteIngreso {
  final int? id;
  final int fechaMs;
  final String concepto;

  /// 'venta_cosecha' | 'venta_lena_madera' | 'alquiler_terreno'
  /// | 'ayuda_pac' | 'subvencion_autonomica' | 'otro'
  final String tipoIngreso;

  /// Importe neto en céntimos de euro (sin IVA ni compensación).
  final int importeBaseCentimos;

  /// IVA repercutido en céntimos. 0 si REAGP, alquiler agrícola o
  /// si es ayuda/subvención.
  final int ivaRepercutidoCentimos;

  /// Compensación REAGP en céntimos (12% sobre la base) cuando el
  /// titular está en REAGP y el comprador la paga. 0 si régimen
  /// general o si es ayuda/subvención.
  final int compensacionReagpCentimos;

  /// Cantidad vendida — kg/toneladas para cosecha, m³ para
  /// leña/madera, hectáreas/m² para alquiler, null para
  /// ayudas/subvenciones.
  final double? cantidad;

  /// Unidad de medida: 'kg' | 'tn' | 'm3' | 'ha' | 'm2' | ''
  final String unidad;

  final int? terceroId;
  final int? fincaId;

  /// Cultivo del catálogo (catalogoCultivos[].id) para cuando el
  /// ingreso es imputable a un tipo de cultivo concreto pero no
  /// necesariamente a una parcela. Vacío si no procede.
  final String cultivoId;

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
    this.fincaId,
    this.cultivoId = '',
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
  /// rendimiento ordinario de la actividad económica. La PAC en
  /// agro es típicamente una porción significativa de los ingresos
  /// totales — separarla evita inflar artificialmente la
  /// rentabilidad por hectárea.
  bool get esAyudaOSubvencion =>
      tipoIngreso == 'ayuda_pac' || tipoIngreso == 'subvencion_autonomica';

  bool get esVentaCosecha => tipoIngreso == 'venta_cosecha';
  bool get esAlquilerTerreno => tipoIngreso == 'alquiler_terreno';

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
        'finca_id': fincaId,
        'cultivo_id': cultivoId,
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
        fincaId: mapa['finca_id'] as int?,
        cultivoId: (mapa['cultivo_id'] as String?) ?? '',
        rutaFotoFactura: (mapa['ruta_foto_factura'] as String?) ?? '',
        numeroFactura: (mapa['numero_factura'] as String?) ?? '',
        notas: (mapa['notas'] as String?) ?? '',
      );
}
