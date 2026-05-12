/// Apunte económico de gasto. Categorías apícolas concretas en
/// `tipoGasto`: alimentación (azúcar, candy, sustitutos polen),
/// sanidad varroa (sustancias activas, otros productos veterinarios),
/// material (cuadros, cera estampada, alzas, reinas, núcleos),
/// transporte trashumancia, mano de obra, veterinario, seguros,
/// combustible, otros.
///
/// La trashumancia es la complicación apícola: un mismo apunte de
/// transporte puede afectar a varios colmenares a la vez. Por eso
/// `imputacion`:
///  - 'colmenar_concreto' + apiarioId set → todo el gasto al colmenar.
///  - 'reparto_proporcional' → el extracto reparte el gasto entre
///    colmenares activos proporcional al número de colmenas vivas
///    en cada uno en el momento de la fecha del gasto.
///  - 'general' → gasto de la explotación, sin imputación a colmenar.
///
/// Importes en céntimos de euro (mismo motivo que ApunteIngreso).
class ApunteGasto {
  final int? id;
  final int fechaMs;
  final String concepto;

  /// 'alimentacion' | 'sanidad_varroa' | 'material' |
  /// 'transporte_trashumancia' | 'mano_obra' | 'veterinario' |
  /// 'seguros' | 'combustible' | 'otro'
  final String tipoGasto;

  final int importeBaseCentimos;

  /// IVA soportado en céntimos. Recuperable si el titular está en
  /// régimen general; NO recuperable si está en REAGP (caso típico
  /// en apicultura mediana — el IVA soportado se imputa como mayor
  /// coste).
  final int ivaSoportadoCentimos;

  /// 'colmenar_concreto' | 'reparto_proporcional' | 'general'
  final String imputacion;

  /// Sólo significativo si imputacion == 'colmenar_concreto'.
  final int? apiarioId;

  /// Proveedor (FK opcional a `terceros`).
  final int? terceroId;

  final String rutaFotoFactura;
  final String numeroFactura;

  /// Atajo opcional al `tratamientos_varroa` que originó este gasto
  /// (sinergia: el apunte de tratamiento del libro REGA puede
  /// generar el apunte de gasto correspondiente). null si no procede.
  final int? tratamientoVarroaId;

  final String notas;

  ApunteGasto({
    this.id,
    required this.fechaMs,
    this.concepto = '',
    this.tipoGasto = 'otro',
    this.importeBaseCentimos = 0,
    this.ivaSoportadoCentimos = 0,
    this.imputacion = 'general',
    this.apiarioId,
    this.terceroId,
    this.rutaFotoFactura = '',
    this.numeroFactura = '',
    this.tratamientoVarroaId,
    this.notas = '',
  });

  int get importeTotalCentimos => importeBaseCentimos + ivaSoportadoCentimos;

  bool get tieneRepartoProporcional => imputacion == 'reparto_proporcional';
  bool get esColmenarConcreto =>
      imputacion == 'colmenar_concreto' && apiarioId != null;

  Map<String, Object?> toMap() => {
        'id': id,
        'fecha_ms': fechaMs,
        'concepto': concepto,
        'tipo_gasto': tipoGasto,
        'importe_base_centimos': importeBaseCentimos,
        'iva_soportado_centimos': ivaSoportadoCentimos,
        'imputacion': imputacion,
        'apiario_id': apiarioId,
        'tercero_id': terceroId,
        'ruta_foto_factura': rutaFotoFactura,
        'numero_factura': numeroFactura,
        'tratamiento_varroa_id': tratamientoVarroaId,
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
        apiarioId: mapa['apiario_id'] as int?,
        terceroId: mapa['tercero_id'] as int?,
        rutaFotoFactura: (mapa['ruta_foto_factura'] as String?) ?? '',
        numeroFactura: (mapa['numero_factura'] as String?) ?? '',
        tratamientoVarroaId: mapa['tratamiento_varroa_id'] as int?,
        notas: (mapa['notas'] as String?) ?? '',
      );
}
