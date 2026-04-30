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

  Future<void> bombearPantalla(
    WidgetTester tester, {
    String? nombrePerfilActivo,
  }) async {
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
        home: PantallaCuaderno(
          repositorio: repositorio,
          estado: estado,
          nombrePerfilActivo: nombrePerfilActivo,
        ),
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

  testWidgets('muestra Misterios abiertos del catálogo seminal',
      (tester) async {
    await bombearPantalla(tester);
    // El home aplica `.take(3)` sobre el orden alfabético de las
    // preguntas; los tres primeros del seed seminal son lluvia,
    // dos pájaros pequeños marrones y encina vieja. La pestaña
    // Misterios del bottom nav (siempre montada en el `IndexedStack`)
    // los repite, así que estos dos del top-3 aparecen dos veces.
    expect(
      find.text(
        'Después de llover, ¿qué seres vivos aparecen?',
        skipOffstage: false,
      ),
      findsNWidgets(2),
    );
    expect(
      find.text(
        'La encina vieja del parque: ¿de qué año es?',
        skipOffstage: false,
      ),
      findsNWidgets(2),
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

  testWidgets(
    'jubilar sit spot: confirma → marca retiradoEn → home vuelve a invitación',
    (tester) async {
      await bombearPantalla(tester);

      // Estado inicial: el sit spot sembrado existe.
      expect(find.text('El Roble Grande'), findsWidgets);
      expect(await repositorio.obtenerSitSpot(), isNotNull);

      // Abrir el menú de la tarjeta y pulsar "jubilar este sit spot".
      await tester.tap(find.byTooltip('opciones del sit spot'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('jubilar este sit spot'));
      await tester.pumpAndSettle();

      // Confirmar el diálogo amable.
      expect(find.text('Jubilar este sit spot'), findsOneWidget);
      expect(
        find.textContaining('La página seguirá guardada en el cuaderno'),
        findsOneWidget,
      );
      await tester.tap(find.widgetWithText(FilledButton, 'jubilar'));
      await tester.pumpAndSettle();

      // El repo lo deja con retiradoEn poblado → obtenerSitSpot
      // devuelve null → home muestra la tarjeta de invitación.
      expect(await repositorio.obtenerSitSpot(), isNull);
      expect(find.text('El Roble Grande'), findsNothing);
      expect(
        find.textContaining('puedes hacerlo tu sit spot'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'jubilar sit spot: cancelar → no toca el repositorio',
    (tester) async {
      await bombearPantalla(tester);
      final antes = await repositorio.obtenerSitSpot();
      expect(antes, isNotNull);

      await tester.tap(find.byTooltip('opciones del sit spot'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('jubilar este sit spot'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(TextButton, 'cancelar'));
      await tester.pumpAndSettle();

      final despues = await repositorio.obtenerSitSpot();
      expect(despues, isNotNull);
      expect(despues!.id, antes!.id);
      expect(despues.retiradoEn, isNull);
      expect(find.text('El Roble Grande'), findsWidgets);
    },
  );

  testWidgets(
    'sin nombrePerfilActivo: el saludo cae al genérico "Hola."',
    (tester) async {
      await bombearPantalla(tester);
      expect(find.text('Hola.'), findsOneWidget);
    },
  );

  testWidgets(
    'con nombrePerfilActivo: el saludo personaliza con el nombre',
    (tester) async {
      await bombearPantalla(tester, nombrePerfilActivo: 'Maren');
      expect(find.text('Hola, Maren.'), findsOneWidget);
      // El genérico ya no debe aparecer en el árbol.
      expect(find.text('Hola.'), findsNothing);
    },
  );

  testWidgets(
    'nombrePerfilActivo con espacios en blanco se trata como vacío',
    (tester) async {
      await bombearPantalla(tester, nombrePerfilActivo: '   ');
      expect(find.text('Hola.'), findsOneWidget);
    },
  );

  testWidgets(
    'enlace "ver todas tus páginas" aparece si hay observaciones',
    (tester) async {
      await bombearPantalla(tester);
      // El seed siembra observaciones — el enlace está visible.
      expect(find.text('ver todas tus páginas'), findsOneWidget);
    },
  );

  testWidgets(
    'pulsar una tarjeta de Misterio abre PantallaPaginaMisterio',
    (tester) async {
      await bombearPantalla(tester);
      // El home muestra los 3 primeros Misterios abiertos por orden
      // alfabético. Pulsamos el de la lluvia (alfabéticamente entra).
      final preguntaLluvia = find.text(
        'Después de llover, ¿qué seres vivos aparecen?',
      );
      expect(preguntaLluvia, findsOneWidget);
      await tester.tap(preguntaLluvia);
      await tester.pumpAndSettle();

      // En la página del Misterio aparece la cabecera "Misterio" del
      // AppBar y el botón "anotar evidencia para este misterio".
      expect(find.text('Misterio'), findsOneWidget);
      expect(
        find.text('anotar evidencia para este misterio'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'pestaña Misterios del bottom nav lista todos los Misterios abiertos',
    (tester) async {
      await bombearPantalla(tester);
      // El seed deja 5 Misterios abiertos. El home muestra .take(3)
      // por orden alfabético: los tres primeros (lluvia, dos pájaros,
      // encina) caben; los dos últimos por código Unicode (los que
      // empiezan por "¿") sólo se ven en la pestaña Misterios.
      final misteriosAbiertos =
          await repositorio.obtenerMisteriosAbiertos();
      expect(misteriosAbiertos.length, 5);

      await tester.tap(find.text('misterios'));
      await tester.pumpAndSettle();

      // Estas dos preguntas no caben en el .take(3) del home, así que
      // la única razón por la que se vean es que la pestaña las pinta.
      expect(
        find.text(
          '¿Cuándo se fueron las golondrinas de tu barrio?',
          skipOffstage: false,
        ),
        findsOneWidget,
      );
      expect(
        find.text(
          '¿Por qué hay líquenes en este lado del muro y no en el otro?',
          skipOffstage: false,
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'pestaña Misterios: pulsar una tarjeta abre PantallaPaginaMisterio',
    (tester) async {
      await bombearPantalla(tester);
      await tester.tap(find.text('misterios'));
      await tester.pumpAndSettle();

      // Las golondrinas no caben en el .take(3) del home, así que aquí
      // es la única ocurrencia → no hay ambigüedad de tap entre dos
      // hijos del `IndexedStack`.
      final preguntaGolondrinas = find.text(
        '¿Cuándo se fueron las golondrinas de tu barrio?',
      );
      expect(preguntaGolondrinas, findsOneWidget);
      await tester.tap(preguntaGolondrinas);
      await tester.pumpAndSettle();

      expect(
        find.text('anotar evidencia para este misterio'),
        findsOneWidget,
      );
    },
  );
}
