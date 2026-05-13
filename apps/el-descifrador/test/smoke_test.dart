// Smoke test del esqueleto v0.1.0.
//
// El test verifica que la app compila, que las cuatro lenguas peninsulares
// cooficiales están cableadas, y que el mensaje de bienvenida se muestra
// en castellano por defecto.
//
// Cuando entre la mecánica real, este test se sustituirá por suites
// específicas (motor de corpus, cuaderno, decisiones, etc.).

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:el_descifrador/main.dart';
import 'package:el_descifrador/l10n/app_localizations.dart';

void main() {
  testWidgets('Esqueleto muestra mensaje de bienvenida en castellano', (
    tester,
  ) async {
    await tester.pumpWidget(const AppDescifrador());
    await tester.pumpAndSettle();

    expect(find.text('La Estafeta te espera.'), findsOneWidget);
  });

  test('Las cuatro lenguas peninsulares cooficiales están soportadas', () {
    final localesSoportados = AppLocalizations.supportedLocales
        .map((locale) => locale.languageCode)
        .toSet();

    expect(localesSoportados, containsAll(['es', 'eu', 'ca', 'gl']));
    expect(
      localesSoportados.length,
      4,
      reason:
          'Decisión 2026-05-13: las cuatro cooficiales son contenido nuclear, '
          'no decoración. Si alguien añade una quinta lengua antes de v1.1, '
          'que actualice este test con la razón.',
    );
  });
}
