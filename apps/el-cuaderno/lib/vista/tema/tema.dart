import 'package:flutter/material.dart';

import 'colores.dart';
import 'tipografia.dart';

/// Construcción de los dos temas del juego — claro y oscuro. El
/// modo oscuro respeta el del sistema (doc 13 §11.5).
class TemaCuaderno {
  const TemaCuaderno._();

  static ThemeData claro() {
    final esquema = PaletaCuaderno.esquemaClaro;
    return _construir(esquema, Brightness.light);
  }

  static ThemeData oscuro() {
    final esquema = PaletaCuaderno.esquemaOscuro;
    return _construir(esquema, Brightness.dark);
  }

  static ThemeData _construir(ColorScheme esquema, Brightness brillo) {
    return ThemeData(
      useMaterial3: true,
      brightness: brillo,
      colorScheme: esquema,
      scaffoldBackgroundColor: esquema.surface,
      textTheme: TipografiaCuaderno.construirTextTheme(esquema),
      appBarTheme: AppBarTheme(
        backgroundColor: esquema.surface,
        foregroundColor: esquema.onSurface,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TipografiaCuaderno.serif(
          color: esquema.onSurface,
          tamano: TipografiaCuaderno.tamano17,
          peso: TipografiaCuaderno.pesoMedio,
        ),
      ),
      // Sin animación de splash al pulsar — la voz del Cuaderno
      // no celebra (doc 04 §2.4).
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      // Transiciones de 200ms entre pantallas, fade simple (doc 13
      // §11.7). No bounce ni spring.
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: <TargetPlatform, PageTransitionsBuilder>{
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.macOS: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }
}
