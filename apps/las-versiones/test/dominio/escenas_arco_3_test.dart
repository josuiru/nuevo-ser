import 'package:flutter_test/flutter_test.dart';
import 'package:las_versiones/dominio/ambiente_archivo.dart';
import 'package:las_versiones/dominio/escenas_arco_3.dart';
import 'package:las_versiones/dominio/voz_personaje.dart';
import 'package:nuevo_ser_core/nuevo_ser_core.dart';

void main() {
  group('EscenasArco3.aperturaDelArco (3.0.1)', () {
    test('id y flagDeSalida estables', () {
      expect(EscenasArco3.aperturaDelArco.id, '3.0.1');
      expect(
        EscenasArco3.aperturaDelArco.flagDeSalida,
        'escena_3_0_1_vista',
      );
    });

    test(
      'precondición = arco_2_cerrado_por_la_cronista — el Arco 3 sólo '
      'arranca cuando la 2.Z.2 ha cerrado el Arco 2',
      () {
        expect(
          EscenasArco3.aperturaDelArco.flagsRequeridos,
          {'arco_2_cerrado_por_la_cronista'},
        );
      },
    );

    test(
      'al cerrar la escena se activan arco_3_iniciado y '
      'tudela_1378_anunciada — flag hito + flag narrativo de que '
      'la Brecha de la judería de Tudela 1378 ha sido anunciada',
      () {
        expect(
          EscenasArco3.flagsDeCierrePorEscena['escena_3_0_1_vista'],
          containsAll(<String>['arco_3_iniciado', 'tudela_1378_anunciada']),
        );
      },
    );

    test('viaja con ambiente despacho de Isaura', () {
      expect(
        EscenasArco3.aperturaDelArco.ambiente,
        same(AmbienteArchivo.despachoIsaura),
      );
    });

    test('habla Isaura y Maren — sin terceros en esta apertura', () {
      final voces = EscenasArco3.aperturaDelArco.planos
          .whereType<PlanoDialogo>()
          .map((p) => p.voz)
          .toSet();
      expect(voces, {VozPersonaje.isaura, VozPersonaje.maren});
    });

    test(
      'contiene la línea pedagógica clave de la apertura — anuncio '
      'explícito de la Brecha de la judería de Tudela de 1378',
      () {
        final dialogos = EscenasArco3.aperturaDelArco.planos
            .whereType<PlanoDialogo>()
            .map((p) => p.texto);
        expect(
          dialogos.any((t) => t.contains('judería de Tudela de 1378')),
          isTrue,
        );
      },
    );

    test(
      'contiene la frase clave de Isaura sobre por qué se la asigna '
      'a Maren — "puede llegar a una versión nueva sin estar atrapada"',
      () {
        final dialogos = EscenasArco3.aperturaDelArco.planos
            .whereType<PlanoDialogo>()
            .map((p) => p.texto);
        expect(
          dialogos.any((t) =>
              t.contains('versión nueva') && t.contains('atrapada')),
          isTrue,
        );
      },
    );
  });

  group('EscenasArco3.eiderYLaDistancia (3.0.2)', () {
    test('precondición = escena_3_0_1_vista — encadena con la apertura', () {
      expect(
        EscenasArco3.eiderYLaDistancia.flagsRequeridos,
        {'escena_3_0_1_vista'},
      );
    });

    test('habla Eider, Maren y voz del Cuaderno', () {
      final voces = EscenasArco3.eiderYLaDistancia.planos
          .whereType<PlanoDialogo>()
          .map((p) => p.voz)
          .toSet();
      expect(
        voces,
        {VozPersonaje.eider, VozPersonaje.maren, VozPersonaje.vozDeFuente},
      );
    });

    test('viaja con ambiente plaza del Castillo de Iruña', () {
      expect(
        EscenasArco3.eiderYLaDistancia.ambiente,
        same(AmbienteArchivo.plazaCastilloIruna),
      );
    });

    test(
      'contiene la línea de Eider que articula la distancia — "Otra '
      'vez fuera"',
      () {
        final dialogos = EscenasArco3.eiderYLaDistancia.planos
            .whereType<PlanoDialogo>()
            .map((p) => p.texto);
        expect(
          dialogos.any((t) => t.contains('Otra vez fuera')),
          isTrue,
        );
      },
    );
  });

  group('EscenasArco3.sanCernin (3.1.1)', () {
    test('viaja con ambiente iglesia de San Cernin', () {
      expect(
        EscenasArco3.sanCernin.ambiente,
        same(AmbienteArchivo.iglesiaSanCernin),
      );
    });

    test(
      'al cerrar la escena se activan san_cernin_visitado y '
      'tres_burgos_aprendidos — flags pedagógicos del modelo de los '
      'tres burgos medievales de Pamplona',
      () {
        expect(
          EscenasArco3.flagsDeCierrePorEscena['escena_3_1_1_vista'],
          containsAll(<String>[
            'san_cernin_visitado',
            'tres_burgos_aprendidos',
          ]),
        );
      },
    );

    test(
      'menciona los tres burgos por nombre — Navarrería + San Cernin '
      '+ San Nicolás',
      () {
        final dialogos = EscenasArco3.sanCernin.planos
            .whereType<PlanoDialogo>()
            .map((p) => p.texto)
            .join(' ');
        expect(dialogos, contains('Navarrería'));
        expect(dialogos, contains('San Cernin'));
        expect(dialogos, contains('San Nicolás'));
      },
    );
  });

  group('EscenasArco3.tresLenguas (3.1.2)', () {
    test('viaja con ambiente Mesa de Trabajo del Archivo', () {
      expect(
        EscenasArco3.tresLenguas.ambiente,
        same(AmbienteArchivo.mesaTrabajoArchivo),
      );
    });

    test(
      'menciona las tres lenguas — latín + romance navarro + occitano '
      'gascón',
      () {
        final acotaciones = EscenasArco3.tresLenguas.planos
            .whereType<PlanoAmbiente>()
            .map((p) => p.textoLectura ?? '')
            .join(' ');
        expect(acotaciones, contains('Latín'));
        expect(acotaciones, contains('Romance navarro'));
        expect(acotaciones, contains('Occitano gascón'));
      },
    );

    test(
      'cita el documento histórico ancla — Fuero de Pamplona-San '
      'Cernin (1129) en latín jurídico medieval',
      () {
        final acotaciones = EscenasArco3.tresLenguas.planos
            .whereType<PlanoAmbiente>()
            .map((p) => p.textoLectura ?? '')
            .join(' ');
        expect(
          acotaciones,
          contains('Fuero de Pamplona-San Cernin (1129)'),
        );
      },
    );
  });

  group('EscenasArco3.concilioSanCernin (3.1.4)', () {
    test('viaja con ambiente Salón del Concilio', () {
      expect(
        EscenasArco3.concilioSanCernin.ambiente,
        same(AmbienteArchivo.salonConcilio),
      );
    });

    test(
      'la pregunta clave de Karim distingue documentación trilingüe '
      'Sólida vs inferencia indirecta sobre el euskera oral cotidiano '
      'Probable — pedagogía del manejo de evidencia',
      () {
        final dialogos = EscenasArco3.concilioSanCernin.planos
            .whereType<PlanoDialogo>()
            .map((p) => p.texto)
            .join(' ');
        expect(dialogos, contains('Probable y no Sólido'));
        expect(dialogos, contains('evidencia indirecta'));
      },
    );
  });

  group('EscenasArco3.marinaYLosPuentes (3.A.1)', () {
    test(
      'precondición = arco_3_estacion_1_cerrada (la 3.1.5 lo activa) '
      '— se ordena detrás de la Estación 3.1 completa',
      () {
        expect(
          EscenasArco3.marinaYLosPuentes.flagsRequeridos,
          {'arco_3_estacion_1_cerrada'},
        );
      },
    );

    test(
      'cita la metáfora pedagógica clave — cada lengua es un puente '
      'al pensamiento de quien la hablaba con su propia geografía',
      () {
        final dialogos = EscenasArco3.marinaYLosPuentes.planos
            .whereType<PlanoDialogo>()
            .map((p) => p.texto)
            .join(' ');
        expect(dialogos, contains('puente al pensamiento'));
        expect(dialogos, contains('geografía'));
      },
    );
  });

  group('EscenasArco3.todas', () {
    test(
      'catálogo cubre 3.0.1 (apertura) + 3.0.2 (Eider y la distancia) '
      '+ Estación 3.1 completa (3.1.1 a 3.1.5 — San Cernin) + '
      'latente 3.A.1 (Marina y los puentes) — 8 cinemáticas '
      'implementadas hoy en el primer slice (F2-20a)',
      () {
        expect(EscenasArco3.todas, hasLength(8));
        expect(
          EscenasArco3.todas.map((escena) => escena.id).toList(),
          ['3.0.1', '3.0.2', '3.1.1', '3.1.2', '3.1.3', '3.1.4', '3.1.5', '3.A.1'],
        );
      },
    );

    test('todas las escenas tienen id y flagDeSalida no vacíos', () {
      for (final escena in EscenasArco3.todas) {
        expect(escena.id, isNotEmpty);
        expect(escena.flagDeSalida, isNotEmpty);
      }
    });

    test('todos los flagDeSalida son únicos en el catálogo', () {
      final flagsDeSalida =
          EscenasArco3.todas.map((escena) => escena.flagDeSalida).toList();
      expect(flagsDeSalida.toSet(), hasLength(flagsDeSalida.length));
    });

    test(
      'cada flag de salida con flagsDeCierrePorEscena registrado '
      'corresponde a una escena del catálogo',
      () {
        final flagsDeSalida =
            EscenasArco3.todas.map((escena) => escena.flagDeSalida).toSet();
        for (final flagDeCierre
            in EscenasArco3.flagsDeCierrePorEscena.keys) {
          expect(
            flagsDeSalida,
            contains(flagDeCierre),
            reason:
                'el mapa flagsDeCierrePorEscena registra "$flagDeCierre" '
                'pero ninguna escena tiene ese flagDeSalida',
          );
        }
      },
    );
  });
}
