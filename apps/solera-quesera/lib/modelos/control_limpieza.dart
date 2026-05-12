/// Control de limpieza — registro APPCC de higiene y saneamiento.
class ControlLimpieza {
  final int? id;
  final int fechaMs;
  final String zona; // produccion / camara / utensilios / envases / salaDegustacion
  final String tarea;
  final String productoUsado;
  final String responsable;
  final bool verificado;
  final String accionCorrectiva;
  final String notas;

  ControlLimpieza({
    this.id,
    required this.fechaMs,
    required this.zona,
    this.tarea = '',
    this.productoUsado = '',
    this.responsable = '',
    this.verificado = true,
    this.accionCorrectiva = '',
    this.notas = '',
  });

  Map<String, Object?> toMap() => {
        'id': id,
        'fecha_ms': fechaMs,
        'zona': zona,
        'tarea': tarea,
        'producto_usado': productoUsado,
        'responsable': responsable,
        'verificado': verificado ? 1 : 0,
        'accion_correctiva': accionCorrectiva,
        'notas': notas,
      };

  factory ControlLimpieza.fromMap(Map<String, Object?> mapa) => ControlLimpieza(
        id: mapa['id'] as int?,
        fechaMs: mapa['fecha_ms'] as int,
        zona: (mapa['zona'] as String?) ?? '',
        tarea: (mapa['tarea'] as String?) ?? '',
        productoUsado: (mapa['producto_usado'] as String?) ?? '',
        responsable: (mapa['responsable'] as String?) ?? '',
        verificado: (mapa['verificado'] as int?) == 1,
        accionCorrectiva: (mapa['accion_correctiva'] as String?) ?? '',
        notas: (mapa['notas'] as String?) ?? '',
      );
}
