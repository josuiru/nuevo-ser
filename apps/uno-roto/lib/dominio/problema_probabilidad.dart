import 'dart:math' as math;

import 'problema_espejo.dart' show Fraccion;

int _mcd(int a, int b) {
  a = a.abs();
  b = b.abs();
  while (b != 0) {
    final t = b;
    b = a % b;
    a = t;
  }
  return a == 0 ? 1 : a;
}

Fraccion _reducir(Fraccion f) {
  final g = _mcd(f.numerador, f.denominador);
  return Fraccion(f.numerador ~/ g, f.denominador ~/ g);
}

/// Problema EST.05: el niño ve "saco con 3 rojas y 5 azules → P(roja)
/// = ?" y elige la fracción reducida entre cuatro candidatos.
class ProblemaProbabilidad {
  final int favorables;
  final int otros;
  final List<Fraccion> candidatos;
  final int indiceCorrecto;

  const ProblemaProbabilidad({
    required this.favorables,
    required this.otros,
    required this.candidatos,
    required this.indiceCorrecto,
  });

  int get total => favorables + otros;

  Fraccion get probabilidad => candidatos[indiceCorrecto];

  bool esCorrecta(int indiceElegido) => indiceElegido == indiceCorrecto;
}

/// Pares (favorables, otros) curados.
const _paresFaciles = <(int, int)>[
  (3, 5),     // 3/8 (no reducible)
  (4, 6),     // 4/10 → 2/5
  (6, 4),     // 6/10 → 3/5
  (2, 8),     // 2/10 → 1/5
  (3, 7),     // 3/10
  (5, 5),     // 5/10 → 1/2
  (4, 8),     // 4/12 → 1/3
  (8, 4),     // 8/12 → 2/3
];

class GeneradorProbabilidad {
  final math.Random _azar;

  GeneradorProbabilidad({int? semilla}) : _azar = math.Random(semilla);

  static int get cantidadCurada => _paresFaciles.length;

  ProblemaProbabilidad generar({int dificultad = 1}) {
    final (favorables, otros) =
        _paresFaciles[_azar.nextInt(_paresFaciles.length)];
    return _construir(favorables, otros);
  }

  ProblemaProbabilidad generarPorIndice(int indice) {
    final (favorables, otros) =
        _paresFaciles[indice.clamp(0, _paresFaciles.length - 1)];
    return _construir(favorables, otros);
  }

  ProblemaProbabilidad _construir(int favorables, int otros) {
    final total = favorables + otros;
    final correcto = _reducir(Fraccion(favorables, total));

    final propuestos = <Fraccion>[correcto];
    bool yaEsta(Fraccion f) =>
        propuestos.any((p) =>
            p.numerador == f.numerador && p.denominador == f.denominador);
    void anyadirSiNuevo(Fraccion f) {
      if (f.numerador <= 0 || f.denominador <= 0) return;
      if (!yaEsta(f)) propuestos.add(f);
    }

    // 1. Probabilidad del complementario (otros / total reducido).
    anyadirSiNuevo(_reducir(Fraccion(otros, total)));
    // 2. Cociente al revés (favorables / otros, sin total).
    anyadirSiNuevo(_reducir(Fraccion(favorables, otros)));
    // 3. Forma sin reducir.
    anyadirSiNuevo(Fraccion(favorables, total));
    // 4. Off-by-one en el total (favorables / (total+1)).
    anyadirSiNuevo(_reducir(Fraccion(favorables, total + 1)));

    final cuatro = propuestos.take(4).toList()..shuffle(_azar);
    final indice = cuatro.indexWhere(
      (f) =>
          f.numerador == correcto.numerador &&
          f.denominador == correcto.denominador,
    );
    return ProblemaProbabilidad(
      favorables: favorables,
      otros: otros,
      candidatos: cuatro,
      indiceCorrecto: indice,
    );
  }
}
