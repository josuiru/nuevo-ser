import 'dart:math' as math;

import 'problema_espejo.dart' show Fraccion;

/// Problema FR.07: el niño ve dos fracciones con denominadores Y
/// numeradores distintos (no comparten ningún término) y toca la
/// mayor. Es el siguiente escalón sobre FR.05 (mismo denominador) y
/// FR.06 (mismo numerador) — aquí no hay atajo, hay que comparar el
/// valor de verdad (multiplicar cruzado o intuir por valor).
class ProblemaComparacionDistinta {
  final Fraccion a;
  final Fraccion b;

  const ProblemaComparacionDistinta({required this.a, required this.b});

  /// Devuelve la fracción de mayor valor entre [a] y [b]. Si fueran
  /// equivalentes (no debería ocurrir por diseño), devuelve [a].
  Fraccion get fraccionMayor {
    final ladoA = a.numerador * b.denominador;
    final ladoB = b.numerador * a.denominador;
    return ladoA >= ladoB ? a : b;
  }

  /// Índice de la mayor: 0 si es [a], 1 si es [b].
  int get indiceMayor => identical(fraccionMayor, a) ? 0 : 1;

  bool esCorrecta(int indiceElegido) => indiceElegido == indiceMayor;
}

/// Genera problemas FR.07 con sesgo a casos contraintuitivos. El niño
/// asume "más numerador gana" o "menos denominador gana"; cuando ambas
/// fracciones tienen num y den distintos, esa intuición falla. El
/// generador escoge ≥ 60 % casos donde la respuesta intuitiva no vale
/// (la "candidata fácil" según `aMasCifras` es la pequeña), y un 40 %
/// donde la intuición acierta para no machacar al niño.
class GeneradorComparacionDistinta {
  final math.Random _azar;

  GeneradorComparacionDistinta({int? semilla})
      : _azar = math.Random(semilla);

  ProblemaComparacionDistinta generar({int dificultad = 1}) {
    final maximoDenominador = switch (dificultad) {
      1 => 6,
      2 => 10,
      _ => 12,
    };

    // Bandera: ¿queremos un caso contraintuitivo en esta tirada?
    final buscaContraintuitivo = _azar.nextDouble() < 0.6;

    for (var intento = 0; intento < 200; intento++) {
      final denA = 2 + _azar.nextInt(maximoDenominador - 1);
      final denB = 2 + _azar.nextInt(maximoDenominador - 1);
      if (denA == denB) continue; // sería FR.05
      final numA = 1 + _azar.nextInt(denA - 1);
      final numB = 1 + _azar.nextInt(denB - 1);
      if (numA == numB) continue; // sería FR.06
      final a = Fraccion(numA, denA);
      final b = Fraccion(numB, denB);
      if (a.numerador * b.denominador == b.numerador * a.denominador) {
        // Equivalentes: el puzzle no admite empate.
        continue;
      }
      // Caso contraintuitivo: una fracción tiene num menor Y den menor
      // que la otra, pero su valor es mayor.
      final ambasMenores = (numA < numB && denA < denB) ||
          (numB < numA && denB < denA);
      final mayorValor =
          a.numerador * b.denominador > b.numerador * a.denominador ? a : b;
      // Es contraintuitivo cuando la mayor por valor es la que tiene
      // ambos términos menores que la otra.
      final esContraintuitivo = ambasMenores &&
          ((mayorValor == a && numA < numB) ||
              (mayorValor == b && numB < numA));

      if (buscaContraintuitivo && !esContraintuitivo) continue;
      if (!buscaContraintuitivo && esContraintuitivo) continue;

      return ProblemaComparacionDistinta(a: a, b: b);
    }

    // Fallback: cualquier par válido si tras 200 intentos no encajó
    // exactamente la categoría buscada.
    return _fallbackCualquierPar(maximoDenominador);
  }

  ProblemaComparacionDistinta _fallbackCualquierPar(int maximoDenominador) {
    while (true) {
      final denA = 2 + _azar.nextInt(maximoDenominador - 1);
      final denB = 2 + _azar.nextInt(maximoDenominador - 1);
      if (denA == denB) continue;
      final numA = 1 + _azar.nextInt(denA - 1);
      final numB = 1 + _azar.nextInt(denB - 1);
      if (numA == numB) continue;
      final a = Fraccion(numA, denA);
      final b = Fraccion(numB, denB);
      if (a.numerador * b.denominador == b.numerador * a.denominador) {
        continue;
      }
      return ProblemaComparacionDistinta(a: a, b: b);
    }
  }
}
