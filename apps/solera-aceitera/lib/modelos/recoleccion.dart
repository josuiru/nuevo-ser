/// Recolección — parte diario de aceituna recolectada de una parcela
/// concreta. La unidad operativa del olivar durante la campaña. Una
/// recolección puede generar una o varias PartidaAceituna (la misma
/// recolección puede llegar a la almazara en dos volquetes distintos).
class Recoleccion {
  final int? id;
  final int parcelaId; // FK Parcela
  final int campaniaId; // FK Campania
  final int fechaMs;
  final double kgEstimados;
  /// Uno de: `verde` / `envero` / `negra`.
  final String tipoAceituna;
  /// Uno de: `vibrador` / `manual` / `paraguas` / `peine` / `vareo`.
  final String metodo;
  final String cuadrilla;
  final String notas;
  final String rutasFotosJson;

  Recoleccion({
    this.id,
    required this.parcelaId,
    required this.campaniaId,
    required this.fechaMs,
    this.kgEstimados = 0,
    this.tipoAceituna = 'envero',
    this.metodo = 'vibrador',
    this.cuadrilla = '',
    this.notas = '',
    this.rutasFotosJson = '[]',
  });

  Map<String, Object?> toMap() => {
        'id': id,
        'parcela_id': parcelaId,
        'campania_id': campaniaId,
        'fecha_ms': fechaMs,
        'kg_estimados': kgEstimados,
        'tipo_aceituna': tipoAceituna,
        'metodo': metodo,
        'cuadrilla': cuadrilla,
        'notas': notas,
        'rutas_fotos_json': rutasFotosJson,
      };

  factory Recoleccion.fromMap(Map<String, Object?> mapa) => Recoleccion(
        id: mapa['id'] as int?,
        parcelaId: (mapa['parcela_id'] as int?) ?? 0,
        campaniaId: (mapa['campania_id'] as int?) ?? 0,
        fechaMs: (mapa['fecha_ms'] as int?) ?? 0,
        kgEstimados: (mapa['kg_estimados'] as num?)?.toDouble() ?? 0,
        tipoAceituna: (mapa['tipo_aceituna'] as String?) ?? 'envero',
        metodo: (mapa['metodo'] as String?) ?? 'vibrador',
        cuadrilla: (mapa['cuadrilla'] as String?) ?? '',
        notas: (mapa['notas'] as String?) ?? '',
        rutasFotosJson: (mapa['rutas_fotos_json'] as String?) ?? '[]',
      );
}
