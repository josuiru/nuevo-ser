import 'nivel_confianza.dart';

/// Coordenadas geográficas precisas. **Solo se persisten en el
/// dispositivo**, nunca cruzan red — el doc 03 §7.1 lo consagra como
/// regla innegociable. En S1 siempre es `null` porque la
/// geolocalización entra en S5; el campo existe ya para no tener que
/// migrar el modelo cuando llegue.
class Coordenadas {
  const Coordenadas({required this.lat, required this.lng});

  final double lat;
  final double lng;

  Map<String, dynamic> toJson() => {'lat': lat, 'lng': lng};

  static Coordenadas fromJson(Map<String, dynamic> json) =>
      Coordenadas(lat: json['lat'] as double, lng: json['lng'] as double);

  @override
  bool operator ==(Object other) =>
      other is Coordenadas && other.lat == lat && other.lng == lng;

  @override
  int get hashCode => Object.hash(lat, lng);
}

/// Una observación del cuaderno. Clase inmutable: cualquier cambio
/// produce una instancia nueva vía [copyWith] — coherente con el
/// principio "el cuaderno es del niño" (biblia §2.1) en su variante
/// técnica: las observaciones no se mutan en sitio, se versionan.
///
/// Estructura validada en construcción según la biblia §5.2:
///
/// - [queVio] no puede ser cadena vacía: registrar nada no es una
///   observación.
/// - Si [confianza] es [NivelConfianza.consenso], [creesQueEs] **no
///   puede ser null** — declarar consenso sin haber propuesto una
///   identificación es incoherente.
/// - [confianza] no puede ser [NivelConfianza.abandonado]: ese estado
///   pertenece a Misterios, no a observaciones.
class Observacion {
  Observacion({
    required this.id,
    required this.cuandoCreada,
    required this.cuandoOcurrio,
    required this.dondeNombre,
    required this.queVio,
    required this.confianza,
    this.dondeCoordenadas,
    this.climaResumen,
    this.creesQueEs,
    this.fotoRutaLocal,
    this.dibujoRutaLocal,
    this.misterioId,
    this.preguntaDelNinoId,
    this.sitSpotId,
  }) {
    if (queVio.isEmpty) {
      throw ArgumentError.value(
        queVio,
        'queVio',
        'una observación sin descripción no es una observación',
      );
    }
    if (confianza == NivelConfianza.abandonado) {
      throw ArgumentError.value(
        confianza,
        'confianza',
        'abandonado pertenece a Misterios, no a observaciones',
      );
    }
    if (confianza == NivelConfianza.consenso && creesQueEs == null) {
      throw ArgumentError.value(
        creesQueEs,
        'creesQueEs',
        'declarar consenso requiere haber propuesto una identificación',
      );
    }
  }

  /// UUID v4. Ver [NuevaObservacion] o el seed para ver cómo se genera.
  final String id;

  /// Cuándo se grabó la fila en el cuaderno (timestamp del sistema).
  final DateTime cuandoCreada;

  /// Cuándo ocurrió la observación. Puede diferir de [cuandoCreada]
  /// si la niña la registra después.
  final DateTime cuandoOcurrio;

  /// Texto libre que el niño le pone al lugar — el sit spot, una calle,
  /// "patio del cole". Doc 13 §3.2 lo deja explícito: cualquier texto
  /// vale.
  final String dondeNombre;

  /// Coordenadas precisas, opcionales y siempre locales. En S1
  /// siempre es null (la geolocalización entra en S5).
  final Coordenadas? dondeCoordenadas;

  /// Descriptor del tiempo si la niña lo añade ("soleado", "lluvia
  /// fina"). Opcional.
  final String? climaResumen;

  /// La descripción libre — el campo central del oficio. Obligatorio.
  /// La biblia §5.2 estructura la pantalla para forzar que esto se
  /// rellene antes que [creesQueEs].
  final String queVio;

  /// Identificación propuesta por el niño. Opcional. Una observación
  /// sin identificación es válida — anotar lo visto sin nombrarlo es
  /// parte del oficio (doc 04 §3.4 intercambio 4).
  final String? creesQueEs;

  /// Nivel de confianza sobre la identificación. Por defecto al
  /// registrar algo nuevo: [NivelConfianza.hipotesisActiva] (doc 13
  /// §3.2). El UI ofrece chips solo cuando [creesQueEs] no es null.
  final NivelConfianza confianza;

  /// Path al fichero de foto en el almacenamiento privado del
  /// dispositivo. Nunca cruza red salvo que la niña explícitamente
  /// comparta (Sprint 7+). En S1 siempre null.
  final String? fotoRutaLocal;

  /// Path al dibujo (canvas táctil del juego). Misma política que la
  /// foto.
  final String? dibujoRutaLocal;

  /// Anclaje opcional a un Misterio. Vincular una observación a un
  /// Misterio le da contexto pedagógico — la biblia §5.3 prevé que
  /// muchas observaciones se acumulen en torno a un Misterio abierto.
  final String? misterioId;

