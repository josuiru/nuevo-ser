import 'package:flutter/material.dart';

/// Paleta de El Cuaderno (biblia §8, doc 11). Cuaderno botánico
/// clásico llevado a un lenguaje moderno: cremas, verdes apagados,
/// ocres, sienas, azul ceniza, blanco hueso. **Sin saturaciones
/// altas. Sin negro puro: gris carbón.**
///
/// Esta paleta es **provisional**: las tonalidades exactas se
/// cierran con el doc 11 (guía visual) cuando la ilustradora
/// botánica entregue su primera muestra. La idea aquí es bloquear
/// las constantes pedagógicas (sin saturación tóxica, sin negro,
/// jerarquía de neutros cálidos) sin comprometer una decisión
/// estética que aún pertenece al diseño de arte.
class PaletaCuaderno {
  const PaletaCuaderno._();

  // Fondos — la base del papel.
  static const Color papelClaro = Color(0xFFF5EFE2);
  static const Color papelMedio = Color(0xFFEBE3D2);
  static const Color papelOscuro = Color(0xFFD8CFB8);

  // Tinta y carbón — los neutros oscuros. **Sin negro puro**: el
  // gris carbón evita la dureza de los `#000` que el principio §4
  // de la biblia aborrece (no humillar incluye no agredir
  // ópticamente).
  static const Color tinta = Color(0xFF2C2A24);
  static const Color carbon = Color(0xFF3F3D36);
  static const Color tintaTenue = Color(0xFF625F55);

  // Verdes apagados — acentos del oficio.
  static const Color verdeMusgo = Color(0xFF6E7B53);
  static const Color verdeBosque = Color(0xFF49583B);

  // Ocres y sienas — la tierra del cuaderno.
  static const Color ocreClaro = Color(0xFFC9A968);
  static const Color sienaTenue = Color(0xFFA0784A);

  // Azul ceniza — para datos del sistema, citas, tipografía
  // sans-serif. **No es decorativo**: marca la jerarquía (lo del
  // niño en serif/tinta, lo del sistema en sans/azul ceniza).
  static const Color azulCeniza = Color(0xFF6A7585);
  static const Color azulCenizaProfundo = Color(0xFF4D5764);

  // Modo oscuro — fondos gris carbón muy oscuro (no negro puro,
  // doc 13 §11.5), textos crema, mismos verdes y ocres apagados
  // un poco más luminosos.
  static const Color papelOscuroFondoNoche = Color(0xFF1F1E1A);
  static const Color cartulinaNoche = Color(0xFF2A2926);
  static const Color tintaNoche = Color(0xFFE8E2D2);
  static const Color tintaTenueNoche = Color(0xFFB7B0A0);

  /// Esquema de color para Material 3 en modo claro.
  static ColorScheme get esquemaClaro => const ColorScheme(
        brightness: Brightness.light,
        primary: verdeBosque,
        onPrimary: papelClaro,
        secondary: sienaTenue,
        onSecondary: papelClaro,
        tertiary: azulCenizaProfundo,
        onTertiary: papelClaro,
        error: sienaTenue, // El juego no usa rojo (biblia §2.4).
        onError: papelClaro,
        surface: papelClaro,
        onSurface: tinta,
        surfaceContainerHighest: papelMedio,
        outline: papelOscuro,
        outlineVariant: papelOscuro,
      );

  /// Esquema de color para Material 3 en modo oscuro (doc 13 §11.5).
  static ColorScheme get esquemaOscuro => const ColorScheme(
        brightness: Brightness.dark,
        primary: Color(0xFF8C9A6E),
        onPrimary: papelOscuroFondoNoche,
        secondary: ocreClaro,
        onSecondary: papelOscuroFondoNoche,
        tertiary: Color(0xFF8E97A6),
        onTertiary: papelOscuroFondoNoche,
        error: Color(0xFFB58A60),
        onError: papelOscuroFondoNoche,
        surface: papelOscuroFondoNoche,
        onSurface: tintaNoche,
        surfaceContainerHighest: cartulinaNoche,
        outline: cartulinaNoche,
        outlineVariant: cartulinaNoche,
      );
}
