import 'package:flutter_test/flutter_test.dart';
import 'package:las_versiones/dominio/brecha.dart';
import 'package:las_versiones/dominio/catalogo_brechas.dart';

void main() {
  group('CatalogoBrechas.todas', () {
    test('catálogo cubre las 4 Brechas del Arco 1 + las 4 Brechas '
        'del Arco 2 (8 Brechas implementadas) — el MVP de las 4 '
        'Estaciones del Arco 2 jugables al completo', () {
      expect(CatalogoBrechas.todas, hasLength(8));
      expect(
        CatalogoBrechas.todas.map((brecha) => brecha.id).toList(),
        ['1.1', '1.2', '1.3', '1.4', '2.1', '2.2', '2.3', '2.4'],
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

  group('CatalogoBrechas.brecha23 — La domus de los mosaicos', () {
    test('id, título, ubicación y flag de completado estables', () {
      expect(CatalogoBrechas.brecha23.id, '2.3');
      expect(
        CatalogoBrechas.brecha23.titulo,
        'La domus de los mosaicos',
      );
      expect(
        CatalogoBrechas.brecha23.ubicacionVisible,
        'IRUÑA — DOMUS SUBTERRÁNEA',
      );
      expect(
        CatalogoBrechas.brecha23.flagDeCompletado,
        'brecha_2_3_completada',
      );
    });

    test('catálogo: 4 fuentes y 8 afirmaciones canónicas — la '
        'asimetría documental de la domus pide más declaraciones '
        'que las Brechas previas para que la afirmación 6 sobre la '
        'ausencia se vea como una entre muchas, no como excepción', () {
      expect(CatalogoBrechas.brecha23.fuentes, hasLength(4));
      expect(CatalogoBrechas.brecha23.afirmacionesCanonicas, hasLength(8));
    });

    test('minimoAfirmacionesParaConcilio: 6 — declarar al menos 6 de '
        '8 obliga a tocar al menos una afirmación no Sólido (las '
        'dos Probable o la Disputado), evitando que el jugador '
        'escape sólo con las cinco Sólido', () {
      expect(
        CatalogoBrechas.brecha23.minimoAfirmacionesParaConcilio,
        6,
      );
    });

    test('distribución pedagógica 5 Sólido + 2 Probable + 1 Disputado '
        '— catálogo asimétrico que refleja una fuente epigráfica '
        'oficialista (mucho Sólido sobre el propietario varón) y '
        'una material muda (silencio sobre quienes sostenían la '
        'casa, declarado como Sólido (la ausencia))', () {
      final niveles = CatalogoBrechas.brecha23.afirmacionesCanonicas
          .map((a) => a.calibracionCorrecta)
          .toList();
      expect(niveles.where((n) => n == NivelConfianza.solido), hasLength(5));
      expect(niveles.where((n) => n == NivelConfianza.probable), hasLength(2));
      expect(niveles.where((n) => n == NivelConfianza.disputado), hasLength(1));
    });

    test('la afirmación sobre la ausencia documentada de las personas '
        'esclavizadas se calibra como Sólido (no Disputado), porque '
        'el silencio es estructura social documentada — corazón '
        'pedagógico de la Estación 2.3 según doc 08 §2.3.5', () {
      final ausencia = CatalogoBrechas.brecha23.afirmacionesCanonicas
          .firstWhere((a) => a.id == 'ausencia_nombrar_esclavizadas');
      expect(ausencia.calibracionCorrecta, NivelConfianza.solido);
      expect(ausencia.texto, contains('Sólido (la ausencia)'));
      expect(ausencia.texto, contains('estructura'));
    });

    test('la afirmación Disputado única es la existencia de hijos no '
        'documentados directamente — ni la inscripción ni las '
        'cuentas los registran, aunque la edad y posición hacen '
        'Probable que sí los tuviera', () {
      final disputadas = CatalogoBrechas.brecha23.afirmacionesCanonicas
          .where((a) => a.calibracionCorrecta == NivelConfianza.disputado)
          .map((a) => a.id)
          .toSet();
      expect(disputadas, {'existencia_hijos'});
    });

    test('todas las afirmaciones citan al menos una fuente del '
        'catálogo — anclaje a evidencia (P3) tiene a qué apuntar', () {
      final idsFuentes =
          CatalogoBrechas.brecha23.fuentes.map((f) => f.id).toSet();
      for (final afirmacion in CatalogoBrechas.brecha23.afirmacionesCanonicas) {
        expect(afirmacion.idsFuentesAnclaje, isNotEmpty);
        for (final idFuente in afirmacion.idsFuentesAnclaje) {
          expect(idsFuentes, contains(idFuente));
        }
      }
    });

    test('la inscripción honorífica del propietario lleva sesgo '
        'oficialista — fuente epigráfica que registra al cabeza de '
        'familia varón con cargo cívico y omite a quienes sostenían '
        'la casa', () {
      final inscripcion = CatalogoBrechas.brecha23.fuentes
          .firstWhere((f) => f.id == 'inscripcion_propietario_cornelio');
      expect(inscripcion.propiedadesCanonicas.tipo, TipoFuente.primaria);
      expect(
        inscripcion.propiedadesCanonicas.sesgo,
        SesgoFuente.oficialista,
      );
    });

    test('la tablilla con cuentas domésticas lleva sesgo '
        'invisibilizador — registra a las personas esclavizadas '
        'como número ("servis II") sin nombre, lógica '
        'administrativa que disuelve las identidades', () {
      final tablilla = CatalogoBrechas.brecha23.fuentes
          .firstWhere((f) => f.id == 'tablilla_cuentas_domesticas');
      expect(tablilla.propiedadesCanonicas.tipo, TipoFuente.primaria);
      expect(
        tablilla.propiedadesCanonicas.sesgo,
        SesgoFuente.invisibilizador,
      );
    });

    test('la afirmación sobre la ausencia se ancla en al menos las '
        'tres fuentes que la documentan (la tablilla por número, '
        'la inscripción por silencio, los restos materiales por '
        'mudez sobre identidades)', () {
      final ausencia = CatalogoBrechas.brecha23.afirmacionesCanonicas
          .firstWhere((a) => a.id == 'ausencia_nombrar_esclavizadas');
      expect(
        ausencia.idsFuentesAnclaje.toSet(),
        {
          'tablilla_cuentas_domesticas',
          'inscripcion_propietario_cornelio',
          'restos_materiales_domus',
        },
      );
    });
  });

  group('CatalogoBrechas.brecha24 — Wamba contra los vascones', () {
    test('id, título, ubicación y flag de completado estables', () {
      expect(CatalogoBrechas.brecha24.id, '2.4');
      expect(
        CatalogoBrechas.brecha24.titulo,
        'Wamba contra los vascones',
      );
      expect(
        CatalogoBrechas.brecha24.ubicacionVisible,
        'IRUÑA — BIBLIOTECA + YACIMIENTO DEL NORTE',
      );
      expect(
        CatalogoBrechas.brecha24.flagDeCompletado,
        'brecha_2_4_completada',
      );
    });

    test('catálogo más amplio del MVP: 4 fuentes y 9 afirmaciones '
        'canónicas — la "Brecha de un solo lado" del encargo de '
        'Isaura pide más declaraciones para que la asimetría '
        'documental se vea estructuralmente y no como excepción', () {
      expect(CatalogoBrechas.brecha24.fuentes, hasLength(4));
      expect(CatalogoBrechas.brecha24.afirmacionesCanonicas, hasLength(9));
    });

    test('minimoAfirmacionesParaConcilio: 7 — declarar al menos 7 de '
        '9 obliga a tocar al menos una afirmación no Sólido (las '
        'dos Probable o las dos Disputado), evitando que el jugador '
        'escape sólo con las cinco Sólido del catálogo', () {
      expect(
        CatalogoBrechas.brecha24.minimoAfirmacionesParaConcilio,
        7,
      );
    });

    test('distribución pedagógica 5 Sólido + 2 Probable + 2 Disputado '
        '— catálogo asimétrico que refleja una fuente visigoda '
        'oficialista (mucho Sólido sobre la campaña), un silencio '
        'vascón estructural (Sólido (la ausencia)) y un techo '
        'metodológico de la reconstrucción (Sólido como declaración '
        'metodológica)', () {
      final niveles = CatalogoBrechas.brecha24.afirmacionesCanonicas
          .map((a) => a.calibracionCorrecta)
          .toList();
      expect(niveles.where((n) => n == NivelConfianza.solido), hasLength(5));
      expect(niveles.where((n) => n == NivelConfianza.probable), hasLength(2));
      expect(niveles.where((n) => n == NivelConfianza.disputado), hasLength(2));
    });

    test('la afirmación 7 sobre la ausencia de fuentes vasconas se '
        'calibra como Sólido (no Disputado) — el silencio vascón '
        'es el dato, no la ausencia de dato; lección epistémica '
        'clave articulada por Karim en 2.4.5', () {
      final ausencia = CatalogoBrechas.brecha24.afirmacionesCanonicas
          .firstWhere((a) => a.id == 'ausencia_fuentes_vasconas');
      expect(ausencia.calibracionCorrecta, NivelConfianza.solido);
      expect(ausencia.texto, contains('Sólido (la ausencia)'));
    });

    test('la afirmación 9 sobre el techo metodológico se calibra '
        'como Sólido — declaración metodológica explícita que '
        'cualquier cronista futuro debe poder leer para no '
        'confundir "no se sabe" con "se puede saber con más '
        'trabajo"', () {
      final techoMetodologico = CatalogoBrechas.brecha24.afirmacionesCanonicas
          .firstWhere((a) => a.id == 'techo_metodologico_reconstruccion');
      expect(techoMetodologico.calibracionCorrecta, NivelConfianza.solido);
      expect(
        techoMetodologico.texto,
        contains('Sólido como declaración metodológica'),
      );
      expect(techoMetodologico.texto, contains('techo'));
    });

    test('las dos afirmaciones Disputado son el estatus previo de '
        'los vascones y el alcance real de la "pacificación" — '
        'las dos preguntas que la propaganda visigoda no permite '
        'cerrar contra la evidencia de campañas recurrentes', () {
      final disputadas = CatalogoBrechas.brecha24.afirmacionesCanonicas
          .where((a) => a.calibracionCorrecta == NivelConfianza.disputado)
          .map((a) => a.id)
          .toSet();
      expect(disputadas, {'estatus_previo_vascones', 'alcance_pacificacion'});
    });

    test('todas las afirmaciones citan al menos una fuente del '
        'catálogo — anclaje a evidencia (P3) tiene a qué apuntar '
        'incluso para las dos Sólido especiales (la ausencia y la '
        'declaración metodológica)', () {
      final idsFuentes =
          CatalogoBrechas.brecha24.fuentes.map((f) => f.id).toSet();
      for (final afirmacion in CatalogoBrechas.brecha24.afirmacionesCanonicas) {
        expect(afirmacion.idsFuentesAnclaje, isNotEmpty);
        for (final idFuente in afirmacion.idsFuentesAnclaje) {
          expect(idsFuentes, contains(idFuente));
        }
      }
    });

    test('la Historia Wambae regis lleva sesgo oficialista — '
        'propaganda dinástica visigoda hagiográfica, fuente '
        'principal sobre la campaña pero con presuposiciones de '
        'legitimidad no examinadas', () {
      final julian = CatalogoBrechas.brecha24.fuentes
          .firstWhere((f) => f.id == 'historia_wambae_regis');
      expect(julian.propiedadesCanonicas.tipo, TipoFuente.primaria);
      expect(
        julian.propiedadesCanonicas.sesgo,
        SesgoFuente.oficialista,
      );
    });

    test('el yacimiento vascón del norte permanece sin nombre '
        'histórico — sustitución diegética hasta validación del '
        'comité asesor (registrada en BLOQUEOS-PENDIENTES.md), '
        'preserva la pedagogía de fuente material muda sin '
        'afirmar yacimiento concreto', () {
      final yacimiento = CatalogoBrechas.brecha24.fuentes
          .firstWhere((f) => f.id == 'yacimiento_vascon_norte');
      expect(yacimiento.tipoVisible, contains('sin nombre'));
      expect(yacimiento.propiedadesCanonicas.tipo, TipoFuente.primaria);
    });

    test('la afirmación 8 (estructura social que produce la '
        'asimetría documental) se calibra como Probable — el doc '
        '08 §2.4.7 la marca explícitamente como interpretativa, '
        'donde Joana/Karim/Aitor convergen desde distintos lados', () {
      final estructura = CatalogoBrechas.brecha24.afirmacionesCanonicas
          .firstWhere((a) => a.id == 'ausencia_estructural_no_accidente');
      expect(estructura.calibracionCorrecta, NivelConfianza.probable);
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

    test('la Brecha 2.3 se dispara con '
        '`comprender_sin_justificar_aprendido` (flag que la '
        'cinemática 2.3.4 *Comprender sin justificar* activa al '
        'cerrar — Isaura ha enseñado la lección epistémica clave '
        'y Maren la aplica jugando)', () {
      expect(
        CatalogoBrechas
            .brechaPorFlagDeDisparo['comprender_sin_justificar_aprendido'],
        same(CatalogoBrechas.brecha23),
      );
    });

    test('la Brecha 2.4 se dispara con `silencio_es_dato_aprendido` '
        '(flag que la cinemática 2.4.5 *El silencio es el dato* '
        'activa al cerrar — Karim articula la lección epistémica '
        'clave del Arco 2 *"el silencio vascón es el dato. No es '
        'ausencia de dato"*)', () {
      expect(
        CatalogoBrechas.brechaPorFlagDeDisparo['silencio_es_dato_aprendido'],
        same(CatalogoBrechas.brecha24),
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
