/// Modelo de dominio para *El Faro de Azula* — periódico semanal del
/// lore que el niño lee dentro del juego (sub-mecánica del doc 15
/// sección 16). Cada edición tiene cuatro partes: portada, crónica,
/// cartas al director y acertijo. El banco operativo (v0.2) trae 20
/// ediciones y se carga al juego como asset; la siguiente edición
/// aparece cada viernes calculado a partir del primer viernes que el
/// niño abre el Faro.
///
/// Modelos inmutables. No dependen de Flutter: la pantalla decide
/// cómo se renderizan, este fichero sólo define la forma de los
/// datos.
library;

/// Una edición completa del Faro.
///
/// `numeroSemana` es el índice del banco (1..N) — ordena las ediciones
/// dentro del juego.
///
/// `numeroEdicion` es el número canónico del periódico en el lore
/// (1234, 1235, ...) y `anioOrden` el año (412 al lanzamiento). Son
/// solo decoración del cabecero impreso.
class EdicionFaro {
  const EdicionFaro({
    required this.numeroSemana,
    required this.anioOrden,
    required this.numeroEdicion,
    required this.portada,
    required this.cronica,
    required this.cartas,
    required this.acertijo,
  });

  final int numeroSemana;
  final int anioOrden;
  final int numeroEdicion;
  final List<NoticiaPortada> portada;
  final Cronica cronica;
  final List<CartaAlDirector> cartas;
  final Acertijo acertijo;
}

/// Una noticia de portada. Una edición puede tener varias en orden
/// (en E2, p. ej., conviven "Aciertos de la semana" y "Otra portada
/// — El puente del Mercado vuelve a abrir"). La solución del acertijo
/// de la semana anterior se publica también como una de estas
/// noticias.
class NoticiaPortada {
  const NoticiaPortada({
    required this.titulo,
    required this.cuerpo,
    this.firma,
  });

  final String titulo;
  final String? firma;
  final String cuerpo;
}

/// La crónica firmada por un personaje del lore. Un único bloque por
/// edición.
class Cronica {
  const Cronica({
    required this.titulo,
    required this.firma,
    required this.introduccion,
    required this.cuerpo,
  });

  /// Título sin la firma. Ej.: *Estampas de mi mostrador*.
  final String titulo;

  /// Firma del cronista. Ej.: "por Liana Verde".
  final String firma;

  /// Bloque introductorio en cursiva que presenta al cronista
  /// (oficio, edad, contexto).
  final String introduccion;

  /// Cuerpo principal de la crónica.
  final String cuerpo;
}

/// Una carta al director con su respuesta de la redacción.
class CartaAlDirector {
  const CartaAlDirector({
    required this.pregunta,
    required this.firmante,
    required this.respuesta,
  });

  /// Texto de la carta tal como llega al periódico.
  final String pregunta;

  /// Firmante de la carta (puede ser un seudónimo: "D. de Canales",
  /// "Niño curioso, 10 años", "Anónimo").
  final String firmante;

  /// Respuesta de la redacción.
  final String respuesta;
}

/// Acertijo matemático del final del periódico.
///
/// Cada edición trae un acertijo y la solución del **anterior** se
/// publica como noticia de portada en la siguiente edición.
class Acertijo {
  const Acertijo({
    required this.titulo,
    required this.enunciado,
    required this.solucionCanonica,
    required this.dificultad,
    this.pista,
    this.explicacionSolucion,
  });

  /// Nombre del acertijo (lo que aparece en negrita justo después
  /// del encabezado "Acertijo de la semana"). Ej.: "El reparto de
  /// las naranjas".
  final String titulo;

  final String enunciado;

  /// Pista opcional que el periódico ofrece junto al enunciado.
  final String? pista;

  /// Solución canónica en forma corta — la usa la validación cuando
  /// el niño envía respuesta. Ej.: "20", "7,5 grados", "12 kg
  /// manzanas, 8 kg uvas".
  final String solucionCanonica;

  /// Texto opcional que explica cómo se llega a la solución. Es lo
  /// que aparece en la portada de la edición siguiente (no se
  /// muestra en la propia edición del acertijo).
  final String? explicacionSolucion;

  final NivelDificultadAcertijo dificultad;
}

/// Calibración aproximada del acertijo. Se mapea con el rango del
/// jugador para introducir el escalonado del banco inicial (suaves
/// al principio, más exigentes al final).
enum NivelDificultadAcertijo {
  aprendizI,
  aprendizII,
  aprendizIII,
  iniciadoI,
  iniciadoII,
}
