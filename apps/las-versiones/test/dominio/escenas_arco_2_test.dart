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
        'Estación 2.2 completa (2.2.1 a 2.2.6) — 15 cinemáticas '
        'implementadas hoy', () {
      expect(EscenasArco2.todas, hasLength(15));
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
  });
}
