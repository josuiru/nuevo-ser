import 'package:el_cuaderno/datos/repositorio_aula_profesor.dart';
import 'package:el_cuaderno/datos/repositorio_perfil_cuaderno.dart';
import 'package:el_cuaderno/datos/repositorio_presentacion_sit_spot.dart';
import 'package:el_cuaderno/datos_simulados/seed.dart';
import 'package:el_cuaderno/infraestructura/memoria/repositorio_memoria.dart';
import 'package:el_cuaderno/main.dart';
import 'package:el_cuaderno/vista/pantalla_bienvenida_nombre.dart';
import 'package:el_cuaderno/vista/pantalla_configuracion_inicial.dart';
import 'package:el_cuaderno/vista/pantalla_cuaderno/pantalla_cuaderno.dart';
import 'package:el_cuaderno/vista/pantalla_sit_spot/pantalla_presentacion_sit_spot.dart';
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
    presentacionSitSpotVista.value = false;
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

  RepositorioCuentaBackend crearRepoCuentaProfesor() {
    return RepositorioCuentaBackend(
      prefs: SharedPreferences.getInstance,
      claveToken: 'nuevoser.elcuaderno.token_profesor',
      claveEmail: 'nuevoser.elcuaderno.email_profesor',
    );
  }

  RepositorioAulaProfesor crearRepoAulaProfesor() {
    return RepositorioAulaProfesor(
      prefs: SharedPreferences.getInstance,
      clave: 'nuevoser.elcuaderno.profesor.aula_activa',
    );
  }

  RepositorioPresentacionSitSpot crearRepoPresentacionSitSpot() {
    return RepositorioPresentacionSitSpot(
      prefs: SharedPreferences.getInstance,
    );
  }

  Future<AppElCuaderno> crearApp() async {
    return AppElCuaderno(
      repoIdioma: crearRepoIdioma(),
      repositorioCuaderno: await crearRepoCuaderno(),
      repoCuenta: crearRepoCuenta(),
      repoPerfil: RepositorioPerfilCuaderno(),
      repoCuentaProfesor: crearRepoCuentaProfesor(),
      repoAulaProfesor: crearRepoAulaProfesor(),
      repoPresentacionSitSpot: crearRepoPresentacionSitSpot(),
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
    expect(find.text('lee cómo se cuida tu cuaderno'), findsOneWidget);
  });

  testWidgets(
      'el enlace "lee cómo se cuida tu cuaderno" abre un diálogo de privacidad',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 1600));
    await tester.pumpWidget(await crearApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('lee cómo se cuida tu cuaderno'));
    await tester.pumpAndSettle();

    expect(find.text('cómo se cuida tu cuaderno'), findsOneWidget);
    expect(
      find.textContaining('Tu cuaderno es tuyo'),
      findsOneWidget,
    );
    // Sin haber elegido idioma todavía: sigue en la pantalla de
    // configuración inicial tras cerrar el diálogo.
    await tester.tap(find.text('Cerrar'));
    await tester.pumpAndSettle();
    expect(find.byType(PantallaConfiguracionInicial), findsOneWidget);
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
      'con idioma + perfil ya creado + presentación vista → salta directo a la pantalla principal',
      (tester) async {
    SharedPreferences.setMockInitialValues({
      'nuevoser.elcuaderno.idioma_app': 'es',
      'nuevoser.elcuaderno.perfil_activo_id': 'maren',
      'nuevoser.elcuaderno.perfiles_lista': '',
      'nuevoser.elcuaderno.presentacion_sit_spot.vista': true,
    });
    // Pre-poblar la lista de perfiles + el nombre del perfil activo.
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('nuevoser.elcuaderno.perfiles_lista', ['maren']);
    await prefs.setString('nuevoser.elcuaderno.perfil.maren.nombre_jugador', 'Maren');
    localeAppElCuaderno.value = const Locale('es');
    nombrePerfilElCuaderno.value = 'Maren';
    presentacionSitSpotVista.value = true;

    await tester.binding.setSurfaceSize(const Size(800, 1600));
    await tester.pumpWidget(await crearApp());
    await tester.pumpAndSettle();

    expect(find.byType(PantallaCuaderno), findsOneWidget);
    expect(find.byType(PantallaConfiguracionInicial), findsNothing);
    expect(find.byType(PantallaBienvenidaNombre), findsNothing);
    expect(find.byType(PantallaPresentacionSitSpot), findsNothing);
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
      'al confirmar nombre se crea el perfil y se muestra la presentación del sit spot',
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

    // Tras confirmar el nombre, NO salta a la pantalla principal:
    // queda en la presentación pedagógica del sit spot.
    expect(nombrePerfilElCuaderno.value, 'Maren');
    expect(find.byType(PantallaPresentacionSitSpot), findsOneWidget);
    expect(find.byType(PantallaCuaderno), findsNothing);

    final prefs = await SharedPreferences.getInstance();
    final perfiles = prefs.getStringList('nuevoser.elcuaderno.perfiles_lista');
    expect(perfiles, isNotNull);
    expect(perfiles, contains('maren'));
    expect(
      prefs.getString('nuevoser.elcuaderno.perfil.maren.nombre_jugador'),
      'Maren',
    );
  });

  testWidgets(
      'tras la bienvenida + presentación pulsando "ya pienso en uno" → PantallaCuaderno + flag persistido',
      (tester) async {
    SharedPreferences.setMockInitialValues({
      'nuevoser.elcuaderno.idioma_app': 'es',
      'nuevoser.elcuaderno.perfil_activo_id': 'maren',
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('nuevoser.elcuaderno.perfiles_lista', ['maren']);
    await prefs.setString(
      'nuevoser.elcuaderno.perfil.maren.nombre_jugador',
      'Maren',
    );
    localeAppElCuaderno.value = const Locale('es');
    nombrePerfilElCuaderno.value = 'Maren';
    // presentacionSitSpotVista queda en false (default del setUp).

    await tester.binding.setSurfaceSize(const Size(800, 1600));
    await tester.pumpWidget(await crearApp());
    await tester.pumpAndSettle();

    expect(find.byType(PantallaPresentacionSitSpot), findsOneWidget);
    expect(find.byType(PantallaCuaderno), findsNothing);

    await tester.tap(find.text('ya pienso en uno'));
    await tester.pumpAndSettle();

    expect(presentacionSitSpotVista.value, isTrue);
    expect(find.byType(PantallaCuaderno), findsOneWidget);
    expect(
      prefs.getBool('nuevoser.elcuaderno.presentacion_sit_spot.vista'),
      isTrue,
    );
  });

  testWidgets(
      'pulsando "todavía no" en la presentación también marca vista y va a PantallaCuaderno',
      (tester) async {
    SharedPreferences.setMockInitialValues({
      'nuevoser.elcuaderno.idioma_app': 'es',
      'nuevoser.elcuaderno.perfil_activo_id': 'maren',
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('nuevoser.elcuaderno.perfiles_lista', ['maren']);
    await prefs.setString(
      'nuevoser.elcuaderno.perfil.maren.nombre_jugador',
      'Maren',
    );
    localeAppElCuaderno.value = const Locale('es');
    nombrePerfilElCuaderno.value = 'Maren';

    await tester.binding.setSurfaceSize(const Size(800, 1600));
    await tester.pumpWidget(await crearApp());
    await tester.pumpAndSettle();

    expect(find.byType(PantallaPresentacionSitSpot), findsOneWidget);

    await tester.tap(find.text('todavía no'));
    await tester.pumpAndSettle();

    expect(presentacionSitSpotVista.value, isTrue);
    expect(find.byType(PantallaCuaderno), findsOneWidget);
    expect(
      prefs.getBool('nuevoser.elcuaderno.presentacion_sit_spot.vista'),
      isTrue,
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
