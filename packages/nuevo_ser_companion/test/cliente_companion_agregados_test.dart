import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:nuevo_ser_companion/nuevo_ser_companion.dart';
import 'package:nuevo_ser_core/nuevo_ser_core.dart';

void main() {
  Map<String, dynamic> agregadosEjemplo() {
    return {
      'minutos_jugados': 42,
      'habilidades_practicadas': ['FR.05', 'FR.07'],
      'mosaicos_completados': 1,
    };
  }

  test('POST /companion/aggregates/weekly: 201 → fila nueva con summary vacío',
      () async {
    http.Request? capturada;
    final mock = MockClient((request) async {
      capturada = request;
      return http.Response(
        jsonEncode({
          'game_id': 'uno-roto',
          'iso_week': '2026-W18',
          'aggregates_hash':
              'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855',
          'summary_text': '',
          'conversation_prompt': null,
          'generated_at': '2026-04-29 22:30:00',
        }),
        201,
        headers: {'content-type': 'application/json'},
      );
    });
    final cliente = ClienteCompanion(
      urlBase: 'https://backend.example',
      cliente: mock,
    );

    final resultado = await cliente.archivarAgregadosSemanales(
      token: 'tok-jwt',
      gameId: 'uno-roto',
      isoWeek: '2026-W18',
      aggregates: agregadosEjemplo(),
    );

    expect(resultado.gameId, 'uno-roto');
    expect(resultado.isoWeek, '2026-W18');
    expect(resultado.aggregatesHash, hasLength(64));
    expect(resultado.summaryText, '');
    expect(resultado.conversationPrompt, isNull);
    expect(resultado.generatedAt, DateTime.parse('2026-04-29 22:30:00'));

    expect(capturada!.method, 'POST');
    expect(
      capturada!.url.toString(),
      'https://backend.example/wp-json/nuevo-ser/v1/companion/aggregates/weekly',
    );
    final cuerpoEnviado = jsonDecode(capturada!.body) as Map<String, dynamic>;
    expect(cuerpoEnviado['game_id'], 'uno-roto');
    expect(cuerpoEnviado['iso_week'], '2026-W18');
    expect(cuerpoEnviado['aggregates'], agregadosEjemplo());
  });

  test(
      'POST /companion/aggregates/weekly: 200 idempotente preserva summary cached',
      () async {
    final mock = MockClient((_) async => http.Response(
          jsonEncode({
            'game_id': 'uno-roto',
            'iso_week': '2026-W18',
            'aggregates_hash':
                '7e2c4b4a2c4f8b9e0d1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c3d',
            'summary_text': 'Has practicado fracciones esta semana, ¡ánimo!',
            'conversation_prompt': '¿Qué te ha costado más?',
            'generated_at': '2026-04-25 09:00:00',
          }),
          200,
        ));
    final cliente = ClienteCompanion(
      urlBase: 'https://backend.example',
      cliente: mock,
    );

    final resultado = await cliente.archivarAgregadosSemanales(
      token: 'tok',
      gameId: 'uno-roto',
      isoWeek: '2026-W18',
      aggregates: agregadosEjemplo(),
    );

    expect(resultado.summaryText,
        'Has practicado fracciones esta semana, ¡ánimo!');
    expect(resultado.conversationPrompt, '¿Qué te ha costado más?');
    // generatedAt es la fecha del cache, no la de ahora.
    expect(resultado.generatedAt, DateTime.parse('2026-04-25 09:00:00'));
  });

  test('archivarAgregadosSemanales: 400 con invalid_fields → ExcepcionApi(400)',
      () async {
    final mock = MockClient((_) async => http.Response(
          jsonEncode({
            'code': 'campos_invalidos',
            'message': 'Algunos campos no pasan la validación.',
            'data': {
              'status': 400,
              'invalid_fields': {'iso_week': 'formato_invalido'},
            },
          }),
          400,
        ));
    final cliente = ClienteCompanion(
      urlBase: 'https://backend.example',
      cliente: mock,
    );

    expect(
      () => cliente.archivarAgregadosSemanales(
        token: 'tok',
        gameId: 'uno-roto',
        isoWeek: 'no-es-iso',
        aggregates: agregadosEjemplo(),
      ),
      throwsA(
        isA<ExcepcionApi>().having((e) => e.codigo, 'codigo', 400),
      ),
    );
  });

  test('archivarAgregadosSemanales: 401 → ExcepcionApi(401)', () async {
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
      () => cliente.archivarAgregadosSemanales(
        token: 'tok-malo',
        gameId: 'uno-roto',
        isoWeek: '2026-W18',
        aggregates: agregadosEjemplo(),
      ),
      throwsA(isA<ExcepcionApi>().having((e) => e.codigo, 'codigo', 401)),
    );
  });

  test('archivarAgregadosSemanales: aggregates anidados se serializan tal cual',
      () async {
    Map<String, dynamic>? cuerpoEnviado;
    final mock = MockClient((request) async {
      cuerpoEnviado = jsonDecode(request.body) as Map<String, dynamic>;
      return http.Response(
        jsonEncode({
          'game_id': 'uno-roto',
          'iso_week': '2026-W18',
          'aggregates_hash': 'a' * 64,
          'summary_text': '',
          'conversation_prompt': null,
          'generated_at': '2026-04-29 22:30:00',
        }),
        201,
      );
    });
    final cliente = ClienteCompanion(
      urlBase: 'https://backend.example',
      cliente: mock,
    );

    await cliente.archivarAgregadosSemanales(
      token: 'tok',
      gameId: 'uno-roto',
      isoWeek: '2026-W18',
      aggregates: {
        'por_distrito': {
          'fracciones': {'minutos': 20, 'aciertos': 12},
          'pleno': {'minutos': 22, 'aciertos': 15},
        },
        'totales': {'minutos': 42, 'mosaicos': 1},
      },
    );

    expect(cuerpoEnviado!['aggregates'], isA<Map>());
    final por_distrito =
        (cuerpoEnviado!['aggregates'] as Map)['por_distrito'] as Map;
    expect(por_distrito['fracciones'], {'minutos': 20, 'aciertos': 12});
  });
}
