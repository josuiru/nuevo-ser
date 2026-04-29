import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:nuevo_ser_core/nuevo_ser_core.dart';

void main() {
  group('ManifestPaqueteAudio.fromJson', () {
    test('parsea el shape canónico y normaliza sha256 a minúsculas', () {
      final m = ManifestPaqueteAudio.fromJson({
        'version': 3,
        'url': 'https://backend.example/wp-content/uploads/audio_v3.zip',
        'sha256': 'ABCDEF0123456789',
        'tamano_bytes': 1572864,
      });
      expect(m.version, 3);
      expect(m.urlPaquete,
          'https://backend.example/wp-content/uploads/audio_v3.zip');
      expect(m.sha256Hex, 'abcdef0123456789');
      expect(m.tamanoBytes, 1572864);
    });

    test('tamanoLegible muestra MB con un decimal', () {
      const m = ManifestPaqueteAudio(
        version: 1,
        urlPaquete: 'x',
        sha256Hex: 'x',
        tamanoBytes: 1572864, // 1.5 MB exactos
      );
      expect(m.tamanoLegible, '1.5 MB');
    });
  });

  group('DescargandoAudio.fraccion', () {
    test('mapea recibido/total a 0..1', () {
      const e = DescargandoAudio(50, 200);
      expect(e.fraccion, 0.25);
    });

    test('clampa al rango cuando recibido excede el total', () {
      const e = DescargandoAudio(300, 200);
      expect(e.fraccion, 1.0);
    });

    test('devuelve -1 cuando totalBytes es 0 (server sin Content-Length)',
        () {
      const e = DescargandoAudio(50, 0);
      expect(e.fraccion, -1);
    });
  });

  group('obtenerManifest', () {
    DescargadorAudio crear(http.Client cliente) {
      return DescargadorAudio(
        urlManifest: Uri.parse('https://backend.example/manifest'),
        userAgent: 'TestUA/1.0',
        cliente: cliente,
        rutaBaseCache: () async => '/tmp/cache_no_se_usa',
        leerVersion: () async => null,
        escribirVersion: (_) async {},
        borrarVersion: () async {},
      );
    }

    test('200 con shape válido → ManifestPaqueteAudio', () async {
      http.BaseRequest? capturada;
      final mock = MockClient((request) async {
        capturada = request;
        return http.Response(
          jsonEncode({
            'version': 7,
            'url': 'https://backend.example/audio_v7.zip',
            'sha256': 'AAAA',
            'tamano_bytes': 1024,
          }),
          200,
        );
      });
      final descargador = crear(mock);

      final m = await descargador.obtenerManifest();

      expect(m.version, 7);
      expect(m.sha256Hex, 'aaaa');
      expect(capturada!.method, 'GET');
      expect(capturada!.headers['User-Agent'], 'TestUA/1.0');
    });

    test('non-200 lanza HttpException', () async {
      final mock =
          MockClient((_) async => http.Response('boom', 500));
      final descargador = crear(mock);

      expect(() => descargador.obtenerManifest(), throwsA(isA<Exception>()));
    });

    test('hostOverride aparece como cabecera Host cuando se pasa', () async {
      Map<String, String>? cabeceras;
      final mock = MockClient((request) async {
        cabeceras = request.headers;
        return http.Response(
          jsonEncode({
            'version': 1,
            'url': 'x',
            'sha256': 'aa',
            'tamano_bytes': 1,
          }),
          200,
        );
      });
      final descargador = DescargadorAudio(
        urlManifest: Uri.parse('http://127.0.0.1:10063/manifest'),
        userAgent: 'TestUA/1.0',
        hostOverride: 'mi-juego.local',
        cliente: mock,
        rutaBaseCache: () async => '/tmp/x',
        leerVersion: () async => null,
        escribirVersion: (_) async {},
        borrarVersion: () async {},
      );

      await descargador.obtenerManifest();
      expect(cabeceras!['Host'], 'mi-juego.local');
      expect(cabeceras!['User-Agent'], 'TestUA/1.0');
    });
  });

  group('versionLocal/borrarCache delegan en los callbacks', () {
    test('versionLocal devuelve lo que retorne leerVersion', () async {
      var llamadas = 0;
      final descargador = DescargadorAudio(
        urlManifest: Uri.parse('https://x'),
        userAgent: 'X',
        cliente: MockClient((_) async => http.Response('', 500)),
        rutaBaseCache: () async => '/tmp/x',
        leerVersion: () async {
          llamadas++;
          return 5;
        },
        escribirVersion: (_) async {},
        borrarVersion: () async {},
      );

      expect(await descargador.versionLocal(), 5);
      expect(llamadas, 1);
    });

    test('borrarCache invoca borrarVersion + invalidarLocalizador',
        () async {
      var borradas = 0;
      var invalidadas = 0;
      final descargador = DescargadorAudio(
        urlManifest: Uri.parse('https://x'),
        userAgent: 'X',
        cliente: MockClient((_) async => http.Response('', 500)),
        // Path que no existe en disco: el try/catch del descargador lo
        // tolera y seguimos con los callbacks.
        rutaBaseCache: () async =>
            '/tmp/no_existe_${DateTime.now().microsecondsSinceEpoch}',
        leerVersion: () async => null,
        escribirVersion: (_) async {},
        borrarVersion: () async {
          borradas++;
        },
        invalidarLocalizador: () {
          invalidadas++;
        },
      );

      await descargador.borrarCache();

      expect(borradas, 1);
      expect(invalidadas, 1);
    });
  });
}
