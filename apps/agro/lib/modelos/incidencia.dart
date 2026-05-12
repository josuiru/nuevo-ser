/// Incidencia: plaga, enfermedad o estrés detectado en la planta.
/// Diferencia de `Observacion` porque exige diagnóstico (free-text en
/// v1, contra catálogo curado en F2) y severidad. La IA por foto en F2
/// rellenará automáticamente `diagnostico` y propondrá tratamientos.
///
/// `severidad` 1..5: 1 leve, 5 muy grave/crítica. Null si pendiente
/// de evaluar.
/// `tipo` clasifica gruesamente para estadística: 'plaga' |
/// 'enfermedad' | 'estres' | 'fisiologico' | 'otro'. La granularidad
/// fina vive en `diagnostico`.
class Incidencia {
  final int? id;
  final int plantaId;
  final int fechaMs;
  final String tipo;
  final String diagnostico;
  final int? severidad;
  final String rutasFotosJson;
  final String notas;
  final bool resuelta;
  final int? fechaResolucionMs;

  Incidencia({
    this.id,
    required this.plantaId,
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
        'planta_id': plantaId,
        'fecha_ms': fechaMs,
        'tipo': tipo,
        'diagnostico': diagnostico,
        'severidad': severidad,
        'rutas_fotos_json': rutasFotosJson,
        'notas': notas,
        'resuelta': resuelta ? 1 : 0,
        'fecha_resolucion_ms': fechaResolucionMs,
      };

  factory Incidencia.fromMap(Map<String, Object?> mapa) => Incidencia(
        id: mapa['id'] as int?,
        plantaId: mapa['planta_id'] as int,
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
