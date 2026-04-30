import 'package:el_cuaderno/datos/cliente_auth_cuaderno.dart';
import 'package:el_cuaderno/nucleo/i18n/generado/textos_app.dart';
import 'package:el_cuaderno/vista/pantalla_ajustes/bloque_login_adulto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nuevo_ser_core/nuevo_ser_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Tests del bloque "Cuenta del adulto" (A6). El cliente HTTP se
/// sustituye por una closure stub para que los tests no toquen red.
void main() {
  RepositorioCuentaBackend crearRepoCuenta() {
    return RepositorioCuentaBackend(
      prefs: SharedPreferences.getInstance,
      claveToken: 'nuevoser.elcuaderno.token_backend',
      claveEmail: 'nuevoser.elcuaderno.email_backend',
    );
  }

  Widget envolver(Widget bloque) {
    return MaterialApp(
      locale: const Locale('es'),
      localizationsDelegates: TextosApp.localizationsDelegates,
      supportedLocales: TextosApp.supportedLocales,
      home: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: bloque,
        ),
      ),
    );
  }

  group('BloqueLoginAdulto sin sesión previa', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    testWidgets('muestra título, descripción, dos campos y botón Iniciar sesión',
        (tester) async {
      await tester.pumpWidget(envolver(BloqueLoginAdulto(
        repoCuenta: crearRepoCuenta(),
        iniciarSesion: ({required email, required password}) async =>
            const LoginExito(token: 'no-llamar', ninoId: 0),
        esquema: const ColorScheme.light(),
      )));
      await tester.pumpAndSettle();

      expect(find.text('Cuenta del adulto'), findsOneWidget);
      expect(find.byType(TextField), findsNWidgets(2));
      expect(find.text('Iniciar sesión'), findsOneWidget);
    });

    testWidgets(
        'campos vacíos al pulsar entrar → muestra error sin tocar la red',
        (tester) async {
      var stubLlamado = false;
      await tester.pumpWidget(envolver(BloqueLoginAdulto(
        repoCuenta: crearRepoCuenta(),
        iniciarSesion: ({required email, required password}) async {
          stubLlamado = true;
          return const LoginExito(token: 't', ninoId: 1);
        },
        esquema: const ColorScheme.light(),
      )));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Iniciar sesión'));
      await tester.pumpAndSettle();

      expect(
        find.text('Escribe el correo y la contraseña antes de continuar.'),
        findsOneWidget,
      );
      expect(stubLlamado, isFalse);
    });

    testWidgets('credenciales inválidas → mensaje de credenciales',
        (tester) async {
      await tester.pumpWidget(envolver(BloqueLoginAdulto(
        repoCuenta: crearRepoCuenta(),
        iniciarSesion: ({required email, required password}) async =>
            const LoginCredencialesIncorrectas(),
        esquema: const ColorScheme.light(),
      )));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).first, 'a@b.c');
      await tester.enterText(find.byType(TextField).last, 'mal');
      await tester.tap(find.text('Iniciar sesión'));
      await tester.pumpAndSettle();

      expect(
        find.textContaining('no coinciden con ninguna cuenta'),
        findsOneWidget,
      );
    });

    testWidgets('error de red → mensaje de error genérico', (tester) async {
      await tester.pumpWidget(envolver(BloqueLoginAdulto(
        repoCuenta: crearRepoCuenta(),
        iniciarSesion: ({required email, required password}) async =>
            const LoginErrorRed(detalle: 'timeout'),
        esquema: const ColorScheme.light(),
      )));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).first, 'a@b.c');
      await tester.enterText(find.byType(TextField).last, 'pwd');
      await tester.tap(find.text('Iniciar sesión'));
      await tester.pumpAndSettle();

      expect(
        find.textContaining('No se ha podido conectar'),
        findsOneWidget,
      );
    });

    testWidgets(
        'cuenta sin niño → mensaje específico de "sin perfil"',
        (tester) async {
      await tester.pumpWidget(envolver(BloqueLoginAdulto(
        repoCuenta: crearRepoCuenta(),
        iniciarSesion: ({required email, required password}) async =>
            const LoginSinPerfilDeNino(),
        esquema: const ColorScheme.light(),
      )));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).first, 'a@b.c');
      await tester.enterText(find.byType(TextField).last, 'pwd');
      await tester.tap(find.text('Iniciar sesión'));
      await tester.pumpAndSettle();

      expect(
        find.textContaining('ningún niño asociado'),
        findsOneWidget,
      );
    });

    testWidgets(
        'éxito → persiste token+email, llama alCambiarToken, muestra estado iniciada',
        (tester) async {
      var notificado = 0;
      final repoCuenta = crearRepoCuenta();
      await tester.pumpWidget(envolver(BloqueLoginAdulto(
        repoCuenta: repoCuenta,
        iniciarSesion: ({required email, required password}) async =>
            const LoginExito(token: 'jwt.real', ninoId: 7),
        alCambiarToken: () => notificado++,
        esquema: const ColorScheme.light(),
      )));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byType(TextField).first,
        'adulto@ejemplo.org',
      );
      await tester.enterText(find.byType(TextField).last, 'lacontrasena');
      await tester.tap(find.text('Iniciar sesión'));
      await tester.pumpAndSettle();

      expect(await repoCuenta.cargarToken(), 'jwt.real');
      expect(await repoCuenta.cargarEmail(), 'adulto@ejemplo.org');
      expect(notificado, 1);
      expect(
        find.text('Sesión iniciada como adulto@ejemplo.org.'),
        findsOneWidget,
      );
      expect(find.text('Cerrar sesión'), findsOneWidget);
    });
  });

  group('BloqueLoginAdulto con sesión previa', () {
    testWidgets('arranca en estado iniciada y permite cerrar sesión',
        (tester) async {
      SharedPreferences.setMockInitialValues({
        'nuevoser.elcuaderno.token_backend': 'jwt.previo',
        'nuevoser.elcuaderno.email_backend': 'adulto@ejemplo.org',
      });
      var notificado = 0;
      final repoCuenta = crearRepoCuenta();
      await tester.pumpWidget(envolver(BloqueLoginAdulto(
        repoCuenta: repoCuenta,
        iniciarSesion: ({required email, required password}) async =>
            const LoginExito(token: 'no-llamar', ninoId: 0),
        alCambiarToken: () => notificado++,
        esquema: const ColorScheme.light(),
      )));
      await tester.pumpAndSettle();

      expect(
        find.text('Sesión iniciada como adulto@ejemplo.org.'),
        findsOneWidget,
      );

      await tester.tap(find.text('Cerrar sesión'));
      await tester.pumpAndSettle();

      expect(await repoCuenta.cargarToken(), isNull);
      expect(await repoCuenta.cargarEmail(), isNull);
      expect(notificado, 1);
      expect(find.byType(TextField), findsNWidgets(2));
    });
  });
}
