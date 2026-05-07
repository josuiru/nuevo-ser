import 'dart:math' as math;

/// Puzzle GEO.08: el niño ve un triángulo rectángulo con dos lados
/// etiquetados y elige el tercero entre cuatro candidatos. Aplicación
/// directa de Pitágoras `a² + b² = c²`. Solo tripletas pitagóricas
/// enteras — el resultado siempre es entero, sin radicales sueltos.
class ProblemaPitagoras {
  /// Cateto a (lado conocido junto al ángulo recto).
  final int a;

  /// Cateto b (otro lado junto al ángulo recto).
  final int b;

  /// Hipotenusa.
  final int hipotenusa;

  /// Modo: descubrir hipotenusa o descubrir un cateto.
  final ModoPitagoras modo;

  final List<int> candidatos;
  final int indiceCorrecto;

  const ProblemaPitagoras({
    required this.a,
    required this.b,
    required this.hipotenusa,
    required this.modo,
    required this.candidatos,
    required this.indiceCorrecto,
  });

  int get correcto => switch (modo) {
        ModoPitagoras.hipotenusa => hipotenusa,
        ModoPitagoras.cateto => b,
      };

  bool esCorrecta(int indice) => indice == indiceCorrecto;
}

enum ModoPitagoras { hipotenusa, cateto }

/// Pool curado de tripletas pitagóricas (a, b, c) con a ≤ b < c.
/// Limitado a tamaños donde el dibujo del triángulo se ve bien y los
/// niños pueden estimar sin calcular si el orden de magnitud encaja.
const _tripletas = <List<int>>[
  [3, 4, 5],
  [6, 8, 10],
  [5, 12, 13],
  [9, 12, 15],
  [8, 15, 17],
  [12, 16, 20],
  [7, 24, 25],
  [20, 21, 29],
  [9, 40, 41],
  [12, 35, 37],
];

class GeneradorPitagoras {
  final math.Random _azar;

  GeneradorPitagoras({int? semilla}) : _azar = math.Random(semilla);

  /// Genera Pitágoras escalando dificultad por tamaño de la tripleta y
  /// por modo (cateto desconocido > hipotenusa desconocida).
  ///   - Dif 1: hipotenusa desconocida, tripletas pequeñas.
  ///   - Dif 2: hipotenusa desconocida, tripletas medianas.
  ///   - Dif 3: cateto desconocido, tripletas pequeñas/medianas.
  ///   - Dif 4: cateto desconocido, tripletas grandes.
  ProblemaPitagoras generar({int dificultad = 1}) {
    final modo = dificultad >= 3
        ? ModoPitagoras.cateto
        : ModoPitagoras.hipotenusa;

    final pool = switch (dificultad) {
      1 => _tripletas.take(3).toList(), // 3-4-5, 6-8-10, 5-12-13
      2 => _tripletas.take(6).toList(),
      3 => _tripletas.take(8).toList(),
      _ => _tripletas,
    };

    final tripleta = pool[_azar.nextInt(pool.length)];
    return _construir(
      a: tripleta[0],
      b: tripleta[1],
      c: tripleta[2],
      modo: modo,
    );
  }

  ProblemaPitagoras _construir({
    required int a,
    required int b,
    required int c,
    required ModoPitagoras modo,
  }) {
    final correcto = modo == ModoPitagoras.hipotenusa ? c : b;
    final distractores = <int>{};

    if (modo == ModoPitagoras.hipotenusa) {
      // Distractor estrella: sumar lados linealmente (a + b) en lugar
      // de aplicar Pitágoras. Error clásico al iniciar el teorema.
      final sumaLineal = a + b;
      if (sumaLineal != correcto) distractores.add(sumaLineal);

      // Distractor: el cateto mayor (b) sin operar.
      if (b != correcto) distractores.add(b);

      // Distractor: a² + b² sin raíz (responder el cuadrado en lugar
      // de la raíz).
      final cuadrado = a * a + b * b;
      if (cuadrado != correcto && cuadrado < 1000) {
        distractores.add(cuadrado);
      }
    } else {
      // Modo cateto: hipotenusa y a conocidos, b incógnita.
      // Distractor estrella: restar linealmente (c - a) en lugar de
      // hacer √(c² - a²).
      final restaLineal = c - a;
      if (restaLineal != correcto && restaLineal > 0) {
        distractores.add(restaLineal);
      }

      // Distractor: c² − a² sin raíz.
      final restaCuadrados = c * c - a * a;
      if (restaCuadrados != correcto && restaCuadrados > 0) {
        distractores.add(restaCuadrados);
      }

      // Distractor: el cateto a literal (confundirse de incógnita).
      if (a != correcto) distractores.add(a);
    }

    var k = 1;
    while (distractores.length < 3 && k < 50) {
      final candidato = correcto + k;
      k++;
      if (candidato == correcto || candidato <= 0) continue;
      if (distractores.contains(candidato)) continue;
      distractores.add(candidato);
    }

    final lista = <int>[correcto, ...distractores.take(3)];
    lista.shuffle(_azar);
    return ProblemaPitagoras(
      a: a,
      b: b,
      hipotenusa: c,
      modo: modo,
      candidatos: lista,
      indiceCorrecto: lista.indexOf(correcto),
    );
  }
}
