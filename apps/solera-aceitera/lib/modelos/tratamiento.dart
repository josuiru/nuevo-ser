/// Tratamiento fitosanitario aplicado a una parcela. Va al Cuaderno
/// PAC olivar (RD 1311/2012) — es trazabilidad obligatoria.
///
/// `sustanciaActivaId` viaja como texto (FK al catálogo
/// `fitosanitarios_olivar`) para no atar la BD a IDs numéricos de
/// catálogo que pueden cambiar al regenerar desde CSV. `productoComercial`
/// se guarda como referencia libre pero no es vinculante — la
/// trazabilidad real es la sustancia activa.
///
/// `carnetAplicadorNumero` es load-bearing para la trazabilidad
/// PAC — sin él la inspección OCA rechaza el cuaderno.
class Tratamiento {
  final int? id;
  final int parcelaId; // FK Parcela
  final int fechaMs;
  final String productoComercialReferencia;
  /// FK textual al catálogo `fitosanitarios_olivar`.
  final String sustanciaActivaId;
  final double dosisLitrosPorHa;
  /// FK textual al catálogo `plagas_olivo`. Vacío para tratamiento
  /// preventivo no dirigido.
  final String plagaObjetivoId;
  final String aplicadorNombre;
  final String carnetAplicadorNumero;
  final String observaciones;
  final String notas;
  final String rutasFotosJson;

  Tratamiento({
    this.id,
    required this.parcelaId,
    required this.fechaMs,
    this.productoComercialReferencia = '',
    this.sustanciaActivaId = '',
    this.dosisLitrosPorHa = 0,
    this.plagaObjetivoId = '',
    this.aplicadorNombre = '',
    this.carnetAplicadorNumero = '',
    this.observaciones = '',
    this.notas = '',
    this.rutasFotosJson = '[]',
  });

  Map<String, Object?> toMap() => {
        'id': id,
        'parcela_id': parcelaId,
        'fecha_ms': fechaMs,
        'producto_comercial_referencia': productoComercialReferencia,
        'sustancia_activa_id': sustanciaActivaId,
        'dosis_litros_por_ha': dosisLitrosPorHa,
        'plaga_objetivo_id': plagaObjetivoId,
        'aplicador_nombre': aplicadorNombre,
        'carnet_aplicador_numero': carnetAplicadorNumero,
        'observaciones': observaciones,
        'notas': notas,
        'rutas_fotos_json': rutasFotosJson,
      };

  factory Tratamiento.fromMap(Map<String, Object?> mapa) => Tratamiento(
        id: mapa['id'] as int?,
        parcelaId: (mapa['parcela_id'] as int?) ?? 0,
        fechaMs: (mapa['fecha_ms'] as int?) ?? 0,
        productoComercialReferencia:
            (mapa['producto_comercial_referencia'] as String?) ?? '',
        sustanciaActivaId: (mapa['sustancia_activa_id'] as String?) ?? '',
        dosisLitrosPorHa: (mapa['dosis_litros_por_ha'] as num?)?.toDouble() ?? 0,
        plagaObjetivoId: (mapa['plaga_objetivo_id'] as String?) ?? '',
        aplicadorNombre: (mapa['aplicador_nombre'] as String?) ?? '',
        carnetAplicadorNumero: (mapa['carnet_aplicador_numero'] as String?) ?? '',
        observaciones: (mapa['observaciones'] as String?) ?? '',
        notas: (mapa['notas'] as String?) ?? '',
        rutasFotosJson: (mapa['rutas_fotos_json'] as String?) ?? '[]',
      );
}
