/// Habilidad atómica del mapa pedagógico (ver docs/02).
///
/// Representa una unidad mínima de competencia matemática que el
/// sistema mide y sube de nivel. Inmutable: se carga desde
/// `assets/data/skills.json` al arrancar la app.
class Habilidad {
  final String identificador;
  final String nombre;
  final String dominio;
  final List<String> dependencias;
  final List<String> familiasFragmento;
  final List<String> distritos;
  final String rangoIntroduccion;
  final String rangoExigido;
  final double umbralPrecision;
  final int tiempoMedianoMinSeg;
  final int tiempoMedianoMaxSeg;

  const Habilidad({
    required this.identificador,
    required this.nombre,
    required this.dominio,
    required this.dependencias,
    required this.familiasFragmento,
    required this.distritos,
    required this.rangoIntroduccion,
    required this.rangoExigido,
    required this.umbralPrecision,
    required this.tiempoMedianoMinSeg,
    required this.tiempoMedianoMaxSeg,
  });

  factory Habilidad.desdeJson(Map<String, dynamic> json) {
    final tiempo = (json['time_median_seconds'] as List).cast<num>();
    return Habilidad(
      identificador: json['id'] as String,
      nombre: json['name'] as String,
      dominio: json['domain'] as String,
      dependencias: (json['deps'] as List).cast<String>(),
      familiasFragmento: (json['families'] as List).cast<String>(),
      distritos: (json['districts'] as List).cast<String>(),
      rangoIntroduccion: json['intro_rank'] as String,
      rangoExigido: json['required_rank'] as String,
      umbralPrecision: (json['precision_threshold'] as num).toDouble(),
      tiempoMedianoMinSeg: tiempo[0].toInt(),
      tiempoMedianoMaxSeg: tiempo[1].toInt(),
    );
  }
}

/// Nivel de maestría de una habilidad para un niño concreto.
/// Orden estable: coincide con el valor numérico usado en el JSON.
enum NivelMaestria {
  inexplorada, // 0
  introducida, // 1
  enDesarrollo, // 2
  competente, // 3
  maestria, // 4
}

extension NivelMaestriaEntero on NivelMaestria {
  int get valor => index;

  static NivelMaestria desdeValor(int v) {
    if (v < 0 || v >= NivelMaestria.values.length) {
      return NivelMaestria.inexplorada;
    }
    return NivelMaestria.values[v];
  }

  String get nombreCastellano {
    switch (this) {
      case NivelMaestria.inexplorada:
        return 'Inexplorada';
      case NivelMaestria.introducida:
        return 'Introducida';
      case NivelMaestria.enDesarrollo:
        return 'En desarrollo';
      case NivelMaestria.competente:
        return 'Competente';
      case NivelMaestria.maestria:
        return 'Maestría';
    }
  }
}

/// Registro de un intento concreto (resultado de un puzzle) contra una
/// habilidad. Formato mínimo para persistencia local.
///
/// Los tres campos opcionales [senalEsperada], [clasePredicha] y
/// [componentesRubrica] llevan la metadata por intento que P2 y P3
/// necesitan. Son `null` para intentos P1/P4, presentes para P2 y P3
/// respectivamente. Su shape JSON es compacto (`se`, `cp`, `cr`) y se
/// omite cuando es null para que estados P1 antiguos serialicen
/// idénticamente que antes (retrocompatibilidad de fixtures).
class IntentoHabilidad {
  final DateTime instante;
  final bool acierto;
  final double dificultad;
  final int duracionSegundos;

  /// **P2 — clase real**: `true` si el caso era de la clase positiva
  /// (la "señal" — p. ej. para HF.10, "esta fuente sí omite"), `false`
  /// si era negativo. `null` para intentos sin pareo binario.
  final bool? senalEsperada;

  /// **P2 — clase predicha**: lo que la persona dijo. Si [acierto] es
  /// true, [clasePredicha] == [senalEsperada]; si false, la opuesta.
  /// `null` cuando [senalEsperada] es null.
  final bool? clasePredicha;

  /// **P3 — componentes de rúbrica** 0..1. Claves esperadas: `a`
  /// (anclaje), `c` (calibración), `p` (completud), `f` (ausencia de
  /// falacias). `null` para intentos no rúbrica.
  final Map<String, double>? componentesRubrica;

  const IntentoHabilidad({
    required this.instante,
    required this.acierto,
    required this.dificultad,
    required this.duracionSegundos,
    this.senalEsperada,
    this.clasePredicha,
    this.componentesRubrica,
  });

