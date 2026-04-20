import 'dart:math' as math;

/// Fragmento unitario de la Familia B: valor 1/denominador.
///
/// El jugador debe cortarlo en exactamente [denominador] sectores iguales
/// que pasen todos por el centro, con una tolerancia angular configurable.
class FragmentoUnitario {
  final int denominador;

  const FragmentoUnitario(this.denominador)
      : assert(denominador >= 2 && denominador <= 12);

  double get valor => 1.0 / denominador;

  String get etiqueta => '1/$denominador';

  double get anguloEsperadoEntreCortes => (2 * math.pi) / denominador;

  /// Número de trazos que el jugador debe realizar.
  ///
  /// Para denominadores pares hasta 4, basta con n/2 líneas diametrales.
  /// Para el MVP del prototipo exigimos exactamente los trazos mínimos:
  /// - 1/2 → 1 trazo diametral.
  /// - 1/3 → 3 radios desde el centro (no hay línea recta que divida en tres).
  /// - 1/4 → 2 trazos diametrales perpendiculares.
  /// - 1/5 → 5 radios desde el centro.
  ///
  /// Modelamos todo como "radios desde el centro" por uniformidad: cada
  /// trazo es una línea que sale del centro hacia el borde.
  int get radiosRequeridos => denominador;
}

/// Un radio trazado por el jugador, descrito por su ángulo en radianes.
///
/// El ángulo sigue la convención matemática: 0 apunta a la derecha,
/// crece en sentido antihorario.
class RadioTrazado {
  final double anguloRad;

  const RadioTrazado(this.anguloRad);

  /// Normaliza el ángulo al rango [0, 2π).
  double get anguloNormalizado {
    var anguloModulo = anguloRad % (2 * math.pi);
    if (anguloModulo < 0) anguloModulo += 2 * math.pi;
    return anguloModulo;
  }
}
