import 'dart:math' as math;

/// Representa una fracción concreta a/b usada en problemas de
/// equivalencia. No confundir con [FragmentoUnitario], que vive en el
/// motor de combate.
class Fraccion {
  final int numerador;
  final int denominador;

  /// El `assert` se elimina en release. Se mantiene `const` para que
  /// las decenas de Fracciones constantes (curated pools) sigan
  /// siendo compile-time. La validación runtime se aplica en
  /// [Fraccion.dinamica] — usar este factory cuando los valores se
  /// derivan de aritmética no garantizada (restas, simplificaciones,
  /// caminos de "trampa clásica").
  const Fraccion(this.numerador, this.denominador)
      : assert(denominador > 0);

  /// Factory con validación runtime (también activa en release).
  /// Usar siempre que numerador/denominador procedan de cálculos
  /// dinámicos: restas, simplificaciones o ramas defensivas
  /// (`_trampaClasica` en [ProblemaDual], etc.).
  factory Fraccion.dinamica(int numerador, int denominador) {
    if (denominador <= 0) {
      throw ArgumentError.value(
        denominador,
        'denominador',
        'Fracción exige denominador > 0 (recibido: $denominador).',
      );
    }
    return Fraccion(numerador, denominador);
  }

  String get etiqueta =>
      denominador == 1 ? '$numerador' : '$numerador/$denominador';

  double get valor => numerador / denominador;

  /// Dos fracciones son equivalentes cuando numerador*d == c*denominador.
  bool esEquivalenteA(Fraccion otra) =>
      numerador * otra.denominador == otra.numerador * denominador;

  Fraccion reducida() {
    final divisor = _mcd(numerador.abs(), denominador.abs());
    if (divisor == 0) return this;
    return Fraccion(numerador ~/ divisor, denominador ~/ divisor);
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

/// Un problema de equivalencia listo para presentar en la UI: una
/// fracción objetivo y cuatro candidatos, de los cuales exactamente
/// uno es equivalente.
class ProblemaEspejo {
  final Fraccion objetivo;
  final List<Fraccion> candidatos;
  final int indiceCorrecto;

  const ProblemaEspejo({
    required this.objetivo,
    required this.candidatos,
    required this.indiceCorrecto,
  });

  Fraccion get correcto => candidatos[indiceCorrecto];
}

/// Genera un problema de equivalencia a partir de una fracción base.
/// Distractores: fracciones con valor distinto al objetivo pero con
/// números cercanos para que no sea trivial por tamaño.
class GeneradorEspejo {
  final math.Random _azar;

  GeneradorEspejo({int? semilla}) : _azar = math.Random(semilla);

  ProblemaEspejo generar({
    required int numeradorBase,
    required int denominadorBase,
  }) {
    final objetivo = Fraccion(numeradorBase, denominadorBase);
    final reducida = objetivo.reducida();

    // Candidato correcto: una equivalencia distinta a la forma dada.
    final correcto = _generarEquivalenteDistinto(reducida, objetivo);

    // Tres distractores: fracciones NO equivalentes con numeradores
    // y denominadores cercanos para que no se resuelva a ojo.
    final distractores = <Fraccion>[];
    var intentos = 0;
    while (distractores.length < 3 && intentos < 60) {
      intentos++;
      final candidato = _generarDistractor(objetivo);
      if (candidato.esEquivalenteA(objetivo)) continue;
      if (distractores.any((d) =>
          d.numerador == candidato.numerador &&
          d.denominador == candidato.denominador)) {
        continue;
      }
      if (candidato.numerador == correcto.numerador &&
          candidato.denominador == correcto.denominador) {
        continue;
      }
      distractores.add(candidato);
    }
    while (distractores.length < 3) {
      // Fallback ultra defensivo: añade fracciones simples que seguro
      // no son equivalentes.
      distractores
          .add(Fraccion(objetivo.numerador + 1, objetivo.denominador));
    }

    final candidatos = <Fraccion>[correcto, ...distractores];
    candidatos.shuffle(_azar);
    final indiceCorrecto = candidatos.indexWhere(
      (c) => c.numerador == correcto.numerador &&
          c.denominador == correcto.denominador,
    );

    return ProblemaEspejo(
      objetivo: objetivo,
      candidatos: candidatos,
      indiceCorrecto: indiceCorrecto,
    );
  }

  Fraccion _generarEquivalenteDistinto(Fraccion reducida, Fraccion evitar) {
    // Multiplicamos numerador y denominador por un factor entero
    // que no produzca la misma fracción dada.
    for (var factor = 2; factor <= 6; factor++) {
      final candidato =
          Fraccion(reducida.numerador * factor, reducida.denominador * factor);
      if (candidato.numerador != evitar.numerador ||
          candidato.denominador != evitar.denominador) {
        return candidato;
      }
    }
    return Fraccion(reducida.numerador * 7, reducida.denominador * 7);
  }

  Fraccion _generarDistractor(Fraccion objetivo) {
    // Varias estrategias posibles para que los distractores no sean
    // predecibles: cambiar solo el numerador, solo el denominador,
    // o ambos, manteniendo los números en un rango comparable.
    final estrategia = _azar.nextInt(3);
    switch (estrategia) {
      case 0:
        final nuevoNumerador = math.max(
          1,
          objetivo.numerador + _azar.nextInt(5) - 2,
        );
        return Fraccion(nuevoNumerador, objetivo.denominador);
      case 1:
        final nuevoDenominador = math.max(
          objetivo.numerador + 1,
          objetivo.denominador + _azar.nextInt(5) - 2,
        );
        return Fraccion(objetivo.numerador, nuevoDenominador);
      case 2:
      default:
        final n = math.max(1, _azar.nextInt(8) + 1);
        final d = math.max(n + 1, _azar.nextInt(10) + 2);
        return Fraccion(n, d);
    }
  }
}
