import 'dart:math' as math;

import 'problema_espejo.dart' show Fraccion;

/// Problema FR.03: el niño ve un rectángulo dividido en N columnas
/// con M coloreadas y elige la fracción correcta entre cuatro
/// candidatos. Primer puzzle visual de Uno Roto: la lectura ocurre
/// **mirando**, no leyendo cifras.
class ProblemaRepresentacionFraccion {
  final Fraccion fraccionCorrecta;
  final List<Fraccion> candidatos;
  final int indiceCorrecto;

  const ProblemaRepresentacionFraccion({
    required this.fraccionCorrecta,
    required this.candidatos,
    required this.indiceCorrecto,
  });

  int get numerador => fraccionCorrecta.numerador;
  int get denominador => fraccionCorrecta.denominador;

  bool esCorrecta(int indiceElegido) => indiceElegido == indiceCorrecto;
}

/// Genera problemas FR.03 con distractores que reflejan los errores
/// reales: invertir num/den (cuando el niño cuenta las partes mal),
/// confundir lo coloreado con lo no coloreado (complemento), o un
/// vecino del numerador (error de conteo).
class GeneradorRepresentacionFraccion {
  final math.Random _azar;

  GeneradorRepresentacionFraccion({int? semilla})
      : _azar = math.Random(semilla);

  ProblemaRepresentacionFraccion generar({int dificultad = 1}) {
    final candidatosDenominador = switch (dificultad) {
      1 => const <int>[2, 3, 4, 5, 6],
      2 => const <int>[3, 4, 5, 6, 7, 8],
      _ => const <int>[5, 6, 7, 8, 9, 10],
    };
    final denominador =
        candidatosDenominador[_azar.nextInt(candidatosDenominador.length)];
    final numerador = 1 + _azar.nextInt(denominador - 1);
    return _construirDesdeFraccion(Fraccion(numerador, denominador));
  }

  /// Reconstruye el problema concreto a partir de la fracción
  /// guardada en el Fragmento — para mantener consistencia entre
  /// la representación que se ve en el tejado y el puzzle.
  ProblemaRepresentacionFraccion generarDesdeFraccion(Fraccion fraccion) =>
      _construirDesdeFraccion(fraccion);

  ProblemaRepresentacionFraccion _construirDesdeFraccion(Fraccion correcta) {
    final propuestos = <Fraccion>[correcta];
    bool yaEsta(Fraccion f) => propuestos.any((p) =>
        p.numerador == f.numerador && p.denominador == f.denominador);
    void anyadirSiNuevo(Fraccion f) {
      if (f.numerador > 0 && f.denominador > 0 && !yaEsta(f)) {
        propuestos.add(f);
      }
    }

    // Trampa 1: invertir num/den (el niño que cuenta las partes mal).
    anyadirSiNuevo(Fraccion(correcta.denominador, correcta.numerador));
    // Trampa 2: complemento (cuenta lo NO coloreado).
    final complemento = correcta.denominador - correcta.numerador;
    anyadirSiNuevo(Fraccion(complemento, correcta.denominador));
    // Trampa 3: vecino del numerador (error de conteo ±1).
    anyadirSiNuevo(Fraccion(correcta.numerador + 1, correcta.denominador));
    if (correcta.numerador - 1 > 0) {
      anyadirSiNuevo(Fraccion(correcta.numerador - 1, correcta.denominador));
    }

    // Si tras los distractores hay menos de 4, completa con un vecino
    // del denominador o variantes seguras.
    var paso = 1;
    while (propuestos.length < 4) {
      anyadirSiNuevo(
          Fraccion(correcta.numerador, correcta.denominador + paso));
      if (propuestos.length < 4 && correcta.denominador - paso > 1) {
        anyadirSiNuevo(
            Fraccion(correcta.numerador, correcta.denominador - paso));
      }
      paso++;
      if (paso > 4) break;
    }

    final cuatro = propuestos.take(4).toList()..shuffle(_azar);
    final indice = cuatro.indexWhere((f) =>
        f.numerador == correcta.numerador &&
        f.denominador == correcta.denominador);
    return ProblemaRepresentacionFraccion(
      fraccionCorrecta: correcta,
      candidatos: cuatro,
      indiceCorrecto: indice,
    );
  }
}
