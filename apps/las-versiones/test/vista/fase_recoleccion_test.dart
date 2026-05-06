import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nuevo_ser_core/nuevo_ser_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:las_versiones/datos/repositorio_recoleccion_fuentes.dart';
import 'package:las_versiones/dominio/brecha.dart';
import 'package:las_versiones/dominio/catalogo_brechas.dart';
import 'package:las_versiones/vista/fase_recoleccion.dart';

GestorPerfiles _gestorDePrueba() => GestorPerfiles(
      namespace: 'nuevoser.lasversiones',
      sufijoNombreVisible: 'nombre_jugador',
      clavesGlobalesNoMigrables: const {
        'nuevoser.lasversiones.idioma_app',
        'nuevoser.lasversiones.token_backend',
        'nuevoser.lasversiones.email_backend',
      },
    );

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
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
            child: FaseRecoleccion(
              brecha: brecha,
              alAvanzarFase: alAvanzar,
              repoRecoleccion: RepositorioRecoleccionFuentes(
                gestor: _gestorDePrueba(),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets(
      'cinco fuentes de la Brecha 1.1 aparecen y el avance está bloqueado '
      'al inicio', (tester) async {
    await bombearFase(
      tester,
      brecha: CatalogoBrechas.brecha11,
      alAvanzar: () {},
    );

    expect(
      find.text('AÑADIR A LA MESA'),
      findsNWidgets(CatalogoBrechas.brecha11.fuentes.length),
    );
    expect(find.text('Recogidas: 0 / 5'), findsOneWidget);

    final cta = tester.widget<TextButton>(
      find.ancestor(
        of: find.text('IR A LA MESA DE TRABAJO'),
        matching: find.byType(TextButton),
      ),
    );
    expect(cta.onPressed, isNull, reason: '0 de 5 → bloqueado');
  });

  testWidgets('recoger todas las fuentes desbloquea el avance',
      (tester) async {
    var avancesInvocados = 0;
    await bombearFase(
      tester,
      brecha: CatalogoBrechas.brecha11,
      alAvanzar: () => avancesInvocados++,
    );

    final totalFuentes = CatalogoBrechas.brecha11.fuentes.length;
    for (var i = 0; i < totalFuentes; i++) {
      final boton = find.text('AÑADIR A LA MESA').first;
      // Hace scroll en el ScrollView hasta que el botón esté visible
      // — el viewport de tests por defecto no muestra las 5 tarjetas
      // a la vez.
      await tester.scrollUntilVisible(boton, 80);
      await tester.tap(boton);
      await tester.pumpAndSettle();
    }

    expect(find.text('AÑADIR A LA MESA'), findsNothing);
    expect(find.text('EN LA MESA'), findsNWidgets(totalFuentes));
    expect(find.text('Recogidas: 5 / 5'), findsOneWidget);

    final cta = tester.widget<TextButton>(
      find.ancestor(
        of: find.text('IR A LA MESA DE TRABAJO'),
        matching: find.byType(TextButton),
      ),
    );
    expect(cta.onPressed, isNotNull);

    await tester.tap(find.text('IR A LA MESA DE TRABAJO'));
    await tester.pumpAndSettle();
    expect(avancesInvocados, 1);
  });

  testWidgets('fuentes recogidas en sesión previa aparecen ya marcadas',
      (tester) async {
    SharedPreferences.setMockInitialValues({
      'nuevoser.lasversiones.perfil_activo_id': 'principal',
      'nuevoser.lasversiones.perfiles_lista': <String>['principal'],
      'nuevoser.lasversiones.perfil.principal.brecha.1.1.fuente.'
          'restos_oseos_in_situ': true,
      'nuevoser.lasversiones.perfil.principal.brecha.1.1.fuente.'
          'toponimo_local': true,
    });
    await bombearFase(
      tester,
      brecha: CatalogoBrechas.brecha11,
      alAvanzar: () {},
    );

    expect(find.text('Recogidas: 2 / 5'), findsOneWidget);
    expect(find.text('EN LA MESA'), findsNWidgets(2));
    expect(find.text('AÑADIR A LA MESA'), findsNWidgets(3));
  });
}
