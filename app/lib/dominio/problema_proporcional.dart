import 'dart:math' as math;

/// Un problema de proporcionalidad: dada una razón [a : b], se muestra
/// una segunda razón incompleta [c : ?] y el niño debe elegir el valor
/// que mantiene la proporción (es decir, c tal que a*? == b*c).
class ProblemaProporcional {
  final int a;
  final int b;
  final int c;
  final List<int> candidatos;
  final int indiceCorrecto;

  const ProblemaProporcional({
    required this.a,
    required this.b,
    required this.c,
    required this.candidatos,
    required this.indiceCorrecto,
  });

  String get razonOrigen => '$a : $b';
  String get razonIncompleta => '$c : ?';

  int get respuestaCorrecta => candidatos[indiceCorrecto];
}

class GeneradorProporcional {
  final math.Random _azar;

  GeneradorProporcional({int? semilla}) : _azar = math.Random(semilla);

  ProblemaProporcional generarDesde({required int a, required int b}) {
    // Elegimos un multiplicador entero entre 2 y 5.
    final multiplicador = 2 + _azar.nextInt(4);
    final c = a * multiplicador;
    final respuestaCorrecta = b * multiplicador;

    final distractores = <int>{};
    var intentos = 0;
    while (distractores.length < 3 && intentos < 40) {
      intentos++;
      final candidato = _generarDistractor(
        correcto: respuestaCorrecta,
        b: b,
      );
      if (candidato == respuestaCorrecta) continue;
      distractores.add(candidato);
    }
    while (distractores.length < 3) {
      distractores.add(respuestaCorrecta + 3 + distractores.length);
    }

    final candidatos = <int>[respuestaCorrecta, ...distractores];
    candidatos.shuffle(_azar);
    final indiceCorrecto = candidatos.indexOf(respuestaCorrecta);

    return ProblemaProporcional(
      a: a,
      b: b,
      c: c,
      candidatos: candidatos,
      indiceCorrecto: indiceCorrecto,
    );
  }

  int _generarDistractor({required int correcto, required int b}) {
    final estrategia = _azar.nextInt(3);
    switch (estrategia) {
      case 0:
        // Error típico: sumar en vez de multiplicar (b + delta pequeño).
        return math.max(1, correcto + (_azar.nextInt(4) - 2 + _signo()));
      case 1:
        // Múltiplo cercano equivocado (p. ej. mitad, doble, ±b).
        final delta = b + _signo() * (_azar.nextInt(2) + 1);
        return math.max(1, correcto + delta * _signo());
      case 2:
      default:
        // Un número cercano arbitrario.
        return math.max(1, correcto + _azar.nextInt(7) - 3);
    }
  }

  int _signo() => _azar.nextBool() ? 1 : -1;
}
