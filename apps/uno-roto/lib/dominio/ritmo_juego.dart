/// Ritmo con el que el juego presenta cinemáticas, combates y
/// explicaciones. Se elige al crear perfil o desde ajustes. El motor
/// adaptativo sigue midiendo precisión independientemente — esto solo
/// cambia la velocidad con la que todo aparece en pantalla.
///
/// Pensado para ajustar a la edad/madurez lectora del niño sin
/// tocar el contenido.
enum RitmoJuego {
  /// Más pausado: reveal letra-a-letra más lento, combates con
  /// tiempo extra por pregunta, ambientes que respiran más.
  /// Pensado para niños de 9 años o lectura más lenta.
  tranquilo,

  /// Ritmo calibrado del MVP. Pensado para niños 10-12 años.
  estandar,

  /// Más ágil: reveal rápido, combates con tiempo ajustado. Para
  /// niños que ya tienen soltura y se aburren con pausas.
  exigente,
}

extension MetadatosRitmo on RitmoJuego {
  String get nombreVisible {
    switch (this) {
      case RitmoJuego.tranquilo:
        return 'Tranquilo';
      case RitmoJuego.estandar:
        return 'Estándar';
      case RitmoJuego.exigente:
        return 'Exigente';
    }
  }

  String get descripcionCorta {
    switch (this) {
      case RitmoJuego.tranquilo:
        return 'Las palabras aparecen más despacio. Los combates dan más tiempo.';
      case RitmoJuego.estandar:
        return 'La velocidad base del juego.';
      case RitmoJuego.exigente:
        return 'Todo va más rápido. Los combates piden más agilidad.';
    }
  }

  /// Multiplicador aplicado al intervalo de reveal letra-a-letra.
  /// 1.0 en estándar; >1 = más lento; <1 = más rápido.
  double get multiplicadorReveal {
    switch (this) {
      case RitmoJuego.tranquilo:
        return 1.45;
      case RitmoJuego.estandar:
        return 1.0;
      case RitmoJuego.exigente:
        return 0.7;
    }
  }

  /// Multiplicador del tiempo por pregunta en combates de Fragmento
  /// nombrado. En tranquilo hay un 30% más de tiempo.
  double get multiplicadorTiempoCombate {
    switch (this) {
      case RitmoJuego.tranquilo:
        return 1.3;
      case RitmoJuego.estandar:
        return 1.0;
      case RitmoJuego.exigente:
        return 0.85;
    }
  }

  /// Multiplicador para PlanoAmbiente. En tranquilo los ambientes
  /// duran un poco más; en exigente pasan algo más rápido.
  double get multiplicadorAmbiente {
    switch (this) {
      case RitmoJuego.tranquilo:
        return 1.2;
      case RitmoJuego.estandar:
        return 1.0;
      case RitmoJuego.exigente:
        return 0.8;
    }
  }

  int get valor => index;
}
