import 'dart:math' as math;

import 'problema_espejo.dart' show Fraccion;

/// Problema FR.13: el niño ve un número mixto (p. ej. "2 y 3/4") y
/// elige la fracción impropia equivalente entre cuatro candidatos.
/// Inverso pedagógico de FR.12 (impropia → mixta).
///
/// Cálculo correcto: (entero × denominador + numerador) / denominador.
class ProblemaMixtoAImpropio {
  final int entero;
  final int numerador;
  final int denominador;
  final List<Fraccion> candidatos;
  final int indiceCorrecto;

  const ProblemaMixtoAImpropio({
    required this.entero,
    required this.numerador,
    required this.denominador,
    required this.candidatos,
    required this.indiceCorrecto,
  });

  Fraccion get fraccionCorrecta => candidatos[indiceCorrecto];

  bool esCorrecta(int indiceElegido) => indiceElegido == indiceCorrecto;
}

/// Genera problemas FR.13 con distractores que reflejan los tres
/// errores reales del niño: sumar todo (e+n+d), quedarse con la
/// fracción (n/d) ignorando el entero, multiplicar entero por
/// numerador sin sumar (e×n / d). Si dos colisionan, sustituye uno
/// por un error de ±1 o ±2 en el numerador correcto.
class GeneradorMixtoAImpropio {
  final math.Random _azar;

  GeneradorMixtoAImpropio({int? semilla}) : _azar = math.Random(semilla);

  ProblemaMixtoAImpropio generar({int dificultad = 1}) {
    final candidatosDenominador = switch (dificultad) {
      1 => const <int>[2, 3, 4],
      2 => const <int>[2, 3, 4, 5, 6],
      _ => const <int>[2, 3, 4, 5, 6, 7, 8, 9],
    };
    final denominador =
        candidatosDenominador[_azar.nextInt(candidatosDenominador.length)];
    final entero = 1 + _azar.nextInt(4); // 1..4
    final numerador = 1 + _azar.nextInt(denominador - 1);

    final correcto = Fraccion(entero * denominador + numerador, denominador);

    final propuestos = <Fraccion>[correcto];
    bool yaEsta(Fraccion f) =>
        propuestos.any((p) =>
            p.numerador == f.numerador && p.denominador == f.denominador);
    void anyadirSiNuevo(Fraccion f) {
      if (f.numerador > 0 && !yaEsta(f)) propuestos.add(f);
    }

    // Trampas pedagógicas en orden de prioridad.
    anyadirSiNuevo(Fraccion(entero + numerador, denominador));
    anyadirSiNuevo(Fraccion(numerador, denominador));
    anyadirSiNuevo(Fraccion(entero * numerador, denominador));

    // Si alguno colisionó, completa con vecinos ±1, ±2 del correcto.
    var paso = 1;
    while (propuestos.length < 4) {
      anyadirSiNuevo(
          Fraccion(correcto.numerador + paso, denominador));
      if (propuestos.length < 4) {
        anyadirSiNuevo(
            Fraccion(correcto.numerador - paso, denominador));
      }
      paso++;
    }

    final candidatosLista = propuestos..shuffle(_azar);
    final indice = candidatosLista.indexWhere(
      (f) =>
          f.numerador == correcto.numerador &&
          f.denominador == correcto.denominador,
    );

    return ProblemaMixtoAImpropio(
      entero: entero,
      numerador: numerador,
      denominador: denominador,
      candidatos: candidatosLista,
      indiceCorrecto: indice,
    );
  }
}
