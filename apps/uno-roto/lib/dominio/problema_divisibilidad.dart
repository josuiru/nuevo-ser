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

    final int candidato;
    if (queremosDivisible) {
      // Construimos el múltiplo directamente para garantizar el
      // resultado pedido: con divisor=9 y rango [10, 200) el método
      // anterior fallaba ~2,5 % de las tiradas (densidad de múltiplos
      // ~11 %, 30 intentos de rechazo). Aquí elegimos directamente
      // un k tal que k·divisor caiga en [minimo, máximo).
      final kMin = (minimo / divisor).ceil().clamp(1, 1 << 30);
      final kMax = ((maximo - 1) ~/ divisor).clamp(kMin, 1 << 30);
      final k = kMin + _azar.nextInt(kMax - kMin + 1);
      candidato = k * divisor;
    } else {
      // Para no-divisibles, el rechazo uniforme es seguro: la
      // densidad de no-múltiplos es ≥ (1 − 1/2) = 50 % en el peor
      // caso y 30 intentos saturan probabilísticamente.
      var c = minimo + _azar.nextInt(maximo - minimo);
      var intentos = 0;
      while (c % divisor == 0 && intentos < 30) {
        c = minimo + _azar.nextInt(maximo - minimo);
        intentos++;
      }
      candidato = c;
    }

    return ProblemaDivisibilidad(numero: candidato, divisor: divisor);
  }
}
