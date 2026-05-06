import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:las_versiones/vista/pantalla_instrucciones.dart';

void main() {
  group('PantallaInstrucciones', () {
    testWidgets(
      'render mínimo — título + las tres secciones canónicas',
      (tester) async {
        await tester.pumpWidget(const MaterialApp(
          home: PantallaInstrucciones(),
        ));

        expect(find.text('INSTRUCCIONES'), findsOneWidget);
        expect(find.text('DE QUÉ TRATA'), findsOneWidget);
        expect(find.text('CÓMO SE JUEGA'), findsOneWidget);
        expect(find.text('PARA TUTORES Y MAESTROS'), findsOneWidget);
      },
    );

    testWidgets(
      'menciona los conceptos clave del juego: Maren, Archivo de Iruña, '
      'Brechas, Cuaderno, Mosaicos y los tres niveles de confianza',
      (tester) async {
        await tester.pumpWidget(const MaterialApp(
          home: PantallaInstrucciones(),
        ));

        // El cuerpo se renderiza con RichText/TextSpan (negrita/cursiva
        // inline), por eso `findRichText: true`.
        expect(
          find.textContaining('Maren', findRichText: true),
          findsWidgets,
        );
        expect(
          find.textContaining('Archivo de Iruña', findRichText: true),
          findsWidgets,
        );
        expect(
          find.textContaining('Brecha', findRichText: true),
          findsWidgets,
        );
        expect(
          find.textContaining('Cuaderno', findRichText: true),
          findsWidgets,
        );
        expect(
          find.textContaining('Mosaico', findRichText: true),
          findsWidgets,
        );
        expect(
          find.textContaining('Sólido', findRichText: true),
          findsWidgets,
        );
        expect(
          find.textContaining('Probable', findRichText: true),
          findsWidgets,
        );
        expect(
          find.textContaining('Disputado', findRichText: true),
          findsWidgets,
        );
      },
    );

    testWidgets(
      'menciona privacidad por diseño y la licencia abierta del juego',
      (tester) async {
        await tester.pumpWidget(const MaterialApp(
          home: PantallaInstrucciones(),
        ));

        expect(
          find.textContaining('Privacidad por diseño', findRichText: true),
          findsWidgets,
        );
        expect(
          find.textContaining('AGPL-3.0', findRichText: true),
          findsWidgets,
        );
        expect(
          find.textContaining('CC BY-SA 4.0', findRichText: true),
          findsWidgets,
        );
      },
    );

    testWidgets(
      'la flecha atrás cierra la pantalla y devuelve al árbol anterior',
      (tester) async {
        await tester.pumpWidget(MaterialApp(
          home: Builder(builder: (ctx) {
            return Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () => Navigator.of(ctx).push(
                    MaterialPageRoute(
                      builder: (_) => const PantallaInstrucciones(),
                    ),
                  ),
                  child: const Text('ABRIR'),
                ),
              ),
            );
          }),
        ));

        await tester.tap(find.text('ABRIR'));
        await tester.pumpAndSettle();
        expect(find.byType(PantallaInstrucciones), findsOneWidget);

        await tester.tap(find.byIcon(Icons.arrow_back));
        await tester.pumpAndSettle();

        expect(find.byType(PantallaInstrucciones), findsNothing);
        expect(find.text('ABRIR'), findsOneWidget);
      },
    );
  });
}
