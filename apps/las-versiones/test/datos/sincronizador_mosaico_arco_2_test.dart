import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:nuevo_ser_companion/nuevo_ser_companion.dart' as companion;
import 'package:nuevo_ser_core/nuevo_ser_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:las_versiones/datos/repositorio_mosaico.dart';
import 'package:las_versiones/datos/sincronizador_mosaico.dart';
import 'package:las_versiones/dominio/mosaico_arco_2.dart';

/// Tests del sincronizador del Mosaico del Arco 2 (audio-guía) contra
/// el endpoint `POST /companion/mosaicos`. Mismo patrón que el del
/// M1 — opt-in, lee el token al construir el payload, sin reintento
/// automático, sin cola persistente.
void main() {
  late RepositorioCuentaBackend repoCuenta;
  late RepositorioMosaico repoMosaico;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    repoCuenta = RepositorioCuentaBackend(
      prefs: SharedPreferences.getInstance,
      claveToken: 'nuevoser.lasversiones.token_backend',
      claveEmail: 'nuevoser.lasversiones.email_backend',
    );
    repoMosaico = const RepositorioMosaico();
  });

  Future<void> sembrarMarcas() async {
    await repoMosaico.guardar(MosaicoArco2.idArco, const {
      'pompaelo_la_inscripcion_in_situ': NivelConfianza.solido,
      'pompaelo_lo_que_la_inscripcion_no_dice': NivelConfianza.disputado,
      'calagurris_lo_que_quintiliano_dice': NivelConfianza.solido,
      'calagurris_lo_que_quintiliano_omite': NivelConfianza.probable,
      'domus_la_familia_que_aparece': NivelConfianza.solido,
      'domus_la_familia_que_no_aparece': NivelConfianza.solido,
    });
  }

  http.Response respuesta201({int id = 99}) {
    return http.Response(
      jsonEncode({
        'id': id,
        'game_id': gameIdLasVersiones,
        'arc_id': MosaicoArco2.idArco,
        'format': formatoAudioGuiaArco2,
        'title': MosaicoArco2.titulo,
        'content_ref': '',
        'completed_at': '2026-04-30 14:00:00',
      }),
      201,
      headers: {'content-type': 'application/json; charset=utf-8'},
    );
  }

  companion.ClienteCompanion clienteConRespuesta(http.Response respuesta) {
    final mock = MockClient((_) async => respuesta);
    return companion.ClienteCompanion(
      urlBase: 'https://backend.example',
      cliente: mock,
    );
  }

  companion.ClienteCompanion clienteCapturando({
    required void Function(http.Request) sobreLaRequest,
    required http.Response respuesta,
  }) {
    final mock = MockClient((request) async {
      sobreLaRequest(request);
      return respuesta;
    });
    return companion.ClienteCompanion(
      urlBase: 'https://backend.example',
      cliente: mock,
    );
  }

  test('sin token guardado: devuelve SyncMosaicoSinToken sin tocar red',
      () async {
    var llamadas = 0;
    final mock = MockClient((_) async {
      llamadas++;
      return http.Response('', 500);
    });
    final cliente = companion.ClienteCompanion(
      urlBase: 'https://backend.example',
      cliente: mock,
    );
    final sincronizador = SincronizadorMosaicoArco2(
      repoCuenta: repoCuenta,
      repoMosaico: repoMosaico,
      clienteCompanion: cliente,
    );

    final resultado = await sincronizador.sincronizar();

    expect(resultado, isA<SyncMosaicoSinToken>());
    expect(llamadas, 0);
  });

  test('201 con shape válido: devuelve SyncMosaicoExito con el mosaico '
      'backend (format = audio_guia_arco_2)', () async {
    await repoCuenta.guardarToken('jwt-cronista');
    await sembrarMarcas();
    final cliente = clienteConRespuesta(respuesta201(id: 11));
    final sincronizador = SincronizadorMosaicoArco2(
      repoCuenta: repoCuenta,
      repoMosaico: repoMosaico,
      clienteCompanion: cliente,
    );

    final resultado = await sincronizador.sincronizar();

    expect(resultado, isA<SyncMosaicoExito>());
    final exito = resultado as SyncMosaicoExito;
    expect(exito.mosaicoBackend.id, 11);
    expect(exito.mosaicoBackend.gameId, gameIdLasVersiones);
    expect(exito.mosaicoBackend.arcId, MosaicoArco2.idArco);
    expect(exito.mosaicoBackend.format, formatoAudioGuiaArco2);
  });

  test('payload contiene game_id, arc_id, format y title del Arco 2 '
      '— y los anchors derivan de MosaicoArco2.fragmentos (todos los '
      '8 son anclaje obligatorio porque cada fragmento de la audio-'
      'guía ancla a evidencia)', () async {
    await repoCuenta.guardarToken('jwt-cronista');
    await sembrarMarcas();
    http.Request? capturada;
    final cliente = clienteCapturando(
      sobreLaRequest: (r) => capturada = r,
      respuesta: respuesta201(),
    );
    final sincronizador = SincronizadorMosaicoArco2(
      repoCuenta: repoCuenta,
      repoMosaico: repoMosaico,
      clienteCompanion: cliente,
    );

    await sincronizador.sincronizar();

    expect(capturada, isNotNull);
    expect(capturada!.method, 'POST');
    expect(capturada!.url.path, '/wp-json/nuevo-ser/v1/companion/mosaicos');
    final body = jsonDecode(capturada!.body) as Map<String, dynamic>;
    expect(body['game_id'], gameIdLasVersiones);
    expect(body['arc_id'], MosaicoArco2.idArco);
    expect(body['format'], formatoAudioGuiaArco2);
    expect(body['title'], MosaicoArco2.titulo);
    // requiredAnchors = ids de los 8 fragmentos (todos llevan
    // anclaje obligatorio en el M2 — la audio-guía ancla cada
    // declaración a evidencia documental o material).
    final required = body['required_anchors'] as List<dynamic>;
    expect(required, hasLength(8));
    expect(required, contains('domus_la_familia_que_no_aparece'));
    expect(required, contains('wamba_el_silencio_y_el_techo'));
    // fulfilledAnchors = ids de los 6 fragmentos marcados (los que
    // sembramos arriba), ordenados alfabéticamente.
    final fulfilled = body['fulfilled_anchors'] as List<dynamic>;
    expect(fulfilled, hasLength(6));
    expect(fulfilled, contains('domus_la_familia_que_no_aparece'));
    expect(fulfilled, isNot(contains('wamba_el_silencio_y_el_techo')));
    // contentMeta = mapa nivel-por-fragmento serializado a strings.
    final meta = body['content_meta'] as Map<String, dynamic>;
    expect(meta['pompaelo_la_inscripcion_in_situ'], 'solido');
    expect(meta['pompaelo_lo_que_la_inscripcion_no_dice'], 'disputado');
    expect(meta['calagurris_lo_que_quintiliano_omite'], 'probable');
  });

  test('cabecera Authorization: Bearer <token>', () async {
    await repoCuenta.guardarToken('jwt-cronista-secreto-arco-2');
    await sembrarMarcas();
    http.Request? capturada;
    final cliente = clienteCapturando(
      sobreLaRequest: (r) => capturada = r,
      respuesta: respuesta201(),
    );
    final sincronizador = SincronizadorMosaicoArco2(
      repoCuenta: repoCuenta,
      repoMosaico: repoMosaico,
      clienteCompanion: cliente,
    );

    await sincronizador.sincronizar();

    expect(
      capturada!.headers['authorization'],
      'Bearer jwt-cronista-secreto-arco-2',
    );
  });

  test('500 del backend: devuelve SyncMosaicoError con código y mensaje',
      () async {
    await repoCuenta.guardarToken('jwt-cronista');
    await sembrarMarcas();
    final cliente = clienteConRespuesta(http.Response(
      jsonEncode({'code': 'database_error', 'message': 'tabla bloqueada'}),
      500,
      headers: {'content-type': 'application/json; charset=utf-8'},
    ));
    final sincronizador = SincronizadorMosaicoArco2(
      repoCuenta: repoCuenta,
      repoMosaico: repoMosaico,
      clienteCompanion: cliente,
    );

    final resultado = await sincronizador.sincronizar();

    expect(resultado, isA<SyncMosaicoError>());
    final error = resultado as SyncMosaicoError;
    expect(error.razon, contains('500'));
    expect(error.razon, contains('tabla bloqueada'));
  });

  test('TimeoutException: SyncMosaicoError con razón "Tiempo de espera"',
      () async {
    await repoCuenta.guardarToken('jwt-cronista');
    await sembrarMarcas();
    final mock = MockClient(
      (_) async => throw TimeoutException('demasiado lento'),
    );
    final cliente = companion.ClienteCompanion(
      urlBase: 'https://backend.example',
      cliente: mock,
    );
    final sincronizador = SincronizadorMosaicoArco2(
      repoCuenta: repoCuenta,
      repoMosaico: repoMosaico,
      clienteCompanion: cliente,
    );

    final resultado = await sincronizador.sincronizar();

    expect(resultado, isA<SyncMosaicoError>());
    expect(
      (resultado as SyncMosaicoError).razon,
      contains('Tiempo de espera'),
    );
  });

  test('SocketException: SyncMosaicoError con razón "Sin conexión"',
      () async {
    await repoCuenta.guardarToken('jwt-cronista');
    await sembrarMarcas();
    final mock = MockClient(
      (_) async => throw const SocketException('sin red'),
    );
    final cliente = companion.ClienteCompanion(
      urlBase: 'https://backend.example',
      cliente: mock,
    );
    final sincronizador = SincronizadorMosaicoArco2(
      repoCuenta: repoCuenta,
      repoMosaico: repoMosaico,
      clienteCompanion: cliente,
    );

    final resultado = await sincronizador.sincronizar();

    expect(resultado, isA<SyncMosaicoError>());
    expect(
      (resultado as SyncMosaicoError).razon,
      contains('Sin conexión'),
    );
  });

  test('idArco del payload es "arco_2" — distinto del "arco_1" del M1, '
      'el backend los archiva como dos mosaicos separados', () async {
    await repoCuenta.guardarToken('jwt-cronista');
    await sembrarMarcas();
    http.Request? capturada;
    final cliente = clienteCapturando(
      sobreLaRequest: (r) => capturada = r,
      respuesta: respuesta201(),
    );
    final sincronizador = SincronizadorMosaicoArco2(
      repoCuenta: repoCuenta,
      repoMosaico: repoMosaico,
      clienteCompanion: cliente,
    );

    await sincronizador.sincronizar();

    final body = jsonDecode(capturada!.body) as Map<String, dynamic>;
    expect(body['arc_id'], 'arco_2');
    expect(body['arc_id'], isNot('arco_1'));
  });
}
