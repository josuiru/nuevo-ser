// El Descifrador — v0.3.0
//
// Cuarto juego Kids de la Colección Nuevo Ser. Verbo motor: descifrar.
// Edad 11-14. Materia: lengua, idiomas L2 lectura, pensamiento crítico,
// redacción. Mundo: La Estafeta — puerto atlántico ficticio peninsular.
//
// El paquete documental v0.1 vive fuera del monorepo en:
//   ~/Projects/games/el-descifrador-paquete-documental-v0.1/
//
// La biblia es `el-descifrador-01-biblia.md`. Antes de tocar nada de
// gameplay, leer biblia + mecánica nuclear + flujos de usuario.

import 'package:flutter/material.dart';
import 'l10n/app_localizations.dart';
import 'vista/pantalla_mesa.dart';

void main() {
  runApp(const AppDescifrador());
}

class AppDescifrador extends StatelessWidget {
  const AppDescifrador({super.key});

  @override
  Widget build(BuildContext contexto) {
    return MaterialApp(
      onGenerateTitle: (contexto) => AppLocalizations.of(contexto)!.tituloApp,
      // Cuatro lenguas peninsulares cooficiales como L1 desde el día uno.
      // Manifiesto madre §5.4 y biblia del Descifrador §2.5.
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      // En v0.3.0 castellano por defecto. La selección de lengua de
      // juego (incluida segunda lengua materna del niño bilingüe —
      // decisión 2026-05-13 §2.4) se cablea cuando llegue el sistema
      // de perfiles del Descifrador.
      locale: const Locale('es'),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          // Paleta provisional doc 11 §1.1. Ilustrador asignado afinará.
          seedColor: const Color(0xFF7A5C3A),
        ),
      ),
      home: const PantallaMesa(),
    );
  }
}
