import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:las_versiones/vista/pantalla_esqueleto.dart';

void main() {
  group('PantallaEsqueleto', () {
    testWidgets(
      'sin callback de menú — sólo título y nota; ningún engranaje',
      (tester) async {
        await tester.pumpWidget(const MaterialApp(home: PantallaEsqueleto()));
        expect(find.text('LAS VERSIONES'), findsOneWidget);
        expect(find.byIcon(Icons.settings_outlined), findsNothing);
      },
    );

    testWidgets(
      'con alAbrirMenu != null aparece el engranaje arriba-derecha '
      'y un tap dispara el callback',
      (tester) async {
        var pulsaciones = 0;
        await tester.pumpWidget(MaterialApp(
          home: PantallaEsqueleto(alAbrirMenu: () => pulsaciones++),
        ));
        expect(find.byIcon(Icons.settings_outlined), findsOneWidget);

        await tester.tap(find.byIcon(Icons.settings_outlined));
        await tester.pump();
        expect(pulsaciones, 1);
      },
    );
  });
}
