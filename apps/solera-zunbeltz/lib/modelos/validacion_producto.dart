import 'constantes.dart';

/// Una prueba de validación de producto de un proyecto de test: qué se
/// validó (una receta, un formato, una calidad…), con qué resultado y
/// valoración. Recoge la validación de producto que pide la memoria.
class ValidacionProducto {
  ValidacionProducto({
    this.id,
    required this.proyectoId,
    this.fechaMs = 0,
    this.descripcion = '',
    this.resultado = resultadoValidacionPorDefecto,
    this.valoracion = 0,
    this.notas = '',
    this.fechaCreacionMs = 0,
  });

  final int? id;
  final int proyectoId;
  final int fechaMs;

  /// Qué se ha validado.
  final String descripcion;

  /// Código de `resultadosValidacion` (validado / ajustar / descartar).
  final String resultado;

  /// Valoración de 0 (sin valorar) a 5.
  final int valoracion;

  final String notas;
  final int fechaCreacionMs;

  Map<String, Object?> toMap() => {
        'id': id,
        'proyecto_id': proyectoId,
        'fecha_ms': fechaMs,
        'descripcion': descripcion,
        'resultado': resultado,
        'valoracion': valoracion,
        'notas': notas,
        'fecha_creacion_ms': fechaCreacionMs,
      };

  factory ValidacionProducto.fromMap(Map<String, Object?> mapa) =>
      ValidacionProducto(
        id: mapa['id'] as int?,
        proyectoId: (mapa['proyecto_id'] as int?) ?? 0,
        fechaMs: (mapa['fecha_ms'] as int?) ?? 0,
        descripcion: (mapa['descripcion'] as String?) ?? '',
        resultado:
            (mapa['resultado'] as String?) ?? resultadoValidacionPorDefecto,
        valoracion: (mapa['valoracion'] as int?) ?? 0,
        notas: (mapa['notas'] as String?) ?? '',
        fechaCreacionMs: (mapa['fecha_creacion_ms'] as int?) ?? 0,
      );
}
