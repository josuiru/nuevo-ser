import 'observacion.dart';

/// El lugar de regreso elegido por el niño (biblia §5.1). Una entidad
/// privilegiada: es la única del juego que persiste coordenadas en
/// local cuando llegue Sprint 5. En S1 [coordenadas] siempre es null y
/// el lugar se identifica por [dondeNombre].
///
/// El MVP solo permite **un sit spot activo por niño**: si quiere
/// cambiar, tiene que jubilar el actual (doc 13 §2.6), lo que escribe
/// `retiradoEn` y crea otro desde cero. Esto refleja el principio del
/// libro: el sit spot se construye con tiempo.
class SitSpot {
  SitSpot({
    required this.id,
    required this.nombre,
    required this.dondeNombre,
    required this.creadoEn,
    this.coordenadas,
    this.ultimaVisita,
    this.retiradoEn,
  }) {
    if (nombre.isEmpty) {
      throw ArgumentError.value(
        nombre,
        'nombre',
        'el sit spot necesita nombre — el niño se lo pone',
      );
    }
  }

  /// UUID v4.
  final String id;

  /// Como el niño llama al sitio: "El Roble Grande", "Mi banco",
  /// "Donde fui con el abuelo", "Aquí". Doc 13 §2.4 acepta cualquier
  /// cosa.
  final String nombre;

  /// Texto adicional para acordarse de dónde está cuando no hay
  /// geolocalización ("al final del parque, junto al pino más alto").
  /// Opcional.
  final String dondeNombre;

  /// Coordenadas precisas. **Solo en local**, nunca a servidor (doc 03
  /// §7.1). En S1 siempre null.
  final Coordenadas? coordenadas;

  /// Cuándo se creó el sit spot.
  final DateTime creadoEn;

  /// Última vez que la geolocalización detectó al niño dentro del
  /// radio. En S1 se actualiza manualmente desde la pantalla de
  /// observación.
  final DateTime? ultimaVisita;

  /// Si el niño jubila el sit spot, queda con `retiradoEn != null`.
  /// La página del sit spot sigue accesible en el cuaderno; solo no se
  /// puede registrar nuevas observaciones contra él. Doc 13 §2.6.
  final DateTime? retiradoEn;

  bool get estaActivo => retiradoEn == null;

  SitSpot copyWith({
    String? id,
    String? nombre,
    String? dondeNombre,
    Coordenadas? coordenadas,
    DateTime? creadoEn,
    DateTime? ultimaVisita,
    DateTime? retiradoEn,
  }) {
    return SitSpot(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      dondeNombre: dondeNombre ?? this.dondeNombre,
      coordenadas: coordenadas ?? this.coordenadas,
      creadoEn: creadoEn ?? this.creadoEn,
      ultimaVisita: ultimaVisita ?? this.ultimaVisita,
      retiradoEn: retiradoEn ?? this.retiradoEn,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nombre': nombre,
        'dondeNombre': dondeNombre,
        'coordenadas': coordenadas?.toJson(),
        'creadoEn': creadoEn.toIso8601String(),
        'ultimaVisita': ultimaVisita?.toIso8601String(),
        'retiradoEn': retiradoEn?.toIso8601String(),
      };

  static SitSpot fromJson(Map<String, dynamic> json) {
    final coordsJson = json['coordenadas'] as Map<String, dynamic>?;
    return SitSpot(
      id: json['id'] as String,
      nombre: json['nombre'] as String,
      dondeNombre: json['dondeNombre'] as String,
      coordenadas: coordsJson == null ? null : Coordenadas.fromJson(coordsJson),
      creadoEn: DateTime.parse(json['creadoEn'] as String),
      ultimaVisita: json['ultimaVisita'] == null
          ? null
          : DateTime.parse(json['ultimaVisita'] as String),
      retiradoEn: json['retiradoEn'] == null
          ? null
          : DateTime.parse(json['retiradoEn'] as String),
    );
  }

  @override
  bool operator ==(Object other) {
    if (other is! SitSpot) return false;
    return other.id == id &&
        other.nombre == nombre &&
        other.dondeNombre == dondeNombre &&
        other.coordenadas == coordenadas &&
        other.creadoEn == creadoEn &&
        other.ultimaVisita == ultimaVisita &&
        other.retiradoEn == retiradoEn;
  }

  @override
  int get hashCode => Object.hash(
        id,
        nombre,
        dondeNombre,
        coordenadas,
        creadoEn,
        ultimaVisita,
        retiradoEn,
      );
}
