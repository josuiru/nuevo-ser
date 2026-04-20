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
enum TipoFragmentoEnTejado {
  unitario,
  espejo,
  decimal,
  porcentaje,
  impropio,
  proporcional,
  dual,
  operacionDecimal,
}

/// Operador aritmético usado por los Fragmentos Duales y los de
/// operación con decimales.
enum OperadorAritmetico { suma, resta, producto, division }

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
