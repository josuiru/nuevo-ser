import 'dart:math' as math;

/// Problema PROP.07: el niño ve "Mapa 1:500 — 4 cm en plano → ? m" y
/// elige el resultado entre cuatro candidatos. Mecánica: multiplicar
/// la medida en plano por la escala, luego convertir cm → m (o m → km).
class ProblemaEscala {
  /// Denominador de la escala 1:N.
  final int denominadorEscala;

  /// Medida en el plano (en cm).
  final int valorPlanoCm;

  /// Resultado correcto en metros.
  final int resultadoMetros;

  final List<int> candidatos;
  final int indiceCorrecto;

  const ProblemaEscala({
    required this.denominadorEscala,
    required this.valorPlanoCm,
    required this.resultadoMetros,
    required this.candidatos,
    required this.indiceCorrecto,
  });

  bool esCorrecta(int indiceElegido) => indiceElegido == indiceCorrecto;
}

/// Pares (denominadorEscala, valorPlanoCm) curados para que el
/// resultado sea entero en metros.
const _paresFaciles = <(int, int)>[
  (100, 5),     // 5 m
  (100, 8),     // 8 m
  (200, 3),     // 6 m
  (200, 7),     // 14 m
  (500, 4),     // 20 m
  (500, 6),     // 30 m
  (1000, 5),    // 50 m
  (1000, 3),    // 30 m
];
const _paresMedios = <(int, int)>[
  (1000, 12),   // 120 m
  (2000, 5),    // 100 m
  (5000, 4),    // 200 m
  (10000, 3),   // 300 m
];

class GeneradorEscala {
  final math.Random _azar;

  GeneradorEscala({int? semilla}) : _azar = math.Random(semilla);

  ProblemaEscala generar({int dificultad = 1}) {
    final pool = <(int, int)>[
      ..._paresFaciles,
      if (dificultad >= 2) ..._paresMedios,
    ];
    final (escala, valor) = pool[_azar.nextInt(pool.length)];
    return _construir(escala, valor);
  }

  ProblemaEscala generarDesdeTerminos({
    required int denominadorEscala,
    required int valorPlanoCm,
  }) =>
      _construir(denominadorEscala, valorPlanoCm);

  ProblemaEscala _construir(int escala, int valorCm) {
    // valorCm × escala = real en cm; / 100 → real en m.
    final realCm = valorCm * escala;
    final correcto = realCm ~/ 100;

    final propuestos = <int>[correcto];
    void anyadirSiNuevo(int v) {
      if (v <= 0) return;
      if (!propuestos.contains(v)) propuestos.add(v);
    }

    // 1. Olvidar la conversión cm → m: el resultado en cm sin pasar a m.
    anyadirSiNuevo(realCm);
    // 2. Multiplicar en lugar de aplicar la escala: valor × escala / 1000
    //    (confundir el factor 100 de cm/m con 1000 de cm/km).
    anyadirSiNuevo((valorCm * escala) ~/ 1000);
    // 3. La escala literal como respuesta (típico despiste).
    anyadirSiNuevo(escala);
    // 4. Solo el valor del plano sin aplicar escala. Cuando la
    //    escala es 1:100 — caso "(100, valor)" — el resultado en m
    //    coincide numéricamente con el valor en cm (porque
    //    valor × 100 / 100 = valor) y este distractor colisiona;
    //    sustituimos por valorCm × 10 (la trampa "factor de un cero
    //    de más", típica al confundir escalas).
    anyadirSiNuevo(valorCm == correcto ? valorCm * 10 : valorCm);

    var paso = 5;
    while (propuestos.length < 4) {
      anyadirSiNuevo(correcto + paso);
      if (propuestos.length < 4) anyadirSiNuevo(correcto - paso);
      paso += 5;
      if (paso > 100) break;
    }

    final cuatro = propuestos.take(4).toList()..shuffle(_azar);
    final indice = cuatro.indexOf(correcto);
    return ProblemaEscala(
      denominadorEscala: escala,
      valorPlanoCm: valorCm,
      resultadoMetros: correcto,
      candidatos: cuatro,
      indiceCorrecto: indice,
    );
  }
}
