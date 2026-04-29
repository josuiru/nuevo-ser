import 'nivel_confianza.dart';

/// Una pregunta sostenida del oficio (biblia §5.3). Equivalente
/// funcional a los Fragmentos de Uno Roto y a las Brechas de Las
/// Versiones, pero **sin envoltorio narrativo** — el Cuaderno presenta
/// la pregunta desnuda.
///
/// El [estado] del Misterio refleja el consenso científico, no la
/// confianza del niño. **El niño no puede modificarlo desde la UI**:
/// el sistema lo asigna al cargar el catálogo y solo cambia con
/// actualizaciones del catálogo o si se le retira por irrelevancia
/// (`retiradoEn`). Esto es estructuralmente importante: el juego no
/// oculta respuestas — si un Misterio está como hipótesis activa, lo
/// está de verdad (biblia §5.3).
class Misterio {
  Misterio({
    required this.id,
    required this.pregunta,
    required this.descripcionCorta,
    required this.estado,
    required this.abierto,
    this.observacionesIds = const <String>[],
    this.retiradoEn,
  }) {
    if (pregunta.isEmpty) {
      throw ArgumentError.value(
        pregunta,
        'pregunta',
        'un Misterio sin pregunta no es un Misterio',
      );
    }
    if (estado == NivelConfianza.noSegura) {
      throw ArgumentError.value(
        estado,
        'estado',
        'noSegura no aplica a Misterios — el sistema declara hipótesis '
            'activa cuando hay incertidumbre real',
      );
    }
  }

  /// UUID v4. Genera el catálogo, no el cliente.
  final String id;

  /// Pregunta tal como aparece en pantalla. Sentence case, sin
  /// adornos. Ejemplos del catálogo seminal (biblia §5.3): *"¿Qué
  /// insectos visitan las flores azules de tu sit spot?"*.
  final String pregunta;

  /// Bajada breve que matiza la pregunta. Visible cuando el niño abre
  /// la tarjeta del Misterio.
  final String descripcionCorta;

  /// Estado del consenso sobre la respuesta: `consenso` (resuelto),
  /// `hipotesisActiva` (la ciencia aún no sabe del todo) o
  /// `abandonado` (se descartó como pregunta interesante). El niño no
  /// puede modificarlo.
  final NivelConfianza estado;

  /// Si el Misterio está disponible para anclar observaciones. Cada
  /// niño tiene de 3 a 5 abiertos a la vez (biblia §5.3); los demás
  /// quedan en el catálogo a la espera.
  final bool abierto;

  /// IDs de las observaciones del niño que ha anclado a este
  /// Misterio. Ordenados cronológicamente al insertar.
  final List<String> observacionesIds;

  /// Si el Misterio se retiró del catálogo activo (porque dejó de ser
  /// relevante para la región/estación o porque se actualizó la
  /// versión del catálogo).
  final DateTime? retiradoEn;

  bool get estaVigente => retiradoEn == null;

  Misterio copyWith({
    String? id,
    String? pregunta,
    String? descripcionCorta,
    NivelConfianza? estado,
    bool? abierto,
    List<String>? observacionesIds,
    DateTime? retiradoEn,
  }) {
    return Misterio(
      id: id ?? this.id,
      pregunta: pregunta ?? this.pregunta,
      descripcionCorta: descripcionCorta ?? this.descripcionCorta,
      estado: estado ?? this.estado,
      abierto: abierto ?? this.abierto,
      observacionesIds: observacionesIds ?? this.observacionesIds,
      retiradoEn: retiradoEn ?? this.retiradoEn,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'pregunta': pregunta,
        'descripcionCorta': descripcionCorta,
        'estado': estado.name,
        'abierto': abierto,
        'observacionesIds': observacionesIds,
        'retiradoEn': retiradoEn?.toIso8601String(),
      };

  static Misterio fromJson(Map<String, dynamic> json) {
    return Misterio(
      id: json['id'] as String,
      pregunta: json['pregunta'] as String,
      descripcionCorta: json['descripcionCorta'] as String,
      estado: NivelConfianza.fromString(json['estado'] as String),
      abierto: json['abierto'] as bool,
      observacionesIds: (json['observacionesIds'] as List<dynamic>? ?? const [])
          .cast<String>(),
      retiradoEn: json['retiradoEn'] == null
          ? null
          : DateTime.parse(json['retiradoEn'] as String),
    );
  }

  @override
  bool operator ==(Object other) {
    if (other is! Misterio) return false;
    if (other.id != id) return false;
    if (other.pregunta != pregunta) return false;
    if (other.descripcionCorta != descripcionCorta) return false;
    if (other.estado != estado) return false;
    if (other.abierto != abierto) return false;
    if (other.retiradoEn != retiradoEn) return false;
    if (other.observacionesIds.length != observacionesIds.length) return false;
    for (var indice = 0; indice < observacionesIds.length; indice++) {
      if (other.observacionesIds[indice] != observacionesIds[indice]) {
        return false;
      }
    }
    return true;
  }

  @override
  int get hashCode => Object.hash(
        id,
        pregunta,
        descripcionCorta,
        estado,
        abierto,
        Object.hashAll(observacionesIds),
        retiradoEn,
      );
}
