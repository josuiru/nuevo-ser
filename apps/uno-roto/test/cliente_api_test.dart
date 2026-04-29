import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:nuevo_ser_core/nuevo_ser_core.dart';

void main() {
  const urlBase = 'https://test.example.org';

  test('registrar envía payload correcto y decodifica token', () async {
    final mock = MockClient((peticion) async {
      expect(peticion.method, 'POST');
      expect(peticion.url.toString(),
          '$urlBase/wp-json/nuevo-ser/v1/register');
      expect(peticion.headers['Content-Type'], 'application/json');
      final cuerpo = jsonDecode(peticion.body);
      expect(cuerpo['email'], 'padre@example.org');
      expect(cuerpo['nombre_nino'], 'Leo');
      expect(cuerpo['password'].length, greaterThanOrEqualTo(8));
      return http.Response(
        jsonEncode({'token': 'abc.def.ghi', 'nino_id': 42, 'usuario_id': 7}),
        201,
        headers: {'content-type': 'application/json'},
      );
    });

    final api = ClienteApi(urlBase: urlBase, cliente: mock);
    final resp = await api.registrar(
      email: 'padre@example.org',
      password: 'clave-segura-8',
      nombreTutor: 'Josu',
      nombreNino: 'Leo',
    );
    expect(resp.token, 'abc.def.ghi');
    expect(resp.ninoId, 42);
    expect(resp.usuarioId, 7);
  });

  test('login con credenciales incorrectas lanza ExcepcionApi 401',
      () async {
    final mock = MockClient((peticion) async {
      return http.Response(
        jsonEncode({'error': 'Credenciales incorrectas.'}),
        401,
      );
    });
    final api = ClienteApi(urlBase: urlBase, cliente: mock);
    try {
      await api.iniciarSesion(
        email: 'padre@example.org',
        password: 'incorrecta',
      );
      fail('Debió lanzar ExcepcionApi');
    } on ExcepcionApi catch (e) {
      expect(e.codigo, 401);
      expect(e.mensaje, contains('Credenciales'));
    }
  });

  test('sincronizar incluye Authorization Bearer y envía el estado',
      () async {
    final mock = MockClient((peticion) async {
      expect(peticion.headers['Authorization'], 'Bearer miTokenJWT');
      final cuerpo = jsonDecode(peticion.body);
      expect(cuerpo['progreso']['esquirlas_total'], 30);
      expect((cuerpo['habilidades'] as List).length, 2);
      return http.Response(
        jsonEncode({
          'progreso': cuerpo['progreso'],
          'habilidades': cuerpo['habilidades'],
        }),
        200,
      );
    });
    final api = ClienteApi(urlBase: urlBase, cliente: mock);
    final resultado = await api.sincronizar(
      token: 'miTokenJWT',
      progreso: {
        'nombre_jugador': 'Leo',
        'esquirlas_total': 30,
        'rango': 1,
        'arco_actual': 1,
        'flags': {'escena_1_1_vista': true},
        'actualizado_en': '2026-04-21 14:23:00',
      },
      habilidades: [
        {'id_habilidad': 'FR.01', 'nivel': 3},
        {'id_habilidad': 'FR.05', 'nivel': 2},
      ],
    );
    expect(resultado['progreso']['esquirlas_total'], 30);
    expect((resultado['habilidades'] as List).length, 2);
  });

  test('obtenerProgreso sin token lanza si servidor devuelve 401',
      () async {
    final mock = MockClient((peticion) async {
      return http.Response(
        jsonEncode({'message': 'Falta el header Authorization: Bearer.'}),
        401,
      );
    });
    final api = ClienteApi(urlBase: urlBase, cliente: mock);
    try {
      await api.obtenerProgreso('');
      fail('Debió lanzar ExcepcionApi');
    } on ExcepcionApi catch (e) {
      expect(e.codigo, 401);
    }
  });

  test('borrarCuenta delete devuelve 200 y no lanza', () async {
    final mock = MockClient((peticion) async {
      expect(peticion.method, 'DELETE');
      return http.Response(jsonEncode({'ok': true}), 200);
    });
    final api = ClienteApi(urlBase: urlBase, cliente: mock);
    await api.borrarCuenta('tokenAlgo');
  });

  test('error HTTP sin body parseable da mensaje genérico', () async {
    final mock = MockClient((peticion) async {
      return http.Response('no-json aquí', 500);
    });
    final api = ClienteApi(urlBase: urlBase, cliente: mock);
    try {
      await api.iniciarSesion(email: 'a@b.c', password: '12345678');
      fail('Debió lanzar ExcepcionApi');
    } on ExcepcionApi catch (e) {
      expect(e.codigo, 500);
      expect(e.mensaje, contains('500'));
    }
  });
}
