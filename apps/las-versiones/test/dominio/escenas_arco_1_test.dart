import 'package:flutter_test/flutter_test.dart';
import 'package:las_versiones/dominio/ambiente_archivo.dart';
import 'package:las_versiones/dominio/escenas_arco_1.dart';
import 'package:las_versiones/dominio/voz_personaje.dart';
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

  group('EscenasArco1.cierreCromlechConSira (1.2.fin)', () {
    test('id, flagDeSalida y precondición coherentes', () {
      expect(EscenasArco1.cierreCromlechConSira.id, '1.2.fin');
      expect(
        EscenasArco1.cierreCromlechConSira.flagDeSalida,
        'escena_1_2_fin_vista',
      );
      expect(
        EscenasArco1.cierreCromlechConSira.flagsRequeridos,
        {'brecha_1_2_completada'},
        reason: 'la cinemática se dispara automáticamente cuando la '
            'Brecha 1.2 se cierra',
      );
    });

    test('viaja con ambiente del crómlech — la caminata de regreso '
        'arranca en el sitio antes de subir al coche', () {
      expect(
        EscenasArco1.cierreCromlechConSira.ambiente,
        same(AmbienteArchivo.cromlechAralar),
      );
    });

    test('cierra como amable — la voz del Cuaderno cierra la sesión, '
        'no encadena con la 1.B.1 en la misma sesión', () {
      final ultimoPlano = EscenasArco1.cierreCromlechConSira.planos.last;
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

  group('EscenasArco1.viajeAlPirineo (1.3.1)', () {
    test('id, flagDeSalida y precondición coherentes', () {
      expect(EscenasArco1.viajeAlPirineo.id, '1.3.1');
      expect(
        EscenasArco1.viajeAlPirineo.flagDeSalida,
        'escena_1_3_1_vista',
      );
      expect(
        EscenasArco1.viajeAlPirineo.flagsRequeridos,
        {'escena_1_b1_vista'},
        reason: '1.3.1 se dispara después de la conversación con el padre '
            '(1.B.1), que cerraba la transición entre Estaciones 2 y 3',
      );
    });

    test('viaja con ambiente coche de Isaura — la carretera al Pirineo', () {
      expect(
        EscenasArco1.viajeAlPirineo.ambiente,
        same(AmbienteArchivo.cocheIsaura),
      );
    });

    test('cierra como amable — al llegar al inicio del bosque la sesión '
        'puede pausarse antes de entrar a la cueva', () {
      final ultimoPlano = EscenasArco1.viajeAlPirineo.planos.last;
      expect(ultimoPlano, isA<PlanoCierreAmable>());
    });
  });

  group('EscenasArco1.laBocaDeLaCueva (1.3.2)', () {
    test('id, flagDeSalida y precondición coherentes', () {
      expect(EscenasArco1.laBocaDeLaCueva.id, '1.3.2');
      expect(
        EscenasArco1.laBocaDeLaCueva.flagDeSalida,
        'escena_1_3_2_vista',
      );
      expect(
        EscenasArco1.laBocaDeLaCueva.flagsRequeridos,
        {'escena_1_3_1_vista'},
        reason: '1.3.2 se encadena directamente tras 1.3.1',
      );
    });

    test('viaja con ambiente bosque de hayas — la subida hasta la boca '
        'de la cueva', () {
      expect(
        EscenasArco1.laBocaDeLaCueva.ambiente,
        same(AmbienteArchivo.bosqueHayas),
      );
    });

    test('cierra como amable — antes de entrar a la cueva la sesión '
        'puede pausarse', () {
      final ultimoPlano = EscenasArco1.laBocaDeLaCueva.planos.last;
      expect(ultimoPlano, isA<PlanoCierreAmable>());
    });
  });

  group('EscenasArco1.dentroDeLaCueva (1.3.3)', () {
    test('id, flagDeSalida y precondición coherentes', () {
      expect(EscenasArco1.dentroDeLaCueva.id, '1.3.3');
      expect(
        EscenasArco1.dentroDeLaCueva.flagDeSalida,
        'escena_1_3_3_vista',
      );
      expect(
        EscenasArco1.dentroDeLaCueva.flagsRequeridos,
        {'escena_1_3_2_vista'},
        reason: '1.3.3 se encadena directamente tras 1.3.2',
      );
    });

    test('viaja con ambiente interior de la cueva — el covacho de '
        'habitación con carbones y herramientas', () {
      expect(
        EscenasArco1.dentroDeLaCueva.ambiente,
        same(AmbienteArchivo.cuevaInterior),
      );
    });

    test('cierra como amable — antes de la sala con grabados la sesión '
        'puede pausarse', () {
      final ultimoPlano = EscenasArco1.dentroDeLaCueva.planos.last;
      expect(ultimoPlano, isA<PlanoCierreAmable>());
    });
  });

  group('EscenasArco1.laPared (1.3.4)', () {
    test('id, flagDeSalida y precondición coherentes', () {
      expect(EscenasArco1.laPared.id, '1.3.4');
      expect(
        EscenasArco1.laPared.flagDeSalida,
        'escena_1_3_4_vista',
      );
      expect(
        EscenasArco1.laPared.flagsRequeridos,
        {'escena_1_3_3_vista'},
        reason: '1.3.4 se encadena directamente tras 1.3.3',
      );
    });

    test('viaja con ambiente sala con grabados parietales — el corazón '
        'pedagógico de la Estación 3', () {
      expect(
        EscenasArco1.laPared.ambiente,
        same(AmbienteArchivo.salaGrabadosParietales),
      );
    });

    test('cierra como amable — los momentos largos sin diálogo terminan '
        'cuando el jugador decide salir', () {
      final ultimoPlano = EscenasArco1.laPared.planos.last;
      expect(ultimoPlano, isA<PlanoCierreAmable>());
    });
  });

  group('EscenasArco1.vueltaYSilencio (1.3.5)', () {
    test('id, flagDeSalida y precondición coherentes', () {
      expect(EscenasArco1.vueltaYSilencio.id, '1.3.5');
      expect(
        EscenasArco1.vueltaYSilencio.flagDeSalida,
        'escena_1_3_5_vista',
      );
      expect(
        EscenasArco1.vueltaYSilencio.flagsRequeridos,
        {'escena_1_3_4_vista'},
        reason: '1.3.5 se encadena directamente tras 1.3.4 — el coche '
            'de regreso',
      );
    });

    test('viaja con ambiente coche de Isaura — la vuelta', () {
      expect(
        EscenasArco1.vueltaYSilencio.ambiente,
        same(AmbienteArchivo.cocheIsaura),
      );
    });

    test('cierra como amable — al llegar a Iruña termina la sesión, no '
        'encadena con la fase jugable de la Brecha 1.3 en la misma '
        'sesión', () {
      final ultimoPlano = EscenasArco1.vueltaYSilencio.planos.last;
      expect(ultimoPlano, isA<PlanoCierreAmable>());
    });
  });

  group('EscenasArco1.elPrimerConcilioFormal (1.3.6)', () {
    test('id, flagDeSalida y precondición coherentes', () {
      expect(EscenasArco1.elPrimerConcilioFormal.id, '1.3.6');
      expect(
        EscenasArco1.elPrimerConcilioFormal.flagDeSalida,
        'escena_1_3_6_vista',
      );
      expect(
        EscenasArco1.elPrimerConcilioFormal.flagsRequeridos,
        {'brecha_1_3_completada'},
        reason: '1.3.6 se dispara automáticamente al cerrar la fase '
            'jugable de la Brecha 1.3',
      );
    });

    test('viaja con ambiente sala del Concilio — Aitor, Joana y Karim '
        'revisan la entrega de Maren', () {
      expect(
        EscenasArco1.elPrimerConcilioFormal.ambiente,
        same(AmbienteArchivo.salonConcilio),
      );
    });

    test('cierra como amable — tras el Concilio formal Maren vuelve a '
        'casa, no encadena con 1.3.7 en la misma sesión', () {
      final ultimoPlano = EscenasArco1.elPrimerConcilioFormal.planos.last;
      expect(ultimoPlano, isA<PlanoCierreAmable>());
    });
  });

  group('EscenasArco1.elApunteLargo (1.3.7)', () {
    test('id, flagDeSalida y precondición coherentes', () {
      expect(EscenasArco1.elApunteLargo.id, '1.3.7');
      expect(
        EscenasArco1.elApunteLargo.flagDeSalida,
        'escena_1_3_7_vista',
      );
      expect(
        EscenasArco1.elApunteLargo.flagsRequeridos,
        {'escena_1_3_6_vista'},
        reason: '1.3.7 se encadena directamente tras 1.3.6 — el apunte '
            'largo en el Cuaderno tras el primer Concilio formal',
      );
    });

    test('viaja con ambiente cuarto de Maren — donde escribe en su '
        'Cuaderno', () {
      expect(
        EscenasArco1.elApunteLargo.ambiente,
        same(AmbienteArchivo.cuartoCasaMaren),
      );
    });

    test('cierra como amable — al cerrar el Cuaderno termina la sesión',
        () {
      final ultimoPlano = EscenasArco1.elApunteLargo.planos.last;
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

  group('EscenasArco1.viajeAYacimientoIrulegi (1.4.1)', () {
    test('id, flagDeSalida y precondición coherentes', () {
      expect(EscenasArco1.viajeAYacimientoIrulegi.id, '1.4.1');
      expect(
        EscenasArco1.viajeAYacimientoIrulegi.flagDeSalida,
        'escena_1_4_1_vista',
      );
      expect(
        EscenasArco1.viajeAYacimientoIrulegi.flagsRequeridos,
        {'escena_1_3_7_vista'},
        reason: '1.4.1 se encadena tras la 1.3.7 (apunte largo del '
            'Cuaderno tras el primer Concilio formal)',
      );
    });

    test('viaja con ambiente yacimiento de Irulegi — el monte sobre '
        'el valle de Aranguren', () {
      expect(
        EscenasArco1.viajeAYacimientoIrulegi.ambiente,
        same(AmbienteArchivo.yacimientoIrulegi),
      );
    });

    test('cierra como amable — Maren empieza la jornada de trabajo '
        'en el sitio, no encadena con 1.4.2 en la misma sesión', () {
      final ultimoPlano = EscenasArco1.viajeAYacimientoIrulegi.planos.last;
      expect(ultimoPlano, isA<PlanoCierreAmable>());
    });
  });

  group('EscenasArco1.materialCongelado (1.4.2)', () {
    test('id, flagDeSalida y precondición coherentes', () {
      expect(EscenasArco1.materialCongelado.id, '1.4.2');
      expect(
        EscenasArco1.materialCongelado.flagDeSalida,
        'escena_1_4_2_vista',
      );
      expect(
        EscenasArco1.materialCongelado.flagsRequeridos,
        {'escena_1_4_1_vista'},
        reason: '1.4.2 se encadena directamente tras 1.4.1',
      );
    });

    test('viaja con ambiente Museo de Navarra — donde está la Mano de '
        'Irulegi y donde Maren articula la voz del Cuaderno', () {
      expect(
        EscenasArco1.materialCongelado.ambiente,
        same(AmbienteArchivo.museoNavarra),
      );
    });

    test('cierra como amable — al cerrar la voz del Cuaderno se abre '
        'la fase jugable de la Brecha 1.4 (siguiente sesión)', () {
      final ultimoPlano = EscenasArco1.materialCongelado.planos.last;
      expect(ultimoPlano, isA<PlanoCierreAmable>());
    });
  });

  group('EscenasArco1.granConcilio (1.4.3)', () {
    test('id, flagDeSalida y precondición coherentes', () {
      expect(EscenasArco1.granConcilio.id, '1.4.3');
      expect(
        EscenasArco1.granConcilio.flagDeSalida,
        'escena_1_4_3_vista',
      );
      expect(
        EscenasArco1.granConcilio.flagsRequeridos,
        {'brecha_1_4_completada'},
        reason: '1.4.3 reproduce el diálogo del Concilio tras cerrar la '
            'fase jugable de la Brecha 1.4',
      );
    });

    test('viaja con ambiente sala del Concilio — donde Begoña preside '
        'el Concilio entero', () {
      expect(
        EscenasArco1.granConcilio.ambiente,
        same(AmbienteArchivo.salonConcilio),
      );
    });

    test('cierra como amable — tras la promoción a Aprendiz I la sesión '
        'termina, no encadena con 1.4.4 en la misma sesión', () {
      final ultimoPlano = EscenasArco1.granConcilio.planos.last;
      expect(ultimoPlano, isA<PlanoCierreAmable>());
    });
  });

  group('EscenasArco1.entregaDelMosaico (M1.entrega)', () {
    test('id, flagDeSalida y precondición coherentes', () {
      expect(EscenasArco1.entregaDelMosaico.id, 'M1.entrega');
      expect(
        EscenasArco1.entregaDelMosaico.flagDeSalida,
        'escena_m1_entrega_vista',
      );
      expect(
        EscenasArco1.entregaDelMosaico.flagsRequeridos,
        {'mosaico_arco_1_entregado'},
        reason: 'la cinemática se dispara automáticamente cuando la '
            'Cronista entrega el Mosaico (la pantalla activa el flag '
            'vía callback del orquestador)',
      );
    });

    test('viaja con ambiente ático del Archivo — donde Andrés archiva '
        'el Mosaico', () {
      expect(
        EscenasArco1.entregaDelMosaico.ambiente,
        same(AmbienteArchivo.aticoArchivo),
      );
    });

    test('cierra como amable — al volver a casa termina la sesión, '
        'no encadena con la 1.Z en la misma sesión', () {
      final ultimoPlano = EscenasArco1.entregaDelMosaico.planos.last;
      expect(ultimoPlano, isA<PlanoCierreAmable>());
    });
  });

  group('EscenasArco1.aprendizI (1.4.4)', () {
    test('id, flagDeSalida y precondición coherentes', () {
      expect(EscenasArco1.aprendizI.id, '1.4.4');
      expect(EscenasArco1.aprendizI.flagDeSalida, 'escena_1_4_4_vista');
      expect(
        EscenasArco1.aprendizI.flagsRequeridos,
        {'escena_1_4_3_vista'},
        reason: 'tras F8.6 la 1.4.4 se dispara al cerrar la 1.4.3 (gran '
            'Concilio), no directamente al cerrar la Brecha — el orden '
            'narrativo es Brecha 1.4 → 1.4.3 → 1.4.4',
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

  group('EscenasArco1.cierreDelArco (1.Z)', () {
    test('id, flagDeSalida y precondición coherentes', () {
      expect(EscenasArco1.cierreDelArco.id, '1.Z');
      expect(
        EscenasArco1.cierreDelArco.flagDeSalida,
        'escena_1_z_vista',
      );
      expect(
        EscenasArco1.cierreDelArco.flagsRequeridos,
        {'escena_m1_entrega_vista'},
        reason: '1.Z se dispara la noche de la entrega del Mosaico — '
            'tras la cinemática de entrega (Andrés + Marina)',
      );
    });

    test('viaja con ambiente cuarto de Maren — donde escribe en su '
        'Cuaderno la noche del cierre', () {
      expect(
        EscenasArco1.cierreDelArco.ambiente,
        same(AmbienteArchivo.cuartoCasaMaren),
      );
    });

    test('cierra como amable — al cerrar el Cuaderno termina la '
        'sesión y se queda activo `arco_1_cerrado_por_la_cronista`',
        () {
      final ultimoPlano = EscenasArco1.cierreDelArco.planos.last;
      expect(ultimoPlano, isA<PlanoCierreAmable>());
    });

    test('la voz interna del Cuaderno usa VozPersonaje.vozDeFuente — '
        'monólogo en cursiva sin atribución personal, característico '
        'de la voz íntima del Cuaderno en el resto del arco', () {
      final dialogos = EscenasArco1.cierreDelArco.planos
          .whereType<PlanoDialogo>()
          .toList();
      expect(dialogos, isNotEmpty);
      for (final plano in dialogos) {
        expect(plano.voz, same(VozPersonaje.vozDeFuente));
      }
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

    test('1.B cierra activando cromlech_aralar_alcanzado — encadena con '
        'la Brecha 1.2 (en F8.4 el flag arco_1_completado se sacó de '
        'aquí; entrará al cierre de 1.4.4 cuando exista la Brecha 1.4)',
        () {
      final flags =
          EscenasArco1.flagsDeCierrePorEscena['escena_1_b_vista'];
      expect(flags, contains('cromlech_aralar_alcanzado'));
      expect(flags, contains('visita_atico_andres'));
      expect(flags, isNot(contains('arco_1_completado')),
          reason: 'arco_1_completado se mueve al cierre de 1.4.4 cuando '
              'entren todas las Estaciones del arco');
    });

    test('1.2.fin cierra activando arco_1_estacion_2_cerrada y registra '
        'el primer trabajo en equipo de Maren con un par', () {
      final flags =
          EscenasArco1.flagsDeCierrePorEscena['escena_1_2_fin_vista'];
      expect(flags, {
        'arco_1_estacion_2_cerrada',
        'primer_trabajo_en_equipo_completado',
      });
    });

    test('1.4.4 cierra activando rango_aprendiz_i, arco_2_anunciado y '
        'arco_1_completado — Maren asciende a Aprendiz I, se abre la '
        'transición al Arco 2 y se dispara el Mosaico de fin de arco '
        '(tras F8.6 el flag arco_1_completado se mueve aquí desde 1.B '
        'porque la 1.4.4 es el cierre real del arco)', () {
      final flags =
          EscenasArco1.flagsDeCierrePorEscena['escena_1_4_4_vista'];
      expect(flags, {
        'rango_aprendiz_i',
        'arco_2_anunciado',
        'arco_1_completado',
      });
    });

    test('1.4.1 cierra activando visitado_yacimiento_irulegi y '
        'avisada_concilio_entero — Maren llega al sitio y queda '
        'enterada del Concilio entero del día siguiente', () {
      final flags =
          EscenasArco1.flagsDeCierrePorEscena['escena_1_4_1_vista'];
      expect(flags, {'visitado_yacimiento_irulegi', 'avisada_concilio_entero'});
    });

    test('1.4.2 cierra activando material_irulegi_recogido — el flag '
        'que el catálogo de Brechas reconoce como disparador de la '
        'fase jugable de la Brecha 1.4', () {
      final flags =
          EscenasArco1.flagsDeCierrePorEscena['escena_1_4_2_vista'];
      expect(flags, {'material_irulegi_recogido', 'mano_irulegi_observada'});
    });

    test('1.4.3 cierra activando gran_concilio_realizado — el Concilio '
        'queda registrado pero NO activa arco_1_completado: ese flag '
        'se mueve a 1.4.4 para preservar el orden narrativo del doc 07 '
        '(§M1 "Activa: tras 1.4")', () {
      final flags =
          EscenasArco1.flagsDeCierrePorEscena['escena_1_4_3_vista'];
      expect(flags, {'gran_concilio_realizado'});
      expect(flags, isNot(contains('arco_1_completado')),
          reason: 'arco_1_completado se activa en 1.4.4 para que el '
              'Mosaico llegue tras la promoción a Aprendiz I, no antes');
    });

    test('1.Z cierra activando arco_1_cerrado_por_la_cronista — el '
        'flag canónico del cierre del arco narrado por Maren (no por '
        'el sistema)', () {
      final flags =
          EscenasArco1.flagsDeCierrePorEscena['escena_1_z_vista'];
      expect(flags, {'arco_1_cerrado_por_la_cronista'});
    });

    test('1.3.1 cierra activando traveling_pyrenees_first — la primera '
        'salida con Isaura fuera de Iruña queda registrada en el estado '
        'narrativo', () {
      final flags =
          EscenasArco1.flagsDeCierrePorEscena['escena_1_3_1_vista'];
      expect(flags, {'traveling_pyrenees_first'});
    });

    test('1.3.5 cierra activando cueva_pirineo_visitada — el flag que '
        'el catálogo de Brechas reconoce como disparador de la fase '
        'jugable de la Brecha 1.3', () {
      final flags =
          EscenasArco1.flagsDeCierrePorEscena['escena_1_3_5_vista'];
      expect(flags, {'cueva_pirineo_visitada'});
    });

    test('1.3.6 cierra activando first_formal_concilio — el primer '
        'Concilio formal de Maren con revisores académicos', () {
      final flags =
          EscenasArco1.flagsDeCierrePorEscena['escena_1_3_6_vista'];
      expect(flags, {'first_formal_concilio'});
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
      // El flag `mosaico_arco_1_entregado` lo activa el orquestador
      // al recibir el callback `alEntregar` de la pantalla del
      // Mosaico, no una escena. Lo añadimos al pool inicial para
      // que la cinemática `entregaDelMosaico` pueda referenciarlo.
      flagsProducibles.add('mosaico_arco_1_entregado');

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
