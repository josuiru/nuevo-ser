import 'dart:math' as math;

import 'problema_espejo.dart' show Fraccion;

/// Una de las dos opciones de un problema de comparación mixta. Lleva
/// el formato canónico (`fraccion` o `decimal`) y el valor numérico
/// que se usa para decidir cuál es la mayor.
class OpcionComparacionMixta {
  final String etiqueta;
  final double valor;
  final bool esFraccion;

  const OpcionComparacionMixta({
    required this.etiqueta,
    required this.valor,
    required this.esFraccion,
  });

  factory OpcionComparacionMixta.deFraccion(Fraccion f) =>
      OpcionComparacionMixta(
        etiqueta: f.etiqueta,
        valor: f.valor,
        esFraccion: true,
      );

  factory OpcionComparacionMixta.deDecimal(String etiqueta) =>
      OpcionComparacionMixta(
        etiqueta: etiqueta,
        valor: double.parse(etiqueta.replaceAll(',', '.')),
        esFraccion: false,
      );
}

/// Problema DEC.03: el niño ve un decimal (0,5) y una fracción (3/4)
/// lado a lado y toca la mayor. Mecánica nueva: comparar formatos
/// cruzados — el niño no puede atajar mirando solo cifras o solo
/// términos, tiene que pensar el valor.
class ProblemaComparacionMixta {
  final OpcionComparacionMixta a;
  final OpcionComparacionMixta b;

  const ProblemaComparacionMixta({required this.a, required this.b});

  /// Índice (0 o 1) de la opción de mayor valor. Devuelve 0 si son
  /// iguales en valor (no debería ocurrir por diseño).
  int get indiceMayor => a.valor >= b.valor ? 0 : 1;

  bool esCorrecta(int indiceElegido) => indiceElegido == indiceMayor;
}

/// Pares curados: cada par tiene una fracción y un decimal con
/// **diferencia clara** (≥ 0,05) y **etiquetas amigables**. La mitad
/// son casos donde la fracción gana, la otra mitad el decimal —
/// para que el niño no aprenda un atajo "siempre gana X formato".
const _paresCurados = <(Fraccion, String)>[
  // (fracción, etiqueta del decimal)
  (Fraccion(1, 2), '0,3'),  // 0,5 > 0,3 → fracción gana
  (Fraccion(1, 4), '0,5'),  // 0,5 > 0,25 → decimal gana
  (Fraccion(3, 4), '0,5'),  // 0,75 > 0,5 → fracción gana
  (Fraccion(1, 5), '0,3'),  // 0,3 > 0,2 → decimal gana
  (Fraccion(2, 5), '0,5'),  // 0,5 > 0,4 → decimal gana
  (Fraccion(3, 5), '0,5'),  // 0,6 > 0,5 → fracción gana
  (Fraccion(1, 4), '0,3'),  // 0,3 > 0,25 → decimal gana
  (Fraccion(3, 4), '0,8'),  // 0,8 > 0,75 → decimal gana
  (Fraccion(7, 10), '0,5'), // 0,7 > 0,5 → fracción gana
  (Fraccion(3, 10), '0,5'), // 0,5 > 0,3 → decimal gana
  (Fraccion(1, 3), '0,5'),  // 0,5 > 0,33 → decimal gana
  (Fraccion(2, 3), '0,5'),  // 0,66 > 0,5 → fracción gana
  (Fraccion(1, 8), '0,2'),  // 0,2 > 0,125 → decimal gana
  (Fraccion(5, 8), '0,5'),  // 0,625 > 0,5 → fracción gana
];

/// Genera problemas DEC.03 con sesgo a casos donde el niño se confunde:
/// la fracción "se ve grande" pero su valor es menor que el decimal, o
/// al revés. El generador alterna qué formato gana para no enseñar un
/// atajo formal.
class GeneradorComparacionMixta {
  final math.Random _azar;

  GeneradorComparacionMixta({int? semilla}) : _azar = math.Random(semilla);

  ProblemaComparacionMixta generar({int dificultad = 1}) {
    final pool = dificultad >= 2
        ? _paresCurados
        : _paresCurados
            .where((p) => p.$1.denominador <= 5)
            .toList();
    final (fraccion, etiquetaDecimal) =
        pool[_azar.nextInt(pool.length)];
    final opcionFraccion = OpcionComparacionMixta.deFraccion(fraccion);
    final opcionDecimal = OpcionComparacionMixta.deDecimal(etiquetaDecimal);
    // Alternamos el lado: a veces la fracción está a la izquierda,
    // a veces el decimal — para no fijar la posición.
    final fraccionALaIzquierda = _azar.nextBool();
    return ProblemaComparacionMixta(
      a: fraccionALaIzquierda ? opcionFraccion : opcionDecimal,
      b: fraccionALaIzquierda ? opcionDecimal : opcionFraccion,
    );
  }

  /// Reproduce un problema concreto a partir de los términos guardados
  /// en el Fragmento (fracción + etiqueta decimal). Mantiene el orden
  /// definido por la flag para reproducir la posición original.
  ProblemaComparacionMixta generarDesdeTerminos({
    required Fraccion fraccion,
    required String etiquetaDecimal,
    required bool fraccionALaIzquierda,
  }) {
    final opcionFraccion = OpcionComparacionMixta.deFraccion(fraccion);
    final opcionDecimal = OpcionComparacionMixta.deDecimal(etiquetaDecimal);
    return ProblemaComparacionMixta(
      a: fraccionALaIzquierda ? opcionFraccion : opcionDecimal,
      b: fraccionALaIzquierda ? opcionDecimal : opcionFraccion,
    );
  }
}
