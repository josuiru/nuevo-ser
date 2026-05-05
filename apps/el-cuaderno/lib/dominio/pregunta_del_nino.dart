/// Una pregunta formulada **por el niño**, paralela y simétrica al
/// catálogo de [Misterio] del adulto. La diferencia estructural y
/// pedagógica:
///
/// - Un [Misterio] viene del catálogo curado por el comité científico
///   (B1). Su pregunta, descripción, estación y región las decide el
///   adulto. El niño aporta evidencia y, al final, declara su respuesta.
/// - Una [PreguntaDelNino] la formula el niño desde dentro de su
///   cuaderno: *"¿siempre canta el mirlo a la misma hora?"*, *"¿el moho
///   de la pared crece más rápido cuando llueve?"*. No tiene
///   `descripcionCorta`, no tiene `estado` (no hay consenso a contrastar
///   — es **su** pregunta), no tiene `seasons` ni `regions` (las define
///   él según su lugar y su tiempo).
///
/// Es el corazón de §3.4 de la biblia: *"hipotetizar y contrastar —
/// pregunta sostenida, vuelta al lugar, evidencia"*. El catálogo de
/// Misterios da el oficio; las preguntas propias dan el científico.
///
/// **Anatomía mínima**: pregunta + fecha de formulación + (opcional)
/// observaciones que el niño ha anclado como evidencia + (opcional)
/// fecha y texto de cierre cuando el niño declara *"ya tengo mi
/// respuesta"*.
class PreguntaDelNino {
  PreguntaDelNino({
    required this.id,
    required this.pregunta,
    required this.formuladaEn,
    this.observacionesIds = const <String>[],
    this.cerradaEn,
    this.respuestaDelNino,
  }) {
    if (pregunta.trim().isEmpty) {
      throw ArgumentError.value(
        pregunta,
        'pregunta',
        'una pregunta del niño sin texto no es una pregunta',
      );
    }
    // Cerrar exige respuesta — la respuesta es el contenido pedagógico
    // del cierre. Mismo principio que [Misterio.cerradoPorNino].
    if (cerradaEn != null &&
        (respuestaDelNino == null || respuestaDelNino!.trim().isEmpty)) {
      throw ArgumentError.value(
        respuestaDelNino,
        'respuestaDelNino',
        'cerrar una pregunta del niño exige una respuesta no vacía',
      );
    }
    if (cerradaEn == null && respuestaDelNino != null) {
      throw ArgumentError.value(
        respuestaDelNino,
        'respuestaDelNino',
        'no puede haber respuesta sin cerradaEn',
      );
    }
  }

  /// UUID v4. Lo genera el cliente al crear la pregunta — distinto al
  /// catálogo de Misterios cuyos ids vienen del backend.
  final String id;

  /// Texto crudo del niño. Sin formato impuesto, sin esqueleto
  /// obligatorio. La UI puede ofrecerle plantillas si las pide ("¿siempre
  /// X cuando Y?", "¿qué hace X?"), pero el modelo guarda el texto tal
  /// como lo escribió.
  final String pregunta;

  /// Cuándo formuló la pregunta. La UI la muestra en la página de la
  /// pregunta y se usa para ordenar la lista de abiertas (más recientes
  /// arriba — coherente con el resto del cuaderno).
  final DateTime formuladaEn;

  /// IDs de las observaciones del niño que ha anclado como evidencia
  /// para esta pregunta. Ordenados cronológicamente al insertar.
  /// Equivalente a [Misterio.observacionesIds].
  final List<String> observacionesIds;

  /// Cuándo el niño declaró *"ya tengo mi respuesta"* sobre esta
  /// pregunta. `null` significa que la pregunta sigue abierta.
  /// Cerrar exige texto en [respuestaDelNino] (validado en el
  /// constructor).
  final DateTime? cerradaEn;

  /// Lo que el niño anotó al cerrar la pregunta. Texto libre, sin
  /// formato. No hay respuesta canónica que contrastar — esta es la
  /// suya. Sin texto el cierre es ruido (validado en el constructor).
  final String? respuestaDelNino;

  bool get estaCerrada => cerradaEn != null;

  PreguntaDelNino copyWith({
    String? id,
    String? pregunta,
    DateTime? formuladaEn,
    List<String>? observacionesIds,
    DateTime? cerradaEn,
    String? respuestaDelNino,
  }) {
    return PreguntaDelNino(
      id: id ?? this.id,
      pregunta: pregunta ?? this.pregunta,
      formuladaEn: formuladaEn ?? this.formuladaEn,
      observacionesIds: observacionesIds ?? this.observacionesIds,
      cerradaEn: cerradaEn ?? this.cerradaEn,
      respuestaDelNino: respuestaDelNino ?? this.respuestaDelNino,
    );
  }

  /// Reabrir una pregunta cerrada: descarta tanto la fecha de cierre
  /// como la respuesta. `copyWith` no sirve por el patrón `?? this.x`
  /// que no permite poner `null`. Mismo motivo que
  /// [Misterio.reabiertoPorNino].
  PreguntaDelNino reabiertaPorNino() {
    return PreguntaDelNino(
      id: id,
      pregunta: pregunta,
      formuladaEn: formuladaEn,
      observacionesIds: observacionesIds,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'pregunta': pregunta,
        'formuladaEn': formuladaEn.toIso8601String(),
        'observacionesIds': observacionesIds,
        if (cerradaEn != null) 'cerradaEn': cerradaEn!.toIso8601String(),
        if (respuestaDelNino != null) 'respuestaDelNino': respuestaDelNino,
      };

  static PreguntaDelNino fromJson(Map<String, dynamic> json) {
    return PreguntaDelNino(
      id: json['id'] as String,
      pregunta: json['pregunta'] as String,
      formuladaEn: DateTime.parse(json['formuladaEn'] as String),
      observacionesIds:
          (json['observacionesIds'] as List<dynamic>? ?? const [])
              .cast<String>(),
      cerradaEn: json['cerradaEn'] == null
          ? null
          : DateTime.parse(json['cerradaEn'] as String),
      respuestaDelNino: json['respuestaDelNino'] as String?,
    );
  }

  @override
  bool operator ==(Object other) {
    if (other is! PreguntaDelNino) return false;
    if (other.id != id) return false;
    if (other.pregunta != pregunta) return false;
    if (other.formuladaEn != formuladaEn) return false;
    if (other.observacionesIds.length != observacionesIds.length) return false;
    for (var indice = 0; indice < observacionesIds.length; indice++) {
      if (other.observacionesIds[indice] != observacionesIds[indice]) {
        return false;
      }
    }
    if (other.cerradaEn != cerradaEn) return false;
    if (other.respuestaDelNino != respuestaDelNino) return false;
    return true;
  }

  @override
  int get hashCode => Object.hash(
        id,
        pregunta,
        formuladaEn,
        Object.hashAll(observacionesIds),
        cerradaEn,
        respuestaDelNino,
      );
}
