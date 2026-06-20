/// Una finca del Espacio Test (Zunbeltz, La Planilla y, en su caso, las de
/// otros espacios test cuando la plataforma se replique). Agrupa los puntos
/// de infraestructura y las tareas de mantenimiento.
class Finca {
  Finca({
    this.id,
    this.nombre = '',
    this.latitud,
    this.longitud,
    this.superficieHa = 0,
    this.recintosSigpac = '',
    this.notas = '',
    this.rutasFotosJson = '[]',
  });

  final int? id;
  final String nombre;

  /// Centroide de la finca, para centrar el mapa al entrar.
  final double? latitud;
  final double? longitud;

  final double superficieHa;

  /// Recintos SIGPAC asociados (texto libre por ahora; estructurar en fase
  /// posterior si hace falta para PAC).
  final String recintosSigpac;

  final String notas;

  /// Lista JSON de rutas de fotos (mismo formato que `GestorFotos` del core).
  final String rutasFotosJson;

  Map<String, Object?> toMap() => {
        'id': id,
        'nombre': nombre,
        'latitud': latitud,
        'longitud': longitud,
        'superficie_ha': superficieHa,
        'recintos_sigpac': recintosSigpac,
        'notas': notas,
        'rutas_fotos_json': rutasFotosJson,
      };

  factory Finca.fromMap(Map<String, Object?> mapa) => Finca(
        id: mapa['id'] as int?,
        nombre: (mapa['nombre'] as String?) ?? '',
        latitud: (mapa['latitud'] as num?)?.toDouble(),
        longitud: (mapa['longitud'] as num?)?.toDouble(),
        superficieHa: (mapa['superficie_ha'] as num?)?.toDouble() ?? 0,
        recintosSigpac: (mapa['recintos_sigpac'] as String?) ?? '',
        notas: (mapa['notas'] as String?) ?? '',
        rutasFotosJson: (mapa['rutas_fotos_json'] as String?) ?? '[]',
      );

  Finca copiarCon({
    int? id,
    String? nombre,
    double? latitud,
    double? longitud,
    double? superficieHa,
    String? recintosSigpac,
    String? notas,
    String? rutasFotosJson,
  }) =>
      Finca(
        id: id ?? this.id,
        nombre: nombre ?? this.nombre,
        latitud: latitud ?? this.latitud,
        longitud: longitud ?? this.longitud,
        superficieHa: superficieHa ?? this.superficieHa,
        recintosSigpac: recintosSigpac ?? this.recintosSigpac,
        notas: notas ?? this.notas,
        rutasFotosJson: rutasFotosJson ?? this.rutasFotosJson,
      );
}
