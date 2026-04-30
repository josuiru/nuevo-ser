import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:las_versiones/dominio/brecha.dart';
import 'package:las_versiones/dominio/catalogo_brechas.dart';
import 'package:las_versiones/vista/fase_evaluacion.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({
      // Las cinco fuentes de la 1.1 ya recogidas en Fase 2.
      'nuevoser.lasversiones.brecha.1.1.fuente.restos_oseos_in_situ': true,
      'nuevoser.lasversiones.brecha.1.1.fuente.material_litico_entorno': true,
      'nuevoser.lasversiones.brecha.1.1.fuente.informe_excavacion_antiguo':
          true,
      'nuevoser.lasversiones.brecha.1.1.fuente.informe_revision_moderno': true,
      'nuevoser.lasversiones.brecha.1.1.fuente.toponimo_local': true,
    });
  });

  Future<void> bombearFase(
    WidgetTester tester, {
    required Brecha brecha,
    required VoidCallback alAvanzar,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: FaseEvaluacion(
              brecha: brecha,
              alAvanzarFase: alAvanzar,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets(
      'arranca con 0 evaluadas y CTA bloqueado cuando no hay respuestas',
      (tester) async {
    await bombearFase(
      tester,
      brecha: CatalogoBrechas.brecha11,
      alAvanzar: () {},
    );

    expect(find.text('Evaluadas: 0 / 5'), findsOneWidget);
    final cta = tester.widget<TextButton>(
      find.ancestor(
        of: find.text('IR A LA RECONSTRUCCIÓN'),
        matching: find.byType(TextButton),
      ),
    );
    expect(cta.onPressed, isNull);
  });

  testWidgets(
      'elegir tipo + sesgo en una fuente cuenta como evaluación completa',
      (tester) async {
    await bombearFase(
      tester,
      brecha: CatalogoBrechas.brecha11,
      alAvanzar: () {},
    );

    // La primera fuente: "RESTOS ÓSEOS EN EL HUECO INTERIOR".
    final primariaFinder = find.text('Primaria').first;
    await tester.scrollUntilVisible(primariaFinder, 80);
    await tester.tap(primariaFinder);
    await tester.pumpAndSettle();

    final ningunoFinder = find.text('Ninguno').first;
    await tester.scrollUntilVisible(ningunoFinder, 80);
    await tester.tap(ningunoFinder);
    await tester.pumpAndSettle();

    expect(find.text('Evaluadas: 1 / 5'), findsOneWidget);
    // La nota del oficio aparece tras evaluar.
    expect(find.text('NOTA DEL OFICIO'), findsOneWidget);
    expect(
      find.textContaining('Aciertos en esta fuente: 2 / 2'),
      findsOneWidget,
    );
  });

  testWidgets(
      'evaluar las cinco fuentes desbloquea el CTA "IR A LA RECONSTRUCCIÓN"',
      (tester) async {
    // Un solo setMockInitialValues con todas las claves: las 5
    // recogidas y las 5 evaluaciones precargadas, equivalente a
    // haberlas evaluado en una sesión previa.
    SharedPreferences.setMockInitialValues({
      'nuevoser.lasversiones.brecha.1.1.fuente.restos_oseos_in_situ': true,
      'nuevoser.lasversiones.brecha.1.1.fuente.material_litico_entorno': true,
      'nuevoser.lasversiones.brecha.1.1.fuente.informe_excavacion_antiguo':
          true,
      'nuevoser.lasversiones.brecha.1.1.fuente.informe_revision_moderno': true,
      'nuevoser.lasversiones.brecha.1.1.fuente.toponimo_local': true,
      'nuevoser.lasversiones.brecha.1.1.evaluacion.restos_oseos_in_situ':
          '{"tipo":"primaria","sesgo":"ninguno"}',
      'nuevoser.lasversiones.brecha.1.1.evaluacion.material_litico_entorno':
          '{"tipo":"primaria","sesgo":"ninguno"}',
      'nuevoser.lasversiones.brecha.1.1.evaluacion.informe_excavacion_antiguo':
          '{"tipo":"secundaria","sesgo":"difusionista"}',
      'nuevoser.lasversiones.brecha.1.1.evaluacion.informe_revision_moderno':
          '{"tipo":"secundaria","sesgo":"ninguno"}',
      'nuevoser.lasversiones.brecha.1.1.evaluacion.toponimo_local':
          '{"tipo":"secundaria","sesgo":"ninguno"}',
    });

    var avancesInvocados = 0;
    await bombearFase(
      tester,
      brecha: CatalogoBrechas.brecha11,
      alAvanzar: () => avancesInvocados++,
    );

    expect(find.text('Evaluadas: 5 / 5'), findsOneWidget);
    final cta = tester.widget<TextButton>(
      find.ancestor(
        of: find.text('IR A LA RECONSTRUCCIÓN'),
        matching: find.byType(TextButton),
      ),
    );
    expect(cta.onPressed, isNotNull);

    await tester.tap(find.text('IR A LA RECONSTRUCCIÓN'));
    await tester.pumpAndSettle();
    expect(avancesInvocados, 1);
  });
}
