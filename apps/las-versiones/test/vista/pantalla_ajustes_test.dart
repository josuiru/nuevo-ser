import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:las_versiones/vista/pantalla_ajustes.dart';

void main() {
  group('PantallaAjustes', () {
    testWidgets(
      'render mínimo — título AJUSTES + sección EMPEZAR DE CERO + '
      'botón RESETEAR ARCHIVO + nota de scope futuro',
      (tester) async {
        await tester.pumpWidget(MaterialApp(
          home: PantallaAjustes(alResetearArchivo: () async {}),
        ));
        expect(find.text('AJUSTES'), findsOneWidget);
        expect(find.text('EMPEZAR DE CERO'), findsOneWidget);
        expect(find.text('RESETEAR ARCHIVO'), findsOneWidget);
        expect(find.text('No hay vuelta atrás.'), findsOneWidget);
        expect(
          find.textContaining('cambio de idioma y la selección de perfil'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'tap en RESETEAR ARCHIVO abre diálogo de confirmación con dos '
      'acciones (CANCELAR / SÍ, RESETEAR) — la primera no ejecuta el '
      'callback',
      (tester) async {
        var vecesEjecutado = 0;
        await tester.pumpWidget(MaterialApp(
          home: PantallaAjustes(
            alResetearArchivo: () async => vecesEjecutado++,
          ),
        ));
        await tester.tap(find.text('RESETEAR ARCHIVO'));
        await tester.pumpAndSettle();

        expect(find.text('¿Resetear el Archivo?'), findsOneWidget);
        expect(find.text('CANCELAR'), findsOneWidget);
        expect(find.text('SÍ, RESETEAR'), findsOneWidget);

        await tester.tap(find.text('CANCELAR'));
        await tester.pumpAndSettle();
        expect(vecesEjecutado, 0,
            reason: 'cancelar no debe disparar el reset');
      },
    );

    testWidgets(
      'confirmar el diálogo dispara alResetearArchivo y cierra la '
      'pantalla — la Cronista vuelve al árbol anterior',
      (tester) async {
        var vecesEjecutado = 0;
        await tester.pumpWidget(MaterialApp(
          home: Builder(builder: (ctx) {
            return Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(ctx).push(
                      MaterialPageRoute(
                        builder: (_) => PantallaAjustes(
                          alResetearArchivo: () async => vecesEjecutado++,
                        ),
                      ),
                    );
                  },
                  child: const Text('ABRIR AJUSTES'),
                ),
              ),
            );
          }),
        ));

        await tester.tap(find.text('ABRIR AJUSTES'));
        await tester.pumpAndSettle();
        expect(find.byType(PantallaAjustes), findsOneWidget);

        await tester.tap(find.text('RESETEAR ARCHIVO'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('SÍ, RESETEAR'));
        await tester.pumpAndSettle();

        expect(vecesEjecutado, 1, reason: 'el callback se ejecuta una vez');
        expect(
          find.byType(PantallaAjustes),
          findsNothing,
          reason: 'la pantalla se cierra tras el reset',
        );
        expect(find.text('ABRIR AJUSTES'), findsOneWidget);
      },
    );
  });
}
