/// Formación — registro APPCC de formación del personal.
class Formacion {
  final int? id;
  final String empleado;
  final int fechaMs;
  final String tipo; // higiene / appcc / trazabilidad / do / manipuladorAlimentos
  final String impartidoPor;
  final int duracionMinutos;
  final String documento;
  final String notas;

  Formacion({
    this.id,
    required this.empleado,
    required this.fechaMs,
    required this.tipo,
    this.impartidoPor = '',
    this.duracionMinutos = 0,
    this.documento = '',
    this.notas = '',
  });

  Map<String, Object?> toMap() => {
        'id': id,
        'empleado': empleado,
        'fecha_ms': fechaMs,
        'tipo': tipo,
        'impartido_por': impartidoPor,
        'duracion_minutos': duracionMinutos,
        'documento': documento,
        'notas': notas,
      };

  factory Formacion.fromMap(Map<String, Object?> mapa) => Formacion(
        id: mapa['id'] as int?,
        empleado: (mapa['empleado'] as String?) ?? '',
        fechaMs: mapa['fecha_ms'] as int,
        tipo: (mapa['tipo'] as String?) ?? '',
        impartidoPor: (mapa['impartido_por'] as String?) ?? '',
        duracionMinutos: (mapa['duracion_minutos'] as int?) ?? 0,
        documento: (mapa['documento'] as String?) ?? '',
        notas: (mapa['notas'] as String?) ?? '',
      );
}
