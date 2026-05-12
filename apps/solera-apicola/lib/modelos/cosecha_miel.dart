/// Registro de cosecha apícola: miel, cera, polen, propóleo, jalea
/// real. Apicultor profesional pesa todas las salidas porque la
/// trazabilidad SITRAN-AP lo exige para la miel y el polen vendido
/// al canal de alimentación humana.
///
/// `kilosMiel` es el principal pero los demás también son ingresos.
/// `numeroAlza` opcional: identificador del alza si se cosecha por
/// alza separada (típico en Dadant y Langstroth).
class CosechaMiel {
  final int? id;
  final int colmenaId;
  final int fechaMs;
  final double? kilosMiel;
  final double? kilosCera;
  final double? kilosPolen;
  final double? kilosPropoleo;
  final double? kilosJaleaReal;
  final int? numeroAlza;
  final int? calidad;
  final String rutasFotosJson;
  final String notas;

  CosechaMiel({
    this.id,
    required this.colmenaId,
    required this.fechaMs,
    this.kilosMiel,
    this.kilosCera,
    this.kilosPolen,
    this.kilosPropoleo,
    this.kilosJaleaReal,
    this.numeroAlza,
    this.calidad,
    this.rutasFotosJson = '[]',
    this.notas = '',
  });

  Map<String, Object?> toMap() => {
        'id': id,
        'colmena_id': colmenaId,
        'fecha_ms': fechaMs,
        'kilos_miel': kilosMiel,
        'kilos_cera': kilosCera,
        'kilos_polen': kilosPolen,
        'kilos_propoleo': kilosPropoleo,
        'kilos_jalea_real': kilosJaleaReal,
        'numero_alza': numeroAlza,
        'calidad': calidad,
        'rutas_fotos_json': rutasFotosJson,
        'notas': notas,
      };

  factory CosechaMiel.fromMap(Map<String, Object?> mapa) => CosechaMiel(
        id: mapa['id'] as int?,
        colmenaId: mapa['colmena_id'] as int,
        fechaMs: mapa['fecha_ms'] as int,
        kilosMiel: (mapa['kilos_miel'] as num?)?.toDouble(),
        kilosCera: (mapa['kilos_cera'] as num?)?.toDouble(),
        kilosPolen: (mapa['kilos_polen'] as num?)?.toDouble(),
        kilosPropoleo: (mapa['kilos_propoleo'] as num?)?.toDouble(),
        kilosJaleaReal: (mapa['kilos_jalea_real'] as num?)?.toDouble(),
        numeroAlza: mapa['numero_alza'] as int?,
        calidad: mapa['calidad'] as int?,
        rutasFotosJson: (mapa['rutas_fotos_json'] as String?) ?? '[]',
        notas: (mapa['notas'] as String?) ?? '',
      );
}
