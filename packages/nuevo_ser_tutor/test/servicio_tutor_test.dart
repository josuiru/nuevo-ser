import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:nuevo_ser_core/nuevo_ser_core.dart';
import 'package:nuevo_ser_tutor/nuevo_ser_tutor.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Suite de comportamiento del orquestador del Tutor IA.
///
/// El servicio depende de cuatro piezas inyectables (filtro, disparador,
/// caché, cliente HTTP) más un repositorio de estado por habilidad. Los
/// tests construyen un `RepositorioEstadoTutor` montado sobre un
/// `GestorPerfiles` con prefs en memoria.
void main() {
  late GestorPerfiles gestor;
  late RepositorioEstadoTutor estadoTutor;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    gestor = GestorPerfiles(
      namespace: 'uroto',
      sufijoNombreVisible: 'nombre_jugador',
    );
    estadoTutor = RepositorioEstadoTutor(gestor: gestor);
  });

  ServicioTutor crearServicio({required MockClient mock}) {
    return ServicioTutor(
      cache: CacheTutor(),
      cliente: ClienteTutor(
        urlBase: 'https://t.example',
        cliente: mock,
      ),
      estadoTutor: estadoTutor,
      proveedorToken: () => 'tk',
    );
  }

  group('ServicioTutor — pedirExplicacion', () {
    test('rechaza pregunta con email sin tocar la red', () async {
      var llamadasRed = 0;
      final mock = MockClient((_) async {
        llamadasRed++;
        return http.Response('{}', 200);
      });
      final servicio = crearServicio(mock: mock);
      final r = await servicio.pedirExplicacion(
        idHabilidad: 'FR.05',
        pregunta: 'Mi email es nene@example.com ayúdame',
      );
      expect(r.estado, EstadoRespuestaTutor.rechazada);
      expect(llamadasRed, 0);
    });

    test('hit de caché evita llamada de red', () async {
      var llamadasRed = 0;
      final mock = MockClient((_) async {
        llamadasRed++;
        return http.Response(
          jsonEncode({'explicacion': 'Respuesta', 'fuente': 'llm'}),
          200,
        );
      });
      final servicio = crearServicio(mock: mock);

      // Primera llamada → red.
      final r1 = await servicio.pedirExplicacion(
        idHabilidad: 'FR.05',
        pregunta: 'Cómo se suma',
      );
      expect(r1.estado, EstadoRespuestaTutor.ok);
      expect(r1.desdeCacheLocal, isFalse);
      expect(llamadasRed, 1);

      // Misma pregunta normalizada → cache, sin red.
      final r2 = await servicio.pedirExplicacion(
        idHabilidad: 'FR.05',
        pregunta: '  Cómo  se  suma  ',
      );
      expect(r2.estado, EstadoRespuestaTutor.ok);
      expect(r2.desdeCacheLocal, isTrue);
      expect(llamadasRed, 1);
    });

    test('error 422 del servidor se propaga como rechazo con su mensaje',
        () async {
      final mock = MockClient((_) async {
        return http.Response(
          jsonEncode({'error': 'Solo de matemáticas, prueba otra cosa.'}),
          422,
        );
      });
      final servicio = crearServicio(mock: mock);
      final r = await servicio.pedirExplicacion(
        idHabilidad: 'FR.05',
        pregunta: 'cuéntame algo',
      );
      expect(r.estado, EstadoRespuestaTutor.rechazada);
      expect(r.texto, contains('matemáticas'));
    });

    test('error 500 se traduce a errorRed', () async {
      final mock = MockClient((_) async => http.Response('boom', 500));
      final servicio = crearServicio(mock: mock);
      final r = await servicio.pedirExplicacion(
        idHabilidad: 'FR.05',
        pregunta: 'X',
      );
      expect(r.estado, EstadoRespuestaTutor.errorRed);
    });

    test('respuesta del LLM con URL se rechaza por filtro de salida',
        () async {
      final mock = MockClient((_) async {
        return http.Response(
          jsonEncode({
            'explicacion': 'Mira en https://wikipedia.org',
            'fuente': 'llm',
          }),
          200,
        );
      });
      final servicio = crearServicio(mock: mock);
      final r = await servicio.pedirExplicacion(
        idHabilidad: 'FR.05',
        pregunta: 'X',
      );
      expect(r.estado, EstadoRespuestaTutor.errorRed);
    });

    test('respuesta OK se cachea para llamadas siguientes', () async {
      var llamadas = 0;
      final mock = MockClient((_) async {
        llamadas++;
        return http.Response(
          jsonEncode({'explicacion': 'la respuesta', 'fuente': 'llm'}),
          200,
        );
      });
      final servicio = crearServicio(mock: mock);
      await servicio.pedirExplicacion(idHabilidad: 'X', pregunta: 'q');
      await servicio.pedirExplicacion(idHabilidad: 'X', pregunta: 'q');
      expect(llamadas, 1);
    });
  });

  group('ServicioTutor — política', () {
    test('registrarResultado(false) acumula fallos y dispara oferta',
        () async {
      final servicio = crearServicio(
        mock: MockClient((_) async => http.Response('{}', 200)),
      );
      const id = 'FR.05';
      expect(await servicio.deberiaOfrecer(id), isFalse);
      for (var i = 0; i < fallosConsecutivosParaOfrecer; i++) {
        await servicio.registrarResultado(idHabilidad: id, acierto: false);
      }
      expect(await servicio.deberiaOfrecer(id), isTrue);
    });

    test('registrarResultado(true) resetea contador', () async {
      final servicio = crearServicio(
        mock: MockClient((_) async => http.Response('{}', 200)),
      );
      const id = 'FR.05';
      for (var i = 0; i < fallosConsecutivosParaOfrecer; i++) {
        await servicio.registrarResultado(idHabilidad: id, acierto: false);
      }
      await servicio.registrarResultado(idHabilidad: id, acierto: true);
      expect(await servicio.deberiaOfrecer(id), isFalse);
    });

    test(
      'rechazo simulado: registrarOferta tras "no, sigo solo" frena reofertas',
      () async {
        final servicio = crearServicio(
          mock: MockClient((_) async => http.Response('{}', 200)),
        );
        const id = 'FR.05';
        for (var i = 0; i < fallosConsecutivosParaOfrecer; i++) {
          await servicio.registrarResultado(idHabilidad: id, acierto: false);
        }
        final ahora = DateTime(2026, 4, 27, 12, 0);
        expect(await servicio.deberiaOfrecer(id, ahora: ahora), isTrue);
        await servicio.registrarOferta(id, ahora: ahora);
        for (var i = 0; i < fallosConsecutivosParaOfrecer; i++) {
          await servicio.registrarResultado(idHabilidad: id, acierto: false);
        }
        expect(
          await servicio.deberiaOfrecer(
            id,
            ahora: ahora.add(const Duration(minutes: 2)),
          ),
          isFalse,
          reason:
              'Justo después del rechazo, la oferta NO debe volver a '
              'salir aunque siga atascado.',
        );
        expect(
          await servicio.deberiaOfrecer(
            id,
            ahora: ahora.add(cooldownEntreOfertas),
          ),
          isTrue,
          reason:
              'Pasado el cooldown, si sigue atascado la oferta vuelve.',
        );
      },
    );

    test('registrarOferta arranca cooldown', () async {
      final servicio = crearServicio(
        mock: MockClient((_) async => http.Response('{}', 200)),
      );
      const id = 'FR.05';
      for (var i = 0; i < fallosConsecutivosParaOfrecer; i++) {
        await servicio.registrarResultado(idHabilidad: id, acierto: false);
      }
      final ahora = DateTime(2026, 4, 27, 12, 0);
      expect(await servicio.deberiaOfrecer(id, ahora: ahora), isTrue);
      await servicio.registrarOferta(id, ahora: ahora);
      for (var i = 0; i < fallosConsecutivosParaOfrecer; i++) {
        await servicio.registrarResultado(idHabilidad: id, acierto: false);
      }
      expect(
        await servicio.deberiaOfrecer(
          id,
          ahora: ahora.add(const Duration(minutes: 5)),
        ),
        isFalse,
      );
      expect(
        await servicio.deberiaOfrecer(
          id,
          ahora: ahora.add(cooldownEntreOfertas),
        ),
        isTrue,
      );
    });

    test('estado del tutor se aísla por habilidad', () async {
      final servicio = crearServicio(
        mock: MockClient((_) async => http.Response('{}', 200)),
      );
      for (var i = 0; i < fallosConsecutivosParaOfrecer; i++) {
        await servicio.registrarResultado(
          idHabilidad: 'FR.05',
          acierto: false,
        );
      }
      expect(await servicio.deberiaOfrecer('FR.05'), isTrue);
      expect(await servicio.deberiaOfrecer('FR.06'), isFalse);
    });

    test(
      'flujo caza: 4 intentos con captura final → ofrece antes y resetea después',
      () async {
        final servicio = crearServicio(
          mock: MockClient((_) async => http.Response('{}', 200)),
        );
        const id = 'FR.05';
        for (var i = 0; i < 3; i++) {
          await servicio.registrarResultado(idHabilidad: id, acierto: false);
        }
        expect(await servicio.deberiaOfrecer(id), isTrue);
        await servicio.registrarResultado(idHabilidad: id, acierto: true);
        expect(await servicio.deberiaOfrecer(id), isFalse);
      },
    );

    test(
      'flujo caza: 5 intentos con escape → ofrece y suma fallo final',
      () async {
        final servicio = crearServicio(
          mock: MockClient((_) async => http.Response('{}', 200)),
        );
        const id = 'FR.05';
        for (var i = 0; i < 4; i++) {
          await servicio.registrarResultado(idHabilidad: id, acierto: false);
        }
        expect(await servicio.deberiaOfrecer(id), isTrue);
        await servicio.registrarResultado(idHabilidad: id, acierto: false);
        expect(await servicio.deberiaOfrecer(id), isTrue);
      },
    );

    test(
      'flujo caza: 2 intentos con captura no dispara oferta',
      () async {
        final servicio = crearServicio(
          mock: MockClient((_) async => http.Response('{}', 200)),
        );
        const id = 'FR.05';
        await servicio.registrarResultado(idHabilidad: id, acierto: false);
        expect(await servicio.deberiaOfrecer(id), isFalse);
        await servicio.registrarResultado(idHabilidad: id, acierto: true);
        expect(await servicio.deberiaOfrecer(id), isFalse);
      },
    );
  });
}
