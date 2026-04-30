import 'dart:convert';

import 'package:el_cuaderno/datos/cliente_el_cuaderno.dart';
import 'package:el_cuaderno/dominio/nivel_confianza.dart';
import 'package:el_cuaderno/dominio/observacion.dart';
import 'package:el_cuaderno/dominio/sit_spot.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:nuevo_ser_core/nuevo_ser_core.dart';

void main() {
  ClienteElCuaderno crear({required http.Client cliente, String? token}) {
    return ClienteElCuaderno(
      urlBase: 'https://example.test',
      cliente: cliente,
      obtenerToken: () async => token,
    );
  }

  group('hashearWhatSeen', () {
    test('produce sha256 hex (lowercase) determinista', () {
      // Vector conocido: sha256("abc") = ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad
      expect(
        ClienteElCuaderno.hashearWhatSeen('abc'),
        'ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad',
      );
    });

    test('soporta acentos y ñ del castellano', () {
      final hash = ClienteElCuaderno.hashearWhatSeen('Cigüeña en el campanario');
      expect(hash.length, 64);
      expect(RegExp(r'^[0-9a-f]{64}$').hasMatch(hash), isTrue);
    });

    test('hash es estable entre llamadas con la misma entrada', () {
      final a = ClienteElCuaderno.hashearWhatSeen('observación');
      final b = ClienteElCuaderno.hashearWhatSeen('observación');
      expect(a, b);
    });
  });

  group('crearObservacion', () {
    Observacion observacionEjemplo() {
      return Observacion(
        id: '7f3c0e26-94e8-4b3a-9a2b-d7c1d5e2f834',
        cuandoCreada: DateTime.utc(2026, 4, 30, 17, 48),
        cuandoOcurrio: DateTime.utc(2026, 4, 30, 17, 30),
        dondeNombre: 'El Roble Grande',
        queVio: 'Tres pájaros pequeños marrones saltando entre las hojas',
        confianza: NivelConfianza.hipotesisActiva,
        creesQueEs: 'petirrojo',
        sitSpotId: '11112222-3333-4444-5555-666677778888',
      );
    }

    test('envía hash y omite el texto en claro', () async {
      late http.Request capturada;
      final mock = MockClient((peticion) async {
        capturada = peticion;
        return http.Response(
          jsonEncode({
            'id': 42,
            'uuid': '7f3c0e26-94e8-4b3a-9a2b-d7c1d5e2f834',
            'occurred_at': '2026-04-30 17:30:00',
            'idempotent': false,
          }),
          201,
        );
      });

      final cliente = crear(cliente: mock, token: 'TOKEN');
      final respuesta = await cliente.crearObservacion(
        observacionEjemplo(),
        regionCode: 'ES-NA-PA',
      );

      final cuerpo = jsonDecode(capturada.body) as Map<String, dynamic>;
      expect(cuerpo.containsKey('what_seen'), isFalse,
          reason: 'frontera de privacidad: el texto libre nunca cruza red');
      expect(
        cuerpo['what_seen_hash'],
        ClienteElCuaderno.hashearWhatSeen(
          'Tres pájaros pequeños marrones saltando entre las hojas',
        ),
      );
      expect(cuerpo['uuid'], '7f3c0e26-94e8-4b3a-9a2b-d7c1d5e2f834');
      expect(cuerpo['region_code'], 'ES-NA-PA');
      expect(cuerpo['confidence'], 'hipotesis_activa');
      expect(cuerpo['proposed_id'], 'petirrojo');
      expect(cuerpo['has_photo'], false);
      expect(cuerpo['has_drawing'], false);

      expect(capturada.headers['Authorization'], 'Bearer TOKEN');
      expect(capturada.headers['Content-Type']?.startsWith('application/json'),
          isTrue);

      expect(respuesta.id, 42);
      expect(respuesta.idempotente, isFalse);
    });

    test('mapea NivelConfianza.consenso a "consenso" en el wire', () async {
      late http.Request capturada;
      final mock = MockClient((peticion) async {
        capturada = peticion;
        return http.Response(
          jsonEncode({'id': 1, 'uuid': '7f3c0e26-94e8-4b3a-9a2b-d7c1d5e2f834', 'idempotent': false}),
          201,
        );
      });
      final cliente = crear(cliente: mock, token: 'TOKEN');
      await cliente.crearObservacion(
        observacionEjemplo().copyWith(
          confianza: NivelConfianza.consenso,
          creesQueEs: 'petirrojo',
        ),
        regionCode: 'ES-NA-PA',
      );
      final cuerpo = jsonDecode(capturada.body) as Map<String, dynamic>;
      expect(cuerpo['confidence'], 'consenso');
    });

    test('idempotencia: 200 con idempotent=true', () async {
      final mock = MockClient((_) async => http.Response(
            jsonEncode({
              'id': 99,
              'uuid': '7f3c0e26-94e8-4b3a-9a2b-d7c1d5e2f834',
              'occurred_at': '2026-04-30 17:30:00',
              'idempotent': true,
            }),
            200,
          ));
      final cliente = crear(cliente: mock, token: 'TOKEN');
      final respuesta = await cliente.crearObservacion(
        observacionEjemplo(),
        regionCode: 'ES-NA-PA',
      );
      expect(respuesta.id, 99);
      expect(respuesta.idempotente, isTrue);
    });

    test('sin token lanza ExcepcionApi 401 sin tocar la red', () async {
      var redLlamada = false;
      final mock = MockClient((_) async {
        redLlamada = true;
        return http.Response('', 200);
      });
      final cliente = crear(cliente: mock, token: '');

      await expectLater(
        () => cliente.crearObservacion(
          observacionEjemplo(),
          regionCode: 'ES-NA-PA',
        ),
        throwsA(isA<ExcepcionApi>().having((e) => e.codigo, 'codigo', 401)),
      );
      expect(redLlamada, isFalse);
    });

    test('sin regionCode explícito y con coordenadas: deriva NUTS-3', () async {
      late http.Request capturada;
      final mock = MockClient((peticion) async {
        capturada = peticion;
        return http.Response(
          jsonEncode({
            'id': 1,
            'uuid': '7f3c0e26-94e8-4b3a-9a2b-d7c1d5e2f834',
            'idempotent': false,
          }),
          201,
        );
      });
      final cliente = crear(cliente: mock, token: 'TOKEN');
      // Pamplona — debe normalizarse a ES-NA-PA sin que las coords
      // crucen red.
      final observacionConCoords = observacionEjemplo().copyWith(
        dondeCoordenadas: const Coordenadas(lat: 42.8125, lng: -1.6458),
      );
      await cliente.crearObservacion(observacionConCoords);

      final cuerpo = jsonDecode(capturada.body) as Map<String, dynamic>;
      expect(cuerpo['region_code'], 'ES-NA-PA');
      // Frontera de privacidad: lat/lng nunca cruzan red.
      expect(cuerpo.containsKey('lat'), isFalse);
      expect(cuerpo.containsKey('lng'), isFalse);
      expect(cuerpo.containsKey('dondeCoordenadas'), isFalse);
      expect(cuerpo.containsKey('coordenadas'), isFalse);
    });

    test('sin regionCode explícito y sin coordenadas: fallback ES (NUTS-0)',
        () async {
      late http.Request capturada;
      final mock = MockClient((peticion) async {
        capturada = peticion;
        return http.Response(
          jsonEncode({
            'id': 1,
            'uuid': '7f3c0e26-94e8-4b3a-9a2b-d7c1d5e2f834',
            'idempotent': false,
          }),
          201,
        );
      });
      final cliente = crear(cliente: mock, token: 'TOKEN');
      await cliente.crearObservacion(observacionEjemplo());
      final cuerpo = jsonDecode(capturada.body) as Map<String, dynamic>;
      expect(cuerpo['region_code'], 'ES');
    });

    test('400 del servidor se traduce a ExcepcionApi con mensaje', () async {
      final mock = MockClient((_) async => http.Response(
            jsonEncode({
              'code': 'campos_invalidos',
              'message': 'Algunos campos no pasan la validación.',
            }),
            400,
          ));
      final cliente = crear(cliente: mock, token: 'TOKEN');
      await expectLater(
        () => cliente.crearObservacion(
          observacionEjemplo(),
          regionCode: 'ES-NA-PA',
        ),
        throwsA(isA<ExcepcionApi>()
            .having((e) => e.codigo, 'codigo', 400)
            .having((e) => e.mensaje, 'mensaje',
                'Algunos campos no pasan la validación.')),
      );
    });
  });

  group('establecerSitSpot', () {
    test('envía nombre y region_code', () async {
      late http.Request capturada;
      final mock = MockClient((peticion) async {
        capturada = peticion;
        return http.Response(
          jsonEncode({
            'id': 7,
            'uuid': '11112222-3333-4444-5555-666677778888',
            'idempotent': false,
          }),
          201,
        );
      });
      final cliente = crear(cliente: mock, token: 'TOKEN');
      final sitSpot = SitSpot(
        id: '11112222-3333-4444-5555-666677778888',
        nombre: 'El Roble Grande',
        dondeNombre: 'al final del parque, junto al pino más alto',
        creadoEn: DateTime.utc(2026, 4, 30),
      );
      final respuesta = await cliente.establecerSitSpot(
        sitSpot,
        regionCode: 'ES-NA-PA',
      );

      final cuerpo = jsonDecode(capturada.body) as Map<String, dynamic>;
      expect(cuerpo['uuid'], '11112222-3333-4444-5555-666677778888');
      expect(cuerpo['name'], 'El Roble Grande');
      expect(cuerpo['region_code'], 'ES-NA-PA');
      // Coordenadas precisas NUNCA cruzan red:
      expect(cuerpo.containsKey('coordenadas'), isFalse);
      expect(cuerpo.containsKey('coordinates'), isFalse);
      expect(cuerpo.containsKey('lat'), isFalse);
      expect(cuerpo.containsKey('lng'), isFalse);

      expect(respuesta.id, 7);
      expect(respuesta.idempotente, isFalse);
    });

    test('deriva region_code desde sitSpot.coordenadas si no se pasa', () async {
      late http.Request capturada;
      final mock = MockClient((peticion) async {
        capturada = peticion;
        return http.Response(
          jsonEncode({
            'id': 7,
            'uuid': '11112222-3333-4444-5555-666677778888',
            'idempotent': false,
          }),
          201,
        );
      });
      final cliente = crear(cliente: mock, token: 'TOKEN');
      final sitSpotConCoords = SitSpot(
        id: '11112222-3333-4444-5555-666677778888',
        nombre: 'Mi banco del parque',
        dondeNombre: 'Madrid centro',
        creadoEn: DateTime.utc(2026, 4, 30),
        // Madrid → ES-MD vía bounding box piloto.
        coordenadas: const Coordenadas(lat: 40.4168, lng: -3.7038),
      );
      await cliente.establecerSitSpot(sitSpotConCoords);

      final cuerpo = jsonDecode(capturada.body) as Map<String, dynamic>;
      expect(cuerpo['region_code'], 'ES-MD');
      expect(cuerpo.containsKey('lat'), isFalse);
      expect(cuerpo.containsKey('lng'), isFalse);
    });
  });

  group('listarMisterios', () {
    test('serializa region/season y deserializa el array', () async {
      late http.Request capturada;
      final mock = MockClient((peticion) async {
        capturada = peticion;
        return http.Response(
          jsonEncode({
            'misterios': [
              {
                'code': 'MIST.AVES.GOLONDRINAS_OTONO',
                'pregunta_es': '¿Cuándo se van las golondrinas de tu barrio?',
                'descripcion_es': 'Cada año las golondrinas vuelan al sur en otoño…',
                'estado': 'hipotesis_activa',
                'season': ['verano', 'otono'],
                'region_filter': null,
              }
            ],
            'catalogo_total': 2,
            'aplican_filtros': 1,
          }),
          200,
          headers: const {'content-type': 'application/json; charset=utf-8'},
        );
      });
      final cliente = crear(cliente: mock, token: 'TOKEN');
      final respuesta = await cliente.listarMisterios(
        region: 'ES-NA-PA',
        season: 'otono',
      );

      expect(capturada.url.queryParameters['region'], 'ES-NA-PA');
      expect(capturada.url.queryParameters['season'], 'otono');
      expect(respuesta.misterios, hasLength(1));
      expect(respuesta.misterios.single.code, 'MIST.AVES.GOLONDRINAS_OTONO');
      expect(respuesta.misterios.single.season, ['verano', 'otono']);
      expect(respuesta.misterios.single.regionFilter, isNull);
      expect(respuesta.catalogoTotal, 2);
      expect(respuesta.aplicanFiltros, 1);
    });

    test('listarMisteriosParaAhora deriva region+season del lugar y fecha',
        () async {
      late http.Request capturada;
      final mock = MockClient((peticion) async {
        capturada = peticion;
        return http.Response(
          jsonEncode({'misterios': [], 'catalogo_total': 0, 'aplican_filtros': 0}),
          200,
        );
      });
      final cliente = crear(cliente: mock, token: 'TOKEN');
      // Pamplona, 1 de noviembre → ES-NA-PA + otono.
      await cliente.listarMisteriosParaAhora(
        coordenadas: const Coordenadas(lat: 42.8125, lng: -1.6458),
        ahora: DateTime(2026, 11, 1),
      );
      expect(capturada.url.queryParameters['region'], 'ES-NA-PA');
      expect(capturada.url.queryParameters['season'], 'otono');
    });

    test('listarMisteriosParaAhora sin coordenadas omite region pero envía season',
        () async {
      late http.Request capturada;
      final mock = MockClient((peticion) async {
        capturada = peticion;
        return http.Response(
          jsonEncode({'misterios': [], 'catalogo_total': 0, 'aplican_filtros': 0}),
          200,
        );
      });
      final cliente = crear(cliente: mock, token: 'TOKEN');
      await cliente.listarMisteriosParaAhora(
        ahora: DateTime(2026, 7, 15), // verano
      );
      expect(capturada.url.queryParameters.containsKey('region'), isFalse);
      expect(capturada.url.queryParameters['season'], 'verano');
    });

    test('sin filtros omite los query params', () async {
      late http.Request capturada;
      final mock = MockClient((peticion) async {
        capturada = peticion;
        return http.Response(
          jsonEncode({'misterios': [], 'catalogo_total': 0, 'aplican_filtros': 0}),
          200,
        );
      });
      final cliente = crear(cliente: mock, token: 'TOKEN');
      await cliente.listarMisterios();

      expect(capturada.url.queryParameters.containsKey('region'), isFalse);
      expect(capturada.url.queryParameters.containsKey('season'), isFalse);
    });
  });
}
