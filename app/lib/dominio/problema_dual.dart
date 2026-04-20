import 'dart:math' as math;

import 'problema_espejo.dart';

/// Suma de dos fracciones (a/b + c/d). El puzzle pide al niño elegir
/// el resultado correcto entre cuatro candidatos; los distractores
/// representan los errores típicos: sumar numerador-con-numerador y
/// denominador-con-denominador (la trampa clásica de 10-11 años) y
/// denominadores mal escogidos.
class ProblemaDual {
  final Fraccion sumandoA;
  final Fraccion sumandoB;
  final List<Fraccion> candidatos;
  final int indiceCorrecto;

  const ProblemaDual({
    required this.sumandoA,
    required this.sumandoB,
    required this.candidatos,
    required this.indiceCorrecto,
  });

  String get etiqueta => '${sumandoA.etiqueta} + ${sumandoB.etiqueta}';
}

class GeneradorDual {
  final math.Random _azar;

  GeneradorDual({int? semilla}) : _azar = math.Random(semilla);

  /// Genera un problema Dual dado dos sumandos fijos (los que aparecían
  /// en el Fragmento del tejado).
  ProblemaDual generarDesde({
    required Fraccion sumandoA,
    required Fraccion sumandoB,
  }) {
    final mcm = _mcm(sumandoA.denominador, sumandoB.denominador);
    final numCorrecto =
        sumandoA.numerador * (mcm ~/ sumandoA.denominador) +
            sumandoB.numerador * (mcm ~/ sumandoB.denominador);
    final correcto = Fraccion(numCorrecto, mcm).reducida();

    final distractores = <Fraccion>{};

    // Distractor clásico: sumar num-con-num y den-con-den.
    final trampaClasica = Fraccion(
      sumandoA.numerador + sumandoB.numerador,
      sumandoA.denominador + sumandoB.denominador,
    );
    if (!trampaClasica.esEquivalenteA(correcto)) {
      distractores.add(trampaClasica);
    }

    // Distractor: mismo numerador, denominador producto.
    final productoDens = Fraccion(
      sumandoA.numerador + sumandoB.numerador,
      sumandoA.denominador * sumandoB.denominador,
    );
    if (!productoDens.esEquivalenteA(correcto) &&
        !distractores.any((d) =>
            d.numerador == productoDens.numerador &&
            d.denominador == productoDens.denominador)) {
      distractores.add(productoDens);
    }

    // Completar hasta tres con perturbaciones del numerador correcto.
    while (distractores.length < 3) {
      final deltaNum = _azar.nextInt(4) - 2;
      final candidato = Fraccion(
        math.max(1, correcto.numerador + deltaNum),
        correcto.denominador,
      );
      if (candidato.esEquivalenteA(correcto)) continue;
      if (distractores.any((d) =>
          d.numerador == candidato.numerador &&
          d.denominador == candidato.denominador)) {
        continue;
      }
      distractores.add(candidato);
    }

    final candidatos = <Fraccion>[correcto, ...distractores.take(3)];
    candidatos.shuffle(_azar);
    final indiceCorrecto = candidatos.indexWhere(
      (c) => c.esEquivalenteA(correcto) &&
          c.numerador == correcto.numerador &&
          c.denominador == correcto.denominador,
    );
    final indiceRespaldo = indiceCorrecto >= 0
        ? indiceCorrecto
        : candidatos.indexWhere((c) => c.esEquivalenteA(correcto));

    return ProblemaDual(
      sumandoA: sumandoA,
      sumandoB: sumandoB,
      candidatos: candidatos,
      indiceCorrecto: indiceRespaldo >= 0 ? indiceRespaldo : 0,
    );
  }

  static int _mcm(int a, int b) {
    return (a * b) ~/ _mcd(a, b);
  }

  static int _mcd(int a, int b) {
    while (b != 0) {
      final resto = a % b;
      a = b;
      b = resto;
    }
    return a;
  }
}
