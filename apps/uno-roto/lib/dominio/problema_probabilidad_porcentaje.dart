import 'dart:math' as math;

import 'problema_espejo.dart' show Fraccion;

/// Problema EST.06: el niño ve "P = 3/4 → como % = ?" y elige el
/// resultado entre cuatro candidatos. Reformula EST.05 → DEC.08 →
/// PROP.04 con sentido probabilístico.
class ProblemaProbabilidadPorcentaje {
  final Fraccion probabilidad;
  final List<int> candidatosPorcentaje;
  final int indiceCorrecto;

  const ProblemaProbabilidadPorcentaje({
    required this.probabilidad,
    required this.candidatosPorcentaje,
    required this.indiceCorrecto,
  });

  int get respuesta => candidatosPorcentaje[indiceCorrecto];

  bool esCorrecta(int indiceElegido) => indiceElegido == indiceCorrecto;
}

/// Fracciones curadas con porcentaje exacto y entero.
const _fraccionesCuradas = <Fraccion>[
  Fraccion(1, 2),    // 50
  Fraccion(1, 4),    // 25
  Fraccion(3, 4),    // 75
  Fraccion(1, 5),    // 20
  Fraccion(2, 5),    // 40
  Fraccion(3, 5),    // 60
  Fraccion(4, 5),    // 80
  Fraccion(1, 10),   // 10
  Fraccion(3, 10),   // 30
  Fraccion(7, 10),   // 70
  Fraccion(9, 10),   // 90
];

class GeneradorProbabilidadPorcentaje {
  final math.Random _azar;

  GeneradorProbabilidadPorcentaje({int? semilla})
      : _azar = math.Random(semilla);

  static int get cantidadCurada => _fraccionesCuradas.length;

  ProblemaProbabilidadPorcentaje generar({int dificultad = 1}) {
    return _construir(
        _fraccionesCuradas[_azar.nextInt(_fraccionesCuradas.length)]);
  }

  ProblemaProbabilidadPorcentaje generarPorIndice(int indice) {
    return _construir(_fraccionesCuradas[
        indice.clamp(0, _fraccionesCuradas.length - 1)]);
  }

  ProblemaProbabilidadPorcentaje _construir(Fraccion f) {
    final correcto = (f.numerador * 100) ~/ f.denominador;

    final propuestos = <int>[correcto];
    void anyadirSiNuevo(int v) {
      if (v <= 0 || v > 100) return;
      if (!propuestos.contains(v)) propuestos.add(v);
    }

    // 1. Complementario (100 - correcto): trampa muy frecuente.
    anyadirSiNuevo(100 - correcto);
    // 2. El numerador literal como porcentaje (3 → 3% en lugar de 75%).
    anyadirSiNuevo(f.numerador);
    // 3. El denominador literal como porcentaje.
    anyadirSiNuevo(f.denominador);
    // 4. Mitad y doble del correcto.
    anyadirSiNuevo(correcto ~/ 2);
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
    return ProblemaProbabilidadPorcentaje(
      probabilidad: f,
      candidatosPorcentaje: cuatro,
      indiceCorrecto: indice,
    );
  }
}
