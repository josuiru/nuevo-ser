/// Analítica — control de calidad microbiológico, físico-químico o
/// sensorial. Puede referirse a un lote de producción (leche o queso)
/// o ser un control de rutina (agua, superficies).
class Analitica {
  final int? id;
  final int fechaMs;
  final String tipo; // microbiologica / fisico_quimica / sensorial / agua / superficie
  final String laboratorio;
  final int? loteProduccionId; // nullable: control general no asociado a lote
  final String parametrosJson; // {"parametro": "valor", ...}
  final bool conforme;
  final String notas;

  Analitica({
    this.id,
    required this.fechaMs,
    required this.tipo,
    this.laboratorio = '',
    this.loteProduccionId,
    this.parametrosJson = '{}',
    this.conforme = true,
    this.notas = '',
  });

  Map<String, Object?> toMap() => {
        'id': id,
        'fecha_ms': fechaMs,
        'tipo': tipo,
        'laboratorio': laboratorio,
        'lote_produccion_id': loteProduccionId,
        'parametros_json': parametrosJson,
        'conforme': conforme ? 1 : 0,
        'notas': notas,
      };

  factory Analitica.fromMap(Map<String, Object?> mapa) => Analitica(
        id: mapa['id'] as int?,
        fechaMs: mapa['fecha_ms'] as int,
        tipo: (mapa['tipo'] as String?) ?? '',
        laboratorio: (mapa['laboratorio'] as String?) ?? '',
        loteProduccionId: mapa['lote_produccion_id'] as int?,
        parametrosJson: (mapa['parametros_json'] as String?) ?? '{}',
        conforme: (mapa['conforme'] as int?) == 1,
        notas: (mapa['notas'] as String?) ?? '',
      );
}
