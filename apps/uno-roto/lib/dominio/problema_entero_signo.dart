import 'dart:math' as math;

/// Puzzle ARI.04: el niño ve `a ± b` con uno o ambos sumandos
/// negativos y elige el resultado entre cuatro candidatos. Entrada al
/// concepto de número entero con signo.
class ProblemaEnteroSigno {
  /// Primer operando (con signo).
  final int a;

  /// Segundo operando (con signo).
  final int b;

  /// Operador: suma o resta. La resta se interpreta como `a - b`.
  final OperadorEntero operador;

  final List<int> candidatos;
  final int indiceCorrecto;

  const ProblemaEnteroSigno({
    required this.a,
    required this.b,
    required this.operador,
    required this.candidatos,
    required this.indiceCorrecto,
  });

  int get correcto => switch (operador) {
        OperadorEntero.suma => a + b,
        OperadorEntero.resta => a - b,
      };

  bool esCorrecta(int indice) => indice == indiceCorrecto;

  /// "−5 + 3", "7 − (−2)", etc. Usa el guión Unicode "−" (no el ASCII)
  /// para que el signo de operación se distinga del menos del número.
  String get etiqueta {
    final ladoIzdo = _conSigno(a);
    final op = operador == OperadorEntero.suma ? '+' : '−';
    final ladoDcho = b < 0 ? '(${_conSigno(b)})' : '$b';
    return '$ladoIzdo $op $ladoDcho';
  }

  static String _conSigno(int n) => n < 0 ? '−${-n}' : '$n';
}

enum OperadorEntero { suma, resta }

/// Genera operaciones con enteros signados.
///   - Dif 1: suma con un negativo, valores ≤9.
///   - Dif 2: suma con dos negativos posibles, valores ≤9.
///   - Dif 3: introduce resta, valores ≤12.
///   - Dif 4+: combinación libre, valores ≤15.
class GeneradorEnteroSigno {
  final math.Random _azar;

  GeneradorEnteroSigno({int? semilla}) : _azar = math.Random(semilla);

  ProblemaEnteroSigno generar({int dificultad = 1}) {
    final permitirResta = dificultad >= 3;
    final maxAbs = switch (dificultad) {
      1 => 9,
      2 => 9,
      3 => 12,
      _ => 15,
    };

    final operador = (permitirResta && _azar.nextBool())
        ? OperadorEntero.resta
        : OperadorEntero.suma;

    var a = 1 + _azar.nextInt(maxAbs);
    var b = 1 + _azar.nextInt(maxAbs);
    // Al menos uno con signo negativo, casi siempre.
    final negA = _azar.nextDouble() < 0.55;
    final negB = _azar.nextDouble() < (dificultad >= 2 ? 0.5 : 0.3);
    if (negA) a = -a;
    if (negB) b = -b;
    if (!negA && !negB) a = -a; // Garantiza ≥1 negativo.

    return _construir(a: a, b: b, operador: operador);
  }

  ProblemaEnteroSigno _construir({
    required int a,
    required int b,
    required OperadorEntero operador,
  }) {
    final correcto = operador == OperadorEntero.suma ? a + b : a - b;
    final distractores = <int>{};

    // Distractor estrella: ignorar signos (operar con valores absolutos
    // como si fuesen positivos).
    final ignorandoSignos = operador == OperadorEntero.suma
        ? a.abs() + b.abs()
        : (a.abs() - b.abs()).abs();
    if (ignorandoSignos != correcto) distractores.add(ignorandoSignos);

    // Distractor: cambio de signo en el correcto.
    if (-correcto != correcto) distractores.add(-correcto);

    // Distractor: confundir operación (sumar en lugar de restar y vv).
    final operadorContrario = operador == OperadorEntero.suma
        ? a - b
        : a + b;
    if (operadorContrario != correcto) {
      distractores.add(operadorContrario);
    }

    if (distractores.length < 3) distractores.add(correcto + 1);
    if (distractores.length < 3) distractores.add(correcto - 1);

    var k = 2;
    while (distractores.length < 3 && k < 50) {
      final candidato = correcto + k;
      k++;
      if (candidato == correcto) continue;
      if (distractores.contains(candidato)) continue;
      distractores.add(candidato);
    }

    final lista = <int>[correcto, ...distractores.take(3)];
    lista.shuffle(_azar);
    return ProblemaEnteroSigno(
      a: a,
      b: b,
      operador: operador,
      candidatos: lista,
      indiceCorrecto: lista.indexOf(correcto),
    );
  }
}
