import 'package:el_cuaderno/nucleo/i18n/generado/textos_app.dart';
import 'package:el_cuaderno/vista/pantalla_ajustes/pantalla_acerca_de.dart';
import 'package:el_cuaderno/vista/tema/tema.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> bombear(WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(400, 1200));
    await tester.pumpWidget(
      MaterialApp(
        theme: TemaCuaderno.claro(),
        localizationsDelegates: TextosApp.localizationsDelegates,
        supportedLocales: TextosApp.supportedLocales,
        locale: const Locale('es'),
        home: const PantallaAcercaDe(),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets(
    'cabecera + primeras secciones visibles al abrir; el resto se alcanza por scroll',
    (tester) async {
      await bombear(tester);

      // Lo primero que ve quien abre la pantalla — sin scrollear.
      expect(find.text('El Cuaderno'), findsOneWidget);
      expect(
        find.text('un cuaderno de campo digital — para 9-13 años'),
        findsOneWidget,
      );
      expect(find.text('qué es esto'), findsOneWidget);

      // Las secciones siguientes existen pero ListView las construye
      // lazy. scrollUntilVisible es la API canónica para verificar
      // que se llega a ellas.
      await tester.scrollUntilVisible(
        find.text('lo que este cuaderno NO hace'),
        300,
      );
      expect(find.text('lo que este cuaderno NO hace'), findsOneWidget);
    },
  );

  testWidgets(
    'al desplegar "para tu adulto: privacidad" aparece el detalle de la red',
    (tester) async {
      await bombear(tester);

      final tituloAdulto = find.text('para tu adulto: privacidad');
      await tester.scrollUntilVisible(tituloAdulto, 200);
      // Empuja un poco más para que no quede pegado al borde
      // inferior — sin esto el tap cae fuera del render tree.
      await tester.drag(find.byType(ListView), const Offset(0, -120));
      await tester.pumpAndSettle();
      await tester.tap(tituloAdulto);
      await tester.pumpAndSettle();

      // El contenido detallado lo renderiza un RichText con spans
      // por las **negritas** — find.text(...)/textContaining() no
      // los inspecciona, así que recorremos los RichText buscando
      // el fragmento plano.
      final dump = tester
          .widgetList<RichText>(find.byType(RichText, skipOffstage: false))
          .map((rt) => rt.text.toPlainText())
          .join('\n');
      expect(dump, contains('hard limit no negociable'));
    },
  );

  testWidgets('el cierre amable aparece al final', (tester) async {
    await bombear(tester);
    final cierre = find.text('el monte espera');
    await tester.scrollUntilVisible(cierre, 300);
    expect(cierre, findsOneWidget);
  });
}
