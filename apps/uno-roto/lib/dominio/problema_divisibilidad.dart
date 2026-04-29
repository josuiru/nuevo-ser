import 'dart:math' as math;

/// Cómo se le pide al niño la decisión: el cálculo es el mismo (resto
/// cero) pero la pregunta cambia según la habilidad.
/// - [divisible] → DIV.03/DIV.04: "¿es divisible entre N?"
/// - [multiplo] → DIV.01: "¿N es múltiplo de M?"
enum ModoFraseoDivisibilidad { divisible, multiplo }

/// Problema de divisibilidad: se muestra un número y un divisor, el
/// niño decide si es o no divisible. Decisión binaria — primer puzzle
/// de Uno Roto que se responde con sí/no, no con elección entre
/// candidatos.
class ProblemaDivisibilidad {
  final int numero;
  final int divisor;

  const ProblemaDivisibilidad({
    required this.numero,
    required this.divisor,
  });

  bool get esDivisible => numero % divisor == 0;

  /// Tras la respuesta del niño, [esCorrecta] resuelve si acertó.
  bool esCorrecta(bool respuestaSi) => respuestaSi == esDivisible;
}

/// Genera problemas de divisibilidad equilibrados entre sí y no, con
/// números y divisores apropiados al nivel. Rechaza casos triviales
/// (todo número es divisible entre 1) y casos ambiguos.
class GeneradorDivisibilidad {
  final math.Random _azar;

  /// Divisores que acepta este generador. Por defecto los del FR/DIV.03
  /// (criterios básicos: 2, 3, 5, 10). Para DIV.04 se sustituye por
  /// {4, 6, 9}.
  final List<int> divisoresPermitidos;

  GeneradorDivisibilidad({
    int? semilla,
    this.divisoresPermitidos = const [2, 3, 5, 10],
  })  : assert(divisoresPermitidos.isNotEmpty,
            'Debe haber al menos un divisor permitido'),
        _azar = math.Random(semilla);

  /// [dificultad] modula el rango del número candidato. Buscamos un
  /// equilibrio aproximado entre casos divisibles e indivisibles a lo
  /// largo de muchas tiradas.
  ProblemaDivisibilidad generar({int dificultad = 1}) {
    final divisor =
        divisoresPermitidos[_azar.nextInt(divisoresPermitidos.length)];

    // Decidimos primero si queremos un caso "sí" o "no", para que el
    // niño no se acostumbre a una sola respuesta.
    final queremosDivisible = _azar.nextBool();
    final maximo = dificultad >= 3 ? 300 : 200;
    const minimo = 10;

    int candidato;
    var intentos = 0;
    do {
      candidato = minimo + _azar.nextInt(maximo - minimo);
      intentos++;
    } while ((candidato % divisor == 0) != queremosDivisible &&
        intentos < 30);

    return ProblemaDivisibilidad(numero: candidato, divisor: divisor);
  }
}
