import 'package:flutter_test/flutter_test.dart';
import 'package:las_versiones/dominio/mosaico_arco_2.dart';

void main() {
  group('MosaicoArco2 — metadata estable', () {
    test('idArco "arco_2" — conviene el endpoint companion '
        '`/companion/mosaicos` cuando se cablee en F2-12 con format '
        '"audio_guia_arco_2"', () {
      expect(MosaicoArco2.idArco, 'arco_2');
    });

    test('flag de arco completado es `arco_2_estacion_4_cerrada` — '
        'lo activa la cinemática 2.4.8 al cerrar (Aprendiz II), que '
        'es el cierre real del Arco 2 según doc 08', () {
      expect(MosaicoArco2.flagDeArcoCompletado, 'arco_2_estacion_4_cerrada');
    });

    test('flag de Mosaico entregado es `mosaico_arco_2_entregado` — '
        'lo activa la pantalla del Mosaico al entregar, NO la 2.4.8 '
        '(desde F2-11; antes era provisional en el cierre de 2.4.8)', () {
      expect(MosaicoArco2.flagDeMosaicoEntregado, 'mosaico_arco_2_entregado');
    });

    test('mínimo de fragmentos para entregar: 6 de 8 — mismo '
        'patrón que el M1 ("la Cronista puede dejar fragmentos sin '
        'marcar y aún así entregar")', () {
      expect(MosaicoArco2.minimoFragmentosMarcadosParaEntregar, 6);
    });
  });

  group('MosaicoArco2 — ocho fragmentos, dos por Estación', () {
    test('exactamente 8 fragmentos en total', () {
      expect(MosaicoArco2.fragmentos, hasLength(8));
    });

    test('ids de fragmentos únicos — el repositorio los usa como '
        'clave en el blob JSON', () {
      final ids = MosaicoArco2.fragmentos.map((f) => f.id).toSet();
      expect(ids, hasLength(MosaicoArco2.fragmentos.length));
    });

    test('dos fragmentos por cada Estación del Arco 2 (2.1, 2.2, '
        '2.3, 2.4) — distribución pedagógica equilibrada', () {
      final fragmentosPorBrecha = <String, int>{};
      for (final fragmento in MosaicoArco2.fragmentos) {
        fragmentosPorBrecha[fragmento.idBrechaOrigen] =
            (fragmentosPorBrecha[fragmento.idBrechaOrigen] ?? 0) + 1;
      }
      expect(fragmentosPorBrecha, {
        '2.1': 2,
        '2.2': 2,
        '2.3': 2,
        '2.4': 2,
      });
    });

    test('orden cronológico del arco — primero los dos de 2.1, '
        'después 2.2, 2.3 y por último 2.4', () {
      final secuenciaDeBrechas =
          MosaicoArco2.fragmentos.map((f) => f.idBrechaOrigen).toList();
      expect(
        secuenciaDeBrechas,
        ['2.1', '2.1', '2.2', '2.2', '2.3', '2.3', '2.4', '2.4'],
      );
    });

    test('todos los fragmentos llevan al menos una fuente de '
        'anclaje — la audio-guía del oficio del Arco 2 ancla cada '
        'declaración a evidencia documental o material', () {
      for (final fragmento in MosaicoArco2.fragmentos) {
        expect(
          fragmento.idsFuentesAncladas,
          isNotEmpty,
          reason: 'el fragmento ${fragmento.id} debe anclar a una '
              'fuente al menos',
        );
        expect(fragmento.esAnclajeObligatorio, isTrue);
      }
    });
  });

  group('MosaicoArco2 — fragmentos clave del oficio del Arco 2', () {
    test('el segundo fragmento del par 2.3 articula la afirmación '
        '6 *Sólido (la ausencia)* sobre las personas esclavizadas '
        'no nombradas — corazón pedagógico de la Estación 2.3', () {
      final fragmento = MosaicoArco2.fragmentos
          .firstWhere((f) => f.id == 'domus_la_familia_que_no_aparece');
      expect(fragmento.idBrechaOrigen, '2.3');
      expect(fragmento.textoLeido, contains('no están nombradas'));
      expect(fragmento.textoLeido, contains('estructura'));
      expect(fragmento.textoLeido, contains('sólido'));
    });

    test('el segundo fragmento del par 2.4 articula la afirmación '
        '7 *Sólido (la ausencia)* sobre la ausencia de fuentes '
        'producidas por los vascones del periodo y la afirmación 9 '
        '*Sólido como declaración metodológica* sobre el techo '
        'estructural de la reconstrucción — corazón pedagógico de '
        'la Estación 2.4', () {
      final fragmento = MosaicoArco2.fragmentos
          .firstWhere((f) => f.id == 'wamba_el_silencio_y_el_techo');
      expect(fragmento.idBrechaOrigen, '2.4');
      expect(fragmento.textoLeido, contains('no se conservan fuentes'));
      expect(fragmento.textoLeido, contains('techo metodológico'));
      expect(fragmento.textoLeido, contains('declaración metodológica'));
    });

    test('el segundo fragmento del par 2.2 articula la lección de '
        'inferencia por omisión sobre la identidad cultural '
        'predominante de Quintiliano cuando escribe — corazón '
        'pedagógico de HF.10 detección de omisiones', () {
      final fragmento = MosaicoArco2.fragmentos
          .firstWhere((f) => f.id == 'calagurris_lo_que_quintiliano_omite');
      expect(fragmento.idBrechaOrigen, '2.2');
      expect(fragmento.textoLeido, contains('omisión'));
      expect(fragmento.textoLeido, contains('Probablemente'));
      expect(fragmento.textoLeido, contains('inferencia'));
    });
  });

  group('MosaicoArco2 — pregunta abierta del arco', () {
    test('la pregunta abierta del Mosaico es coherente con el '
        'eje epistémico del Arco 2: aprender a declarar lo que las '
        'fuentes no permiten cerrar', () {
      expect(
        MosaicoArco2.preguntaAbiertaDelArco,
        contains('fuentes hablan sólo desde un lado'),
      );
    });

    test('la glosa explica el formato audio-guía y la regla mínima '
        'de entrega', () {
      expect(MosaicoArco2.glosa, contains('audio-guía'));
      expect(MosaicoArco2.glosa, contains('noventa segundos'));
      expect(MosaicoArco2.glosa, contains('seis'));
    });
  });
}
