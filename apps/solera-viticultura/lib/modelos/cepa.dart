/// Una cepa de vid con identidad persistente. Acumula historia
/// (cosechas, observaciones, incidencias, tratamientos) a lo largo
/// del tiempo. Distinto de un "hallazgo" puntual de las apps de
/// fósiles/naturaleza.
///
/// `vinedoId` es nullable: una cepa puede ser un **punto suelto** (una
/// cepa singular fuera del viñedo principal). El modo "censo rápido"
/// del mapa crea cepas con `vinedoId == null` por defecto a menos que
/// esté seleccionado un viñedo activo.
///
/// `variedadId` referencia al catálogo curado de variedades viníferas
/// (F1-4, decisión humana con asesor enológico): tempranillo,
/// garnacha, albarino, mencia, viura, etc.
///
/// `portainjertoId` referencia al catálogo curado de portainjertos
/// (F1-4): 110-R, SO4, 41-B, 1103P, etc. Cadena vacía mientras no
/// se haya identificado.
class Cepa {
  final int? id;
  final int? vinedoId;
  final String variedadId;
  final String portainjertoId;
  final double latitud;
  final double longitud;
  final double? precisionMetros;
  final int? fechaPlantacionMs;
  final String etiqueta;
  final String notas;
  final String rutasFotosJson;
  final int fechaCreacionMs;

  Cepa({
    this.id,
    this.vinedoId,
    required this.variedadId,
    this.portainjertoId = '',
    required this.latitud,
    required this.longitud,
    this.precisionMetros,
    this.fechaPlantacionMs,
    this.etiqueta = '',
    this.notas = '',
    this.rutasFotosJson = '[]',
    required this.fechaCreacionMs,
  });

  Map<String, Object?> toMap() => {
        'id': id,
        'vinedo_id': vinedoId,
        'variedad_id': variedadId,
        'portainjerto_id': portainjertoId,
        'latitud': latitud,
        'longitud': longitud,
        'precision_metros': precisionMetros,
        'fecha_plantacion_ms': fechaPlantacionMs,
        'etiqueta': etiqueta,
        'notas': notas,
        'rutas_fotos_json': rutasFotosJson,
        'fecha_creacion_ms': fechaCreacionMs,
      };

  factory Cepa.fromMap(Map<String, Object?> mapa) => Cepa(
        id: mapa['id'] as int?,
        vinedoId: mapa['vinedo_id'] as int?,
        variedadId: (mapa['variedad_id'] as String?) ?? 'desconocida',
        portainjertoId: (mapa['portainjerto_id'] as String?) ?? '',
        latitud: (mapa['latitud'] as num).toDouble(),
        longitud: (mapa['longitud'] as num).toDouble(),
        precisionMetros: (mapa['precision_metros'] as num?)?.toDouble(),
        fechaPlantacionMs: mapa['fecha_plantacion_ms'] as int?,
        etiqueta: (mapa['etiqueta'] as String?) ?? '',
        notas: (mapa['notas'] as String?) ?? '',
        rutasFotosJson: (mapa['rutas_fotos_json'] as String?) ?? '[]',
        fechaCreacionMs: mapa['fecha_creacion_ms'] as int,
      );
}
