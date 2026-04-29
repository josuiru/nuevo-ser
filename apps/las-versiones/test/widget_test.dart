import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nuevo_ser_core/nuevo_ser_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:las_versiones/datos/repositorio_estado_brecha.dart';
import 'package:las_versiones/datos/repositorio_flags_narrativos.dart';
import 'package:las_versiones/main.dart';
import 'package:las_versiones/vista/pantalla_brecha.dart';
import 'package:las_versiones/vista/pantalla_cinematica.dart';
import 'package:las_versiones/vista/pantalla_configuracion_inicial.dart';
import 'package:las_versiones/vista/pantalla_esqueleto.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    localeAppLasVersiones.value = null;
  });

  RepositorioIdiomaApp crearRepoIdioma() {
    return RepositorioIdiomaApp(
      prefs: SharedPreferences.getInstance,
      clave: 'nuevoser.lasversiones.idioma_app',
    );
  }

  RepositorioFlagsNarrativos crearRepoFlags() {
    return const RepositorioFlagsNarrativos();
  }

  RepositorioEstadoBrecha crearRepoEstadoBrecha() {
    return const RepositorioEstadoBrecha();
  }

  AppLasVersiones crearApp() {
    return AppLasVersiones(
      repoIdioma: crearRepoIdioma(),
      repoFlags: crearRepoFlags(),
      repoEstadoBrecha: crearRepoEstadoBrecha(),
    );
  }

  testWidgets(
      'primer arranque sin idioma → muestra PantallaConfiguracionInicial',
      (tester) async {
    await tester.pumpWidget(crearApp());
    await tester.pumpAndSettle();

    expect(find.byType(PantallaConfiguracionInicial), findsOneWidget);
    expect(find.byType(PantallaEsqueleto), findsNothing);
    expect(find.byType(PantallaCinematica), findsNothing);
    expect(find.text('LAS VERSIONES'), findsOneWidget);
    expect(find.text('Castellano'), findsOneWidget);
    expect(find.text('Euskara'), findsOneWidget);
    expect(find.text('Català'), findsOneWidget);
  });

  testWidgets(
      'arranque con idioma persistido y todas las unidades del Arco 1 '
      'cerradas → salta directo al esqueleto', (tester) async {
    SharedPreferences.setMockInitialValues({
      'nuevoser.lasversiones.idioma_app': 'eu',
      'nuevoser.lasversiones.flag.escena_1_0_1_vista': true,
      'nuevoser.lasversiones.flag.escena_1_0_2_vista': true,
      'nuevoser.lasversiones.flag.escena_1_0_3_vista': true,
      'nuevoser.lasversiones.flag.escena_1_1_1_vista': true,
      'nuevoser.lasversiones.flag.escena_1_1_2_vista': true,
      'nuevoser.lasversiones.flag.aralar_dolmen_alcanzado': true,
      'nuevoser.lasversiones.flag.brecha_1_1_completada': true,
      'nuevoser.lasversiones.flag.escena_1_1_7_vista': true,
    });

    await tester.pumpWidget(crearApp());
    await tester.pumpAndSettle();

    expect(find.byType(PantallaEsqueleto), findsOneWidget);
    expect(find.byType(PantallaCinematica), findsNothing);
    expect(find.byType(PantallaBrecha), findsNothing);
    expect(find.byType(PantallaConfiguracionInicial), findsNothing);
  });

  testWidgets(
      'arranque con cinemática 1.1.2 cerrada y Brecha 1.1 sin completar → '
      'abre la PantallaBrecha en fase formulación', (tester) async {
    SharedPreferences.setMockInitialValues({
      'nuevoser.lasversiones.idioma_app': 'es',
      'nuevoser.lasversiones.flag.escena_1_0_1_vista': true,
      'nuevoser.lasversiones.flag.escena_1_0_2_vista': true,
      'nuevoser.lasversiones.flag.escena_1_0_3_vista': true,
      'nuevoser.lasversiones.flag.escena_1_1_1_vista': true,
      'nuevoser.lasversiones.flag.escena_1_1_2_vista': true,
      'nuevoser.lasversiones.flag.aralar_dolmen_alcanzado': true,
      // brecha_1_1_completada NO está → la brecha está abierta
    });

    await tester.pumpWidget(crearApp());
    await tester.pumpAndSettle();

    expect(find.byType(PantallaBrecha), findsOneWidget);
    expect(find.byType(PantallaCinematica), findsNothing);
    expect(find.text('ARALAR — DOLMEN DE AROZTEGI'), findsOneWidget);
    expect(find.textContaining('FASE 1'), findsOneWidget);
  });

  testWidgets(
      'completar la Brecha 1.1 marca su flag y libera la cinemática 1.1.7',
      (tester) async {
    SharedPreferences.setMockInitialValues({
      'nuevoser.lasversiones.idioma_app': 'es',
      'nuevoser.lasversiones.flag.escena_1_0_1_vista': true,
      'nuevoser.lasversiones.flag.escena_1_0_2_vista': true,
      'nuevoser.lasversiones.flag.escena_1_0_3_vista': true,
      'nuevoser.lasversiones.flag.escena_1_1_1_vista': true,
      'nuevoser.lasversiones.flag.escena_1_1_2_vista': true,
      'nuevoser.lasversiones.flag.aralar_dolmen_alcanzado': true,
      // Forzamos arranque ya en Concilio para no andar pulsando 4 veces.
      'nuevoser.lasversiones.brecha.1.1.fase': 'concilio',
    });

    await tester.pumpWidget(crearApp());
    await tester.pumpAndSettle();

    expect(find.byType(PantallaBrecha), findsOneWidget);
    expect(find.text('CERRAR LA BRECHA'), findsOneWidget);

    await tester.tap(find.text('CERRAR LA BRECHA'));
    await tester.pumpAndSettle();

    // Tras cerrar, la cinemática 1.1.7 (que requiere
    // brecha_1_1_completada) debe arrancar.
    expect(find.byType(PantallaCinematica), findsOneWidget);
    expect(find.byType(PantallaBrecha), findsNothing);

    final repoFlags = crearRepoFlags();
    expect(await repoFlags.estaActivo('brecha_1_1_completada'), isTrue);
  });

  testWidgets(
      'arranque con idioma persistido y escena 1.0.1 sin ver → '
      'reproduce la cinemática', (tester) async {
    SharedPreferences.setMockInitialValues({
      'nuevoser.lasversiones.idioma_app': 'es',
    });

    await tester.pumpWidget(crearApp());
    await tester.pumpAndSettle();

    expect(find.byType(PantallaCinematica), findsOneWidget,
        reason: 'la primera cinemática debe arrancar al volver con idioma '
            'pero sin haberla vivido aún');
    expect(find.byType(PantallaEsqueleto), findsNothing);
  });

  testWidgets('elegir idioma persiste y arranca la cinemática 1.0.1',
      (tester) async {
    final repoIdioma = crearRepoIdioma();
    await tester.pumpWidget(AppLasVersiones(
      repoIdioma: repoIdioma,
      repoFlags: crearRepoFlags(),
      repoEstadoBrecha: crearRepoEstadoBrecha(),
    ));
    await tester.pumpAndSettle();

    expect(find.byType(PantallaConfiguracionInicial), findsOneWidget);

    await tester.tap(find.text('Català'));
    await tester.pumpAndSettle();

    expect(find.byType(PantallaCinematica), findsOneWidget,
        reason: 'tras elegir idioma toca empezar la primera cinemática');
    expect(await repoIdioma.cargar(), 'ca',
        reason: 'la elección debe persistir bajo la clave del juego');
    expect(localeAppLasVersiones.value, const Locale('ca'),
        reason: 'el ValueNotifier global debe quedar en sincronía');
  });

  test('clave de prefs del idioma sigue el namespace '
      'nuevoser.lasversiones.*', () async {
    SharedPreferences.setMockInitialValues({
      'nuevoser.lasversiones.idioma_app': 'es',
    });
    final repositorio = crearRepoIdioma();

    expect(await repositorio.cargar(), 'es');

    // Una clave con el prefijo "lasversiones.*" (sin el namespace
    // canónico) NO debe verse desde el repositorio. Esto protege la
    // convención del CLAUDE.md raíz contra regresiones.
    SharedPreferences.setMockInitialValues({
      'lasversiones.idioma_app': 'eu',
    });
    final repositorio2 = crearRepoIdioma();
    expect(await repositorio2.cargar(), isNull,
        reason: 'el repositorio sólo lee la clave canónica nuevoser.*');
  });
}
