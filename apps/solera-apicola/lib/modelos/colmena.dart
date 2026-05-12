/// Estado actual de la colmena. Las colmenas son entidades persistentes
/// — la **caja** se queda aunque el enjambre muera, y se puede ahijar
/// con uno nuevo. Importante distinguirlo en la BD para reflejar la
/// vida real de la explotación.
enum EstadoColmena {
  /// Enjambre vivo y productivo.
  viva,

  /// Caja vacía, esperando enjambre nuevo.
  vacia,

  /// El enjambre murió (mortalidad invernal, varroa fuerte, etc.).
  /// La caja sigue ahí pero registrada como bajada.
  descolmenada,

  /// Enjambre nuevo capturado (recogido de un enjambrazón natural)
  /// metido en una caja que estaba vacía.
  enjambreNuevo,
}

EstadoColmena _estadoDesdeString(String s) {
  switch (s) {
    case 'viva':
      return EstadoColmena.viva;
    case 'vacia':
      return EstadoColmena.vacia;
    case 'descolmenada':
      return EstadoColmena.descolmenada;
    case 'enjambre_nuevo':
      return EstadoColmena.enjambreNuevo;
    default:
      return EstadoColmena.viva;
  }
}

String _estadoAString(EstadoColmena e) {
  switch (e) {
    case EstadoColmena.viva:
      return 'viva';
    case EstadoColmena.vacia:
      return 'vacia';
    case EstadoColmena.descolmenada:
      return 'descolmenada';
    case EstadoColmena.enjambreNuevo:
      return 'enjambre_nuevo';
  }
}

/// Una colmena con identidad persistente. La identidad se lleva por
/// **matrícula** (string único definido por el apicultor), NO por
/// GPS — las colmenas se mueven (trashumancia). La latitud/longitud
/// guardadas reflejan la ÚLTIMA ubicación conocida; los movimientos
/// históricos viven en la tabla `movimientos`.
///
/// `apiarioId` es nullable: una colmena puede estar como **ubicación
/// puntual** fuera de un apiario fijo.
///
/// `tipoColmenaId` y `razaId` referencian a los catálogos curados
/// (F1A-4, decisión humana con asesor). En v0.1 son free-text.
///
/// `anoReina` permite calcular el color identificador estándar de
/// la marca (ciclo de 5 años: blanco-amarillo-rojo-verde-azul). Se
/// calcula on-demand, no se persiste.
class Colmena {
  final int? id;
  final int? apiarioId;
  final String matricula;
  final String tipoColmenaId;
  final String razaId;
  final int? anoReina;
  final EstadoColmena estado;
  final double? ultimaLatitud;
  final double? ultimaLongitud;
  final int? fechaAltaMs;
  final String notas;
  final String rutasFotosJson;
  final int fechaCreacionMs;

  Colmena({
    this.id,
    this.apiarioId,
    required this.matricula,
    this.tipoColmenaId = '',
    this.razaId = '',
    this.anoReina,
    this.estado = EstadoColmena.viva,
    this.ultimaLatitud,
    this.ultimaLongitud,
    this.fechaAltaMs,
    this.notas = '',
    this.rutasFotosJson = '[]',
    required this.fechaCreacionMs,
  });

  /// Color identificador internacional de la marca de la reina, según
  /// el ciclo estándar de 5 años. Devuelve null si no se conoce el año.
  ///
  /// 0 = blanco, 1 = amarillo, 2 = rojo, 3 = verde, 4 = azul (sobre
  /// el resto de año mod 5).
  String? get colorMarcaReina {
    if (anoReina == null) return null;
    switch (anoReina! % 5) {
      case 1:
      case 6:
        return 'blanco';
      case 2:
      case 7:
        return 'amarillo';
      case 3:
      case 8:
        return 'rojo';
      case 4:
      case 9:
        return 'verde';
      case 0:
      case 5:
        return 'azul';
    }
    return null;
  }

  Map<String, Object?> toMap() => {
        'id': id,
        'apiario_id': apiarioId,
        'matricula': matricula,
        'tipo_colmena_id': tipoColmenaId,
        'raza_id': razaId,
        'ano_reina': anoReina,
        'estado': _estadoAString(estado),
        'ultima_latitud': ultimaLatitud,
        'ultima_longitud': ultimaLongitud,
        'fecha_alta_ms': fechaAltaMs,
        'notas': notas,
        'rutas_fotos_json': rutasFotosJson,
        'fecha_creacion_ms': fechaCreacionMs,
      };

  factory Colmena.fromMap(Map<String, Object?> mapa) => Colmena(
        id: mapa['id'] as int?,
        apiarioId: mapa['apiario_id'] as int?,
        matricula: (mapa['matricula'] as String?) ?? '',
        tipoColmenaId: (mapa['tipo_colmena_id'] as String?) ?? '',
        razaId: (mapa['raza_id'] as String?) ?? '',
        anoReina: mapa['ano_reina'] as int?,
        estado: _estadoDesdeString((mapa['estado'] as String?) ?? 'viva'),
        ultimaLatitud: (mapa['ultima_latitud'] as num?)?.toDouble(),
        ultimaLongitud: (mapa['ultima_longitud'] as num?)?.toDouble(),
        fechaAltaMs: mapa['fecha_alta_ms'] as int?,
        notas: (mapa['notas'] as String?) ?? '',
        rutasFotosJson: (mapa['rutas_fotos_json'] as String?) ?? '[]',
        fechaCreacionMs: mapa['fecha_creacion_ms'] as int,
      );
}
