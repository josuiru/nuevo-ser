import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nuevo_ser_core/nuevo_ser_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:las_versiones/main.dart';
import 'package:las_versiones/vista/pantalla_configuracion_inicial.dart';
import 'package:las_versiones/vista/pantalla_esqueleto.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    localeAppLasVersiones.value = null;
  });

  RepositorioIdiomaApp crearRepositorio() {
    return RepositorioIdiomaApp(
      prefs: SharedPreferences.getInstance,
      clave: 'nuevoser.lasversiones.idioma_app',
    );
  }

  testWidgets(
      'primer arranque sin idioma → muestra PantallaConfiguracionInicial',
      (tester) async {
    await tester.pumpWidget(AppLasVersiones(repoIdioma: crearRepositorio()));
    await tester.pumpAndSettle();

    expect(find.byType(PantallaConfiguracionInicial), findsOneWidget);
    expect(find.byType(PantallaEsqueleto), findsNothing);
    expect(find.text('LAS VERSIONES'), findsOneWidget);
    expect(find.text('Castellano'), findsOneWidget);
    expect(find.text('Euskara'), findsOneWidget);
    expect(find.text('Català'), findsOneWidget);
  });

  testWidgets(
      'arranque con idioma persistido → salta directo al esqueleto',
      (tester) async {
    SharedPreferences.setMockInitialValues({
      'nuevoser.lasversiones.idioma_app': 'eu',
    });

    await tester.pumpWidget(AppLasVersiones(repoIdioma: crearRepositorio()));
    await tester.pumpAndSettle();

    expect(find.byType(PantallaEsqueleto), findsOneWidget);
    expect(find.byType(PantallaConfiguracionInicial), findsNothing);
  });

  testWidgets('elegir idioma persiste y avanza al esqueleto',
      (tester) async {
    final repositorio = crearRepositorio();
    await tester.pumpWidget(AppLasVersiones(repoIdioma: repositorio));
    await tester.pumpAndSettle();

    expect(find.byType(PantallaConfiguracionInicial), findsOneWidget);

    await tester.tap(find.text('Català'));
    await tester.pumpAndSettle();

    expect(find.byType(PantallaEsqueleto), findsOneWidget);
    expect(await repositorio.cargar(), 'ca',
        reason: 'la elección debe persistir bajo la clave del juego');
    expect(localeAppLasVersiones.value, const Locale('ca'),
        reason: 'el ValueNotifier global debe quedar en sincronía');
  });

  test('clave de prefs sigue el namespace nuevoser.lasversiones.*', () async {
    SharedPreferences.setMockInitialValues({
      'nuevoser.lasversiones.idioma_app': 'es',
    });
    final repositorio = crearRepositorio();

    expect(await repositorio.cargar(), 'es');

    // Una clave con el prefijo "lasversiones.*" (sin el namespace
    // canónico) NO debe verse desde el repositorio. Esto protege la
    // convención del CLAUDE.md raíz contra regresiones.
    SharedPreferences.setMockInitialValues({
      'lasversiones.idioma_app': 'eu',
    });
    final repositorio2 = crearRepositorio();
    expect(await repositorio2.cargar(), isNull,
        reason: 'el repositorio sólo lee la clave canónica nuevoser.*');
  });
}
