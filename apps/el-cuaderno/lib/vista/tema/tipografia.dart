import 'package:flutter/material.dart';

/// Tipografía de El Cuaderno (biblia §8, doc 13 §11.6). Dos
/// familias funcionales:
///
/// - **Serif** para los textos del cuaderno y la voz del niño —
///   citas, observaciones, microcopia narrativa. Lora o Fraunces
///   son las candidatas finales (doc 11 pendiente); en S1 usamos
///   la system serif del dispositivo para no comprometer la
///   decisión.
/// - **Sans-serif** para datos del sistema — fecha, hora, lugar,
///   botones, navegación. Inter o IBM Plex Sans son las
///   candidatas; en S1 usamos `null` (system default).
///
/// **Tamaños**: 11, 12, 13, 14, 16, 17 px. Nunca otros — la
/// densidad textual del juego es deliberadamente baja (doc 04
/// §1.2).
///
/// **Pesos**: solo 400 regular y 500 medio. Nunca 600 ni 700 —
/// la voz del Cuaderno no levanta la voz (doc 04 §2.1).
class TipografiaCuaderno {
  const TipografiaCuaderno._();

  // TODO: usar Lora o Fraunces vía google_fonts cuando el doc 11
  // cierre la elección. Mientras, system serif default.
  static const String? _familiaSerif = null;

  // TODO: usar Inter o IBM Plex Sans cuando se cierre.
  static const String? _familiaSans = null;

  static const FontWeight pesoRegular = FontWeight.w400;
  static const FontWeight pesoMedio = FontWeight.w500;

  // Tamaños — los seis canónicos.
  static const double tamano11 = 11;
  static const double tamano12 = 12;
  static const double tamano13 = 13;
  static const double tamano14 = 14;
  static const double tamano16 = 16;
  static const double tamano17 = 17;

  static TextStyle serif({
    required Color color,
    double tamano = tamano14,
    FontWeight peso = pesoRegular,
    double? altoLinea,
  }) {
    return TextStyle(
      fontFamily: _familiaSerif,
      fontFamilyFallback: const ['serif'],
      fontSize: tamano,
      fontWeight: peso,
      color: color,
      height: altoLinea,
    );
  }

  static TextStyle sans({
    required Color color,
    double tamano = tamano13,
    FontWeight peso = pesoRegular,
    double? altoLinea,
  }) {
    return TextStyle(
      fontFamily: _familiaSans,
      fontFamilyFallback: const ['sans-serif'],
      fontSize: tamano,
      fontWeight: peso,
      color: color,
      height: altoLinea,
    );
  }

  /// Construye un TextTheme coherente con la jerarquía pedagógica.
  /// Los tamaños grandes son para títulos del cuaderno (serif), los
  /// medianos para cuerpo del niño (serif), los pequeños para
  /// metadatos del sistema (sans).
  static TextTheme construirTextTheme(ColorScheme esquema) {
    return TextTheme(
      // Cabeceras del cuaderno — serif, peso medio.
      headlineSmall: serif(
        color: esquema.onSurface,
        tamano: tamano17,
        peso: pesoMedio,
        altoLinea: 1.3,
      ),
      titleLarge: serif(
        color: esquema.onSurface,
        tamano: tamano16,
        peso: pesoMedio,
        altoLinea: 1.3,
      ),
      titleMedium: serif(
        color: esquema.onSurface,
        tamano: tamano14,
        peso: pesoMedio,
      ),

      // Cuerpo del cuaderno — serif, peso regular.
      bodyLarge: serif(
        color: esquema.onSurface,
        tamano: tamano16,
        altoLinea: 1.45,
      ),
      bodyMedium: serif(
        color: esquema.onSurface,
        tamano: tamano14,
        altoLinea: 1.45,
      ),
      bodySmall: serif(
        color: esquema.onSurface,
        tamano: tamano13,
        altoLinea: 1.4,
      ),

      // Metadatos del sistema — sans, tenues.
      labelLarge: sans(
        color: esquema.tertiary,
        tamano: tamano13,
        peso: pesoMedio,
      ),
      labelMedium: sans(
        color: esquema.tertiary,
        tamano: tamano12,
      ),
      labelSmall: sans(
        color: esquema.tertiary,
        tamano: tamano11,
      ),
    );
  }
}
