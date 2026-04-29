/// Las cuatro estaciones reales del año del juego (biblia §6). La app
/// detecta latitud + fecha y propone la que toca; cada una dura entre
/// 2 y 4 meses. El cierre de cada estación produce una `PaginaEstacion`
/// con un mosaico no evaluado.
enum Estacion { otono, invierno, primavera, verano }

/// Una página del cuaderno. La pantalla principal (biblia §5.4) es una
/// colección de páginas que se van llenando, sin secciones rígidas:
/// algunas son automáticas (sit spot, misterios, estación) y otras las
/// hace el niño solo (libre).
///
/// Clase sellada: el dominio del juego solo conoce estos cuatro tipos
/// y el switch exhaustivo del UI puede confiar en ello.
sealed class PaginaCuaderno {
  const PaginaCuaderno({required this.id, required this.creadaEn});

  /// UUID v4 propio de la página, distinto del id de la entidad
  /// referenciada — esto permite tener varias páginas que apuntan a la
  /// misma observación (por ejemplo, una observación que aparece en su
  /// página directa y, además, citada en el mosaico de la estación).
  final String id;

  final DateTime creadaEn;

  Map<String, dynamic> toJson();
}

/// Una página que renderiza una observación concreta del cuaderno.
class PaginaObservacion extends PaginaCuaderno {
  const PaginaObservacion({
    required super.id,
    required super.creadaEn,
    required this.observacionId,
  });

  final String observacionId;

  @override
  Map<String, dynamic> toJson() => {
        'tipo': 'observacion',
        'id': id,
        'creadaEn': creadaEn.toIso8601String(),
        'observacionId': observacionId,
      };
}

/// La página del sit spot — biblia §5.1. Se llena sola con cada
/// visita: especies vistas, marcadores estacionales, frecuencia de
/// visitas, mini-mapa. [datosResumen] es el JSON precalculado para
/// mostrar.
class PaginaSitSpot extends PaginaCuaderno {
  const PaginaSitSpot({
    required super.id,
    required super.creadaEn,
    required this.sitSpotId,
    required this.datosResumen,
  });

  final String sitSpotId;
  final Map<String, dynamic> datosResumen;

  @override
  Map<String, dynamic> toJson() => {
        'tipo': 'sit_spot',
        'id': id,
        'creadaEn': creadaEn.toIso8601String(),
        'sitSpotId': sitSpotId,
        'datosResumen': datosResumen,
      };
}

/// La página dedicada a un Misterio abierto: pregunta + observaciones
/// ancladas + estado actual.
class PaginaMisterio extends PaginaCuaderno {
  const PaginaMisterio({
    required super.id,
    required super.creadaEn,
    required this.misterioId,
  });

  final String misterioId;

  @override
  Map<String, dynamic> toJson() => {
        'tipo': 'misterio',
        'id': id,
        'creadaEn': creadaEn.toIso8601String(),
        'misterioId': misterioId,
      };
}

/// La página de cierre de estación — biblia §6 y doc 13 §7. Es el
/// "mosaico" del Cuaderno: producción libre, no evaluada,
/// integradora. [contenidoMosaico] es el JSON de bloques (texto,
/// imágenes, dibujos, mapas, citas) que el niño compuso.
class PaginaEstacion extends PaginaCuaderno {
  const PaginaEstacion({
    required super.id,
    required super.creadaEn,
    required this.estacion,
    required this.ano,
    required this.contenidoMosaico,
  });

  final Estacion estacion;
  final int ano;
  final Map<String, dynamic> contenidoMosaico;

  @override
  Map<String, dynamic> toJson() => {
        'tipo': 'estacion',
        'id': id,
        'creadaEn': creadaEn.toIso8601String(),
        'estacion': estacion.name,
        'ano': ano,
        'contenidoMosaico': contenidoMosaico,
      };
}
