import 'dart:math' as math;

/// Puzzle ALG.02: el niño ve `ax + b = cx + d` (incógnita en ambos
/// lados) y elige x entre cuatro candidatos. Segundo escalón del
/// dominio ALG: ya no basta despejar — hay que agrupar las x en un
/// lado primero. Solución entera garantizada por construcción.
class ProblemaEcuacionAmbosLados {
  final int a;
  final int b;
  final int c;
  final int d;

  final List<int> candidatos;
  final int indiceCorrecto;

  const ProblemaEcuacionAmbosLados({
    required this.a,
    required this.b,
    required this.c,
    required this.d,
    required this.candidatos,
    required this.indiceCorrecto,
  });

  /// Solución: x = (d - b) / (a - c). a != c por construcción.
  int get correcto => (d - b) ~/ (a - c);
  bool esCorrecta(int indice) => indice == indiceCorrecto;

  /// Etiqueta visual lista para mostrar.
  String get etiqueta {
    final izda = _ladoLineal(a, b);
    final dcha = _ladoLineal(c, d);
    return '$izda = $dcha';
  }

  static String _ladoLineal(int coef, int term) {
    final coefStr = coef == 1
        ? 'x'
        : coef == -1
            ? '−x'
            : '${coef}x';
    if (term == 0) return coefStr;
    if (term > 0) return '$coefStr + $term';
    return '$coefStr − ${-term}';
  }
}

/// Genera ecuaciones con incógnita en ambos lados con solución entera.
///   - Dif 1: a∈[2..4], c∈[1..a-1] (siempre a > c, x positivo pequeño).
///   - Dif 2: a∈[2..6], c∈[1..a-1], b y d ≤ 9.
///   - Dif 3: x puede ser negativo, a y c pueden cruzarse en signo.
///   - Dif 4: coeficientes hasta 9, incluye casos con x negativo.
class GeneradorEcuacionAmbosLados {
  final math.Random _azar;

  GeneradorEcuacionAmbosLados({int? semilla}) : _azar = math.Random(semilla);

  ProblemaEcuacionAmbosLados generar({int dificultad = 1}) {
    final maxCoef = switch (dificultad) {
      1 => 4,
      2 => 6,
      3 => 7,
      _ => 9,
    };
    final permitirNegativos = dificultad >= 3;

    // Garantizamos a != c y |a-c| >= 1.
    var a = 2 + _azar.nextInt(maxCoef - 1);
    var c = 1 + _azar.nextInt(a - 1);
    if (permitirNegativos && _azar.nextBool()) {
      // Intercambia rol — c puede ser mayor — pero mantenemos a != c.
      final tmp = a;
      a = c;
      c = tmp;
    }

    final maxX = dificultad <= 2 ? 9 : 7;
    var x = 1 + _azar.nextInt(maxX);
    if (permitirNegativos && _azar.nextBool()) x = -x;

    final maxTerm = dificultad <= 2 ? 9 : 12;
    final b = (permitirNegativos && _azar.nextBool() ? -1 : 1) *
        (1 + _azar.nextInt(maxTerm));
    // d se calcula para garantizar la solución x: d = (a-c)*x + b.
    final d = (a - c) * x + b;

    return _construir(a: a, b: b, c: c, d: d);
  }

  ProblemaEcuacionAmbosLados _construir({
    required int a,
    required int b,
    required int c,
    required int d,
  }) {
    final correcto = (d - b) ~/ (a - c);
    final distractores = <int>{};

    // Distractor estrella: olvidar mover las x — calcular (d-b)/a.
    if ((d - b) % a == 0) {
      final sinAgrupar = (d - b) ~/ a;
      if (sinAgrupar != correcto) distractores.add(sinAgrupar);
    }

    // Distractor: cambio de signo en el correcto.
    if (-correcto != correcto && -correcto != 0) {
      distractores.add(-correcto);
    }

    // Distractor: usar a+c en lugar de a-c en el denominador.
    if (a + c != 0 && (d - b) % (a + c) == 0) {
      final sumando = (d - b) ~/ (a + c);
      if (sumando != correcto) distractores.add(sumando);
    }

    // Distractor: ±1.
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
    return ProblemaEcuacionAmbosLados(
      a: a,
      b: b,
      c: c,
      d: d,
      candidatos: lista,
      indiceCorrecto: lista.indexOf(correcto),
    );
  }
}
