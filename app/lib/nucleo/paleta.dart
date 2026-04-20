import 'package:flutter/material.dart';

/// Paleta de color del prototipo — biblia §3.2 (azul-violeta-neón).
class PaletaNeon {
  static const Color fondoProfundo = Color(0xFF0A0618);
  static const Color fondoMedio = Color(0xFF140A2E);
  static const Color violetaBase = Color(0xFF4B2E83);
  static const Color violetaNeon = Color(0xFF8A5CFF);
  static const Color azulNeon = Color(0xFF4DC9FF);
  static const Color rosaAcento = Color(0xFFFF4D9D);
  static const Color textoPrincipal = Color(0xFFE6E0FF);
  static const Color textoTenue = Color(0xFF9E95C7);
  static const Color exitoSuave = Color(0xFF7EE8B0);

  static const LinearGradient fondoCiudad = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [fondoProfundo, fondoMedio],
  );
}

ThemeData temaUnoRoto() {
  final esquema = ColorScheme.fromSeed(
    seedColor: PaletaNeon.violetaNeon,
    brightness: Brightness.dark,
    primary: PaletaNeon.violetaNeon,
    secondary: PaletaNeon.azulNeon,
    surface: PaletaNeon.fondoMedio,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: esquema,
    scaffoldBackgroundColor: PaletaNeon.fondoProfundo,
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 42,
        fontWeight: FontWeight.w300,
        color: PaletaNeon.textoPrincipal,
        letterSpacing: 3,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: PaletaNeon.textoPrincipal,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: PaletaNeon.textoTenue,
      ),
    ),
  );
}
