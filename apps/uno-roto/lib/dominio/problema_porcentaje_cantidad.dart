import 'dart:math' as math;

/// Problema PROP.03: el niño ve "el 25 % de 80 = ?" y elige el
/// resultado entre cuatro candidatos. La mecánica es de cálculo
/// directo; las trampas son los errores típicos al operar con
/// porcentaje y cantidad por primera vez.
class ProblemaPorcentajeCantidad {
  final int porcentaje;
  final int cantidad;
  final List<int> candidatos;
  final int indiceCorrecto;

  const ProblemaPorcentajeCantidad({
    required this.porcentaje,
    required this.cantidad,
    required this.candidatos,
    required this.indiceCorrecto,
  });

  int get resultado => candidatos[indiceCorrecto];

  bool esCorrecta(int indiceElegido) => indiceElegido == indiceCorrecto;
}

/// Pares (porcentaje, cantidad) con resultado entero garantizado.
/// Ordenados por dificultad creciente: primero los % más amigables,
/// después aparecen 30 %, 60 %, 80 %, etc. Las cantidades se eligen
/// para que el resultado siempre sea limpio (sin decimales).
const _paresFaciles = <(int, int)>[
  (50, 20), (50, 40), (50, 60), (50, 80), (50, 100),
  (25, 20), (25, 40), (25, 80), (25, 100),
  (10, 20), (10, 40), (10, 50), (10, 80), (10, 100), (10, 200),
];
const _paresMedios = <(int, int)>[
  (75, 20), (75, 40), (75, 80), (75, 100),
  (20, 50), (20, 100), (20, 150),
  (30, 50), (30, 100),
  (40, 50), (40, 100),
];
const _paresDificiles = <(int, int)>[
  (60, 50), (60, 100),
  (80, 50), (80, 100),
  (15, 100), (15, 200),
  (35, 100), (35, 200),
];

/// Genera problemas PROP.03 con distractores que reflejan los errores
/// reales: dejar el % literal, multiplicar sin dividir entre 100,
/// restar % de la cantidad, dividir cantidad entre el % en lugar
/// del cálculo correcto.
class GeneradorPorcentajeCantidad {
  final math.Random _azar;

  GeneradorPorcentajeCantidad({int? semilla})
      : _azar = math.Random(semilla);

  ProblemaPorcentajeCantidad generar({int dificultad = 1}) {
    final pool = <(int, int)>[
      ..._paresFaciles,
      if (dificultad >= 2) ..._paresMedios,
      if (dificultad >= 3) ..._paresDificiles,
    ];
    final (porcentaje, cantidad) = pool[_azar.nextInt(pool.length)];
    return _construirDesdePar(porcentaje, cantidad);
  }

  /// Reproduce el problema concreto con el par dado — para reabrir un
  /// Fragmento ya mostrado en el tejado con consistencia.
  ProblemaPorcentajeCantidad generarDesdePar(int porcentaje, int cantidad) =>
      _construirDesdePar(porcentaje, cantidad);

  ProblemaPorcentajeCantidad _construirDesdePar(int porcentaje, int cantidad) {
    final correcto = porcentaje * cantidad ~/ 100;

    final propuestos = <int>[correcto];
    void anyadirSiNuevo(int valor) {
      if (valor > 0 && !propuestos.contains(valor)) {
        propuestos.add(valor);
      }
    }

    // Trampas pedagógicas en orden de prioridad.
    // 1. El % literal (25 % de 80 → 25): ignora la cantidad.
    anyadirSiNuevo(porcentaje);
    // 2. Multiplicar sin dividir entre 100 (% × cantidad).
    anyadirSiNuevo(porcentaje * cantidad);
    // 3. Cantidad menos el correcto (cuando el niño confunde "el X %
    //    de" con "X menos del total" — error de proceso).
    anyadirSiNuevo(cantidad - correcto);
    // 4. Cantidad dividida por porcentaje, redondeada hacia abajo.
    if (porcentaje != 0) anyadirSiNuevo(cantidad ~/ porcentaje);

    // Si tras las trampas no llegamos a 4 candidatos, completamos con
    // vecinos del correcto a una distancia razonable.
    var paso = 1;
    while (propuestos.length < 4) {
      anyadirSiNuevo(correcto + paso * (correcto >= 10 ? 5 : 1));
      if (propuestos.length < 4) {
        anyadirSiNuevo(correcto - paso * (correcto >= 10 ? 5 : 1));
      }
      paso++;
      if (paso > 10) break;
    }

    final cuatro = propuestos.take(4).toList()..shuffle(_azar);
    final indice = cuatro.indexOf(correcto);
    return ProblemaPorcentajeCantidad(
      porcentaje: porcentaje,
      cantidad: cantidad,
      candidatos: cuatro,
      indiceCorrecto: indice,
    );
  }
}
