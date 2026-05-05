import 'package:el_cuaderno/dominio/nivel_confianza.dart';
import 'package:el_cuaderno/dominio/observacion.dart';
import 'package:el_cuaderno/dominio/pregunta_del_nino.dart';
import 'package:el_cuaderno/infraestructura/memoria/repositorio_memoria.dart';
import 'package:el_cuaderno/nucleo/i18n/generado/textos_app.dart';
import 'package:el_cuaderno/vista/pantalla_pregunta/pantalla_pagina_pregunta.dart';
import 'package:el_cuaderno/vista/tema/tema.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late RepositorioMemoria repositorio;

  setUp(() {
    repositorio = RepositorioMemoria();
  });

  Future<void> bombearPagina(
    WidgetTester tester, {
    required PreguntaDelNino pregunta,
    Future<void> Function(String preguntaId)? alAbrirNuevaObservacion,
  }) async {
    await tester.binding.setSurfaceSize(const Size(800, 1600));
    await tester.pumpWidget(
      MaterialApp(
        theme: TemaCuaderno.claro(),
        localizationsDelegates: TextosApp.localizationsDelegates,
        supportedLocales: TextosApp.supportedLocales,
        locale: const Locale('es'),
        home: PantallaPaginaPregunta(
          repositorio: repositorio,
          pregunta: pregunta,
          alAbrirNuevaObservacion: alAbrirNuevaObservacion,
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets(
    'pregunta abierta sin closure → no aparece el botón de evidencia (modo lectura)',
    (tester) async {
      final pregunta = PreguntaDelNino(
        id: 'p1',
        pregunta: '¿de qué color es el moho del pan?',
        formuladaEn: DateTime(2026, 4, 1),
      );
      await repositorio.guardarPreguntaDelNino(pregunta);

      await bombearPagina(tester, pregunta: pregunta);

      expect(find.text('¿de qué color es el moho del pan?'), findsOneWidget);
      expect(find.textContaining('anotar evidencia'), findsNothing);
    },
  );

  testWidgets(
    'pregunta abierta con closure → muestra botón "anotar evidencia" e invoca con id correcto',
    (tester) async {
      final pregunta = PreguntaDelNino(
        id: 'p2',
        pregunta: '¿qué insectos vienen al lavando?',
        formuladaEn: DateTime(2026, 4, 1),
      );
      await repositorio.guardarPreguntaDelNino(pregunta);

      String? idRecibido;
      await bombearPagina(
        tester,
        pregunta: pregunta,
        alAbrirNuevaObservacion: (id) async {
          idRecibido = id;
        },
      );

      expect(find.textContaining('anotar evidencia'), findsOneWidget);
      await tester.tap(find.textContaining('anotar evidencia'));
      await tester.pumpAndSettle();
      expect(idRecibido, 'p2');
    },
  );

  testWidgets(
    'sin evidencia el botón "ya tengo mi respuesta" no aparece (cierre prematuro)',
    (tester) async {
      final pregunta = PreguntaDelNino(
        id: 'p3',
        pregunta: '¿siempre canta el mirlo a la misma hora?',
        formuladaEn: DateTime(2026, 4, 1),
      );
      await repositorio.guardarPreguntaDelNino(pregunta);

      await bombearPagina(
        tester,
        pregunta: pregunta,
        alAbrirNuevaObservacion: (_) async {},
      );

      expect(find.textContaining('ya tengo mi respuesta'), findsNothing);
    },
  );

  testWidgets(
    'con al menos una evidencia anclada → aparece "ya tengo mi respuesta"',
    (tester) async {
      final pregunta = PreguntaDelNino(
        id: 'p4',
        pregunta: '¿qué insectos vienen al lavando?',
        formuladaEn: DateTime(2026, 4, 1),
      );
      await repositorio.guardarPreguntaDelNino(pregunta);

      final observacion = Observacion(
        id: 'obs-1',
        cuandoCreada: DateTime(2026, 4, 12),
        cuandoOcurrio: DateTime(2026, 4, 12),
        dondeNombre: 'jardín',
        queVio: 'una abeja gorda zumbando',
        confianza: NivelConfianza.hipotesisActiva,
        preguntaDelNinoId: 'p4',
      );
      await repositorio.guardarObservacion(observacion);
      await repositorio.anclarObservacionAPregunta('obs-1', 'p4');

      await bombearPagina(
        tester,
        pregunta: pregunta,
        alAbrirNuevaObservacion: (_) async {},
      );

      // La evidencia aparece en el listado.
      expect(find.text('una abeja gorda zumbando'), findsOneWidget);
      // Y el botón de cierre amable está disponible.
      expect(find.textContaining('ya tengo mi respuesta'), findsOneWidget);
    },
  );

  testWidgets(
    'flujo completo de cierre amable: tap "ya tengo mi respuesta" → escribe → guarda → bloque "Tu respuesta" visible',
    (tester) async {
      final pregunta = PreguntaDelNino(
        id: 'p5',
        pregunta: '¿el moho crece más rápido si llueve?',
        formuladaEn: DateTime(2026, 4, 1),
      );
      await repositorio.guardarPreguntaDelNino(pregunta);
      await repositorio.guardarObservacion(Observacion(
        id: 'obs-1',
        cuandoCreada: DateTime(2026, 4, 12),
        cuandoOcurrio: DateTime(2026, 4, 12),
        dondeNombre: 'cocina',
        queVio: 'el pan tenía moho verde el lunes',
        confianza: NivelConfianza.hipotesisActiva,
        preguntaDelNinoId: 'p5',
      ));
      await repositorio.anclarObservacionAPregunta('obs-1', 'p5');

      await bombearPagina(
        tester,
        pregunta: pregunta,
        alAbrirNuevaObservacion: (_) async {},
      );

      await tester.tap(find.textContaining('ya tengo mi respuesta'));
      await tester.pumpAndSettle();

      // Estamos en PantallaCerrarPregunta — escribimos la respuesta.
      await tester.enterText(
        find.byType(TextField),
        'parece que sí, después de tres días de lluvia el moho se nota más',
      );
      await tester.pump();
      await tester.tap(find.text('Guardar mi respuesta'));
      await tester.pumpAndSettle();

      // De vuelta en la página: el bloque "Tu respuesta" está visible.
      expect(find.text('Tu respuesta'), findsOneWidget);
      expect(
        find.text(
          'parece que sí, después de tres días de lluvia el moho se nota más',
        ),
        findsOneWidget,
      );
      // Y el botón de cerrar desaparece (ya está cerrada).
      expect(find.textContaining('ya tengo mi respuesta'), findsNothing);
      // El botón de evidencia también se oculta mientras está cerrada.
      expect(find.textContaining('anotar evidencia'), findsNothing);

      // Persistencia real: el repositorio guarda la fecha + respuesta.
      final actualizada = await repositorio.obtenerPreguntaDelNinoPorId('p5');
      expect(actualizada!.estaCerrada, isTrue);
      expect(actualizada.respuestaDelNino, contains('lluvia'));
    },
  );

  testWidgets(
    'pregunta cerrada → reabrir confirmado limpia respuesta y vuelve a mostrar acciones',
    (tester) async {
      final cerrada = PreguntaDelNino(
        id: 'p6',
        pregunta: '¿hay más cantos al amanecer?',
        formuladaEn: DateTime(2026, 4, 1),
        cerradaEn: DateTime(2026, 4, 20),
        respuestaDelNino: 'sí, conté ocho mirlos a las 7 y sólo dos a mediodía',
      );
      await repositorio.guardarPreguntaDelNino(cerrada);
      await repositorio.guardarObservacion(Observacion(
        id: 'obs-1',
        cuandoCreada: DateTime(2026, 4, 12),
        cuandoOcurrio: DateTime(2026, 4, 12),
        dondeNombre: 'parque',
        queVio: 'ocho cantos distintos al amanecer',
        confianza: NivelConfianza.hipotesisActiva,
        preguntaDelNinoId: 'p6',
      ));
      await repositorio.anclarObservacionAPregunta('obs-1', 'p6');

      await bombearPagina(
        tester,
        pregunta: cerrada,
        alAbrirNuevaObservacion: (_) async {},
      );

      // El bloque cerrado está visible.
      expect(find.text('Tu respuesta'), findsOneWidget);
      expect(
        find.text('sí, conté ocho mirlos a las 7 y sólo dos a mediodía'),
        findsOneWidget,
      );

      // Tap en "reabrir esta pregunta" → confirmar.
      await tester.tap(find.text('reabrir esta pregunta'));
      await tester.pumpAndSettle();
      // Diálogo de confirmación.
      await tester.tap(find.text('Reabrir'));
      await tester.pumpAndSettle();

      // El bloque desaparece y los botones de evidencia/cierre vuelven.
      expect(find.text('Tu respuesta'), findsNothing);
      expect(
        find.text('sí, conté ocho mirlos a las 7 y sólo dos a mediodía'),
        findsNothing,
      );
      expect(find.textContaining('anotar evidencia'), findsOneWidget);
      expect(find.textContaining('ya tengo mi respuesta'), findsOneWidget);

      // Persistencia: la respuesta se ha limpiado en el repo.
      final actualizada = await repositorio.obtenerPreguntaDelNinoPorId('p6');
      expect(actualizada!.estaCerrada, isFalse);
      expect(actualizada.respuestaDelNino, isNull);
    },
  );

  testWidgets(
    'menú overflow → borrar pregunta confirmado vacía la pregunta del repo',
    (tester) async {
      final pregunta = PreguntaDelNino(
        id: 'p7',
        pregunta: '¿qué color tiene el liquen seco?',
        formuladaEn: DateTime(2026, 4, 1),
      );
      await repositorio.guardarPreguntaDelNino(pregunta);

      await bombearPagina(tester, pregunta: pregunta);

      // Abrir el popup menu.
      await tester.tap(find.byType(PopupMenuButton<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('borrar esta pregunta').last);
      await tester.pumpAndSettle();
      // Confirmar.
      await tester.tap(find.text('borrar'));
      await tester.pumpAndSettle();

      // El repo ya no tiene la pregunta.
      final actualizada = await repositorio.obtenerPreguntaDelNinoPorId('p7');
      expect(actualizada, isNull);
    },
  );
}
