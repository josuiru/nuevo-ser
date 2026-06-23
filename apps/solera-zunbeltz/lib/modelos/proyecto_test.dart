/// Un proyecto de test: el proceso que prueba una persona tester en el
/// Espacio Test. Es el eje del seguimiento (producción, validación de
/// producto, comercialización y económico se cuelgan del proyecto). La
/// finca es de apoyo (dónde lo desarrolla), opcional.
class ProyectoTest {
  ProyectoTest({
    this.id,
    this.nombre = '',
    this.persona = '',
    this.actividad = '',
    this.fincaId,
    this.fechaInicioMs,
    this.fechaFinMs,
    this.notas = '',
    this.fechaCreacionMs = 0,
  });

  final int? id;

  /// Nombre del proyecto de test.
  final String nombre;

  /// Persona tester que lo lleva.
  final String persona;

  /// Actividad o vertical productiva (p. ej. «ovino de leche», «huerta»).
  final String actividad;

  /// Finca de apoyo donde se desarrolla (opcional).
  final int? fincaId;

  final int? fechaInicioMs;
  final int? fechaFinMs;
  final String notas;
  final int fechaCreacionMs;

  Map<String, Object?> toMap() => {
        'id': id,
        'nombre': nombre,
        'persona': persona,
        'actividad': actividad,
        'finca_id': fincaId,
        'fecha_inicio_ms': fechaInicioMs,
        'fecha_fin_ms': fechaFinMs,
        'notas': notas,
        'fecha_creacion_ms': fechaCreacionMs,
      };

  factory ProyectoTest.fromMap(Map<String, Object?> mapa) => ProyectoTest(
        id: mapa['id'] as int?,
        nombre: (mapa['nombre'] as String?) ?? '',
        persona: (mapa['persona'] as String?) ?? '',
        actividad: (mapa['actividad'] as String?) ?? '',
        fincaId: mapa['finca_id'] as int?,
        fechaInicioMs: mapa['fecha_inicio_ms'] as int?,
        fechaFinMs: mapa['fecha_fin_ms'] as int?,
        notas: (mapa['notas'] as String?) ?? '',
        fechaCreacionMs: (mapa['fecha_creacion_ms'] as int?) ?? 0,
      );
}
