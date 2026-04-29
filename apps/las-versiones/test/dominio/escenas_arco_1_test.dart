import 'package:flutter_test/flutter_test.dart';
import 'package:las_versiones/dominio/ambiente_archivo.dart';
import 'package:las_versiones/dominio/escenas_arco_1.dart';
import 'package:nuevo_ser_core/nuevo_ser_core.dart';

void main() {
  group('EscenasArco1.laEvaluacion (1.0.1)', () {
    test('id y flagDeSalida estables', () {
      expect(EscenasArco1.laEvaluacion.id, '1.0.1');
      expect(EscenasArco1.laEvaluacion.flagDeSalida, 'escena_1_0_1_vista');
    });

    test('no tiene flags requeridos — es la primera del juego', () {
      expect(EscenasArco1.laEvaluacion.flagsRequeridos, isEmpty);
    });

    test('viaja con ambiente sala de evaluación del Archivo', () {
      expect(
        EscenasArco1.laEvaluacion.ambiente,
        same(AmbienteArchivo.salaEvaluacion),
      );
    });

    test('cierra como amable — la sesión termina al pulsar el botón, '
        'no encadena con 1.0.2 en la misma sesión', () {
      final ultimoPlano = EscenasArco1.laEvaluacion.planos.last;
      expect(ultimoPlano, isA<PlanoCierreAmable>());
    });

    test('contiene al menos una elección — primera decisión real del '
        'jugador en el juego', () {
      final tieneEleccion = EscenasArco1.laEvaluacion.planos
          .any((plano) => plano is PlanoEleccion);
      expect(tieneEleccion, isTrue);
    });

    test('la elección "¿por qué estás aquí?" tiene cuatro opciones, una '
        'por motivo distinto', () {
      final eleccion = EscenasArco1.laEvaluacion.planos
          .whereType<PlanoEleccion>()
          .first;
      expect(eleccion.opciones, hasLength(4));
      final flags = <String>{};
      for (final opcion in eleccion.opciones) {
        flags.addAll(opcion.flagsAEstablecer);
      }
      expect(flags, hasLength(4),
          reason: 'cada opción enciende un motivo distinto');
    });
  });

  group('flagsDeCierrePorEscena', () {
    test('1.0.1 cierra con met_begona, met_isaura, evaluation_passed y '
        'accepted_aspirante', () {
      final flags =
          EscenasArco1.flagsDeCierrePorEscena['escena_1_0_1_vista'];
      expect(flags, {
        'met_begona',
        'met_isaura',
        'evaluation_passed',
        'accepted_aspirante',
      });
    });

    test('todas las escenas catalogadas están en `todas` y todas las que '
        'tienen flags de cierre apuntan a una escena conocida', () {
      final idsConocidos = {
        for (final escena in EscenasArco1.todas) escena.flagDeSalida,
      };
      for (final flagSalida in EscenasArco1.flagsDeCierrePorEscena.keys) {
        expect(idsConocidos, contains(flagSalida),
            reason: 'flagsDeCierrePorEscena referencia $flagSalida pero '
                'ninguna escena de EscenasArco1.todas lo declara como '
                'flagDeSalida');
      }
    });
  });
}
