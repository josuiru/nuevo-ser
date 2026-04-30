import 'dart:convert';

import 'package:el_cuaderno/datos/sincronizador_agregados.dart';
import 'package:el_cuaderno/dominio/nivel_confianza.dart';
import 'package:el_cuaderno/dominio/observacion.dart';
import 'package:el_cuaderno/infraestructura/memoria/repositorio_memoria.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:nuevo_ser_companion/nuevo_ser_companion.dart';
import 'package:nuevo_ser_core/nuevo_ser_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Tests del sincronizador de agregados semanales del cuaderno con el
/// endpoint `POST /companion/aggregates/weekly` del companion.
///
/// El sincronizador es la **única superficie del juego que cruza el
/// agregado del cuaderno** — el resto vive en Isar local. Aquí
/// verificamos: sin token cae a SyncSinToken sin tocar red; con token
/// y respuesta 200 devuelve el AgregadoSemanal del backend; los errores
/// de API/red caen en SyncError; y el body que va al servidor sólo
/// contiene IDs y counts (frontera de privacidad).
void main() {
  late RepositorioMemoria repositorio;
  late RepositorioCuentaBackend repoCuenta;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    repositorio = RepositorioMemoria();
    repoCuenta = RepositorioCuentaBackend(
      prefs: SharedPreferences.getInstance,
      claveToken: 'nuevoser.elcuaderno.token_backend',
      claveEmail: 'nuevoser.elcuaderno.email_backend',
    );
  });

  Future<void> sembrarObservaciones() async {
    await repositorio.guardarObservacion(Observacion(
      id: 'obs-1',
      cuandoCreada: DateTime(2026, 4, 27),
      cuandoOcurrio: DateTime(2026, 4, 27),
      dondeNombre: 'parque-secreto',
      queVio: 'frase-larga-del-niño',
      creesQueEs: 'palabra-confidencial',
      confianza: NivelConfianza.consenso,
      misterioId: 'mist-001',
      sitSpotId: 'spot-1',
    ));
    await repositorio.guardarObservacion(Observacion(
      id: 'obs-2',
      cuandoCreada: DateTime(2026, 4, 28),
      cuandoOcurrio: DateTime(2026, 4, 28),
      dondeNombre: 'parque-secreto',
      queVio: 'otra-frase-del-niño',
      confianza: NivelConfianza.hipotesisActiva,
      misterioId: 'mist-001',
    ));
  }

  ClienteCompanion clienteConRespuesta(http.Response respuesta) {
    final mock = MockClient((_) async => respuesta);
    return ClienteCompanion(urlBase: 'https://backend.example', cliente: mock);
  }

  ClienteCompanion clienteCapturando({
    required void Function(http.Request) sobreLaRequest,
    required http.Response respuesta,
  }) {
    final mock = MockClient((request) async {
      sobreLaRequest(request);
      return respuesta;
    });
    return ClienteCompanion(urlBase: 'https://backend.example', cliente: mock);
  }

  test('sin token guardado: devuelve SyncSinToken sin tocar red', () async {
    var llamadas = 0;
    final mock = MockClient((_) async {
      llamadas++;
      return http.Response('', 500);
    });
    final cliente =
        ClienteCompanion(urlBase: 'https://backend.example', cliente: mock);
    final sincronizador = SincronizadorAgregadosCuaderno(
      repositorio: repositorio,
      repoCuenta: repoCuenta,
      clienteCompanion: cliente,
    );

    final resultado = await sincronizador.sincronizarSemana(
      semanaPivote: DateTime(2026, 4, 28),
    );

    expect(resultado, isA<SyncSinToken>());
    expect(llamadas, 0);
  });

  test('200 con summary: devuelve SyncExito con el agregado del backend',
      () async {
    await repoCuenta.guardarToken('jwt-niño');
    await sembrarObservaciones();
    final cliente = clienteConRespuesta(http.Response(
      jsonEncode({
        'game_id': 'el-cuaderno',
        'iso_week': '2026-W18',
        'aggregates_hash': 'abc123',
        'summary_text': 'Esta semana ha vuelto al arce con preguntas.',
        'conversation_prompt': '¿Qué le ha sonado distinto?',
        'generated_at': '2026-04-29 22:30:00',
      }),
      200,
      headers: {'content-type': 'application/json; charset=utf-8'},
    ));
    final sincronizador = SincronizadorAgregadosCuaderno(
      repositorio: repositorio,
      repoCuenta: repoCuenta,
      clienteCompanion: cliente,
    );

    final resultado = await sincronizador.sincronizarSemana(
      semanaPivote: DateTime(2026, 4, 28),
    );

    expect(resultado, isA<SyncExito>());
    final exito = resultado as SyncExito;
    expect(exito.agregadoBackend.summaryText,
        'Esta semana ha vuelto al arce con preguntas.');
    expect(exito.agregadoBackend.conversationPrompt,
        '¿Qué le ha sonado distinto?');
  });

  test('el body del POST contiene game_id, iso_week y aggregates con counts',
      () async {
    await repoCuenta.guardarToken('jwt-niño');
    await sembrarObservaciones();
    http.Request? capturada;
    final cliente = clienteCapturando(
      sobreLaRequest: (r) => capturada = r,
      respuesta: http.Response(
        jsonEncode({
          'game_id': 'el-cuaderno',
          'iso_week': '2026-W18',
          'aggregates_hash': 'h',
          'summary_text': '',
          'conversation_prompt': null,
          'generated_at': '2026-04-29 22:30:00',
        }),
        200,
        headers: {'content-type': 'application/json; charset=utf-8'},
      ),
    );
    final sincronizador = SincronizadorAgregadosCuaderno(
      repositorio: repositorio,
      repoCuenta: repoCuenta,
      clienteCompanion: cliente,
    );

    await sincronizador.sincronizarSemana(semanaPivote: DateTime(2026, 4, 28));

    expect(capturada, isNotNull);
    expect(capturada!.method, 'POST');
    expect(capturada!.url.path, '/wp-json/nuevo-ser/v1/companion/aggregates/weekly');
    final body = jsonDecode(capturada!.body) as Map<String, dynamic>;
    expect(body['game_id'], 'el-cuaderno');
    expect(body['iso_week'], '2026-W18');
    final agregados = body['aggregates'] as Map<String, dynamic>;
    expect(agregados['observaciones_total'], 2);
    expect(agregados['observaciones_por_misterio'], {'mist-001': 2});
    expect(agregados['sit_spot_visitas'], 1);
    expect(agregados['region_code'], 'ES');
    // Frontera de privacidad: no viaja queVio, creesQueEs, ni
    // dondeNombre — sólo IDs canónicos y counts.
    final cuerpoCrudo = capturada!.body;
    expect(cuerpoCrudo, isNot(contains('frase-larga-del-niño')));
    expect(cuerpoCrudo, isNot(contains('otra-frase-del-niño')));
    expect(cuerpoCrudo, isNot(contains('parque-secreto')));
    expect(cuerpoCrudo, isNot(contains('palabra-confidencial')));
  });

  test('cabecera Authorization: Bearer <token>', () async {
    await repoCuenta.guardarToken('jwt-niño-secreto');
    http.Request? capturada;
    final cliente = clienteCapturando(
      sobreLaRequest: (r) => capturada = r,
      respuesta: http.Response(
        jsonEncode({
          'game_id': 'el-cuaderno',
          'iso_week': '2026-W18',
          'aggregates_hash': 'h',
          'summary_text': '',
          'conversation_prompt': null,
          'generated_at': '2026-04-29 22:30:00',
        }),
        200,
        headers: {'content-type': 'application/json; charset=utf-8'},
      ),
    );
    final sincronizador = SincronizadorAgregadosCuaderno(
      repositorio: repositorio,
      repoCuenta: repoCuenta,
      clienteCompanion: cliente,
    );

    await sincronizador.sincronizarSemana(semanaPivote: DateTime(2026, 4, 28));

    expect(capturada!.headers['Authorization'], 'Bearer jwt-niño-secreto');
  });

  test('500 del backend: devuelve SyncError con el código y mensaje', () async {
    await repoCuenta.guardarToken('jwt-niño');
    final cliente = clienteConRespuesta(http.Response(
      jsonEncode({'message': 'tutor IA no disponible'}),
      500,
      headers: {'content-type': 'application/json; charset=utf-8'},
    ));
    final sincronizador = SincronizadorAgregadosCuaderno(
      repositorio: repositorio,
      repoCuenta: repoCuenta,
      clienteCompanion: cliente,
    );

    final resultado = await sincronizador.sincronizarSemana(
      semanaPivote: DateTime(2026, 4, 28),
    );

    expect(resultado, isA<SyncError>());
    final error = resultado as SyncError;
    expect(error.razon, contains('500'));
  });

  test('200 con summary vacío: SyncExito (no SyncError) — el archivado vale',
      () async {
    // El backend siempre archiva los agregados; si el LLM falla, el
    // summary llega vacío y el cliente reintenta más tarde, pero la
    // fila ya quedó persistida — eso es éxito desde el punto de vista
    // del sincronizador.
    await repoCuenta.guardarToken('jwt-niño');
    final cliente = clienteConRespuesta(http.Response(
      jsonEncode({
        'game_id': 'el-cuaderno',
        'iso_week': '2026-W18',
        'aggregates_hash': 'h',
        'summary_text': '',
        'conversation_prompt': null,
        'generated_at': '2026-04-29 22:30:00',
      }),
      201,
      headers: {'content-type': 'application/json; charset=utf-8'},
    ));
    final sincronizador = SincronizadorAgregadosCuaderno(
      repositorio: repositorio,
      repoCuenta: repoCuenta,
      clienteCompanion: cliente,
    );

    final resultado = await sincronizador.sincronizarSemana(
      semanaPivote: DateTime(2026, 4, 28),
    );

    expect(resultado, isA<SyncExito>());
    final exito = resultado as SyncExito;
    expect(exito.agregadoBackend.summaryText, isEmpty);
  });
}
