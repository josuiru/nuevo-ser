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
    this.seasons = const <String>[],
    this.regions,
    this.cerradoPorNino,
    this.respuestaDelNino,
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
    // Cerrar un Misterio sin haber escrito nada no es cerrar — la respuesta
    // del niño es el contenido pedagógico del cierre. Sin texto el dato
    // es ruido.
    if (cerradoPorNino != null &&
        (respuestaDelNino == null || respuestaDelNino!.trim().isEmpty)) {
      throw ArgumentError.value(
        respuestaDelNino,
        'respuestaDelNino',
        'cerrar un Misterio exige una respuesta del niño no vacía',
      );
    }
    if (cerradoPorNino == null && respuestaDelNino != null) {
      throw ArgumentError.value(
        respuestaDelNino,
        'respuestaDelNino',
        'no puede haber respuesta del niño sin cerradoPorNino',
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

  /// Estaciones en las que el Misterio aplica, como strings del wire
  /// (`'primavera'`, `'verano'`, `'otono'`, `'invierno'`). Lista vacía
  /// significa **todo el año** — Misterios atemporales (líquenes,
  /// hormigas, encina vieja). Es **dato del catálogo**, no estado del
  /// niño; el cliente sólo lo lee para filtrar qué Misterios se
  /// muestran abiertos según el contexto fenológico actual.
  final List<String> seasons;

  /// Prefijos NUTS de las regiones donde el Misterio aplica. `null` o
  /// lista vacía significa **global** (cualquier región). El shorthand
  /// `'ES-*'` es sinónimo de `'ES'` (España entera). Es **dato del
  /// catálogo**, no estado del niño.
  final List<String>? regions;

  /// Cuándo el niño declaró *"ya tengo mi respuesta"* sobre este
  /// Misterio. **Estado del niño, no del catálogo** — el `estado`
  /// canónico del consenso científico no se mueve al cerrar; lo que se
  /// mueve es el ciclo de pregunta del niño con esta pregunta concreta.
  /// `null` significa que el Misterio sigue abierto para este niño.
  /// Cerrar exige texto en [respuestaDelNino] (validado en el
  /// constructor).
  final DateTime? cerradoPorNino;

  /// Lo que el niño anotó sobre lo que ha aprendido al cerrar este
  /// Misterio. **No es la respuesta canónica** — es el cierre del ciclo
  /// del niño con su pregunta. Texto libre, sin formato, sin
  /// validación más allá de "no vacío" si [cerradoPorNino] no es null.
  final String? respuestaDelNino;

  bool get estaVigente => retiradoEn == null;

  bool get estaCerradoPorNino => cerradoPorNino != null;

  Misterio copyWith({
    String? id,
    String? pregunta,
    String? descripcionCorta,
    NivelConfianza? estado,
    bool? abierto,
    List<String>? observacionesIds,
    DateTime? retiradoEn,
    List<String>? seasons,
    List<String>? regions,
    DateTime? cerradoPorNino,
    String? respuestaDelNino,
  }) {
    return Misterio(
      id: id ?? this.id,
      pregunta: pregunta ?? this.pregunta,
      descripcionCorta: descripcionCorta ?? this.descripcionCorta,
      estado: estado ?? this.estado,
      abierto: abierto ?? this.abierto,
      observacionesIds: observacionesIds ?? this.observacionesIds,
      retiradoEn: retiradoEn ?? this.retiradoEn,
      seasons: seasons ?? this.seasons,
      regions: regions ?? this.regions,
      cerradoPorNino: cerradoPorNino ?? this.cerradoPorNino,
      respuestaDelNino: respuestaDelNino ?? this.respuestaDelNino,
    );
  }

  /// Reabrir un Misterio cerrado: descarta tanto la fecha de cierre
  /// como la respuesta del niño. `copyWith` no sirve para esto porque
  /// el patrón `?? this.x` lo hace incapaz de poner null.
  Misterio reabiertoPorNino() {
    return Misterio(
      id: id,
      pregunta: pregunta,
      descripcionCorta: descripcionCorta,
      estado: estado,
      abierto: abierto,
      observacionesIds: observacionesIds,
      retiradoEn: retiradoEn,
      seasons: seasons,
      regions: regions,
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
        'seasons': seasons,
        if (regions != null) 'regions': regions,
        if (cerradoPorNino != null)
          'cerradoPorNino': cerradoPorNino!.toIso8601String(),
        if (respuestaDelNino != null) 'respuestaDelNino': respuestaDelNino,
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
      seasons: (json['seasons'] as List<dynamic>? ?? const [])
          .cast<String>(),
      regions: json['regions'] == null
          ? null
          : (json['regions'] as List<dynamic>).cast<String>(),
      cerradoPorNino: json['cerradoPorNino'] == null
          ? null
          : DateTime.parse(json['cerradoPorNino'] as String),
      respuestaDelNino: json['respuestaDelNino'] as String?,
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
    if (other.seasons.length != seasons.length) return false;
    for (var indice = 0; indice < seasons.length; indice++) {
      if (other.seasons[indice] != seasons[indice]) return false;
    }
    if ((other.regions == null) != (regions == null)) return false;
    if (regions != null) {
      if (other.regions!.length != regions!.length) return false;
      for (var indice = 0; indice < regions!.length; indice++) {
        if (other.regions![indice] != regions![indice]) return false;
      }
    }
    if (other.cerradoPorNino != cerradoPorNino) return false;
    if (other.respuestaDelNino != respuestaDelNino) return false;
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
        Object.hashAll(seasons),
        regions == null ? null : Object.hashAll(regions!),
        cerradoPorNino,
        respuestaDelNino,
      );
}
