import 'constantes.dart';

/// Una operación de comercialización de un proyecto de test: una venta o
/// salida al mercado, con su canal, producto, cantidad, precio e ingreso.
/// Es la experiencia de comercialización que pide la memoria.
class RegistroComercializacion {
  RegistroComercializacion({
    this.id,
    required this.proyectoId,
    this.fechaMs = 0,
    this.producto = '',
    this.canal = canalComercializacionPorDefecto,
    this.cantidad = 0,
    this.unidad = 'uds',
    this.precioUnitarioCentimos = 0,
    this.ingresoCentimos = 0,
    this.ivaPorcentaje = 0,
    this.notas = '',
    this.fechaCreacionMs = 0,
  });

  final int? id;
  final int proyectoId;
  final int fechaMs;

  final String producto;

  /// Código de `canalesComercializacion` (directa, mercado, tienda, online…).
  final String canal;

  final double cantidad;
  final String unidad;

  /// Precio por unidad, en céntimos.
  final int precioUnitarioCentimos;

  /// Ingreso total de la operación, en céntimos (normalmente cantidad ×
  /// precio, pero se guarda explícito por si hay descuentos o lotes).
  final int ingresoCentimos;

  /// Tipo de IVA aplicado (%); 0 = sin IVA. El ingreso es el total (con IVA).
  final int ivaPorcentaje;

  final String notas;
  final int fechaCreacionMs;

  Map<String, Object?> toMap() => {
        'id': id,
        'proyecto_id': proyectoId,
        'fecha_ms': fechaMs,
        'producto': producto,
        'canal': canal,
        'cantidad': cantidad,
        'unidad': unidad,
        'precio_unitario_centimos': precioUnitarioCentimos,
        'ingreso_centimos': ingresoCentimos,
        'iva_porcentaje': ivaPorcentaje,
        'notas': notas,
        'fecha_creacion_ms': fechaCreacionMs,
      };

  factory RegistroComercializacion.fromMap(Map<String, Object?> mapa) =>
      RegistroComercializacion(
        id: mapa['id'] as int?,
        proyectoId: (mapa['proyecto_id'] as int?) ?? 0,
        fechaMs: (mapa['fecha_ms'] as int?) ?? 0,
        producto: (mapa['producto'] as String?) ?? '',
        canal: (mapa['canal'] as String?) ?? canalComercializacionPorDefecto,
        cantidad: (mapa['cantidad'] as num?)?.toDouble() ?? 0,
        unidad: (mapa['unidad'] as String?) ?? 'uds',
        precioUnitarioCentimos: (mapa['precio_unitario_centimos'] as int?) ?? 0,
        ingresoCentimos: (mapa['ingreso_centimos'] as int?) ?? 0,
        ivaPorcentaje: (mapa['iva_porcentaje'] as int?) ?? 0,
        notas: (mapa['notas'] as String?) ?? '',
        fechaCreacionMs: (mapa['fecha_creacion_ms'] as int?) ?? 0,
      );
}
