/// Revisión rutinaria de la colmena. La visita típica del apicultor
/// donde se anota el estado del enjambre: presencia de reina, postura,
/// reservas, vector varroa.
///
/// Niveles 1-5 para postura/cría/miel/polen, donde 1 = mínimo o
/// nulo, 5 = excelente. Null si no se evaluó.
///
/// `varroaCaidaDiaria` es el conteo de varroa muerta caída en el
/// fondo en 24h (sticky board) — métrica clínica estándar para
/// estimar nivel de infestación.
class Revision {
  final int? id;
  final int colmenaId;
  final int fechaMs;

  /// `presente` | `ausente` | `no_observada`
  final String presenciaReina;

  final int? nivelPostura;
  final int? nivelCriaOperculada;
  final int? nivelMiel;
  final int? nivelPolen;
  final int? varroaCaidaDiaria;

  final String etiquetasJson;
  final String rutasFotosJson;
  final String notas;

  Revision({
    this.id,
    required this.colmenaId,
    required this.fechaMs,
    this.presenciaReina = 'no_observada',
    this.nivelPostura,
    this.nivelCriaOperculada,
    this.nivelMiel,
    this.nivelPolen,
    this.varroaCaidaDiaria,
    this.etiquetasJson = '[]',
    this.rutasFotosJson = '[]',
    this.notas = '',
  });

  Map<String, Object?> toMap() => {
        'id': id,
        'colmena_id': colmenaId,
        'fecha_ms': fechaMs,
        'presencia_reina': presenciaReina,
        'nivel_postura': nivelPostura,
        'nivel_cria_operculada': nivelCriaOperculada,
        'nivel_miel': nivelMiel,
        'nivel_polen': nivelPolen,
        'varroa_caida_diaria': varroaCaidaDiaria,
        'etiquetas_json': etiquetasJson,
        'rutas_fotos_json': rutasFotosJson,
        'notas': notas,
      };

  factory Revision.fromMap(Map<String, Object?> mapa) => Revision(
        id: mapa['id'] as int?,
        colmenaId: mapa['colmena_id'] as int,
        fechaMs: mapa['fecha_ms'] as int,
        presenciaReina: (mapa['presencia_reina'] as String?) ?? 'no_observada',
        nivelPostura: mapa['nivel_postura'] as int?,
        nivelCriaOperculada: mapa['nivel_cria_operculada'] as int?,
        nivelMiel: mapa['nivel_miel'] as int?,
        nivelPolen: mapa['nivel_polen'] as int?,
        varroaCaidaDiaria: mapa['varroa_caida_diaria'] as int?,
        etiquetasJson: (mapa['etiquetas_json'] as String?) ?? '[]',
        rutasFotosJson: (mapa['rutas_fotos_json'] as String?) ?? '[]',
        notas: (mapa['notas'] as String?) ?? '',
      );
}
