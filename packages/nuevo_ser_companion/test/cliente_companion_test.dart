import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:nuevo_ser_companion/nuevo_ser_companion.dart';
import 'package:nuevo_ser_core/nuevo_ser_core.dart';

void main() {
  EntradaCuaderno entradaEjemplo() {
    return const EntradaCuaderno(
      gameId: 'uno-roto',
      type: 'reflexion',
      title: 'Las fracciones',
      contentRef: 'doc/123',
      contentMeta: {'palabras': 42},
      anchoredTo: {'habilidad': 'FR.05'},
    );
  }

  test('POST /companion/cuaderno/entries: respuesta 201 → entrada con id y createdAt',
      () async {
    http.Request? capturada;
    final mock = MockClient((request) async {
      capturada = request;
      return http.Response(
        jsonEncode({
          'id': 17,
          'game_id': 'uno-roto',
          'type': 'reflexion',
          'title': 'Las fracciones',
          'content_ref': 'doc/123',
          'created_at': '2026-04-29 21:30:00',
        }),
        201,
        headers: {'content-type': 'application/json'},
      );
    });
    final cliente = ClienteCompanion(
      urlBase: 'https://backend.example',
      cliente: mock,
    );

    final creada = await cliente.crearEntradaCuaderno(
      token: 'tok-jwt',
      entrada: entradaEjemplo(),
    );

    expect(creada.id, 17);
    expect(creada.gameId, 'uno-roto');
    expect(creada.type, 'reflexion');
    expect(creada.title, 'Las fracciones');
    expect(creada.contentRef, 'doc/123');
    expect(
      creada.createdAt,
      DateTime.parse('2026-04-29 21:30:00'),
    );
    // El cliente preserva los campos opcionales del original.
    expect(creada.contentMeta, {'palabras': 42});
    expect(creada.anchoredTo, {'habilidad': 'FR.05'});

    expect(capturada!.method, 'POST');
    expect(
      capturada!.url.toString(),
      'https://backend.example/wp-json/nuevo-ser/v1/companion/cuaderno/entries',
    );
    expect(capturada!.headers['Authorization'], 'Bearer tok-jwt');
    final cuerpoEnviado = jsonDecode(capturada!.body) as Map<String, dynamic>;
    expect(cuerpoEnviado['game_id'], 'uno-roto');
    expect(cuerpoEnviado['title'], 'Las fracciones');
    expect(cuerpoEnviado['content_meta'], {'palabras': 42});
    expect(cuerpoEnviado['anchored_to'], {'habilidad': 'FR.05'});
  });

  test('aJsonParaCrear omite campos opcionales si son null o vacíos',
      () async {
    const entrada = EntradaCuaderno(
      gameId: 'uno-roto',
      title: 'Sin meta',
    );
    final json = entrada.aJsonParaCrear();
    expect(json.keys, containsAll(['game_id', 'title']));
    expect(json.containsKey('type'), isFalse);
    expect(json.containsKey('content_ref'), isFalse);
    expect(json.containsKey('content_meta'), isFalse);
    expect(json.containsKey('anchored_to'), isFalse);
  });

  test('respuesta 401 → ExcepcionApi(401) con mensaje del servidor',
      () async {
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
      () => cliente.crearEntradaCuaderno(
        token: 'tok-malo',
        entrada: entradaEjemplo(),
      ),
      throwsA(
        isA<ExcepcionApi>()
            .having((e) => e.codigo, 'codigo', 401)
            .having(
              (e) => e.mensaje,
              'mensaje',
              contains('Token no válido'),
            ),
      ),
    );
  });

  test('respuesta 400 con invalid_fields → ExcepcionApi(400) con mensaje',
      () async {
    final mock = MockClient((_) async => http.Response(
          jsonEncode({
            'code': 'campos_invalidos',
            'message': 'Algunos campos no pasan la validación.',
            'data': {
              'status': 400,
              'invalid_fields': {'title': 'requerido'},
            },
          }),
          400,
        ));
    final cliente = ClienteCompanion(
      urlBase: 'https://backend.example',
      cliente: mock,
    );

    expect(
      () => cliente.crearEntradaCuaderno(
        token: 'tok',
        entrada: entradaEjemplo(),
      ),
      throwsA(
        isA<ExcepcionApi>()
            .having((e) => e.codigo, 'codigo', 400)
            .having((e) => e.mensaje, 'mensaje', contains('validación')),
      ),
    );
  });

  test('respuesta 500 con cuerpo no-JSON → ExcepcionApi(500) genérica',
      () async {
    final mock = MockClient(
      (_) async => http.Response('<html>boom</html>', 500),
    );
    final cliente = ClienteCompanion(
      urlBase: 'https://backend.example',
      cliente: mock,
    );

    expect(
      () => cliente.crearEntradaCuaderno(
        token: 'tok',
        entrada: entradaEjemplo(),
      ),
      throwsA(
        isA<ExcepcionApi>().having((e) => e.codigo, 'codigo', 500),
      ),
    );
  });

  test('Host override aparece en cabeceras (Local WP)', () async {
    Map<String, String>? cabeceras;
    final mock = MockClient((request) async {
      cabeceras = request.headers;
      return http.Response(
        jsonEncode({
          'id': 1,
          'game_id': 'uno-roto',
          'type': '',
          'title': 'X',
          'content_ref': '',
          'created_at': '2026-04-29 21:30:00',
        }),
        201,
      );
    });
    final cliente = ClienteCompanion(
      urlBase: 'http://127.0.0.1:10063',
      hostOverride: 'uno-roto.local',
      cliente: mock,
    );
    await cliente.crearEntradaCuaderno(
      token: 'tok',
      entrada: const EntradaCuaderno(gameId: 'uno-roto', title: 'X'),
    );
    expect(cabeceras!['Host'], 'uno-roto.local');
  });
}
