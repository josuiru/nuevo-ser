import 'dart:math' as math;

import 'fragmento_en_tejado.dart' show OperadorAritmetico;
import 'problema_espejo.dart' show Fraccion;

/// Problema OP.03: el niño ve una operación binaria que mezcla un
/// decimal y una fracción ("0,5 + 1/4" o "1/2 × 0,4") y elige el
/// resultado decimal correcto entre cuatro candidatos. La trampa
/// estrella: leer el numerador como décimas (1/4 → 0,4 en vez de
/// 0,25). Refuerza la equivalencia decimal ↔ fracción que vio en
/// DEC.08, ahora dentro de una operación.
class ProblemaOperacionMixta {
  /// Si true, la expresión es "decimal op fraccion".
  /// Si false, es "fraccion op decimal".
  final bool decimalPrimero;
  final double valorDecimal;
  final Fraccion fraccion;
  final OperadorAritmetico operador;
  final List<double> candidatosDecimales;
  final int indiceCorrecto;

  const ProblemaOperacionMixta({
    required this.decimalPrimero,
    required this.valorDecimal,
    required this.fraccion,
    required this.operador,
    required this.candidatosDecimales,
    required this.indiceCorrecto,
  });

  double get resultado => candidatosDecimales[indiceCorrecto];

  bool esCorrecta(int indiceElegido) => indiceElegido == indiceCorrecto;
}

/// Caso curado: una expresión mixta con su resultado limpio (entero o
/// con una sola cifra decimal) y la "trampa numerador como décimas".
class _CasoMixto {
  final bool decimalPrimero;
  final double valorDecimal;
  final Fraccion fraccion;
  final OperadorAritmetico operador;
  final double resultado;

  /// Resultado erróneo si el niño lee el numerador como décimas:
  /// 1/4 → 0,4; 1/2 → 0,2; 3/4 → 0,4 (truncado por la décima); etc.
  final double numeradorComoDecimas;
  const _CasoMixto({
    required this.decimalPrimero,
    required this.valorDecimal,
    required this.fraccion,
    required this.operador,
    required this.resultado,
    required this.numeradorComoDecimas,
  });
}

const _casosCurados = <_CasoMixto>[
  // 0,5 + 1/4 → 0,75. Numerador como décima: 0,5+0,1 = 0,6.
  _CasoMixto(
    decimalPrimero: true,
    valorDecimal: 0.5,
    fraccion: Fraccion(1, 4),
    operador: OperadorAritmetico.suma,
    resultado: 0.75,
    numeradorComoDecimas: 0.6,
  ),
  // 1/2 × 0,4 → 0,2. Numerador como décima: 0,1 × 0,4 = 0,04.
  _CasoMixto(
    decimalPrimero: false,
    valorDecimal: 0.4,
    fraccion: Fraccion(1, 2),
    operador: OperadorAritmetico.producto,
    resultado: 0.2,
    numeradorComoDecimas: 0.04,
  ),
  // 0,8 − 1/2 → 0,3. Numerador como décima: 0,8 − 0,1 = 0,7.
  _CasoMixto(
    decimalPrimero: true,
    valorDecimal: 0.8,
    fraccion: Fraccion(1, 2),
    operador: OperadorAritmetico.resta,
    resultado: 0.3,
    numeradorComoDecimas: 0.7,
  ),
  // 3/4 + 0,2 → 0,95. Numerador como décima: 0,3 + 0,2 = 0,5.
  _CasoMixto(
    decimalPrimero: false,
    valorDecimal: 0.2,
    fraccion: Fraccion(3, 4),
    operador: OperadorAritmetico.suma,
    resultado: 0.95,
    numeradorComoDecimas: 0.5,
  ),
  // 0,6 − 1/4 → 0,35. Numerador como décima: 0,6 − 0,1 = 0,5.
  _CasoMixto(
    decimalPrimero: true,
    valorDecimal: 0.6,
    fraccion: Fraccion(1, 4),
    operador: OperadorAritmetico.resta,
    resultado: 0.35,
    numeradorComoDecimas: 0.5,
  ),
  // 1/4 × 0,8 → 0,2. Numerador como décima: 0,1 × 0,8 = 0,08.
  _CasoMixto(
    decimalPrimero: false,
    valorDecimal: 0.8,
    fraccion: Fraccion(1, 4),
    operador: OperadorAritmetico.producto,
    resultado: 0.2,
    numeradorComoDecimas: 0.08,
  ),
  // 0,9 − 3/4 → 0,15. Numerador como décima: 0,9 − 0,3 = 0,6.
  _CasoMixto(
    decimalPrimero: true,
    valorDecimal: 0.9,
    fraccion: Fraccion(3, 4),
    operador: OperadorAritmetico.resta,
    resultado: 0.15,
    numeradorComoDecimas: 0.6,
  ),
  // 2/5 + 0,3 → 0,7. Numerador como décima: 0,2 + 0,3 = 0,5.
  _CasoMixto(
    decimalPrimero: false,
    valorDecimal: 0.3,
    fraccion: Fraccion(2, 5),
    operador: OperadorAritmetico.suma,
    resultado: 0.7,
    numeradorComoDecimas: 0.5,
  ),
];

