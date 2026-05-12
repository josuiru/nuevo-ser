// Tests del cliente HTTP del package compartido. Existen también tests
// más profundos de cada endpoint en `apps/uno-roto/test/cliente_api_test.dart`
// (legado: ese app fue el primer y único consumidor durante meses).
// Este archivo vive en el package para garantizar que cualquier app
// nueva que importe `nuevo_ser_core` pueda confiar en el contrato sin
// depender de uno-roto.

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:nuevo_ser_core/nuevo_ser_core.dart';

void main() {
  const urlBase = 'https://test.example.org';

  group('ClienteApi — cabeceras HTTP', () {
    test('userAgent por defecto es genérico (no ata el package a una app)', () async {
      String? userAgentRecibido;
      final mock = MockClient((peticion) async {
        userAgentRecibido = peticion.headers['User-Agent'];
        return http.Response(jsonEncode({'token': 't', 'nino_id': 1}), 200);
      });

      final api = ClienteApi(urlBase: urlBase, cliente: mock);
      await api.iniciarSesion(email: 'a@b.c', password: 'clave-larga');

      expect(userAgentRecibido, isNotNull);
      expect(userAgentRecibido, isNotEmpty);
      expect(userAgentRecibido, ClienteApi.userAgentPorDefecto);
      expect(
        userAgentRecibido,
        isNot(matches(RegExp(r'UnoRoto', caseSensitive: false))),
        reason: 'El default no debería referirse a una app concreta — eso confunde métricas',
      );
    });

    test('userAgent inyectado se envía tal cual', () async {
      String? userAgentRecibido;
      final mock = MockClient((peticion) async {
        userAgentRecibido = peticion.headers['User-Agent'];
        return http.Response(jsonEncode({'token': 't', 'nino_id': 1}), 200);
      });

      final api = ClienteApi(
        urlBase: urlBase,
        cliente: mock,
        userAgent: 'LasVersiones/0.5 (iOS)',
      );
      await api.iniciarSesion(email: 'a@b.c', password: 'clave-larga');

      expect(userAgentRecibido, 'LasVersiones/0.5 (iOS)');
    });

    test('hostOverride se envía como cabecera Host cuando está presente', () async {
      String? hostRecibido;
      final mock = MockClient((peticion) async {
        hostRecibido = peticion.headers['Host'];
        return http.Response(jsonEncode({'token': 't', 'nino_id': 1}), 200);
      });

      final api = ClienteApi(
        urlBase: urlBase,
        cliente: mock,
        hostOverride: 'uno-roto.local',
      );
      await api.iniciarSesion(email: 'a@b.c', password: 'clave-larga');

      expect(hostRecibido, 'uno-roto.local');
    });
  });

  group('ClienteApi — solicitarResetPassword (anti-enumeración)', () {
    test('200 con cualquier email: no lanza, no revela existencia', () async {
      final mock = MockClient((peticion) async {
        // El servidor real responde 200 también si el email no existe
        // (anti-enumeración). El cliente no debe distinguir.
        return http.Response(jsonEncode({'ok': true}), 200);
      });
      final api = ClienteApi(urlBase: urlBase, cliente: mock);

      // Verificar que ninguna de las dos llamadas lanza.
      await api.solicitarResetPassword(email: 'existe@ejemplo.org');
      await api.solicitarResetPassword(email: 'no-existe@ejemplo.org');
    });
  });

  group('ClienteApi — anadirNinoACuentaExistente', () {
    test('serializa email + password + nombre_nino y decodifica token', () async {
      Map<String, dynamic>? cuerpoEnviado;
      final mock = MockClient((peticion) async {
        cuerpoEnviado = jsonDecode(peticion.body) as Map<String, dynamic>;
        return http.Response(
          jsonEncode({'token': 'tok-nuevo', 'nino_id': 99}),
          201,
        );
      });

      final api = ClienteApi(urlBase: urlBase, cliente: mock);
      final resp = await api.anadirNinoACuentaExistente(
        email: 'padre@ejemplo.org',
        password: 'clave-segura',
        nombreNino: 'Maren',
      );

      expect(cuerpoEnviado!['email'], 'padre@ejemplo.org');
      expect(cuerpoEnviado!['nombre_nino'], 'Maren');
      expect(cuerpoEnviado!['locale'], 'es');
      expect(resp.token, 'tok-nuevo');
      expect(resp.ninoId, 99);
    });
  });
}
