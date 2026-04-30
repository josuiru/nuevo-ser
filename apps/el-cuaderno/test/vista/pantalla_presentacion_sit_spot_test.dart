import 'package:el_cuaderno/vista/pantalla_sit_spot/pantalla_presentacion_sit_spot.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> bombear(
    WidgetTester tester, {
    required Future<void> Function({required bool tieneUnSitioPensado})
        alContinuar,
  }) async {
    await tester.binding.setSurfaceSize(const Size(800, 1400));
    await tester.pumpWidget(MaterialApp(
      home: PantallaPresentacionSitSpot(alContinuar: alContinuar),
    ));
    await tester.pumpAndSettle();
  }

  testWidgets('muestra título, párrafos pedagógicos y los dos botones',
      (tester) async {
    await bombear(
      tester,
      alContinuar: ({required tieneUnSitioPensado}) async {},
    );
    expect(find.text('Un sitio que conoces'), findsOneWidget);
    expect(find.textContaining('un banco del parque'), findsOneWidget);
    expect(find.textContaining('verás cambiar'), findsOneWidget);
    expect(find.text('ya pienso en uno'), findsOneWidget);
    expect(find.text('todavía no'), findsOneWidget);
  });

  testWidgets('"ya pienso en uno" llama al callback con tieneUnSitioPensado=true',
      (tester) async {
    bool? recibido;
    await bombear(
      tester,
      alContinuar: ({required tieneUnSitioPensado}) async {
        recibido = tieneUnSitioPensado;
      },
    );
    await tester.tap(find.text('ya pienso en uno'));
    await tester.pump();
    expect(recibido, isTrue);
  });

  testWidgets('"todavía no" llama al callback con tieneUnSitioPensado=false',
      (tester) async {
    bool? recibido;
    await bombear(
      tester,
      alContinuar: ({required tieneUnSitioPensado}) async {
        recibido = tieneUnSitioPensado;
      },
    );
    await tester.tap(find.text('todavía no'));
    await tester.pump();
    expect(recibido, isFalse);
  });

  testWidgets('voz adulta amable — sin emojis ni signos de exclamación',
      (tester) async {
    await bombear(
      tester,
      alContinuar: ({required tieneUnSitioPensado}) async {},
    );
    // Recorre todos los Text del árbol y verifica que ningún string
    // tenga caracteres de fanfarria (biblia §2.5/§2.7).
    for (final widget in tester.widgetList<Text>(find.byType(Text))) {
      final data = widget.data ?? '';
      expect(data, isNot(contains('!')));
      expect(data, isNot(contains('🌱')));
      expect(data, isNot(contains('¡')));
    }
  });
}
