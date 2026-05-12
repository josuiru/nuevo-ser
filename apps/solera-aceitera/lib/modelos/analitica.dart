/// Analítica de un lote de aceite. Encapsula los controles que pide
/// la categorización oficial del aceite (acidez, peróxidos, K232, K270,
/// panel test) más los voluntarios que aportan valor comercial
/// (polifenoles, color, humedad).
///
/// Los mismos parámetros viven duplicados en `LoteAceite` (campos
/// directos) para acceso rápido sin join — la analítica registra
/// **cuándo** se hizo el control, **qué laboratorio** y la traza
/// histórica si se hace más de un control al lote a lo largo del año.
class Analitica {
  final int? id;
  final int loteAceiteId; // FK LoteAceite
  final int fechaMs;
  final double? acidez;
  final double? peroxidos;
  final double? k232;
  final double? k270;
  final double? polifenolesMgKg;
  /// Saturación visual (0..100) — opcional, evaluación rápida del operador.
  final double? color;
  /// Humedad % — útil para detectar agua arrastrada del decanter.
  final double? humedad;
  /// Puntuación panel test 0..9.
  final double? panelTestPuntuacion;
  final String panelTestNotas;
  /// Nombre del laboratorio que firma el análisis.
  final String laboratorio;
  final String notas;

  Analitica({
    this.id,
    required this.loteAceiteId,
    required this.fechaMs,
    this.acidez,
    this.peroxidos,
    this.k232,
    this.k270,
    this.polifenolesMgKg,
    this.color,
    this.humedad,
    this.panelTestPuntuacion,
    this.panelTestNotas = '',
    this.laboratorio = '',
    this.notas = '',
  });

  Map<String, Object?> toMap() => {
        'id': id,
        'lote_aceite_id': loteAceiteId,
        'fecha_ms': fechaMs,
        'acidez': acidez,
        'peroxidos': peroxidos,
        'k232': k232,
        'k270': k270,
        'polifenoles_mg_kg': polifenolesMgKg,
        'color': color,
        'humedad': humedad,
        'panel_test_puntuacion': panelTestPuntuacion,
        'panel_test_notas': panelTestNotas,
        'laboratorio': laboratorio,
        'notas': notas,
      };

  factory Analitica.fromMap(Map<String, Object?> mapa) => Analitica(
        id: mapa['id'] as int?,
        loteAceiteId: (mapa['lote_aceite_id'] as int?) ?? 0,
        fechaMs: (mapa['fecha_ms'] as int?) ?? 0,
        acidez: (mapa['acidez'] as num?)?.toDouble(),
        peroxidos: (mapa['peroxidos'] as num?)?.toDouble(),
        k232: (mapa['k232'] as num?)?.toDouble(),
        k270: (mapa['k270'] as num?)?.toDouble(),
        polifenolesMgKg: (mapa['polifenoles_mg_kg'] as num?)?.toDouble(),
        color: (mapa['color'] as num?)?.toDouble(),
        humedad: (mapa['humedad'] as num?)?.toDouble(),
        panelTestPuntuacion: (mapa['panel_test_puntuacion'] as num?)?.toDouble(),
        panelTestNotas: (mapa['panel_test_notas'] as String?) ?? '',
        laboratorio: (mapa['laboratorio'] as String?) ?? '',
        notas: (mapa['notas'] as String?) ?? '',
      );
}
