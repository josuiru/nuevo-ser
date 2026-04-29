import 'package:el_cuaderno/dominio/nivel_confianza.dart';
import 'package:el_cuaderno/dominio/observacion.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final cuandoFijo = DateTime.utc(2026, 4, 30, 17, 48);

  Observacion construirValida({
    String queVio = 'Tres pájaros pequeños marrones saltando entre las hojas.',
    String? creesQueEs,
    NivelConfianza confianza = NivelConfianza.hipotesisActiva,
  }) {
    return Observacion(
      id: 'obs-test-1',
      cuandoCreada: cuandoFijo,
      cuandoOcurrio: cuandoFijo,
      dondeNombre: 'El Roble Grande',
      queVio: queVio,
      creesQueEs: creesQueEs,
      confianza: confianza,
    );
  }

  group('validación de constructor', () {
    test('queVio vacío lanza ArgumentError', () {
      expect(() => construirValida(queVio: ''), throwsArgumentError);
    });

    test(
        'confianza consenso con creesQueEs null lanza ArgumentError '
        '(declarar consenso requiere haber propuesto identificación)', () {
      expect(
        () => construirValida(
          confianza: NivelConfianza.consenso,
          // creesQueEs queda null por defecto.
        ),
        throwsArgumentError,
      );
    });

    test('confianza consenso con creesQueEs no nulo es válida', () {
      final observacion = construirValida(
        confianza: NivelConfianza.consenso,
        creesQueEs: 'limonera',
      );
      expect(observacion.confianza, NivelConfianza.consenso);
    });

    test(
        'confianza noSegura con creesQueEs null es válida — el "no sé" '
        'es respuesta legítima del oficio (biblia §5.2)', () {
      final observacion = construirValida(
        confianza: NivelConfianza.noSegura,
      );
      expect(observacion.confianza, NivelConfianza.noSegura);
      expect(observacion.creesQueEs, isNull);
    });

    test('confianza abandonado lanza ArgumentError', () {
      expect(
        () => construirValida(
          confianza: NivelConfianza.abandonado,
          creesQueEs: 'cualquier cosa',
        ),
        throwsArgumentError,
      );
    });
  });

  group('copyWith', () {
    test('preserva campos no especificados', () {
      final original = construirValida(creesQueEs: 'petirrojo');
      final copia = original.copyWith(creesQueEs: 'chochín');
      expect(copia.id, original.id);
      expect(copia.cuandoOcurrio, original.cuandoOcurrio);
      expect(copia.queVio, original.queVio);
      expect(copia.confianza, original.confianza);
      expect(copia.dondeNombre, original.dondeNombre);
      expect(copia.creesQueEs, 'chochín');
    });
  });

  group('toJson / fromJson roundtrip', () {
    test('campos completos sobreviven al round trip', () {
      final original = Observacion(
        id: 'obs-roundtrip',
        cuandoCreada: cuandoFijo,
        cuandoOcurrio: cuandoFijo,
        dondeNombre: 'El Roble Grande',
        dondeCoordenadas: const Coordenadas(lat: 42.81, lng: -1.65),
        climaResumen: 'soleado',
        queVio: 'Dos caracoles tras la lluvia.',
        creesQueEs: 'caracol común',
        confianza: NivelConfianza.noSegura,
        misterioId: 'misterio-lluvia',
        sitSpotId: 'sitspot-roble',
      );
      final json = original.toJson();
      final reconstruida = Observacion.fromJson(json);
      expect(reconstruida, original);
    });

    test('campos null sobreviven como null', () {
      final original = construirValida();
      final json = original.toJson();
      final reconstruida = Observacion.fromJson(json);
      expect(reconstruida.creesQueEs, isNull);
      expect(reconstruida.dondeCoordenadas, isNull);
      expect(reconstruida, original);
    });
  });

  group('equality', () {
    test('dos observaciones con todos los campos iguales son ==', () {
      final a = construirValida(creesQueEs: 'petirrojo');
      final b = construirValida(creesQueEs: 'petirrojo');
      expect(a, b);
      expect(a.hashCode, b.hashCode);
    });
  });
}
