import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uno_roto/l10n/app_localizations.dart';
import 'package:uno_roto/vista/pantalla_instrucciones.dart';

/// La página de instrucciones es estática (sin estado, sin red, sin
/// repositorio). Estos tests confirman que renderiza los tres títulos
/// canónicos del castellano y respeta el locale ca/eu (que aún caen al
/// castellano por traducción pendiente).
void main() {
  Widget envolver(Locale locale) {
    return MaterialApp(
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('es'), Locale('eu'), Locale('ca')],
      home: const PantallaInstrucciones(),
    );
  }

  testWidgets('castellano: muestra los tres títulos de sección',
      (tester) async {
    await tester.pumpWidget(envolver(const Locale('es')));
    await tester.pumpAndSettle();
    expect(find.text('DE QUÉ TRATA'), findsOneWidget);
    // 'CÓMO SE JUEGA' aparece dos veces: AppBar + título de la sección 2.
    expect(find.text('CÓMO SE JUEGA'), findsNWidgets(2));
    expect(find.text('PARA TUTORES Y MAESTROS'), findsOneWidget);
  });

  testWidgets('título de la AppBar respeta el locale', (tester) async {
    await tester.pumpWidget(envolver(const Locale('eu')));
    await tester.pumpAndSettle();
    // Locale eu: el título sí está traducido (la única clave nueva).
    expect(find.text('NOLA JOKATU'), findsOneWidget);
  });

  testWidgets('locale ca: usa el título traducido al catalán',
      (tester) async {
    await tester.pumpWidget(envolver(const Locale('ca')));
    await tester.pumpAndSettle();
    expect(find.text("COM S'HI JUGA"), findsOneWidget);
  });
}
