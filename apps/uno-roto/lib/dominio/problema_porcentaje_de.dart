import 'dart:math' as math;

/// Problema PROP.05: el niño ve "12 de 50 → ¿qué porcentaje?" y elige
/// el resultado entre cuatro candidatos. Mecánica inversa de PROP.04
/// (porcentaje de cantidad): aquí se calcula `parte/total × 100`.
class ProblemaPorcentajeDe {
  /// Parte concreta (12 en "12 de 50").
  final int parte;

  /// Total de referencia (50 en "12 de 50").
  final int total;

  /// Porcentajes candidatos (incluido el correcto).
  final List<int> candidatos;

  final int indiceCorrecto;

  const ProblemaPorcentajeDe({
    required this.parte,
    required this.total,
    required this.candidatos,
    required this.indiceCorrecto,
  });

  int get resultado => candidatos[indiceCorrecto];

  bool esCorrecta(int indiceElegido) => indiceElegido == indiceCorrecto;
}

/// Pares (parte, total) curados para que parte/total × 100 sea entero
/// y el porcentaje sea uno común en primaria (10, 20, 25, 40, 50, 75…).
const _paresFaciles = <(int, int)>[
  (12, 50),    // 24%
  (15, 60),    // 25%
  (20, 80),    // 25%
  (3, 30),     // 10%
  (15, 30),    // 50%
  (4, 20),     // 20%
  (9, 30),     // 30%
  (16, 40),    // 40%
  (6, 30),     // 20%
  (10, 25),    // 40%
];
const _paresMedios = <(int, int)>[
  (21, 30),    // 70%
  (24, 30),    // 80%
  (33, 50),    // 66%
  (45, 60),    // 75%
  (18, 24),    // 75%
  (35, 50),    // 70%
];

class GeneradorPorcentajeDe {
  final math.Random _azar;

  GeneradorPorcentajeDe({int? semilla}) : _azar = math.Random(semilla);

  ProblemaPorcentajeDe generar({int dificultad = 1}) {
    final pool = <(int, int)>[
      ..._paresFaciles,
      if (dificultad >= 2) ..._paresMedios,
    ];
    final (parte, total) = pool[_azar.nextInt(pool.length)];
    return _construir(parte, total);
  }

  ProblemaPorcentajeDe generarDesdeTerminos({
    required int parte,
    required int total,
  }) =>
      _construir(parte, total);

  ProblemaPorcentajeDe _construir(int parte, int total) {
    final correcto = (parte * 100) ~/ total;

    final propuestos = <int>[correcto];
    void anyadirSiNuevo(int v) {
      if (v <= 0 || v > 100) return;
      if (!propuestos.contains(v)) propuestos.add(v);
    }

    // 1. Complemento: si la mayoría confunde "el % que SÍ representa"
    //    con "el % que falta para 100", el complemento es trampa real.
    anyadirSiNuevo(100 - correcto);
    // 2. Numerador literal como porcentaje (sin dividir): "12 de 50"
    //    leído erróneamente como "12 %".
    anyadirSiNuevo(parte);
    // 3. Total leído como porcentaje (otra trampa de "ignorar el
    //    cálculo y elegir un número de la pantalla").
    anyadirSiNuevo(total);
    // 4. Mitad del correcto — error de saltarse un paso del cálculo.
    anyadirSiNuevo(correcto ~/ 2);
    // 5. Doble del correcto — error simétrico.
    anyadirSiNuevo(correcto * 2);

    var paso = 5;
    while (propuestos.length < 4) {
      anyadirSiNuevo(correcto + paso);
      if (propuestos.length < 4) anyadirSiNuevo(correcto - paso);
      paso += 5;
      if (paso > 50) break;
    }

    final cuatro = propuestos.take(4).toList()..shuffle(_azar);
    final indice = cuatro.indexOf(correcto);
    return ProblemaPorcentajeDe(
      parte: parte,
      total: total,
      candidatos: cuatro,
      indiceCorrecto: indice,
    );
  }
}
