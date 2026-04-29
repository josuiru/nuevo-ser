import 'dart:math' as math;

/// Unidades de superficie del MVP. Comparten orden con las lineales
/// pero el factor entre peldaños es 100 (no 10), lo que define la
/// trampa pedagógica de MED.05.
enum UnidadSuperficie { km2, hm2, dam2, m2, dm2, cm2, mm2 }

extension SimboloSuperficie on UnidadSuperficie {
  String get simbolo {
    switch (this) {
      case UnidadSuperficie.km2:
        return 'km²';
      case UnidadSuperficie.hm2:
        return 'hm²';
      case UnidadSuperficie.dam2:
        return 'dam²';
      case UnidadSuperficie.m2:
        return 'm²';
      case UnidadSuperficie.dm2:
        return 'dm²';
      case UnidadSuperficie.cm2:
        return 'cm²';
      case UnidadSuperficie.mm2:
        return 'mm²';
    }
  }

  int get posicion => UnidadSuperficie.values.indexOf(this);
}

UnidadSuperficie unidadSuperficieDesdeSimbolo(String simbolo) {
  for (final unidad in UnidadSuperficie.values) {
    if (unidad.simbolo == simbolo) return unidad;
  }
  throw ArgumentError('Símbolo de superficie desconocido: $simbolo');
}

/// Problema MED.05: el niño ve "5 m² = ? cm²" y elige el resultado
/// entre cuatro candidatos. Mecánica: el sistema de áreas multiplica
/// por 100 (no 10) por peldaño — es justo el error sistemático que la
/// habilidad pretende corregir.
class ProblemaSuperficie {
  final int valorOrigen;
  final UnidadSuperficie unidadOrigen;
  final UnidadSuperficie unidadDestino;
  final List<int> candidatos;
  final int indiceCorrecto;

  const ProblemaSuperficie({
    required this.valorOrigen,
    required this.unidadOrigen,
    required this.unidadDestino,
    required this.candidatos,
    required this.indiceCorrecto,
  });

  int get resultado => candidatos[indiceCorrecto];

  bool esCorrecta(int indiceElegido) => indiceElegido == indiceCorrecto;
}

/// Triplas curadas para que el resultado sea entero. Conversiones
/// más comunes en primaria: m²↔dm², dm²↔cm², m²↔cm², dam²↔m².
const _conversionesFaciles =
    <(int, UnidadSuperficie, UnidadSuperficie)>[
  (3, UnidadSuperficie.m2, UnidadSuperficie.dm2),     // 300
  (2, UnidadSuperficie.m2, UnidadSuperficie.cm2),     // 20000
  (5, UnidadSuperficie.dm2, UnidadSuperficie.cm2),    // 500
  (4, UnidadSuperficie.dam2, UnidadSuperficie.m2),    // 400
  (1, UnidadSuperficie.m2, UnidadSuperficie.dm2),     // 100
  (6, UnidadSuperficie.dm2, UnidadSuperficie.cm2),    // 600
  (7, UnidadSuperficie.dam2, UnidadSuperficie.m2),    // 700
];
const _conversionesMedias = <(int, UnidadSuperficie, UnidadSuperficie)>[
  (300, UnidadSuperficie.dm2, UnidadSuperficie.m2),    // 3
  (40000, UnidadSuperficie.cm2, UnidadSuperficie.m2),  // 4
  (500, UnidadSuperficie.cm2, UnidadSuperficie.dm2),   // 5
  (200, UnidadSuperficie.m2, UnidadSuperficie.dam2),   // 2
];

class GeneradorSuperficie {
  final math.Random _azar;

  GeneradorSuperficie({int? semilla}) : _azar = math.Random(semilla);

  ProblemaSuperficie generar({int dificultad = 1}) {
    final pool = <(int, UnidadSuperficie, UnidadSuperficie)>[
      ..._conversionesFaciles,
      if (dificultad >= 2) ..._conversionesMedias,
    ];
    final (v, o, d) = pool[_azar.nextInt(pool.length)];
    return _construir(v, o, d);
  }

  ProblemaSuperficie generarDesdeTerminos({
    required int valorOrigen,
    required UnidadSuperficie unidadOrigen,
    required UnidadSuperficie unidadDestino,
  }) =>
      _construir(valorOrigen, unidadOrigen, unidadDestino);

  ProblemaSuperficie _construir(
    int valor,
    UnidadSuperficie origen,
    UnidadSuperficie destino,
  ) {
    final delta = destino.posicion - origen.posicion;
    final factor = math.pow(100, delta.abs()).toInt();
    final correcto = delta >= 0 ? valor * factor : valor ~/ factor;

    final propuestos = <int>[correcto];
    void anyadirSiNuevo(int v) {
      if (v <= 0) return;
      if (!propuestos.contains(v)) propuestos.add(v);
    }

    // 1. Trampa estrella: factor lineal (×10 por peldaño en lugar de
    //    ×100). Es exactamente el error que MED.05 corrige.
    final factorLineal = math.pow(10, delta.abs()).toInt();
    anyadirSiNuevo(
        delta >= 0 ? valor * factorLineal : valor ~/ factorLineal);
    // 2. Dirección invertida (multiplicar cuando había que dividir).
    if (delta >= 0) {
      if (valor % factor == 0) {
        anyadirSiNuevo(valor ~/ factor);
      }
    } else {
      anyadirSiNuevo(valor * factor);
    }
    // 3. Valor original sin convertir.
    anyadirSiNuevo(valor);

    var paso = 1;
    while (propuestos.length < 4) {
      anyadirSiNuevo(correcto + paso);
      if (propuestos.length < 4) anyadirSiNuevo(correcto - paso);
      paso++;
      if (paso > 6) break;
    }

    final cuatro = propuestos.take(4).toList()..shuffle(_azar);
    final indice = cuatro.indexOf(correcto);
    return ProblemaSuperficie(
      valorOrigen: valor,
      unidadOrigen: origen,
      unidadDestino: destino,
      candidatos: cuatro,
      indiceCorrecto: indice,
    );
  }
}
