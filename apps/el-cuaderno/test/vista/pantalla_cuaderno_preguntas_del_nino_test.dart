import 'package:el_cuaderno/dominio/pregunta_del_nino.dart';
import 'package:el_cuaderno/infraestructura/memoria/repositorio_memoria.dart';
import 'package:el_cuaderno/nucleo/i18n/generado/textos_app.dart';
import 'package:el_cuaderno/vista/pantalla_cuaderno/estado_cuaderno.dart';
import 'package:el_cuaderno/vista/pantalla_cuaderno/pantalla_cuaderno.dart';
import 'package:el_cuaderno/vista/pantalla_pregunta/pantalla_formular_pregunta.dart';
import 'package:el_cuaderno/vista/pantalla_pregunta/pantalla_pagina_pregunta.dart';
import 'package:el_cuaderno/vista/tema/tema.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late RepositorioMemoria repositorio;
  late EstadoCuaderno estado;

  DateTime ahoraPrimavera() => DateTime(2026, 5, 1);

  setUp(() {
    repositorio = RepositorioMemoria();
    estado = EstadoCuaderno(
      repositorio: repositorio,
      proveedorAhora: ahoraPrimavera,
    );
  });

  tearDown(() => estado.dispose());

  Future<void> bombear(WidgetTester tester) async {
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
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> abrirPestanaMisterios(WidgetTester tester) async {
    await tester.tap(find.text('misterios'));
    await tester.pumpAndSettle();
  }

  testWidgets(
    'pestaña Misterios sin preguntas del niño → muestra estado vacío con voz amable',
    (tester) async {
      await bombear(tester);
      await abrirPestanaMisterios(tester);
      // El IndexedStack monta TODAS las pestañas, así que los textos del
      // home (cuaderno) también pueden aparecer. Buscamos sólo dentro
      // de la sección "Tus preguntas".
      expect(find.text('Tus preguntas'), findsOneWidget);
      expect(
        find.textContaining('Aún no has formulado ninguna pregunta'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'pestaña Misterios con preguntas guardadas → tarjetas pulsables que abren PantallaPaginaPregunta',
    (tester) async {
      await repositorio.guardarPreguntaDelNino(PreguntaDelNino(
        id: 'p1',
        pregunta: '¿siempre canta el mirlo a la misma hora?',
        formuladaEn: DateTime(2026, 4, 28),
      ));
      await estado.cargar();

      await bombear(tester);
      await abrirPestanaMisterios(tester);

      // Aparece la tarjeta de la pregunta.
      expect(
        find.text('¿siempre canta el mirlo a la misma hora?'),
        findsOneWidget,
      );

      // Pulsar la tarjeta abre la página de la pregunta.
      await tester.tap(find.text('¿siempre canta el mirlo a la misma hora?'));
      await tester.pumpAndSettle();
      expect(find.byType(PantallaPaginaPregunta), findsOneWidget);
    },
  );

  testWidgets(
    'FAB de la pestaña Misterios abre PantallaFormularPregunta',
    (tester) async {
      await bombear(tester);
      await abrirPestanaMisterios(tester);

      expect(find.text('formular pregunta'), findsOneWidget);
      await tester.tap(find.text('formular pregunta'));
      await tester.pumpAndSettle();
      expect(find.byType(PantallaFormularPregunta), findsOneWidget);
    },
  );

  testWidgets(
    'FAB del Cuaderno (pestaña 0) sigue siendo "anotar" — el FAB cambia con la pestaña',
    (tester) async {
      await bombear(tester);
      // Por defecto se entra en la pestaña Cuaderno (índice 0).
      expect(find.text('anotar'), findsOneWidget);
      expect(find.text('formular pregunta'), findsNothing);
    },
  );

  testWidgets(
    'flujo completo: formular pregunta → vuelve al home → aparece en la pestaña Misterios',
    (tester) async {
      await bombear(tester);
      await abrirPestanaMisterios(tester);

      // Abrir el formulario.
      await tester.tap(find.text('formular pregunta'));
      await tester.pumpAndSettle();

      // Escribir y guardar.
      await tester.enterText(
        find.byType(TextField),
        '¿qué insectos vienen al lavando del jardín?',
      );
      await tester.pump();
      await tester.tap(find.text('Guardar mi pregunta'));
      await tester.pumpAndSettle();

      // De vuelta en la pestaña Misterios — la pregunta nueva aparece.
      expect(
        find.text('¿qué insectos vienen al lavando del jardín?'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'pregunta cerrada aparece como tarjeta cerrada distinta',
    (tester) async {
      await repositorio.guardarPreguntaDelNino(PreguntaDelNino(
        id: 'p1',
        pregunta: '¿el moho crece más rápido cuando llueve?',
        formuladaEn: DateTime(2026, 4, 1),
      ));
      await repositorio.cerrarPreguntaDelNino(
        'p1',
        'parece que sí, lo he visto crecer mucho la semana después de llover tres días',
      );
      await estado.cargar();

      await bombear(tester);
      await abrirPestanaMisterios(tester);

      // La pregunta NO aparece en abiertas. La copia con estado vacío
      // sí aparece (no hay abiertas).
      expect(
        find.textContaining('Aún no has formulado ninguna pregunta'),
        findsOneWidget,
      );
      // Pero la cerrada SÍ aparece, con su prefijo "cerrada el".
      expect(
        find.text('¿el moho crece más rápido cuando llueve?'),
        findsOneWidget,
      );
      expect(find.textContaining('cerrada el'), findsOneWidget);
    },
  );
}
