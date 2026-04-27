import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:uno_roto/datos/cache_tutor.dart';
import 'package:uno_roto/datos/cliente_tutor.dart';
import 'package:uno_roto/datos/repositorio_progreso.dart';
import 'package:uno_roto/dominio/tutor/servicio_tutor.dart';
import 'package:uno_roto/vista/pantalla_tutor.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  ServicioTutor crearServicio(MockClient mock) {
    return ServicioTutor(
      cache: CacheTutor(),
      cliente: ClienteTutor(urlBase: 'https://t.example', cliente: mock),
      repositorio: RepositorioProgreso(),
      proveedorToken: () => 'tk',
    );
  }

  Widget envolver(Widget pantalla) {
    return MaterialApp(home: pantalla);
  }

  testWidgets(
    'estado vacío muestra mensaje guía y arranca el cooldown del disparador',
    (tester) async {
      final mock = MockClient((_) async => http.Response('{}', 200));
      final servicio = crearServicio(mock);
      await tester.pumpWidget(envolver(PantallaTutor(
        servicio: servicio,
        idHabilidad: 'FR.05',
        nombreHabilidad: 'Comparar fracciones',
      )));
      await tester.pumpAndSettle();
      expect(find.text('Cuéntame qué te ha trabado.\nCon tus palabras.'),
          findsOneWidget);
      expect(find.text('tutor — comparar fracciones'), findsOneWidget);
    },
  );

  testWidgets(
    'enviar pregunta válida muestra burbuja del niño y respuesta del tutor',
    (tester) async {
      final mock = MockClient((_) async {
        return http.Response(
          jsonEncode({
            'explicacion': 'Mismo denominador: gana el numerador mayor.',
            'fuente': 'llm',
          }),
          200,
        );
      });
      final servicio = crearServicio(mock);
      await tester.pumpWidget(envolver(PantallaTutor(
        servicio: servicio,
        idHabilidad: 'FR.05',
        nombreHabilidad: 'Comparar fracciones',
      )));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'no entiendo');
      await tester.tap(find.byTooltip('preguntar'));
      await tester.pumpAndSettle();

      expect(find.text('no entiendo'), findsOneWidget);
      expect(find.text('Mismo denominador: gana el numerador mayor.'),
          findsOneWidget);
    },
  );

  testWidgets(
    'pregunta con email se rechaza localmente sin llamar a la red',
    (tester) async {
      var llamadas = 0;
      final mock = MockClient((_) async {
        llamadas++;
        return http.Response('{}', 200);
      });
      final servicio = crearServicio(mock);
      await tester.pumpWidget(envolver(PantallaTutor(
        servicio: servicio,
        idHabilidad: 'FR.05',
        nombreHabilidad: 'Comparar fracciones',
      )));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byType(TextField),
        'mi correo es nene@example.com',
      );
      await tester.tap(find.byTooltip('preguntar'));
      await tester.pumpAndSettle();

      expect(llamadas, 0);
      // Mensaje cariñoso visible.
      expect(find.textContaining('datos personales'), findsOneWidget);
    },
  );

  testWidgets(
    'campo vacío no envía nada',
    (tester) async {
      var llamadas = 0;
      final mock = MockClient((_) async {
        llamadas++;
        return http.Response('{}', 200);
      });
      final servicio = crearServicio(mock);
      await tester.pumpWidget(envolver(PantallaTutor(
        servicio: servicio,
        idHabilidad: 'FR.05',
        nombreHabilidad: 'Comparar fracciones',
      )));
      await tester.pumpAndSettle();

      await tester.tap(find.byTooltip('preguntar'));
      await tester.pumpAndSettle();
      expect(llamadas, 0);
    },
  );
}
