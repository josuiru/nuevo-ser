import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:nuevo_ser_companion/nuevo_ser_companion.dart';
import 'package:nuevo_ser_core/nuevo_ser_core.dart';

void main() {
  Mosaico mosaicoEjemplo() {
    return const Mosaico(
      gameId: 'uno-roto',
      arcId: 'distrito-fracciones',
      format: 'video',
      title: 'El Pleno y las fracciones',
      contentRef: 'video/abc',
      contentMeta: {'segundos': 90},
      requiredAnchors: ['FR.05', 'FR.07'],
      fulfilledAnchors: ['FR.05'],
      qualitativeFeedback: 'Buen ejemplo del concepto de Pleno.',
    );
  }

  test(
      'POST /companion/mosaicos: 201 → mosaico con id y completedAt; opcionales preservados',
      () async {
    http.Request? capturada;
    final mock = MockClient((request) async {
      capturada = request;
      return http.Response(
        jsonEncode({
          'id': 42,
          'game_id': 'uno-roto',
          'arc_id': 'distrito-fracciones',
          'format': 'video',
          'title': 'El Pleno y las fracciones',
          'content_ref': 'video/abc',
          'completed_at': '2026-04-29 22:00:00',
        }),
        201,
        headers: {'content-type': 'application/json'},
      );
    });
    final cliente = ClienteCompanion(
      urlBase: 'https://backend.example',
      cliente: mock,
    );

    final creado = await cliente.crearMosaico(
      token: 'tok-jwt',
      mosaico: mosaicoEjemplo(),
    );

    expect(creado.id, 42);
    expect(creado.gameId, 'uno-roto');
    expect(creado.arcId, 'distrito-fracciones');
    expect(creado.format, 'video');
    expect(creado.title, 'El Pleno y las fracciones');
    expect(creado.contentRef, 'video/abc');
    expect(
      creado.completedAt,
      DateTime.parse('2026-04-29 22:00:00'),
    );
    // Opcionales preservados del original.
    expect(creado.contentMeta, {'segundos': 90});
    expect(creado.requiredAnchors, ['FR.05', 'FR.07']);
    expect(creado.fulfilledAnchors, ['FR.05']);
    expect(creado.qualitativeFeedback, 'Buen ejemplo del concepto de Pleno.');

    expect(capturada!.method, 'POST');
    expect(
      capturada!.url.toString(),
      'https://backend.example/wp-json/nuevo-ser/v1/companion/mosaicos',
    );
    expect(capturada!.headers['Authorization'], 'Bearer tok-jwt');
    final cuerpoEnviado = jsonDecode(capturada!.body) as Map<String, dynamic>;
    expect(cuerpoEnviado['game_id'], 'uno-roto');
    expect(cuerpoEnviado['arc_id'], 'distrito-fracciones');
    expect(cuerpoEnviado['format'], 'video');
    expect(cuerpoEnviado['title'], 'El Pleno y las fracciones');
    expect(cuerpoEnviado['required_anchors'], ['FR.05', 'FR.07']);
    expect(cuerpoEnviado['fulfilled_anchors'], ['FR.05']);
    expect(cuerpoEnviado['qualitative_feedback'],
        'Buen ejemplo del concepto de Pleno.');
  });

  test('aJsonParaCrear omite campos opcionales si son null o vacíos', () async {
    const mosaico = Mosaico(
      gameId: 'uno-roto',
      arcId: 'distrito-A',
      title: 'Sin extras',
    );
    final json = mosaico.aJsonParaCrear();
    expect(json.keys, containsAll(['game_id', 'arc_id', 'title']));
    expect(json.containsKey('format'), isFalse);
    expect(json.containsKey('content_ref'), isFalse);
    expect(json.containsKey('content_meta'), isFalse);
    expect(json.containsKey('required_anchors'), isFalse);
    expect(json.containsKey('fulfilled_anchors'), isFalse);
    expect(json.containsKey('qualitative_feedback'), isFalse);
  });

  test('crearMosaico: 400 con invalid_fields → ExcepcionApi(400)', () async {
    final mock = MockClient((_) async => http.Response(
          jsonEncode({
            'code': 'campos_invalidos',
            'message': 'Algunos campos no pasan la validación.',
            'data': {
              'status': 400,
              'invalid_fields': {'arc_id': 'requerido'},
            },
          }),
          400,
        ));
    final cliente = ClienteCompanion(
      urlBase: 'https://backend.example',
      cliente: mock,
    );

    expect(
      () => cliente.crearMosaico(
        token: 'tok',
        mosaico: mosaicoEjemplo(),
      ),
      throwsA(
        isA<ExcepcionApi>()
            .having((e) => e.codigo, 'codigo', 400)
            .having((e) => e.mensaje, 'mensaje', contains('validación')),
      ),
    );
  });

  test('crearMosaico: 401 → ExcepcionApi(401)', () async {
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
      () => cliente.crearMosaico(
        token: 'tok-malo',
        mosaico: mosaicoEjemplo(),
      ),
      throwsA(isA<ExcepcionApi>().having((e) => e.codigo, 'codigo', 401)),
    );
  });

  test('GET /companion/mosaicos: 200 vacío → listado sin mosaicos', () async {
    http.Request? capturada;
    final mock = MockClient((request) async {
      capturada = request;
      return http.Response(
        jsonEncode({
          'entries': <Map<String, dynamic>>[],
          'total': 0,
          'limit': 20,
          'offset': 0,
        }),
        200,
        headers: {'content-type': 'application/json'},
      );
    });
    final cliente = ClienteCompanion(
      urlBase: 'https://backend.example',
      cliente: mock,
    );

    final listado = await cliente.listarMosaicos(token: 'tok-jwt');

    expect(listado.mosaicos, isEmpty);
    expect(listado.total, 0);
    expect(listado.limit, 20);
    expect(listado.offset, 0);

    expect(capturada!.method, 'GET');
    final url = capturada!.url;
    expect(url.path, '/wp-json/nuevo-ser/v1/companion/mosaicos');
    expect(url.queryParameters['limit'], '20');
    expect(url.queryParameters['offset'], '0');
    expect(url.queryParameters.containsKey('game_id'), isFalse);
    expect(url.queryParameters.containsKey('arc_id'), isFalse);
  });

  test(
      'GET /companion/mosaicos: 200 con mosaicos → parsea content_meta y anchors',
      () async {
    final mock = MockClient((_) async => http.Response(
          jsonEncode({
            'entries': [
              {
                'id': 42,
                'game_id': 'uno-roto',
                'arc_id': 'distrito-fracciones',
                'format': 'video',
                'title': 'El Pleno y las fracciones',
                'content_ref': 'video/abc',
                'content_meta': {'segundos': 90},
                'required_anchors': ['FR.05', 'FR.07'],
                'fulfilled_anchors': {
                  'FR.05': {'nivel': 2}
                },
                'qualitative_feedback': 'Buen ejemplo del concepto de Pleno.',
                'completed_at': '2026-04-29 22:00:00',
              },
              {
                'id': 41,
                'game_id': 'uno-roto',
                'arc_id': 'distrito-A',
                'format': '',
                'title': 'Sin extras',
                'content_ref': '',
                'content_meta': null,
                'required_anchors': null,
                'fulfilled_anchors': null,
                'qualitative_feedback': null,
                'completed_at': '2026-04-28 09:00:00',
              },
            ],
            'total': 2,
            'limit': 20,
            'offset': 0,
          }),
          200,
        ));
    final cliente = ClienteCompanion(
      urlBase: 'https://backend.example',
      cliente: mock,
    );

    final listado = await cliente.listarMosaicos(token: 'tok');

    expect(listado.total, 2);
    expect(listado.mosaicos, hasLength(2));

    final primero = listado.mosaicos[0];
    expect(primero.id, 42);
    expect(primero.arcId, 'distrito-fracciones');
    expect(primero.format, 'video');
    expect(primero.contentMeta, {'segundos': 90});
    expect(primero.requiredAnchors, ['FR.05', 'FR.07']);
    expect(primero.fulfilledAnchors, isA<Map>());
    final cumplidos = primero.fulfilledAnchors as Map;
    expect(cumplidos['FR.05'], {'nivel': 2});
    expect(primero.qualitativeFeedback, 'Buen ejemplo del concepto de Pleno.');
    expect(primero.completedAt, DateTime.parse('2026-04-29 22:00:00'));

    final segundo = listado.mosaicos[1];
    expect(segundo.id, 41);
    expect(segundo.contentMeta, isNull);
    expect(segundo.requiredAnchors, isNull);
    expect(segundo.fulfilledAnchors, isNull);
    expect(segundo.qualitativeFeedback, isNull);
  });

  test(
      'GET /companion/mosaicos: gameId/arcId/limit/offset llegan en la URL',
      () async {
    Uri? urlCapturada;
    final mock = MockClient((request) async {
      urlCapturada = request.url;
      return http.Response(
        jsonEncode({
          'entries': <Map<String, dynamic>>[],
          'total': 0,
          'limit': 5,
          'offset': 10,
        }),
        200,
      );
    });
    final cliente = ClienteCompanion(
      urlBase: 'https://backend.example',
      cliente: mock,
    );

    await cliente.listarMosaicos(
      token: 'tok',
      gameId: 'uno-roto',
      arcId: 'distrito-A',
      limit: 5,
      offset: 10,
    );

    expect(urlCapturada!.queryParameters['game_id'], 'uno-roto');
    expect(urlCapturada!.queryParameters['arc_id'], 'distrito-A');
    expect(urlCapturada!.queryParameters['limit'], '5');
    expect(urlCapturada!.queryParameters['offset'], '10');
  });

  test('GET /companion/mosaicos: 400 con invalid_fields → ExcepcionApi(400)',
      () async {
    final mock = MockClient((_) async => http.Response(
          jsonEncode({
            'code': 'campos_invalidos',
            'message': 'Algunos parámetros de la consulta no pasan la validación.',
            'data': {
              'status': 400,
              'invalid_fields': {'limit': 'fuera_de_rango'},
            },
          }),
          400,
        ));
    final cliente = ClienteCompanion(
      urlBase: 'https://backend.example',
      cliente: mock,
    );

    expect(
      () => cliente.listarMosaicos(token: 'tok', limit: 999),
      throwsA(
        isA<ExcepcionApi>()
            .having((e) => e.codigo, 'codigo', 400)
            .having((e) => e.mensaje, 'mensaje', contains('validación')),
      ),
    );
  });

  test('crearMosaico: anchors como Map (objeto) también se aceptan', () async {
    Map<String, dynamic>? cuerpoEnviado;
    final mock = MockClient((request) async {
      cuerpoEnviado = jsonDecode(request.body) as Map<String, dynamic>;
      return http.Response(
        jsonEncode({
          'id': 1,
          'game_id': 'uno-roto',
          'arc_id': 'distrito-A',
          'format': '',
          'title': 'X',
          'content_ref': '',
          'completed_at': '2026-04-29 22:00:00',
        }),
        201,
      );
    });
    final cliente = ClienteCompanion(
      urlBase: 'https://backend.example',
      cliente: mock,
    );

    await cliente.crearMosaico(
      token: 'tok',
      mosaico: const Mosaico(
        gameId: 'uno-roto',
        arcId: 'distrito-A',
        title: 'X',
        requiredAnchors: {'FR.05': {'nivel_minimo': 2}},
      ),
    );

    expect(cuerpoEnviado!['required_anchors'], isA<Map>());
    final anchors = cuerpoEnviado!['required_anchors'] as Map;
    expect(anchors['FR.05'], {'nivel_minimo': 2});
  });
}
