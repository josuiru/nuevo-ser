/// Apunte económico de gasto del titular de olivar/almazara.
/// Categorías olivar concretas en `tipoGasto`:
///
///   - 'insumos_olivar' — fertilizantes, abonos, herbicidas (IVA 4%
///     reducido como insumo agrícola en general; ⚠ confirmar caso a
///     caso).
///   - 'fitosanitarios' — productos fitosanitarios autorizados
///     (sinergia con el libro PAC: cada apunte de tratamiento puede
///     generar el apunte de gasto correspondiente).
///   - 'recoleccion' — jornales de cuadrilla en recolección. Pico
///     anual del gasto en olivar tradicional (octubre-enero).
///     Suele tributar al 0% por ser mano de obra.
///   - 'molturacion_externa' — pago a almazara externa cuando el
///     titular no muele en propia. 10% IVA habitualmente.
///   - 'envasado' — botellas, garrafas, etiquetado, cápsulas, cajas.
///   - 'analiticas' — analíticas de aceite (acidez, peróxidos, K232/
///     K270, panel test) obligatorias para DOP.
///   - 'cuota_dop' — cuota anual del Consejo Regulador de la DOP.
///   - 'maquinaria' — compra y mantenimiento (vibradores, peines
///     eléctricos, tractores, decanter, batidora). Recurrente y
///     amortizable.
///   - 'mano_obra' — jornales fuera de recolección (poda, escarda,
///     riegos, mantenimiento). 0% IVA por ser mano de obra.
///   - 'combustible' — gasoil agrícola (REAGP da derecho a
///     devolución parcial del IH; el extracto lo computa aparte).
///   - 'seguros' — seguro agrario (exento de IVA).
///   - 'transporte' — transporte de aceituna o aceite a almazara/
///     envasador externos.
///   - 'certificacion' — ecológico, integrada, DOP (recurrente anual).
///   - 'otro' — el resto, libre.
///
/// **Imputación** a parcela/variedad/general:
///   - 'parcela_concreta' + parcelaId set → todo el gasto a la parcela.
///   - 'variedad_general' + variedadId set → gasto compartido entre
///     todas las parcelas con esa variedad (el extracto en v1 lista
///     el importe íntegro; el reparto proporcional por superficie
///     queda pendiente de validación de asesor fiscal).
///   - 'general' → gasto de la explotación, sin imputación concreta.
///
/// Importes en céntimos de euro.
class ApunteGasto {
  final int? id;
  final int fechaMs;
  final String concepto;

  /// 'insumos_olivar' | 'fitosanitarios' | 'recoleccion'
  /// | 'molturacion_externa' | 'envasado' | 'analiticas'
  /// | 'cuota_dop' | 'maquinaria' | 'mano_obra' | 'combustible'
  /// | 'seguros' | 'transporte' | 'certificacion' | 'otro'
  final String tipoGasto;

  final int importeBaseCentimos;

  /// IVA soportado en céntimos. Recuperable si el titular está en
  /// régimen general; NO recuperable si está en REAGP (caso típico
  /// en explotación pequeña-mediana de olivar).
  final int ivaSoportadoCentimos;

  /// 'parcela_concreta' | 'variedad_general' | 'general'
  final String imputacion;

  /// Sólo significativo si imputacion == 'parcela_concreta'.
  final int? parcelaId;

  /// Sólo significativo si imputacion == 'variedad_general'. String
  /// del catálogo de variedades.
  final String variedadId;

  /// Proveedor (FK opcional a `terceros`).
  final int? terceroId;

  final String rutaFotoFactura;
  final String numeroFactura;

  /// Atajo opcional al `tratamientos` que originó este gasto
  /// (sinergia clave: el apunte de tratamiento del libro PAC puede
  /// generar el apunte de gasto correspondiente). null si no procede.
  final int? tratamientoId;

  final String notas;

  ApunteGasto({
    this.id,
    required this.fechaMs,
    this.concepto = '',
    this.tipoGasto = 'otro',
    this.importeBaseCentimos = 0,
    this.ivaSoportadoCentimos = 0,
    this.imputacion = 'general',
    this.parcelaId,
    this.variedadId = '',
    this.terceroId,
    this.rutaFotoFactura = '',
    this.numeroFactura = '',
    this.tratamientoId,
    this.notas = '',
  });

  int get importeTotalCentimos => importeBaseCentimos + ivaSoportadoCentimos;

  bool get esParcelaConcreta =>
      imputacion == 'parcela_concreta' && parcelaId != null;

  bool get esVariedadGeneral =>
      imputacion == 'variedad_general' && variedadId.isNotEmpty;

  /// `true` si el gasto es gasoil agrícola — el extracto fiscal lo
  /// computa aparte para calcular la devolución del IH en REAGP.
  bool get esGasoilAgricola => tipoGasto == 'combustible';

  Map<String, Object?> toMap() => {
        'id': id,
        'fecha_ms': fechaMs,
        'concepto': concepto,
        'tipo_gasto': tipoGasto,
        'importe_base_centimos': importeBaseCentimos,
        'iva_soportado_centimos': ivaSoportadoCentimos,
        'imputacion': imputacion,
        'parcela_id': parcelaId,
        'variedad_id': variedadId,
        'tercero_id': terceroId,
        'ruta_foto_factura': rutaFotoFactura,
        'numero_factura': numeroFactura,
        'tratamiento_id': tratamientoId,
        'notas': notas,
      };

  factory ApunteGasto.fromMap(Map<String, Object?> mapa) => ApunteGasto(
        id: mapa['id'] as int?,
        fechaMs: mapa['fecha_ms'] as int,
        concepto: (mapa['concepto'] as String?) ?? '',
        tipoGasto: (mapa['tipo_gasto'] as String?) ?? 'otro',
        importeBaseCentimos: (mapa['importe_base_centimos'] as int?) ?? 0,
        ivaSoportadoCentimos: (mapa['iva_soportado_centimos'] as int?) ?? 0,
        imputacion: (mapa['imputacion'] as String?) ?? 'general',
        parcelaId: mapa['parcela_id'] as int?,
        variedadId: (mapa['variedad_id'] as String?) ?? '',
        terceroId: mapa['tercero_id'] as int?,
        rutaFotoFactura: (mapa['ruta_foto_factura'] as String?) ?? '',
        numeroFactura: (mapa['numero_factura'] as String?) ?? '',
        tratamientoId: mapa['tratamiento_id'] as int?,
        notas: (mapa['notas'] as String?) ?? '',
      );
}
