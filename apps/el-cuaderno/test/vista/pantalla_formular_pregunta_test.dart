import 'package:el_cuaderno/dominio/pregunta_del_nino.dart';
import 'package:el_cuaderno/infraestructura/memoria/repositorio_memoria.dart';
import 'package:el_cuaderno/nucleo/i18n/generado/textos_app.dart';
import 'package:el_cuaderno/vista/pantalla_pregunta/pantalla_formular_pregunta.dart';
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
    await tester.pumpWidget(
      MaterialApp(
        theme: TemaCuaderno.claro(),
        localizationsDelegates: TextosApp.localizationsDelegates,
        supportedLocales: TextosApp.supportedLocales,
        locale: const Locale('es'),
        home: PantallaFormularPregunta(
          repositorio: repositorio,
          proveedorAhora: () => DateTime.utc(2026, 5, 1, 9, 30),
          proveedorIds: () => 'p-test-1',
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('estado inicial: botón Guardar deshabilitado', (tester) async {
    await bombear(tester);
    final boton = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Guardar mi pregunta'),
    );
    expect(boton.onPressed, isNull);
  });

  testWidgets('escribir habilita el botón Guardar', (tester) async {
    await bombear(tester);
    await tester.enterText(find.byType(TextField), '¿hola?');
    await tester.pump();
    final boton = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Guardar mi pregunta'),
    );
    expect(boton.onPressed, isNotNull);
  });

  testWidgets(
    'guardar persiste la pregunta con id y fecha del proveedor',
    (tester) async {
      await bombear(tester);
      await tester.enterText(
        find.byType(TextField),
        '¿siempre cantan los gorriones por la mañana?',
      );
      await tester.pump();
      await tester.tap(find.text('Guardar mi pregunta'));
      await tester.pumpAndSettle();

      final guardada = await repositorio.obtenerPreguntaDelNinoPorId('p-test-1');
      expect(guardada, isNotNull);
      expect(
        guardada!.pregunta,
        '¿siempre cantan los gorriones por la mañana?',
      );
      expect(guardada.formuladaEn, DateTime.utc(2026, 5, 1, 9, 30));
      expect(guardada.estaCerrada, isFalse);
    },
  );

  testWidgets(
    'guardar trim: espacios al principio y al final no se persisten',
    (tester) async {
      await bombear(tester);
      await tester.enterText(find.byType(TextField), '   ¿x?   ');
      await tester.pump();
      await tester.tap(find.text('Guardar mi pregunta'));
      await tester.pumpAndSettle();

      final guardada =
          await repositorio.obtenerPreguntaDelNinoPorId('p-test-1');
      expect(guardada!.pregunta, '¿x?');
    },
  );

  testWidgets(
    'pulsar "necesito ideas" abre la hoja con los cinco esqueletos opcionales',
    (tester) async {
      await bombear(tester);
      await tester.tap(find.text('necesito ideas'));
      await tester.pumpAndSettle();
      // Hoja modal con título + intro + cinco ideas.
      expect(find.text('Si necesitas un punto de partida'), findsOneWidget);
      expect(find.textContaining('No tienes que usar ninguno'), findsOneWidget);
      expect(find.text('¿siempre … cuando …?'), findsOneWidget);
      expect(find.text('¿qué pasa cuando …?'), findsOneWidget);
      expect(find.text('¿se parece … a …?'), findsOneWidget);
      expect(find.text('¿cómo cambia … con el tiempo?'), findsOneWidget);
      expect(find.text('¿qué hace … cuando …?'), findsOneWidget);
    },
  );

  testWidgets(
    'pulsar un esqueleto lo inserta en el campo y cierra la hoja',
    (tester) async {
      await bombear(tester);
      await tester.tap(find.text('necesito ideas'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('¿qué pasa cuando …?'));
      await tester.pumpAndSettle();

      // Hoja cerrada — el campo del formulario lleva el esqueleto.
      expect(find.text('Si necesitas un punto de partida'), findsNothing);
      // El campo (TextField) ahora tiene el texto.
      final tf = tester.widget<TextField>(find.byType(TextField));
      expect(tf.controller!.text, '¿qué pasa cuando …?');
    },
  );

  testWidgets(
    'el formulario devuelve la PreguntaDelNino al caller vía Navigator.pop',
    (tester) async {
      // Envolvemos en un caller que captura el resultado.
      PreguntaDelNino? capturada;
      await tester.binding.setSurfaceSize(const Size(800, 1200));
      await tester.pumpWidget(
        MaterialApp(
          theme: TemaCuaderno.claro(),
          localizationsDelegates: TextosApp.localizationsDelegates,
          supportedLocales: TextosApp.supportedLocales,
          locale: const Locale('es'),
          home: Builder(
            builder: (contexto) => Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () async {
                    capturada =
                        await Navigator.of(contexto).push<PreguntaDelNino?>(
                      MaterialPageRoute(
                        builder: (_) => PantallaFormularPregunta(
                          repositorio: repositorio,
                          proveedorAhora: () => DateTime.utc(2026, 5, 1),
                          proveedorIds: () => 'p-test-2',
                        ),
                      ),
                    );
                  },
                  child: const Text('abrir'),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('abrir'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), '¿x?');
      await tester.pump();
      await tester.tap(find.text('Guardar mi pregunta'));
      await tester.pumpAndSettle();

      expect(capturada, isNotNull);
      expect(capturada!.id, 'p-test-2');
      expect(capturada!.pregunta, '¿x?');
    },
  );
}
