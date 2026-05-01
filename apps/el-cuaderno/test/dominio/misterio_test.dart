import 'package:el_cuaderno/dominio/misterio.dart';
import 'package:el_cuaderno/dominio/nivel_confianza.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Misterio misterioBase({
    DateTime? cerradoPorNino,
    String? respuestaDelNino,
  }) {
    return Misterio(
      id: 'm1',
      pregunta: '¿qué insectos visitan las flores azules?',
      descripcionCorta: 'mira con calma',
      estado: NivelConfianza.hipotesisActiva,
      abierto: true,
      cerradoPorNino: cerradoPorNino,
      respuestaDelNino: respuestaDelNino,
    );
  }

  group('cierre amable del niño', () {
    test(
      'cerrar sin respuesta lanza ArgumentError',
      () {
        expect(
          () => misterioBase(cerradoPorNino: DateTime(2026, 5, 1)),
          throwsArgumentError,
        );
      },
    );

    test(
      'cerrar con respuesta sólo de espacios lanza ArgumentError',
      () {
        expect(
          () => misterioBase(
            cerradoPorNino: DateTime(2026, 5, 1),
            respuestaDelNino: '   ',
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      'respuestaDelNino sin cerradoPorNino lanza ArgumentError',
      () {
        expect(
          () => misterioBase(respuestaDelNino: 'lo que aprendí'),
          throwsArgumentError,
        );
      },
    );

    test(
      'cerrar con fecha y respuesta no vacía construye y expone estaCerradoPorNino',
      () {
        final misterio = misterioBase(
          cerradoPorNino: DateTime(2026, 5, 1),
          respuestaDelNino: 'vi tres mariposas blancas',
        );
        expect(misterio.estaCerradoPorNino, isTrue);
        expect(misterio.respuestaDelNino, 'vi tres mariposas blancas');
      },
    );

    test(
      'sin cierre, estaCerradoPorNino es false',
      () {
        expect(misterioBase().estaCerradoPorNino, isFalse);
      },
    );

    test(
      'reabiertoPorNino borra ambos campos',
      () {
        final cerrado = misterioBase(
          cerradoPorNino: DateTime(2026, 5, 1),
          respuestaDelNino: 'lo que aprendí',
        );
        final reabierto = cerrado.reabiertoPorNino();
        expect(reabierto.cerradoPorNino, isNull);
        expect(reabierto.respuestaDelNino, isNull);
        expect(reabierto.id, cerrado.id);
        expect(reabierto.pregunta, cerrado.pregunta);
      },
    );
  });

  group('round-trip JSON con cierre', () {
    test(
      'misterio cerrado preserva fecha y respuesta',
      () {
        final original = misterioBase(
          cerradoPorNino: DateTime.utc(2026, 5, 1, 12, 30),
          respuestaDelNino: 'flores azules atraen abejas',
        );
        final clon = Misterio.fromJson(original.toJson());
        expect(clon, original);
        expect(clon.cerradoPorNino, original.cerradoPorNino);
        expect(clon.respuestaDelNino, original.respuestaDelNino);
      },
    );

    test(
      'misterio sin cerrar omite las claves del JSON',
      () {
        final json = misterioBase().toJson();
        expect(json.containsKey('cerradoPorNino'), isFalse);
        expect(json.containsKey('respuestaDelNino'), isFalse);
      },
    );

    test(
      'fromJson sin las claves construye con campos null',
      () {
        final misterio = Misterio.fromJson({
          'id': 'm1',
          'pregunta': '¿qué insectos visitan las flores azules?',
          'descripcionCorta': 'mira con calma',
          'estado': 'hipotesisActiva',
          'abierto': true,
        });
        expect(misterio.cerradoPorNino, isNull);
        expect(misterio.respuestaDelNino, isNull);
      },
    );
  });

  group('copyWith con cierre amable', () {
    test(
      'copyWith preserva los campos por defecto',
      () {
        final original = misterioBase(
          cerradoPorNino: DateTime(2026, 5, 1),
          respuestaDelNino: 'lo que aprendí',
        );
        final clon = original.copyWith(pregunta: 'otra pregunta');
        expect(clon.cerradoPorNino, original.cerradoPorNino);
        expect(clon.respuestaDelNino, original.respuestaDelNino);
      },
    );

    test(
      'copyWith añade el cierre',
      () {
        final original = misterioBase();
        final cerrado = original.copyWith(
          cerradoPorNino: DateTime(2026, 5, 1),
          respuestaDelNino: 'tres avistamientos en abril',
        );
        expect(cerrado.estaCerradoPorNino, isTrue);
        expect(cerrado.respuestaDelNino, 'tres avistamientos en abril');
      },
    );
  });

  group('igualdad', () {
    test(
      'dos misterios con mismo cierre son iguales',
      () {
        final fecha = DateTime(2026, 5, 1);
        expect(
          misterioBase(cerradoPorNino: fecha, respuestaDelNino: 'a'),
          misterioBase(cerradoPorNino: fecha, respuestaDelNino: 'a'),
        );
      },
    );

    test(
      'fechas distintas → no iguales',
      () {
        expect(
          misterioBase(
            cerradoPorNino: DateTime(2026, 5, 1),
            respuestaDelNino: 'a',
          ),
          isNot(
            misterioBase(
              cerradoPorNino: DateTime(2026, 5, 2),
              respuestaDelNino: 'a',
            ),
          ),
        );
      },
    );

    test(
      'respuestas distintas → no iguales',
      () {
        final fecha = DateTime(2026, 5, 1);
        expect(
          misterioBase(cerradoPorNino: fecha, respuestaDelNino: 'a'),
          isNot(
            misterioBase(cerradoPorNino: fecha, respuestaDelNino: 'b'),
          ),
        );
      },
    );
  });
}
