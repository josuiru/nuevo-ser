import 'dart:math' as math;

/// Puzzle ALG.03: el niño ve un sistema 2×2 lineal sencillo y elige el
/// par solución (x, y) entre cuatro candidatos. Encarna sustitución o
/// reducción según el caso. Solución entera garantizada.
class ProblemaSistemaDosXDos {
  /// Coeficientes y términos independientes del sistema:
  ///   a x + b y = c
  ///   d x + e y = f
  final int a;
  final int b;
  final int c;
  final int d;
  final int e;
  final int f;

  /// Cada candidato es un par (x, y).
  final List<({int x, int y})> candidatos;
  final int indiceCorrecto;

  const ProblemaSistemaDosXDos({
    required this.a,
    required this.b,
    required this.c,
    required this.d,
    required this.e,
    required this.f,
    required this.candidatos,
    required this.indiceCorrecto,
  });

  ({int x, int y}) get correcto => candidatos[indiceCorrecto];
  bool esCorrecta(int indice) => indice == indiceCorrecto;

  String _ladoLineal(int coefX, int coefY, int term) {
    final x = coefX == 1
        ? 'x'
        : coefX == -1
            ? '−x'
            : '${coefX}x';
    final yPart = coefY == 1
        ? '+ y'
        : coefY == -1
            ? '− y'
            : coefY > 0
                ? '+ ${coefY}y'
                : '− ${-coefY}y';
    return '$x $yPart = $term';
  }

  String get ecuacionUno => _ladoLineal(a, b, c);
  String get ecuacionDos => _ladoLineal(d, e, f);
}

class GeneradorSistemaDosXDos {
  final math.Random _azar;

  GeneradorSistemaDosXDos({int? semilla}) : _azar = math.Random(semilla);

  /// Genera siempre con solución entera porque construimos a partir de
  /// (x, y) y derivamos (c, f). Coeficientes pequeños para que los
  /// niños puedan probar mentalmente cuando dudan.
  ProblemaSistemaDosXDos generar({int dificultad = 1}) {
    final maxCoef = switch (dificultad) {
      1 => 3,
      2 => 4,
      _ => 5,
    };
    final permitirNegativos = dificultad >= 3;
    final maxXY = dificultad <= 2 ? 7 : 9;

    int sortear({bool conSigno = false}) {
      var v = 1 + _azar.nextInt(maxCoef);
      if (conSigno && _azar.nextBool()) v = -v;
      return v;
    }

    var x = 1 + _azar.nextInt(maxXY);
    var y = 1 + _azar.nextInt(maxXY);
    if (permitirNegativos && _azar.nextBool()) x = -x;
    if (permitirNegativos && _azar.nextBool()) y = -y;

    final aCoef = sortear(conSigno: permitirNegativos);
    final bCoef = sortear(conSigno: permitirNegativos);
    var dCoef = sortear(conSigno: permitirNegativos);
    var eCoef = sortear(conSigno: permitirNegativos);

    // Garantizamos sistema NO degenerado (a*e − b*d != 0).
    if (aCoef * eCoef - bCoef * dCoef == 0) {
      dCoef = dCoef + 1;
      if (aCoef * eCoef - bCoef * dCoef == 0) eCoef = eCoef + 1;
    }

    final cCoef = aCoef * x + bCoef * y;
    final fCoef = dCoef * x + eCoef * y;
    return _construir(
      a: aCoef,
      b: bCoef,
      c: cCoef,
      d: dCoef,
      e: eCoef,
      f: fCoef,
      x: x,
      y: y,
    );
  }

  ProblemaSistemaDosXDos _construir({
    required int a,
    required int b,
    required int c,
    required int d,
    required int e,
    required int f,
    required int x,
    required int y,
  }) {
    final correcto = (x: x, y: y);
    final distractores = <({int x, int y})>{};

    // Distractor: x e y intercambiados.
    if (x != y) distractores.add((x: y, y: x));

    // Distractor: signos invertidos.
    if (correcto != (x: -x, y: -y)) {
      distractores.add((x: -x, y: -y));
    }

    // Distractor: usar c y f directamente como x e y (típico de
    // mirada superficial).
    if ((x: c, y: f) != correcto) distractores.add((x: c, y: f));

    // Distractor: vecino x±1.
    distractores.add((x: x + 1, y: y));
    distractores.add((x: x, y: y + 1));

    distractores.removeWhere((p) => p == correcto);

    final mezclados = distractores.toList()..shuffle(_azar);
    final lista = <({int x, int y})>[correcto, ...mezclados.take(3)];
    lista.shuffle(_azar);
    return ProblemaSistemaDosXDos(
      a: a,
      b: b,
      c: c,
      d: d,
      e: e,
      f: f,
      candidatos: lista,
      indiceCorrecto: lista.indexOf(correcto),
    );
  }
}
