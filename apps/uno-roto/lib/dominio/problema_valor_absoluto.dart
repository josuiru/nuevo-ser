import 'dart:math' as math;

/// Puzzle ARI.05: el niño ve `|n|` o `|a − b|` y elige su valor entre
/// cuatro candidatos. Pedagogía del "lo que dista del cero", sin
/// confundir con el signo.
class ProblemaValorAbsoluto {
  /// Modo: número simple `|n|` o expresión `|a − b|` (más exigente).
  final ModoValorAbsoluto modo;

  /// Argumento principal — n en modo simple, a en modo expresión.
  final int a;

  /// Solo en modo expresión: el segundo término.
  final int b;

  final List<int> candidatos;
  final int indiceCorrecto;

  const ProblemaValorAbsoluto({
    required this.modo,
    required this.a,
    required this.b,
    required this.candidatos,
    required this.indiceCorrecto,
  });

  int get correcto => switch (modo) {
        ModoValorAbsoluto.simple => a.abs(),
        ModoValorAbsoluto.expresion => (a - b).abs(),
      };

  bool esCorrecta(int indice) => indice == indiceCorrecto;

  String get etiqueta {
    if (modo == ModoValorAbsoluto.simple) {
      final aTxt = a < 0 ? '−${-a}' : '$a';
      return '|$aTxt|';
    }
    final aTxt = a < 0 ? '−${-a}' : '$a';
    final bTxt = b < 0 ? '−${-b}' : '$b';
    return '|$aTxt − $bTxt|';
  }
}

enum ModoValorAbsoluto { simple, expresion }

class GeneradorValorAbsoluto {
  final math.Random _azar;

  GeneradorValorAbsoluto({int? semilla}) : _azar = math.Random(semilla);

  ProblemaValorAbsoluto generar({int dificultad = 1}) {
    final modo = dificultad >= 3
        ? ModoValorAbsoluto.expresion
        : ModoValorAbsoluto.simple;
    final maxAbs = dificultad <= 2 ? 12 : 20;
    var a = 1 + _azar.nextInt(maxAbs);
    if (_azar.nextBool()) a = -a;
    var b = 0;
    if (modo == ModoValorAbsoluto.expresion) {
      b = 1 + _azar.nextInt(maxAbs);
      if (_azar.nextBool()) b = -b;
    }
    return _construir(modo: modo, a: a, b: b);
  }

  ProblemaValorAbsoluto _construir({
    required ModoValorAbsoluto modo,
    required int a,
    required int b,
  }) {
    final correcto = modo == ModoValorAbsoluto.simple
        ? a.abs()
        : (a - b).abs();
    final distractores = <int>{};

    // Distractor estrella: el propio número con signo (no quitarlo).
    if (modo == ModoValorAbsoluto.simple && a != correcto) {
      distractores.add(a);
    }
    if (modo == ModoValorAbsoluto.expresion) {
      // Distractor: ignorar las barras (a - b sin pasar por absoluto).
      final sinAbsoluto = a - b;
      if (sinAbsoluto != correcto) distractores.add(sinAbsoluto);
      // Distractor: sumar en lugar de restar.
      final sumando = (a + b).abs();
      if (sumando != correcto) distractores.add(sumando);
    }

    // Distractor: signo cambiado.
    if (-correcto != correcto && -correcto != 0) {
      distractores.add(-correcto);
    }

    if (distractores.length < 3) distractores.add(correcto + 1);
    if (distractores.length < 3 && correcto > 1) {
      distractores.add(correcto - 1);
    }

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
    return ProblemaValorAbsoluto(
      modo: modo,
      a: a,
      b: b,
      candidatos: lista,
      indiceCorrecto: lista.indexOf(correcto),
    );
  }
}
