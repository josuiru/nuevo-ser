import 'package:el_cuaderno/dominio/nivel_confianza.dart';
import 'package:el_cuaderno/dominio/observacion.dart';
import 'package:el_cuaderno/infraestructura/memoria/repositorio_memoria.dart';
import 'package:el_cuaderno/nucleo/i18n/generado/textos_app.dart';
import 'package:el_cuaderno/vista/pantalla_observaciones/pantalla_lista_observaciones.dart';
import 'package:el_cuaderno/vista/tema/tema.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late RepositorioMemoria repositorio;

  setUp(() {
    repositorio = RepositorioMemoria();
  });

  Future<void> bombear(WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 1200));
    await tester.pumpWidget(MaterialApp(
      theme: TemaCuaderno.claro(),
      localizationsDelegates: TextosApp.localizationsDelegates,
      supportedLocales: TextosApp.supportedLocales,
      locale: const Locale('es'),
      home: PantallaListaObservaciones(repositorio: repositorio),
    ));
    await tester.pumpAndSettle();
  }

  Future<void> sembrar({
    required String id,
    required String queVio,
    String? creesQueEs,
    String dondeNombre = 'parque',
    DateTime? cuandoOcurrio,
  }) async {
    await repositorio.guardarObservacion(Observacion(
      id: id,
      cuandoCreada: cuandoOcurrio ?? DateTime(2026, 4, 30),
      cuandoOcurrio: cuandoOcurrio ?? DateTime(2026, 4, 30),
      dondeNombre: dondeNombre,
      queVio: queVio,
      creesQueEs: creesQueEs,
      confianza: NivelConfianza.hipotesisActiva,
    ));
  }

  testWidgets('cuaderno vacío: muestra microcopia de estado vacío',
      (tester) async {
    await bombear(tester);
    expect(
      find.textContaining('Aún no has anotado nada'),
      findsOneWidget,
    );
  });

  testWidgets('lista todas las observaciones cuando no hay búsqueda activa',
      (tester) async {
    await sembrar(id: '1', queVio: 'pájaro pequeño');
    await sembrar(id: '2', queVio: 'flor amarilla');
    await sembrar(id: '3', queVio: 'hoja seca');
    await bombear(tester);
    expect(find.textContaining('pájaro pequeño'), findsOneWidget);
    expect(find.textContaining('flor amarilla'), findsOneWidget);
    expect(find.textContaining('hoja seca'), findsOneWidget);
  });

  testWidgets('filtra por queVio (case-insensitive)', (tester) async {
    await sembrar(id: '1', queVio: 'pájaro pequeño marrón');
    await sembrar(id: '2', queVio: 'flor amarilla');
    await bombear(tester);
    await tester.enterText(find.byType(TextField), 'PAJARO');
    await tester.pump();
    expect(find.textContaining('pájaro'), findsOneWidget);
    expect(find.textContaining('flor amarilla'), findsNothing);
  });

  testWidgets('filtra por creesQueEs', (tester) async {
    await sembrar(id: '1', queVio: 'algo en el agua', creesQueEs: 'mirlo');
    await sembrar(id: '2', queVio: 'algo más', creesQueEs: 'azulejo');
    await bombear(tester);
    await tester.enterText(find.byType(TextField), 'mirlo');
    await tester.pump();
    expect(find.textContaining('algo en el agua'), findsOneWidget);
    expect(find.textContaining('algo más'), findsNothing);
  });

  testWidgets('filtra por dondeNombre', (tester) async {
    await sembrar(id: '1', queVio: 'cosa', dondeNombre: 'el roble grande');
    await sembrar(id: '2', queVio: 'otra', dondeNombre: 'la fuente');
    await bombear(tester);
    await tester.enterText(find.byType(TextField), 'roble');
    await tester.pump();
    expect(find.textContaining('cosa'), findsOneWidget);
    expect(find.textContaining('otra'), findsNothing);
  });

  testWidgets('búsqueda sin resultados: microcopia "ninguna página"',
      (tester) async {
    await sembrar(id: '1', queVio: 'pájaro');
    await bombear(tester);
    await tester.enterText(find.byType(TextField), 'jirafa');
    await tester.pump();
    expect(
      find.textContaining('Ninguna página guarda eso'),
      findsOneWidget,
    );
  });

  testWidgets('botón "limpiar" devuelve la lista completa', (tester) async {
    await sembrar(id: '1', queVio: 'pájaro');
    await sembrar(id: '2', queVio: 'flor');
    await bombear(tester);
    await tester.enterText(find.byType(TextField), 'pajaro');
    await tester.pump();
    expect(find.textContaining('flor'), findsNothing);
    await tester.tap(find.byTooltip('limpiar búsqueda'));
    await tester.pump();
    expect(find.textContaining('pájaro'), findsOneWidget);
    expect(find.textContaining('flor'), findsOneWidget);
  });

  testWidgets(
      'el botón "limpiar" sólo aparece si la búsqueda no está vacía',
      (tester) async {
    await sembrar(id: '1', queVio: 'pájaro');
    await bombear(tester);
    expect(find.byTooltip('limpiar búsqueda'), findsNothing);
    await tester.enterText(find.byType(TextField), 'p');
    await tester.pump();
    expect(find.byTooltip('limpiar búsqueda'), findsOneWidget);
  });

  testWidgets(
    'pulsar una tarjeta del listado invoca alAbrirDetalle con la observación',
    (tester) async {
      await sembrar(id: 'obs-1', queVio: 'pájaro pequeño marrón');
      await sembrar(id: 'obs-2', queVio: 'caracol grande');
      Observacion? recibida;
      await tester.binding.setSurfaceSize(const Size(800, 1200));
      await tester.pumpWidget(MaterialApp(
        theme: TemaCuaderno.claro(),
        localizationsDelegates: TextosApp.localizationsDelegates,
        supportedLocales: TextosApp.supportedLocales,
        locale: const Locale('es'),
        home: PantallaListaObservaciones(
          repositorio: repositorio,
          alAbrirDetalle: (obs) {
            recibida = obs;
          },
        ),
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.textContaining('caracol grande'));
      await tester.pumpAndSettle();

      expect(recibida, isNotNull);
      expect(recibida!.id, 'obs-2');
      expect(recibida!.queVio, 'caracol grande');
    },
  );

  testWidgets(
    'sin observaciones, el icono "leer tus páginas" no aparece en el AppBar',
    (tester) async {
      await bombear(tester);
      expect(find.byTooltip('leer tus páginas'), findsNothing);
    },
  );

  testWidgets(
    'con observaciones, el icono "leer tus páginas" abre el modo lectura',
    (tester) async {
      await sembrar(id: 'a', queVio: 'mirlo común');
      await bombear(tester);

      expect(find.byTooltip('leer tus páginas'), findsOneWidget);
      await tester.tap(find.byTooltip('leer tus páginas'));
      await tester.pumpAndSettle();

      // En el modo lectura aparece el AppBar "Leer tus páginas".
      expect(find.text('Leer tus páginas'), findsOneWidget);
      // El queVio aparece en la página del modo lectura.
      expect(find.text('mirlo común'), findsOneWidget);
    },
  );
}
