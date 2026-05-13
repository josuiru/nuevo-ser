// Smoke test del flujo principal en v0.3.0.
//
// Verifica que la app arranca con la mesa y carga el corpus.
//
// **TODO próximo sprint**: tests más exhaustivos de navegación (abrir
// pieza, decidir, volver) requieren refactor para inyectar
// CargadorCorpus en PantallaMesa. El rootBundle.loadString se comporta
// inconsistentemente entre testWidgets sucesivos en el mismo archivo
// (el primer test carga corpus correctamente, los siguientes no — sin
// patrón claro). Cuando se inyecte cargador con bundle in-memory, esos
// tests se pueden hacer deterministas.

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:el_descifrador/main.dart';
import 'package:el_descifrador/l10n/app_localizations.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('La app arranca con la mesa y carga el corpus', (tester) async {
    await tester.pumpWidget(const AppDescifrador());

    // Tras carga del corpus, debe aparecer el saludo del maestro
    // y al menos una pieza en la bandeja.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Hay correo en la mesa.'), findsOneWidget);
    // Las dos piezas empaquetadas en v0.1.0 deben aparecer por
    // remitente. Inês es voz recurrente — su identificador en
    // remitenteTextoLibre se muestra con guiones bajos sustituidos.
    expect(find.textContaining('ines cocinera lisboa'), findsOneWidget);
    expect(find.textContaining('aprendiz-companero-niko'), findsOneWidget);
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
