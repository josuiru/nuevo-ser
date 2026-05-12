/// Apunte económico de gasto. Categorías agro concretas en
/// `tipoGasto`: insumos (semillas, plantones, fertilizantes,
/// abonos), tratamientos fitosanitarios (con sinergia opcional al
/// cuaderno MAPA — cada apunte de tratamiento puede generar el
/// apunte de gasto correspondiente), maquinaria, mano de obra,
/// combustible, seguros (seguro agrario es típico), riego/agua
/// (canon, electricidad bombeo), transporte, veterinario animal
/// (para los que tienen ganado en dehesa), certificación
/// (DOP/IGP/ecológico, coste recurrente), otros.
///
/// Imputación a parcela/cultivo/general:
///  - 'finca_concreta' + fincaId set → todo el gasto a la parcela.
///  - 'cultivo_general' + cultivoId set → gasto compartido entre
///    todas las parcelas con ese cultivo (el extracto en v1 lista
///    el importe íntegro; el reparto proporcional por hectárea
///    queda pendiente de validación de asesor fiscal).
///  - 'general' → gasto de la explotación, sin imputación concreta.
///
/// Importes en céntimos de euro (mismo motivo que ApunteIngreso).
class ApunteGasto {
  final int? id;
  final int fechaMs;
  final String concepto;

  /// 'insumos' | 'tratamientos_fitosanitarios' | 'maquinaria' |
  /// 'mano_obra' | 'combustible' | 'seguros' | 'riego_agua' |
  /// 'transporte' | 'veterinario_animal' | 'certificacion' | 'otro'
  final String tipoGasto;

  final int importeBaseCentimos;

  /// IVA soportado en céntimos. Recuperable si el titular está en
  /// régimen general; NO recuperable si está en REAGP (caso típico
  /// en agricultor pequeño/mediano — el IVA soportado se imputa
  /// como mayor coste).
  final int ivaSoportadoCentimos;

  /// 'finca_concreta' | 'cultivo_general' | 'general'
  final String imputacion;

  /// Sólo significativo si imputacion == 'finca_concreta'.
  final int? fincaId;

  /// Sólo significativo si imputacion == 'cultivo_general'. String
  /// del catálogo de cultivos (`catalogoCultivos[].id`).
  final String cultivoId;

  /// Proveedor (FK opcional a `terceros`).
  final int? terceroId;

  final String rutaFotoFactura;
  final String numeroFactura;

  /// Atajo opcional al `tratamientos` que originó este gasto
  /// (sinergia clave: el apunte de tratamiento del cuaderno MAPA
  /// puede generar el apunte de gasto correspondiente). null si no
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
    this.fincaId,
    this.cultivoId = '',
    this.terceroId,
    this.rutaFotoFactura = '',
    this.numeroFactura = '',
    this.tratamientoId,
    this.notas = '',
  });

  int get importeTotalCentimos => importeBaseCentimos + ivaSoportadoCentimos;

  bool get esFincaConcreta =>
      imputacion == 'finca_concreta' && fincaId != null;

  bool get esCultivoGeneral =>
      imputacion == 'cultivo_general' && cultivoId.isNotEmpty;

  Map<String, Object?> toMap() => {
        'id': id,
        'fecha_ms': fechaMs,
        'concepto': concepto,
        'tipo_gasto': tipoGasto,
        'importe_base_centimos': importeBaseCentimos,
        'iva_soportado_centimos': ivaSoportadoCentimos,
        'imputacion': imputacion,
        'finca_id': fincaId,
        'cultivo_id': cultivoId,
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
        fincaId: mapa['finca_id'] as int?,
        cultivoId: (mapa['cultivo_id'] as String?) ?? '',
        terceroId: mapa['tercero_id'] as int?,
        rutaFotoFactura: (mapa['ruta_foto_factura'] as String?) ?? '',
        numeroFactura: (mapa['numero_factura'] as String?) ?? '',
        tratamientoId: mapa['tratamiento_id'] as int?,
        notas: (mapa['notas'] as String?) ?? '',
      );
}
