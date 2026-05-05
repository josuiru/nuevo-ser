import 'package:el_cuaderno/dominio/nivel_confianza.dart';
import 'package:el_cuaderno/dominio/observacion.dart';
import 'package:el_cuaderno/infraestructura/memoria/repositorio_memoria.dart';
import 'package:el_cuaderno/nucleo/i18n/generado/textos_app.dart';
import 'package:el_cuaderno/vista/pantalla_atlas/pantalla_atlas.dart';
import 'package:el_cuaderno/vista/tema/tema.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late RepositorioMemoria repositorio;

  setUp(() {
    repositorio = RepositorioMemoria();
  });

  Future<void> bombear(WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(500, 1400));
    await tester.pumpWidget(
      MaterialApp(
        theme: TemaCuaderno.claro(),
        localizationsDelegates: TextosApp.localizationsDelegates,
        supportedLocales: TextosApp.supportedLocales,
        locale: const Locale('es'),
        home: PantallaAtlas(repositorio: repositorio),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> guardar({
    required String id,
    required DateTime cuando,
    required String? creesQueEs,
  }) async {
    await repositorio.guardarObservacion(Observacion(
      id: id,
      cuandoCreada: cuando,
      cuandoOcurrio: cuando,
      dondeNombre: 'jardín',
      queVio: 'algo',
      confianza: NivelConfianza.hipotesisActiva,
      creesQueEs: creesQueEs,
    ));
  }

  testWidgets(
    'atlas vacío → cabecera y cuerpo amables (sin trofeos visibles)',
    (tester) async {
      await bombear(tester);
      expect(find.text('Tu atlas todavía está vacío.'), findsOneWidget);
      expect(
        find.textContaining('se irá llenando solo'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'observaciones sin creesQueEs → atlas sigue vacío (no penaliza el "no sé")',
    (tester) async {
      await guardar(
        id: '1',
        cuando: DateTime(2026, 4, 1),
        creesQueEs: null,
      );
      await guardar(
        id: '2',
        cuando: DateTime(2026, 4, 2),
        creesQueEs: '',
      );
      await bombear(tester);
      expect(find.text('Tu atlas todavía está vacío.'), findsOneWidget);
    },
  );

  testWidgets(
    'una identificación nueva → aparece en "Tus primeras veces" y en '
    '"Lo que has visto"',
    (tester) async {
      await guardar(
        id: '1',
        cuando: DateTime(2026, 4, 1),
        creesQueEs: 'mariposa blanca',
      );
      await bombear(tester);

      expect(find.text('Tus primeras veces'), findsOneWidget);
      expect(find.text('Lo que has visto'), findsOneWidget);
      // El texto aparece dos veces: una en la tarjeta de primera
      // vez y otra en la fila de conteo.
      expect(find.text('mariposa blanca'), findsNWidgets(2));
      expect(find.text('1 vez'), findsOneWidget);
    },
  );

  testWidgets(
    'tres observaciones del mismo creesQueEs → 1 primera vez + conteo plural',
    (tester) async {
      await guardar(
        id: '1',
        cuando: DateTime(2026, 4, 1),
        creesQueEs: 'hormiga',
      );
      await guardar(
        id: '2',
        cuando: DateTime(2026, 4, 5),
        creesQueEs: 'hormiga',
      );
      await guardar(
        id: '3',
        cuando: DateTime(2026, 4, 10),
        creesQueEs: 'hormiga',
      );
      await bombear(tester);

      expect(find.text('hormiga'), findsNWidgets(2));
      expect(find.text('3 veces'), findsOneWidget);
      expect(find.text('1 vez'), findsNothing);
    },
  );

  testWidgets(
    'pulsar una tarjeta de primera vez invoca alAbrirDetalle con la observación',
    (tester) async {
      await guardar(
        id: 'mirlo-1',
        cuando: DateTime(2026, 4, 1),
        creesQueEs: 'mirlo',
      );
      Observacion? abierta;

      await tester.binding.setSurfaceSize(const Size(500, 1400));
      await tester.pumpWidget(
        MaterialApp(
          theme: TemaCuaderno.claro(),
          localizationsDelegates: TextosApp.localizationsDelegates,
          supportedLocales: TextosApp.supportedLocales,
          locale: const Locale('es'),
          home: PantallaAtlas(
            repositorio: repositorio,
            alAbrirDetalle: (obs) => abierta = obs,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Hay dos textos "mirlo" — la tarjeta superior es la primera
      // vez. Pulsamos la primera ocurrencia.
      await tester.tap(find.text('mirlo').first);
      await tester.pumpAndSettle();
      expect(abierta, isNotNull);
      expect(abierta!.id, 'mirlo-1');
    },
  );
}
