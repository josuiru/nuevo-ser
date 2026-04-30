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

  group('EscenasArco1.laMeriendaConEider (1.A)', () {
    test('id, flagDeSalida y precondición coherentes', () {
      expect(EscenasArco1.laMeriendaConEider.id, '1.A');
      expect(
        EscenasArco1.laMeriendaConEider.flagDeSalida,
        'escena_1_a_vista',
      );
      expect(
        EscenasArco1.laMeriendaConEider.flagsRequeridos,
        {'escena_1_1_7_vista'},
        reason: '1.A se dispara después de la 1.1.7, no antes',
      );
    });

    test('viaja con ambiente cafetería del Casco Viejo — primer espacio '
        'neutro fuera de Archivo y casa familiar', () {
      expect(
        EscenasArco1.laMeriendaConEider.ambiente,
        same(AmbienteArchivo.cafeteriaCascoViejo),
      );
    });

    test('cierra como amable — la sesión termina al pagar y salir, no '
        'encadena con 1.B en la misma sesión', () {
      final ultimoPlano = EscenasArco1.laMeriendaConEider.planos.last;
      expect(ultimoPlano, isA<PlanoCierreAmable>());
    });
  });

  group('EscenasArco1.elAtico (1.B)', () {
    test('id, flagDeSalida y precondición coherentes', () {
      expect(EscenasArco1.elAtico.id, '1.B');
      expect(EscenasArco1.elAtico.flagDeSalida, 'escena_1_b_vista');
      expect(
        EscenasArco1.elAtico.flagsRequeridos,
        {'escena_1_a_vista'},
        reason: '1.B se dispara después de 1.A',
      );
    });

    test('viaja con ambiente ático del Archivo — donde está Andrés', () {
      expect(
        EscenasArco1.elAtico.ambiente,
        same(AmbienteArchivo.aticoArchivo),
      );
    });

    test('cierra como amable — al bajar del ático termina la sesión y el '
        'orquestador ya tiene arco_1_completado activo para abrir el '
        'Mosaico al siguiente arranque', () {
      final ultimoPlano = EscenasArco1.elAtico.planos.last;
      expect(ultimoPlano, isA<PlanoCierreAmable>());
    });
  });

  group('EscenasArco1.conversacionConElPadre (1.B.1)', () {
    test('id, flagDeSalida y precondición coherentes', () {
      expect(EscenasArco1.conversacionConElPadre.id, '1.B.1');
      expect(
        EscenasArco1.conversacionConElPadre.flagDeSalida,
        'escena_1_b1_vista',
      );
      expect(
        EscenasArco1.conversacionConElPadre.flagsRequeridos,
        {'brecha_1_2_completada'},
        reason: '1.B.1 requiere haber cerrado la Estación 2 — queda '
            'latente hasta que entre la Brecha 1.2 al catálogo',
      );
    });

    test('viaja con ambiente cocina de casa de Maren', () {
      expect(
        EscenasArco1.conversacionConElPadre.ambiente,
        same(AmbienteArchivo.cocinaCasaMaren),
      );
    });

    test('cierra como amable — al salir de la cocina termina la sesión',
        () {
      final ultimoPlano = EscenasArco1.conversacionConElPadre.planos.last;
      expect(ultimoPlano, isA<PlanoCierreAmable>());
    });
  });

  group('EscenasArco1.naiaPregunta (1.C)', () {
    test('id, flagDeSalida y precondición coherentes', () {
      expect(EscenasArco1.naiaPregunta.id, '1.C');
      expect(EscenasArco1.naiaPregunta.flagDeSalida, 'escena_1_c_vista');
      expect(
        EscenasArco1.naiaPregunta.flagsRequeridos,
        {'brecha_1_3_completada'},
        reason: '1.C requiere haber cerrado la Estación 3 (cueva) — '
            'queda latente hasta que entre la Brecha 1.3 al catálogo',
      );
    });

    test('viaja con ambiente cocina de casa de Maren — cena familiar', () {
      expect(
        EscenasArco1.naiaPregunta.ambiente,
        same(AmbienteArchivo.cocinaCasaMaren),
      );
    });

    test('cierra como amable — al terminar la cena termina la sesión', () {
      final ultimoPlano = EscenasArco1.naiaPregunta.planos.last;
      expect(ultimoPlano, isA<PlanoCierreAmable>());
    });
  });

  group('EscenasArco1.aprendizI (1.4.4)', () {
    test('id, flagDeSalida y precondición coherentes', () {
      expect(EscenasArco1.aprendizI.id, '1.4.4');
      expect(EscenasArco1.aprendizI.flagDeSalida, 'escena_1_4_4_vista');
      expect(
        EscenasArco1.aprendizI.flagsRequeridos,
        {'brecha_1_4_completada'},
        reason: '1.4.4 requiere haber cerrado la Estación 4 (Irulegi) — '
            'queda latente hasta que entre la Brecha 1.4 al catálogo',
      );
    });

    test('viaja con ambiente patio del Archivo — el capitel y el brocal '
        'del pozo', () {
      expect(
        EscenasArco1.aprendizI.ambiente,
        same(AmbienteArchivo.patioArchivo),
      );
    });

    test('cierra como amable — al "cerrar el arco" termina la sesión '
        '(la cinemática 1.Z del cierre del arco aún no está catalogada)',
        () {
      final ultimoPlano = EscenasArco1.aprendizI.planos.last;
      expect(ultimoPlano, isA<PlanoCierreAmable>());
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

    test('1.B cierra activando arco_1_completado — es el último flag del '
        'recorrido del Arco 1 antes del Mosaico (provisional hasta que '
        'entren las Estaciones 1.2-1.4 al catálogo)', () {
      final flags =
          EscenasArco1.flagsDeCierrePorEscena['escena_1_b_vista'];
      expect(flags, contains('arco_1_completado'));
      expect(flags, contains('visita_atico_andres'));
    });

    test('1.4.4 cierra activando rango_aprendiz_i y arco_2_anunciado — '
        'Maren asciende a Aprendiz I y se abre la transición al Arco 2',
        () {
      final flags =
          EscenasArco1.flagsDeCierrePorEscena['escena_1_4_4_vista'];
      expect(flags, {'rango_aprendiz_i', 'arco_2_anunciado'});
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
    test('cada escena (excepto la primera) tiene precondiciones — el '
        'orquestador no la dispara antes de su sitio', () {
      var primera = true;
      for (final escena in EscenasArco1.todas) {
        if (primera) {
          primera = false;
          continue;
        }
        expect(
          escena.flagsRequeridos,
          isNotEmpty,
          reason: '${escena.id} debe declarar al menos una precondición '
              'para no dispararse antes de tiempo',
        );
      }
    });

    test('cada escena (excepto la primera) requiere o bien la flagDeSalida '
        'de una escena anterior, o un flag conocido del juego (caso típico: '
        'una escena posterior a una Brecha requiere brecha_<id>_completada)',
        () {
      // Construimos el conjunto de "flags producibles" antes de cada
      // escena: flagDeSalida + flagsDeCierre de escenas previas, más
      // los flags conocidos de cierre de Brechas (brecha_<id>_completada).
      final flagsProducibles = <String>{};
      // Las Brechas catalogadas también producen su flag de cierre.
      // Lo añadimos al pool inicial para que escenas posteriores a
      // una Brecha puedan referenciarlo libremente. Hoy sólo está
      // implementada la Brecha 1.1 en el catálogo, pero el doc 07
      // prevé 1.2/1.3/1.4 — las cinemáticas posteriores (1.B.1, 1.C)
      // las anclan ya, lo que las deja latentes hasta que las
      // Brechas correspondientes entren al catálogo.
      flagsProducibles.add('brecha_1_1_completada');
      flagsProducibles.add('brecha_1_2_completada');
      flagsProducibles.add('brecha_1_3_completada');
      flagsProducibles.add('brecha_1_4_completada');

      var primera = true;
      for (final escena in EscenasArco1.todas) {
        if (!primera) {
          for (final requerido in escena.flagsRequeridos) {
            expect(
              flagsProducibles,
              contains(requerido),
              reason: '${escena.id} requiere "$requerido" pero no hay '
                  'unidad narrativa anterior que lo produzca',
            );
          }
        }
        primera = false;
        flagsProducibles.add(escena.flagDeSalida);
        final cierres =
            EscenasArco1.flagsDeCierrePorEscena[escena.flagDeSalida];
        if (cierres != null) flagsProducibles.addAll(cierres);
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
