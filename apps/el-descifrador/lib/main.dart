// El Descifrador — esqueleto v0.1.0
//
// Cuarto juego Kids de la Colección Nuevo Ser. Verbo motor: descifrar.
// Edad 11-14. Materia: lengua, idiomas L2 lectura, pensamiento crítico,
// redacción. Mundo: La Estafeta — puerto atlántico ficticio peninsular.
//
// Este archivo es esqueleto. Sin contenido. Sin mecánica. Solo prueba que
// el monorepo compila y que las cuatro lenguas peninsulares cooficiales
// están cableadas desde el día uno (decisión cerrada 2026-05-13).
//
// El paquete documental v0.1 vive fuera del monorepo en:
//   ~/Projects/games/el-descifrador-paquete-documental-v0.1/
//
// La biblia es `el-descifrador-01-biblia.md`. Antes de tocar nada de
// gameplay, leer biblia + mecánica nuclear + flujos de usuario.

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';

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
      // Las cuatro tienen igual dignidad estructural. Castellano queda
      // como fallback técnico (template ARB), no como lengua principal
      // del juego — la lengua principal se elegirá en pantalla de
      // configuración inicial cuando entre la mecánica real.
      locale: const Locale('es'),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          // Paleta provisional doc 11 §1.1. Papel (#F4ECDD) como fondo,
          // tinta (#1F1A14) como texto. Ilustrador asignado afinará.
          seedColor: const Color(0xFF7A5C3A),
        ),
      ),
      home: const PantallaEsqueleto(),
    );
  }
}

class PantallaEsqueleto extends StatelessWidget {
  const PantallaEsqueleto({super.key});

  @override
  Widget build(BuildContext contexto) {
    final localizaciones = AppLocalizations.of(contexto)!;
    return Scaffold(
      backgroundColor: const Color(0xFFF4ECDD),
      body: Center(
        child: Text(
          localizaciones.mensajeEsqueletoBienvenida,
          style: const TextStyle(
            fontSize: 24,
            color: Color(0xFF1F1A14),
          ),
        ),
      ),
    );
  }
}
