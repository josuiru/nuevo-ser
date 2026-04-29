import 'package:flutter_test/flutter_test.dart';
import 'package:uno_roto/dominio/estado_cuaderno.dart';
import 'package:uno_roto/dominio/habilidad.dart';

EstadoHabilidad _construir({
  required NivelMaestria nivel,
  int totalExposiciones = 0,
  double precision = 0,
}) {
  return EstadoHabilidad(
    identificadorHabilidad: 'FR.01',
    nivel: nivel,
    precision: precision,
    tiempoMedianoSeg: 0,
    ultimaPractica: DateTime.fromMillisecondsSinceEpoch(0),
    sesionesConsecutivasBuenas: 0,
    totalExposiciones: totalExposiciones,
    intentosRecientes: const [],
  );
}

void main() {
  group('estadoCuadernoDe', () {
    test('inexplorada sin exposiciones → latente', () {
      final estado = _construir(nivel: NivelMaestria.inexplorada);
      expect(estadoCuadernoDe(estado), EstadoCuaderno.latente);
    });

    test('inexplorada con exposiciones → vista (la tocó pero olvidó)', () {
      final estado = _construir(
        nivel: NivelMaestria.inexplorada,
        totalExposiciones: 3,
      );
      expect(estadoCuadernoDe(estado), EstadoCuaderno.vista);
    });

    test('introducida → vista', () {
      final estado = _construir(
        nivel: NivelMaestria.introducida,
        totalExposiciones: 5,
      );
      expect(estadoCuadernoDe(estado), EstadoCuaderno.vista);
    });

    test('enDesarrollo → practica', () {
      final estado = _construir(
        nivel: NivelMaestria.enDesarrollo,
        totalExposiciones: 12,
      );
      expect(estadoCuadernoDe(estado), EstadoCuaderno.practica);
    });

    test('competente → firme', () {
      final estado = _construir(
        nivel: NivelMaestria.competente,
        totalExposiciones: 25,
      );
      expect(estadoCuadernoDe(estado), EstadoCuaderno.firme);
    });

    test('maestria → dominada', () {
      final estado = _construir(
        nivel: NivelMaestria.maestria,
        totalExposiciones: 40,
      );
      expect(estadoCuadernoDe(estado), EstadoCuaderno.dominada);
    });
  });

  group('NombreEstadoCuaderno', () {
    test('todos los estados tienen nombre no vacío', () {
      for (final estado in EstadoCuaderno.values) {
        expect(estado.nombreCorto, isNotEmpty);
      }
    });

    test('los nombres son distintos entre sí', () {
      final nombres =
          EstadoCuaderno.values.map((e) => e.nombreCorto).toSet();
      expect(nombres.length, EstadoCuaderno.values.length);
    });
  });
}
