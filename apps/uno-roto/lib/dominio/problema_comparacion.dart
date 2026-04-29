import 'dart:math' as math;

import 'fragmento_en_tejado.dart' show ModoComparacion;
import 'problema_espejo.dart' show Fraccion;

/// Un problema de comparación: dos fracciones, el niño toca la mayor.
/// El modo determina qué se comparte (denominador o numerador) y, por
/// tanto, qué pista pedagógica muestra la pantalla.
class ProblemaComparacion {
  final Fraccion a;
  final Fraccion b;
  final ModoComparacion modo;

  const ProblemaComparacion({
    required this.a,
    required this.b,
    required this.modo,
  });

  /// Índice de la mayor: 0 si es [a], 1 si es [b].
  /// Si son equivalentes en valor, devuelve null — el generador evita
  /// ese caso, pero lo dejamos explícito para tests.
  int? get indiceMayor {
    if (a.valor > b.valor) return 0;
    if (b.valor > a.valor) return 1;
    return null;
  }

  bool esCorrecto(int indiceElegido) => indiceElegido == indiceMayor;
}

/// Genera problemas de comparación con el modo pedido. Para
/// [ModoComparacion.mismoDenominador] elige un denominador común y dos
/// numeradores distintos dentro del rango. Para
/// [ModoComparacion.mismoNumerador] elige un numerador compartido y
/// dos denominadores distintos, ambos mayores que el numerador para que
/// las dos fracciones sean propias.
class GeneradorComparacion {
  final math.Random _azar;

  GeneradorComparacion({int? semilla}) : _azar = math.Random(semilla);

  ProblemaComparacion generar({
    required ModoComparacion modo,
    int dificultad = 1,
  }) {
    switch (modo) {
      case ModoComparacion.mismoDenominador:
        return _mismoDenominador(dificultad);
      case ModoComparacion.mismoNumerador:
        return _mismoNumerador(dificultad);
    }
  }

  ProblemaComparacion _mismoDenominador(int dificultad) {
    final denominadoresPorNivel = <int>[
      3, 4, 4, 5, 5, 6, 6, 8,
      if (dificultad >= 2) ...[7, 9, 10],
      if (dificultad >= 3) ...[10, 12],
    ];
    final denominador =
        denominadoresPorNivel[_azar.nextInt(denominadoresPorNivel.length)];
    // Dos numeradores distintos en [1, denominador-1]: garantiza
    // fracciones propias y evita la unidad (que sería 1 entero).
    final maximo = denominador - 1;
    final a = 1 + _azar.nextInt(maximo);
    int b;
    do {
      b = 1 + _azar.nextInt(maximo);
    } while (b == a);
    return ProblemaComparacion(
      a: Fraccion(a, denominador),
      b: Fraccion(b, denominador),
      modo: ModoComparacion.mismoDenominador,
    );
  }

  ProblemaComparacion _mismoNumerador(int dificultad) {
    // Numerador compartido pequeño (2..4) para que los denominadores
    // puedan ser claramente distintos y las dos fracciones sigan siendo
    // propias (denominador > numerador).
    final numerador = 2 + _azar.nextInt(3);
    // Denominadores: cada uno > numerador, distintos entre sí.
    final minimoDen = numerador + 1;
    final maximoDen = dificultad >= 3
        ? numerador + 10
        : dificultad >= 2
            ? numerador + 7
            : numerador + 5;
    final denA = minimoDen + _azar.nextInt(maximoDen - minimoDen + 1);
    int denB;
    do {
      denB = minimoDen + _azar.nextInt(maximoDen - minimoDen + 1);
    } while (denB == denA);
    return ProblemaComparacion(
      a: Fraccion(numerador, denA),
      b: Fraccion(numerador, denB),
      modo: ModoComparacion.mismoNumerador,
    );
  }
}
