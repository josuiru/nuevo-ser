import 'package:flutter/foundation.dart';

/// Tipo de puzzle que plantea este Fragmento al ser tocado.
///
/// - [unitario]: combate de cortes (Familia B y C). El niño corta en
///   partes iguales tantas veces como indique numerador/denominador.
/// - [espejo]: puzzle de equivalencia (Familia D). Se muestra la
///   fracción del Fragmento y el niño elige su equivalente entre
///   varios candidatos.
/// - [decimal]: puzzle de conversión (Familia G). El Fragmento se
///   etiqueta con un decimal (0,25) y el niño elige la fracción
///   equivalente entre cuatro candidatos.
/// - [porcentaje]: puzzle de conversión (Familia H). El Fragmento se
///   etiqueta con un porcentaje (25%) y el niño elige la fracción
///   equivalente.
/// - [comparacion]: puzzle de comparación (Familia B/C, FR.05/FR.06).
///   Se muestran dos fracciones — con el mismo denominador o con el
///   mismo numerador — y el niño toca la mayor.
/// - [simplificar]: puzzle FR.10. Se muestra una fracción reducible
///   (p. ej. 6/8) y el niño elige su forma mínima entre cuatro
///   candidatos. A diferencia de [espejo], el ganador es único.
/// - [amplificar]: puzzle FR.11. Se presenta la ecuación
///   "3/4 = ?/12" y el niño elige el numerador que la completa.
///   Mecánica de "rellenar el hueco".
/// - [divisibilidad]: puzzle DIV.03/DIV.04. Se muestra un número y un
///   divisor; el niño decide sí/no. Primera mecánica binaria.
/// - [comparacionDecimal]: puzzle DEC.02. Dos decimales lado a lado,
///   tocar el mayor. Sesgado a casos donde el más largo no es el mayor.
/// - [lecturaDecimal]: puzzle DEC.01. Se muestra un decimal en
///   palabras ("veinticinco centésimas") y el niño elige su etiqueta
///   numérica entre cuatro candidatos.
/// - [multiplos]: puzzle DIV.01. Variante de divisibilidad con
///   fraseado inverso: "¿N es múltiplo de M?".
/// - [comparacionUnidad]: puzzle FR.04. Una fracción y tres botones
///   (<1, =1, >1). Primera mecánica de tres opciones en Uno Roto.
/// - [lecturaFraccion]: puzzle FR.02. Texto en castellano
///   ("tres quintos") + cuatro fracciones candidatas. Simétrico a
///   [lecturaDecimal] pero con trampas propias del idioma de fracciones.
/// - [mixtoAImpropio]: puzzle FR.13. Número mixto ("2 y 3/4") y
///   cuatro fracciones impropias candidatas. Inverso de [impropio].
enum TipoFragmentoEnTejado {
  unitario,
  espejo,
  decimal,
  porcentaje,
  impropio,
  proporcional,
  dual,
  operacionDecimal,
  comparacion,
  simplificar,
  amplificar,
  divisibilidad,
  comparacionDecimal,
  lecturaDecimal,
  multiplos,
  comparacionUnidad,
  lecturaFraccion,
  mixtoAImpropio,
}

/// Operador aritmético usado por los Fragmentos Duales y los de
/// operación con decimales.
enum OperadorAritmetico { suma, resta, producto, division }

/// Modo de un puzzle de comparación. Determina qué se fija entre las
/// dos fracciones y qué tiene que mirar el niño.
enum ModoComparacion {
  /// FR.05 — misma base (3/8 vs 5/8): gana el numerador mayor.
  mismoDenominador,

  /// FR.06 — mismo numerador (3/5 vs 3/8): gana el denominador menor.
  /// Contraintuitivo: más importante.
  mismoNumerador,
}

extension SimboloOperador on OperadorAritmetico {
  String get simbolo {
    switch (this) {
      case OperadorAritmetico.suma:
        return '+';
      case OperadorAritmetico.resta:
        return '−';
      case OperadorAritmetico.producto:
        return '×';
      case OperadorAritmetico.division:
        return '÷';
    }
  }
}

/// Un Fragmento concreto flotando en el tejado a la espera de ser
/// cazado. Se distingue de [FragmentoUnitario] en que carga datos de
/// **presencia en el mundo**: posición en pantalla, cuándo apareció
/// y cuándo se escapará si nadie lo engancha.
@immutable
class FragmentoEnTejado {
  final String identificador;
  final int numerador;
  final int denominador;
  final TipoFragmentoEnTejado tipo;

  /// Segunda fracción — solo se usa en Fragmentos Duales (Familia F)
  /// donde el puzzle es una operación aritmética sobre a/b y c/d.
  /// Null en cualquier otro tipo.
  final int? numeradorB;
  final int? denominadorB;

  /// Operador que une la primera y segunda fracción en un Dual, o los
  /// dos decimales en un Fragmento de operación decimal. Null en
  /// Fragmentos que no tienen operación binaria explícita.
  final OperadorAritmetico? operador;

  /// Operandos decimales para [TipoFragmentoEnTejado.operacionDecimal].
  /// Se guardan como texto ya formateado ("0,5", "1,25") para mostrar
  /// tal cual en la pantalla, y como valor numérico para la evaluación.
  final String? decimalA;
  final String? decimalB;

  /// Modo de comparación en Fragmentos de tipo
  /// [TipoFragmentoEnTejado.comparacion]. Null para el resto.
  final ModoComparacion? modoComparacion;

  /// Etiqueta alternativa para Fragmentos decimales. Si está presente
  /// se muestra en el tejado en lugar de numerador/denominador.
  final String? etiquetaDecimal;

  /// Coordenadas normalizadas (0-1) sobre el área de caza. El pintor
  /// las multiplica por el tamaño del lienzo al dibujar.
  final double xNormalizado;
  final double yNormalizado;

  /// Momento de aparición en el tejado.
  final DateTime instanteAparicion;

  /// Cuánto tiempo permanece antes de empezar a escapar si nadie lo
  /// engancha. Varía por Fragmento para que no todos se sientan
  /// igual de urgentes.
  final Duration tiempoDeVida;

  const FragmentoEnTejado({
    required this.identificador,
    required this.numerador,
    required this.denominador,
    required this.xNormalizado,
    required this.yNormalizado,
    required this.instanteAparicion,
    required this.tiempoDeVida,
    this.tipo = TipoFragmentoEnTejado.unitario,
    this.etiquetaDecimal,
    this.numeradorB,
    this.denominadorB,
    this.operador,
    this.decimalA,
    this.decimalB,
    this.modoComparacion,
  });

  bool get esCompuesto => numerador > 1;

  String get etiqueta => etiquetaDecimal ?? '$numerador/$denominador';

  /// Fracción de vida consumida en este instante [ahora].
  /// 0.0 = acaba de aparecer, 1.0 = se le agotó el tiempo.
  double fraccionVidaConsumida(DateTime ahora) {
    final transcurrido = ahora.difference(instanteAparicion).inMilliseconds;
    if (transcurrido <= 0) return 0;
    final total = tiempoDeVida.inMilliseconds;
    if (total <= 0) return 1;
    return (transcurrido / total).clamp(0.0, 1.0);
  }

  bool seEstaEscapando(DateTime ahora) =>
      fraccionVidaConsumida(ahora) >= 0.75;

  bool seHaEscapado(DateTime ahora) => fraccionVidaConsumida(ahora) >= 1.0;
}