class GeneradorOperacionMixta {
  final math.Random _azar;

  GeneradorOperacionMixta({int? semilla}) : _azar = math.Random(semilla);

  /// Cantidad de casos curados — el generador del tejado elige un
  /// índice y luego el dispatcher reconstruye el mismo caso.
  static int get cantidadDeCasosCurados => _casosCurados.length;

  ProblemaOperacionMixta generar({int dificultad = 1}) {
    final caso = _casosCurados[_azar.nextInt(_casosCurados.length)];
    return _construir(caso);
  }

  ProblemaOperacionMixta generarPorIndice(int indice) {
    return _construir(
      _casosCurados[indice.clamp(0, _casosCurados.length - 1)],
    );
  }

  ProblemaOperacionMixta _construir(_CasoMixto caso) {
    final candidatosPropuestos = <double>[caso.resultado];
    bool yaEsta(double valor) =>
        candidatosPropuestos.any((c) => (c - valor).abs() < 1e-9);

    void anyadirSiNuevo(double valor) {
      if (valor < 0) return;
      if (!yaEsta(valor)) candidatosPropuestos.add(valor);
    }

    // 1. Trampa estrella: el numerador leído como décima.
    anyadirSiNuevo(caso.numeradorComoDecimas);
    // 2. El propio decimal de partida (sin operar).
    anyadirSiNuevo(caso.valorDecimal);
    // 3. Distractor numérico cercano — sumando el doble del numerador
    //    como décimas, errores típicos de signo o cifra.
    final fraccionComoDecimal =
        caso.fraccion.numerador / caso.fraccion.denominador;
    final inverso = caso.operador == OperadorAritmetico.suma
        ? caso.valorDecimal - fraccionComoDecimal
        : caso.operador == OperadorAritmetico.resta
            ? caso.valorDecimal + fraccionComoDecimal
            : caso.valorDecimal / (fraccionComoDecimal == 0
                ? 1
                : fraccionComoDecimal);
    anyadirSiNuevo(_redondearADosCifras(inverso));
    // 4. Cercano al correcto si aún hace falta.
    anyadirSiNuevo(_redondearADosCifras(caso.resultado + 0.1));
    anyadirSiNuevo(_redondearADosCifras(caso.resultado - 0.05));

    final cuatro = candidatosPropuestos.take(4).toList()..shuffle(_azar);
    final indice = cuatro.indexWhere(
      (c) => (c - caso.resultado).abs() < 1e-9,
    );
    return ProblemaOperacionMixta(
      decimalPrimero: caso.decimalPrimero,
      valorDecimal: caso.valorDecimal,
      fraccion: caso.fraccion,
      operador: caso.operador,
      candidatosDecimales: cuatro,
      indiceCorrecto: indice,
    );
  }

  double _redondearADosCifras(double valor) {
    final clamp = valor < 0 ? 0.0 : valor;
    return (clamp * 100).round() / 100;
  }
}

/// Formatea un decimal como cadena con coma y sin ceros sobrantes
/// ("0,5", "0,75", "0,04"). Útil para la pantalla y para tests.
String formatearDecimalEsAOrtografia(double valor) {
  if (valor == valor.truncateToDouble()) return valor.toInt().toString();
  final cadena = valor.toStringAsFixed(2);
  // Quitar el último 0 si es "0,X0"
  final sinCeroFinal =
      cadena.endsWith('0') ? cadena.substring(0, cadena.length - 1) : cadena;
  return sinCeroFinal.replaceAll('.', ',');
}
