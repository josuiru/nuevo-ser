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

  group('EscenasArco3.caminoATudela (3.2.1)', () {
    test(
      'precondición = escena_3_a_1_vista — la latente de Marina cierra '
      'antes del viaje a Tudela',
      () {
        expect(
          EscenasArco3.caminoATudela.flagsRequeridos,
          {'escena_3_a_1_vista'},
        );
      },
    );

    test('viaja con ambiente coche de Aitor (no el de Isaura)', () {
      expect(
        EscenasArco3.caminoATudela.ambiente,
        same(AmbienteArchivo.cocheAitor),
      );
    });

    test(
      'contiene el aviso explícito de Aitor sobre Tasio + el consejo '
      'metodológico clave: dejarse examinar sabiendo qué se enseña',
      () {
        final dialogos = EscenasArco3.caminoATudela.planos
            .whereType<PlanoDialogo>()
            .map((p) => p.texto)
            .join(' ');
        expect(dialogos, contains('Tasio está en Tudela'));
        expect(dialogos, contains('Está examinándote'));
        expect(dialogos, contains('qué le enseñas tú'));
      },
    );
  });

  group('EscenasArco3.elEncuentroConTasio (3.2.5)', () {
    test('viaja con ambiente cafetería casco viejo de Tudela', () {
      expect(
        EscenasArco3.elEncuentroConTasio.ambiente,
        same(AmbienteArchivo.cafeteriaCascoViejoTudela),
      );
    });

    test(
      'al cerrar la escena se activan met_tasio y tasio_first_encounter '
      '— hito narrativo del primer encuentro con Tasio',
      () {
        expect(
          EscenasArco3.flagsDeCierrePorEscena['escena_3_2_5_vista'],
          containsAll(<String>['met_tasio', 'tasio_first_encounter']),
        );
      },
    );

    test(
      'hablan Tasio, Maren y Aitor — primer diálogo de Tasio del juego',
      () {
        final voces = EscenasArco3.elEncuentroConTasio.planos
            .whereType<PlanoDialogo>()
            .map((p) => p.voz)
            .toSet();
        expect(
          voces,
          {VozPersonaje.tasio, VozPersonaje.maren, VozPersonaje.aitor},
        );
      },
    );

    test(
      'contiene las tres preguntas pedagógicas clave de Tasio: '
      'reformabilidad del Archivo + ¿quieres ser Isaura? + ¿qué quieres ser?',
      () {
        final dialogos = EscenasArco3.elEncuentroConTasio.planos
            .whereType<PlanoDialogo>()
            .map((p) => p.texto)
            .join(' ');
        expect(dialogos, contains('Archivo es reformable desde dentro'));
        expect(dialogos, contains('¿Tú quieres ser Isaura?'));
        expect(dialogos, contains('¿Qué quieres ser?'));
      },
    );

    test(
      'contiene la petición clave de cierre: las tres lecturas de la '
      'Brecha del incendio de la judería de Tudela del 1378',
      () {
        final dialogos = EscenasArco3.elEncuentroConTasio.planos
            .whereType<PlanoDialogo>()
            .map((p) => p.texto)
            .join(' ');
        expect(dialogos, contains('judería de Tudela del 1378'));
        expect(dialogos, contains('tres lecturas'));
        expect(dialogos, contains('La tercera es la tuya'));
      },
    );
  });

  group('EscenasArco3.lasFuentesArabes (3.2.3)', () {
    test(
      'menciona las fuentes árabes ancla — Ibn Hayyán Muqtabis + '
      'Al-Razi + Crónica de Alfonso III + alcazaba como material '
      'arqueológico',
      () {
        final acotaciones = EscenasArco3.lasFuentesArabes.planos
            .whereType<PlanoAmbiente>()
            .map((p) => p.textoLectura ?? '')
            .join(' ');
        expect(acotaciones, contains('Ibn Hayyán'));
        expect(acotaciones, contains('Muqtabis'));
        expect(acotaciones, contains('Al-Razi'));
        expect(acotaciones, contains('Crónica de Alfonso III'));
        expect(acotaciones, contains('alcazaba'));
      },
    );

    test(
      'la voz del Cuaderno articula la lección clave de identidad '
      'muladí — la dicotomía moderna no aplica al periodo',
      () {
        final dialogos = EscenasArco3.lasFuentesArabes.planos
            .whereType<PlanoDialogo>()
            .map((p) => p.texto)
            .join(' ');
        expect(dialogos, contains('muladíes'));
        expect(dialogos, contains('dicotomía'));
      },
    );
  });

  group('EscenasArco3.elSilencioDeMaren (3.2.8)', () {
    test('viaja con ambiente cuarto de Maren', () {
      expect(
        EscenasArco3.elSilencioDeMaren.ambiente,
        same(AmbienteArchivo.cuartoCasaMaren),
      );
    });

    test(
      'no contiene PlanoDialogo — la única noche del MVP donde el '
      'Cuaderno no habla. El silencio es el dato',
      () {
        final dialogos =
            EscenasArco3.elSilencioDeMaren.planos.whereType<PlanoDialogo>();
        expect(dialogos, isEmpty);
      },
    );

    test(
      'al cerrar la escena se activa arco_3_estacion_2_cerrada — '
      'desbloquea la 3.B.1 latente con Isaura',
      () {
        expect(
          EscenasArco3.flagsDeCierrePorEscena['escena_3_2_8_vista'],
          contains('arco_3_estacion_2_cerrada'),
        );
      },
    );
  });

  group('EscenasArco3.teTratoBien (3.B.1)', () {
    test(
      'precondición = arco_3_estacion_2_cerrada — la 3.2.8 lo activa',
      () {
        expect(
          EscenasArco3.teTratoBien.flagsRequeridos,
          {'arco_3_estacion_2_cerrada'},
        );
      },
    );

    test(
      'contiene la frase de Isaura "Lo sigo queriendo" — confesión '
      'sobre Tasio que Maren obtiene tras preguntar "¿Tú lo querías?"',
      () {
        final dialogos = EscenasArco3.teTratoBien.planos
            .whereType<PlanoDialogo>()
            .map((p) => p.texto)
            .join(' ');
        expect(dialogos, contains('¿Tú lo querías?'));
        expect(dialogos, contains('Lo sigo queriendo'));
      },
    );
  });

  group('EscenasArco3.caminoALeyre (3.3.1)', () {
    test(
      'precondición = escena_3_b_1_vista — la 3.B.1 (Te trató bien) '
      'desbloquea el viaje a Leyre',
      () {
        expect(
          EscenasArco3.caminoALeyre.flagsRequeridos,
          {'escena_3_b_1_vista'},
        );
      },
    );

    test(
      'el ambiente es cocheMarina — el viaje lo lleva Marina, no '
      'Aitor (3.2.1) ni Isaura',
      () {
        expect(
          EscenasArco3.caminoALeyre.ambiente,
          same(AmbienteArchivo.cocheMarina),
        );
      },
    );

    test(
      'Marina cuenta a Maren la leyenda del abad Virila — los '
      'trescientos años, el pájaro, el regreso',
      () {
        final dialogos = EscenasArco3.caminoALeyre.planos
            .whereType<PlanoDialogo>()
            .map((p) => p.texto)
            .join(' ');
        expect(dialogos, contains('Virila'));
        expect(dialogos, contains('trescientos años'));
        expect(dialogos, contains('pájaro'));
      },
    );
  });

  group('EscenasArco3.elMonasterio (3.3.2)', () {
    test('viaja con ambiente monasterioLeyre', () {
      expect(
        EscenasArco3.elMonasterio.ambiente,
        same(AmbienteArchivo.monasterioLeyre),
      );
    });

    test(
      'menciona los cuatro reyes de Pamplona enterrados en Leyre + '
      'la cripta románica del s. XI',
      () {
        final dialogos = EscenasArco3.elMonasterio.planos
            .whereType<PlanoDialogo>()
            .map((p) => p.texto)
            .join(' ');
        final acotaciones = EscenasArco3.elMonasterio.planos
            .whereType<PlanoAmbiente>()
            .map((p) => p.textoLectura ?? '')
            .join(' ');
        expect(dialogos, contains('Sancho I'));
        expect(dialogos, contains('García Sánchez I'));
        expect(dialogos, contains('Sancho II'));
        expect(dialogos, contains('García Sánchez II'));
        expect(acotaciones, contains('cripta románica'));
        expect(acotaciones, contains('s. XI'));
      },
    );
  });

  group('EscenasArco3.laLeyendaDeVirila (3.3.3)', () {
    test('viaja con ambiente scriptoriumLeyre', () {
      expect(
        EscenasArco3.laLeyendaDeVirila.ambiente,
        same(AmbienteArchivo.scriptoriumLeyre),
      );
    });

    test(
      'la voz monjeLeyre articula la revelación clave: leyenda en '
      'códice del s. XIII, Virila histórico s. IX o principios del X',
      () {
        final dialogosMonje = EscenasArco3.laLeyendaDeVirila.planos
            .whereType<PlanoDialogo>()
            .where((p) => p.voz == VozPersonaje.monjeLeyre)
            .map((p) => p.texto)
            .join(' ');
        expect(dialogosMonje, contains('s. IX'));
        expect(dialogosMonje, contains('XIII'));
      },
    );

    test(
      'cierra con la pregunta abierta del monje "Esa es la pregunta '
      'para vosotras" — pasaje del oficio',
      () {
        final dialogos = EscenasArco3.laLeyendaDeVirila.planos
            .whereType<PlanoDialogo>()
            .map((p) => p.texto)
            .join(' ');
        expect(dialogos, contains('Esa es la pregunta para vosotras'));
      },
    );
  });

  group('EscenasArco3.cuandoSeEscribio (3.3.4)', () {
    test(
      'la voz del Cuaderno articula la lección PH.10: la leyenda no '
      'cuenta el s. IX, cuenta cómo Leyre del s. XIII se sentía '
      'mirando al s. IX',
      () {
        final dialogosCuaderno = EscenasArco3.cuandoSeEscribio.planos
            .whereType<PlanoDialogo>()
            .where((p) => p.voz == VozPersonaje.vozDeFuente)
            .map((p) => p.texto)
            .join(' ');
        expect(dialogosCuaderno, contains('declive'));
        expect(dialogosCuaderno, contains('cluniacense'));
        expect(
          dialogosCuaderno,
          contains('cómo Leyre del s. XIII se sentía'),
        );
      },
    );

    test(
      'la Cronista produce 6 afirmaciones (3 Sólido + 3 Probable)',
      () {
        final acotaciones = EscenasArco3.cuandoSeEscribio.planos
            .whereType<PlanoAmbiente>()
            .map((p) => p.textoLectura ?? '')
            .join(' ');
        expect(acotaciones, contains('6 afirmaciones'));
        expect(acotaciones, contains('1.'));
        expect(acotaciones, contains('6.'));
      },
    );
  });

  group('EscenasArco3.concilioLeyre (3.3.5)', () {
    test('ambiente = salonConcilio', () {
      expect(
        EscenasArco3.concilioLeyre.ambiente,
        same(AmbienteArchivo.salonConcilio),
      );
    });

    test(
      'Joana cuestiona la afirmación 5 (cifra "trescientos años") '
      'como interpretativa, Maren la mantiene Probable y Aitor sella',
      () {
        final dialogos = EscenasArco3.concilioLeyre.planos
            .whereType<PlanoDialogo>()
            .map((p) => p.texto)
            .join(' ');
        expect(dialogos, contains('interpretativa'));
        expect(dialogos, contains('Probable'));
        expect(dialogos, contains('Sellada'));
        expect(dialogos, contains('paralelos'));
      },
    );
  });

  group('EscenasArco3.laLeyendaNoMienteDesplaza (3.3.6)', () {
    test(
      'la voz del Cuaderno cierra con la lección PH.10: las leyendas '
      'no mienten, desplazan',
      () {
        final dialogos = EscenasArco3.laLeyendaNoMienteDesplaza.planos
            .whereType<PlanoDialogo>()
            .map((p) => p.texto)
            .join(' ');
        expect(dialogos, contains('Las leyendas no mienten. Desplazan'));
        expect(dialogos, contains('escuchando el silencio'));
      },
    );

    test(
      'al cerrar la escena se activa arco_3_estacion_3_cerrada — '
      'desbloquea la 3.C.1 latente con Naia',
      () {
        expect(
          EscenasArco3.flagsDeCierrePorEscena['escena_3_3_6_vista'],
          contains('arco_3_estacion_3_cerrada'),
        );
      },
    );
  });

  group('EscenasArco3.naiaPreguntaOtraVez (3.C.1)', () {
    test(
      'precondición = arco_3_estacion_3_cerrada — la 3.3.6 lo activa',
      () {
        expect(
          EscenasArco3.naiaPreguntaOtraVez.flagsRequeridos,
          {'arco_3_estacion_3_cerrada'},
        );
      },
    );

    test(
      'la voz de Naia plantea la pregunta de oficio que abre PH.10 '
      'al lenguaje contemporáneo: las películas también son sobre el '
      'momento en que se hacen',
      () {
        final dialogos = EscenasArco3.naiaPreguntaOtraVez.planos
            .whereType<PlanoDialogo>()
            .map((p) => p.texto)
            .join(' ');
        expect(dialogos, contains('películas'));
        expect(dialogos, contains('momento en que se hacen'));
      },
    );

    test(
      'cierra con el voto de Maren "Voy a guardar el papel toda mi '
      'vida" — articula el reconocimiento del oficio en su hermana',
      () {
        final dialogos = EscenasArco3.naiaPreguntaOtraVez.planos
            .whereType<PlanoDialogo>()
            .map((p) => p.texto)
            .join(' ');
        expect(
          dialogos,
          contains('hermana de ocho años acaba de hacerme una pregunta'),
        );
        expect(dialogos, contains('guardar el papel toda mi vida'));
      },
    );
  });

  group('EscenasArco3.todas', () {
    test(
      'catálogo cubre apertura (3.0.x) + Estación 3.1 completa + '
      'latente 3.A.1 + Estación 3.2 completa (3.2.1 a 3.2.8) + '
      'latente 3.B.1 + Estación 3.3 completa (3.3.1 a 3.3.6) + '
      'latente 3.C.1 — 24 cinemáticas implementadas',
      () {
        expect(EscenasArco3.todas, hasLength(24));
        expect(
          EscenasArco3.todas.map((escena) => escena.id).toList(),
          [
            '3.0.1',
            '3.0.2',
            '3.1.1',
            '3.1.2',
            '3.1.3',
            '3.1.4',
            '3.1.5',
            '3.A.1',
            '3.2.1',
            '3.2.2',
            '3.2.3',
            '3.2.4',
            '3.2.5',
            '3.2.6',
            '3.2.7',
            '3.2.8',
            '3.B.1',
            '3.3.1',
            '3.3.2',
            '3.3.3',
            '3.3.4',
            '3.3.5',
            '3.3.6',
            '3.C.1',
          ],
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
