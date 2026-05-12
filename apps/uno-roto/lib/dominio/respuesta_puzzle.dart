/// Lo que el niño respondió en un puzzle y lo que era correcto.
/// Cada pantalla de puzzle escribe aquí antes de cerrarse, para que
/// el tutor IA sepa exactamente qué opción tocó el niño.
class RespuestaPuzzle {
  final bool acertado;
  final String respuestaDelNino;
  final String respuestaCorrecta;
  final String preguntaTexto;
  final List<String> opciones;

  const RespuestaPuzzle({
    required this.acertado,
    required this.respuestaDelNino,
    required this.respuestaCorrecta,
    required this.preguntaTexto,
    required this.opciones,
  });
}

/// Holder global de la última respuesta. Evita cambiar la firma de
/// navegación de 50+ pantallas de puzzle.
class UltimaRespuestaPuzzle {
  static RespuestaPuzzle? _ultima;
  static RespuestaPuzzle? get ultima => _ultima;
  static void registrar(RespuestaPuzzle r) => _ultima = r;
  static void limpiar() => _ultima = null;
}
