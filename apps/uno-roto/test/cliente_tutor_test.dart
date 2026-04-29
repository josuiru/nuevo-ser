import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:uno_roto/datos/cache_tutor.dart';
import 'package:uno_roto/datos/cliente_api.dart';
import 'package:uno_roto/datos/cliente_tutor.dart';

void main() {
  const urlBase = 'https://test.example.org';

  group('ClienteTutor', () {
    test('explicar envía payload correcto y decodifica respuesta LLM',
        () async {
      final mock = MockClient((peticion) async {
        expect(peticion.method, 'POST');
        expect(
          peticion.url.toString(),
          '$urlBase/wp-json/nuevo-ser/v1/tutor/explicar',
        );
        expect(peticion.headers['Authorization'], 'Bearer tk');
        expect(peticion.headers['Content-Type'], 'application/json');
        final cuerpo = jsonDecode(peticion.body);
        expect(cuerpo['id_habilidad'], 'FR.05');
        expect(cuerpo['pregunta'], 'No entiendo este');
        expect(cuerpo['contexto_fragmento'], '3/5 vs 4/5');
        return http.Response(
          jsonEncode({
            'explicacion': 'Mismo denominador: el de mayor numerador es mayor.',
            'fuente': 'llm',
          }),
          200,
        );
      });
      final tutor = ClienteTutor(urlBase: urlBase, cliente: mock);
      final r = await tutor.explicar(
        token: 'tk',
        idHabilidad: 'FR.05',
        pregunta: 'No entiendo este',
        contextoFragmento: '3/5 vs 4/5',
      );
      expect(r.explicacion, contains('mayor numerador'));
      expect(r.desdeCache, isFalse);
    });

    test('detecta respuesta cacheada vía fuente=cache', () async {
      final mock = MockClient((_) async {
        return http.Response(
          jsonEncode({'explicacion': 'Respuesta antigua', 'fuente': 'cache'}),
          200,
        );
      });
      final tutor = ClienteTutor(urlBase: urlBase, cliente: mock);
      final r = await tutor.explicar(
        token: 'tk',
        idHabilidad: 'DEC.01',
        pregunta: '?',
      );
      expect(r.desdeCache, isTrue);
    });

    test('omite contexto_fragmento si no se pasa', () async {
      final mock = MockClient((peticion) async {
        final cuerpo = jsonDecode(peticion.body) as Map<String, dynamic>;
        expect(cuerpo.containsKey('contexto_fragmento'), isFalse);
        return http.Response(
          jsonEncode({'explicacion': 'OK', 'fuente': 'llm'}),
          200,
        );
      });
      final tutor = ClienteTutor(urlBase: urlBase, cliente: mock);
      await tutor.explicar(
        token: 'tk',
        idHabilidad: 'X',
        pregunta: 'P',
      );
    });

    test('servidor rechazando con 422 propaga el mensaje', () async {
      final mock = MockClient((_) async {
        return http.Response(
          jsonEncode({'error': 'Eso no es de matemáticas, prueba otra.'}),
          422,
        );
      });
      final tutor = ClienteTutor(urlBase: urlBase, cliente: mock);
      try {
        await tutor.explicar(
          token: 'tk',
          idHabilidad: 'X',
          pregunta: 'pregunta rara',
        );
        fail('Debió lanzar ExcepcionApi');
      } on ExcepcionApi catch (e) {
        expect(e.codigo, 422);
        expect(e.mensaje, contains('matemáticas'));
      }
    });

    test('hostOverride añade cabecera Host', () async {
      final mock = MockClient((peticion) async {
        expect(peticion.headers['Host'], 'uno-roto.local');
        return http.Response(
          jsonEncode({'explicacion': 'OK', 'fuente': 'llm'}),
          200,
        );
      });
      final tutor = ClienteTutor(
        urlBase: urlBase,
        cliente: mock,
        hostOverride: 'uno-roto.local',
      );
      await tutor.explicar(
        token: 'tk',
        idHabilidad: 'X',
        pregunta: 'P',
      );
    });
  });

  group('CacheTutor', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('hit y miss básicos', () async {
      final cache = CacheTutor();
      expect(
        await cache.recuperar(idHabilidad: 'FR.05', pregunta: 'X'),
        isNull,
      );
      await cache.guardar(
        idHabilidad: 'FR.05',
        pregunta: 'X',
        explicacion: 'porque sí',
      );
      expect(
        await cache.recuperar(idHabilidad: 'FR.05', pregunta: 'X'),
        'porque sí',
      );
    });

    test('normalización: mismo contenido con espacios y caso distintos', () async {
      final cache = CacheTutor();
      await cache.guardar(
        idHabilidad: 'FR.05',
        pregunta: 'Cómo Sumo 1/2',
        explicacion: 'Igualas denominadores.',
      );
      // Espacios extra y minúsculas → mismo hit.
      expect(
        await cache.recuperar(
          idHabilidad: 'FR.05',
          pregunta: '  cómo sumo   1/2  ',
        ),
        'Igualas denominadores.',
      );
    });

    test('aislamiento por idHabilidad', () async {
      final cache = CacheTutor();
      await cache.guardar(
        idHabilidad: 'FR.05',
        pregunta: 'X',
        explicacion: 'A',
      );
      expect(
        await cache.recuperar(idHabilidad: 'FR.06', pregunta: 'X'),
        isNull,
      );
    });

    test('TTL caduca entradas viejas y las purga', () async {
      final cache = CacheTutor(ttl: const Duration(days: 1));
      final hace2dias = DateTime(2026, 4, 1);
      await cache.guardar(
        idHabilidad: 'FR.05',
        pregunta: 'X',
        explicacion: 'vieja',
        ahora: hace2dias,
      );
      // Justo antes del corte: aún válida.
      expect(
        await cache.recuperar(
          idHabilidad: 'FR.05',
          pregunta: 'X',
          ahora: hace2dias.add(const Duration(hours: 23)),
        ),
        'vieja',
      );
      // Pasado el TTL: null y purgada.
      expect(
        await cache.recuperar(
          idHabilidad: 'FR.05',
          pregunta: 'X',
          ahora: hace2dias.add(const Duration(days: 2)),
        ),
        isNull,
      );
      expect(cache.tamano, 0);
    });

    test('LRU expulsa la más vieja al pasar el tamaño máximo', () async {
      final cache = CacheTutor(tamanoMaximo: 2);
      final t0 = DateTime(2026, 4, 1);
      await cache.guardar(
        idHabilidad: 'A',
        pregunta: 'a',
        explicacion: 'la más vieja',
        ahora: t0,
      );
      await cache.guardar(
        idHabilidad: 'B',
        pregunta: 'b',
        explicacion: 'media',
        ahora: t0.add(const Duration(minutes: 1)),
      );
      await cache.guardar(
        idHabilidad: 'C',
        pregunta: 'c',
        explicacion: 'la nueva',
        ahora: t0.add(const Duration(minutes: 2)),
      );
      // La más vieja (A) fue expulsada.
      expect(await cache.recuperar(idHabilidad: 'A', pregunta: 'a'), isNull);
      expect(await cache.recuperar(idHabilidad: 'B', pregunta: 'b'), 'media');
      expect(await cache.recuperar(idHabilidad: 'C', pregunta: 'c'), 'la nueva');
    });

    test('persistencia: instancia nueva recupera lo guardado', () async {
      final escritor = CacheTutor();
      await escritor.guardar(
        idHabilidad: 'FR.05',
        pregunta: 'X',
        explicacion: 'persistida',
      );
      // Nueva instancia, mismo SharedPreferences mock.
      final lector = CacheTutor();
      expect(
        await lector.recuperar(idHabilidad: 'FR.05', pregunta: 'X'),
        'persistida',
      );
    });

    test('limpiar borra todo y rompe el cache anterior', () async {
      final cache = CacheTutor();
      await cache.guardar(
        idHabilidad: 'FR.05',
        pregunta: 'X',
        explicacion: 'A',
      );
      await cache.limpiar();
      expect(cache.tamano, 0);
      expect(
        await cache.recuperar(idHabilidad: 'FR.05', pregunta: 'X'),
        isNull,
      );
    });

    test('JSON corrupto en SharedPreferences no rompe la carga', () async {
      SharedPreferences.setMockInitialValues({
        'uroto.tutor.cache.v1': 'no es JSON {{{',
      });
      final cache = CacheTutor();
      // No lanza, simplemente arranca vacío.
      expect(
        await cache.recuperar(idHabilidad: 'FR.05', pregunta: 'X'),
        isNull,
      );
    });
  });
}
