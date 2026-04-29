import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:nuevo_ser_companion/nuevo_ser_companion.dart';
import 'package:nuevo_ser_core/nuevo_ser_core.dart';

void main() {
  test('POST /classrooms/{code}/join: 201 → membresía nueva', () async {
    http.Request? capturada;
    final mock = MockClient((request) async {
      capturada = request;
      return http.Response(
        jsonEncode({
          'classroom_id': 7,
          'code': 'ABC123',
          'name': 'Aula 6º A',
          'game_ids': ['uno-roto'],
          'language': 'es',
          'joined_at': '2026-04-29 22:30:00',
        }),
        201,
        headers: {'content-type': 'application/json'},
      );
    });
    final cliente = ClienteCompanion(
      urlBase: 'https://backend.example',
      cliente: mock,
    );

    final membresia = await cliente.unirseAula(
      token: 'tok-jwt',
      code: 'abc123',
    );

    expect(membresia.classroomId, 7);
    expect(membresia.code, 'ABC123');
    expect(membresia.name, 'Aula 6º A');
    expect(membresia.gameIds, ['uno-roto']);
    expect(membresia.language, 'es');
    expect(membresia.joinedAt, DateTime.parse('2026-04-29 22:30:00'));

    expect(capturada!.method, 'POST');
    // El código se sube en mayúsculas en la URL.
    expect(
      capturada!.url.toString(),
      'https://backend.example/wp-json/nuevo-ser/v1/classrooms/ABC123/join',
    );
    expect(capturada!.headers['Authorization'], 'Bearer tok-jwt');
  });

  test('POST /classrooms/{code}/join: 200 → idempotente, ya era miembro',
      () async {
    final mock = MockClient((_) async => http.Response(
          jsonEncode({
            'classroom_id': 7,
            'code': 'ABC123',
            'name': 'Aula 6º A',
            'game_ids': ['uno-roto'],
            'language': 'es',
            'joined_at': '2026-03-01 10:00:00',
          }),
          200,
        ));
    final cliente = ClienteCompanion(
      urlBase: 'https://backend.example',
      cliente: mock,
    );

    final membresia = await cliente.unirseAula(
      token: 'tok-jwt',
      code: 'ABC123',
    );

    // joined_at preserva la fecha del primer ingreso, no la de ahora.
    expect(membresia.joinedAt, DateTime.parse('2026-03-01 10:00:00'));
  });

  test('unirseAula: code se trim-ea y mayusculiza antes de subir a la URL',
      () async {
    Uri? urlCapturada;
    final mock = MockClient((request) async {
      urlCapturada = request.url;
      return http.Response(
        jsonEncode({
          'classroom_id': 1,
          'code': 'AAAA',
          'name': 'X',
          'game_ids': <String>[],
          'language': 'es',
          'joined_at': '2026-04-29 22:30:00',
        }),
        201,
      );
    });
    final cliente = ClienteCompanion(
      urlBase: 'https://backend.example',
      cliente: mock,
    );

    await cliente.unirseAula(token: 'tok', code: '  aaaa  ');

    expect(urlCapturada!.path, '/wp-json/nuevo-ser/v1/classrooms/AAAA/join');
  });

  test('unirseAula: 404 si el code no existe → ExcepcionApi(404)', () async {
    final mock = MockClient((_) async => http.Response(
          jsonEncode({
            'code': 'ns_aulas_codigo_no_existe',
            'message': 'No existe ningún aula con ese código.',
            'data': {'status': 404},
          }),
          404,
        ));
    final cliente = ClienteCompanion(
      urlBase: 'https://backend.example',
      cliente: mock,
    );

    expect(
      () => cliente.unirseAula(token: 'tok', code: 'ZZZZ'),
      throwsA(
        isA<ExcepcionApi>()
            .having((e) => e.codigo, 'codigo', 404)
            .having((e) => e.mensaje, 'mensaje', contains('No existe')),
      ),
    );
  });

  test('unirseAula: 409 si el aula está inactiva → ExcepcionApi(409)',
      () async {
    final mock = MockClient((_) async => http.Response(
          jsonEncode({
            'code': 'ns_aulas_inactiva',
            'message': 'El aula está inactiva y no admite nuevos miembros.',
            'data': {'status': 409},
          }),
          409,
        ));
    final cliente = ClienteCompanion(
      urlBase: 'https://backend.example',
      cliente: mock,
    );

    expect(
      () => cliente.unirseAula(token: 'tok', code: 'ABC123'),
      throwsA(isA<ExcepcionApi>().having((e) => e.codigo, 'codigo', 409)),
    );
  });

  test('unirseAula: 400 con invalid_fields.code → ExcepcionApi(400)', () async {
    final mock = MockClient((_) async => http.Response(
          jsonEncode({
            'code': 'campos_invalidos',
            'message': 'El código del aula no pasa la validación.',
            'data': {
              'status': 400,
              'invalid_fields': {'code': 'formato_invalido'},
            },
          }),
          400,
        ));
    final cliente = ClienteCompanion(
      urlBase: 'https://backend.example',
      cliente: mock,
    );

    expect(
      () => cliente.unirseAula(token: 'tok', code: 'ZZZZ'),
      throwsA(isA<ExcepcionApi>().having((e) => e.codigo, 'codigo', 400)),
    );
  });

  test('unirseAula: 401 → ExcepcionApi(401)', () async {
    final mock = MockClient((_) async => http.Response(
          jsonEncode({
            'code': 'uroto_token_invalido',
            'message': 'Token no válido o expirado.',
            'data': {'status': 401},
          }),
          401,
        ));
    final cliente = ClienteCompanion(
      urlBase: 'https://backend.example',
      cliente: mock,
    );

    expect(
      () => cliente.unirseAula(token: 'tok-malo', code: 'ABC123'),
      throwsA(isA<ExcepcionApi>().having((e) => e.codigo, 'codigo', 401)),
    );
  });

  test('MembresiaAula.desdeJson: game_ids inválido → lista vacía', () async {
    final m = MembresiaAula.desdeJson(const {
      'classroom_id': 1,
      'code': 'X',
      'name': 'Y',
      'game_ids': null, // shape inesperado, no rompemos.
      'language': 'es',
      'joined_at': '2026-01-01 00:00:00',
    });
    expect(m.gameIds, isEmpty);
  });
}
