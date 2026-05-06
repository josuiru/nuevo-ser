import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:las_versiones/dominio/voz_personaje.dart';
import 'package:las_versiones/vista/avatar_personaje.dart';

void main() {
  group('AvatarPersonaje', () {
    testWidgets(
      'voz con nombre — el avatar se renderiza con CustomPaint y el '
      'tamaño solicitado. Maren tiene retrato ilustrado en F2-30, así '
      'que en el árbol hay al menos un CustomPaint (el del borde por '
      'estamento, encima de la imagen)',
      (tester) async {
        await tester.pumpWidget(const MaterialApp(
          home: Scaffold(
            body: AvatarPersonaje(voz: VozPersonaje.maren, tamano: 40),
          ),
        ));

        final cajaSized = tester.widgetList<SizedBox>(
          find.descendant(
            of: find.byType(AvatarPersonaje),
            matching: find.byType(SizedBox),
          ),
        ).first;
        expect(cajaSized.width, 40);
        expect(cajaSized.height, 40);
        expect(
          find.descendant(
            of: find.byType(AvatarPersonaje),
            matching: find.byType(CustomPaint),
          ),
          findsAtLeastNWidgets(1),
        );
      },
    );

    testWidgets(
      'voz con retrato ilustrado (Maren) — modo ilustrado: ClipOval '
      'con Image.asset y CustomPaint del borde superpuesto. El asset '
      'puede no cargar en el entorno de tests sin assets — el '
      'errorBuilder cae al CustomPaint procedural sin lanzar, así que '
      'la presencia de ClipOval es la firma robusta del modo ilustrado',
      (tester) async {
        await tester.pumpWidget(const MaterialApp(
          home: Scaffold(
            body: AvatarPersonaje(voz: VozPersonaje.maren),
          ),
        ));

        expect(
          find.descendant(
            of: find.byType(AvatarPersonaje),
            matching: find.byType(ClipOval),
          ),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'voz sin retrato ilustrado (Tasio) — modo procedural: ningún '
      'ClipOval en el árbol, sólo el CustomPaint con inicial + borde + '
      'disco translúcido del color de la voz',
      (tester) async {
        await tester.pumpWidget(const MaterialApp(
          home: Scaffold(
            body: AvatarPersonaje(voz: VozPersonaje.tasio),
          ),
        ));

        expect(
          find.descendant(
            of: find.byType(AvatarPersonaje),
            matching: find.byType(ClipOval),
          ),
          findsNothing,
        );
        expect(
          find.descendant(
            of: find.byType(AvatarPersonaje),
            matching: find.byType(CustomPaint),
          ),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'voz sin nombre (narrador) — no se pinta nada, sólo un placeholder '
      'del tamaño pedido para que el layout no salte',
      (tester) async {
        await tester.pumpWidget(const MaterialApp(
          home: Scaffold(
            body: AvatarPersonaje(voz: VozPersonaje.narrador, tamano: 32),
          ),
        ));

        // Sin CustomPaint cuando la voz es anónima (narrador). El
        // SizedBox queda como reserva de espacio.
        expect(
          find.descendant(
            of: find.byType(AvatarPersonaje),
            matching: find.byType(CustomPaint),
          ),
          findsNothing,
        );
      },
    );

    testWidgets(
      'el avatar es decorativo — se excluye de la semántica accesible '
      'porque el nombre del hablante ya aparece como Text adyacente',
      (tester) async {
        await tester.pumpWidget(const MaterialApp(
          home: Scaffold(
            body: AvatarPersonaje(voz: VozPersonaje.isaura),
          ),
        ));

        expect(
          find.descendant(
            of: find.byType(AvatarPersonaje),
            matching: find.byType(ExcludeSemantics),
          ),
          findsOneWidget,
        );
      },
    );
  });
}
