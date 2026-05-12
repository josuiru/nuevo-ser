/// Partida de leche — cada recepción diaria de leche en la quesería.
/// Una partida puede ser de un proveedor externo o del rebaño propio.
class PartidaLeche {
  final int? id;
  final int proveedorId;
  final int fechaMs;
  final double volumenLitros;
  final double? temperaturaRecepcion;
  final double? ph;
  final double? grasa;
  final double? proteina;
  final double? extractoSeco;
  final double? celulasSomaticas;
  final double? bacterias;
  final bool antibioticosPositivos;
  final String incidencia;
  final String notas;

  PartidaLeche({
    this.id,
    required this.proveedorId,
    required this.fechaMs,
    required this.volumenLitros,
    this.temperaturaRecepcion,
    this.ph,
    this.grasa,
    this.proteina,
    this.extractoSeco,
    this.celulasSomaticas,
    this.bacterias,
    this.antibioticosPositivos = false,
    this.incidencia = '',
    this.notas = '',
  });

  Map<String, Object?> toMap() => {
        'id': id,
        'proveedor_id': proveedorId,
        'fecha_ms': fechaMs,
        'volumen_litros': volumenLitros,
        'temperatura_recepcion': temperaturaRecepcion,
        'ph': ph,
        'grasa': grasa,
        'proteina': proteina,
        'extracto_seco': extractoSeco,
        'celulas_somaticas': celulasSomaticas,
        'bacterias': bacterias,
        'antibioticos_positivos': antibioticosPositivos ? 1 : 0,
        'incidencia': incidencia,
        'notas': notas,
      };

  factory PartidaLeche.fromMap(Map<String, Object?> mapa) => PartidaLeche(
        id: mapa['id'] as int?,
        proveedorId: mapa['proveedor_id'] as int,
        fechaMs: mapa['fecha_ms'] as int,
        volumenLitros: (mapa['volumen_litros'] as num).toDouble(),
        temperaturaRecepcion: (mapa['temperatura_recepcion'] as num?)?.toDouble(),
        ph: (mapa['ph'] as num?)?.toDouble(),
        grasa: (mapa['grasa'] as num?)?.toDouble(),
        proteina: (mapa['proteina'] as num?)?.toDouble(),
        extractoSeco: (mapa['extracto_seco'] as num?)?.toDouble(),
        celulasSomaticas: (mapa['celulas_somaticas'] as num?)?.toDouble(),
        bacterias: (mapa['bacterias'] as num?)?.toDouble(),
        antibioticosPositivos: (mapa['antibioticos_positivos'] as int?) == 1,
        incidencia: (mapa['incidencia'] as String?) ?? '',
        notas: (mapa['notas'] as String?) ?? '',
      );
}
