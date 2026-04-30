import 'dart:math' as math;

import 'fragmento_en_tejado.dart' show OperadorAritmetico, SimboloOperador;

/// Problema OP.01: el niño ve una expresión con tres números y dos
/// operadores (p. ej. "2 + 3 × 4") y elige el resultado correcto entre
/// cuatro candidatos. La trampa pedagógica clásica: calcular de
/// izquierda a derecha sin respetar la prioridad de × y ÷.
class ProblemaJerarquia {
  /// Tres operandos a, b, c y dos operadores op1 entre a y b, op2
  /// entre b y c. Sin paréntesis: la pantalla los muestra tal cual.
  final int a;
  final int b;
  final int c;
  final OperadorAritmetico op1;
  final OperadorAritmetico op2;
  final List<int> candidatos;
  final int indiceCorrecto;

  const ProblemaJerarquia({
    required this.a,
    required this.b,
    required this.c,
    required this.op1,
    required this.op2,
    required this.candidatos,
    required this.indiceCorrecto,
  });

  int get resultado => candidatos[indiceCorrecto];

  bool esCorrecta(int indiceElegido) => indiceElegido == indiceCorrecto;
}

int _aplicar(int x, OperadorAritmetico op, int y) {
  switch (op) {
    case OperadorAritmetico.suma:
      return x + y;
    case OperadorAritmetico.resta:
      return x - y;
    case OperadorAritmetico.producto:
      return x * y;
    case OperadorAritmetico.division:
      return x ~/ y;
  }
}

bool _esPrioritario(OperadorAritmetico op) =>
    op == OperadorAritmetico.producto || op == OperadorAritmetico.division;

/// Triplas (a, b, c, op1, op2) curadas. Cada caso garantiza:
/// 1. Resultado entero (sin decimales).
/// 2. Resultado correcto distinto del cálculo izquierda-a-derecha
///    (para que el distractor pedagógico tenga peso).
/// 3. Operandos pequeños (≤ 20) para que el niño calcule mentalmente.
const _casosFaciles = <(int, int, int, OperadorAritmetico, OperadorAritmetico)>[
  // Suma con producto a la derecha.
  (2, 3, 4, OperadorAritmetico.suma, OperadorAritmetico.producto),    // 14 vs 20
  (5, 2, 3, OperadorAritmetico.suma, OperadorAritmetico.producto),    // 11 vs 21
  (8, 2, 3, OperadorAritmetico.suma, OperadorAritmetico.producto),    // 14 vs 30
  // Resta con producto a la derecha.
  (20, 4, 3, OperadorAritmetico.resta, OperadorAritmetico.producto),  // 8 vs 48
  (15, 2, 4, OperadorAritmetico.resta, OperadorAritmetico.producto),  // 7 vs 52
  // Resta con división a la derecha.
  (10, 6, 2, OperadorAritmetico.resta, OperadorAritmetico.division),  // 7 vs 2
  (12, 8, 4, OperadorAritmetico.resta, OperadorAritmetico.division),  // 10 vs 1
  // Suma con división a la derecha.
  (3, 8, 4, OperadorAritmetico.suma, OperadorAritmetico.division),    // 5 vs (3+8)/4=2
];
// Casos de dificultad media: misma estructura que los fáciles
// (op1 no prioritario + op2 prioritario) pero con operandos mayores.
// Esto preserva la trampa pedagógica del distractor "izquierda a
// derecha", que en los antiguos _casosMedios coincidía con el correcto
// porque op1 era prioritario.
const _casosMedios = <(int, int, int, OperadorAritmetico, OperadorAritmetico)>[
  (4, 6, 3, OperadorAritmetico.suma, OperadorAritmetico.producto),     // 22 vs 30
  (10, 4, 5, OperadorAritmetico.suma, OperadorAritmetico.producto),    // 30 vs 70
  (7, 9, 3, OperadorAritmetico.suma, OperadorAritmetico.division),     // 10 vs (16/3=5)
  (18, 6, 2, OperadorAritmetico.resta, OperadorAritmetico.division),   // 15 vs 6
  (25, 4, 5, OperadorAritmetico.resta, OperadorAritmetico.producto),   // 5 vs 105
  (16, 9, 3, OperadorAritmetico.resta, OperadorAritmetico.division),   // 13 vs 2
];

