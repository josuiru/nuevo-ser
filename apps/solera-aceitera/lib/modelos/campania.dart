/// Campaña olivarera — año comercial de aceituna y aceite. Análogo a
/// Cosecha en viticultura. Habitualmente arranca el 1 de octubre y
/// termina el 31 de marzo del año siguiente.
///
/// `anyoComercial` corresponde al año en que se ANUNCIA la campaña
/// (campaña 2026/2027 → `anyoComercial = 2026`). Convención AICA y
/// PAC olivar.
class Campania {
  final int? id;
  final int olivarId; // FK Olivar
  final int anyoComercial;
  final int fechaInicioMs;
  final int? fechaFinMs;
  final double produccionTotalKgAceituna;
  final double produccionTotalKgAceite;
  /// Rendimiento medio aceite/aceituna en porcentaje (típico 18-22 %).
  final double rendimientoMedioPorcentaje;
  final String observacionesMeteorologicas;
  final String notas;

  Campania({
    this.id,
    required this.olivarId,
    required this.anyoComercial,
    required this.fechaInicioMs,
    this.fechaFinMs,
    this.produccionTotalKgAceituna = 0,
    this.produccionTotalKgAceite = 0,
    this.rendimientoMedioPorcentaje = 0,
    this.observacionesMeteorologicas = '',
    this.notas = '',
  });

  /// `true` si la campaña sigue abierta (sin fecha de cierre).
  bool get estaAbierta => fechaFinMs == null;

  Map<String, Object?> toMap() => {
        'id': id,
        'olivar_id': olivarId,
        'anyo_comercial': anyoComercial,
        'fecha_inicio_ms': fechaInicioMs,
        'fecha_fin_ms': fechaFinMs,
        'produccion_total_kg_aceituna': produccionTotalKgAceituna,
        'produccion_total_kg_aceite': produccionTotalKgAceite,
        'rendimiento_medio_porcentaje': rendimientoMedioPorcentaje,
        'observaciones_meteorologicas': observacionesMeteorologicas,
        'notas': notas,
      };

  factory Campania.fromMap(Map<String, Object?> mapa) => Campania(
        id: mapa['id'] as int?,
        olivarId: (mapa['olivar_id'] as int?) ?? 0,
        anyoComercial: (mapa['anyo_comercial'] as int?) ?? 0,
        fechaInicioMs: (mapa['fecha_inicio_ms'] as int?) ?? 0,
        fechaFinMs: mapa['fecha_fin_ms'] as int?,
        produccionTotalKgAceituna: (mapa['produccion_total_kg_aceituna'] as num?)?.toDouble() ?? 0,
        produccionTotalKgAceite: (mapa['produccion_total_kg_aceite'] as num?)?.toDouble() ?? 0,
        rendimientoMedioPorcentaje: (mapa['rendimiento_medio_porcentaje'] as num?)?.toDouble() ?? 0,
        observacionesMeteorologicas: (mapa['observaciones_meteorologicas'] as String?) ?? '',
        notas: (mapa['notas'] as String?) ?? '',
      );
}
