import 'dart:math' as math;

/// Clasificación cualitativa del temperamento del Fragmento, usada solo
/// para diferenciar estética y comportamiento. NO afecta a la dificultad
/// matemática: todos los unitarios se cortan con la misma regla.
///
/// Biblia §5.2 B: el Medio es "tranquilo", el Tercio "rota sobre sí
/// mismo", el Cuarto "permite combos", el Quinto es "esquivo".
enum TemperamentoFragmento { sereno, estable, metodico, inquieto }

/// Fragmento unitario de la Familia B: valor 1/denominador.
///
/// El jugador debe cortarlo en exactamente [denominador] sectores iguales
/// que pasen todos por el centro, con una tolerancia angular configurable.
class FragmentoUnitario {
  final int denominador;

  const FragmentoUnitario(this.denominador)
      : assert(denominador >= 2 && denominador <= 8);

  double get valor => 1.0 / denominador;

  String get etiqueta => '1/$denominador';

  double get anguloEsperadoEntreCortes => (2 * math.pi) / denominador;

  /// Número de trazos que el jugador debe realizar para partir el
  /// Fragmento en [denominador] sectores iguales.
  ///
  /// Modelamos cada gesto como un radio desde el centro hacia el borde
  /// (ver [LienzoCombate]: el ángulo se toma del punto final del gesto
  /// respecto al centro). Por tanto cortar 1/N exige exactamente N
  /// trazos radiales — sin atajos diametrales.
  ///
  /// El tope superior del [denominador] se mantiene bajo a propósito:
  /// pedirle al niño 11 trazos en una pantalla de móvil no aporta
  /// nada pedagógico, y los denominadores grandes ya se ejercitan en
  /// los puzzles abstractos.
  int get radiosRequeridos => denominador;

  TemperamentoFragmento get temperamento {
    switch (denominador) {
      case 2:
        return TemperamentoFragmento.sereno;
      case 3:
        return TemperamentoFragmento.estable;
      case 4:
        return TemperamentoFragmento.metodico;
      default:
        // Los denominadores mayores o primos empiezan a ser "inquietos".
        return TemperamentoFragmento.inquieto;
    }
  }
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
