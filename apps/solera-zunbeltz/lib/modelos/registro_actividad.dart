import 'constantes.dart';

/// Un registro de actividad del seguimiento del testaje: alimentación (kg),
/// pariciones (nº) o productos comercializados (uds/kg). Modelo ligero —
/// el cuaderno ganadero completo (animales con crotal/DIB) es una fase
/// posterior. El lote/rebaño es texto libre por ahora.
class RegistroActividad {
  RegistroActividad({
    this.id,
    required this.fincaId,
    this.tipo = tipoActividadPorDefecto,
    this.cantidad = 0,
    this.fechaMs = 0,
    this.lote = '',
    this.notas = '',
    this.fechaCreacionMs = 0,
  });

  final int? id;
  final int fincaId;

  /// Código de `tiposActividad` (alimentacion / paricion / producto).
  final String tipo;

  /// Cantidad en la unidad propia del tipo (kg de pienso, nº de crías,
  /// uds comercializadas). Ver `unidadActividad`.
  final double cantidad;

  final int fechaMs;
  final String lote;
  final String notas;
  final int fechaCreacionMs;

  Map<String, Object?> toMap() => {
        'id': id,
        'finca_id': fincaId,
        'tipo': tipo,
        'cantidad': cantidad,
        'fecha_ms': fechaMs,
        'lote': lote,
        'notas': notas,
        'fecha_creacion_ms': fechaCreacionMs,
      };

  factory RegistroActividad.fromMap(Map<String, Object?> mapa) =>
      RegistroActividad(
        id: mapa['id'] as int?,
        fincaId: (mapa['finca_id'] as int?) ?? 0,
        tipo: (mapa['tipo'] as String?) ?? tipoActividadPorDefecto,
        cantidad: (mapa['cantidad'] as num?)?.toDouble() ?? 0,
        fechaMs: (mapa['fecha_ms'] as int?) ?? 0,
        lote: (mapa['lote'] as String?) ?? '',
        notas: (mapa['notas'] as String?) ?? '',
        fechaCreacionMs: (mapa['fecha_creacion_ms'] as int?) ?? 0,
      );
}
