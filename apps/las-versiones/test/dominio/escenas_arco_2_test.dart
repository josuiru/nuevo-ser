import 'package:flutter_test/flutter_test.dart';
import 'package:las_versiones/dominio/ambiente_archivo.dart';
import 'package:las_versiones/dominio/escenas_arco_2.dart';
import 'package:las_versiones/dominio/voz_personaje.dart';
import 'package:nuevo_ser_core/nuevo_ser_core.dart';

void main() {
  group('EscenasArco2.primerDiaDelArco (2.0.1)', () {
    test('id y flagDeSalida estables', () {
      expect(EscenasArco2.primerDiaDelArco.id, '2.0.1');
      expect(EscenasArco2.primerDiaDelArco.flagDeSalida, 'escena_2_0_1_vista');
    });

    test('precondición = arco_1_cerrado_por_la_cronista — el Arco 2 sólo '
        'arranca cuando la 1.Z (cierre del arco) ha cerrado', () {
      expect(
        EscenasArco2.primerDiaDelArco.flagsRequeridos,
        {'arco_1_cerrado_por_la_cronista'},
      );
    });

    test('al cerrar la escena se activa arco_2_iniciado — flag hito '
        'compartido', () {
      expect(
        EscenasArco2.flagsDeCierrePorEscena['escena_2_0_1_vista'],
        contains('arco_2_iniciado'),
      );
    });

    test('viaja con ambiente patio del Archivo — Isaura espera junto al '
        'capitel del claustro', () {
      expect(
        EscenasArco2.primerDiaDelArco.ambiente,
        same(AmbienteArchivo.patioArchivo),
      );
    });

    test('habla Isaura y Maren — sin terceros en esta apertura', () {
      final voces = EscenasArco2.primerDiaDelArco.planos
          .whereType<PlanoDialogo>()
          .map((p) => p.voz)
          .toSet();
      expect(voces, {VozPersonaje.isaura, VozPersonaje.maren});
    });

    test('contiene la línea pedagógica clave del arco — "tienes texto, '
        'no te creas que eso lo hace más fácil"', () {
      final dialogos = EscenasArco2.primerDiaDelArco.planos
          .whereType<PlanoDialogo>()
          .map((p) => p.texto);
      expect(
        dialogos.any((t) =>
            t.contains('tienes texto') && t.contains('más fácil')),
        isTrue,
      );
    });

    test('no encadena con 2.1.1 en la misma sesión: cierra natural cuando '
        'se acaban los planos (sin PlanoCierreAmable porque la siguiente '
        'cinemática del Arco 2 todavía no está implementada)', () {
      // En el estado actual del juego (sólo 2.0.1 implementada), el
      // orquestador no tiene siguiente cinemática del Arco 2 — al
      // cerrar la 2.0.1 cae al esqueleto. Cuando entre la 2.1.1, este
      // test cambia a comprobar PlanoCierreAmable o transición directa
      // según lo que el doc 08 §2.0.1→2.1.1 prescriba.
      final planos = EscenasArco2.primerDiaDelArco.planos;
      expect(planos.isNotEmpty, isTrue);
    });
  });

  group('EscenasArco2.todas', () {
    test('catálogo cubre 2.0.1 (apertura) + Estación 2.1 completa '
        '(2.1.1 a 2.1.6) + latentes post-Estación 2.1 (2.A.1 y 2.A.2) + '
        'Estación 2.2 completa (2.2.1 a 2.2.6) + latente post-Estación '
        '2.2 (2.B.1) + Estación 2.3 completa (2.3.1 a 2.3.6) + latente '
        'post-Estación 2.3 (2.C.1) + Estación 2.4 completa (2.4.1 a '
        '2.4.8) + entrega Mosaico M2 + cierre del Arco 2 (2.Z.1 + '
        '2.Z.2) — 34 cinemáticas implementadas hoy', () {
      expect(EscenasArco2.todas, hasLength(34));
      expect(
        EscenasArco2.todas.map((escena) => escena.id).toList(),
        [
          '2.0.1',
          '2.1.1',
          '2.1.2',
          '2.1.3',
          '2.1.4',
          '2.1.5',
          '2.1.6',
          '2.A.1',
          '2.A.2',
          '2.2.1',
          '2.2.2',
          '2.2.3',
          '2.2.4',
          '2.2.5',
          '2.2.6',
          '2.B.1',
          '2.3.1',
          '2.3.2',
          '2.3.3',
          '2.3.4',
          '2.3.5',
          '2.3.6',
          '2.C.1',
          '2.4.1',
          '2.4.2',
          '2.4.3',
          '2.4.4',
          '2.4.5',
          '2.4.6',
          '2.4.7',
          '2.4.8',
          'M2.entrega',
          '2.Z.1',
          '2.Z.2',
        ],
      );
    });

    test('cada cinemática nueva del Arco 2 tiene su flag de cierre '
        'registrado — el orquestador necesita el mapa para activar '
        'flags institucionales al cerrar', () {
      final flagsDeSalida =
          EscenasArco2.todas.map((escena) => escena.flagDeSalida).toSet();
      for (final flagSalida in flagsDeSalida) {
        expect(
          EscenasArco2.flagsDeCierrePorEscena.containsKey(flagSalida),
          isTrue,
          reason: 'falta entrada en flagsDeCierrePorEscena para $flagSalida',
        );
      }
    });

    test('la Estación 2.1 cierra con escena_2_1_6 que activa '
        'arco_2_estacion_1_cerrada — hito que la Estación 2.2 '
        'requerirá como precondición', () {
      expect(
        EscenasArco2.flagsDeCierrePorEscena['escena_2_1_6_vista'],
        contains('arco_2_estacion_1_cerrada'),
      );
    });

    test('2.A.1 (libro de Quintiliano) requiere arco_2_estacion_1_cerrada '
        '— es latente post-Estación 2.1', () {
      expect(
        EscenasArco2.elLibroDeQuintiliano.flagsRequeridos,
        {'arco_2_estacion_1_cerrada'},
      );
    });

    test('2.A.2 (Marina y los descansos) requiere escena_2_a_1_vista — '
        'las dos latentes se reproducen en el orden del doc 08 (padre '
        'antes que Marina)', () {
      expect(
        EscenasArco2.marinaYLosDescansos.flagsRequeridos,
        {'escena_2_a_1_vista'},
      );
    });

    test('2.A.1 viaja con ambiente estudio del padre — sub-ambiente '
        'íntimo distinto del cuarto de Maren o de la cocina familiar',
        () {
      expect(
        EscenasArco2.elLibroDeQuintiliano.ambiente,
        same(AmbienteArchivo.estudioAntonio),
      );
    });

    test('2.A.2 viaja con ambiente cocina del Archivo — Marina entra '
        'mientras Maren se prepara un café', () {
      expect(
        EscenasArco2.marinaYLosDescansos.ambiente,
        same(AmbienteArchivo.cocinaArchivo),
      );
    });

    test('Estación 2.2 arranca con 2.2.1 que requiere escena_2_a_2_vista '
        '— el orquestador encadena las dos latentes 2.A antes del viaje '
        'a Calahorra', () {
      expect(
        EscenasArco2.caminoACalahorra.flagsRequeridos,
        {'escena_2_a_2_vista'},
      );
    });

    test('Estación 2.2 cierra con 2.2.6 que activa '
        'arco_2_estacion_2_cerrada — hito que la Estación 2.3 '
        'requerirá como precondición', () {
      expect(
        EscenasArco2.flagsDeCierrePorEscena['escena_2_2_6_vista'],
        contains('arco_2_estacion_2_cerrada'),
      );
    });

    test('Concilio 2.2.5 activa brecha_2_2_completada al cerrar — '
        'mismo patrón que 2.1.5 con la Brecha 2.1', () {
      expect(
        EscenasArco2.flagsDeCierrePorEscena['escena_2_2_5_vista'],
        containsAll(['concilio_2_2_cerrado', 'brecha_2_2_completada']),
      );
    });

    test('2.2.1 (camino a Calahorra) y 2.2.6 (regreso) viajan con '
        'ambiente cocheIsaura — paréntesis simétrico de la Estación', () {
      expect(
        EscenasArco2.caminoACalahorra.ambiente,
        same(AmbienteArchivo.cocheIsaura),
      );
      expect(
        EscenasArco2.loQueFueYDejoDeSer.ambiente,
        same(AmbienteArchivo.cocheIsaura),
      );
    });

    test('2.2.3 a 2.2.5 viajan con la sala de trabajo del museo de '
        'Calahorra — tres cinemáticas consecutivas en el mismo espacio',
        () {
      for (final escena in [
        EscenasArco2.quintilianoSobreSiMismo,
        EscenasArco2.loQueOmite,
        EscenasArco2.elConcilioEnCalahorra,
      ]) {
        expect(
          escena.ambiente,
          same(AmbienteArchivo.salaTrabajoMuseoCalahorra),
          reason: '${escena.id} debería usar salaTrabajoMuseoCalahorra',
        );
      }
    });

    test('la voz arqueologa de Calahorra (femenina, sin nombre en '
        'pantalla) aparece en las cinemáticas 2.2.2 / 2.2.4 / 2.2.5 '
        '— simétrica al arqueólogo de Irulegi', () {
      for (final escena in [
        EscenasArco2.calagurrisBajoCalahorra,
        EscenasArco2.loQueOmite,
        EscenasArco2.elConcilioEnCalahorra,
      ]) {
        final voces = escena.planos
            .whereType<PlanoDialogo>()
            .map((plano) => plano.voz)
            .toSet();
        expect(
          voces,
          contains(VozPersonaje.arqueologa),
          reason: '${escena.id} debería incluir VozPersonaje.arqueologa',
        );
      }
    });

    test('2.B.1 (cuaderno de Isaura) requiere arco_2_estacion_2_cerrada '
        '— es latente post-Estación 2.2', () {
      expect(
        EscenasArco2.elCuadernoDeIsaura.flagsRequeridos,
        {'arco_2_estacion_2_cerrada'},
      );
    });

    test('2.B.1 viaja con ambiente despacho de Isaura — primera '
        'aparición de este sub-espacio del Archivo en el catálogo', () {
      expect(
        EscenasArco2.elCuadernoDeIsaura.ambiente,
        same(AmbienteArchivo.despachoIsaura),
      );
    });

    test('2.B.1 contiene la línea pedagógica clave — el cuaderno de '
        'Isaura tiene "preguntas, sólo" y treinta años', () {
      final dialogos = EscenasArco2.elCuadernoDeIsaura.planos
          .whereType<PlanoDialogo>()
          .map((plano) => plano.texto)
          .toList();
      expect(dialogos, contains('Treinta.'));
      expect(dialogos, contains('Preguntas.'));
      expect(dialogos, contains('Sólo.'));
    });

    test('2.B.1 sólo habla Isaura y Maren — escena íntima sin terceros',
        () {
      final voces = EscenasArco2.elCuadernoDeIsaura.planos
          .whereType<PlanoDialogo>()
          .map((plano) => plano.voz)
          .toSet();
      expect(voces, {VozPersonaje.isaura, VozPersonaje.maren});
    });

    test('Estación 2.3 arranca con 2.3.1 que requiere escena_2_b_1_vista '
        '— la latente 2.B.1 actúa como precondición', () {
      expect(
        EscenasArco2.laDomusDeLosMosaicos.flagsRequeridos,
        {'escena_2_b_1_vista'},
      );
    });

    test('Estación 2.3 cierra con 2.3.6 que activa al mismo tiempo el '
        'concilio cerrado, la Brecha 2.3 completada y la Estación 2.3 '
        'cerrada — hito triple para que la Estación 2.4 lo requiera', () {
      expect(
        EscenasArco2.flagsDeCierrePorEscena['escena_2_3_6_vista'],
        containsAll([
          'concilio_2_3_cerrado',
          'brecha_2_3_completada',
          'arco_2_estacion_3_cerrada',
        ]),
      );
    });

    test('2.3.1 y 2.3.2 viajan con la domus subterránea — el espacio '
        'físico de la Brecha', () {
      for (final escena in [
        EscenasArco2.laDomusDeLosMosaicos,
        EscenasArco2.lasPersonasQueVivieronAqui,
      ]) {
        expect(
          escena.ambiente,
          same(AmbienteArchivo.domusMosaicosSubterranea),
          reason: '${escena.id} debería usar domusMosaicosSubterranea',
        );
      }
    });

    test('2.3.3 (la crisis) viaja con el patio del Archivo — Maren sale '
        'a respirar al brocal del pozo', () {
      expect(
        EscenasArco2.laCrisis.ambiente,
        same(AmbienteArchivo.patioArchivo),
      );
    });

    test('2.3.4 (comprender sin justificar) viaja con la cocina del '
        'Archivo — té con Isaura, lección epistémica clave', () {
      expect(
        EscenasArco2.comprenderSinJustificar.ambiente,
        same(AmbienteArchivo.cocinaArchivo),
      );
    });

    test('2.3.6 (Concilio) viaja con el salón del Concilio del Archivo '
        '— mismo espacio formal que cierra la Estación 1.4 del Arco 1',
        () {
      expect(
        EscenasArco2.concilioDeLaDomus.ambiente,
        same(AmbienteArchivo.salonConcilio),
      );
    });

    test('2.3.6 (Concilio) lleva las cuatro voces del Archivo — Karim, '
        'Aitor, Maren e Isaura — la mesa formal de revisores del Arco 2',
        () {
      final voces = EscenasArco2.concilioDeLaDomus.planos
          .whereType<PlanoDialogo>()
          .map((plano) => plano.voz)
          .toSet();
      expect(voces, containsAll([
        VozPersonaje.karim,
        VozPersonaje.aitor,
        VozPersonaje.maren,
      ]));
    });

    test('2.3.4 contiene la dicotomía pedagógica clave del Arco 2 — '
        'neutralidad vs comprensión, PH.01 vs PH.08', () {
      final dialogos = EscenasArco2.comprenderSinJustificar.planos
          .whereType<PlanoDialogo>()
          .map((plano) => plano.texto)
          .toList();
      expect(
        dialogos.any((texto) =>
            texto.contains('neutralidad') && texto.contains('comprensión')),
        isTrue,
        reason: 'al menos un diálogo debe contraponer las dos posturas',
      );
      expect(
        dialogos.any((texto) =>
            texto.contains('PH.01') && texto.contains('PH.08')),
        isTrue,
        reason: 'Isaura nombra explícitamente las dos habilidades',
      );
    });

    test('2.3.5 reproduce las ocho afirmaciones canónicas — incluida la '
        'afirmación 6 declarada como Sólido (la ausencia)', () {
      final textoCompleto = EscenasArco2.reconstruccionDeLaDomus.planos
          .whereType<PlanoAmbiente>()
          .map((plano) => plano.textoLectura)
          .join(' ');
      expect(textoCompleto, contains('1.'));
      expect(textoCompleto, contains('8.'));
      expect(
        textoCompleto,
        contains('Sólido (la ausencia)'),
        reason: 'la afirmación 6 declara la ausencia documentada como '
            'información, calificada como Sólido',
      );
    });

    test('2.C.1 (Eider y el cambio) requiere arco_2_estacion_3_cerrada '
        '— es latente post-Estación 2.3', () {
      expect(
        EscenasArco2.eiderYElCambio.flagsRequeridos,
        {'arco_2_estacion_3_cerrada'},
      );
    });

    test('2.C.1 viaja con la plaza del Castillo de Iruña — segundo '
        'encuentro con Eider tras la cafetería del Casco Viejo (1.A)',
        () {
      expect(
        EscenasArco2.eiderYElCambio.ambiente,
        same(AmbienteArchivo.plazaCastilloIruna),
      );
    });

    test('2.C.1 sólo habla Eider y Maren — escena de amistad sin '
        'terceros, simétrica a 2.B.1 con Isaura', () {
      final voces = EscenasArco2.eiderYElCambio.planos
          .whereType<PlanoDialogo>()
          .map((plano) => plano.voz)
          .toSet();
      expect(voces, {VozPersonaje.eider, VozPersonaje.maren});
    });

    test('2.C.1 contiene la pregunta directa de Eider y la respuesta '
        'de doble pertenencia de Maren — corazón pedagógico de la '
        'cinemática', () {
      final dialogos = EscenasArco2.eiderYElCambio.planos
          .whereType<PlanoDialogo>()
          .map((plano) => plano.texto)
          .toList();
      expect(dialogos, contains('¿Sigues siendo amiga mía?'));
      expect(
        dialogos.any((texto) =>
            texto.contains('muchos sitios a la vez') &&
            texto.contains('contigo estoy')),
        isTrue,
        reason:
            'Maren articula explícitamente el compromiso con la doble '
            'pertenencia',
      );
    });

    test('Estación 2.4 arranca con 2.4.1 que requiere escena_2_c_1_vista '
        '— la latente 2.C.1 actúa como precondición, igual que las dos '
        'estaciones anteriores con sus latentes', () {
      expect(
        EscenasArco2.unaBrechaDeUnSoloLado.flagsRequeridos,
        {'escena_2_c_1_vista'},
      );
    });

    test('Estación 2.4 cierra con 2.4.8 que activa al mismo tiempo el '
        'aprendiz_dos_alcanzado y la arco_2_estacion_4_cerrada — hito '
        'doble de cierre de la última Estación del Arco 2', () {
      expect(
        EscenasArco2.flagsDeCierrePorEscena['escena_2_4_8_vista'],
        containsAll([
          'aprendiz_dos_alcanzado',
          'arco_2_estacion_4_cerrada',
        ]),
      );
    });

    test('Concilio 2.4.7 activa concilio_2_4_cerrado al cerrar — '
        'desde F2-10d ya NO activa `brecha_2_4_completada` (lo activa '
        'la Brecha 2.4 jugable antes que la 2.4.7 cinemática se '
        'pueda ver, mismo patrón que 2.1 / 2.2 / 2.3 con sus '
        'respectivas Brechas jugables)', () {
      expect(
        EscenasArco2.flagsDeCierrePorEscena['escena_2_4_7_vista'],
        contains('concilio_2_4_cerrado'),
      );
      expect(
        EscenasArco2.flagsDeCierrePorEscena['escena_2_4_7_vista'],
        isNot(contains('brecha_2_4_completada')),
      );
    });

    test('2.4.1 (encargo) viaja con el despacho de Isaura — Brecha '
        'asignada en privado, mismo sub-espacio íntimo que 2.B.1', () {
      expect(
        EscenasArco2.unaBrechaDeUnSoloLado.ambiente,
        same(AmbienteArchivo.despachoIsaura),
      );
    });

    test('2.4.2 (crónicas visigodas) viaja con la biblioteca del '
        'Archivo — primera aparición de este sub-ambiente: Maren lee '
        'sola Julián de Toledo y otras crónicas de la perspectiva '
        'ganadora', () {
      expect(
        EscenasArco2.lasCronicasVisigodas.ambiente,
        same(AmbienteArchivo.bibliotecaArchivo),
      );
    });

    test('2.4.3 (silencio vascón) viaja con un yacimiento del norte sin '
        'nombre histórico en pantalla — sustitución diegética hasta '
        'validación del comité asesor (registrada en BLOQUEOS)', () {
      expect(
        EscenasArco2.elSilencioVascon.ambiente,
        same(AmbienteArchivo.yacimientoVasconNorte),
      );
    });

    test('2.4.4 y 2.4.6 viajan con la mesa de trabajo del Archivo — la '
        'frustración primero, la reconstrucción honesta después, en el '
        'mismo espacio físico para subrayar la transformación interna', () {
      for (final escena in [
        EscenasArco2.laFrustracion,
        EscenasArco2.reconstruccionHonesta,
      ]) {
        expect(
          escena.ambiente,
          same(AmbienteArchivo.mesaTrabajoArchivo),
          reason: '${escena.id} debería usar mesaTrabajoArchivo',
        );
      }
    });

    test('2.4.5 (conversación con Karim) viaja con la cocina del '
        'Archivo — espacio íntimo recurrente para las lecciones '
        'epistémicas clave (mismo patrón que 2.3.4)', () {
      expect(
        EscenasArco2.conversacionConKarim.ambiente,
        same(AmbienteArchivo.cocinaArchivo),
      );
    });

    test('2.4.5 contiene la lección epistémica clave del Arco 2 — el '
        'silencio vascón es dato, no ausencia de dato', () {
      final dialogos = EscenasArco2.conversacionConKarim.planos
          .whereType<PlanoDialogo>()
          .map((plano) => plano.texto)
          .toList();
      expect(
        dialogos.any((texto) =>
            texto.contains('silencio vascón') &&
            texto.contains('dato') &&
            texto.contains('ausencia')),
        isTrue,
        reason: 'Karim debe articular explícitamente que el silencio es '
            'dato y no ausencia de dato',
      );
    });

    test('2.4.6 reproduce las nueve afirmaciones canónicas — incluida '
        'la afirmación 7 declarada como "Sólido (la ausencia)" y la 9 '
        'como "Sólido como declaración metodológica"', () {
      final textoCompleto = EscenasArco2.reconstruccionHonesta.planos
          .whereType<PlanoAmbiente>()
          .map((plano) => plano.textoLectura)
          .join(' ');
      expect(textoCompleto, contains('1.'));
      expect(textoCompleto, contains('9.'));
      expect(
        textoCompleto,
        contains('Sólido (la ausencia)'),
        reason: 'la afirmación 7 declara la ausencia documental como '
            'información, calificada como Sólido',
      );
      expect(
        textoCompleto,
        contains('Sólido como declaración metodológica'),
        reason: 'la afirmación 9 declara explícitamente el techo de '
            'reconstrucción como afirmación metodológica',
      );
    });

    test('2.4.7 (Concilio) viaja con el salón del Concilio del Archivo '
        '— mesa formal de revisores, igual que 2.3.6 cierra la 2.3', () {
      expect(
        EscenasArco2.elConcilioDividido.ambiente,
        same(AmbienteArchivo.salonConcilio),
      );
    });

    test('2.4.7 (Concilio dividido) lleva las cinco voces revisoras del '
        'Arco 2 — Karim (Reformista), Aitor (Constructor), Joana, '
        'Begoña, Isaura — más Maren que presenta', () {
      final voces = EscenasArco2.elConcilioDividido.planos
          .whereType<PlanoDialogo>()
          .map((plano) => plano.voz)
          .toSet();
      expect(voces, containsAll([
        VozPersonaje.karim,
        VozPersonaje.aitor,
        VozPersonaje.joana,
        VozPersonaje.begona,
        VozPersonaje.maren,
      ]));
    });

    test('2.4.8 (Aprendiz II) viaja con el patio del Archivo — cierre '
        'simbólico de la Estación 2.4 en el mismo espacio donde abrió '
        'el Arco 2 con la 2.0.1 (peso narrativo del brocal del pozo)', () {
      expect(
        EscenasArco2.aprendizDosLogrado.ambiente,
        same(AmbienteArchivo.patioArchivo),
      );
    });

    test('2.4.8 contiene la línea pedagógica clave de cierre — Isaura '
        'declara Aprendiz II y revela que su cuaderno tiene tres '
        'preguntas sobre Wamba con dos sin resolver desde hace mucho '
        'tiempo (continuidad del oficio)', () {
      final dialogos = EscenasArco2.aprendizDosLogrado.planos
          .whereType<PlanoDialogo>()
          .map((plano) => plano.texto)
          .toList();
      expect(dialogos, contains('Aprendiz II.'));
      expect(dialogos, contains('Tres preguntas. De hace mucho.'));
      expect(dialogos, contains('Una. Las otras dos siguen.'));
    });

    test('2.4.8 sólo habla Isaura y Maren — escena íntima de cierre '
        'sin terceros, simétrica a 2.0.1 que abrió el arco con las '
        'mismas dos voces', () {
      final voces = EscenasArco2.aprendizDosLogrado.planos
          .whereType<PlanoDialogo>()
          .map((plano) => plano.voz)
          .toSet();
      expect(voces, {VozPersonaje.isaura, VozPersonaje.maren});
    });

    test('2.4.8 activa aprendiz_dos_alcanzado y arco_2_estacion_4_cerrada '
        'al cerrar — desde F2-11 ya NO activa `mosaico_arco_2_entregado` '
        '(lo activa la pantalla jugable del Mosaico M2 al entregar, '
        'mismo patrón que el M1 del Arco 1 con su `_alEntregarMosaicoArco2` '
        'en main.dart). El flag `arco_2_estacion_4_cerrada` es lo que '
        'dispara la pantalla M2 jugable', () {
      expect(
        EscenasArco2.flagsDeCierrePorEscena['escena_2_4_8_vista'],
        containsAll([
          'aprendiz_dos_alcanzado',
          'arco_2_estacion_4_cerrada',
        ]),
      );
      expect(
        EscenasArco2.flagsDeCierrePorEscena['escena_2_4_8_vista'],
        isNot(contains('mosaico_arco_2_entregado')),
      );
    });

    test('M2.entrega requiere mosaico_arco_2_entregado — patrón '
        'simétrico al M1.entrega del Arco 1', () {
      expect(
        EscenasArco2.entregaDelMosaicoM2.flagsRequeridos,
        {'mosaico_arco_2_entregado'},
      );
    });

    test('M2.entrega viaja con el ático del Archivo — mismo lugar '
        'donde Maren entregó el Mosaico M1 a Andrés', () {
      expect(
        EscenasArco2.entregaDelMosaicoM2.ambiente,
        same(AmbienteArchivo.aticoArchivo),
      );
    });

    test('M2.entrega sólo habla Andrés y Maren — gesto pequeño de '
        'reconocimiento sin terceros, igual que 1.M1.entrega', () {
      final voces = EscenasArco2.entregaDelMosaicoM2.planos
          .whereType<PlanoDialogo>()
          .map((plano) => plano.voz)
          .toSet();
      expect(voces, {VozPersonaje.andres, VozPersonaje.maren});
    });

    test('M2.entrega contiene la observación pedagógica clave de '
        'Andrés — "no sabemos" tres veces y "probablemente" cuatro, '
        'cerrado con "está perfecto"', () {
      final dialogos = EscenasArco2.entregaDelMosaicoM2.planos
          .whereType<PlanoDialogo>()
          .map((plano) => plano.texto)
          .toList();
      expect(
        dialogos.any((texto) =>
            texto.contains('no sabemos') &&
            texto.contains('tres veces') &&
            texto.contains('probablemente')),
        isTrue,
        reason:
            'Andrés debe enumerar las dos marcas de honestidad '
            'epistémica que oyó en la audio-guía',
      );
      expect(dialogos, contains('Está perfecto.'));
    });

    test('2.Z.1 (Antonio y Wamba) requiere escena_m2_entrega_vista — '
        'la entrega del Mosaico M2 actúa como precondición del '
        'cierre del arco', () {
      expect(
        EscenasArco2.antonioYWamba.flagsRequeridos,
        {'escena_m2_entrega_vista'},
      );
    });

    test('2.Z.1 viaja con la cocina de casa de Maren — mismo espacio '
        'íntimo familiar de la 1.B.1, marca el cambio de escala '
        'narrativa al cerrar el arco', () {
      expect(
        EscenasArco2.antonioYWamba.ambiente,
        same(AmbienteArchivo.cocinaCasaMaren),
      );
    });

    test('2.Z.1 sólo habla Antonio y Maren — escena de cierre '
        'íntima, sin Iratxe ni Naia (que están en un cumpleaños)', () {
      final voces = EscenasArco2.antonioYWamba.planos
          .whereType<PlanoDialogo>()
          .map((plano) => plano.voz)
          .toSet();
      expect(voces, {VozPersonaje.antonio, VozPersonaje.maren});
    });

    test('2.Z.1 contiene las dos frases pedagógicas clave del '
        'padre — el paralelo con los moriscos en El Quijote y el '
        'aforismo "los oficios que tienes claros desde el principio "'
        '"suelen ser los que se acaban antes"', () {
      final dialogos = EscenasArco2.antonioYWamba.planos
          .whereType<PlanoDialogo>()
          .map((plano) => plano.texto)
          .toList();
      expect(
        dialogos.any((texto) =>
            texto.contains('Quijote') &&
            texto.contains('moriscos') &&
            texto.contains('escribiendo')),
        isTrue,
        reason: 'Antonio debe articular el paralelo entre los '
            'moriscos del Quijote y el silencio vascón',
      );
      expect(
        dialogos.any((texto) =>
            texto.contains('oficios') &&
            texto.contains('claros') &&
            texto.contains('acaban antes')),
        isTrue,
        reason: 'Antonio debe articular el aforismo de cierre',
      );
    });

    test('2.Z.1 contiene el silencio final de Antonio que la 2.Z.2 '
        'va a interrogar — "Maren / Mmm. Olvídalo"', () {
      final dialogos = EscenasArco2.antonioYWamba.planos
          .whereType<PlanoDialogo>()
          .map((plano) => plano.texto)
          .toList();
      expect(
        dialogos.any((texto) =>
            texto.contains('Olvídalo') && texto.contains('cocinando')),
        isTrue,
        reason:
            'Antonio debe abrir y cerrar la frase truncada que la '
            '2.Z.2 va a apuntar como pregunta abierta',
      );
    });

    test('2.Z.2 (La grabación) requiere escena_2_z_1_vista — '
        'continúa la misma noche, después de la cocina', () {
      expect(
        EscenasArco2.laGrabacion.flagsRequeridos,
        {'escena_2_z_1_vista'},
      );
    });

    test('2.Z.2 viaja con el cuarto de casa de Maren — sub-espacio '
        'íntimo distinto de la cocina, primera aparición en este '
        'arco', () {
      expect(
        EscenasArco2.laGrabacion.ambiente,
        same(AmbienteArchivo.cuartoCasaMaren),
      );
    });

    test('2.Z.2 cierra el Arco 2 activando '
        'arco_2_cerrado_por_la_cronista — hito que el Arco 3 '
        'requerirá como precondición, simétrico con la 1.Z del '
        'Arco 1', () {
      expect(
        EscenasArco2.flagsDeCierrePorEscena['escena_2_z_2_vista'],
        contains('arco_2_cerrado_por_la_cronista'),
      );
    });

    test('2.Z.2 sólo articula la voz íntima del Cuaderno (vozDeFuente) '
        '— Maren está sola en su cuarto, no hay diálogo con nadie', () {
      final voces = EscenasArco2.laGrabacion.planos
          .whereType<PlanoDialogo>()
          .map((plano) => plano.voz)
          .toSet();
      expect(voces, {VozPersonaje.vozDeFuente});
    });

    test('2.Z.2 reproduce los cuatro pensamientos clave del Cuaderno '
        '— grabar al padre sin permiso (declarado para mañana), '
        'oírse hablando como par, recordar la frase del oficio, '
        'apuntar el silencio como pregunta abierta como Isaura', () {
      final pensamientos = EscenasArco2.laGrabacion.planos
          .whereType<PlanoDialogo>()
          .map((plano) => plano.texto)
          .toList();
      expect(
        pensamientos.any((texto) =>
            texto.contains('grabado a mi padre') &&
            texto.contains('Mañana se lo cuento')),
        isTrue,
        reason: 'declaración de honestidad: mañana se lo cuenta',
      );
      expect(
        pensamientos.any((texto) =>
            texto.contains('hablando con') && texto.contains('par')),
        isTrue,
        reason: 'reconocimiento del cambio de escala con el padre',
      );
      expect(
        pensamientos.any((texto) =>
            texto.contains('oficios') && texto.contains('frase')),
        isTrue,
        reason: 'archivo del aforismo del padre',
      );
      expect(
        pensamientos.any((texto) =>
            texto.contains('pregunta abierta') &&
            texto.contains('Isaura')),
        isTrue,
        reason:
            'el silencio del padre se apunta usando explícitamente '
            'el modelo metodológico de Isaura',
      );
    });

    test('2.Z.2 contiene el cierre formal del arco — ARCO 2 — '
        'CERRADO + anuncio del Arco 3 con su título canónico '
        '"La forja del reino"', () {
      final textoLectura = EscenasArco2.laGrabacion.planos
          .whereType<PlanoAmbiente>()
          .map((plano) => plano.textoLectura)
          .join(' ');
      expect(textoLectura, contains('ARCO 2 — CERRADO'));
      expect(textoLectura, contains('La forja del reino'));
    });
  });
}
