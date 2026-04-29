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

  group('EscenasArco1.elRecorrido (1.0.2)', () {
    test('id, flagDeSalida y precondición coherentes', () {
      expect(EscenasArco1.elRecorrido.id, '1.0.2');
      expect(EscenasArco1.elRecorrido.flagDeSalida, 'escena_1_0_2_vista');
      expect(
        EscenasArco1.elRecorrido.flagsRequeridos,
        {'escena_1_0_1_vista'},
        reason: '1.0.2 sólo se dispara cuando la 1.0.1 ya está vista',
      );
    });

    test('viaja con ambiente paraguas recorrido_archivo — el recorrido '
        'cambia de espacio dentro de la escena', () {
      expect(
        EscenasArco1.elRecorrido.ambiente,
        same(AmbienteArchivo.recorridoArchivo),
      );
    });

    test('cierra como amable — al terminar el recorrido el orquestador '
        'manda a Maren a casa, no encadena con 1.0.3 en la misma sesión',
        () {
      final ultimoPlano = EscenasArco1.elRecorrido.planos.last;
      expect(ultimoPlano, isA<PlanoCierreAmable>());
    });
  });

  group('EscenasArco1.laPrimeraTardeEnCasa (1.0.3)', () {
    test('id, flagDeSalida y precondición coherentes', () {
      expect(EscenasArco1.laPrimeraTardeEnCasa.id, '1.0.3');
      expect(
        EscenasArco1.laPrimeraTardeEnCasa.flagDeSalida,
        'escena_1_0_3_vista',
      );
      expect(
        EscenasArco1.laPrimeraTardeEnCasa.flagsRequeridos,
        {'escena_1_0_2_vista'},
        reason: '1.0.3 sólo se dispara cuando la 1.0.2 ya está vista',
      );
    });

    test('viaja con ambiente paraguas casa_maren', () {
      expect(
        EscenasArco1.laPrimeraTardeEnCasa.ambiente,
        same(AmbienteArchivo.casaMaren),
      );
    });

    test('cierra con HASTA MAÑANA — la noche antes de la primera Brecha',
        () {
      final ultimoPlano =
          EscenasArco1.laPrimeraTardeEnCasa.planos.last as PlanoCierreAmable;
      expect(ultimoPlano.textoBoton, 'HASTA MAÑANA');
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

    test('1.0.2 cierra con met_andres, met_marina y seen_archivo_interior',
        () {
      final flags =
          EscenasArco1.flagsDeCierrePorEscena['escena_1_0_2_vista'];
      expect(flags, {'met_andres', 'met_marina', 'seen_archivo_interior'});
    });

    test('1.0.3 cierra con told_family_archive y naia_first_curiosity',
        () {
      final flags =
          EscenasArco1.flagsDeCierrePorEscena['escena_1_0_3_vista'];
      expect(flags, {'told_family_archive', 'naia_first_curiosity'});
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

  group('cadena del Arco 1', () {
    test('el orden en `todas` respeta la cadena de precondiciones — '
        'cada escena requiere la flagDeSalida de la anterior', () {
      String? salidaPrevia;
      for (final escena in EscenasArco1.todas) {
        if (salidaPrevia != null) {
          expect(
            escena.flagsRequeridos,
            contains(salidaPrevia),
            reason: '${escena.id} debe requerir el cierre de la escena '
                'anterior ($salidaPrevia)',
          );
        }
        salidaPrevia = escena.flagDeSalida;
      }
    });

    test('todas las escenas son únicas por id y por flagDeSalida', () {
      final ids = EscenasArco1.todas.map((e) => e.id).toSet();
      final flags = EscenasArco1.todas.map((e) => e.flagDeSalida).toSet();
      expect(ids.length, EscenasArco1.todas.length);
      expect(flags.length, EscenasArco1.todas.length);
    });
  });
}
