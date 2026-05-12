/// Una planta con identidad persistente: árbol, arbusto o mata. Acumula
/// historia (cosechas, observaciones, incidencias, tratamientos) a lo
/// largo del tiempo. Distinto de un "hallazgo" puntual de las apps de
/// fósiles/naturaleza.
///
/// `fincaId` es nullable: una planta puede ser un **punto suelto** (un
/// árbol singular fuera de finca, p. ej. un nogal en linde). El modo
/// "censo rápido" del mapa crea plantas con `fincaId` == null por
/// defecto a menos que esté seleccionada una finca activa.
class Planta {
  final int? id;
  final int? fincaId;
  final String cultivoId;
  final String variedad;
  final double latitud;
  final double longitud;
  final double? precisionMetros;
  final int? fechaPlantacionMs;
  final String patron;
  final String etiqueta;
  final String notas;
  final String rutasFotosJson;
  final int fechaCreacionMs;

  Planta({
    this.id,
    this.fincaId,
    required this.cultivoId,
    this.variedad = '',
    required this.latitud,
    required this.longitud,
    this.precisionMetros,
    this.fechaPlantacionMs,
    this.patron = '',
    this.etiqueta = '',
    this.notas = '',
    this.rutasFotosJson = '[]',
    required this.fechaCreacionMs,
  });

  Map<String, Object?> toMap() => {
        'id': id,
        'finca_id': fincaId,
        'cultivo_id': cultivoId,
        'variedad': variedad,
        'latitud': latitud,
        'longitud': longitud,
        'precision_metros': precisionMetros,
        'fecha_plantacion_ms': fechaPlantacionMs,
        'patron': patron,
        'etiqueta': etiqueta,
        'notas': notas,
        'rutas_fotos_json': rutasFotosJson,
        'fecha_creacion_ms': fechaCreacionMs,
      };

  factory Planta.fromMap(Map<String, Object?> mapa) => Planta(
        id: mapa['id'] as int?,
        fincaId: mapa['finca_id'] as int?,
        cultivoId: (mapa['cultivo_id'] as String?) ?? 'generico',
        variedad: (mapa['variedad'] as String?) ?? '',
        latitud: (mapa['latitud'] as num).toDouble(),
        longitud: (mapa['longitud'] as num).toDouble(),
        precisionMetros: (mapa['precision_metros'] as num?)?.toDouble(),
        fechaPlantacionMs: mapa['fecha_plantacion_ms'] as int?,
        patron: (mapa['patron'] as String?) ?? '',
        etiqueta: (mapa['etiqueta'] as String?) ?? '',
        notas: (mapa['notas'] as String?) ?? '',
        rutasFotosJson: (mapa['rutas_fotos_json'] as String?) ?? '[]',
        fechaCreacionMs: mapa['fecha_creacion_ms'] as int,
      );
}
