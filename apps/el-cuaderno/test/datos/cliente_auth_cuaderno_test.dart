import 'dart:convert';

import 'package:el_cuaderno/datos/cliente_auth_cuaderno.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  group('ClienteAuthCuaderno.iniciarSesion', () {
    test('200 con {token, nino_id} devuelve LoginExito', () async {
      late http.Request peticionRecibida;
      final cliente = ClienteAuthCuaderno(
        urlBase: 'https://nuevoser.example.org',
        cliente: MockClient((peticion) async {
          peticionRecibida = peticion;
          return http.Response(
            jsonEncode({'token': 'abc.def.ghi', 'nino_id': 42}),
            200,
            headers: {'content-type': 'application/json'},
          );
        }),
      );

      final resultado = await cliente.iniciarSesion(
        email: 'adulto@ejemplo.org',
        password: 'lacontrasena',
      );

      expect(resultado, isA<LoginExito>());
      final exito = resultado as LoginExito;
      expect(exito.token, 'abc.def.ghi');
      expect(exito.ninoId, 42);

      expect(
        peticionRecibida.url.toString(),
        'https://nuevoser.example.org/wp-json/nuevo-ser/v1/login',
      );
      expect(peticionRecibida.method, 'POST');
      final cuerpo = jsonDecode(peticionRecibida.body) as Map<String, dynamic>;
      expect(cuerpo['email'], 'adulto@ejemplo.org');
      expect(cuerpo['password'], 'lacontrasena');
    });

    test('401 devuelve LoginCredencialesIncorrectas', () async {
      final cliente = ClienteAuthCuaderno(
        urlBase: 'https://nuevoser.example.org',
        cliente: MockClient((_) async => http.Response(
              jsonEncode({'error': 'Credenciales incorrectas.'}),
              401,
              headers: {'content-type': 'application/json'},
            )),
      );
      final resultado = await cliente.iniciarSesion(
        email: 'a@b.c',
        password: 'mal',
      );
      expect(resultado, isA<LoginCredencialesIncorrectas>());
    });

    test('404 devuelve LoginSinPerfilDeNino', () async {
      final cliente = ClienteAuthCuaderno(
        urlBase: 'https://nuevoser.example.org',
        cliente: MockClient((_) async => http.Response(
              jsonEncode({'error': 'La cuenta no tiene ningún perfil.'}),
              404,
              headers: {'content-type': 'application/json'},
            )),
      );
      final resultado = await cliente.iniciarSesion(
        email: 'a@b.c',
        password: 'pwd',
      );
      expect(resultado, isA<LoginSinPerfilDeNino>());
    });

    test('500 devuelve LoginErrorRed con detalle', () async {
      final cliente = ClienteAuthCuaderno(
        urlBase: 'https://nuevoser.example.org',
        cliente: MockClient((_) async => http.Response(
              'kaboom',
              500,
            )),
      );
      final resultado = await cliente.iniciarSesion(
        email: 'a@b.c',
        password: 'pwd',
      );
      expect(resultado, isA<LoginErrorRed>());
      expect((resultado as LoginErrorRed).detalle, contains('500'));
    });

    test('respuesta 200 sin token devuelve LoginErrorRed', () async {
      final cliente = ClienteAuthCuaderno(
        urlBase: 'https://nuevoser.example.org',
        cliente: MockClient((_) async => http.Response(
              jsonEncode({'token': '', 'nino_id': 1}),
              200,
              headers: {'content-type': 'application/json'},
            )),
      );
      final resultado = await cliente.iniciarSesion(
        email: 'a@b.c',
        password: 'pwd',
      );
      expect(resultado, isA<LoginErrorRed>());
    });

    test('excepción del transporte (timeout / DNS) devuelve LoginErrorRed',
        () async {
      final cliente = ClienteAuthCuaderno(
        urlBase: 'https://nuevoser.example.org',
        cliente: MockClient((_) async {
          throw const SocketCaido('host inaccesible');
        }),
      );
      final resultado = await cliente.iniciarSesion(
        email: 'a@b.c',
        password: 'pwd',
      );
      expect(resultado, isA<LoginErrorRed>());
      expect(
        (resultado as LoginErrorRed).detalle,
        contains('host inaccesible'),
      );
    });

    test('hostOverride se añade como cabecera Host', () async {
      late http.Request peticionRecibida;
      final cliente = ClienteAuthCuaderno(
        urlBase: 'http://127.0.0.1:10063',
        hostOverride: 'nuevo-ser.local',
        cliente: MockClient((peticion) async {
          peticionRecibida = peticion;
          return http.Response(
            jsonEncode({'token': 't', 'nino_id': 1}),
            200,
          );
        }),
      );
      await cliente.iniciarSesion(email: 'a@b.c', password: 'p');
      expect(peticionRecibida.headers['Host'], 'nuevo-ser.local');
    });
  });
}

class SocketCaido implements Exception {
  const SocketCaido(this.mensaje);
  final String mensaje;
  @override
  String toString() => 'SocketCaido: $mensaje';
}
