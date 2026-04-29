import 'dart:math' as math;

import 'problema_espejo.dart' show Fraccion;

/// Una forma canónica de "lectura" de fracción: el texto en castellano
/// y la fracción correspondiente. Las dos representaciones se
/// mantienen como datos puros — el comparador trabaja sobre etiquetas.
class FormaLecturaFraccion {
  final String texto;
  final Fraccion fraccionCorrecta;
  final List<Fraccion> distractoresFraccion;

  const FormaLecturaFraccion({
    required this.texto,
    required this.fraccionCorrecta,
    required this.distractoresFraccion,
  });
}

/// Problema FR.02: el niño ve una fracción escrita en palabras
/// ("tres quintos") y elige la fracción equivalente entre cuatro
/// candidatos. Mecánica simétrica a DEC.01: texto → número.
class ProblemaLecturaFraccion {
  final String texto;
  final List<Fraccion> candidatos;
  final int indiceCorrecto;

  const ProblemaLecturaFraccion({
    required this.texto,
    required this.candidatos,
    required this.indiceCorrecto,
  });

  Fraccion get fraccionCorrecta => candidatos[indiceCorrecto];

  bool esCorrecta(int indiceElegido) => indiceElegido == indiceCorrecto;
}

/// Genera problemas FR.02 a partir de una lista curada. Los
/// distractores son las trampas idiomáticas reales del niño:
/// invertir numerador y denominador ("tres quintos" leído como 5/3),
/// duplicar cifras (5/5 = 1, no 3/5) y aproximar al cardinal sin mirar
/// el ordinal ("tres" en lugar de "tercios").
class GeneradorLecturaFraccion {
  final math.Random _azar;

  GeneradorLecturaFraccion({int? semilla}) : _azar = math.Random(semilla);

  static const _formas = <FormaLecturaFraccion>[
    FormaLecturaFraccion(
      texto: 'un medio',
      fraccionCorrecta: Fraccion(1, 2),
      distractoresFraccion: [Fraccion(2, 1), Fraccion(1, 3), Fraccion(2, 2)],
    ),
    FormaLecturaFraccion(
      texto: 'un tercio',
      fraccionCorrecta: Fraccion(1, 3),
      distractoresFraccion: [Fraccion(3, 1), Fraccion(1, 2), Fraccion(3, 3)],
    ),
    FormaLecturaFraccion(
      texto: 'dos tercios',
      fraccionCorrecta: Fraccion(2, 3),
      distractoresFraccion: [Fraccion(3, 2), Fraccion(2, 2), Fraccion(3, 3)],
    ),
    FormaLecturaFraccion(
      texto: 'un cuarto',
      fraccionCorrecta: Fraccion(1, 4),
      distractoresFraccion: [Fraccion(4, 1), Fraccion(1, 3), Fraccion(1, 2)],
    ),
    FormaLecturaFraccion(
      texto: 'tres cuartos',
      fraccionCorrecta: Fraccion(3, 4),
      distractoresFraccion: [Fraccion(4, 3), Fraccion(3, 3), Fraccion(4, 4)],
    ),
    FormaLecturaFraccion(
      texto: 'dos quintos',
      fraccionCorrecta: Fraccion(2, 5),
      distractoresFraccion: [Fraccion(5, 2), Fraccion(2, 2), Fraccion(5, 5)],
    ),
    FormaLecturaFraccion(
      texto: 'tres quintos',
      fraccionCorrecta: Fraccion(3, 5),
      distractoresFraccion: [Fraccion(5, 3), Fraccion(3, 3), Fraccion(5, 5)],
    ),
    FormaLecturaFraccion(
      texto: 'un sexto',
      fraccionCorrecta: Fraccion(1, 6),
      distractoresFraccion: [Fraccion(6, 1), Fraccion(1, 5), Fraccion(1, 4)],
    ),
    FormaLecturaFraccion(
      texto: 'cinco sextos',
      fraccionCorrecta: Fraccion(5, 6),
      distractoresFraccion: [Fraccion(6, 5), Fraccion(5, 5), Fraccion(6, 6)],
    ),
    FormaLecturaFraccion(
      texto: 'dos séptimos',
      fraccionCorrecta: Fraccion(2, 7),
      distractoresFraccion: [Fraccion(7, 2), Fraccion(2, 2), Fraccion(7, 7)],
    ),
    FormaLecturaFraccion(
      texto: 'tres octavos',
      fraccionCorrecta: Fraccion(3, 8),
      distractoresFraccion: [Fraccion(8, 3), Fraccion(3, 3), Fraccion(8, 8)],
    ),
    FormaLecturaFraccion(
      texto: 'cinco octavos',
      fraccionCorrecta: Fraccion(5, 8),
      distractoresFraccion: [Fraccion(8, 5), Fraccion(5, 5), Fraccion(8, 8)],
    ),
    FormaLecturaFraccion(
      texto: 'cuatro novenos',
      fraccionCorrecta: Fraccion(4, 9),
      distractoresFraccion: [Fraccion(9, 4), Fraccion(4, 4), Fraccion(9, 9)],
    ),
    FormaLecturaFraccion(
      texto: 'siete décimos',
      fraccionCorrecta: Fraccion(7, 10),
      distractoresFraccion: [Fraccion(10, 7), Fraccion(7, 7), Fraccion(1, 7)],
    ),
    FormaLecturaFraccion(
      texto: 'tres décimos',
      fraccionCorrecta: Fraccion(3, 10),
      distractoresFraccion: [Fraccion(10, 3), Fraccion(3, 3), Fraccion(1, 3)],
    ),
  ];

  /// Reproduce un problema concreto cuando el niño abre el Fragmento
  /// que ya vio en el tejado. Si el texto no se encuentra, cae a uno
  /// nuevo aleatorio para no dejar al niño en blanco.
  ProblemaLecturaFraccion generarDesdeTexto(String texto) {
    final encontrada = _formas.firstWhere(
      (f) => f.texto == texto,
      orElse: () => _formas[_azar.nextInt(_formas.length)],
    );
    return _construirDesde(encontrada);
  }

  ProblemaLecturaFraccion generar({int dificultad = 1}) {
    Iterable<FormaLecturaFraccion> reservaPosibles() {
      // En dificultad baja dejamos solo denominadores ≤ 6 — los nombres
      // ordinales más familiares. Sextos y séptimos entran en el
      // siguiente tier; octavos/novenos/décimos al final.
      if (dificultad >= 3) return _formas;
      if (dificultad >= 2) {
        return _formas.where((f) {
          final den = f.fraccionCorrecta.denominador;
          return den <= 8;
        });
      }
      return _formas.where((f) {
        final den = f.fraccionCorrecta.denominador;
        return den <= 5;
      });
    }

    final candidatasPosibles = reservaPosibles().toList();
    final eleccion =
        candidatasPosibles[_azar.nextInt(candidatasPosibles.length)];
    return _construirDesde(eleccion);
  }

  ProblemaLecturaFraccion _construirDesde(FormaLecturaFraccion forma) {
    final candidatos = <Fraccion>[
      forma.fraccionCorrecta,
      ...forma.distractoresFraccion,
    ];
    candidatos.shuffle(_azar);
    final indice = candidatos.indexWhere(
      (c) =>
          c.numerador == forma.fraccionCorrecta.numerador &&
          c.denominador == forma.fraccionCorrecta.denominador,
    );
    return ProblemaLecturaFraccion(
      texto: forma.texto,
      candidatos: candidatos,
      indiceCorrecto: indice,
    );
  }
}
