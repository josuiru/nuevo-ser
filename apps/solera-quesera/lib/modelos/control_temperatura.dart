/// Control de temperatura y humedad — registro APPCC diario de cada
/// cámara/cueva de curación.
class ControlTemperatura {
  final int? id;
  final int fechaMs;
  final String cavaId; // nombre o identificador de la cámara
  final double temperatura;
  final double humedadRelativa;
  final String responsable;
  final String notas;

  ControlTemperatura({
    this.id,
    required this.fechaMs,
    required this.cavaId,
    required this.temperatura,
    required this.humedadRelativa,
    this.responsable = '',
    this.notas = '',
  });

  Map<String, Object?> toMap() => {
        'id': id,
        'fecha_ms': fechaMs,
        'cava_id': cavaId,
        'temperatura': temperatura,
        'humedad_relativa': humedadRelativa,
        'responsable': responsable,
        'notas': notas,
      };

  factory ControlTemperatura.fromMap(Map<String, Object?> mapa) =>
      ControlTemperatura(
        id: mapa['id'] as int?,
        fechaMs: mapa['fecha_ms'] as int,
        cavaId: mapa['cava_id'] as String,
        temperatura: (mapa['temperatura'] as num).toDouble(),
        humedadRelativa: (mapa['humedad_relativa'] as num).toDouble(),
        responsable: (mapa['responsable'] as String?) ?? '',
        notas: (mapa['notas'] as String?) ?? '',
      );
}
