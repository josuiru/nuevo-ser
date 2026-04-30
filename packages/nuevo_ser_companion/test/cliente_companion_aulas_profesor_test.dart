import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:nuevo_ser_companion/nuevo_ser_companion.dart';
import 'package:nuevo_ser_core/nuevo_ser_core.dart';

/// Tests del cliente del profesor (B7) — endpoints `POST /classrooms`
/// y `GET /classrooms/{id}/aggregates`. Sin tocar red: MockClient.
void main() {
  group('POST /classrooms (profesor crea aula)', () {
    test('201 con shape completo devuelve AulaCreada', () async {
      http.Request? capturada;
      final mock = MockClient((request) async {
        capturada = request;
        return http.Response(
          jsonEncode({
            'classroom_id': 42,
            'code': 'MARMOTAS',
            'name': '6º A',
            'language': 'es',
            'game_ids': ['el-cuaderno', 'uno-roto'],
            'active': true,
            'created_at': '2026-04-30 12:00:00',
          }),
          201,
          headers: {'content-type': 'application/json'},
        );
      });
      final cliente = ClienteCompanion(
        urlBase: 'https://backend.example',
        cliente: mock,
      );

      final aula = await cliente.crearAula(
        token: 'tok-prof',
        name: '6º A',
        gameIds: const ['el-cuaderno', 'uno-roto'],
      );

      expect(aula.classroomId, 42);
      expect(aula.code, 'MARMOTAS');
      expect(aula.name, '6º A');
      expect(aula.language, 'es');
      expect(aula.gameIds, ['el-cuaderno', 'uno-roto']);
      expect(aula.active, isTrue);
      expect(aula.createdAt, DateTime.parse('2026-04-30 12:00:00'));

      expect(capturada!.method, 'POST');
      expect(
        capturada!.url.toString(),
        'https://backend.example/wp-json/nuevo-ser/v1/classrooms',
      );
      expect(capturada!.headers['Authorization'], 'Bearer tok-prof');
      final cuerpo = jsonDecode(capturada!.body) as Map<String, dynamic>;
      expect(cuerpo['name'], '6º A');
      expect(cuerpo['language'], 'es');
      expect(cuerpo['game_ids'], ['el-cuaderno', 'uno-roto']);
    });

    test('422 con invalid_fields lanza ExcepcionApi(422)', () async {
      final mock = MockClient((_) async => http.Response(
            jsonEncode({
              'code': 'campos_invalidos',
              'message': 'Los datos del aula no pasan la validación.',
              'data': {
                'status': 422,
                'invalid_fields': {'game_ids': 'no_catalogados'},
              },
            }),
            422,
            headers: {'content-type': 'application/json'},
          ));
      final cliente = ClienteCompanion(
        urlBase: 'https://backend.example',
        cliente: mock,
      );

      await expectLater(
        () => cliente.crearAula(
          token: 'tok-prof',
          name: 'X',
          gameIds: const ['game-inexistente'],
        ),
        throwsA(isA<ExcepcionApi>().having((e) => e.codigo, 'codigo', 422)),
      );
    });

    test('401 con token de niño (tipo != profesor) lanza ExcepcionApi(401)',
        () async {
      final mock = MockClient((_) async => http.Response(
            jsonEncode({
              'code': 'jwt_no_profesor',
              'message': 'Hace falta un token de profesor.',
              'data': {'status': 401},
            }),
            401,
          ));
      final cliente = ClienteCompanion(
        urlBase: 'https://backend.example',
        cliente: mock,
      );
      await expectLater(
        () => cliente.crearAula(
          token: 'tok-nino',
          name: '6º A',
          gameIds: const ['el-cuaderno'],
        ),
        throwsA(isA<ExcepcionApi>().having((e) => e.codigo, 'codigo', 401)),
      );
    });
  });

  group('GET /classrooms/{id}/aggregates (profesor lee agregados)', () {
    test('200 devuelve AgregadosAula con counts por juego', () async {
      http.Request? capturada;
      final mock = MockClient((request) async {
        capturada = request;
        return http.Response(
          jsonEncode({
            'classroom_id': 42,
            'code': 'MARMOTAS',
            'name': '6º A',
            'language': 'es',
            'iso_week': '2026-W17',
            'member_count': 12,
            'reporting_count': 8,
            'aggregates': {
              'el-cuaderno': {
                'observaciones_total': 47,
                'observaciones_por_misterio': {
                  'MIST.AVES.GOLONDRINAS_OTONO': 6,
                  'MIST.PLANTAS.ALMENDRO_FLORACION': 9,
                },
              },
            },
          }),
          200,
        );
      });
      final cliente = ClienteCompanion(
        urlBase: 'https://backend.example',
        cliente: mock,
      );

      final agregados = await cliente.obtenerAgregadosAula(
        token: 'tok-prof',
        classroomId: 42,
        gameId: 'el-cuaderno',
        isoWeek: '2026-W17',
      );

      expect(agregados.classroomId, 42);
      expect(agregados.isoWeek, '2026-W17');
      expect(agregados.memberCount, 12);
      expect(agregados.reportingCount, 8);
      expect(
        agregados.aggregates['el-cuaderno']?['observaciones_total'],
        47,
      );
      final porMisterio =
          agregados.aggregates['el-cuaderno']?['observaciones_por_misterio'];
      expect(porMisterio, isA<Map>());
      expect(
        (porMisterio as Map)['MIST.AVES.GOLONDRINAS_OTONO'],
        6,
      );

      expect(capturada!.method, 'GET');
      expect(capturada!.url.queryParameters['game_id'], 'el-cuaderno');
      expect(capturada!.url.queryParameters['iso_week'], '2026-W17');
      expect(
        capturada!.url.path,
        '/wp-json/nuevo-ser/v1/classrooms/42/aggregates',
      );
    });

    test('sin filtros, no se añaden query params', () async {
      http.Request? capturada;
      final mock = MockClient((request) async {
        capturada = request;
        return http.Response(
          jsonEncode({
            'classroom_id': 42,
            'code': 'MARMOTAS',
            'name': '6º A',
            'language': 'es',
            'iso_week': '2026-W17',
            'member_count': 5,
            'reporting_count': 5,
            'aggregates': {},
          }),
          200,
        );
      });
      final cliente = ClienteCompanion(
        urlBase: 'https://backend.example',
        cliente: mock,
      );
      await cliente.obtenerAgregadosAula(
        token: 'tok-prof',
        classroomId: 42,
      );
      expect(capturada!.url.queryParameters, isEmpty);
    });

    test('403 k_minimo_no_alcanzado lanza ExcepcionApi(403)', () async {
      final mock = MockClient((_) async => http.Response(
            jsonEncode({
              'code': 'ns_aulas_k_minimo_no_alcanzado',
              'message':
                  'El aula necesita al menos 5 miembros activos para que la vista de agregados sea visible.',
              'data': {
                'status': 403,
                'k_minimo': 5,
                'miembros_activos': 3,
              },
            }),
            403,
          ));
      final cliente = ClienteCompanion(
        urlBase: 'https://backend.example',
        cliente: mock,
      );
      await expectLater(
        () => cliente.obtenerAgregadosAula(
          token: 'tok-prof',
          classroomId: 42,
        ),
        throwsA(isA<ExcepcionApi>().having((e) => e.codigo, 'codigo', 403)),
      );
    });

    test('403 aula no propia lanza ExcepcionApi(403)', () async {
      final mock = MockClient((_) async => http.Response(
            jsonEncode({
              'code': 'ns_aulas_no_propia',
              'message':
                  'No tienes permiso para ver los agregados de este aula.',
              'data': {'status': 403},
            }),
            403,
          ));
      final cliente = ClienteCompanion(
        urlBase: 'https://backend.example',
        cliente: mock,
      );
      await expectLater(
        () => cliente.obtenerAgregadosAula(
          token: 'tok-otro-prof',
          classroomId: 42,
        ),
        throwsA(isA<ExcepcionApi>().having((e) => e.codigo, 'codigo', 403)),
      );
    });

    test('404 aula no existe', () async {
      final mock = MockClient((_) async => http.Response(
            jsonEncode({
              'code': 'ns_aulas_no_existe',
              'message': 'No existe un aula con ese identificador.',
              'data': {'status': 404},
            }),
            404,
          ));
      final cliente = ClienteCompanion(
        urlBase: 'https://backend.example',
        cliente: mock,
      );
      await expectLater(
        () => cliente.obtenerAgregadosAula(
          token: 'tok-prof',
          classroomId: 9999,
        ),
        throwsA(isA<ExcepcionApi>().having((e) => e.codigo, 'codigo', 404)),
      );
    });
  });
}
