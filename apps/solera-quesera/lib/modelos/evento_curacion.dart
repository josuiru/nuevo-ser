/// Evento de curación — cada acción sobre una pieza durante el afinado.
///
/// Tipos: volteo, cepillado, ahumado, baño (salmuera/aceite),
/// controlPeso, inspeccionVisual, otro.
///
/// `maderaAhumado` solo aplica cuando tipo = 'ahumado' (haya, abedul,
/// espino, cerezo, roble…).
class EventoCuracion {
  final int? id;
  final int piezaId;
  final int fechaMs;
  final String tipo; // volteo / cepillado / ahumado / baño /
                     // controlPeso / inspeccionVisual / otro
  final double? pesoActual;
  final String maderaAhumado;
  final String notas;
  final int fechaCreacionMs;

  EventoCuracion({
    this.id,
    required this.piezaId,
    required this.fechaMs,
    required this.tipo,
    this.pesoActual,
    this.maderaAhumado = '',
    this.notas = '',
    required this.fechaCreacionMs,
  });

  Map<String, Object?> toMap() => {
        'id': id,
        'pieza_id': piezaId,
        'fecha_ms': fechaMs,
        'tipo': tipo,
        'peso_actual': pesoActual,
        'madera_ahumado': maderaAhumado,
        'notas': notas,
        'fecha_creacion_ms': fechaCreacionMs,
      };

  factory EventoCuracion.fromMap(Map<String, Object?> mapa) => EventoCuracion(
        id: mapa['id'] as int?,
        piezaId: mapa['pieza_id'] as int,
        fechaMs: mapa['fecha_ms'] as int,
        tipo: mapa['tipo'] as String,
        pesoActual: (mapa['peso_actual'] as num?)?.toDouble(),
        maderaAhumado: (mapa['madera_ahumado'] as String?) ?? '',
        notas: (mapa['notas'] as String?) ?? '',
        fechaCreacionMs: (mapa['fecha_creacion_ms'] as int?) ?? 0,
      );
}
