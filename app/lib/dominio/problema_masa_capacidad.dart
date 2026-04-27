import 'dart:math' as math;

/// Familia de unidades del sistema métrico que MED.02 ejercita: masa
/// (kg, g…) o capacidad (L, mL…). Comparten la escalera ×10 — la
/// mecánica del puzzle es idéntica, solo cambian los símbolos.
enum FamiliaMetrica { masa, capacidad }

/// Unidades de masa que el MVP soporta (orden por escalón ×10).
enum UnidadMasa { kg, hg, dag, g, dg, cg, mg }

/// Unidades de capacidad que el MVP soporta (orden por escalón ×10).
enum UnidadCapacidad { kL, hL, daL, l, dl, cl, ml }

extension SimboloMasa on UnidadMasa {
  String get simbolo {
    switch (this) {
      case UnidadMasa.kg:
        return 'kg';
      case UnidadMasa.hg:
        return 'hg';
      case UnidadMasa.dag:
        return 'dag';
      case UnidadMasa.g:
        return 'g';
      case UnidadMasa.dg:
        return 'dg';
      case UnidadMasa.cg:
        return 'cg';
      case UnidadMasa.mg:
        return 'mg';
    }
  }

  int get posicion {
    return UnidadMasa.values.indexOf(this);
  }
}

extension SimboloCapacidad on UnidadCapacidad {
  String get simbolo {
    switch (this) {
      case UnidadCapacidad.kL:
        return 'kL';
      case UnidadCapacidad.hL:
        return 'hL';
      case UnidadCapacidad.daL:
        return 'daL';
      case UnidadCapacidad.l:
        return 'L';
      case UnidadCapacidad.dl:
        return 'dL';
      case UnidadCapacidad.cl:
        return 'cL';
      case UnidadCapacidad.ml:
        return 'mL';
    }
  }

  int get posicion {
    return UnidadCapacidad.values.indexOf(this);
  }
}

/// Devuelve la unidad cuyo símbolo coincide. Lanza [ArgumentError] si
/// no hay coincidencia para no enmascarar errores de empaquetado.
({FamiliaMetrica familia, int posicion}) unidadDesdeSimboloMetrica(
    String simbolo) {
  for (final unidad in UnidadMasa.values) {
    if (unidad.simbolo == simbolo) {
      return (familia: FamiliaMetrica.masa, posicion: unidad.posicion);
    }
  }
  for (final unidad in UnidadCapacidad.values) {
    if (unidad.simbolo == simbolo) {
      return (
        familia: FamiliaMetrica.capacidad,
        posicion: unidad.posicion,
      );
    }
  }
  throw ArgumentError('Símbolo métrico desconocido: $simbolo');
}

/// Símbolo dado familia y posición en la escalera (0..6).
String simboloMetricoEnPosicion(FamiliaMetrica familia, int posicion) {
  switch (familia) {
    case FamiliaMetrica.masa:
      return UnidadMasa.values[posicion].simbolo;
    case FamiliaMetrica.capacidad:
      return UnidadCapacidad.values[posicion].simbolo;
  }
}

/// Problema MED.02: el niño ve "3 kg = ? g" o "5 L = ? mL" y elige el
/// resultado entre cuatro candidatos. Mecánica idéntica a MED.01.
class ProblemaMasaCapacidad {
  final FamiliaMetrica familia;
  final int valorOrigen;
  final int posicionOrigen;
  final int posicionDestino;
  final List<int> candidatos;
  final int indiceCorrecto;

  const ProblemaMasaCapacidad({
    required this.familia,
    required this.valorOrigen,
    required this.posicionOrigen,
    required this.posicionDestino,
    required this.candidatos,
    required this.indiceCorrecto,
  });

  String get simboloOrigen =>
      simboloMetricoEnPosicion(familia, posicionOrigen);
  String get simboloDestino =>
      simboloMetricoEnPosicion(familia, posicionDestino);
  int get resultado => candidatos[indiceCorrecto];

  bool esCorrecta(int indiceElegido) => indiceElegido == indiceCorrecto;
}

/// Triplas curadas (valor, origenPos, destinoPos) para masa: kg↔g,
/// kg↔hg, g↔mg, dag↔g — las conversiones más comunes en primaria.
const _conversionesMasaFaciles =
    <(int, int, int)>[
  (3, 0, 3),    // 3 kg → 3000 g
  (5, 0, 1),    // 5 kg → 50 hg
  (4, 3, 6),    // 4 g → 4000 mg
  (2, 0, 3),    // 2 kg → 2000 g
  (1, 0, 3),    // 1 kg → 1000 g
  (6, 3, 6),    // 6 g → 6000 mg
  (8, 3, 4),    // 8 g → 80 dg
  (7, 2, 3),    // 7 dag → 70 g
];
const _conversionesMasaMedias = <(int, int, int)>[
  (250, 5, 4),    // 250 cg → 25 dg
  (300, 5, 3),    // 300 cg → 3 g
  (4000, 3, 0),   // 4000 g → 4 kg
  (250, 4, 3),    // 250 dg → 25 g
  (12, 3, 5),     // 12 g → 1200 cg
];

