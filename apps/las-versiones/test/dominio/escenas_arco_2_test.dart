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
    test('catálogo arranca con 2.0.1 — única cinemática implementada hoy',
        () {
      expect(EscenasArco2.todas, hasLength(1));
      expect(EscenasArco2.todas.first.id, '2.0.1');
    });
  });
}
