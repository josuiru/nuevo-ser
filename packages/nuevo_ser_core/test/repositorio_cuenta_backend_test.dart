import 'package:flutter_test/flutter_test.dart';
import 'package:nuevo_ser_core/nuevo_ser_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late RepositorioCuentaBackend cuenta;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    cuenta = RepositorioCuentaBackend(
      prefs: SharedPreferences.getInstance,
      claveToken: 'uroto.token_backend',
      claveEmail: 'uroto.email_backend',
    );
  });

  group('token', () {
    test('sin guardar devuelve null', () async {
      expect(await cuenta.cargarToken(), isNull);
    });

    test('guardar + cargar devuelve lo guardado', () async {
      await cuenta.guardarToken('jwt.aaa.bbb');
      expect(await cuenta.cargarToken(), 'jwt.aaa.bbb');
    });

    test('borrar elimina el valor', () async {
      await cuenta.guardarToken('jwt.aaa.bbb');
      await cuenta.borrarToken();
      expect(await cuenta.cargarToken(), isNull);
    });
  });

  group('email', () {
    test('sin guardar devuelve null', () async {
      expect(await cuenta.cargarEmail(), isNull);
    });

    test('guardar + cargar', () async {
      await cuenta.guardarEmail('mama@example.com');
      expect(await cuenta.cargarEmail(), 'mama@example.com');
    });

    test('borrar elimina el valor', () async {
      await cuenta.guardarEmail('mama@example.com');
      await cuenta.borrarEmail();
      expect(await cuenta.cargarEmail(), isNull);
    });
  });

  group('cerrarSesion', () {
    test('borra token y email simultáneamente', () async {
      await cuenta.guardarToken('jwt.aaa.bbb');
      await cuenta.guardarEmail('mama@example.com');

      await cuenta.cerrarSesion();

      expect(await cuenta.cargarToken(), isNull);
      expect(await cuenta.cargarEmail(), isNull);
    });

    test('es idempotente cuando no hay sesión activa', () async {
      await cuenta.cerrarSesion();
      expect(await cuenta.cargarToken(), isNull);
      expect(await cuenta.cargarEmail(), isNull);
    });
  });

  test('claves personalizadas — dos juegos coexisten en el mismo prefs',
      () async {
    final cuentaUroto = RepositorioCuentaBackend(
      prefs: SharedPreferences.getInstance,
      claveToken: 'uroto.token_backend',
      claveEmail: 'uroto.email_backend',
    );
    final cuentaLasVersiones = RepositorioCuentaBackend(
      prefs: SharedPreferences.getInstance,
      claveToken: 'nuevoser.lasversiones.token_backend',
      claveEmail: 'nuevoser.lasversiones.email_backend',
    );

    await cuentaUroto.guardarToken('token-uroto');
    await cuentaLasVersiones.guardarToken('token-lasversiones');

    expect(await cuentaUroto.cargarToken(), 'token-uroto');
    expect(await cuentaLasVersiones.cargarToken(), 'token-lasversiones');

    await cuentaUroto.cerrarSesion();
    expect(await cuentaUroto.cargarToken(), isNull);
    expect(await cuentaLasVersiones.cargarToken(), 'token-lasversiones');
  });
}
