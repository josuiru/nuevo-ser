import 'dart:math' as math;

import 'problema_espejo.dart' show Fraccion;

/// Tres categorías mutuamente excluyentes: la fracción es propia
/// (< 1), igual a 1, o impropia (> 1).
enum RelacionConUnidad { menor, igual, mayor }

/// Problema FR.04: el niño ve una fracción y la clasifica respecto a 1.
/// El generador procura que las tres categorías aparezcan, con sesgo a
/// propias e impropias (las que el niño usa más) y un porcentaje
/// pequeño dedicado a "igual" — el caso n/n que se suele pasar por alto.
class ProblemaComparacionUnidad {
  final Fraccion fraccion;

  const ProblemaComparacionUnidad({required this.fraccion});

  RelacionConUnidad get relacionCorrecta {
    if (fraccion.numerador < fraccion.denominador) return RelacionConUnidad.menor;
    if (fraccion.numerador > fraccion.denominador) return RelacionConUnidad.mayor;
    return RelacionConUnidad.igual;
  }

  bool esCorrecta(RelacionConUnidad respuesta) =>
      respuesta == relacionCorrecta;
}

class GeneradorComparacionUnidad {
  final math.Random _azar;

  GeneradorComparacionUnidad({int? semilla}) : _azar = math.Random(semilla);

  /// Reparto aproximado: 45 % propias, 45 % impropias, 10 % iguales.
  /// Ajustamos por dificultad: mismas proporciones, pero con
  /// denominadores mayores cuando la dificultad sube.
  ProblemaComparacionUnidad generar({int dificultad = 1}) {
    final tirada = _azar.nextDouble();
    final RelacionConUnidad objetivo;
    if (tirada < 0.10) {
      objetivo = RelacionConUnidad.igual;
    } else if (tirada < 0.55) {
      objetivo = RelacionConUnidad.menor;
    } else {
      objetivo = RelacionConUnidad.mayor;
    }
    return ProblemaComparacionUnidad(
      fraccion: _fabricarFraccion(objetivo, dificultad),
    );
  }

  Fraccion _fabricarFraccion(RelacionConUnidad objetivo, int dificultad) {
    final candidatosDenominador = <int>[
      2, 3, 3, 4, 4, 5, 5, 6,
      if (dificultad >= 2) ...[7, 8, 8, 9, 10],
      if (dificultad >= 3) ...[11, 12, 12, 15],
    ];
    final denominador =
        candidatosDenominador[_azar.nextInt(candidatosDenominador.length)];

    switch (objetivo) {
      case RelacionConUnidad.igual:
        // n/n para n cualquiera del rango.
        return Fraccion(denominador, denominador);
      case RelacionConUnidad.menor:
        // Numerador en [1, denominador-1].
        final numerador = 1 + _azar.nextInt(denominador - 1);
        return Fraccion(numerador, denominador);
      case RelacionConUnidad.mayor:
        // Numerador en [denominador+1, denominador*2+1] aprox., para
        // que la impropia no sea exagerada.
        final maximo = denominador * 2 + 1;
        final numerador =
            (denominador + 1) + _azar.nextInt(math.max(1, maximo - denominador));
        return Fraccion(numerador, denominador);
    }
  }
}
