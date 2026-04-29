import 'dart:math' as math;

/// Operación que aplica el porcentaje sobre la base.
enum TipoVariacionPorcentual { aumento, descuento }

extension SignoVariacion on TipoVariacionPorcentual {
  String get verbo {
    switch (this) {
      case TipoVariacionPorcentual.aumento:
        return 'aumenta un';
      case TipoVariacionPorcentual.descuento:
        return 'descuenta un';
    }
  }
}

/// Problema PROP.06: el niño ve "Aumenta un 15% sobre 200" o
/// "Descuenta un 20% sobre 80" y elige el resultado entre cuatro
/// candidatos. Mecánica: cantidad ± (porcentaje/100) × cantidad.
class ProblemaAumentoDescuento {
  final TipoVariacionPorcentual tipo;
  final int porcentaje;
  final int cantidad;
  final List<int> candidatos;
  final int indiceCorrecto;

  const ProblemaAumentoDescuento({
    required this.tipo,
    required this.porcentaje,
    required this.cantidad,
    required this.candidatos,
    required this.indiceCorrecto,
  });

  int get resultado => candidatos[indiceCorrecto];

  bool esCorrecta(int indiceElegido) => indiceElegido == indiceCorrecto;
}

/// Triplas (porcentaje, cantidad) curadas para que el cálculo dé
/// entero — porcentaje × cantidad debe ser múltiplo de 100.
const _paresFaciles = <(int, int)>[
  (10, 80),     // 10% de 80 = 8
  (20, 80),     // 20% de 80 = 16
  (25, 40),     // 25% de 40 = 10
  (50, 60),     // 50% de 60 = 30
  (10, 200),    // 10% de 200 = 20
  (15, 200),    // 15% de 200 = 30
  (25, 80),     // 25% de 80 = 20
  (30, 50),     // 30% de 50 = 15
  (75, 40),     // 75% de 40 = 30
  (10, 150),    // 10% de 150 = 15
];
const _paresMedios = <(int, int)>[
  (12, 50),     // 12% de 50 = 6
  (35, 60),     // 35% de 60 = 21
  (40, 75),     // 40% de 75 = 30
  (45, 80),     // 45% de 80 = 36
];

class GeneradorAumentoDescuento {
  final math.Random _azar;

  GeneradorAumentoDescuento({int? semilla}) : _azar = math.Random(semilla);

  ProblemaAumentoDescuento generar({int dificultad = 1}) {
    final pool = <(int, int)>[
      ..._paresFaciles,
      if (dificultad >= 2) ..._paresMedios,
    ];
    final (porcentaje, cantidad) = pool[_azar.nextInt(pool.length)];
    final tipo = _azar.nextBool()
        ? TipoVariacionPorcentual.aumento
        : TipoVariacionPorcentual.descuento;
    return _construir(tipo, porcentaje, cantidad);
  }

  ProblemaAumentoDescuento generarDesdeTerminos({
    required TipoVariacionPorcentual tipo,
    required int porcentaje,
    required int cantidad,
  }) =>
      _construir(tipo, porcentaje, cantidad);

  ProblemaAumentoDescuento _construir(
    TipoVariacionPorcentual tipo,
    int porcentaje,
    int cantidad,
  ) {
    final variacion = (porcentaje * cantidad) ~/ 100;
    final correcto = tipo == TipoVariacionPorcentual.aumento
        ? cantidad + variacion
        : cantidad - variacion;

    final propuestos = <int>[correcto];
    void anyadirSiNuevo(int v) {
      if (v <= 0) return;
      if (!propuestos.contains(v)) propuestos.add(v);
    }

    // 1. Resultado de la operación inversa (descuento por aumento o
    //    viceversa): error muy frecuente.
    final inverso = tipo == TipoVariacionPorcentual.aumento
        ? cantidad - variacion
        : cantidad + variacion;
    anyadirSiNuevo(inverso);
    // 2. Solo la variación, sin sumar ni restar (la cantidad
    //    "aumentada" o "descontada" en absoluto).
    anyadirSiNuevo(variacion);
    // 3. La cantidad original sin cambio.
    anyadirSiNuevo(cantidad);
    // 4. Restar/sumar el porcentaje literal (cantidad ± porcentaje):
    //    "20% de descuento sobre 80 → 60" en lugar de 64.
    final literal = tipo == TipoVariacionPorcentual.aumento
        ? cantidad + porcentaje
        : cantidad - porcentaje;
    anyadirSiNuevo(literal);

    var paso = 5;
    while (propuestos.length < 4) {
      anyadirSiNuevo(correcto + paso);
      if (propuestos.length < 4) anyadirSiNuevo(correcto - paso);
      paso += 5;
      if (paso > 50) break;
    }

    final cuatro = propuestos.take(4).toList()..shuffle(_azar);
    final indice = cuatro.indexOf(correcto);
    return ProblemaAumentoDescuento(
      tipo: tipo,
      porcentaje: porcentaje,
      cantidad: cantidad,
      candidatos: cuatro,
      indiceCorrecto: indice,
    );
  }
}
