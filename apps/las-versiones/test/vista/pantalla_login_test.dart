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
}
