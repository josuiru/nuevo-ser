import 'dart:convert';

import 'package:el_cuaderno/datos/cliente_el_cuaderno.dart';
import 'package:el_cuaderno/datos/cola_sync_observaciones.dart';
import 'package:el_cuaderno/dominio/nivel_confianza.dart';
import 'package:el_cuaderno/dominio/observacion.dart';
import 'package:el_cuaderno/infraestructura/memoria/repositorio_memoria.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  ColaSyncObservaciones crearCola() {
    return ColaSyncObservaciones(prefs: SharedPreferences.getInstance);
  }

  ClienteElCuaderno crearCliente(http.Client mock) {
    return ClienteElCuaderno(
      urlBase: 'https://example.test',
      cliente: mock,
      obtenerToken: () async => 'TOKEN',
    );
  }

  Observacion observacion(String uuid, {String que = 'pájaro pequeño'}) {
    return Observacion(
      id: uuid,
      cuandoCreada: DateTime.utc(2026, 4, 30, 17, 48),
      cuandoOcurrio: DateTime.utc(2026, 4, 30, 17, 30),
      dondeNombre: 'El Roble Grande',
      queVio: que,
      confianza: NivelConfianza.hipotesisActiva,
    );
  }

  test('marcarPendiente añade el UUID y es idempotente', () async {
    final cola = crearCola();
    await cola.marcarPendiente('uuid-1');
    await cola.marcarPendiente('uuid-1');
    await cola.marcarPendiente('uuid-2');
    expect(await cola.uuidsPendientes(), ['uuid-1', 'uuid-2']);
  });

  test('uuidsPendientes auto-cura una clave corrupta a vacía', () async {
    SharedPreferences.setMockInitialValues({
      ColaSyncObservaciones.claveSharedPrefs: 'esto-no-es-json',
    });
    final cola = crearCola();
    expect(await cola.uuidsPendientes(), isEmpty);
  });

  test(
    'intentarEnviar éxito 201 saca el UUID de la cola',
    () async {
      final repositorio = RepositorioMemoria();
      await repositorio.guardarObservacion(observacion('uuid-1'));

      final cola = crearCola();
      await cola.marcarPendiente('uuid-1');

      final mock = MockClient((_) async => http.Response(
            jsonEncode({'id': 1, 'uuid': 'uuid-1', 'idempotent': false}),
            201,
          ));
      final cliente = crearCliente(mock);

      final resultado = await cola.intentarEnviar(
        repositorio: repositorio,
        cliente: cliente,
        regionCode: 'ES-NA-PA',
      );

      expect(resultado.enviadas, ['uuid-1']);
      expect(resultado.rechazadas, isEmpty);
      expect(resultado.dejadasParaReintento, isEmpty);
      expect(await cola.uuidsPendientes(), isEmpty);
    },
  );

  test(
    '200 idempotente del servidor cuenta como enviada (no la deja en cola)',
    () async {
      final repositorio = RepositorioMemoria();
      await repositorio.guardarObservacion(observacion('uuid-1'));
      final cola = crearCola();
      await cola.marcarPendiente('uuid-1');

      final mock = MockClient((_) async => http.Response(
            jsonEncode({'id': 1, 'uuid': 'uuid-1', 'idempotent': true}),
            200,
          ));
      final cliente = crearCliente(mock);

      final resultado = await cola.intentarEnviar(
        repositorio: repositorio,
        cliente: cliente,
        regionCode: 'ES-NA-PA',
      );

      expect(resultado.enviadas, ['uuid-1']);
      expect(await cola.uuidsPendientes(), isEmpty);
    },
  );

  test(
    '4xx irrecuperable saca el UUID de la cola y lo marca rechazado',
    () async {
      final repositorio = RepositorioMemoria();
      await repositorio.guardarObservacion(observacion('uuid-1'));
      final cola = crearCola();
      await cola.marcarPendiente('uuid-1');

      final mock = MockClient((_) async => http.Response(
            jsonEncode({'message': 'Algunos campos no pasan la validación.'}),
            400,
          ));
      final cliente = crearCliente(mock);

      final resultado = await cola.intentarEnviar(
        repositorio: repositorio,
        cliente: cliente,
        regionCode: 'ES-NA-PA',
      );

      expect(resultado.enviadas, isEmpty);
      expect(resultado.rechazadas.map((r) => r.uuid).toList(), ['uuid-1']);
      expect(resultado.rechazadas.single.motivo.codigo, 400);
      expect(await cola.uuidsPendientes(), isEmpty);
    },
  );

  test('5xx deja el UUID en cola para reintento', () async {
    final repositorio = RepositorioMemoria();
    await repositorio.guardarObservacion(observacion('uuid-1'));
    final cola = crearCola();
    await cola.marcarPendiente('uuid-1');

    final mock =
        MockClient((_) async => http.Response('Internal Server Error', 503));
    final cliente = crearCliente(mock);

    final resultado = await cola.intentarEnviar(
      repositorio: repositorio,
      cliente: cliente,
      regionCode: 'ES-NA-PA',
    );

    expect(resultado.enviadas, isEmpty);
    expect(resultado.rechazadas, isEmpty);
    expect(resultado.dejadasParaReintento, ['uuid-1']);
    expect(await cola.uuidsPendientes(), ['uuid-1']);
  });

  test('401 (sesión expirada) deja el UUID para reintentar', () async {
    final repositorio = RepositorioMemoria();
    await repositorio.guardarObservacion(observacion('uuid-1'));
    final cola = crearCola();
    await cola.marcarPendiente('uuid-1');

    final mock = MockClient((_) async => http.Response(
          jsonEncode({'message': 'jwt_expired'}),
          401,
        ));
    final cliente = crearCliente(mock);

    final resultado = await cola.intentarEnviar(
      repositorio: repositorio,
      cliente: cliente,
      regionCode: 'ES-NA-PA',
    );

    expect(resultado.dejadasParaReintento, ['uuid-1']);
    expect(await cola.uuidsPendientes(), ['uuid-1']);
  });

  test('429 (rate limit) deja el UUID para reintentar', () async {
    final repositorio = RepositorioMemoria();
    await repositorio.guardarObservacion(observacion('uuid-1'));
    final cola = crearCola();
    await cola.marcarPendiente('uuid-1');

    final mock = MockClient((_) async => http.Response('rate', 429));
    final resultado = await cola.intentarEnviar(
      repositorio: repositorio,
      cliente: crearCliente(mock),
      regionCode: 'ES-NA-PA',
    );
    expect(resultado.dejadasParaReintento, ['uuid-1']);
  });

  test('UUID en cola sin observación local se descarta sin contar como rechazo',
      () async {
    final repositorio = RepositorioMemoria();
    final cola = crearCola();
    await cola.marcarPendiente('uuid-fantasma');

    var redLlamada = false;
    final mock = MockClient((_) async {
      redLlamada = true;
      return http.Response('', 200);
    });

    final resultado = await cola.intentarEnviar(
      repositorio: repositorio,
      cliente: crearCliente(mock),
      regionCode: 'ES-NA-PA',
    );

    expect(resultado.enviadas, isEmpty);
    expect(resultado.rechazadas, isEmpty);
    expect(resultado.dejadasParaReintento, isEmpty);
    expect(await cola.uuidsPendientes(), isEmpty);
    expect(redLlamada, isFalse,
        reason: 'No tiene sentido enviar una observación que ya no está local');
  });

  test(
    'mezcla: una OK + una 5xx deja la 5xx en cola y saca la OK',
    () async {
      final repositorio = RepositorioMemoria();
      await repositorio.guardarObservacion(observacion('uuid-ok'));
      await repositorio.guardarObservacion(observacion('uuid-down'));
      final cola = crearCola();
      await cola.marcarPendiente('uuid-ok');
      await cola.marcarPendiente('uuid-down');

      var llamadas = 0;
      final mock = MockClient((peticion) async {
        llamadas++;
        final cuerpo = jsonDecode(peticion.body) as Map<String, dynamic>;
        if (cuerpo['uuid'] == 'uuid-ok') {
          return http.Response(
            jsonEncode({'id': 1, 'uuid': 'uuid-ok', 'idempotent': false}),
            201,
          );
        }
        return http.Response('down', 500);
      });

      final resultado = await cola.intentarEnviar(
        repositorio: repositorio,
        cliente: crearCliente(mock),
        regionCode: 'ES-NA-PA',
      );

      expect(llamadas, 2);
      expect(resultado.enviadas, ['uuid-ok']);
      expect(resultado.dejadasParaReintento, ['uuid-down']);
      expect(await cola.uuidsPendientes(), ['uuid-down']);
    },
  );
}
