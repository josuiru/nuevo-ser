/// Registro de cosecha asociado a una planta. Soporta dos unidades en
/// paralelo (kilos + número de unidades) porque para algunos cultivos
/// se mide uno o el otro o ambos: trufa se pesa, fruta se pesa y a veces
/// también se cuenta, granos como pistacho se pesan. Calidad opcional
/// 1-5 (libre interpretación por el operador).
class Cosecha {
  final int? id;
  final int plantaId;
  final int fechaMs;
  final double? kilos;
  final int? unidades;
  final int? calidad;
  final String rutasFotosJson;
  final String notas;

  Cosecha({
    this.id,
    required this.plantaId,
    required this.fechaMs,
    this.kilos,
    this.unidades,
    this.calidad,
    this.rutasFotosJson = '[]',
    this.notas = '',
  });

  Map<String, Object?> toMap() => {
        'id': id,
        'planta_id': plantaId,
        'fecha_ms': fechaMs,
        'kilos': kilos,
        'unidades': unidades,
        'calidad': calidad,
        'rutas_fotos_json': rutasFotosJson,
        'notas': notas,
      };

  factory Cosecha.fromMap(Map<String, Object?> mapa) => Cosecha(
        id: mapa['id'] as int?,
        plantaId: mapa['planta_id'] as int,
        fechaMs: mapa['fecha_ms'] as int,
        kilos: (mapa['kilos'] as num?)?.toDouble(),
        unidades: mapa['unidades'] as int?,
        calidad: mapa['calidad'] as int?,
        rutasFotosJson: (mapa['rutas_fotos_json'] as String?) ?? '[]',
        notas: (mapa['notas'] as String?) ?? '',
      );
}
