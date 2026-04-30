import 'package:el_cuaderno/dominio/nivel_confianza.dart';
import 'package:el_cuaderno/dominio/observacion.dart';
import 'package:el_cuaderno/dominio/sit_spot.dart';
import 'package:el_cuaderno/infraestructura/memoria/repositorio_memoria.dart';
import 'package:el_cuaderno/nucleo/i18n/generado/textos_app.dart';
import 'package:el_cuaderno/vista/pantalla_sit_spot/pantalla_pagina_sit_spot.dart';
import 'package:el_cuaderno/vista/tema/tema.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late RepositorioMemoria repositorio;

  SitSpot crearSitSpot({String id = 'ss-1'}) => SitSpot(
        id: id,
        nombre: 'El Roble Grande',
        dondeNombre: 'al final del parque, junto al pino más alto',
        creadoEn: DateTime(2026, 3, 12),
      );

  setUp(() async {
    repositorio = RepositorioMemoria();
  });

  Future<void> bombear(
    WidgetTester tester, {
    required SitSpot sitSpot,
    Future<void> Function()? alAbrirNuevaObservacion,
  }) async {
    await tester.binding.setSurfaceSize(const Size(800, 1200));
    await tester.pumpWidget(MaterialApp(
      theme: TemaCuaderno.claro(),
      localizationsDelegates: TextosApp.localizationsDelegates,
      supportedLocales: TextosApp.supportedLocales,
      locale: const Locale('es'),
      home: PantallaPaginaSitSpot(
        repositorio: repositorio,
        sitSpot: sitSpot,
        alAbrirNuevaObservacion: alAbrirNuevaObservacion,
      ),
    ));
    await tester.pumpAndSettle();
  }

  Future<void> sembrarObservacion({
    required String id,
    required String queVio,
    String? sitSpotId,
    DateTime? cuandoOcurrio,
  }) async {
    await repositorio.guardarObservacion(Observacion(
      id: id,
      cuandoCreada: cuandoOcurrio ?? DateTime(2026, 4, 30),
      cuandoOcurrio: cuandoOcurrio ?? DateTime(2026, 4, 30),
      dondeNombre: 'parque',
      queVio: queVio,
      confianza: NivelConfianza.hipotesisActiva,
      sitSpotId: sitSpotId,
    ));
  }

  testWidgets('cabecera: nombre + dondeNombre + "Activo desde"',
      (tester) async {
    await repositorio.establecerSitSpot(crearSitSpot());
    await bombear(tester, sitSpot: crearSitSpot());
    expect(find.text('El Roble Grande'), findsAtLeastNWidgets(1));
    expect(
      find.textContaining('al final del parque'),
      findsOneWidget,
    );
    expect(find.text('Activo desde el 12/03/2026.'), findsOneWidget);
  });

  testWidgets(
    'sin observaciones ancladas: muestra microcopia de estado vacío',
    (tester) async {
      await repositorio.establecerSitSpot(crearSitSpot());
      await bombear(tester, sitSpot: crearSitSpot());
      expect(
        find.textContaining('Todavía no has anotado nada en este sit spot'),
        findsOneWidget,
      );
    },
  );

  testWidgets('lista observaciones ancladas a este sit spot', (tester) async {
    await repositorio.establecerSitSpot(crearSitSpot());
    await sembrarObservacion(
      id: 'obs-1',
      queVio: 'gorrión picoteando entre las raíces',
      sitSpotId: 'ss-1',
    );
    await sembrarObservacion(
      id: 'obs-2',
      queVio: 'líquenes amarillos en la corteza norte',
      sitSpotId: 'ss-1',
    );
    // Una observación de OTRO sit spot no debe aparecer.
    await sembrarObservacion(
      id: 'obs-3',
      queVio: 'hormigas subiendo por el muro',
      sitSpotId: 'otro-ss',
    );
    await bombear(tester, sitSpot: crearSitSpot());
    expect(
      find.textContaining('gorrión picoteando entre las raíces'),
      findsOneWidget,
    );
    expect(
      find.textContaining('líquenes amarillos en la corteza norte'),
      findsOneWidget,
    );
    expect(find.textContaining('hormigas subiendo por el muro'), findsNothing);
    expect(find.text('2 observaciones guardadas'), findsOneWidget);
  });

  testWidgets(
    'sin alAbrirNuevaObservacion: el botón "anotar observación aquí" no aparece',
    (tester) async {
      await repositorio.establecerSitSpot(crearSitSpot());
      await bombear(tester, sitSpot: crearSitSpot());
      expect(find.text('anotar observación aquí'), findsNothing);
    },
  );

  testWidgets(
    'con alAbrirNuevaObservacion: pulsar el botón invoca el callback y recarga',
    (tester) async {
      await repositorio.establecerSitSpot(crearSitSpot());
      var llamadas = 0;
      await bombear(
        tester,
        sitSpot: crearSitSpot(),
        alAbrirNuevaObservacion: () async {
          llamadas++;
          await sembrarObservacion(
            id: 'obs-recien',
            queVio: 'evidencia recién anotada',
            sitSpotId: 'ss-1',
          );
        },
      );
      expect(
        find.textContaining('Todavía no has anotado nada en este sit spot'),
        findsOneWidget,
      );
      await tester.tap(find.text('anotar observación aquí'));
      await tester.pumpAndSettle();
      expect(llamadas, 1);
      expect(find.textContaining('evidencia recién anotada'), findsOneWidget);
      expect(
        find.textContaining('Todavía no has anotado nada en este sit spot'),
        findsNothing,
      );
    },
  );

  testWidgets(
    'una sola observación anclada: contador en singular',
    (tester) async {
      await repositorio.establecerSitSpot(crearSitSpot());
      await sembrarObservacion(
        id: 'obs-1',
        queVio: 'la única',
        sitSpotId: 'ss-1',
      );
      await bombear(tester, sitSpot: crearSitSpot());
      expect(find.text('1 observación guardada'), findsOneWidget);
    },
  );
}