/// Mismo formato para capacidad: L↔mL, L↔dL, kL↔L.
const _conversionesCapacidadFaciles = <(int, int, int)>[
  (3, 0, 3),    // 3 kL → 3000 L
  (5, 3, 4),    // 5 L → 50 dL
  (4, 3, 6),    // 4 L → 4000 mL
  (2, 0, 3),    // 2 kL → 2000 L
  (1, 0, 3),    // 1 kL → 1000 L
  (6, 3, 6),    // 6 L → 6000 mL
  (8, 3, 5),    // 8 L → 800 cL
  (7, 0, 1),    // 7 kL → 70 hL
];
const _conversionesCapacidadMedias = <(int, int, int)>[
  (250, 5, 4),     // 250 cL → 25 dL
  (300, 5, 3),     // 300 cL → 3 L
  (4000, 3, 0),    // 4000 L → 4 kL
  (250, 4, 3),     // 250 dL → 25 L
  (12, 3, 5),      // 12 L → 1200 cL
];

class GeneradorMasaCapacidad {
  final math.Random _azar;

  GeneradorMasaCapacidad({int? semilla}) : _azar = math.Random(semilla);

  ProblemaMasaCapacidad generar({
    int dificultad = 1,
    FamiliaMetrica? familiaPreferida,
  }) {
    final familia = familiaPreferida ??
        (_azar.nextBool() ? FamiliaMetrica.masa : FamiliaMetrica.capacidad);
    final faciles = familia == FamiliaMetrica.masa
        ? _conversionesMasaFaciles
        : _conversionesCapacidadFaciles;
    final medias = familia == FamiliaMetrica.masa
        ? _conversionesMasaMedias
        : _conversionesCapacidadMedias;
    final pool = <(int, int, int)>[
      ...faciles,
      if (dificultad >= 2)
        ...medias.where((c) {
          final delta = c.$3 - c.$2;
          if (delta >= 0) return true;
          final divisor = math.pow(10, -delta).toInt();
          return c.$1 % divisor == 0;
        }),
    ];
    final (v, oPos, dPos) = pool[_azar.nextInt(pool.length)];
    return _construir(familia, v, oPos, dPos);
  }

  ProblemaMasaCapacidad generarDesdeTerminos({
    required FamiliaMetrica familia,
    required int valorOrigen,
    required int posicionOrigen,
    required int posicionDestino,
  }) =>
      _construir(familia, valorOrigen, posicionOrigen, posicionDestino);

  ProblemaMasaCapacidad _construir(
    FamiliaMetrica familia,
    int valor,
    int origenPos,
    int destinoPos,
  ) {
    final delta = destinoPos - origenPos;
    final factor = math.pow(10, delta.abs()).toInt();
    final correcto = delta >= 0 ? valor * factor : valor ~/ factor;

    final propuestos = <int>[correcto];
    void anyadirSiNuevo(int v) {
      if (v <= 0) return;
      if (!propuestos.contains(v)) propuestos.add(v);
    }

    if (delta.abs() >= 2) {
      final factorErr = math.pow(10, delta.abs() - 1).toInt();
      anyadirSiNuevo(delta >= 0 ? valor * factorErr : valor ~/ factorErr);
    }
    if (delta.abs() >= 1) {
      if (delta >= 0) {
        if (valor % factor == 0) {
          anyadirSiNuevo(valor ~/ factor);
        }
      } else {
        anyadirSiNuevo(valor * factor);
      }
    }
    anyadirSiNuevo(valor);
    if (delta.abs() >= 1) {
      final factorMas = math.pow(10, delta.abs() + 1).toInt();
      anyadirSiNuevo(delta >= 0 ? valor * factorMas : valor ~/ factorMas);
    }

    var paso = 1;
    while (propuestos.length < 4) {
      anyadirSiNuevo(correcto + paso);
      if (propuestos.length < 4) anyadirSiNuevo(correcto - paso);
      paso++;
      if (paso > 6) break;
    }

    final cuatro = propuestos.take(4).toList()..shuffle(_azar);
    final indice = cuatro.indexOf(correcto);
    return ProblemaMasaCapacidad(
      familia: familia,
      valorOrigen: valor,
      posicionOrigen: origenPos,
      posicionDestino: destinoPos,
      candidatos: cuatro,
      indiceCorrecto: indice,
    );
  }
}
