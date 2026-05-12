/// Apunte económico de gasto del viticultor/bodega. Categorías vid
/// concretas en `tipoGasto`: insumos vid (fertilizantes, abonos,
/// sulfatos), tratamientos fitosanitarios (con sinergia opcional al
/// libro PAC — cada apunte de tratamiento puede generar el apunte
/// de gasto correspondiente), vendimia (mano de obra estacional —
/// pico de gasto del año), embotellado (botella, corcho, cápsula),
/// etiquetado, barricas (compra y mantenimiento), maquinaria,
/// mano de obra (cuadrilla resto del año), combustible, seguros,
/// transporte, certificación (DOP/IGP/ecológico, recurrente
/// anual), otros.
///
/// Imputación a viñedo/variedad/general:
///  - 'vinedo_concreto' + vinedoId set → todo el gasto al viñedo.
///  - 'variedad_general' + variedadId set → gasto compartido entre
///    todas las parcelas con esa variedad (el extracto en v1 lista
///    el importe íntegro; el reparto proporcional por superficie
///    queda pendiente de validación de asesor fiscal).
///  - 'general' → gasto de la explotación, sin imputación concreta.
///
/// Importes en céntimos de euro.
class ApunteGasto {
  final int? id;
  final int fechaMs;
  final String concepto;

  /// 'insumos_vid' | 'tratamientos_fitosanitarios' | 'vendimia' |
  /// 'embotellado' | 'etiquetado' | 'barricas' | 'maquinaria' |
  /// 'mano_obra' | 'combustible' | 'seguros' | 'transporte' |
  /// 'certificacion' | 'otro'
  final String tipoGasto;

  final int importeBaseCentimos;

  /// IVA soportado en céntimos. Recuperable si el titular está en
  /// régimen general; NO recuperable si está en REAGP (caso típico
  /// en bodega pequeña).
  final int ivaSoportadoCentimos;

  /// 'vinedo_concreto' | 'variedad_general' | 'general'
  final String imputacion;

  /// Sólo significativo si imputacion == 'vinedo_concreto'.
  final int? vinedoId;

  /// Sólo significativo si imputacion == 'variedad_general'. String
  /// del catálogo de variedades.
  final String variedadId;

  /// Proveedor (FK opcional a `terceros`).
  final int? terceroId;

  final String rutaFotoFactura;
  final String numeroFactura;

  /// Atajo opcional al `tratamientos` que originó este gasto
  /// (sinergia clave: el apunte de tratamiento del libro PAC puede
  /// generar el apunte de gasto correspondiente). null si no
  /// procede.
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
    this.vinedoId,
    this.variedadId = '',
    this.terceroId,
    this.rutaFotoFactura = '',
    this.numeroFactura = '',
    this.tratamientoId,
    this.notas = '',
  });

  int get importeTotalCentimos => importeBaseCentimos + ivaSoportadoCentimos;

  bool get esVinedoConcreto =>
      imputacion == 'vinedo_concreto' && vinedoId != null;

  bool get esVariedadGeneral =>
      imputacion == 'variedad_general' && variedadId.isNotEmpty;

  Map<String, Object?> toMap() => {
        'id': id,
        'fecha_ms': fechaMs,
        'concepto': concepto,
        'tipo_gasto': tipoGasto,
        'importe_base_centimos': importeBaseCentimos,
        'iva_soportado_centimos': ivaSoportadoCentimos,
        'imputacion': imputacion,
        'vinedo_id': vinedoId,
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
        vinedoId: mapa['vinedo_id'] as int?,
        variedadId: (mapa['variedad_id'] as String?) ?? '',
        terceroId: mapa['tercero_id'] as int?,
        rutaFotoFactura: (mapa['ruta_foto_factura'] as String?) ?? '',
        numeroFactura: (mapa['numero_factura'] as String?) ?? '',
        tratamientoId: mapa['tratamiento_id'] as int?,
        notas: (mapa['notas'] as String?) ?? '',
      );
}
