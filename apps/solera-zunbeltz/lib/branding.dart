import 'package:flutter/material.dart';

/// Paleta y assets de Solera Zunbeltz. Consolidados en un único punto para
/// que el ilustrador pueda sustituirlos sin tocar el árbol de widgets.
///
/// La paleta replica la de la presentación (`presentacion/index.html`):
/// monte (verde profundo) + crema + ocre, con pasto y musgo de apoyo.
/// Es el branding distintivo de la suite Solera para el vertical ganadero
/// extensivo de Navarra.

/// Verde monte profundo — color principal del branding Zunbeltz.
const Color colorMonteZunbeltz = Color(0xFF1F2E22);

/// Verde pasto — acento principal sobre fondo claro.
const Color colorPastoZunbeltz = Color(0xFF5E7D3A);

/// Ocre — acentos cálidos (estados, pines, llamadas a la acción).
const Color colorOcreZunbeltz = Color(0xFFC99A3B);

/// Musgo — verde suave para superficies y chips.
const Color colorMusgoZunbeltz = Color(0xFF8AA66B);

/// Crema cálida — fondo principal de la app.
const Color colorCremaZunbeltz = Color(0xFFF4F0E4);

/// Tinta — texto sobre fondo crema.
const Color colorTintaZunbeltz = Color(0xFF1C241B);

/// Colores de estado de las tareas de mantenimiento (coherentes con la
/// leyenda de la presentación: pendiente = ocre, en curso = niebla,
/// hecha = musgo, bloqueada = terracota).
const Color colorEstadoPendiente = Color(0xFFC99A3B);
const Color colorEstadoEnCurso = Color(0xFF6C8AA0);
const Color colorEstadoHecha = Color(0xFF8AA66B);
const Color colorEstadoBloqueada = Color(0xFFB05E3B);

/// Logo placeholder. Lo sustituye el ilustrador cuando entregue el activo
/// definitivo (ver BLOQUEOS-PENDIENTES, branding visual).
const String rutaLogoZunbeltz = 'assets/icono-logo-zunbeltz.png';

/// Tema Material 3 de la app, derivado del verde monte sobre crema.
ThemeData temaZunbeltz() {
  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: colorMonteZunbeltz,
      primary: colorMonteZunbeltz,
      secondary: colorPastoZunbeltz,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: colorCremaZunbeltz,
  );
}
