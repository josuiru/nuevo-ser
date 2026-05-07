import 'dart:math' as math;

/// Puzzle ARI.03: el niño ve `√n` con n cuadrado perfecto y elige la
/// raíz entre cuatro candidatos. Inversa pedagógica de ARI.02 — la
/// radicación como operación contraria a la potenciación.
class ProblemaRaizCuadrada {
  /// Radicando: número cuyo cuadrado se conoce.
  final int radicando;

  final List<int> candidatos;
  final int indiceCorrecto;

  const ProblemaRaizCuadrada({
    required this.radicando,
    required this.candidatos,
    required this.indiceCorrecto,
  });

  int get correcto => math.sqrt(radicando).round();
  bool esCorrecta(int indice) => indice == indiceCorrecto;

  /// "√144".
  String get etiqueta => '√$radicando';
}

/// Genera raíces cuadradas exactas con dificultad escalonada.
///   - Dif 1: raíces 2..5  (radicandos 4..25).
///   - Dif 2: raíces 2..9  (4..81).
///   - Dif 3: raíces 2..12 (4..144).
///   - Dif 4: raíces 2..15 (4..225).
class GeneradorRaizCuadrada {
  final math.Random _azar;

  GeneradorRaizCuadrada({int? semilla}) : _azar = math.Random(semilla);

  ProblemaRaizCuadrada generar({int dificultad = 1}) {
    final maxRaiz = switch (dificultad) {
      1 => 5,
      2 => 9,
      3 => 12,
      _ => 15,
    };
    final raiz = 2 + _azar.nextInt(maxRaiz - 1);
    return generarDesde(raiz: raiz);
  }

  ProblemaRaizCuadrada generarDesde({required int raiz}) {
    final radicando = raiz * raiz;
    final correcto = raiz;
    final distractores = <int>{};

    // Distractor estrella: confundir raíz con mitad del radicando
    // (`√100 → 50` en lugar de `10`). Error frecuentísimo.
    final mitad = radicando ~/ 2;
    if (mitad != correcto && mitad > 0) distractores.add(mitad);

    // Distractor: el propio radicando.
    if (radicando != correcto) distractores.add(radicando);

    // Distractor: raíz vecina (raíz±1).
    if (correcto + 1 > 1) distractores.add(correcto + 1);
    if (correcto - 1 > 1 && distractores.length < 3) {
      distractores.add(correcto - 1);
    }

    var k = 2;
    while (distractores.length < 3 && k < 100) {
      final candidato = correcto + k;
      k++;
      if (candidato == correcto || candidato <= 0) continue;
      if (distractores.contains(candidato)) continue;
      distractores.add(candidato);
    }

    final lista = <int>[correcto, ...distractores.take(3)];
    lista.shuffle(_azar);
    return ProblemaRaizCuadrada(
      radicando: radicando,
      candidatos: lista,
      indiceCorrecto: lista.indexOf(correcto),
    );
  }
}
