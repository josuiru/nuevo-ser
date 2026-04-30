import 'dart:math' as math;

import 'problema_espejo.dart' show Fraccion;

/// Problema FR.11: se presenta una fracción base (p. ej. 3/4) y un
/// denominador objetivo (p. ej. 12). El niño elige el numerador que
/// completa la equivalencia — en este caso, 9.
///
/// A diferencia de [ProblemaEspejo] (cualquier equivalente vale) y
/// [ProblemaSimplificar] (la forma mínima), aquí el ganador es el
/// numerador concreto que satisface `base = ?/denominadorObjetivo`.
class ProblemaAmplificar {
  final Fraccion base;
  final int denominadorObjetivo;
  final List<int> candidatos;
  final int indiceCorrecto;

  const ProblemaAmplificar({
    required this.base,
    required this.denominadorObjetivo,
    required this.candidatos,
    required this.indiceCorrecto,
  });

  int get numeradorCorrecto => candidatos[indiceCorrecto];

  /// Factor aplicado sobre la base: `denominadorObjetivo / base.denominador`.
  int get factor => denominadorObjetivo ~/ base.denominador;
}

/// Genera problemas de amplificación. Elige una forma reducida pequeña
/// (2/3, 3/4, 5/6…) y la multiplica por un factor entero 2..5 para
/// obtener `denominadorObjetivo`. Los distractores combinan errores
/// típicos:
///   - el propio numerador base (olvido de aplicar el factor),
///   - el factor como numerador (confundir numerador con el factor
///     aplicado al denominador),
///   - el correcto ±1 o ±2 (equivocación de cálculo).
class GeneradorAmplificar {
  final math.Random _azar;

  GeneradorAmplificar({int? semilla}) : _azar = math.Random(semilla);

  ProblemaAmplificar generar({int dificultad = 1}) {
    final base = _elegirBase(dificultad);
    final factor = 2 + _azar.nextInt(dificultad >= 3 ? 5 : 3);
    return _construir(base: base, factor: factor);
  }

  /// Construye el problema reusando la fracción base y el denominador
  /// objetivo concretos del Fragmento. Si los datos no encajan
  /// (factor no entero ≥ 2, denominador objetivo ≤ base) cae al
  /// generador aleatorio.
  ProblemaAmplificar generarDesde({
    required int numeradorBase,
    required int denominadorBase,
    required int denominadorObjetivo,
    int dificultad = 1,
  }) {
    if (denominadorBase <= 0 ||
        numeradorBase <= 0 ||
        denominadorObjetivo <= denominadorBase ||
        denominadorObjetivo % denominadorBase != 0) {
      return generar(dificultad: dificultad);
    }
    final factor = denominadorObjetivo ~/ denominadorBase;
    if (factor < 2) return generar(dificultad: dificultad);
    return _construir(
      base: Fraccion(numeradorBase, denominadorBase),
      factor: factor,
    );
  }

  ProblemaAmplificar _construir({
    required Fraccion base,
    required int factor,
  }) {
    final denominadorObjetivo = base.denominador * factor;
    final numeradorCorrecto = base.numerador * factor;

    final distractores = <int>{};

    // Error clásico: dejar el numerador tal cual.
    if (base.numerador != numeradorCorrecto) {
      distractores.add(base.numerador);
    }
    // Error de confusión: usar el factor como numerador.
    if (factor != numeradorCorrecto &&
        factor != base.numerador) {
      distractores.add(factor);
    }
    // Errores de ±1/±2 de cálculo.
    for (final delta in const [1, -1, 2, -2]) {
      if (distractores.length >= 3) break;
      final n = numeradorCorrecto + delta;
      if (n > 0 &&
          n != numeradorCorrecto &&
          n != base.numerador &&
          !distractores.contains(n)) {
        distractores.add(n);
      }
    }
    // Fallback defensivo si, con factores pequeños, no llegaron 3.
    var extra = numeradorCorrecto + 3;
    while (distractores.length < 3) {
      if (extra != numeradorCorrecto &&
          extra > 0 &&
          !distractores.contains(extra)) {
        distractores.add(extra);
      }
      extra++;
    }

    final seleccionados = distractores.take(3).toList();
    final candidatos = <int>[numeradorCorrecto, ...seleccionados];
    candidatos.shuffle(_azar);
    final indiceCorrecto = candidatos.indexOf(numeradorCorrecto);

    return ProblemaAmplificar(
      base: base,
      denominadorObjetivo: denominadorObjetivo,
      candidatos: candidatos,
      indiceCorrecto: indiceCorrecto,
    );
  }

  Fraccion _elegirBase(int dificultad) {
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
}
