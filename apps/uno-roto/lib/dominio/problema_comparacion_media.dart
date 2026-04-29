import 'dart:math' as math;

import 'problema_espejo.dart' show Fraccion;

/// Tres categorías mutuamente excluyentes respecto a 1/2.
enum RelacionConMedia { menor, igual, mayor }

/// Problema FR.03: el niño ve una fracción y la clasifica respecto a
/// la mitad. La heurística canónica es "el doble del numerador frente
/// al denominador": si 2·n < d → menor, 2·n = d → igual, 2·n > d →
/// mayor. La habilidad pretende que el niño la interiorice.
class ProblemaComparacionMedia {
  final Fraccion fraccion;

  const ProblemaComparacionMedia({required this.fraccion});

  RelacionConMedia get relacionCorrecta {
    final dosN = 2 * fraccion.numerador;
    if (dosN < fraccion.denominador) return RelacionConMedia.menor;
    if (dosN > fraccion.denominador) return RelacionConMedia.mayor;
    return RelacionConMedia.igual;
  }

  bool esCorrecta(RelacionConMedia respuesta) =>
      respuesta == relacionCorrecta;
}

/// Genera fracciones con sesgo a casos contraintuitivos: pares donde
/// la primera mirada engaña (5/9, 7/13, 4/9 ≈ 1/2 pero por encima o
/// debajo). Reparto aproximado: 40% mayor, 40% menor, 20% igual — el
/// caso de equivalencia (3/6, 4/8, etc.) se incluye explícitamente
/// porque suele pasarse por alto.
class GeneradorComparacionMedia {
  final math.Random _azar;

  GeneradorComparacionMedia({int? semilla}) : _azar = math.Random(semilla);

  ProblemaComparacionMedia generar({int dificultad = 1}) {
    final tirada = _azar.nextDouble();
    final RelacionConMedia objetivo;
    if (tirada < 0.20) {
      objetivo = RelacionConMedia.igual;
    } else if (tirada < 0.60) {
      objetivo = RelacionConMedia.menor;
    } else {
      objetivo = RelacionConMedia.mayor;
    }
    return ProblemaComparacionMedia(
      fraccion: _fabricarFraccion(objetivo, dificultad),
    );
  }

  /// Reconstruye un problema con una fracción dada (para reproducir el
  /// problema desde un Fragmento ya emitido).
  ProblemaComparacionMedia generarDesdeFraccion(Fraccion fraccion) =>
      ProblemaComparacionMedia(fraccion: fraccion);

  Fraccion _fabricarFraccion(RelacionConMedia objetivo, int dificultad) {
    // Para los casos "menor" y "mayor" usamos denominadores impares con
    // sesgo, porque el caso contraintuitivo es justo el de denominador
    // impar donde el niño no puede partir entre 2 directamente. Para
    // "igual" usamos pares para que la fracción sea n/2n.
    switch (objetivo) {
      case RelacionConMedia.igual:
        // 1/2, 2/4, 3/6, 4/8, 5/10, 6/12 — el niño suele detectar 1/2
        // pero falla con las equivalentes.
        final candidatosDen = <int>[
          2, 4, 6, 8,
          if (dificultad >= 2) 10,
          if (dificultad >= 2) 12,
        ];
        final den =
            candidatosDen[_azar.nextInt(candidatosDen.length)];
        return Fraccion(den ~/ 2, den);

      case RelacionConMedia.menor:
        // Casos clásicos: 2/5, 3/7, 4/9, 5/11, 1/3, 2/7… 2·n < d.
        final pares = <(int, int)>[
          (1, 3), (1, 4), (2, 5), (2, 7), (3, 7), (3, 8),
          (4, 9), (3, 10), (4, 11), (5, 11),
          if (dificultad >= 2) ...[(5, 12), (6, 13), (4, 13)],
        ];
        final p = pares[_azar.nextInt(pares.length)];
        return Fraccion(p.$1, p.$2);

      case RelacionConMedia.mayor:
        // Casos clásicos: 3/5, 4/7, 5/9, 6/11, 5/8, 2/3… 2·n > d.
        final pares = <(int, int)>[
          (2, 3), (3, 5), (3, 4), (4, 7), (5, 7), (5, 9),
          (5, 8), (6, 11), (7, 11), (7, 12),
          if (dificultad >= 2) ...[(7, 13), (8, 13), (9, 13)],
        ];
        final p = pares[_azar.nextInt(pares.length)];
        return Fraccion(p.$1, p.$2);
    }
  }
}
