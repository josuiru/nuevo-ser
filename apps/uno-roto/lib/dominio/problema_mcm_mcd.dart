import 'dart:math' as math;

/// Modo del puzzle: pedimos el mínimo común múltiplo o el máximo
/// común divisor. La pantalla y el motor son los mismos; el modo
/// cambia el enunciado y la respuesta correcta.
enum ModoMcmMcd { mcm, mcd }

/// Problema DIV.07: el niño ve dos números (p. ej. 8 y 12) y elige
/// el MCM o el MCD entre cuatro candidatos. Los distractores son los
/// errores típicos: confundir MCM y MCD, multiplicar o sumar los dos,
/// quedarse con uno de los dos números.
class ProblemaMcmMcd {
  final int a;
  final int b;
  final ModoMcmMcd modo;
  final List<int> candidatos;
  final int indiceCorrecto;

  const ProblemaMcmMcd({
    required this.a,
    required this.b,
    required this.modo,
    required this.candidatos,
    required this.indiceCorrecto,
  });

  int get resultado => candidatos[indiceCorrecto];

  bool esCorrecta(int indiceElegido) => indiceElegido == indiceCorrecto;
}

int _mcd(int x, int y) {
  var a = x.abs();
  var b = y.abs();
  while (b != 0) {
    final resto = a % b;
    a = b;
    b = resto;
  }
  return a;
}

int _mcm(int x, int y) {
  if (x == 0 || y == 0) return 0;
  return (x ~/ _mcd(x, y)) * y;
}

/// Genera problemas DIV.07. Pares curados con resultados manejables
/// (MCM ≤ 60, MCD ≥ 1) para que el niño pueda calcular mentalmente
/// sin perder el hilo.
class GeneradorMcmMcd {
  final math.Random _azar;

  GeneradorMcmMcd({int? semilla}) : _azar = math.Random(semilla);

  /// Pares (a, b) curados. La selección por dificultad amplía el rango
  /// de los números y también la variedad del MCM/MCD resultante.
  static const _paresFaciles = <(int, int)>[
    (4, 6), (6, 8), (4, 10), (6, 9), (8, 12), (10, 15),
    (3, 5), (4, 5), (6, 10), (4, 8), (3, 6), (9, 12),
  ];
  static const _paresMedios = <(int, int)>[
    (12, 18), (12, 20), (15, 20), (8, 18),
    (10, 12), (14, 21), (10, 25), (6, 15),
  ];
  static const _paresDificiles = <(int, int)>[
    (12, 15), (15, 24), (18, 24), (16, 24),
    (20, 30), (14, 35), (21, 28),
  ];

  ProblemaMcmMcd generar({
    required ModoMcmMcd modo,
    int dificultad = 1,
  }) {
    final pool = <(int, int)>[
      ..._paresFaciles,
      if (dificultad >= 2) ..._paresMedios,
      if (dificultad >= 3) ..._paresDificiles,
    ];
    final (a, b) = pool[_azar.nextInt(pool.length)];
    return _construirDesdePar(a: a, b: b, modo: modo);
  }

  /// Reconstruye un problema concreto a partir de los términos
  /// guardados en el Fragmento, para mantener consistencia entre
  /// lo que se ve en el tejado y lo que aparece al abrirlo.
  ProblemaMcmMcd generarDesdeTerminos({
    required int a,
    required int b,
    required ModoMcmMcd modo,
  }) =>
      _construirDesdePar(a: a, b: b, modo: modo);

  ProblemaMcmMcd _construirDesdePar({
    required int a,
    required int b,
    required ModoMcmMcd modo,
  }) {
    final mcm = _mcm(a, b);
    final mcd = _mcd(a, b);
    final correcto = modo == ModoMcmMcd.mcm ? mcm : mcd;
    final contrario = modo == ModoMcmMcd.mcm ? mcd : mcm;

    final propuestos = <int>[correcto];
    void anyadirSiNuevo(int valor) {
      if (valor > 0 && !propuestos.contains(valor)) {
        propuestos.add(valor);
      }
    }

    // 1. El contrario (confusión MCM↔MCD).
    anyadirSiNuevo(contrario);
    // 2. Producto de los dos (típico para MCM exagerado o MCD nulo).
    anyadirSiNuevo(a * b);
    // 3. Suma de los dos (intento simple cuando no se sabe).
    anyadirSiNuevo(a + b);
    // 4. Uno de los dos números (en MCD a veces el niño cree que es
    //    el menor, en MCM cree que es el mayor).
    anyadirSiNuevo(modo == ModoMcmMcd.mcd ? math.min(a, b) : math.max(a, b));
    // 5. El otro número, si todavía hay hueco.
    anyadirSiNuevo(modo == ModoMcmMcd.mcd ? math.max(a, b) : math.min(a, b));

    // Si tras todo seguimos por debajo de 4 candidatos (raro, pero
    // posible cuando colisionan), añade vecinos del correcto.
    var paso = 1;
    while (propuestos.length < 4) {
      anyadirSiNuevo(correcto + paso);
      if (propuestos.length < 4) anyadirSiNuevo(correcto - paso);
      paso++;
      if (paso > 6) break;
    }

    final cuatro = propuestos.take(4).toList()..shuffle(_azar);
    final indice = cuatro.indexOf(correcto);
    return ProblemaMcmMcd(
      a: a,
      b: b,
      modo: modo,
      candidatos: cuatro,
      indiceCorrecto: indice,
    );
  }
}