/// Evalúa la expresión respetando la prioridad de × y ÷.
int _evaluarConPrioridad({
  required int a,
  required int b,
  required int c,
  required OperadorAritmetico op1,
  required OperadorAritmetico op2,
}) {
  // Si op2 es prioritario y op1 no, evaluamos b op2 c primero.
  if (_esPrioritario(op2) && !_esPrioritario(op1)) {
    return _aplicar(a, op1, _aplicar(b, op2, c));
  }
  // En otro caso, el orden izquierda-a-derecha respeta la prioridad
  // (op1 prioritario o ambos del mismo nivel).
  return _aplicar(_aplicar(a, op1, b), op2, c);
}

/// Evalúa la expresión de izquierda a derecha (error pedagógico).
int _evaluarIzquierdaADerecha({
  required int a,
  required int b,
  required int c,
  required OperadorAritmetico op1,
  required OperadorAritmetico op2,
}) =>
    _aplicar(_aplicar(a, op1, b), op2, c);

class GeneradorJerarquia {
  final math.Random _azar;

  GeneradorJerarquia({int? semilla}) : _azar = math.Random(semilla);

  ProblemaJerarquia generar({int dificultad = 1}) {
    final pool = <(int, int, int, OperadorAritmetico, OperadorAritmetico)>[
      ..._casosFaciles,
      if (dificultad >= 2) ..._casosMedios,
    ];
    final caso = pool[_azar.nextInt(pool.length)];
    return _construirDesdeCaso(caso);
  }

  /// Reconstruye el problema concreto a partir de los términos
  /// guardados en el Fragmento.
  ProblemaJerarquia generarDesdeTerminos({
    required int a,
    required int b,
    required int c,
    required OperadorAritmetico op1,
    required OperadorAritmetico op2,
  }) =>
      _construirDesdeCaso((a, b, c, op1, op2));

  ProblemaJerarquia _construirDesdeCaso(
    (int, int, int, OperadorAritmetico, OperadorAritmetico) caso,
  ) {
    final (a, b, c, op1, op2) = caso;
    final correcto =
        _evaluarConPrioridad(a: a, b: b, c: c, op1: op1, op2: op2);
    final izqDer =
        _evaluarIzquierdaADerecha(a: a, b: b, c: c, op1: op1, op2: op2);

    final propuestos = <int>[correcto];
    void anyadirSiNuevo(int valor) {
      // Filtramos negativos: en este nivel el niño no trabaja
      // enteros relativos, un candidato negativo se descarta
      // visualmente pero rompe la legibilidad de la pantalla.
      if (valor < 0) return;
      if (!propuestos.contains(valor)) propuestos.add(valor);
    }

    // Trampa estrella: izquierda a derecha sin prioridad. Sólo añade
    // si difiere del correcto; en casos donde op1 es prioritario
    // ambos coinciden y el distractor se rellenaría con vecinos.
    if (izqDer != correcto) anyadirSiNuevo(izqDer);
    // Aplicar el otro operador equivocado (op1 sustituido por op2 o
    // similar) — añade un distractor más sutil.
    anyadirSiNuevo(_aplicar(a, op2, _aplicar(b, op1, c)));
    // Vecinos del correcto.
    var paso = 1;
    while (propuestos.length < 4) {
      anyadirSiNuevo(correcto + paso);
      if (propuestos.length < 4) anyadirSiNuevo(correcto - paso);
      paso++;
      if (paso > 8) break;
    }

    final cuatro = propuestos.take(4).toList()..shuffle(_azar);
    final indice = cuatro.indexOf(correcto);
    return ProblemaJerarquia(
      a: a,
      b: b,
      c: c,
      op1: op1,
      op2: op2,
      candidatos: cuatro,
      indiceCorrecto: indice,
    );
  }
}

/// Devuelve la expresión formateada como texto: "2 + 3 × 4".
String formatearExpresion(ProblemaJerarquia problema) =>
    '${problema.a} ${problema.op1.simbolo} ${problema.b} '
    '${problema.op2.simbolo} ${problema.c}';
