import 'dart:convert';

import 'package:el_cuaderno/datos/cliente_tutor_cuaderno.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:nuevo_ser_core/nuevo_ser_core.dart';

void main() {
  ClienteTutorCuaderno crear({required http.Client cliente, String? token}) {
    return ClienteTutorCuaderno(
      urlBase: 'https://example.test',
      cliente: cliente,
      obtenerToken: () async => token,
    );
  }

  group('ContextoTutor.aJson', () {
    test('contexto vacío serializa a {}', () {
      expect(const ContextoTutor.vacio().aJson(), <String, Object?>{});
    });

    test('omite los nulos y las cadenas vacías', () {
      final json = const ContextoTutor(
        edad: 11,
        regionCode: '',
        season: 'primavera',
      ).aJson();
      expect(json, {'edad': 11, 'season': 'primavera'});
    });

    test('serializa todos los campos rellenados', () {
      final json = const ContextoTutor(
        edad: 11,
        regionCode: 'ES-NA-PA',
        season: 'primavera',
        skillId: 'TAX.05',
        nivelSkill: 2,
        observacionAdjunta: 'pájaro pequeño marrón',
      ).aJson();
      expect(json, {
        'edad': 11,
        'region_code': 'ES-NA-PA',
        'season': 'primavera',
        'skill_id': 'TAX.05',
        'nivel_skill': 2,
        'observacion_adjunta': 'pájaro pequeño marrón',
      });
    });
  });

  group('preguntar', () {
    test('envía pregunta + idioma + contexto al endpoint correcto', () async {
      late http.Request capturada;
      final mock = MockClient((peticion) async {
        capturada = peticion;
        return http.Response(
          jsonEncode({
            'respuesta': 'Limonera. Coincide con la clave.',
            'prompt_version': 'cuaderno-v1-2026-04-30',
            'filtro': 'aceptada',
            'tiene_nombre_cientifico': false,
          }),
          200,
          headers: const {'content-type': 'application/json; charset=utf-8'},
        );
      });
      final cliente = crear(cliente: mock, token: 'TOKEN');
      final r = await cliente.preguntar(
        pregunta: '¿es una limonera?',
        idioma: 'es',
        contexto: const ContextoTutor(edad: 11, skillId: 'TAX.05'),
      );

      expect(capturada.url.toString(),
          'https://example.test/wp-json/nuevo-ser/v1/el-cuaderno/tutor');
      expect(capturada.method, 'POST');
      expect(capturada.headers['Authorization'], 'Bearer TOKEN');

      final cuerpo = jsonDecode(capturada.body) as Map<String, dynamic>;
      expect(cuerpo['pregunta'], '¿es una limonera?');
      expect(cuerpo['idioma'], 'es');
      expect(cuerpo['contexto'], {'edad': 11, 'skill_id': 'TAX.05'});

      expect(r.respuesta, 'Limonera. Coincide con la clave.');
      expect(r.promptVersion, 'cuaderno-v1-2026-04-30');
      expect(r.filtro, FiltroTutor.aceptada);
      expect(r.tieneNombreCientifico, isFalse);
    });

    test('contexto vacío no añade el campo al cuerpo', () async {
      late http.Request capturada;
      final mock = MockClient((peticion) async {
        capturada = peticion;
        return http.Response(
          jsonEncode({
            'respuesta': 'No lo sé.',
            'prompt_version': 'cuaderno-v1-2026-04-30',
            'filtro': 'aceptada',
            'tiene_nombre_cientifico': false,
          }),
          200,
          headers: const {'content-type': 'application/json; charset=utf-8'},
        );
      });
      final cliente = crear(cliente: mock, token: 'TOKEN');
      await cliente.preguntar(pregunta: 'hola');
      final cuerpo = jsonDecode(capturada.body) as Map<String, dynamic>;
      expect(cuerpo.containsKey('contexto'), isFalse);
    });

    test('mapea cada estado del filtro', () async {
      for (final entrada in const [
        ('aceptada', FiltroTutor.aceptada),
        ('regenerada', FiltroTutor.regenerada),
        ('reemplazada_canonico', FiltroTutor.reemplazadaCanonico),
        ('fallback_filtrado', FiltroTutor.fallbackFiltrado),
      ]) {
        final mock = MockClient((_) async => http.Response(
              jsonEncode({
                'respuesta': 'x',
                'prompt_version': 'cuaderno-v1-2026-04-30',
                'filtro': entrada.$1,
                'tiene_nombre_cientifico': false,
              }),
              200,
              headers: const {'content-type': 'application/json; charset=utf-8'},
            ));
        final cliente = crear(cliente: mock, token: 'TOKEN');
        final r = await cliente.preguntar(pregunta: 'hola');
        expect(r.filtro, entrada.$2,
            reason: 'mapping de "${entrada.$1}" → ${entrada.$2}');
      }
    });

    test('429 lanza CuotaTutorAgotada con mensaje canónico', () async {
      final mock = MockClient((_) async => http.Response(
            jsonEncode({
              'mensaje_cuota': 'Hoy hemos hablado mucho. Volvemos mañana.',
              'turnos_dia': 30,
              'turnos_semana': 200,
            }),
            429,
            headers: const {'content-type': 'application/json; charset=utf-8'},
          ));
      final cliente = crear(cliente: mock, token: 'TOKEN');
      await expectLater(
        () => cliente.preguntar(pregunta: 'hola'),
        throwsA(isA<CuotaTutorAgotada>().having(
          (e) => e.mensaje,
          'mensaje',
          'Hoy hemos hablado mucho. Volvemos mañana.',
        )),
      );
    });

    test('sin token lanza ExcepcionApi 401 sin tocar la red', () async {
      var redLlamada = false;
      final mock = MockClient((_) async {
        redLlamada = true;
        return http.Response('', 200);
      });
      final cliente = crear(cliente: mock, token: '');
      await expectLater(
        () => cliente.preguntar(pregunta: 'hola'),
        throwsA(isA<ExcepcionApi>().having((e) => e.codigo, 'codigo', 401)),
      );
      expect(redLlamada, isFalse);
    });

    test('5xx se traduce a ExcepcionApi', () async {
      final mock = MockClient((_) async => http.Response(
            jsonEncode({'message': 'tutor backend caído'}),
            502,
            headers: const {'content-type': 'application/json; charset=utf-8'},
          ));
      final cliente = crear(cliente: mock, token: 'TOKEN');
      await expectLater(
        () => cliente.preguntar(pregunta: 'hola'),
        throwsA(isA<ExcepcionApi>()
            .having((e) => e.codigo, 'codigo', 502)
            .having((e) => e.mensaje, 'mensaje', 'tutor backend caído')),
      );
    });

    test('FiltroTutor.fromString rechaza valores desconocidos', () {
      expect(
        () => FiltroTutor.fromString('inexistente'),
        throwsA(isA<ArgumentError>()),
      );
    });
  });
}
