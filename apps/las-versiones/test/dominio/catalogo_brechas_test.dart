import 'package:flutter_test/flutter_test.dart';
import 'package:las_versiones/dominio/brecha.dart';
import 'package:las_versiones/dominio/catalogo_brechas.dart';

void main() {
  group('CatalogoBrechas.todas', () {
    test('catálogo cubre las 4 Brechas del Arco 1 + Brechas 2.1 y 2.2 '
        'del Arco 2 (6 Brechas implementadas) — las 2.3/2.4 todavía '
        'no están en el catálogo', () {
      expect(CatalogoBrechas.todas, hasLength(6));
      expect(
        CatalogoBrechas.todas.map((brecha) => brecha.id).toList(),
        ['1.1', '1.2', '1.3', '1.4', '2.1', '2.2'],
      );
    });

    test('cada Brecha lleva un flagDeCompletado único — el orquestador '
        'lo usa como clave para saber cuáles están cerradas', () {
      final flagsCompletado =
          CatalogoBrechas.todas.map((b) => b.flagDeCompletado).toSet();
      expect(flagsCompletado, hasLength(CatalogoBrechas.todas.length));
    });
  });

  group('CatalogoBrechas.brecha21 — Pompaelo bajo Iruña', () {
    test('id, título, ubicación y flag de completado estables', () {
      expect(CatalogoBrechas.brecha21.id, '2.1');
      expect(CatalogoBrechas.brecha21.titulo, 'La inscripción de Licinio');
      expect(
        CatalogoBrechas.brecha21.ubicacionVisible,
        'IRUÑA — POMPAELO SUBTERRÁNEA',
      );
      expect(
        CatalogoBrechas.brecha21.flagDeCompletado,
        'brecha_2_1_completada',
      );
    });

    test('catálogo amplio: 5 fuentes y 6 afirmaciones canónicas — '
        'la pedagogía pide más declaraciones que en el Arco 1 (4 '
        'afirmaciones) porque la fuente textual con propaganda '
        'requiere distinguir más matices', () {
      expect(CatalogoBrechas.brecha21.fuentes, hasLength(5));
      expect(CatalogoBrechas.brecha21.afirmacionesCanonicas, hasLength(6));
    });

    test('minimoAfirmacionesParaConcilio elevado a 4 (vs el default 3 '
        'del Arco 1) — declarar sólo 3 de 6 sería insuficiente para '
        'sostener la versión sobre la inscripción', () {
      expect(
        CatalogoBrechas.brecha21.minimoAfirmacionesParaConcilio,
        4,
      );
    });

    test('distribución de calibración pedagógica — 2 Sólidas + 2 '
        'Probables + 2 Disputadas. La pedagogía de la Estación 2.1 '
        'es que en una fuente textual con propaganda el oficio '
        'honesto declara muchas Disputado y Probable, no muchas '
        'Sólido', () {
      final niveles = CatalogoBrechas.brecha21.afirmacionesCanonicas
          .map((a) => a.calibracionCorrecta)
          .toList();
      expect(niveles.where((n) => n == NivelConfianza.solido), hasLength(2));
      expect(niveles.where((n) => n == NivelConfianza.probable), hasLength(2));
      expect(niveles.where((n) => n == NivelConfianza.disputado), hasLength(2));
    });

    test('las dos afirmaciones Sólido son la naturaleza honorífica '
        'y la datación amplia s. I-III — son las que la convención '
        'epigráfica permite afirmar sin disputa', () {
      final solidas = CatalogoBrechas.brecha21.afirmacionesCanonicas
          .where((a) => a.calibracionCorrecta == NivelConfianza.solido)
          .map((a) => a.id)
          .toSet();
      expect(
        solidas,
        {'tipo_honorifica', 'siglo_inscripcion_amplio'},
      );
    });

    test('las dos afirmaciones Disputado son la identidad del '
        'dedicante y el vínculo del honrado con Pompaelo — las dos '
        'preguntas que la inscripción mutilada deja explícitamente '
        'sin respuesta', () {
      final disputadas = CatalogoBrechas.brecha21.afirmacionesCanonicas
          .where((a) => a.calibracionCorrecta == NivelConfianza.disputado)
          .map((a) => a.id)
          .toSet();
      expect(
        disputadas,
        {'identidad_dedicante', 'vinculo_pompaelo_honrado'},
      );
    });

    test('todas las afirmaciones citan al menos una fuente del '
        'catálogo de la Brecha — anclaje a evidencia (P3) tiene a '
        'qué apuntar', () {
      final idsFuentes =
          CatalogoBrechas.brecha21.fuentes.map((f) => f.id).toSet();
      for (final afirmacion in CatalogoBrechas.brecha21.afirmacionesCanonicas) {
        expect(
          afirmacion.idsFuentesAnclaje,
          isNotEmpty,
          reason:
              'la afirmación ${afirmacion.id} debe anclarse en al '
              'menos una fuente para sostener la calibración P3',
        );
        for (final idFuente in afirmacion.idsFuentesAnclaje) {
          expect(
            idsFuentes,
            contains(idFuente),
            reason: 'la afirmación ${afirmacion.id} cita la fuente '
                '$idFuente que no está en el catálogo de fuentes '
                'de la Brecha 2.1',
          );
        }
      }
    });

    test('la inscripción in situ es fuente primaria con sesgo '
        'oficialista — propaganda institucional según la lección '
        'pedagógica de Karim en 2.1.4', () {
      final inscripcion = CatalogoBrechas.brecha21.fuentes
          .firstWhere((f) => f.id == 'inscripcion_in_situ');
      expect(inscripcion.propiedadesCanonicas.tipo, TipoFuente.primaria);
      expect(
        inscripcion.propiedadesCanonicas.sesgo,
        SesgoFuente.oficialista,
      );
    });

    test('los paralelos de inscripciones de la capital llevan sesgo '
        'invisibilizador — los dedicantes no élites están '
        'infrarepresentados, dato pedagógico que el oficio debe '
        'hacer explícito', () {
      final paralelos = CatalogoBrechas.brecha21.fuentes
          .firstWhere((f) => f.id == 'paralelos_inscripciones_capital');
      expect(paralelos.propiedadesCanonicas.tipo, TipoFuente.secundaria);
      expect(
        paralelos.propiedadesCanonicas.sesgo,
        SesgoFuente.invisibilizador,
      );
    });

    test('la PIR aparece como herramienta de referencia secundaria '
        '— se cita por su nombre canónico (Prosopographia Imperii '
        'Romani) sin afirmar entradas concretas, según el doc 08', () {
      final pir = CatalogoBrechas.brecha21.fuentes
          .firstWhere((f) => f.id == 'pir_repertorio');
      expect(pir.propiedadesCanonicas.tipo, TipoFuente.secundaria);
      expect(pir.tipoVisible, contains('PIR'));
      expect(pir.tipoVisible, contains('Prosopographia'));
    });
  });

  group('CatalogoBrechas.brecha22 — Quintiliano de Calagurris', () {
    test('id, título, ubicación y flag de completado estables', () {
      expect(CatalogoBrechas.brecha22.id, '2.2');
      expect(
        CatalogoBrechas.brecha22.titulo,
        'Quintiliano de Calagurris',
      );
      expect(
        CatalogoBrechas.brecha22.ubicacionVisible,
        'CALAHORRA — MUSEO ROMANO',
      );
      expect(
        CatalogoBrechas.brecha22.flagDeCompletado,
        'brecha_2_2_completada',
      );
    });

    test('catálogo: 4 fuentes y 7 afirmaciones canónicas — la '
        'pedagogía pide más afirmaciones que la 2.1 porque la '
        'Institutio Oratoria es texto rico en datos directos sobre '
        'lo que Quintiliano dice + lo que omite', () {
      expect(CatalogoBrechas.brecha22.fuentes, hasLength(4));
      expect(CatalogoBrechas.brecha22.afirmacionesCanonicas, hasLength(7));
    });

    test('minimoAfirmacionesParaConcilio: 5 — declarar al menos 5 '
        'de 7 obliga a tocar al menos una de las inferencias sobre '
        'omisiones (Probable o Disputado)', () {
      expect(
        CatalogoBrechas.brecha22.minimoAfirmacionesParaConcilio,
        5,
      );
    });

    test('distribución pedagógica 4 Sólido + 1 Probable + 2 '
        'Disputado — la Institutio es fuente rica en datos directos '
        '(mucho Sólido) pero la pedagogía clave es declarar las '
        'inferencias por omisión como Probable/Disputado', () {
      final niveles = CatalogoBrechas.brecha22.afirmacionesCanonicas
          .map((a) => a.calibracionCorrecta)
          .toList();
      expect(niveles.where((n) => n == NivelConfianza.solido), hasLength(4));
      expect(niveles.where((n) => n == NivelConfianza.probable), hasLength(1));
      expect(niveles.where((n) => n == NivelConfianza.disputado), hasLength(2));
    });

    test('la afirmación Probable es justamente la identidad cultural '
        'predominante de Quintiliano cuando escribe — basada en '
        'omisiones, no en afirmaciones (lección de Aitor por '
        'videollamada en 2.2.5)', () {
      final probables = CatalogoBrechas.brecha22.afirmacionesCanonicas
          .where((a) => a.calibracionCorrecta == NivelConfianza.probable)
          .map((a) => a.id)
          .toSet();
      expect(probables, {'identidad_romana_predominante'});
    });

    test('todas las afirmaciones citan al menos una fuente del '
        'catálogo — anclaje a evidencia (P3) tiene a qué apuntar', () {
      final idsFuentes =
          CatalogoBrechas.brecha22.fuentes.map((f) => f.id).toSet();
      for (final afirmacion in CatalogoBrechas.brecha22.afirmacionesCanonicas) {
        expect(afirmacion.idsFuentesAnclaje, isNotEmpty);
        for (final idFuente in afirmacion.idsFuentesAnclaje) {
          expect(idsFuentes, contains(idFuente));
        }
      }
    });

    test('la Institutio Oratoria lleva sesgo invisibilizador — '
        'omite lo no romano e invisibiliza la propia identidad '
        'provincial de Quintiliano (núcleo pedagógico de HF.10 '
        'detección de omisiones)', () {
      final io = CatalogoBrechas.brecha22.fuentes
          .firstWhere((f) => f.id == 'institutio_oratoria_pasajes');
      expect(io.propiedadesCanonicas.tipo, TipoFuente.primaria);
      expect(
        io.propiedadesCanonicas.sesgo,
        SesgoFuente.invisibilizador,
      );
    });
  });

  group('CatalogoBrechas.brechaPorFlagDeDisparo', () {
    test('la Brecha 2.1 se dispara con `inscripcion_romana_estudiada` '
        '(flag que la cinemática 2.1.4 activa al cerrar)', () {
      expect(
        CatalogoBrechas.brechaPorFlagDeDisparo['inscripcion_romana_estudiada'],
        same(CatalogoBrechas.brecha21),
      );
    });

    test('la Brecha 2.2 se dispara con '
        '`omisiones_quintiliano_estudiadas` (flag que la cinemática '
        '2.2.4 "Lo que omite" activa al cerrar)', () {
      expect(
        CatalogoBrechas
            .brechaPorFlagDeDisparo['omisiones_quintiliano_estudiadas'],
        same(CatalogoBrechas.brecha22),
      );
    });

    test('cada flag de disparo apunta a una Brecha distinta — el '
        'orquestador no debe tener ambigüedad', () {
      final brechas = CatalogoBrechas.brechaPorFlagDeDisparo.values.toSet();
      expect(
        brechas,
        hasLength(CatalogoBrechas.brechaPorFlagDeDisparo.length),
      );
    });
  });
}
