/// Apunte económico de ingreso para titular de olivar/almazara.
/// Categorías olivar concretas en `tipoIngreso`:
///
///   - 'venta_aceituna' — aceituna vendida a cooperativa o almazara
///     externa. IVA 4% (general) o compensación REAGP 12% (REAGP).
///   - 'venta_aceite_envasado' — aceite virgen extra/virgen/lampante
///     envasado vendido al consumidor o distribuidor final. IVA 4%
///     (alimento de primera necesidad). Suele ser operación de la
///     almazara, fuera del REAGP del agricultor.
///   - 'venta_aceite_granel' — aceite a granel a otro envasador o
///     refinador. Tratamiento intermedio que el asesor fiscal debe
///     confirmar (4% por categorización del producto, según
///     interpretación habitual; revisar caso por caso).
///   - 'alquiler_terreno' — uso agrícola exento (LIVA 20.1.23).
///   - 'ayuda_pac' / 'subvencion_autonomica' — ingreso no comercial,
///     categoría aparte en el resumen anual.
///   - 'subproducto_alperujo' — venta de alperujo a orujera (común
///     en almazaras pequeñas que no lo procesan). IVA 10% como
///     subproducto agrícola — ⚠ confirmar con asesor.
///   - 'otro' — el resto, libre.
///
/// `terceroId` puede ser null para venta directa en almazara a
/// particular. El resumen anual avisa de los apuntes sin terceroId
/// que no entran al modelo 347.
///
/// `parcelaId` es opcional — para imputar el ingreso a una parcela
/// concreta cuando se quiera ver rentabilidad. Si null, el ingreso
/// es general de la explotación.
///
/// `variedadId` es opcional — string del catálogo de variedades de
/// olivo (`catalogoVariedadesOlivo`) para distinguir rentabilidad
/// (picual vs hojiblanca vs arbequina…).
///
/// `loteAceiteId` es opcional — FK al lote de aceite vendido, útil
/// para trazabilidad DOP. En v1 se enlaza con la tabla de lotes ya
/// existente.
///
/// Importes en céntimos de euro para evitar errores de redondeo en
/// double (la AEAT no perdona décimas).
class ApunteIngreso {
  final int? id;
  final int fechaMs;
  final String concepto;

  /// 'venta_aceituna' | 'venta_aceite_envasado' | 'venta_aceite_granel'
  /// | 'alquiler_terreno' | 'ayuda_pac' | 'subvencion_autonomica'
  /// | 'subproducto_alperujo' | 'otro'
  final String tipoIngreso;

  /// Importe neto en céntimos de euro (sin IVA ni compensación).
  final int importeBaseCentimos;

  /// IVA repercutido en céntimos. 0 si REAGP en venta de aceituna,
  /// alquiler agrícola, ayuda o subvención.
  final int ivaRepercutidoCentimos;

  /// Compensación REAGP en céntimos (12% sobre la base) cuando el
  /// titular está en REAGP y la operación es venta de aceituna. 0 en
  /// resto de casos.
  final int compensacionReagpCentimos;

  /// Cantidad vendida — kg para aceituna y aceite, litros para aceite
  /// a granel, botellas para aceite envasado, hectáreas para alquiler,
  /// null para ayudas/subvenciones.
  final double? cantidad;

  /// Unidad de medida: 'kg' | 'tn' | 'botellas' | 'l' | 'hl' | 'ha'
  /// | ''
  final String unidad;

  final int? terceroId;
  final int? parcelaId;

  /// Variedad del catálogo (id de variedad) para cuando el ingreso
  /// es imputable a un tipo de aceituna concreto. Vacío si no procede.
  final String variedadId;

  /// FK al lote de aceite vendido (tabla `lotes_aceite`). Útil para
  /// trazabilidad DOP — el extracto puede agrupar ventas por lote.
  final int? loteAceiteId;

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
    this.parcelaId,
    this.variedadId = '',
    this.loteAceiteId,
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

  bool get esVentaAceituna => tipoIngreso == 'venta_aceituna';
  bool get esVentaAceite =>
      tipoIngreso == 'venta_aceite_envasado' ||
      tipoIngreso == 'venta_aceite_granel';

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
        'parcela_id': parcelaId,
        'variedad_id': variedadId,
        'lote_aceite_id': loteAceiteId,
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
        parcelaId: mapa['parcela_id'] as int?,
        variedadId: (mapa['variedad_id'] as String?) ?? '',
        loteAceiteId: mapa['lote_aceite_id'] as int?,
        rutaFotoFactura: (mapa['ruta_foto_factura'] as String?) ?? '',
        numeroFactura: (mapa['numero_factura'] as String?) ?? '',
        notas: (mapa['notas'] as String?) ?? '',
      );
}
