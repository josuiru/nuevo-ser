import 'dart:math' as math;

/// Puzzle FUN.01: el niño ve una tabla de pares `(x, y)` y elige la
/// función `y = mx + n` correspondiente. Primer puzzle del dominio
/// FUN — entrada al pensamiento funcional. La tabla siempre encaja
/// exactamente en una relación lineal entera.
class ProblemaRelacionLineal {
  /// Pendiente de la recta verdadera.
  final int m;

  /// Ordenada en el origen.
  final int n;

  /// Pares (x, y) que el niño verá tabulados, mostrados en este
  /// orden. Por construcción, `y = m*x + n` en cada uno.
  final List<({int x, int y})> tabla;

  /// Cuatro candidatos: cada uno con su propia (m, n). El correcto
  /// está en `indiceCorrecto`.
  final List<({int m, int n})> candidatos;
  final int indiceCorrecto;

  const ProblemaRelacionLineal({
    required this.m,
    required this.n,
    required this.tabla,
    required this.candidatos,
    required this.indiceCorrecto,
  });

  bool esCorrecta(int indice) => indice == indiceCorrecto;
}

class GeneradorRelacionLineal {
  final math.Random _azar;

  GeneradorRelacionLineal({int? semilla}) : _azar = math.Random(semilla);

  /// Dificultad escala los rangos de m y n y la longitud de la tabla.
  ///   - Dif 1: m∈[1..4], n=0, tabla de 3 filas (proporción directa).
  ///   - Dif 2: m∈[1..5], n∈[-3..3], tabla de 3 filas.
  ///   - Dif 3+: m incluye negativos, n más amplio, 4 filas.
  ProblemaRelacionLineal generar({int dificultad = 1}) {
    final permitirNAbsCero = dificultad >= 2;
    final permitirMNegativo = dificultad >= 3;
    final maxAbsM = dificultad <= 2 ? 5 : 6;
    final maxAbsN = dificultad <= 2 ? 3 : 5;
    final filas = dificultad <= 2 ? 3 : 4;

    var m = 1 + _azar.nextInt(maxAbsM);
    if (permitirMNegativo && _azar.nextBool()) m = -m;

    var n = 0;
    if (permitirNAbsCero) {
      n = _azar.nextInt(maxAbsN * 2 + 1) - maxAbsN;
    }

    // Genera valores de x consecutivos pequeños (-1 a filas-2 o 1 a filas).
    final xInicio = dificultad >= 3 ? -1 : 1;
    final tabla = <({int x, int y})>[];
    for (var i = 0; i < filas; i++) {
      final x = xInicio + i;
      tabla.add((x: x, y: m * x + n));
    }

    return _construir(m: m, n: n, tabla: tabla);
  }

  ProblemaRelacionLineal _construir({
    required int m,
    required int n,
    required List<({int x, int y})> tabla,
  }) {
    final correcto = (m: m, n: n);
    final distractores = <({int m, int n})>{};

    // Distractor estrella: leer m del primer (x, y) como si y fuera m
    // (`(1, 5) → m=5, n=0` cuando en realidad es `m=2, n=3`).
    final primerYComoM = (m: tabla[0].y, n: 0);
    if (primerYComoM != correcto) distractores.add(primerYComoM);

    // Distractor: pendiente y ordenada intercambiadas.
    if (m != n) distractores.add((m: n, n: m));

    // Distractor: pendiente con signo invertido.
    if (-m != m) distractores.add((m: -m, n: n));

    // Distractor: ordenada con signo invertido.
    if (n != 0 && -n != n) distractores.add((m: m, n: -n));

    // Distractor: m±1.
    distractores.add((m: m + 1, n: n));
    distractores.add((m: m - 1, n: n));

    distractores.removeWhere((p) => p == correcto);
    final mezclados = distractores.toList()..shuffle(_azar);
    final lista = <({int m, int n})>[correcto, ...mezclados.take(3)];
    lista.shuffle(_azar);
    return ProblemaRelacionLineal(
      m: m,
      n: n,
      tabla: tabla,
      candidatos: lista,
      indiceCorrecto: lista.indexOf(correcto),
    );
  }
}

/// Helper para formatear `y = mx + n` de forma legible.
String formatearRectaCanonica(int m, int n) {
  final mPart = m == 1
      ? 'x'
      : m == -1
          ? '−x'
          : '${m}x';
  if (n == 0) return 'y = $mPart';
  if (n > 0) return 'y = $mPart + $n';
  return 'y = $mPart − ${-n}';
}
