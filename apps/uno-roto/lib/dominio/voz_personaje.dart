import 'package:flutter/material.dart';

import '../nucleo/paleta.dart';

/// Cada personaje narrativo tiene una "voz" con nombre visible, color y
/// estilo tipográfico propio. Los Fragmentos con voz (Kurz, Eco) usan
/// itálica + color de acento para distinguirse del diálogo humano —
/// guía visual §5 hasta que integremos Cormorant Garamond como asset.
enum VozPersonaje {
  narrador,
  sora,
  kai,
  irune,
  oryn,
  naini,
  brina,
  rexan,
  vadic,
  ari,
  fragmentoKurz,
  fragmentoEco,
  fragmentoZafran,
  fragmentoVorax,
  aprendizNiko,
}

extension EstiloVozPersonaje on VozPersonaje {
  String get nombreVisible {
    switch (this) {
      case VozPersonaje.narrador:
        return '';
      case VozPersonaje.sora:
        return 'Sora';
      case VozPersonaje.kai:
        return 'Kai';
      case VozPersonaje.irune:
        return 'Irune';
      case VozPersonaje.oryn:
        return 'Oryn';
      case VozPersonaje.naini:
        return 'Naini';
      case VozPersonaje.brina:
        return 'Brina';
      case VozPersonaje.rexan:
        return 'Rexán';
      case VozPersonaje.vadic:
        return 'Vadic';
      case VozPersonaje.ari:
        return 'Ari';
      case VozPersonaje.fragmentoKurz:
        return 'Kurz';
      case VozPersonaje.fragmentoEco:
        return 'Eco';
      case VozPersonaje.fragmentoZafran:
        return 'Zafrán';
      case VozPersonaje.fragmentoVorax:
        return 'Vorax';
      case VozPersonaje.aprendizNiko:
        return 'Niko';
    }
  }

  Color get colorNombre {
    switch (this) {
      case VozPersonaje.narrador:
        return PaletaNeon.textoTenue;
      case VozPersonaje.sora:
        return PaletaNeon.azulNeon;
      case VozPersonaje.kai:
        return PaletaNeon.rosaAcento;
      case VozPersonaje.irune:
      case VozPersonaje.brina:
        return PaletaNeon.violetaNeon;
      case VozPersonaje.oryn:
        return PaletaNeon.exitoSuave;
      case VozPersonaje.naini:
        return PaletaNeon.rosaAcento;
      case VozPersonaje.rexan:
        return PaletaNeon.ambarCanales;
      case VozPersonaje.vadic:
        return PaletaNeon.grisMetal;
      case VozPersonaje.ari:
        return PaletaNeon.exitoSuave;
      case VozPersonaje.aprendizNiko:
        return PaletaNeon.azulNeon;
      case VozPersonaje.fragmentoKurz:
      case VozPersonaje.fragmentoEco:
      case VozPersonaje.fragmentoZafran:
      case VozPersonaje.fragmentoVorax:
        return PaletaNeon.violetaNeon;
    }
  }

  bool get esFragmento {
    switch (this) {
      case VozPersonaje.fragmentoKurz:
      case VozPersonaje.fragmentoEco:
      case VozPersonaje.fragmentoZafran:
      case VozPersonaje.fragmentoVorax:
        return true;
      default:
        return false;
    }
  }

  /// Los Fragmentos con voz usan Cormorant Garamond italic — guía
  /// visual §5. Tipografía serif distinta del humano (sans Inter por
  /// defecto del tema), perceptible incluso sin saber qué fuente es.
  TextStyle estiloTextoCuerpo() {
    if (esFragmento) {
      return const TextStyle(
        fontFamily: 'CormorantGaramond',
        fontSize: 22,
        height: 1.45,
        color: PaletaNeon.textoPrincipal,
        fontStyle: FontStyle.italic,
        letterSpacing: 0.4,
        fontWeight: FontWeight.w400,
      );
    }
    return const TextStyle(
      fontSize: 20,
      height: 1.5,
      color: PaletaNeon.textoPrincipal,
      letterSpacing: 0.3,
      fontWeight: FontWeight.w300,
    );
  }
}
