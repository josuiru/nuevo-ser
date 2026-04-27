import 'dart:math' as math;

/// Una razón "a:b" reducida a su forma mínima por el MCD de a y b.
class Razon {
  final int a;
  final int b;

  const Razon(this.a, this.b);

  /// Devuelve la razón reducida dividiendo ambos términos por el MCD.
  Razon reducida() {
    final divisor = _mcd(a.abs(), b.abs());
    if (divisor == 0) return this;
    return Razon(a ~/ divisor, b ~/ divisor);
  }

  bool esEquivalenteA(Razon otra) => a * otra.b == otra.a * b;

  String get etiqueta => '$a : $b';

  static int _mcd(int x, int y) {
    while (y != 0) {
      final resto = x % y;
      x = y;
      y = resto;
    }
    return x;
  }
}

/// Problema PROP.01: el niño ve dos cantidades en un contexto concreto
/// (p. ej. "12 manzanas y 8 naranjas") y elige la razón reducida que
/// las relaciona entre cuatro candidatos.
class ProblemaRazon {
  final int primero;
  final int segundo;
  final String etiquetaPrimero;
  final String etiquetaSegundo;
  final List<Razon> candidatos;
  final int indiceCorrecto;

  const ProblemaRazon({
    required this.primero,
    required this.segundo,
    required this.etiquetaPrimero,
    required this.etiquetaSegundo,
    required this.candidatos,
    required this.indiceCorrecto,
  });

  Razon get razonReducida => candidatos[indiceCorrecto];

  bool esCorrecta(int indiceElegido) => indiceElegido == indiceCorrecto;
}

/// Pares contextualizados (primero, segundo, etiquetaA, etiquetaB) con
/// MCD > 1 para que la razón reducida sea distinta de la presentada.
const _paresFaciles = <(int, int, String, String)>[
  (12, 8, 'manzanas', 'naranjas'),     // → 3:2
  (10, 6, 'rojas', 'azules'),          // → 5:3
  (15, 9, 'pequeñas', 'grandes'),      // → 5:3
  (8, 4, 'sí', 'no'),                  // → 2:1
  (6, 4, 'rosas', 'tulipanes'),        // → 3:2
  (9, 6, 'gatos', 'perros'),           // → 3:2
  (10, 4, 'verdes', 'amarillas'),      // → 5:2
  (12, 9, 'lápices', 'bolígrafos'),    // → 4:3
];
const _paresMedios = <(int, int, String, String)>[
  (18, 12, 'altas', 'bajas'),          // → 3:2
  (24, 16, 'rojas', 'verdes'),         // → 3:2
  (15, 10, 'libros', 'cuadernos'),     // → 3:2
  (20, 8, 'monedas', 'billetes'),      // → 5:2
  (14, 6, 'mías', 'tuyas'),            // → 7:3
];

class GeneradorRazon {
  final math.Random _azar;

  GeneradorRazon({int? semilla}) : _azar = math.Random(semilla);

  ProblemaRazon generar({int dificultad = 1}) {
    final pool = <(int, int, String, String)>[
      ..._paresFaciles,
      if (dificultad >= 2) ..._paresMedios,
    ];
    final (p, s, ea, eb) = pool[_azar.nextInt(pool.length)];
    return _construir(p, s, ea, eb);
  }

  ProblemaRazon generarDesdePar({
    required int primero,
    required int segundo,
    String etiquetaPrimero = 'rojas',
    String etiquetaSegundo = 'azules',
  }) =>
      _construir(primero, segundo, etiquetaPrimero, etiquetaSegundo);

  ProblemaRazon _construir(int p, int s, String ea, String eb) {
    final original = Razon(p, s);
    final reducida = original.reducida();

    final propuestas = <Razon>[reducida];
    void anyadirSiNueva(Razon r) {
      if (r.a <= 0 || r.b <= 0) return;
      if (propuestas
          .any((existing) => existing.a == r.a && existing.b == r.b)) {
        return;
      }
      propuestas.add(r);
    }

    // 1. Razón sin reducir (los números originales) — el error típico:
    //    "no he simplificado".
    anyadirSiNueva(original);
    // 2. Razón invertida (b:a en lugar de a:b) — confunde el orden.
    anyadirSiNueva(Razon(reducida.b, reducida.a));
    // 3. Razón con la suma como segundo término (a : a+b).
    anyadirSiNueva(Razon(reducida.a, reducida.a + reducida.b));
    // 4. Razón con números cercanos al reducido (off-by-one).
    anyadirSiNueva(Razon(reducida.a + 1, reducida.b));
    anyadirSiNueva(Razon(reducida.a, reducida.b + 1));

    final cuatro = propuestas.take(4).toList()..shuffle(_azar);
    final indice = cuatro.indexWhere(
      (r) => r.a == reducida.a && r.b == reducida.b,
    );
    return ProblemaRazon(
      primero: p,
      segundo: s,
      etiquetaPrimero: ea,
      etiquetaSegundo: eb,
      candidatos: cuatro,
      indiceCorrecto: indice,
    );
  }
}
