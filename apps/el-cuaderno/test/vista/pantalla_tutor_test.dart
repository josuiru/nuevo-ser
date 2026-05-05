import 'dart:async';

import 'package:el_cuaderno/datos/cliente_tutor_cuaderno.dart';
import 'package:el_cuaderno/infraestructura/memoria/repositorio_memoria.dart';
import 'package:el_cuaderno/nucleo/i18n/generado/textos_app.dart';
import 'package:el_cuaderno/vista/pantalla_tutor/pantalla_tutor.dart';
import 'package:el_cuaderno/vista/tema/tema.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late RepositorioMemoria repositorio;

  setUp(() {
    repositorio = RepositorioMemoria();
  });

  Future<void> bombear(
    WidgetTester tester, {
    EnviarPreguntaTutor? enviarPregunta,
  }) async {
    await tester.binding.setSurfaceSize(const Size(800, 1200));
    await tester.pumpWidget(
      MaterialApp(
        theme: TemaCuaderno.claro(),
        localizationsDelegates: TextosApp.localizationsDelegates,
        supportedLocales: TextosApp.supportedLocales,
        locale: const Locale('es'),
        home: Scaffold(
          body: PantallaTutor(
            repositorio: repositorio,
            enviarPregunta: enviarPregunta,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('saludo canónico siempre presente', (tester) async {
    await bombear(tester);
    expect(
      find.text('Soy el Tutor del Cuaderno. Pregúntame lo que necesites.'),
      findsOneWidget,
    );
  });

  testWidgets('sin enviarPregunta: usa canned response del S1', (tester) async {
    await bombear(tester);
    await tester.enterText(find.byType(TextField), '¿qué es esto?');
    await tester.tap(find.text('Enviar'));
    await tester.pumpAndSettle();
    expect(find.text('¿qué es esto?'), findsOneWidget);
    expect(
      find.text('El Tutor todavía no está conectado. Vuelve en unas semanas.'),
      findsOneWidget,
    );
  });

  testWidgets('con cliente real: muestra la respuesta del backend', (tester) async {
    String? preguntaEnviada;
    await bombear(tester, enviarPregunta: (pregunta) async {
      preguntaEnviada = pregunta;
      return 'Mira las antenas. Si la punta es blanca, es limonera.';
    });
    await tester.enterText(find.byType(TextField), '¿es una limonera?');
    await tester.tap(find.text('Enviar'));
    await tester.pumpAndSettle();
    expect(preguntaEnviada, '¿es una limonera?');
    expect(
      find.text('Mira las antenas. Si la punta es blanca, es limonera.'),
      findsOneWidget,
    );
  });

  testWidgets('CuotaTutorAgotada: muestra el mensaje canónico de la excepción',
      (tester) async {
    await bombear(tester, enviarPregunta: (_) async {
      throw const CuotaTutorAgotada(
        mensaje: 'Hoy hemos hablado mucho. Volvemos mañana.',
      );
    });
    await tester.enterText(find.byType(TextField), 'hola');
    await tester.tap(find.text('Enviar'));
    await tester.pumpAndSettle();
    expect(
      find.text('Hoy hemos hablado mucho. Volvemos mañana.'),
      findsOneWidget,
    );
  });

  testWidgets(
      'error de red con cuenta vinculada: muestra "ahora mismo no llego" '
      '(NO el canned response del estado sin cuenta)', (tester) async {
    // Cuenta vinculada (enviarPregunta no es null) pero la llamada falla.
    // Antes este caso caía al canned response, lo que sugería al adulto
    // que no había vinculado cuenta — engañoso. Ahora distingue.
    await bombear(tester, enviarPregunta: (_) async {
      throw Exception('boom');
    });
    await tester.enterText(find.byType(TextField), 'hola');
    await tester.tap(find.text('Enviar'));
    await tester.pumpAndSettle();
    expect(
      find.text(
        'Ahora mismo no llego al cuaderno. Espera un momento y vuelve a probar.',
      ),
      findsOneWidget,
    );
    expect(
      find.text('El Tutor todavía no está conectado. Vuelve en unas semanas.'),
      findsNothing,
    );
  });

  testWidgets(
      'lista de turnos tiene ScrollController cableado para auto-scroll '
      '(regresión: si se quita, los turnos nuevos quedan ocultos abajo)',
      (tester) async {
    await bombear(tester);
    final listView = tester.widget<ListView>(find.byType(ListView));
    expect(listView.controller, isNotNull);
  });

  testWidgets('botón Enviar deshabilitado mientras hay respuesta en vuelo',
      (tester) async {
    void Function() resolverlo = () {};
    await bombear(tester, enviarPregunta: (pregunta) async {
      // Espera infinita controlada por el test.
      final completador = Completer<String>();
      resolverlo = () {
        completador.complete('respuesta');
      };
      return completador.future;
    });
    await tester.enterText(find.byType(TextField), 'hola');
    await tester.tap(find.text('Enviar'));
    await tester.pump(); // sin pumpAndSettle (no completaría).
    final boton = tester.widget<FilledButton>(find.byType(FilledButton));
    expect(boton.onPressed, isNull);
    expect(find.text('· · ·'), findsOneWidget);
    resolverlo();
    await tester.pumpAndSettle();
    expect(find.text('respuesta'), findsOneWidget);
  });
}
