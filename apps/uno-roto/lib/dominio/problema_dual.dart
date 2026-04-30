import 'dart:math' as math;

import 'fragmento_en_tejado.dart'
    show OperadorAritmetico, SimboloOperador;
import 'problema_espejo.dart';

/// Operación aritmética sobre dos fracciones (a/b OP c/d). El puzzle
/// pide al niño elegir el resultado correcto entre cuatro candidatos.
class ProblemaDual {
  final Fraccion sumandoA;
  final Fraccion sumandoB;
  final OperadorAritmetico operador;
  final List<Fraccion> candidatos;
  final int indiceCorrecto;

  const ProblemaDual({
    required this.sumandoA,
    required this.sumandoB,
    required this.operador,
    required this.candidatos,
    required this.indiceCorrecto,
  });

  String get etiqueta =>
      '${sumandoA.etiqueta} ${operador.simbolo} ${sumandoB.etiqueta}';
}

class GeneradorDual {
  final math.Random _azar;

  GeneradorDual({int? semilla}) : _azar = math.Random(semilla);

  /// Genera un problema Dual dados los dos operandos y el operador.
  ProblemaDual generarDesde({
    required Fraccion sumandoA,
    required Fraccion sumandoB,
    OperadorAritmetico operador = OperadorAritmetico.suma,
  }) {
    final correcto = _calcularResultado(sumandoA, sumandoB, operador);
    final distractores = _generarDistractores(
      sumandoA: sumandoA,
      sumandoB: sumandoB,
      operador: operador,
      correcto: correcto,
    );

    final candidatos = <Fraccion>[correcto, ...distractores.take(3)];
    candidatos.shuffle(_azar);
    final indiceCorrecto = candidatos.indexWhere(
      (c) => c.numerador == correcto.numerador &&
          c.denominador == correcto.denominador,
    );
    final indiceRespaldo = indiceCorrecto >= 0
        ? indiceCorrecto
        : candidatos.indexWhere((c) => c.esEquivalenteA(correcto));

    return ProblemaDual(
      sumandoA: sumandoA,
      sumandoB: sumandoB,
      operador: operador,
      candidatos: candidatos,
      indiceCorrecto: indiceRespaldo >= 0 ? indiceRespaldo : 0,
    );
  }

  Fraccion _calcularResultado(
    Fraccion a,
    Fraccion b,
    OperadorAritmetico operador,
  ) {
    switch (operador) {
      case OperadorAritmetico.suma:
        {
          final mcm = _mcm(a.denominador, b.denominador);
          final num =
              a.numerador * (mcm ~/ a.denominador) +
                  b.numerador * (mcm ~/ b.denominador);
          return Fraccion(num, mcm).reducida();
        }
      case OperadorAritmetico.resta:
        {
          final mcm = _mcm(a.denominador, b.denominador);
          final num =
              a.numerador * (mcm ~/ a.denominador) -
                  b.numerador * (mcm ~/ b.denominador);
          return Fraccion(num, mcm).reducida();
        }
      case OperadorAritmetico.producto:
        return Fraccion(
          a.numerador * b.numerador,
          a.denominador * b.denominador,
        ).reducida();
      case OperadorAritmetico.division:
        return Fraccion(
          a.numerador * b.denominador,
          a.denominador * b.numerador,
        ).reducida();
    }
  }

  Set<Fraccion> _generarDistractores({
    required Fraccion sumandoA,
    required Fraccion sumandoB,
    required OperadorAritmetico operador,
    required Fraccion correcto,
  }) {
    final distractores = <Fraccion>{};

    // Distractor clásico: el error común por operador.
    final trampaClasica = _trampaClasica(sumandoA, sumandoB, operador);
    if (trampaClasica != null &&
        !trampaClasica.esEquivalenteA(correcto) &&
        trampaClasica.denominador != 0) {
      distractores.add(trampaClasica);
    }

    // Distractor: otro error plausible pero distinto.
    final alternativo = _trampaAlternativa(sumandoA, sumandoB, operador);
    if (alternativo != null &&
        !alternativo.esEquivalenteA(correcto) &&
        alternativo.denominador != 0 &&
        !distractores.any((d) =>
            d.numerador == alternativo.numerador &&
            d.denominador == alternativo.denominador)) {
      distractores.add(alternativo);
    }

    // Completar con perturbaciones del correcto.
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

    return distractores;
  }

  /// Errores "clásicos" por operador: el típico que comete un niño
  /// que no ha interiorizado la operación.
  Fraccion? _trampaClasica(
    Fraccion a,
    Fraccion b,
    OperadorAritmetico operador,
  ) {
    switch (operador) {
      case OperadorAritmetico.suma:
        // Sumar num-con-num y den-con-den.
        return Fraccion(
          a.numerador + b.numerador,
          a.denominador + b.denominador,
        );
      case OperadorAritmetico.resta:
        // El error clásico (restar num-con-num, den-con-den) puede
        // producir denominador cero o negativo si a.den ≤ b.den. En
        // ese caso devolvemos null y el bucle de perturbaciones
        // rellena el cuarto candidato.
        final denResta = a.denominador - b.denominador;
        if (denResta <= 0) return null;
        final numResta = a.numerador - b.numerador;
        if (numResta <= 0) return null;
        return Fraccion(numResta, denResta);
      case OperadorAritmetico.producto:
        // Hacer denominador común innecesario.
        final mcm = _mcm(a.denominador, b.denominador);
        return Fraccion(
          a.numerador * (mcm ~/ a.denominador) +
              b.numerador * (mcm ~/ b.denominador),
          mcm,
        ).reducida();
      case OperadorAritmetico.division:
        // Invertir la primera en vez de la segunda. Si numerador de
        // a es 0, el "denominador" de la trampa también, así que
        // devolvemos null para que se descarte como distractor.
        if (a.numerador == 0) return null;
        return Fraccion(
          a.denominador * b.numerador,
          a.numerador * b.denominador,
        );
    }
  }

  Fraccion? _trampaAlternativa(
    Fraccion a,
    Fraccion b,
    OperadorAritmetico operador,
  ) {
    switch (operador) {
      case OperadorAritmetico.suma:
      case OperadorAritmetico.resta:
        // Mismo numerador que el correcto pero con denominador producto.
        return Fraccion(
          a.numerador + b.numerador,
          a.denominador * b.denominador,
        );
      case OperadorAritmetico.producto:
        // Producto sin simplificar con algún error.
        return Fraccion(
          a.numerador + b.numerador,
          a.denominador * b.denominador,
        );
      case OperadorAritmetico.division:
        // Multiplicar directamente en vez de invertir.
        return Fraccion(
          a.numerador * b.numerador,
          a.denominador * b.denominador,
        );
    }
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
