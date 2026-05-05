import 'package:el_cuaderno/dominio/pregunta_del_nino.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  PreguntaDelNino preguntaBase({
    DateTime? cerradaEn,
    String? respuestaDelNino,
    List<String> observacionesIds = const <String>[],
  }) {
    return PreguntaDelNino(
      id: 'p1',
      pregunta: '¿siempre canta el mirlo a la misma hora?',
      formuladaEn: DateTime.utc(2026, 5, 1, 9, 30),
      observacionesIds: observacionesIds,
      cerradaEn: cerradaEn,
      respuestaDelNino: respuestaDelNino,
    );
  }

  group('validaciones del constructor', () {
    test('pregunta vacía lanza ArgumentError', () {
      expect(
        () => PreguntaDelNino(
          id: 'p1',
          pregunta: '',
          formuladaEn: DateTime.utc(2026, 5, 1),
        ),
        throwsArgumentError,
      );
    });

    test('pregunta sólo de espacios lanza ArgumentError', () {
      expect(
        () => PreguntaDelNino(
          id: 'p1',
          pregunta: '   ',
          formuladaEn: DateTime.utc(2026, 5, 1),
        ),
        throwsArgumentError,
      );
    });

    test('cerrar sin respuesta lanza ArgumentError', () {
      expect(
        () => preguntaBase(cerradaEn: DateTime.utc(2026, 5, 7)),
        throwsArgumentError,
      );
    });

    test('cerrar con respuesta sólo de espacios lanza ArgumentError', () {
      expect(
        () => preguntaBase(
          cerradaEn: DateTime.utc(2026, 5, 7),
          respuestaDelNino: '   ',
        ),
        throwsArgumentError,
      );
    });

    test('respuestaDelNino sin cerradaEn lanza ArgumentError', () {
      expect(
        () => preguntaBase(respuestaDelNino: 'creo que sí, depende del sol'),
        throwsArgumentError,
      );
    });
  });

  group('estaCerrada', () {
    test('false por defecto', () {
      expect(preguntaBase().estaCerrada, isFalse);
    });

    test('true cuando hay cerradaEn + respuesta', () {
      final cerrada = preguntaBase(
        cerradaEn: DateTime.utc(2026, 5, 7),
        respuestaDelNino: 'creo que sí',
      );
      expect(cerrada.estaCerrada, isTrue);
    });
  });

  group('JSON round-trip', () {
    test('abierta sin observaciones: omite cerradaEn y respuestaDelNino', () {
      final original = preguntaBase();
      final json = original.toJson();
      expect(json.containsKey('cerradaEn'), isFalse);
      expect(json.containsKey('respuestaDelNino'), isFalse);
      final reconstruida = PreguntaDelNino.fromJson(json);
      expect(reconstruida, equals(original));
    });

    test('cerrada con respuesta: round-trip preserva todo', () {
      final cerrada = preguntaBase(
        cerradaEn: DateTime.utc(2026, 5, 7, 18),
        respuestaDelNino:
            'no, lo he oído pronto en mayo y casi a oscuras en abril',
      );
      final json = cerrada.toJson();
      expect(json['cerradaEn'], isNotNull);
      expect(json['respuestaDelNino'], isNotNull);
      final reconstruida = PreguntaDelNino.fromJson(json);
      expect(reconstruida, equals(cerrada));
    });

    test('preserva el orden de observacionesIds', () {
      final con = preguntaBase(observacionesIds: const ['o1', 'o2', 'o3']);
      final reconstruida = PreguntaDelNino.fromJson(con.toJson());
      expect(reconstruida.observacionesIds, ['o1', 'o2', 'o3']);
    });

    test('JSON sin clave observacionesIds → lista vacía', () {
      final json = {
        'id': 'p1',
        'pregunta': '¿x?',
        'formuladaEn': '2026-05-01T09:30:00.000Z',
      };
      final reconstruida = PreguntaDelNino.fromJson(json);
      expect(reconstruida.observacionesIds, isEmpty);
    });
  });

  group('copyWith y reabiertaPorNino', () {
    test('copyWith preserva los campos no tocados', () {
      final original = preguntaBase();
      final cambiada = original.copyWith(pregunta: '¿y los gorriones?');
      expect(cambiada.id, original.id);
      expect(cambiada.formuladaEn, original.formuladaEn);
      expect(cambiada.pregunta, '¿y los gorriones?');
    });

    test(
      'reabiertaPorNino limpia cerradaEn y respuestaDelNino '
      '(copyWith no podría por el patrón ?? this.x)',
      () {
        final cerrada = preguntaBase(
          cerradaEn: DateTime.utc(2026, 5, 7),
          respuestaDelNino: 'creo que sí',
        );
        final reabierta = cerrada.reabiertaPorNino();
        expect(reabierta.cerradaEn, isNull);
        expect(reabierta.respuestaDelNino, isNull);
        expect(reabierta.id, cerrada.id);
        expect(reabierta.pregunta, cerrada.pregunta);
        expect(reabierta.observacionesIds, cerrada.observacionesIds);
      },
    );
  });

  group('igualdad por valor', () {
    test('dos preguntas con mismos campos son iguales', () {
      expect(preguntaBase(), equals(preguntaBase()));
      expect(preguntaBase().hashCode, preguntaBase().hashCode);
    });

    test(
      'pregunta cerrada y abierta con mismos campos restantes NO son iguales',
      () {
        final abierta = preguntaBase();
        final cerrada = preguntaBase(
          cerradaEn: DateTime.utc(2026, 5, 7),
          respuestaDelNino: 'sí',
        );
        expect(abierta == cerrada, isFalse);
      },
    );
  });
}
