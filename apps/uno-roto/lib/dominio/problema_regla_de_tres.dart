import 'dart:math' as math;

/// Problema PROP.03: el niño ve una proporción "a → b, c → ?" y elige
/// el valor correcto entre cuatro candidatos. Mecánica de regla de
/// tres directa: si a corresponde a b, entonces c corresponde a
/// (b · c) / a.
class ProblemaReglaDeTres {
  final int a;
  final int b;
  final int c;
  final List<int> candidatos;
  final int indiceCorrecto;

  const ProblemaReglaDeTres({
    required this.a,
    required this.b,
    required this.c,
    required this.candidatos,
    required this.indiceCorrecto,
  });

  int get resultado => candidatos[indiceCorrecto];

  bool esCorrecta(int indiceElegido) => indiceElegido == indiceCorrecto;
}

/// Triplas (a, b, c) con resultado entero garantizado, c ≠ a (para
/// que el puzzle no sea trivial) y a+b+c ≠ b·c/a (para que el
/// distractor pedagógico "sumar todo" no colisione con el correcto).
/// Repartidas por dificultad.
const _triplasFaciles = <(int, int, int)>[
  (2, 6, 5),    // 2:6 = 5:15  (antes 2,6,4 — suma colisionaba)
  (3, 9, 7),    // 3:9 = 7:21  (antes 3,9,6 — suma colisionaba)
  (4, 12, 7),   // 4:12 = 7:21 (antes 4,12,8 — suma colisionaba)
  (5, 10, 7),   // 5:10 = 7:14
  (2, 8, 5),    // 2:8 = 5:20
  (3, 6, 4),    // 3:6 = 4:8
  (5, 15, 2),   // 5:15 = 2:6
  (4, 8, 7),    // 4:8 = 7:14
];
const _triplasMedias = <(int, int, int)>[
  (3, 12, 7),   // 3:12 = 7:28
  (5, 20, 4),   // 5:20 = 4:16
  (6, 9, 8),    // 6:9 = 8:12
  (4, 10, 6),   // 4:10 = 6:15
  (6, 15, 4),   // 6:15 = 4:10
  (8, 12, 6),   // 8:12 = 6:9
];

/// Genera problemas PROP.03 con los errores reales como distractores:
/// invertir la relación (b·a/c en lugar de b·c/a), sumar todo, multiplicar
/// los tres, restar uno de otro.
class GeneradorReglaDeTres {
  final math.Random _azar;

  GeneradorReglaDeTres({int? semilla}) : _azar = math.Random(semilla);

  ProblemaReglaDeTres generar({int dificultad = 1}) {
    final pool = <(int, int, int)>[
      ..._triplasFaciles,
      if (dificultad >= 2) ..._triplasMedias,
    ];
    final (a, b, c) = pool[_azar.nextInt(pool.length)];
    return _construirDesdeTripla(a, b, c);
  }

  /// Reconstruye un problema concreto a partir de los términos
  /// guardados en el Fragmento.
  ProblemaReglaDeTres generarDesdeTerminos({
    required int a,
    required int b,
    required int c,
  }) =>
      _construirDesdeTripla(a, b, c);

  ProblemaReglaDeTres _construirDesdeTripla(int a, int b, int c) {
    final correcto = (b * c) ~/ a;

    final propuestos = <int>[correcto];
    void anyadirSiNuevo(int valor) {
      if (valor > 0 && !propuestos.contains(valor)) {
        propuestos.add(valor);
      }
    }

    // 1. Relación invertida (b · a / c en lugar de b · c / a).
    if (c != 0) anyadirSiNuevo((b * a) ~/ c);
    // 2. Suma de los tres (intento simple).
    anyadirSiNuevo(a + b + c);
    // 3. Solo el segundo término (ignora la proporción).
    anyadirSiNuevo(b);
    // 4. b + c (otra suma común).
    anyadirSiNuevo(b + c);

    var paso = 1;
    while (propuestos.length < 4) {
      anyadirSiNuevo(correcto + paso);
      if (propuestos.length < 4) anyadirSiNuevo(correcto - paso);
      paso++;
      if (paso > 6) break;
    }

    final cuatro = propuestos.take(4).toList()..shuffle(_azar);
    final indice = cuatro.indexOf(correcto);
    return ProblemaReglaDeTres(
      a: a,
      b: b,
      c: c,
      candidatos: cuatro,
      indiceCorrecto: indice,
    );
  }
}
