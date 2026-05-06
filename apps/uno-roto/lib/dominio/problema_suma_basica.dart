import 'dart:math' as math;

/// Puzzle ARI.01: el niño ve "a + b = ?" con dos enteros pequeños y
/// elige el resultado entre cuatro candidatos. Primer puzzle del
/// dominio ARI (Aritmética básica) — entrada para niños de 6-9 años o
/// para usuarios con dificultades en mates que necesitan reforzar la
/// base antes de subir.
class ProblemaSumaBasica {
  final int a;
  final int b;
  final List<int> candidatos;
  final int indiceCorrecto;

  const ProblemaSumaBasica({
    required this.a,
    required this.b,
    required this.candidatos,
    required this.indiceCorrecto,
  });

  int get correcto => a + b;
  bool esCorrecta(int indice) => indice == indiceCorrecto;
}

/// Genera problemas de suma básica con dificultad escalonada:
///   - Dif 1: 1+1 a 5+5 (sin llevadas, manipulable mentalmente).
///   - Dif 2: 1+1 a 9+9 (mezcla con llevadas, dígito + dígito).
///   - Dif 3: 10..20 + 1..9 (decena + unidad).
///   - Dif 4: 10..50 + 10..50 (decena + decena, con llevadas).
class GeneradorSumaBasica {
  final math.Random _azar;

  GeneradorSumaBasica({int? semilla}) : _azar = math.Random(semilla);

  ProblemaSumaBasica generar({int dificultad = 1}) {
    final (minA, maxA, minB, maxB) = switch (dificultad) {
      1 => (1, 5, 1, 5),
      2 => (1, 9, 1, 9),
      3 => (10, 20, 1, 9),
      _ => (10, 50, 10, 50),
    };
    final a = minA + _azar.nextInt(maxA - minA + 1);
    final b = minB + _azar.nextInt(maxB - minB + 1);
    return generarDesde(a: a, b: b);
  }

  ProblemaSumaBasica generarDesde({required int a, required int b}) {
    final correcto = a + b;
    final distractores = <int>{};

    // Distractor: confundir con la resta — error pedagógico clave a
    // esta edad (el niño aprende el signo + pero a veces lo lee como −).
    final resta = (a - b).abs();
    if (resta != correcto && resta > 0) distractores.add(resta);

    // Distractor: off-by-one al contar (cuenta uno de los sumandos
    // dos veces o se salta uno).
    if (correcto - 1 > 0 && correcto - 1 != resta) {
      distractores.add(correcto - 1);
    }
    if (distractores.length < 3) {
      distractores.add(correcto + 1);
    }

    // Distractor: producto en lugar de suma (típico para sumandos
    // pequeños donde a×b es plausiblemente cercano).
    final producto = a * b;
    if (producto != correcto &&
        producto > 0 &&
        producto < correcto * 4 &&
        !distractores.contains(producto)) {
      distractores.add(producto);
    }

    // Fallback ultra defensivo — varía k para garantizar unicidad.
    var k = 2;
    while (distractores.length < 3 && k < 50) {
      final candidato = correcto + k;
      k++;
      if (candidato == correcto) continue;
      if (distractores.contains(candidato)) continue;
      distractores.add(candidato);
    }

    final lista = <int>[correcto, ...distractores.take(3)];
    lista.shuffle(_azar);
    return ProblemaSumaBasica(
      a: a,
      b: b,
      candidatos: lista,
      indiceCorrecto: lista.indexOf(correcto),
    );
  }
}
