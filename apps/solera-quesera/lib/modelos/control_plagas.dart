/// Control de plagas — registro APPCC de gestión de plagas.
class ControlPlagas {
  final int? id;
  final int fechaMs;
  final String tipo; // roedores / insectos / aves / otras
  final String medida; // cebo / trampa / barrera / tratamiento / inspeccion
  final String responsable;
  final String resultado;
  final int? proximaRevisionMs;
  final String notas;

  ControlPlagas({
    this.id,
    required this.fechaMs,
    required this.tipo,
    this.medida = '',
    this.responsable = '',
    this.resultado = '',
    this.proximaRevisionMs,
    this.notas = '',
  });

  Map<String, Object?> toMap() => {
        'id': id,
        'fecha_ms': fechaMs,
        'tipo': tipo,
        'medida': medida,
        'responsable': responsable,
        'resultado': resultado,
        'proxima_revision_ms': proximaRevisionMs,
        'notas': notas,
      };

  factory ControlPlagas.fromMap(Map<String, Object?> mapa) => ControlPlagas(
        id: mapa['id'] as int?,
        fechaMs: mapa['fecha_ms'] as int,
        tipo: (mapa['tipo'] as String?) ?? '',
        medida: (mapa['medida'] as String?) ?? '',
        responsable: (mapa['responsable'] as String?) ?? '',
        resultado: (mapa['resultado'] as String?) ?? '',
        proximaRevisionMs: mapa['proxima_revision_ms'] as int?,
        notas: (mapa['notas'] as String?) ?? '',
      );
}
