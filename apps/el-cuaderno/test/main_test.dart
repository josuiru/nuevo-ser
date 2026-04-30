import 'package:el_cuaderno/datos_simulados/seed.dart';
import 'package:el_cuaderno/infraestructura/memoria/repositorio_memoria.dart';
import 'package:el_cuaderno/main.dart';
import 'package:el_cuaderno/vista/pantalla_configuracion_inicial.dart';
import 'package:el_cuaderno/vista/pantalla_cuaderno/pantalla_cuaderno.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nuevo_ser_core/nuevo_ser_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Tests del orquestador de El Cuaderno (S2-C):
/// - clave de prefs sigue el namespace `nuevoser.elcuaderno.*`,
/// - sin idioma → [PantallaConfiguracionInicial],
/// - con idioma persistido → [PantallaCuaderno],
/// - elegir un idioma persiste y el `ValueNotifier` global se actualiza.
void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    localeAppElCuaderno.value = null;
  });

  RepositorioIdiomaApp crearRepoIdioma() {
    return RepositorioIdiomaApp(
      prefs: SharedPreferences.getInstance,
      clave: 'nuevoser.elcuaderno.idioma_app',
    );
  }

  Future<RepositorioMemoria> crearRepoCuaderno() async {
    final repositorio = RepositorioMemoria();
    await sembrarDatosDesarrollo(repositorio);
    return repositorio;
  }

  Future<AppElCuaderno> crearApp() async {
    return AppElCuaderno(
      repoIdioma: crearRepoIdioma(),
      repositorioCuaderno: await crearRepoCuaderno(),
    );
  }

  testWidgets(
      'primer arranque sin idioma → muestra PantallaConfiguracionInicial',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 1600));
    await tester.pumpWidget(await crearApp());
    await tester.pumpAndSettle();

    expect(find.byType(PantallaConfiguracionInicial), findsOneWidget);
    expect(find.byType(PantallaCuaderno), findsNothing);
    expect(find.text('el cuaderno'), findsOneWidget);
    expect(find.text('Castellano'), findsOneWidget);
    expect(find.text('Euskara'), findsOneWidget);
    expect(find.text('Català'), findsOneWidget);
  });

  testWidgets(
      'arranque con idioma persistido → salta directo a la pantalla principal',
      (tester) async {
    SharedPreferences.setMockInitialValues({
      'nuevoser.elcuaderno.idioma_app': 'es',
    });
    localeAppElCuaderno.value = const Locale('es');

    await tester.binding.setSurfaceSize(const Size(800, 1600));
    await tester.pumpWidget(await crearApp());
    await tester.pumpAndSettle();

    expect(find.byType(PantallaCuaderno), findsOneWidget);
    expect(find.byType(PantallaConfiguracionInicial), findsNothing);
  });

  testWidgets(
      'al elegir un idioma se persiste y el ValueNotifier global se actualiza',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 1600));
    await tester.pumpWidget(await crearApp());
    await tester.pumpAndSettle();

    expect(localeAppElCuaderno.value, isNull);

    await tester.tap(find.text('Euskara'));
    await tester.pumpAndSettle();

    expect(localeAppElCuaderno.value, const Locale('eu'));
    expect(find.byType(PantallaCuaderno), findsOneWidget);

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('nuevoser.elcuaderno.idioma_app'), 'eu');
  });

  test(
      'la clave de prefs sigue el namespace nuevoser.elcuaderno.* (regresión)',
      () async {
    SharedPreferences.setMockInitialValues({});
    final repo = crearRepoIdioma();
    await repo.guardar('ca');

    final prefs = await SharedPreferences.getInstance();
    expect(
      prefs.getKeys().any((c) => c.startsWith('nuevoser.elcuaderno.')),
      isTrue,
    );
    expect(prefs.getString('nuevoser.elcuaderno.idioma_app'), 'ca');
  });
}
