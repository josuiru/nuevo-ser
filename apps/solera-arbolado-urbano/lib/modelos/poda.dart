/// Actuación de poda sobre un árbol urbano. Es el evento más frecuente
/// en el día a día del operario y en los partes municipales — por eso
/// tiene tabla propia en lugar de mezclarse con tratamientos.
///
/// El campo `tipoPodaId` casa con el catálogo curado `tipos_poda.csv`
/// (formación, mantenimiento, saneamiento, refaldado, drástica…).
///
/// `volumenRestosM3` es estimación visual del volumen de restos
/// generados — útil para presupuestar el gasto de retirada y para
/// calcular m³ por jornada en el parte municipal.
///
/// `rutasFotosAntesJson` y `rutasFotosDespuesJson` se separan para que
/// el parte municipal pueda mostrar antes/después de cada actuación.
class Poda {
  final int? id;
  final int arbolId;
  final int? tecnicoId;
  final int fechaMs;
  final String tipoPodaId;
  final double? volumenRestosM3;
  final String motivo;
  final String rutasFotosAntesJson;
  final String rutasFotosDespuesJson;
  final String notas;

  Poda({
    this.id,
    required this.arbolId,
    this.tecnicoId,
    required this.fechaMs,
    this.tipoPodaId = '',
    this.volumenRestosM3,
    this.motivo = '',
    this.rutasFotosAntesJson = '[]',
    this.rutasFotosDespuesJson = '[]',
    this.notas = '',
  });

  Map<String, Object?> toMap() => {
        'id': id,
        'arbol_id': arbolId,
        'tecnico_id': tecnicoId,
        'fecha_ms': fechaMs,
        'tipo_poda_id': tipoPodaId,
        'volumen_restos_m3': volumenRestosM3,
        'motivo': motivo,
        'rutas_fotos_antes_json': rutasFotosAntesJson,
        'rutas_fotos_despues_json': rutasFotosDespuesJson,
        'notas': notas,
      };

  factory Poda.fromMap(Map<String, Object?> mapa) => Poda(
        id: mapa['id'] as int?,
        arbolId: mapa['arbol_id'] as int,
        tecnicoId: mapa['tecnico_id'] as int?,
        fechaMs: mapa['fecha_ms'] as int,
        tipoPodaId: (mapa['tipo_poda_id'] as String?) ?? '',
        volumenRestosM3: (mapa['volumen_restos_m3'] as num?)?.toDouble(),
        motivo: (mapa['motivo'] as String?) ?? '',
        rutasFotosAntesJson: (mapa['rutas_fotos_antes_json'] as String?) ?? '[]',
        rutasFotosDespuesJson: (mapa['rutas_fotos_despues_json'] as String?) ?? '[]',
        notas: (mapa['notas'] as String?) ?? '',
      );
}
