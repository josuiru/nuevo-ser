import 'dart:math' as math;

/// Representa un número mixto a y b/c, como "1 y 3/4".
class NumeroMixto {
  final int entera;
  final int numerador;
  final int denominador;

  const NumeroMixto({
    required this.entera,
    required this.numerador,
    required this.denominador,
  }) : assert(denominador > 0);

  String get etiqueta {
    if (numerador == 0) return '$entera';
    if (entera == 0) return '$numerador/$denominador';
    return '$entera y $numerador/$denominador';
  }

  /// Valor numérico para comparaciones.
  double get valor => entera + numerador / denominador;

  bool esIgualA(NumeroMixto otro) =>
      entera == otro.entera &&
      numerador == otro.numerador &&
      denominador == otro.denominador;
}

class ProblemaImpropio {
  final String etiquetaImpropia;
  final List<NumeroMixto> candidatos;
  final int indiceCorrecto;

  const ProblemaImpropio({
    required this.etiquetaImpropia,
    required this.candidatos,
    required this.indiceCorrecto,
  });
}

class GeneradorImpropio {
  final math.Random _azar;

  GeneradorImpropio({int? semilla}) : _azar = math.Random(semilla);

  ProblemaImpropio generarDesde({
    required int numerador,
    required int denominador,
  }) {
    assert(numerador > denominador);

    final enteraCorrecta = numerador ~/ denominador;
    final numeradorRestante = numerador % denominador;
    final correcto = NumeroMixto(
      entera: enteraCorrecta,
      numerador: numeradorRestante,
      denominador: denominador,
    );

    final distractores = <NumeroMixto>{};
    var intentos = 0;
    while (distractores.length < 3 && intentos < 60) {
      intentos++;
      final candidato = _generarDistractor(
        correcto: correcto,
        denominador: denominador,
      );
      if (candidato.esIgualA(correcto)) continue;
      if (distractores.any((d) => d.esIgualA(candidato))) continue;
      distractores.add(candidato);
    }
    // Fallback ultra defensivo — varía k y verifica que no colisione
    // con el correcto ni con distractores ya añadidos. Sin esto, dos
    // pasadas del bucle podrían añadir el mismo NumeroMixto.
    var k = 1;
    while (distractores.length < 3 && k < 50) {
      final candidato = NumeroMixto(
        entera: enteraCorrecta + k,
        numerador: numeradorRestante,
        denominador: denominador,
      );
      k++;
      if (candidato.esIgualA(correcto)) continue;
      if (distractores.any((d) => d.esIgualA(candidato))) continue;
      distractores.add(candidato);
    }

    final candidatos = <NumeroMixto>[correcto, ...distractores];
    candidatos.shuffle(_azar);
    final indiceCorrecto =
        candidatos.indexWhere((c) => c.esIgualA(correcto));

    return ProblemaImpropio(
      etiquetaImpropia: '$numerador/$denominador',
      candidatos: candidatos,
      indiceCorrecto: indiceCorrecto,
    );
  }

  NumeroMixto _generarDistractor({
    required NumeroMixto correcto,
    required int denominador,
  }) {
    final estrategia = _azar.nextInt(4);
    switch (estrategia) {
      case 0:
        // Entera +/- 1.
        final delta = _azar.nextBool() ? 1 : -1;
        final entera = math.max(0, correcto.entera + delta);
        return NumeroMixto(
          entera: entera,
          numerador: correcto.numerador,
          denominador: denominador,
        );
      case 1:
        // Numerador distinto (dentro de rango válido).
        final nuevoNum =
            (correcto.numerador + 1 + _azar.nextInt(denominador - 1)) %
                denominador;
        return NumeroMixto(
          entera: correcto.entera,
          numerador: nuevoNum,
          denominador: denominador,
        );
      case 2:
        // Denominador cercano.
        final nuevoDen =
            math.max(2, denominador + (_azar.nextBool() ? 1 : -1));
        final nuevoNumerador =
            math.min(correcto.numerador, nuevoDen - 1);
        return NumeroMixto(
          entera: correcto.entera,
          numerador: nuevoNumerador,
          denominador: nuevoDen,
        );
      case 3:
      default:
        // Entera y numerador ambos distintos.
        return NumeroMixto(
          entera: correcto.entera + 1,
          numerador: math.max(0, correcto.numerador - 1),
          denominador: denominador,
        );
    }
  }
}
