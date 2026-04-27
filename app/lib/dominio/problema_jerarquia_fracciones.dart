import 'dart:math' as math;

import 'fragmento_en_tejado.dart' show OperadorAritmetico;
import 'problema_espejo.dart' show Fraccion;

/// Problema OP.02: el niño ve una expresión de tres fracciones con
/// dos operadores ("1/2 + 1/4 × 2/3") y elige el resultado correcto
/// entre cuatro candidatos. La trampa estrella: calcular izquierda-a-
/// derecha sin respetar la prioridad de × y ÷.
class ProblemaJerarquiaFracciones {
  final Fraccion a;
  final OperadorAritmetico op1;
  final Fraccion b;
  final OperadorAritmetico op2;
  final Fraccion c;
  final List<Fraccion> candidatos;
  final int indiceCorrecto;

  const ProblemaJerarquiaFracciones({
    required this.a,
    required this.op1,
    required this.b,
    required this.op2,
    required this.c,
    required this.candidatos,
    required this.indiceCorrecto,
  });

  Fraccion get resultado => candidatos[indiceCorrecto];

  bool esCorrecta(int indiceElegido) => indiceElegido == indiceCorrecto;
}

/// Una tripla curada de la forma "a op1 b op2 c" con su resultado
/// correcto (respetando prioridad) y el de izquierda-a-derecha (la
/// trampa). Si ambos coinciden, no es un caso útil para OP.02.
class _CasoJerarquia {
  final Fraccion a;
  final OperadorAritmetico op1;
  final Fraccion b;
  final OperadorAritmetico op2;
  final Fraccion c;
  final Fraccion correcto;
  final Fraccion izquierdaDerecha;
  const _CasoJerarquia({
    required this.a,
    required this.op1,
    required this.b,
    required this.op2,
    required this.c,
    required this.correcto,
    required this.izquierdaDerecha,
  });
}

const _casosCurados = <_CasoJerarquia>[
  // 1/2 + 1/4 × 2 → con prio: 1/2 + 1/2 = 1; sin prio: (3/4) × 2 = 3/2.
  _CasoJerarquia(
    a: Fraccion(1, 2),
    op1: OperadorAritmetico.suma,
    b: Fraccion(1, 4),
    op2: OperadorAritmetico.producto,
    c: Fraccion(2, 1),
    correcto: Fraccion(1, 1),
    izquierdaDerecha: Fraccion(3, 2),
  ),
  // 1/2 + 2/3 × 1/4 → con prio: 1/2 + 2/12 = 6/12 + 2/12 = 8/12 = 2/3.
  // l-r: (1/2 + 2/3) = 7/6; 7/6 × 1/4 = 7/24.
  _CasoJerarquia(
    a: Fraccion(1, 2),
    op1: OperadorAritmetico.suma,
    b: Fraccion(2, 3),
    op2: OperadorAritmetico.producto,
    c: Fraccion(1, 4),
    correcto: Fraccion(2, 3),
    izquierdaDerecha: Fraccion(7, 24),
  ),
  // 5/6 − 1/2 × 1/3 → 5/6 − 1/6 = 4/6 = 2/3; l-r: (5/6−1/2)=1/3; ×1/3=1/9.
  _CasoJerarquia(
    a: Fraccion(5, 6),
    op1: OperadorAritmetico.resta,
    b: Fraccion(1, 2),
    op2: OperadorAritmetico.producto,
    c: Fraccion(1, 3),
    correcto: Fraccion(2, 3),
    izquierdaDerecha: Fraccion(1, 9),
  ),
  // 1/3 + 1/6 × 3 → 1/3 + 1/2 = 5/6; l-r: 1/2 × 3 = 3/2.
  _CasoJerarquia(
    a: Fraccion(1, 3),
    op1: OperadorAritmetico.suma,
    b: Fraccion(1, 6),
    op2: OperadorAritmetico.producto,
    c: Fraccion(3, 1),
    correcto: Fraccion(5, 6),
    izquierdaDerecha: Fraccion(3, 2),
  ),
  // 3/4 × 2 + 1/2 → con prio: 3/2 + 1/2 = 2; l-r idéntico (× ya iba primero).
  // [descartado: l-r y prio coinciden]
  // 1/2 × 4 − 1/3 → 2 − 1/3 = 5/3; l-r idéntico. [descartado]
  // 2/3 + 1/2 × 2 → 2/3 + 1 = 5/3; l-r: (7/6)×2 = 7/3.
  _CasoJerarquia(
    a: Fraccion(2, 3),
    op1: OperadorAritmetico.suma,
    b: Fraccion(1, 2),
    op2: OperadorAritmetico.producto,
    c: Fraccion(2, 1),
    correcto: Fraccion(5, 3),
    izquierdaDerecha: Fraccion(7, 3),
  ),
];

class GeneradorJerarquiaFracciones {
  final math.Random _azar;

  GeneradorJerarquiaFracciones({int? semilla})
      : _azar = math.Random(semilla);

  /// Cantidad de casos curados — útil para que el generador del tejado
  /// elija un índice y luego el dispatcher reconstruya el mismo caso.
  static int get cantidadDeCasosCurados => _casosCurados.length;

  ProblemaJerarquiaFracciones generar({int dificultad = 1}) {
    final caso = _casosCurados[_azar.nextInt(_casosCurados.length)];
    return _construir(caso);
  }

  ProblemaJerarquiaFracciones generarPorIndice(int indice) {
    return _construir(
        _casosCurados[indice.clamp(0, _casosCurados.length - 1)]);
  }

  ProblemaJerarquiaFracciones _construir(_CasoJerarquia caso) {
    final propuestos = <Fraccion>[caso.correcto];
    bool yaEsta(Fraccion f) =>
        propuestos.any((p) =>
            p.numerador == f.numerador &&
            p.denominador == f.denominador);
    void anyadirSiNuevo(Fraccion f) {
      if (f.numerador <= 0 || f.denominador <= 0) return;
      if (!yaEsta(f)) propuestos.add(f);
    }

    // 1. La trampa estrella: izquierda-a-derecha.
    anyadirSiNuevo(caso.izquierdaDerecha);
    // 2. Algún número claramente dentro de la expresión, sin operar:
    //    el primer operando o el último, según convenga.
    anyadirSiNuevo(caso.a);
    anyadirSiNuevo(caso.c);
    // 3. Algún cercano al correcto si aún hace falta.
    anyadirSiNuevo(Fraccion(
      caso.correcto.numerador + 1,
      caso.correcto.denominador,
    ));
    anyadirSiNuevo(Fraccion(
      caso.correcto.numerador,
      caso.correcto.denominador + 1,
    ));

    final cuatro = propuestos.take(4).toList()..shuffle(_azar);
    final indice = cuatro.indexWhere(
      (f) =>
          f.numerador == caso.correcto.numerador &&
          f.denominador == caso.correcto.denominador,
    );
    return ProblemaJerarquiaFracciones(
      a: caso.a,
      op1: caso.op1,
      b: caso.b,
      op2: caso.op2,
      c: caso.c,
      candidatos: cuatro,
      indiceCorrecto: indice,
    );
  }
}
