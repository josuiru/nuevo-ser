import 'package:el_cuaderno/dominio/sit_spot.dart';
import 'package:el_cuaderno/nucleo/i18n/generado/textos_app.dart';
import 'package:el_cuaderno/vista/pantalla_cuaderno/tarjeta_sit_spot.dart';
import 'package:el_cuaderno/vista/tema/tema.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> bombear(
    WidgetTester tester, {
    SitSpot? sitSpot,
    VoidCallback? alPulsarInvitacion,
    VoidCallback? alJubilar,
  }) async {
    await tester.binding.setSurfaceSize(const Size(800, 1200));
    await tester.pumpWidget(MaterialApp(
      theme: TemaCuaderno.claro(),
      localizationsDelegates: TextosApp.localizationsDelegates,
      supportedLocales: TextosApp.supportedLocales,
      locale: const Locale('es'),
      home: Scaffold(
        body: TarjetaSitSpot(
          sitSpot: sitSpot,
          alPulsarInvitacion: alPulsarInvitacion,
          alJubilar: alJubilar,
        ),
      ),
    ));
    await tester.pumpAndSettle();
  }

  group('estado invitación (sin sit spot)', () {
    testWidgets('muestra el texto de invitación + botón "qué es un sit spot"',
        (tester) async {
      await bombear(tester);
      expect(find.textContaining('un parque'), findsOneWidget);
      expect(find.text('qué es un sit spot'), findsOneWidget);
    });

    testWidgets('pulsar "qué es un sit spot" abre el diálogo pedagógico',
        (tester) async {
      await bombear(tester);
      await tester.tap(find.text('qué es un sit spot'));
      await tester.pumpAndSettle();
      // Título del diálogo (mismo que la pantalla de presentación).
      expect(find.text('Un sitio que conoces'), findsOneWidget);
      // Al menos un párrafo distinguible.
      expect(find.textContaining('verás cambiar'), findsOneWidget);
      // Botón cerrar.
      await tester.tap(find.text('Cerrar'));
      await tester.pumpAndSettle();
      expect(find.text('Un sitio que conoces'), findsNothing);
    });

    testWidgets('pulsar el área principal dispara alPulsarInvitacion',
        (tester) async {
      var pulsado = 0;
      await bombear(tester, alPulsarInvitacion: () => pulsado++);
      // Tap sobre la tarjeta (no sobre el botón secundario).
      await tester.tap(find.textContaining('un parque'));
      await tester.pumpAndSettle();
      expect(pulsado, 1);
    });

    testWidgets('"qué es un sit spot" NO dispara alPulsarInvitacion',
        (tester) async {
      var pulsado = 0;
      await bombear(tester, alPulsarInvitacion: () => pulsado++);
      await tester.tap(find.text('qué es un sit spot'));
      await tester.pumpAndSettle();
      expect(pulsado, 0);
    });

    testWidgets(
        'sin alPulsarInvitacion: la tarjeta no es pulsable pero el botón sigue ahí',
        (tester) async {
      await bombear(tester);
      // El botón "qué es" siempre está; el diálogo es accesible siempre.
      expect(find.text('qué es un sit spot'), findsOneWidget);
    });
  });

  group('estado activo (con sit spot)', () {
    testWidgets(
        'tarjeta activa NO muestra el botón "qué es un sit spot"',
        (tester) async {
      final activo = SitSpot(
        id: 'sp-1',
        nombre: 'el banco viejo',
        dondeNombre: 'final del parque',
        creadoEn: DateTime.utc(2026, 1, 15),
      );
      await bombear(tester, sitSpot: activo);
      expect(find.text('el banco viejo'), findsOneWidget);
      // El botón pedagógico sólo aparece en la invitación, no en la
      // tarjeta activa — el niño ya lo vivió.
      expect(find.text('qué es un sit spot'), findsNothing);
    });
  });
}
