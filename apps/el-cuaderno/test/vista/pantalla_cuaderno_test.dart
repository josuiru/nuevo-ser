import 'package:el_cuaderno/datos_simulados/seed.dart';
import 'package:el_cuaderno/infraestructura/memoria/repositorio_memoria.dart';
import 'package:el_cuaderno/nucleo/i18n/generado/textos_app.dart';
import 'package:el_cuaderno/vista/pantalla_cuaderno/estado_cuaderno.dart';
import 'package:el_cuaderno/vista/pantalla_cuaderno/pantalla_cuaderno.dart';
import 'package:el_cuaderno/vista/tema/tema.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late RepositorioMemoria repositorio;
  late EstadoCuaderno estado;

  setUp(() async {
    repositorio = RepositorioMemoria();
    await sembrarDatosDesarrollo(repositorio);
    estado = EstadoCuaderno(repositorio: repositorio);
  });

  tearDown(() {
    estado.dispose();
  });

  Future<void> bombearPantalla(WidgetTester tester) async {
    // El ListView crece más allá del viewport por defecto del
    // tester (800x600). Damos un viewport amplio para que todas las
    // secciones se renderen sin necesidad de scroll en los `find`.
    await tester.binding.setSurfaceSize(const Size(800, 1600));
    await tester.pumpWidget(
      MaterialApp(
        theme: TemaCuaderno.claro(),
        localizationsDelegates: TextosApp.localizationsDelegates,
        supportedLocales: TextosApp.supportedLocales,
        locale: const Locale('es'),
        home: PantallaCuaderno(repositorio: repositorio, estado: estado),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets(
    'renderiza con datos sembrados — muestra el sit spot El Roble Grande',
    (tester) async {
      await bombearPantalla(tester);
      expect(find.text('El Roble Grande'), findsWidgets);
    },
  );

  testWidgets('muestra los dos Misterios sembrados', (tester) async {
    await bombearPantalla(tester);
    expect(
      find.text(
        '¿Cuándo se van las golondrinas de tu barrio?',
        skipOffstage: false,
      ),
      findsOneWidget,
    );
    expect(
      find.text(
        'Después de llover, ¿qué seres vivos aparecen que no estaban antes?',
        skipOffstage: false,
      ),
      findsOneWidget,
    );
  });

  testWidgets('el bottom nav tiene 4 pestañas', (tester) async {
    await bombearPantalla(tester);
    final navigationBar = find.byType(NavigationBar);
    expect(navigationBar, findsOneWidget);
    final destinations = find.descendant(
      of: navigationBar,
      matching: find.byType(NavigationDestination),
    );
    expect(destinations, findsNWidgets(4));
  });

  testWidgets(
    'la sección última página muestra la observación más reciente',
    (tester) async {
      await bombearPantalla(tester);
      expect(
        find.textContaining('Tres pájaros pequeños marrones',
            skipOffstage: false),
        findsOneWidget,
      );
    },
  );
}
