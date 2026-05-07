import 'dart:math' as math;

/// Puzzle ARI.02: el niño ve `a^b = ?` con base y exponente naturales
/// pequeños y elige el resultado entre cuatro candidatos. Entrada a la
/// notación posicional avanzada para 12-14 años.
class ProblemaPotenciaNatural {
  /// Base de la potencia.
  final int base;

  /// Exponente natural (≥1).
  final int exponente;

  final List<int> candidatos;
  final int indiceCorrecto;

  const ProblemaPotenciaNatural({
    required this.base,
    required this.exponente,
    required this.candidatos,
    required this.indiceCorrecto,
  });

  int get correcto {
    var resultado = 1;
    for (var i = 0; i < exponente; i++) {
      resultado *= base;
    }
    return resultado;
  }

  bool esCorrecta(int indice) => indice == indiceCorrecto;

  /// Etiqueta visual: "2⁴", "5³", etc. Usa caracteres Unicode de
  /// superíndice para los exponentes 1..9 (suficiente para el rango
  /// del juego, sin romper el render de Flutter en pantallas pequeñas).
  String get etiqueta => '$base${_superindice(exponente)}';

  static String _superindice(int n) {
    const tabla = ['⁰', '¹', '²', '³', '⁴', '⁵', '⁶', '⁷', '⁸', '⁹'];
    return n.toString().split('').map((c) => tabla[int.parse(c)]).join();
  }
}

/// Genera potencias con resultado entero pequeño en su mayoría.
///   - Dif 1: base 2..5, exponente 2..3 (resultados 4..125).
///   - Dif 2: base 2..6, exponente 2..4.
///   - Dif 3: base 2..10, exponente 2..4. Incluye 10ⁿ.
///   - Dif 4: base 2..12, exponente 2..5. Resultados grandes legibles.
class GeneradorPotenciaNatural {
  final math.Random _azar;

  GeneradorPotenciaNatural({int? semilla}) : _azar = math.Random(semilla);

  ProblemaPotenciaNatural generar({int dificultad = 1}) {
    final (minBase, maxBase, minExp, maxExp) = switch (dificultad) {
      1 => (2, 5, 2, 3),
      2 => (2, 6, 2, 4),
      3 => (2, 10, 2, 4),
      _ => (2, 12, 2, 5),
    };
    final base = minBase + _azar.nextInt(maxBase - minBase + 1);
    final exponente = minExp + _azar.nextInt(maxExp - minExp + 1);
    return generarDesde(base: base, exponente: exponente);
  }

  ProblemaPotenciaNatural generarDesde({
    required int base,
    required int exponente,
  }) {
    final problema = ProblemaPotenciaNatural(
      base: base,
      exponente: exponente,
      candidatos: const [],
      indiceCorrecto: 0,
    );
    final correcto = problema.correcto;
    final distractores = <int>{};

    // Distractor estrella: confundir con producto base × exponente
    // (`2^4 → 8` en lugar de `16`). Es el error más típico la primera vez.
    final productoLineal = base * exponente;
    if (productoLineal != correcto && productoLineal > 0) {
      distractores.add(productoLineal);
    }

    // Distractor: un exponente más / uno menos.
    if (exponente >= 2) {
      var resultMenosUno = 1;
      for (var i = 0; i < exponente - 1; i++) {
        resultMenosUno *= base;
      }
      if (resultMenosUno != correcto) distractores.add(resultMenosUno);
    }
    final resultMasUno = correcto * base;
    if (resultMasUno > 0 && resultMasUno < 100000) {
      distractores.add(resultMasUno);
    }

    // Distractor: error frecuente — duplicar la base por el exponente
    // (`2^4 → 2*4 + 2 = 10`, etc). Lo modelamos como base+exponente.
    final suma = base + exponente;
    if (suma != correcto && suma > 0 && !distractores.contains(suma)) {
      distractores.add(suma);
    }

    var k = 2;
    while (distractores.length < 3 && k < 200) {
      final candidato = correcto + k;
      k++;
      if (candidato == correcto || candidato <= 0) continue;
      if (distractores.contains(candidato)) continue;
      distractores.add(candidato);
    }

    final lista = <int>[correcto, ...distractores.take(3)];
    lista.shuffle(_azar);
    return ProblemaPotenciaNatural(
      base: base,
      exponente: exponente,
      candidatos: lista,
      indiceCorrecto: lista.indexOf(correcto),
    );
  }
}
