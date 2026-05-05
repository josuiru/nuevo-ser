import 'package:el_cuaderno/dominio/pregunta_del_nino.dart';
import 'package:el_cuaderno/infraestructura/memoria/repositorio_memoria.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late RepositorioMemoria repositorio;

  PreguntaDelNino preguntaBase({
    String id = 'p1',
    String pregunta = '¿siempre canta el mirlo a la misma hora?',
    DateTime? formuladaEn,
    List<String> observacionesIds = const <String>[],
  }) {
    return PreguntaDelNino(
      id: id,
      pregunta: pregunta,
      formuladaEn: formuladaEn ?? DateTime.utc(2026, 5, 1),
      observacionesIds: observacionesIds,
    );
  }

  setUp(() {
    repositorio = RepositorioMemoria();
  });

  group('guardar y obtener', () {
    test('guardar es idempotente por id (sobrescribe)', () async {
      await repositorio.guardarPreguntaDelNino(preguntaBase());
      await repositorio.guardarPreguntaDelNino(preguntaBase(
        pregunta: '¿y los gorriones también?',
      ));
      final recuperada = await repositorio.obtenerPreguntaDelNinoPorId('p1');
      expect(recuperada!.pregunta, '¿y los gorriones también?');
    });

    test('obtener inexistente devuelve null', () async {
      expect(
        await repositorio.obtenerPreguntaDelNinoPorId('no-existe'),
        isNull,
      );
    });
  });

  group('listados separan abiertas y cerradas', () {
    test(
      'abiertas más recientes primero, cerradas no aparecen',
      () async {
        await repositorio.guardarPreguntaDelNino(preguntaBase(
          id: 'p1',
          formuladaEn: DateTime.utc(2026, 4, 1),
        ));
        await repositorio.guardarPreguntaDelNino(preguntaBase(
          id: 'p2',
          formuladaEn: DateTime.utc(2026, 5, 1),
        ));
        await repositorio.guardarPreguntaDelNino(preguntaBase(
          id: 'p3',
          formuladaEn: DateTime.utc(2026, 5, 15),
        ));
        await repositorio.cerrarPreguntaDelNino('p2', 'la cerré');

        final abiertas = await repositorio.obtenerPreguntasDelNinoAbiertas();
        expect(abiertas.map((p) => p.id), ['p3', 'p1']);

        final cerradas = await repositorio.obtenerPreguntasDelNinoCerradas();
        expect(cerradas.map((p) => p.id), ['p2']);
      },
    );
  });

  group('cerrarPreguntaDelNino', () {
    test('inexistente lanza StateError', () {
      expect(
        () => repositorio.cerrarPreguntaDelNino('no-existe', 'r'),
        throwsStateError,
      );
    });

    test('respuesta vacía lanza ArgumentError', () async {
      await repositorio.guardarPreguntaDelNino(preguntaBase());
      expect(
        () => repositorio.cerrarPreguntaDelNino('p1', '   '),
        throwsArgumentError,
      );
    });

    test('cerrar persiste fecha + respuesta y la saca de abiertas', () async {
      await repositorio.guardarPreguntaDelNino(preguntaBase());
      await repositorio.cerrarPreguntaDelNino(
        'p1',
        'lo he oído pronto en mayo y casi a oscuras en abril',
      );
      final abiertas = await repositorio.obtenerPreguntasDelNinoAbiertas();
      expect(abiertas, isEmpty);
      final cerrada = await repositorio.obtenerPreguntaDelNinoPorId('p1');
      expect(cerrada!.estaCerrada, isTrue);
      expect(
        cerrada.respuestaDelNino,
        'lo he oído pronto en mayo y casi a oscuras en abril',
      );
    });

    test('cerrar dos veces el mismo lanza StateError', () async {
      await repositorio.guardarPreguntaDelNino(preguntaBase());
      await repositorio.cerrarPreguntaDelNino('p1', 'primera');
      expect(
        () => repositorio.cerrarPreguntaDelNino('p1', 'segunda'),
        throwsStateError,
      );
    });
  });

  group('reabrirPreguntaDelNino', () {
    test('inexistente lanza StateError', () {
      expect(
        () => repositorio.reabrirPreguntaDelNino('no-existe'),
        throwsStateError,
      );
    });

    test('reabrir limpia cerradaEn y respuesta y vuelve a abiertas', () async {
      await repositorio.guardarPreguntaDelNino(preguntaBase());
      await repositorio.cerrarPreguntaDelNino('p1', 'mi respuesta');
      await repositorio.reabrirPreguntaDelNino('p1');
      final reabierta = await repositorio.obtenerPreguntaDelNinoPorId('p1');
      expect(reabierta!.estaCerrada, isFalse);
      expect(reabierta.respuestaDelNino, isNull);
      final abiertas = await repositorio.obtenerPreguntasDelNinoAbiertas();
      expect(abiertas.map((p) => p.id), ['p1']);
    });

    test('reabrir una pregunta abierta es idempotente (no lanza)', () async {
      await repositorio.guardarPreguntaDelNino(preguntaBase());
      await repositorio.reabrirPreguntaDelNino('p1');
      final pregunta = await repositorio.obtenerPreguntaDelNinoPorId('p1');
      expect(pregunta!.estaCerrada, isFalse);
    });
  });

  group('borrarPreguntaDelNino', () {
    test('borrar inexistente no lanza (idempotente)', () async {
      await repositorio.borrarPreguntaDelNino('no-existe');
    });

    test('borrar quita de listados', () async {
      await repositorio.guardarPreguntaDelNino(preguntaBase());
      await repositorio.borrarPreguntaDelNino('p1');
      expect(await repositorio.obtenerPreguntaDelNinoPorId('p1'), isNull);
      expect(
        (await repositorio.obtenerPreguntasDelNinoAbiertas()),
        isEmpty,
      );
    });
  });

  group('borrarTodoLoLocal cuenta las preguntas del niño', () {
    test('preguntasDelNinoBorradas refleja el conteo previo', () async {
      await repositorio.guardarPreguntaDelNino(preguntaBase(id: 'p1'));
      await repositorio.guardarPreguntaDelNino(preguntaBase(id: 'p2'));
      final resultado = await repositorio.borrarTodoLoLocal();
      expect(resultado.preguntasDelNinoBorradas, 2);
      expect(resultado.total, greaterThanOrEqualTo(2));
      expect(
        await repositorio.obtenerPreguntasDelNinoAbiertas(),
        isEmpty,
      );
    });
  });
}
