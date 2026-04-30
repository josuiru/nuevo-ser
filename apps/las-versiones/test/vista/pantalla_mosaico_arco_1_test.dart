import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:las_versiones/vista/pantalla_mosaico_arco_1.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Future<void> bombear(
    WidgetTester tester, {
    required Future<void> Function() alEntregar,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        home: PantallaMosaicoArco1(alEntregar: alEntregar),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('arranque sin contenido → CTA "ENTREGAR" bloqueado',
      (tester) async {
    await bombear(tester, alEntregar: () async {});
    final cta = tester.widget<TextButton>(
      find.ancestor(
        of: find.text('ENTREGAR EL MOSAICO'),
        matching: find.byType(TextButton),
      ),
    );
    expect(cta.onPressed, isNull);
  });

  testWidgets('escribir en un campo desbloquea el CTA y al pulsarlo entrega',
      (tester) async {
    var entregasInvocadas = 0;
    await bombear(tester, alEntregar: () async {
      entregasInvocadas++;
    });

    await tester.enterText(
      find.byType(TextField).first,
      'Que el oficio empieza por las preguntas.',
    );
    await tester.pumpAndSettle();

    final cta = tester.widget<TextButton>(
      find.ancestor(
        of: find.text('ENTREGAR EL MOSAICO'),
        matching: find.byType(TextButton),
      ),
    );
    expect(cta.onPressed, isNotNull);

    await tester.tap(find.text('ENTREGAR EL MOSAICO'));
    await tester.pumpAndSettle();
    expect(entregasInvocadas, 1);

    final prefs = await SharedPreferences.getInstance();
    final blob = prefs.getString('nuevoser.lasversiones.mosaico.arco_1');
    expect(blob, isNotNull);
    expect(blob, contains('preguntas'));
  });

  testWidgets('respuestas persistidas reaparecen al volver a abrir',
      (tester) async {
    SharedPreferences.setMockInitialValues({
      'nuevoser.lasversiones.mosaico.arco_1':
          '{"que_te_llevas":"Texto previo de la sesión anterior."}',
    });
    await bombear(tester, alEntregar: () async {});
    expect(find.text('Texto previo de la sesión anterior.'), findsOneWidget);
  });
}
