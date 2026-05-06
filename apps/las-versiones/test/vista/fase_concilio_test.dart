import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nuevo_ser_core/nuevo_ser_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:las_versiones/datos/repositorio_reconstruccion.dart';
import 'package:las_versiones/dominio/brecha.dart';
import 'package:las_versiones/dominio/catalogo_brechas.dart';
import 'package:las_versiones/vista/fase_concilio.dart';

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
  Future<void> bombearFase(
    WidgetTester tester, {
    required Brecha brecha,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: FaseConcilio(
              brecha: brecha,
              repoReconstruccion: RepositorioReconstruccion(
                gestor: _gestorDePrueba(),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('sin reconstrucción guardada → mensaje vacío explicativo',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    await bombearFase(tester, brecha: CatalogoBrechas.brecha11);
    expect(find.textContaining('No has declarado'), findsOneWidget);
    expect(find.text('TU CALIBRACIÓN'), findsNothing);
  });

  testWidgets(
      'tres afirmaciones todas con calibración correcta → score 100 + '
      'mensaje de buen oficio', (tester) async {
    SharedPreferences.setMockInitialValues({
      'nuevoser.lasversiones.perfil_activo_id': 'principal',
      'nuevoser.lasversiones.perfiles_lista': <String>['principal'],
      'nuevoser.lasversiones.perfil.principal.brecha.1.1.reconstruccion':
          '{"es_un_enterramiento":"solido",'
              '"fechado_neolitico":"solido",'
              '"funcion_ritual":"probable"}',
    });
    await bombearFase(tester, brecha: CatalogoBrechas.brecha11);

    expect(find.text('TU CALIBRACIÓN'), findsOneWidget);
    expect(
      find.textContaining('Acertaste el nivel de confianza en 3 de 3'),
      findsOneWidget,
    );
    expect(find.textContaining('Score de calibración: 100'), findsOneWidget);
    expect(find.textContaining('Buen oficio'), findsOneWidget);
  });

  testWidgets(
      'todas mal calibradas → score 0 + mensaje de aprender del desencaje',
      (tester) async {
    SharedPreferences.setMockInitialValues({
      'nuevoser.lasversiones.perfil_activo_id': 'principal',
      'nuevoser.lasversiones.perfiles_lista': <String>['principal'],
      'nuevoser.lasversiones.perfil.principal.brecha.1.1.reconstruccion':
          '{"numero_personas_enterradas":"solido",'
              '"origen_atlantico":"solido",'
              '"funcion_ritual":"disputado"}',
    });
    await bombearFase(tester, brecha: CatalogoBrechas.brecha11);

    expect(
      find.textContaining('Acertaste el nivel de confianza en 0 de 3'),
      findsOneWidget,
    );
    expect(find.textContaining('Score de calibración: 0'), findsOneWidget);
    expect(find.textContaining('No has calibrado bien'), findsOneWidget);
  });

  testWidgets(
      'aciertos parciales (2 de 3 — score ~67%) → mensaje "vas en el oficio"',
      (tester) async {
    SharedPreferences.setMockInitialValues({
      'nuevoser.lasversiones.perfil_activo_id': 'principal',
      'nuevoser.lasversiones.perfiles_lista': <String>['principal'],
      'nuevoser.lasversiones.perfil.principal.brecha.1.1.reconstruccion':
          '{"es_un_enterramiento":"solido",'
              '"fechado_neolitico":"solido",'
              '"numero_personas_enterradas":"solido"}',
    });
    await bombearFase(tester, brecha: CatalogoBrechas.brecha11);

    expect(
      find.textContaining('Acertaste el nivel de confianza en 2 de 3'),
      findsOneWidget,
    );
    expect(find.textContaining('Vas en el oficio'), findsOneWidget);
  });

  testWidgets('cada afirmación declarada aparece con su línea de comparación',
      (tester) async {
    SharedPreferences.setMockInitialValues({
      'nuevoser.lasversiones.perfil_activo_id': 'principal',
      'nuevoser.lasversiones.perfiles_lista': <String>['principal'],
      'nuevoser.lasversiones.perfil.principal.brecha.1.1.reconstruccion':
          '{"es_un_enterramiento":"solido"}',
    });
    await bombearFase(tester, brecha: CatalogoBrechas.brecha11);

    expect(find.textContaining('En este lugar se realizaron enterramientos'),
        findsOneWidget);
    expect(find.text('TÚ DIJISTE'), findsOneWidget);
    expect(find.text('EL OFICIO DICE'), findsOneWidget);
  });
}
