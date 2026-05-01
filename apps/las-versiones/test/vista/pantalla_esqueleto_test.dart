import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:las_versiones/vista/pantalla_esqueleto.dart';

void main() {
  group('PantallaEsqueleto', () {
    testWidgets(
      'sin callbacks opcionales — sólo título y nota; ningún botón '
      'de Cuaderno, Sesión ni Ajustes',
      (tester) async {
        await tester.pumpWidget(const MaterialApp(home: PantallaEsqueleto()));
        expect(find.text('LAS VERSIONES'), findsOneWidget);
        expect(find.text('CUADERNO'), findsNothing);
        expect(find.text('INICIAR SESIÓN'), findsNothing);
        expect(find.text('SESIÓN INICIADA'), findsNothing);
        expect(find.text('AJUSTES'), findsNothing);
      },
    );

    testWidgets(
      'con alAbrirAjustes != null aparece el botón AJUSTES (esquina '
      'inferior-derecha) y un tap dispara el callback',
      (tester) async {
        var pulsaciones = 0;
        await tester.pumpWidget(MaterialApp(
          home: PantallaEsqueleto(alAbrirAjustes: () => pulsaciones++),
        ));
        expect(find.text('AJUSTES'), findsOneWidget);
        expect(find.byIcon(Icons.settings_outlined), findsOneWidget);

        await tester.tap(find.text('AJUSTES'));
        await tester.pump();
        expect(pulsaciones, 1);
      },
    );

    testWidgets(
      'el botón AJUSTES convive con CUADERNO y SESIÓN sin solaparse '
      '— los tres callbacks responden de forma independiente',
      (tester) async {
        var ajustes = 0;
        var cuaderno = 0;
        var sesion = 0;
        await tester.pumpWidget(MaterialApp(
          home: PantallaEsqueleto(
            alAbrirCuaderno: () => cuaderno++,
            alAbrirSesion: () => sesion++,
            sesionIniciada: false,
            alAbrirAjustes: () => ajustes++,
          ),
        ));
        expect(find.text('CUADERNO'), findsOneWidget);
        expect(find.text('INICIAR SESIÓN'), findsOneWidget);
        expect(find.text('AJUSTES'), findsOneWidget);

        await tester.tap(find.text('AJUSTES'));
        await tester.pump();
        await tester.tap(find.text('CUADERNO'));
        await tester.pump();
        await tester.tap(find.text('INICIAR SESIÓN'));
        await tester.pump();

        expect(ajustes, 1);
        expect(cuaderno, 1);
        expect(sesion, 1);
      },
    );
  });
}
