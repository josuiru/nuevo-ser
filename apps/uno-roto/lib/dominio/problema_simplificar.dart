import 'dart:math' as math;

import 'problema_espejo.dart' show Fraccion;

/// Un problema de simplificación: el niño ve una fracción reducible
/// (p.ej. 6/8) y tiene que elegir su forma más simple entre cuatro
/// candidatos. Distinto de [ProblemaEspejo] — aquí el ganador es
/// **único y mínimo**, no cualquier equivalente.
class ProblemaSimplificar {
  final Fraccion objetivo;
  final List<Fraccion> candidatos;
  final int indiceCorrecto;

  const ProblemaSimplificar({
    required this.objetivo,
    required this.candidatos,
    required this.indiceCorrecto,
  });

  Fraccion get correcto => candidatos[indiceCorrecto];
}

/// Genera problemas de simplificación. Produce una fracción reducible
/// eligiendo primero una forma reducida (3/4, 2/5, 1/6, …) y luego la
/// amplifica con un factor entero para obtener el objetivo (6/8, 4/10,
/// 2/12, …). El candidato correcto es esa forma reducida. Los
/// distractores mezclan:
///   - el propio objetivo sin simplificar (común error),
///   - otros equivalentes también reducibles (12/16, 8/12…),
///   - fracciones con números cercanos no equivalentes.
class GeneradorSimplificar {
  final math.Random _azar;

  GeneradorSimplificar({int? semilla}) : _azar = math.Random(semilla);

  /// [dificultad] modula el tamaño de numerador/denominador de la
  /// forma reducida y el factor de amplificación.
  ProblemaSimplificar generar({int dificultad = 1}) {
    final reducida = _elegirFraccionReducidaBase(dificultad);
    final factor = 2 + _azar.nextInt(dificultad >= 3 ? 5 : 3);
    final objetivo = Fraccion(
      reducida.numerador * factor,
      reducida.denominador * factor,
    );
    return _construir(reducida: reducida, objetivo: objetivo);
  }

  /// Genera un problema reusando una fracción concreta (p. ej. la que
  /// trae el Fragmento del cazadero). Si la fracción no es reducible
  /// con un factor entero ≥ 2, cae al pool aleatorio para no romper
  /// la mecánica del puzzle (que exige una forma reducida única).
  ProblemaSimplificar generarDesde({
    required int numerador,
    required int denominador,
    int dificultad = 1,
  }) {
    final mcd = _mcd(numerador.abs(), denominador.abs());
    if (mcd <= 1 || denominador <= 0 || numerador <= 0) {
      return generar(dificultad: dificultad);
    }
    final reducida = Fraccion(numerador ~/ mcd, denominador ~/ mcd);
    final objetivo = Fraccion(numerador, denominador);
    return _construir(reducida: reducida, objetivo: objetivo);
  }

  int _mcd(int a, int b) {
    while (b != 0) {
      final t = b;
      b = a % b;
      a = t;
    }
    return a == 0 ? 1 : a;
  }

  ProblemaSimplificar _construir({
    required Fraccion reducida,
    required Fraccion objetivo,
  }) {
    final correcto = reducida;
    final factor = objetivo.denominador ~/ reducida.denominador;

    final distractores = <Fraccion>[];

    // El propio objetivo sin simplificar — el error típico.
    distractores.add(objetivo);

    // Otra amplificación distinta de la reducida (también reducible).
    final otroFactor = factor == 2 ? 3 : 2;
    final otroEquivalente = Fraccion(
      reducida.numerador * otroFactor,
      reducida.denominador * otroFactor,
    );
    // Evitamos duplicado si por casualidad coincide con objetivo.
    if (otroEquivalente.numerador != objetivo.numerador ||
        otroEquivalente.denominador != objetivo.denominador) {
      distractores.add(otroEquivalente);
    }

    // Un distractor cercano NO equivalente: movemos el numerador ±1.
    var intentos = 0;
    while (distractores.length < 3 && intentos < 40) {
      intentos++;
      final delta = _azar.nextBool() ? 1 : -1;
      final nuevoNum =
          math.max(1, reducida.numerador + delta);
      final candidato = Fraccion(nuevoNum, reducida.denominador);
      if (candidato.esEquivalenteA(objetivo)) continue;
      if (_yaEsta(candidato, distractores) ||
          _mismaFraccion(candidato, correcto)) {
        continue;
      }
      distractores.add(candidato);
    }

    // Fallback ultra defensivo — varía k para garantizar unicidad y
    // que ningún distractor coincida con el correcto, el objetivo o
    // entre sí. Sin esto, dos llamadas seguidas añadirían el mismo
    // valor y el niño podría tocar un duplicado del correcto y verlo
    // marcado como error.
    var k = 1;
    while (distractores.length < 3 && k < 200) {
      final candidato = Fraccion(
        correcto.numerador + k,
        correcto.denominador + k,
      );
      k++;
      if (candidato.esEquivalenteA(correcto)) continue;
      if (candidato.esEquivalenteA(objetivo)) continue;
      if (_yaEsta(candidato, distractores) ||
          _mismaFraccion(candidato, correcto)) {
        continue;
      }
      distractores.add(candidato);
    }

    final candidatos = <Fraccion>[correcto, ...distractores];
    candidatos.shuffle(_azar);
    final indiceCorrecto = candidatos.indexWhere(
      (c) =>
          c.numerador == correcto.numerador &&
          c.denominador == correcto.denominador,
    );

    return ProblemaSimplificar(
      objetivo: objetivo,
      candidatos: candidatos,
      indiceCorrecto: indiceCorrecto,
    );
  }

  Fraccion _elegirFraccionReducidaBase(int dificultad) {
    // Lista de formas reducidas "canónicas" para primaria. Mezclamos
    // fracciones con denominador pequeño (2, 3, 4, 5) con algunas de
    // denominador mayor cuando la dificultad sube.
    final facilBase = <Fraccion>[
      const Fraccion(1, 2),
      const Fraccion(1, 3),
      const Fraccion(2, 3),
      const Fraccion(1, 4),
      const Fraccion(3, 4),
      const Fraccion(1, 5),
      const Fraccion(2, 5),
      const Fraccion(3, 5),
      const Fraccion(4, 5),
      const Fraccion(1, 6),
      const Fraccion(5, 6),
    ];
    if (dificultad < 3) {
      return facilBase[_azar.nextInt(facilBase.length)];
    }
    final dificilExtra = <Fraccion>[
      const Fraccion(2, 7),
      const Fraccion(3, 7),
      const Fraccion(3, 8),
      const Fraccion(5, 8),
      const Fraccion(7, 8),
      const Fraccion(2, 9),
      const Fraccion(4, 9),
      const Fraccion(7, 10),
    ];
    final total = [...facilBase, ...dificilExtra];
    return total[_azar.nextInt(total.length)];
  }

  bool _mismaFraccion(Fraccion a, Fraccion b) =>
      a.numerador == b.numerador && a.denominador == b.denominador;

  bool _yaEsta(Fraccion candidato, List<Fraccion> lista) =>
      lista.any((f) => _mismaFraccion(f, candidato));
}
