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
    DateTime Function()? proveedorAhora,
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
        proveedorAhora: proveedorAhora,
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

  group('bloque "Este mes aquí"', () {
    DateTime ahora() => DateTime(2026, 5, 15);

    testWidgets(
      'sin observaciones del mes en curso → bloque no se muestra',
      (tester) async {
        await sembrarObservacion(
          id: 'obs-1',
          queVio: 'algo de abril',
          sitSpotId: 'ss-1',
          cuandoOcurrio: DateTime(2026, 4, 20),
        );
        await bombear(
          tester,
          sitSpot: crearSitSpot(),
          proveedorAhora: ahora,
        );
        expect(find.text('Este mes aquí'), findsNothing);
      },
    );

    testWidgets(
      'con una sola visita del mes → bloque tampoco se muestra '
      '(empieza a partir de la segunda)',
      (tester) async {
        await sembrarObservacion(
          id: 'obs-1',
          queVio: 'primera',
          sitSpotId: 'ss-1',
          cuandoOcurrio: DateTime(2026, 5, 5),
        );
        await bombear(
          tester,
          sitSpot: crearSitSpot(),
          proveedorAhora: ahora,
        );
        expect(find.text('Este mes aquí'), findsNothing);
      },
    );

    testWidgets(
      'con dos visitas del mes en días distintos → bloque visible '
      'con plural "dos veces" y fechas DD/MM',
      (tester) async {
        await sembrarObservacion(
          id: 'obs-1',
          queVio: 'primera',
          sitSpotId: 'ss-1',
          cuandoOcurrio: DateTime(2026, 5, 3),
        );
        await sembrarObservacion(
          id: 'obs-2',
          queVio: 'última',
          sitSpotId: 'ss-1',
          cuandoOcurrio: DateTime(2026, 5, 12),
        );
        await bombear(
          tester,
          sitSpot: crearSitSpot(),
          proveedorAhora: ahora,
        );
        expect(find.text('Este mes aquí'), findsOneWidget);
        expect(find.text('Has venido dos veces este mes.'), findsOneWidget);
        expect(
          find.text('La primera fue el 03/05. La última, el 12/05.'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'con cinco visitas del mes → plural "5 veces" cae en la rama other',
      (tester) async {
        for (var dia = 1; dia <= 5; dia++) {
          await sembrarObservacion(
            id: 'obs-$dia',
            queVio: 'cosa $dia',
            sitSpotId: 'ss-1',
            cuandoOcurrio: DateTime(2026, 5, dia * 2),
          );
        }
        await bombear(
          tester,
          sitSpot: crearSitSpot(),
          proveedorAhora: ahora,
        );
        expect(find.text('Has venido 5 veces este mes.'), findsOneWidget);
      },
    );

    testWidgets(
      'tres anotaciones en dos días distintos → bloque dice "dos veces", '
      'no "tres veces" (la unidad pedagógica es la visita, no la '
      'observación)',
      (tester) async {
        await sembrarObservacion(
          id: 'obs-1',
          queVio: 'mañana',
          sitSpotId: 'ss-1',
          cuandoOcurrio: DateTime(2026, 5, 5, 9),
        );
        await sembrarObservacion(
          id: 'obs-2',
          queVio: 'tarde',
          sitSpotId: 'ss-1',
          cuandoOcurrio: DateTime(2026, 5, 5, 17),
        );
        await sembrarObservacion(
          id: 'obs-3',
          queVio: 'al día siguiente',
          sitSpotId: 'ss-1',
          cuandoOcurrio: DateTime(2026, 5, 6),
        );
        await bombear(
          tester,
          sitSpot: crearSitSpot(),
          proveedorAhora: ahora,
        );
        expect(find.text('Has venido dos veces este mes.'), findsOneWidget);
      },
    );
  });
}
