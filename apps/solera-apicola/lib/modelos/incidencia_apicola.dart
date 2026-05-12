/// Incidencia apícola: enfermedad, plaga, mortalidad, enjambrazón,
/// robo, ataque externo (vespa velutina, polilla cera), etc.
///
/// `tipo` clasifica gruesamente para estadística:
///  - 'sanitario' (varroa, nosema, loque, ascosferiosis…)
///  - 'mortalidad' (colmena descolmenada o muerte súbita)
///  - 'enjambrazon' (la colmena enjambró espontáneamente)
///  - 'robo' (otra colmena robó las reservas)
///  - 'vespa_velutina' (ataque de avispa asiática — plaga regulada)
///  - 'polilla_cera' (Galleria mellonella en cuadros almacenados)
///  - 'otro'
class IncidenciaApicola {
  final int? id;
  final int colmenaId;
  final int fechaMs;
  final String tipo;
  final String diagnostico;
  final int? severidad;
  final String rutasFotosJson;
  final String notas;
  final bool resuelta;
  final int? fechaResolucionMs;

  IncidenciaApicola({
    this.id,
    required this.colmenaId,
    required this.fechaMs,
    this.tipo = 'otro',
    this.diagnostico = '',
    this.severidad,
    this.rutasFotosJson = '[]',
    this.notas = '',
    this.resuelta = false,
    this.fechaResolucionMs,
  });

  Map<String, Object?> toMap() => {
        'id': id,
        'colmena_id': colmenaId,
        'fecha_ms': fechaMs,
        'tipo': tipo,
        'diagnostico': diagnostico,
        'severidad': severidad,
        'rutas_fotos_json': rutasFotosJson,
        'notas': notas,
        'resuelta': resuelta ? 1 : 0,
        'fecha_resolucion_ms': fechaResolucionMs,
      };

  factory IncidenciaApicola.fromMap(Map<String, Object?> mapa) => IncidenciaApicola(
        id: mapa['id'] as int?,
        colmenaId: mapa['colmena_id'] as int,
        fechaMs: mapa['fecha_ms'] as int,
        tipo: (mapa['tipo'] as String?) ?? 'otro',
        diagnostico: (mapa['diagnostico'] as String?) ?? '',
        severidad: mapa['severidad'] as int?,
        rutasFotosJson: (mapa['rutas_fotos_json'] as String?) ?? '[]',
        notas: (mapa['notas'] as String?) ?? '',
        resuelta: ((mapa['resuelta'] as int?) ?? 0) == 1,
        fechaResolucionMs: mapa['fecha_resolucion_ms'] as int?,
      );
}