  /// Anclaje opcional a una pregunta formulada por el niño. Paralelo a
  /// [misterioId] pero apuntando al catálogo del niño en lugar del
  /// catálogo del adulto. Una observación puede tener uno, otro, los
  /// dos o ninguno — el oficio admite anclar la misma observación a
  /// una pregunta del niño Y a un Misterio del catálogo cuando ambos
  /// son relevantes.
  final String? preguntaDelNinoId;

  /// Si la observación se hizo dentro del radio del sit spot, este
  /// campo apunta al SitSpot. La página del sit spot del cuaderno se
  /// alimenta de aquí.
  final String? sitSpotId;

  Observacion copyWith({
    String? id,
    DateTime? cuandoCreada,
    DateTime? cuandoOcurrio,
    String? dondeNombre,
    Coordenadas? dondeCoordenadas,
    String? climaResumen,
    String? queVio,
    String? creesQueEs,
    NivelConfianza? confianza,
    String? fotoRutaLocal,
    String? dibujoRutaLocal,
    String? misterioId,
    String? preguntaDelNinoId,
    String? sitSpotId,
  }) {
    return Observacion(
      id: id ?? this.id,
      cuandoCreada: cuandoCreada ?? this.cuandoCreada,
      cuandoOcurrio: cuandoOcurrio ?? this.cuandoOcurrio,
      dondeNombre: dondeNombre ?? this.dondeNombre,
      dondeCoordenadas: dondeCoordenadas ?? this.dondeCoordenadas,
      climaResumen: climaResumen ?? this.climaResumen,
      queVio: queVio ?? this.queVio,
      creesQueEs: creesQueEs ?? this.creesQueEs,
      confianza: confianza ?? this.confianza,
      fotoRutaLocal: fotoRutaLocal ?? this.fotoRutaLocal,
      dibujoRutaLocal: dibujoRutaLocal ?? this.dibujoRutaLocal,
      misterioId: misterioId ?? this.misterioId,
      preguntaDelNinoId: preguntaDelNinoId ?? this.preguntaDelNinoId,
      sitSpotId: sitSpotId ?? this.sitSpotId,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'cuandoCreada': cuandoCreada.toIso8601String(),
        'cuandoOcurrio': cuandoOcurrio.toIso8601String(),
        'dondeNombre': dondeNombre,
        'dondeCoordenadas': dondeCoordenadas?.toJson(),
        'climaResumen': climaResumen,
        'queVio': queVio,
        'creesQueEs': creesQueEs,
        'confianza': confianza.name,
        'fotoRutaLocal': fotoRutaLocal,
        'dibujoRutaLocal': dibujoRutaLocal,
        'misterioId': misterioId,
        if (preguntaDelNinoId != null) 'preguntaDelNinoId': preguntaDelNinoId,
        'sitSpotId': sitSpotId,
      };

  static Observacion fromJson(Map<String, dynamic> json) {
    final coordsJson = json['dondeCoordenadas'] as Map<String, dynamic>?;
    return Observacion(
      id: json['id'] as String,
      cuandoCreada: DateTime.parse(json['cuandoCreada'] as String),
      cuandoOcurrio: DateTime.parse(json['cuandoOcurrio'] as String),
      dondeNombre: json['dondeNombre'] as String,
      dondeCoordenadas:
          coordsJson == null ? null : Coordenadas.fromJson(coordsJson),
      climaResumen: json['climaResumen'] as String?,
      queVio: json['queVio'] as String,
      creesQueEs: json['creesQueEs'] as String?,
      confianza: NivelConfianza.fromString(json['confianza'] as String),
      fotoRutaLocal: json['fotoRutaLocal'] as String?,
      dibujoRutaLocal: json['dibujoRutaLocal'] as String?,
      misterioId: json['misterioId'] as String?,
      preguntaDelNinoId: json['preguntaDelNinoId'] as String?,
      sitSpotId: json['sitSpotId'] as String?,
    );
  }

  @override
  bool operator ==(Object other) {
    if (other is! Observacion) return false;
    return other.id == id &&
        other.cuandoCreada == cuandoCreada &&
        other.cuandoOcurrio == cuandoOcurrio &&
        other.dondeNombre == dondeNombre &&
        other.dondeCoordenadas == dondeCoordenadas &&
        other.climaResumen == climaResumen &&
        other.queVio == queVio &&
        other.creesQueEs == creesQueEs &&
        other.confianza == confianza &&
        other.fotoRutaLocal == fotoRutaLocal &&
        other.dibujoRutaLocal == dibujoRutaLocal &&
        other.misterioId == misterioId &&
        other.preguntaDelNinoId == preguntaDelNinoId &&
        other.sitSpotId == sitSpotId;
  }

  @override
  int get hashCode => Object.hashAll([
        id,
        cuandoCreada,
        cuandoOcurrio,
        dondeNombre,
        dondeCoordenadas,
        climaResumen,
        queVio,
        creesQueEs,
        confianza,
        fotoRutaLocal,
        dibujoRutaLocal,
        misterioId,
        preguntaDelNinoId,
        sitSpotId,
      ]);
}
