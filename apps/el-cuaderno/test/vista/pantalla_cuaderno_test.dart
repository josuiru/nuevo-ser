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

  // Fecha por defecto: 2026-05-01 (primavera). Tests deterministas
  // contra el filtrado fenológico que aplica `EstadoCuaderno`. Los
  // tests que necesitan otra estación reconstruyen `estado` antes de
  // bombear con un proveedor distinto (ver el bloque de "pestaña
  // Misterios").
  DateTime ahoraPrimavera() => DateTime(2026, 5, 1);

  setUp(() async {
    repositorio = RepositorioMemoria();
    await sembrarDatosDesarrollo(repositorio);
    estado = EstadoCuaderno(
      repositorio: repositorio,
      proveedorAhora: ahoraPrimavera,
    );
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
      // Las golondrinas (seasons=[verano, otono]) son uno de los 5
      // abiertos del seed; en primavera se filtrarían fuera. Para que
      // este test compruebe el caso interesante (Misterios abiertos
      // que NO caben en el top-3 del home) lo bombeamos con una fecha
      // de otoño donde todos los abiertos del seed aplican.
      estado.dispose();
      estado = EstadoCuaderno(
        repositorio: repositorio,
        proveedorAhora: () => DateTime(2026, 10, 15),
      );
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
      // Igual que el test anterior: forzamos otoño para que las
      // golondrinas pasen el filtro fenológico.
      estado.dispose();
      estado = EstadoCuaderno(
        repositorio: repositorio,
        proveedorAhora: () => DateTime(2026, 10, 15),
      );
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

  testWidgets(
    'pulsar la tarjeta del sit spot activo abre PantallaPaginaSitSpot',
    (tester) async {
      await bombearPantalla(tester);
      // El home muestra la tarjeta del sit spot sembrado.
      expect(find.text('El Roble Grande'), findsWidgets);
      // Pulsamos en el nombre del sit spot (la tarjeta entera es
      // pulsable; el InkWell propaga el tap).
      await tester.tap(find.text('El Roble Grande').first);
      await tester.pumpAndSettle();

      // En la página del sit spot aparece la cabecera "Activo desde".
      expect(find.textContaining('Activo desde'), findsOneWidget);
      expect(find.text('anotar observación aquí'), findsOneWidget);
    },
  );

  testWidgets(
    'pulsar la última página del home abre PantallaDetalleObservacion',
    (tester) async {
      await bombearPantalla(tester);
      // El seed tiene como última observación "Tres pájaros pequeños
      // marrones..." — destacada en SeccionUltimaPagina.
      final ultima = find.textContaining('Tres pájaros pequeños marrones');
      expect(ultima, findsOneWidget);
      await tester.tap(ultima);
      await tester.pumpAndSettle();

      // La pantalla de detalle abre con "Página del cuaderno" en el
      // AppBar.
      expect(find.text('Página del cuaderno'), findsOneWidget);
    },
  );

  testWidgets(
    'tarjeta del Misterio muestra el contador de evidencias del repo',
    (tester) async {
      await bombearPantalla(tester);
      // El seed siembra una observación contra el Misterio "lluvia"
      // (seed-misterio-lluvia) — la tarjeta de ese misterio en el
      // home debe contar 1 evidencia. La cabecera completa es
      // "hipótesis activa · 1 evidencia anotada" porque el seed
      // marca lluvia como hipotesisActiva.
      // El IndexedStack mantiene el home + la pestaña Misterios; el
      // mismo Misterio aparece en ambos.
      expect(
        find.text(
          'consenso · 1 evidencia anotada',
          skipOffstage: false,
        ),
        findsAtLeastNWidgets(1),
      );
      // Otros Misterios sin evidencias muestran "todavía no...".
      expect(
        find.textContaining(
          'todavía no has anotado nada',
          skipOffstage: false,
        ),
        findsAtLeastNWidgets(1),
      );
    },
  );

  testWidgets(
    'filtrado fenológico: en primavera las golondrinas (verano+otoño) '
    'no aparecen',
    (tester) async {
      // setUp ya construye `estado` con proveedor de primavera.
      await bombearPantalla(tester);
      expect(
        find.text(
          '¿Cuándo se fueron las golondrinas de tu barrio?',
          skipOffstage: false,
        ),
        findsNothing,
      );
    },
  );

  testWidgets(
    'filtrado fenológico: en otoño las golondrinas sí aparecen',
    (tester) async {
      estado.dispose();
      estado = EstadoCuaderno(
        repositorio: repositorio,
        proveedorAhora: () => DateTime(2026, 10, 15),
      );
      await bombearPantalla(tester);
      expect(
        find.text(
          '¿Cuándo se fueron las golondrinas de tu barrio?',
          skipOffstage: false,
        ),
        findsAtLeastNWidgets(1),
      );
    },
  );

  testWidgets(
    'tip fenológico: el home muestra una nota del catálogo bajo el saludo',
    (tester) async {
      // Sit spot del seed no tiene coordenadas → regionActual = null
      // → fallback país. En primavera 'ES' tiene una nota de
      // fallback ("Hay más cantos al amanecer..."). Como la lista
      // tiene solo 1 nota, el índice del día siempre cae en 0.
      await bombearPantalla(tester);
      expect(
        find.text(
          'Hay más cantos al amanecer que en cualquier otra estación.',
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'ventana caliente: el Misterio de la lluvia destaca "estos días" al '
    'entrar el otoño',
    (tester) async {
      // 1 octubre 2026: estación = otoño; hace 21 días (10 sep) =
      // verano. El Misterio de la lluvia (seasons: [primavera, otono])
      // aplica hoy y NO aplicaba hace 21 días → ventana caliente.
      // El Misterio de las golondrinas (seasons: [verano, otono])
      // aplica hoy PERO también hace 21 días → no caliente.
      estado.dispose();
      estado = EstadoCuaderno(
        repositorio: repositorio,
        proveedorAhora: () => DateTime(2026, 10, 1),
      );
      await bombearPantalla(tester);

      expect(
        find.text(
          'estos días · consenso · 1 evidencia anotada',
          skipOffstage: false,
        ),
        findsAtLeastNWidgets(1),
        reason: 'la tarjeta de la lluvia debe llevar el prefijo "estos días"',
      );
      // Las golondrinas siguen visibles (otoño aplica) pero sin el
      // prefijo: ya aplicaban en verano.
      expect(
        find.text(
          '¿Cuándo se fueron las golondrinas de tu barrio?',
          skipOffstage: false,
        ),
        findsAtLeastNWidgets(1),
      );
      expect(
        find.textContaining(
          'estos días · hipótesis activa',
          skipOffstage: false,
        ),
        findsNothing,
        reason: 'las golondrinas (hipótesis activa) ya aplicaban en verano',
      );
    },
  );
}
