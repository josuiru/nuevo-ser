import 'package:el_cuaderno/datos/repositorio_perfil_cuaderno.dart';
import 'package:el_cuaderno/datos_simulados/seed.dart';
import 'package:el_cuaderno/infraestructura/memoria/repositorio_memoria.dart';
import 'package:el_cuaderno/main.dart';
import 'package:el_cuaderno/vista/pantalla_bienvenida_nombre.dart';
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
    nombrePerfilElCuaderno.value = null;
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

  RepositorioCuentaBackend crearRepoCuenta() {
    return RepositorioCuentaBackend(
      prefs: SharedPreferences.getInstance,
      claveToken: 'nuevoser.elcuaderno.token_backend',
      claveEmail: 'nuevoser.elcuaderno.email_backend',
    );
  }

  Future<AppElCuaderno> crearApp() async {
    return AppElCuaderno(
      repoIdioma: crearRepoIdioma(),
      repositorioCuaderno: await crearRepoCuaderno(),
      repoCuenta: crearRepoCuenta(),
      repoPerfil: RepositorioPerfilCuaderno(),
    );
  }

  testWidgets(
      'primer arranque sin idioma → muestra PantallaConfiguracionInicial',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 1600));
    await tester.pumpWidget(await crearApp());
    await tester.pumpAndSettle();

    expect(find.byType(PantallaConfiguracionInicial), findsOneWidget);
    expect(find.byType(PantallaBienvenidaNombre), findsNothing);
    expect(find.byType(PantallaCuaderno), findsNothing);
    expect(find.text('el cuaderno'), findsOneWidget);
    expect(find.text('Castellano'), findsOneWidget);
    expect(find.text('Euskara'), findsOneWidget);
    expect(find.text('Català'), findsOneWidget);
  });

  testWidgets(
      'con idioma sin perfil → muestra PantallaBienvenidaNombre',
      (tester) async {
    SharedPreferences.setMockInitialValues({
      'nuevoser.elcuaderno.idioma_app': 'es',
    });
    localeAppElCuaderno.value = const Locale('es');

    await tester.binding.setSurfaceSize(const Size(800, 1600));
    await tester.pumpWidget(await crearApp());
    await tester.pumpAndSettle();

    expect(find.byType(PantallaBienvenidaNombre), findsOneWidget);
    expect(find.byType(PantallaCuaderno), findsNothing);
    expect(find.text('¿Cómo te llamas?'), findsOneWidget);
  });

  testWidgets(
      'con idioma + perfil ya creado → salta directo a la pantalla principal',
      (tester) async {
    SharedPreferences.setMockInitialValues({
      'nuevoser.elcuaderno.idioma_app': 'es',
      'nuevoser.elcuaderno.perfil_activo_id': 'maren',
      'nuevoser.elcuaderno.perfiles_lista': '',
    });
    // Pre-poblar la lista de perfiles + el nombre del perfil activo.
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('nuevoser.elcuaderno.perfiles_lista', ['maren']);
    await prefs.setString('nuevoser.elcuaderno.perfil.maren.nombre_jugador', 'Maren');
    localeAppElCuaderno.value = const Locale('es');
    nombrePerfilElCuaderno.value = 'Maren';

    await tester.binding.setSurfaceSize(const Size(800, 1600));
    await tester.pumpWidget(await crearApp());
    await tester.pumpAndSettle();

    expect(find.byType(PantallaCuaderno), findsOneWidget);
    expect(find.byType(PantallaConfiguracionInicial), findsNothing);
    expect(find.byType(PantallaBienvenidaNombre), findsNothing);
  });

  testWidgets(
      'al elegir un idioma se persiste y se muestra la pantalla de bienvenida',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 1600));
    await tester.pumpWidget(await crearApp());
    await tester.pumpAndSettle();

    expect(localeAppElCuaderno.value, isNull);

    await tester.tap(find.text('Euskara'));
    await tester.pumpAndSettle();

    expect(localeAppElCuaderno.value, const Locale('eu'));
    // Tras elegir idioma, NO salta a PantallaCuaderno: queda en bienvenida.
    expect(find.byType(PantallaBienvenidaNombre), findsOneWidget);

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('nuevoser.elcuaderno.idioma_app'), 'eu');
  });

  testWidgets(
      'al confirmar nombre se crea el perfil y se muestra PantallaCuaderno',
      (tester) async {
    SharedPreferences.setMockInitialValues({
      'nuevoser.elcuaderno.idioma_app': 'es',
    });
    localeAppElCuaderno.value = const Locale('es');

    await tester.binding.setSurfaceSize(const Size(800, 1600));
    await tester.pumpWidget(await crearApp());
    await tester.pumpAndSettle();

    expect(find.byType(PantallaBienvenidaNombre), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'Maren');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continuar'));
    await tester.pumpAndSettle();

    expect(nombrePerfilElCuaderno.value, 'Maren');
    expect(find.byType(PantallaCuaderno), findsOneWidget);

    final prefs = await SharedPreferences.getInstance();
    final perfiles = prefs.getStringList('nuevoser.elcuaderno.perfiles_lista');
    expect(perfiles, isNotNull);
    expect(perfiles, contains('maren'));
    expect(
      prefs.getString('nuevoser.elcuaderno.perfil.maren.nombre_jugador'),
      'Maren',
    );
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