  Map<String, dynamic> aJson() {
    final json = <String, dynamic>{
      't': instante.toIso8601String(),
      'a': acierto,
      'd': dificultad,
      's': duracionSegundos,
    };
    if (senalEsperada != null) json['se'] = senalEsperada;
    if (clasePredicha != null) json['cp'] = clasePredicha;
    if (componentesRubrica != null) json['cr'] = componentesRubrica;
    return json;
  }

  factory IntentoHabilidad.desdeJson(Map<String, dynamic> json) {
    final cr = json['cr'];
    return IntentoHabilidad(
      instante: DateTime.parse(json['t'] as String),
      acierto: json['a'] as bool,
      dificultad: (json['d'] as num).toDouble(),
      duracionSegundos: (json['s'] as num).toInt(),
      senalEsperada: json['se'] as bool?,
      clasePredicha: json['cp'] as bool?,
      componentesRubrica: cr == null
          ? null
          : (cr as Map).map((k, v) => MapEntry(k as String, (v as num).toDouble())),
    );
  }
}

/// Estado agregado de una habilidad para un niño. Se calcula a partir
/// de los últimos 20 intentos. Persistido como JSON en
/// shared_preferences; migrable a Isar en fase posterior.
class EstadoHabilidad {
  final String identificadorHabilidad;
  final NivelMaestria nivel;
  final double precision;
  final double tiempoMedianoSeg;
  final DateTime ultimaPractica;
  final int sesionesConsecutivasBuenas;
  final int totalExposiciones;
  final List<IntentoHabilidad> intentosRecientes;

  const EstadoHabilidad({
    required this.identificadorHabilidad,
    required this.nivel,
    required this.precision,
    required this.tiempoMedianoSeg,
    required this.ultimaPractica,
    required this.sesionesConsecutivasBuenas,
    required this.totalExposiciones,
    required this.intentosRecientes,
  });

  factory EstadoHabilidad.inicial(String id) => EstadoHabilidad(
        identificadorHabilidad: id,
        nivel: NivelMaestria.inexplorada,
        precision: 0,
        tiempoMedianoSeg: 0,
        ultimaPractica: DateTime.fromMillisecondsSinceEpoch(0),
        sesionesConsecutivasBuenas: 0,
        totalExposiciones: 0,
        intentosRecientes: const [],
      );

  EstadoHabilidad copiarCon({
    NivelMaestria? nivel,
    double? precision,
    double? tiempoMedianoSeg,
    DateTime? ultimaPractica,
    int? sesionesConsecutivasBuenas,
    int? totalExposiciones,
    List<IntentoHabilidad>? intentosRecientes,
  }) =>
      EstadoHabilidad(
        identificadorHabilidad: identificadorHabilidad,
        nivel: nivel ?? this.nivel,
        precision: precision ?? this.precision,
        tiempoMedianoSeg: tiempoMedianoSeg ?? this.tiempoMedianoSeg,
        ultimaPractica: ultimaPractica ?? this.ultimaPractica,
        sesionesConsecutivasBuenas:
            sesionesConsecutivasBuenas ?? this.sesionesConsecutivasBuenas,
        totalExposiciones: totalExposiciones ?? this.totalExposiciones,
        intentosRecientes: intentosRecientes ?? this.intentosRecientes,
      );

  Map<String, dynamic> aJson() => {
        'id': identificadorHabilidad,
        'nv': nivel.valor,
        'pr': precision,
        'tm': tiempoMedianoSeg,
        'up': ultimaPractica.toIso8601String(),
        'scb': sesionesConsecutivasBuenas,
        'te': totalExposiciones,
        'ir': intentosRecientes.map((i) => i.aJson()).toList(),
      };

  factory EstadoHabilidad.desdeJson(Map<String, dynamic> json) {
    final intentos = (json['ir'] as List)
        .map((e) => IntentoHabilidad.desdeJson(e as Map<String, dynamic>))
        .toList();
    return EstadoHabilidad(
      identificadorHabilidad: json['id'] as String,
      nivel: NivelMaestriaEntero.desdeValor(json['nv'] as int),
      precision: (json['pr'] as num).toDouble(),
      tiempoMedianoSeg: (json['tm'] as num).toDouble(),
      ultimaPractica: DateTime.parse(json['up'] as String),
      sesionesConsecutivasBuenas: json['scb'] as int,
      totalExposiciones: json['te'] as int,
      intentosRecientes: intentos,
    );
  }
}
