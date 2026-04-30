import 'package:el_cuaderno/datos_simulados/seed.dart';
import 'package:el_cuaderno/dominio/observacion.dart';
import 'package:el_cuaderno/infraestructura/memoria/repositorio_memoria.dart';
import 'package:el_cuaderno/nucleo/i18n/generado/textos_app.dart';
import 'package:el_cuaderno/vista/pantalla_observacion/pantalla_observacion.dart';
import 'package:el_cuaderno/vista/tema/tema.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late RepositorioMemoria repositorio;

  setUp(() async {
    repositorio = RepositorioMemoria();
    await sembrarDatosDesarrollo(repositorio);
  });

  Future<void> bombearPantalla(
    WidgetTester tester, {
    Future<void> Function(Observacion)? alGuardarObservacion,
  }) async {
    await tester.binding.setSurfaceSize(const Size(800, 1600));
    final misteriosAbiertos = await repositorio.obtenerMisteriosAbiertos();
    final sitSpot = await repositorio.obtenerSitSpot();

    await tester.pumpWidget(
      MaterialApp(
        theme: TemaCuaderno.claro(),
        localizationsDelegates: TextosApp.localizationsDelegates,
        supportedLocales: TextosApp.supportedLocales,
        locale: const Locale('es'),
        home: PantallaObservacion(
          repositorio: repositorio,
          misteriosAbiertos: misteriosAbiertos,
          sitSpotActivo: sitSpot,
          alGuardarObservacion: alGuardarObservacion,
          proveedorAhora: () => DateTime.utc(2026, 4, 30, 17, 48),
          proveedorIds: () => 'obs-test-id',
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets(
    'el botón Guardar está deshabilitado al inicio (qué viste vacío)',
    (tester) async {
      await bombearPantalla(tester);
      final boton = tester.widget<FilledButton>(
        find.widgetWithText(FilledButton, 'Guardar en el cuaderno'),
      );
      expect(boton.onPressed, isNull);
    },
  );

  testWidgets(
    'escribir en qué viste habilita el botón Guardar',
    (tester) async {
      await bombearPantalla(tester);
      // El primer TextField de la pantalla es "qué viste".
      await tester.enterText(
        find.byType(TextField).first,
        'Tres pájaros pequeños marrones saltando entre las hojas.',
      );
      await tester.pump();
      final boton = tester.widget<FilledButton>(
        find.widgetWithText(FilledButton, 'Guardar en el cuaderno'),
      );
      expect(boton.onPressed, isNotNull);
    },
  );

  testWidgets(
    'al escribir crees que es aparecen los tres chips de confianza',
    (tester) async {
      await bombearPantalla(tester);
      // Antes de escribir en "crees que es" no aparecen los chips —
      // específicamente el de "consenso" sólo aparece tras escribir
      // (la etiqueta de confianzaConsenso no es ambigua con otra
      // copy de la pantalla).
      expect(find.text('consenso'), findsNothing);

      // Escribir en "crees que es" (segundo TextField).
      await tester.enterText(
        find.byType(TextField).at(1),
        'petirrojo',
      );
      await tester.pumpAndSettle();

      expect(find.text('consenso'), findsOneWidget);
      expect(find.text('hipótesis activa'), findsOneWidget);
      expect(find.text('no estoy segura'), findsOneWidget);
    },
  );

  testWidgets(
    'el chip "hipótesis activa" está seleccionado por defecto al aparecer',
    (tester) async {
      await bombearPantalla(tester);
      // Trigger los chips escribiendo en crees que es.
      await tester.enterText(find.byType(TextField).at(1), 'petirrojo');
      await tester.pumpAndSettle();

      // El chip seleccionado lleva el texto en peso medio (500). Lo
      // detectamos buscando el RichText/Text con peso medio.
      final textoHipotesis = tester.widget<Text>(
        find.text('hipótesis activa'),
      );
      expect(textoHipotesis.style?.fontWeight, FontWeight.w500);

      // Los otros dos están en peso regular (400).
      final textoConsenso = tester.widget<Text>(find.text('consenso'));
      expect(textoConsenso.style?.fontWeight, FontWeight.w400);
    },
  );

  testWidgets(
    'aviso "haz una nota antes de guardar" visible cuando el campo '
    'obligatorio está vacío',
    (tester) async {
      await bombearPantalla(tester);
      expect(find.text('haz una nota antes de guardar'), findsOneWidget);
    },
  );

  testWidgets(
    'al guardar, el callback alGuardarObservacion se invoca con la observación',
    (tester) async {
      Observacion? capturada;
      await bombearPantalla(
        tester,
        alGuardarObservacion: (observacion) async {
          capturada = observacion;
        },
      );
      await tester.enterText(
        find.byType(TextField).first,
        'Algo se ha movido en la rama de arriba.',
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Guardar en el cuaderno'));
      await tester.pumpAndSettle();
      expect(capturada, isNotNull);
      expect(capturada!.id, 'obs-test-id');
      expect(capturada!.queVio, 'Algo se ha movido en la rama de arriba.');
    },
  );

  testWidgets(
    'al guardar contra el sit spot activo: ultimaVisita se actualiza',
    (tester) async {
      // El seed del repositorio coloca el sit spot El Roble Grande
      // con `ultimaVisita` hace 4 días. Tras guardar una observación
      // contra él, debería pasar a la fecha del proveedorAhora.
      final antes = await repositorio.obtenerSitSpot();
      expect(antes, isNotNull);
      expect(antes!.ultimaVisita, isNotNull);

      await bombearPantalla(tester);
      await tester.enterText(
        find.byType(TextField).first,
        'una hoja con borde rojizo',
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Guardar en el cuaderno'));
      await tester.pumpAndSettle();

      final despues = await repositorio.obtenerSitSpot();
      expect(despues, isNotNull);
      expect(despues!.id, antes.id);
      expect(despues.ultimaVisita, DateTime.utc(2026, 4, 30, 17, 48));
      // El nombre y los demás campos no cambian.
      expect(despues.nombre, antes.nombre);
      expect(despues.creadoEn, antes.creadoEn);
    },
  );
}
