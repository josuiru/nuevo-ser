import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:nuevo_ser_companion/nuevo_ser_companion.dart';

/// Tests del [ClienteAuthAdulto] (B7) — POST /auth/login con shape
/// `{email, password, rol}` para profesor o cuidador.
void main() {
  group('ClienteAuthAdulto.iniciarSesion', () {
    test('200 con {token, user_id, rol} → LoginAdultoExito', () async {
      late http.Request capturada;
      final cliente = ClienteAuthAdulto(
        urlBase: 'https://backend.example',
        cliente: MockClient((request) async {
          capturada = request;
          return http.Response(
            jsonEncode({
              'token': 'jwt-prof',
              'user_id': 17,
              'rol': 'profesor',
            }),
            200,
          );
        }),
      );

      final resultado = await cliente.iniciarSesion(
        email: 'maestra@cole.org',
        password: 'tarima',
        rol: RolAdulto.profesor,
      );

      expect(resultado, isA<LoginAdultoExito>());
      final exito = resultado as LoginAdultoExito;
      expect(exito.token, 'jwt-prof');
      expect(exito.userId, 17);
      expect(exito.rol, RolAdulto.profesor);

      expect(
        capturada.url.toString(),
        'https://backend.example/wp-json/nuevo-ser/v1/auth/login',
      );
      final cuerpo = jsonDecode(capturada.body) as Map<String, dynamic>;
      expect(cuerpo['email'], 'maestra@cole.org');
      expect(cuerpo['password'], 'tarima');
      expect(cuerpo['rol'], 'profesor');
    });

    test('rol del wire mal formado → respuesta cae a rol pedido', () async {
      // Sigue siendo un éxito si llegan token + user_id; el rol del
      // servidor se reinterpreta. Defensivo, no defensivo dañino.
      final cliente = ClienteAuthAdulto(
        urlBase: 'https://backend.example',
        cliente: MockClient((_) async => http.Response(
              jsonEncode({
                'token': 't',
                'user_id': 1,
                'rol': 'profesor',
              }),
              200,
            )),
      );
      final resultado = await cliente.iniciarSesion(
        email: 'a@b.c',
        password: 'p',
        rol: RolAdulto.profesor,
      );
      expect(resultado, isA<LoginAdultoExito>());
    });

    test('400 → LoginAdultoRolInvalido', () async {
      final cliente = ClienteAuthAdulto(
        urlBase: 'https://backend.example',
        cliente: MockClient((_) async => http.Response(
              jsonEncode({'error': 'Rol inválido.'}),
              400,
            )),
      );
      final resultado = await cliente.iniciarSesion(
        email: 'a@b.c',
        password: 'p',
        rol: RolAdulto.profesor,
      );
      expect(resultado, isA<LoginAdultoRolInvalido>());
    });

    test('401 → LoginAdultoCredencialesIncorrectas', () async {
      final cliente = ClienteAuthAdulto(
        urlBase: 'https://backend.example',
        cliente: MockClient((_) async => http.Response(
              jsonEncode({'error': 'Credenciales incorrectas.'}),
              401,
            )),
      );
      final resultado = await cliente.iniciarSesion(
        email: 'a@b.c',
        password: 'mal',
        rol: RolAdulto.profesor,
      );
      expect(resultado, isA<LoginAdultoCredencialesIncorrectas>());
    });

    test('403 → LoginAdultoSinRolAsignado (cuidador intenta entrar como profesor)',
        () async {
      final cliente = ClienteAuthAdulto(
        urlBase: 'https://backend.example',
        cliente: MockClient((_) async => http.Response(
              jsonEncode({'error': 'El usuario no tiene el rol solicitado.'}),
              403,
            )),
      );
      final resultado = await cliente.iniciarSesion(
        email: 'tutor@familia.org',
        password: 'p',
        rol: RolAdulto.profesor,
      );
      expect(resultado, isA<LoginAdultoSinRolAsignado>());
    });

    test('500 → LoginAdultoErrorRed', () async {
      final cliente = ClienteAuthAdulto(
        urlBase: 'https://backend.example',
        cliente: MockClient((_) async => http.Response('boom', 500)),
      );
      final resultado = await cliente.iniciarSesion(
        email: 'a@b.c',
        password: 'p',
        rol: RolAdulto.cuidador,
      );
      expect(resultado, isA<LoginAdultoErrorRed>());
    });

    test('200 sin token → LoginAdultoErrorRed', () async {
      final cliente = ClienteAuthAdulto(
        urlBase: 'https://backend.example',
        cliente: MockClient((_) async => http.Response(
              jsonEncode({'token': '', 'user_id': 1, 'rol': 'profesor'}),
              200,
            )),
      );
      final resultado = await cliente.iniciarSesion(
        email: 'a@b.c',
        password: 'p',
        rol: RolAdulto.profesor,
      );
      expect(resultado, isA<LoginAdultoErrorRed>());
    });

    test('hostOverride se añade como cabecera Host', () async {
      late http.Request capturada;
      final cliente = ClienteAuthAdulto(
        urlBase: 'http://127.0.0.1:10063',
        hostOverride: 'nuevo-ser.local',
        cliente: MockClient((request) async {
          capturada = request;
          return http.Response(
            jsonEncode({'token': 't', 'user_id': 1, 'rol': 'profesor'}),
            200,
          );
        }),
      );
      await cliente.iniciarSesion(
        email: 'a@b.c',
        password: 'p',
        rol: RolAdulto.profesor,
      );
      expect(capturada.headers['Host'], 'nuevo-ser.local');
    });

    test('RolAdulto.desdeWire reconoce los dos roles válidos', () {
      expect(RolAdulto.desdeWire('profesor'), RolAdulto.profesor);
      expect(RolAdulto.desdeWire('cuidador'), RolAdulto.cuidador);
      expect(RolAdulto.desdeWire('admin'), isNull);
      expect(RolAdulto.desdeWire(''), isNull);
    });
  });
}
