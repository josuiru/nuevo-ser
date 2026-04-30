import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:las_versiones/vista/pantalla_login.dart';

void main() {
  Widget envolverEnApp(Widget hijo) {
    return MaterialApp(home: hijo);
  }

  testWidgets('renderiza header, dos campos, CTA y nota de opt-in',
      (tester) async {
    await tester.pumpWidget(envolverEnApp(
      PantallaLogin(alIntentarLogin: (_, __) async => null),
    ));
    expect(find.text('INICIAR SESIÓN'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(2));
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Contraseña'), findsOneWidget);
    expect(find.text('ENTRAR'), findsOneWidget);
    expect(
      find.textContaining('El juego funciona sin sesión'),
      findsOneWidget,
    );
  });

  testWidgets('campos vacíos al pulsar ENTRAR → mensaje pedagógico',
      (tester) async {
    var llamadas = 0;
    await tester.pumpWidget(envolverEnApp(
      PantallaLogin(alIntentarLogin: (_, __) async {
        llamadas++;
        return null;
      }),
    ));
    await tester.tap(find.text('ENTRAR'));
    await tester.pump();
    expect(find.text('Introduce email y contraseña.'), findsOneWidget);
    expect(llamadas, 0, reason: 'no llama al callback con campos vacíos');
  });

  testWidgets('email con espacios → trim antes de invocar callback',
      (tester) async {
    String? emailRecibido;
    String? passwordRecibida;
    await tester.pumpWidget(envolverEnApp(
      PantallaLogin(alIntentarLogin: (email, password) async {
        emailRecibido = email;
        passwordRecibida = password;
        return null;
      }),
    ));
    await tester.enterText(
      find.byType(TextField).at(0),
      '   adulto@example.com   ',
    );
    await tester.enterText(find.byType(TextField).at(1), 'secreto123');
    await tester.tap(find.text('ENTRAR'));
    await tester.pumpAndSettle();
    expect(emailRecibido, 'adulto@example.com');
    expect(passwordRecibida, 'secreto123',
        reason: 'la contraseña NO se hace trim');
  });

  testWidgets('callback devuelve null → cierra la pantalla', (tester) async {
    final navegador = GlobalKey<NavigatorState>();
    await tester.pumpWidget(MaterialApp(
      navigatorKey: navegador,
      home: Builder(builder: (ctx) {
        return ElevatedButton(
          onPressed: () => Navigator.of(ctx).push(
            MaterialPageRoute(
              builder: (_) => PantallaLogin(
                alIntentarLogin: (_, __) async => null,
              ),
            ),
          ),
          child: const Text('Abrir login'),
        );
      }),
    ));
    await tester.tap(find.text('Abrir login'));
    await tester.pumpAndSettle();
    expect(find.byType(PantallaLogin), findsOneWidget);

    await tester.enterText(find.byType(TextField).at(0), 'a@b.com');
    await tester.enterText(find.byType(TextField).at(1), 'pwd');
    await tester.tap(find.text('ENTRAR'));
    await tester.pumpAndSettle();

    expect(find.byType(PantallaLogin), findsNothing,
        reason: 'tras éxito vuelve a la pantalla anterior');
  });

  testWidgets('callback devuelve mensaje → se muestra inline en ámbar',
      (tester) async {
    await tester.pumpWidget(envolverEnApp(
      PantallaLogin(
        alIntentarLogin: (_, __) async => 'Email o contraseña incorrectos.',
      ),
    ));
    await tester.enterText(find.byType(TextField).at(0), 'a@b.com');
    await tester.enterText(find.byType(TextField).at(1), 'mala');
    await tester.tap(find.text('ENTRAR'));
    await tester.pumpAndSettle();
    expect(find.text('Email o contraseña incorrectos.'), findsOneWidget);
    expect(find.byType(PantallaLogin), findsOneWidget,
        reason: 'tras error la pantalla se queda abierta');
  });

  testWidgets('durante la llamada: spinner y botón deshabilitado',
      (tester) async {
    final completador = Completer<String?>();
    await tester.pumpWidget(envolverEnApp(
      PantallaLogin(alIntentarLogin: (_, __) => completador.future),
    ));
    await tester.enterText(find.byType(TextField).at(0), 'a@b.com');
    await tester.enterText(find.byType(TextField).at(1), 'pwd');
    await tester.tap(find.text('ENTRAR'));
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    final filledButton = tester.widget<FilledButton>(find.byType(FilledButton));
    expect(filledButton.onPressed, isNull,
        reason: 'CTA deshabilitado mientras la llamada está en curso');

    completador.complete('Error de prueba');
    await tester.pumpAndSettle();
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.text('Error de prueba'), findsOneWidget);
  });

  testWidgets('campo de contraseña usa obscureText', (tester) async {
    await tester.pumpWidget(envolverEnApp(
      PantallaLogin(alIntentarLogin: (_, __) async => null),
    ));
    final campoPassword = tester.widget<TextField>(find.byType(TextField).at(1));
    expect(campoPassword.obscureText, isTrue);
  });

  group('modo cuenta (sesión activa)', () {
    testWidgets(
        'con emailActual y alCerrarSesion: muestra header SESIÓN INICIADA, '
        'email y botón CERRAR SESIÓN', (tester) async {
      await tester.pumpWidget(envolverEnApp(
        PantallaLogin(
          alIntentarLogin: (_, __) async => null,
          emailActual: 'adulto@example.com',
          alCerrarSesion: () async {},
        ),
      ));
      expect(find.text('SESIÓN INICIADA'), findsOneWidget);
      expect(find.text('adulto@example.com'), findsOneWidget);
      expect(find.text('CERRAR SESIÓN'), findsOneWidget);
      expect(find.text('ENTRAR'), findsNothing,
          reason: 'el formulario de login NO debe aparecer');
      expect(find.byType(TextField), findsNothing);
    });

    testWidgets('tap en CERRAR SESIÓN llama callback y cierra la pantalla',
        (tester) async {
      var llamadasCerrar = 0;
      final navegador = GlobalKey<NavigatorState>();
      await tester.pumpWidget(MaterialApp(
        navigatorKey: navegador,
        home: Builder(builder: (ctx) {
          return ElevatedButton(
            onPressed: () => Navigator.of(ctx).push(
              MaterialPageRoute(
                builder: (_) => PantallaLogin(
                  alIntentarLogin: (_, __) async => null,
                  emailActual: 'adulto@example.com',
                  alCerrarSesion: () async {
                    llamadasCerrar++;
                  },
                ),
              ),
            ),
            child: const Text('Abrir cuenta'),
          );
        }),
      ));
      await tester.tap(find.text('Abrir cuenta'));
      await tester.pumpAndSettle();
      expect(find.byType(PantallaLogin), findsOneWidget);

      await tester.tap(find.text('CERRAR SESIÓN'));
      await tester.pumpAndSettle();

      expect(llamadasCerrar, 1);
      expect(find.byType(PantallaLogin), findsNothing,
          reason: 'tras cerrar sesión vuelve a la pantalla anterior');
    });

    testWidgets('emailActual sin alCerrarSesion → cae al modo login',
        (tester) async {
      // El modo cuenta requiere ambos parámetros — si falta el callback
      // de cerrar, la pantalla se comporta como login normal. Es la
      // contraparte defensiva: la pantalla nunca muestra "SESIÓN
      // INICIADA" sin saber cómo cerrar.
      await tester.pumpWidget(envolverEnApp(
        PantallaLogin(
          alIntentarLogin: (_, __) async => null,
          emailActual: 'adulto@example.com',
        ),
      ));
      expect(find.text('INICIAR SESIÓN'), findsOneWidget);
      expect(find.text('SESIÓN INICIADA'), findsNothing);
      expect(find.text('CERRAR SESIÓN'), findsNothing);
      expect(find.byType(TextField), findsNWidgets(2));
    });
  });
}
