import 'package:flutter_test/flutter_test.dart';
import 'package:las_versiones/dominio/brecha.dart';
import 'package:las_versiones/dominio/catalogo_brechas.dart';

void main() {
  group('CatalogoBrechas.todas', () {
    test('catálogo cubre las 4 Brechas del Arco 1 + las 4 Brechas '
        'del Arco 2 + las 4 Brechas jugables del Arco 3 implementadas '
        '(12 Brechas) — F2-28d cierra el set de Brechas jugables del '
        'Arco 3 sumando la 3.5 *Estella en su esplendor* (Brecha de '
        'respiro) a la 3.1, 3.3 y 3.4 ya abiertas. La 3.2 Banu Qasi '
        'sigue bloqueada por BANU-QASI hasta validación del comité; '
        'la 3.6 TUDELA-1378 sigue bloqueada por validación del '
        'comité provisional', () {
      expect(CatalogoBrechas.todas, hasLength(12));
      expect(
        CatalogoBrechas.todas.map((brecha) => brecha.id).toList(),
        [
          '1.1',
          '1.2',
          '1.3',
          '1.4',
          '2.1',
          '2.2',
          '2.3',
          '2.4',
          '3.1',
          '3.3',
          '3.4',
          '3.5',
        ],
      );
    });

    test('cada Brecha lleva un flagDeCompletado único — el orquestador '
        'lo usa como clave para saber cuáles están cerradas', () {
      final flagsCompletado =
          CatalogoBrechas.todas.map((b) => b.flagDeCompletado).toSet();
      expect(flagsCompletado, hasLength(CatalogoBrechas.todas.length));
    });
  });

  group('CatalogoBrechas.brecha21 — Pompelo bajo Iruña '
      '(ara de Aelio Attiano)', () {
    test('id, título, ubicación y flag de completado estables', () {
      expect(CatalogoBrechas.brecha21.id, '2.1');
      expect(CatalogoBrechas.brecha21.titulo, 'El ara de Aelio Attiano');
      expect(
        CatalogoBrechas.brecha21.ubicacionVisible,
        'IRUÑA — POMPELO SUBTERRÁNEA',
      );
      expect(
        CatalogoBrechas.brecha21.flagDeCompletado,
        'brecha_2_1_completada',
      );
    });

    test('catálogo: 4 fuentes y 10 afirmaciones canónicas — las 8 del '
        'doc validado POMPAELO-INSCRIPCION con las dos de calibración '
        'doble (hecho del error / causa del error, hecho de la '
        'reutilización / contexto de inestabilidad) separadas en pares '
        'para preservar el matiz', () {
      expect(CatalogoBrechas.brecha21.fuentes, hasLength(4));
      expect(CatalogoBrechas.brecha21.afirmacionesCanonicas, hasLength(10));
    });

    test('minimoAfirmacionesParaConcilio: 7 — declarar 7 de 10 fuerza '
        'a tocar al menos una no-Sólido (las 6 Sólido por sí solas '
        'no llegan al mínimo)', () {
      expect(
        CatalogoBrechas.brecha21.minimoAfirmacionesParaConcilio,
        7,
      );
    });

    test('distribución pedagógica 6 Sólido + 2 Probable + 2 Disputado '
        '— la pieza tiene hechos epigráficos sólidos (paleografía, '
        'fórmulas, edad del difunto, error gramatical, reutilización) '
        'pero las inferencias clave (causa del error, contexto de '
        'inestabilidad, desfase temporal de las dos caras) son '
        'Probable o Disputado', () {
      final niveles = CatalogoBrechas.brecha21.afirmacionesCanonicas
          .map((a) => a.calibracionCorrecta)
          .toList();
      expect(niveles.where((n) => n == NivelConfianza.solido), hasLength(6));
      expect(niveles.where((n) => n == NivelConfianza.probable), hasLength(2));
      expect(niveles.where((n) => n == NivelConfianza.disputado), hasLength(2));
    });

    test('la afirmación Disputada `tres_hipotesis_desfase` recoge las '
        'tres hipótesis del doc validado sobre el desfase de dos '
        'siglos entre las dos caras del ara — sostener la incertidumbre '
        'es parte del oficio', () {
      final tres = CatalogoBrechas.brecha21.afirmacionesCanonicas
          .firstWhere((a) => a.id == 'tres_hipotesis_desfase');
      expect(tres.calibracionCorrecta, NivelConfianza.disputado);
      expect(tres.texto, contains('pintado con pigmento'));
      expect(tres.texto, contains('officina epigraphica'));
      expect(tres.texto, contains('desechada por defecto'));
    });

    test('el error del lapicida se separa en dos afirmaciones — el '
        'hecho del error es Sólido (factualmente atestiguado), la '
        'causa es Disputada (las tres explicaciones plausibles)', () {
      final hecho = CatalogoBrechas.brecha21.afirmacionesCanonicas
          .firstWhere((a) => a.id == 'error_lapicida_hecho');
      final causa = CatalogoBrechas.brecha21.afirmacionesCanonicas
          .firstWhere((a) => a.id == 'error_lapicida_causa');
      expect(hecho.calibracionCorrecta, NivelConfianza.solido);
      expect(causa.calibracionCorrecta, NivelConfianza.disputado);
      expect(hecho.texto, contains('error gramatical'));
      expect(causa.texto, contains('escaso dominio del latín'));
    });

    test('la reutilización en muralla se separa en dos afirmaciones '
        '— el hecho es Sólido (atestiguado por el contexto '
        'arqueológico del hallazgo), el contexto de inestabilidad '
        'del s. III es Probable (lectura plausible no cerrada)', () {
      final hecho = CatalogoBrechas.brecha21.afirmacionesCanonicas
          .firstWhere((a) => a.id == 'reutilizacion_muralla_hecho');
      final contexto = CatalogoBrechas.brecha21.afirmacionesCanonicas
          .firstWhere((a) => a.id == 'reutilizacion_contexto');
      expect(hecho.calibracionCorrecta, NivelConfianza.solido);
      expect(contexto.calibracionCorrecta, NivelConfianza.probable);
      expect(hecho.texto, contains('muralla bajoimperial'));
      expect(contexto.texto, contains('inestabilidad del Imperio del s. III'));
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

    test('el ara de Aelio Attiano es fuente primaria con sesgo '
        'oficialista — la inscripción funeraria es propaganda en '
        'sentido amplio del padre dedicante; el error del lapicida '
        'es información que escapa', () {
      final ara = CatalogoBrechas.brecha21.fuentes
          .firstWhere((f) => f.id == 'ara_aelio_attiano');
      expect(ara.propiedadesCanonicas.tipo, TipoFuente.primaria);
      expect(
        ara.propiedadesCanonicas.sesgo,
        SesgoFuente.oficialista,
      );
    });

    test('la publicación de Velaza et al. (2014) es fuente '
        'secundaria autorizada — edición rigurosa de referencia '
        'sobre la pieza', () {
      final velaza = CatalogoBrechas.brecha21.fuentes
          .firstWhere((f) => f.id == 'publicacion_velaza_2014');
      expect(velaza.propiedadesCanonicas.tipo, TipoFuente.secundaria);
      expect(velaza.tipoVisible, contains('Velaza'));
      expect(velaza.tipoVisible, contains('Epigraphica'));
    });

    test('las tablas de Arre (CIL II 2958-2960) anclan la forma '
        '`Pompelo` como nombre canónico oficial frente a `Pompaelo` '
        '(variante posterior del Itinerario de Antonino)', () {
      final tablas = CatalogoBrechas.brecha21.fuentes
          .firstWhere((f) => f.id == 'tablas_arre_pompelo');
      expect(tablas.propiedadesCanonicas.tipo, TipoFuente.primaria);
      expect(tablas.tipoVisible, contains('CIL II'));
      expect(tablas.descripcion, contains('Pompelo'));
      expect(tablas.descripcion, contains('Pompaelo'));
      expect(tablas.descripcion, contains('Itinerario de Antonino'));
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

    test('la Brecha 3.1 se dispara con `toponimos_occitanos_aprendidos` '
        '(flag que la cinemática 3.1.3 *El barrio occitano* activa al '
        'cerrar — Isaura le señala a Maren las huellas occitanas en el '
        'callejero y le explica el sustrato vasco como lengua del '
        'paisaje no escrita formalmente)', () {
      expect(
        CatalogoBrechas
            .brechaPorFlagDeDisparo['toponimos_occitanos_aprendidos'],
        same(CatalogoBrechas.brecha31),
      );
    });

    test('la Brecha 3.3 se dispara con `leyenda_virila_estudiada` '
        '(flag que la cinemática 3.3.4 *Cuándo se escribió* activa al '
        'cerrar — la voz del Cuaderno articula la lección PH.10 en '
        'pleno y el monje del scriptorium ya ha desplegado el material '
        'que Maren tiene que articular en la Mesa de Trabajo del '
        'propio monasterio)', () {
      expect(
        CatalogoBrechas.brechaPorFlagDeDisparo['leyenda_virila_estudiada'],
        same(CatalogoBrechas.brecha33),
      );
    });

    test('la Brecha 3.4 se dispara con '
        '`chanson_como_propaganda_aprendida` (flag que la cinemática '
        '3.4.4 *La Chanson* activa al cerrar — Maren analiza la '
        '*Chanson de Roland* en su contexto cruzado y articula que '
        'la sustitución vascones→sarracenos es propaganda cruzada '
        'respirada por los redactores en torno a 1100, lista ya para '
        'producir las 8 afirmaciones canónicas en la Mesa de Trabajo)',
        () {
      expect(
        CatalogoBrechas
            .brechaPorFlagDeDisparo['chanson_como_propaganda_aprendida'],
        same(CatalogoBrechas.brecha34),
      );
    });

    test('la Brecha 3.5 se dispara con `estella_conjunto_visitado` '
        '(flag que la cinemática 3.5.1 *Llegada a Estella* activa al '
        'cerrar — Aitor le ha explicado a Maren que la villa es '
        'proyecto político de Sancho Ramírez de 1090 con carta '
        'puebla específica para atraer población franca al Camino '
        'de Santiago, y le ha señalado los cuatro monumentos del '
        'conjunto románico como fuentes arquitectónicas)', () {
      expect(
        CatalogoBrechas.brechaPorFlagDeDisparo['estella_conjunto_visitado'],
        same(CatalogoBrechas.brecha35),
      );
    });
  });

  group('CatalogoBrechas.brecha31 — San Cernin y las tres lenguas '
      '(primera Brecha jugable del Arco 3)', () {
    test('id, título, ubicación y flag de completado estables', () {
      expect(CatalogoBrechas.brecha31.id, '3.1');
      expect(
        CatalogoBrechas.brecha31.titulo,
        'San Cernin y las tres lenguas',
      );
      expect(
        CatalogoBrechas.brecha31.ubicacionVisible,
        'IRUÑA — CASCO VIEJO + MESA DE TRABAJO',
      );
      expect(
        CatalogoBrechas.brecha31.flagDeCompletado,
        'brecha_3_1_completada',
      );
    });

    test('catálogo: 5 fuentes (3 textuales en 3 lenguas + sustrato '
        'toponímico + estudios filológicos modernos) y 7 afirmaciones '
        'canónicas', () {
      expect(CatalogoBrechas.brecha31.fuentes, hasLength(5));
      expect(CatalogoBrechas.brecha31.afirmacionesCanonicas, hasLength(7));
    });

    test('minimoAfirmacionesParaConcilio: 5 — declarar 5 de 7 obliga '
        'a tocar al menos una de las inferencias indirectas (las dos '
        'Probables o la Disputada), que es donde el oficio se '
        'ejercita en esta Brecha', () {
      expect(
        CatalogoBrechas.brecha31.minimoAfirmacionesParaConcilio,
        5,
      );
    });

    test('distribución pedagógica 4 Sólido + 2 Probable + 1 Disputado '
        '— las cuatro Sólidas son hechos documentados o inferibles '
        'directamente del material trazable; las dos Probables son '
        'inferencias por sustrato toponímico y triangulación; la '
        'Disputada es la pregunta abierta sobre causas de la '
        'invisibilidad documental del euskera', () {
      final niveles = CatalogoBrechas.brecha31.afirmacionesCanonicas
          .map((a) => a.calibracionCorrecta)
          .toList();
      expect(niveles.where((n) => n == NivelConfianza.solido), hasLength(4));
      expect(niveles.where((n) => n == NivelConfianza.probable), hasLength(2));
      expect(niveles.where((n) => n == NivelConfianza.disputado), hasLength(1));
    });

    test('la afirmación Disputada `causas_invisibilidad_euskera` recoge '
        'las cuatro hipótesis abiertas (prestigio diferencial, ausencia '
        'de scriptoria, uso oral estamental, elección política '
        'consciente) y declara explícitamente que la documentación no '
        'las discrimina', () {
      final disputada = CatalogoBrechas.brecha31.afirmacionesCanonicas
          .firstWhere((a) => a.id == 'causas_invisibilidad_euskera');
      expect(disputada.calibracionCorrecta, NivelConfianza.disputado);
      expect(disputada.texto, contains('prestigio diferencial'));
      expect(disputada.texto, contains('scriptoria'));
      expect(disputada.texto, contains('estamentalmente bajo'));
      expect(disputada.texto, contains('elección política'));
    });

    test('la presencia oral del euskera se declara Probable, no Sólida '
        '— pedagogía clave de la Estación 3.1 articulada por Maren '
        'ante Karim en el Concilio (3.1.4): la documentación trilingüe '
        'es Sólida, la inferencia oral basada en evidencia indirecta '
        'es Probable', () {
      final euskera = CatalogoBrechas.brecha31.afirmacionesCanonicas
          .firstWhere((a) => a.id == 'euskera_oral_sustrato');
      expect(euskera.calibracionCorrecta, NivelConfianza.probable);
      expect(euskera.texto, contains('sustrato toponímico'));
      expect(euskera.texto, contains('glosas'));
    });

    test('todas las afirmaciones citan al menos una fuente del '
        'catálogo de la Brecha — ninguna afirmación queda sin '
        'anclaje', () {
      final idsValidos =
          CatalogoBrechas.brecha31.fuentes.map((f) => f.id).toSet();
      for (final afirmacion in CatalogoBrechas.brecha31.afirmacionesCanonicas) {
        expect(
          afirmacion.idsFuentesAnclaje,
          isNotEmpty,
          reason: 'afirmación ${afirmacion.id} sin fuentes',
        );
        for (final idFuente in afirmacion.idsFuentesAnclaje) {
          expect(
            idsValidos,
            contains(idFuente),
            reason:
                'afirmación ${afirmacion.id} cita la fuente $idFuente '
                'pero esa fuente no existe en el catálogo de la Brecha',
          );
        }
      }
    });

    test('habilidades ejercitadas incluyen HF.07 (plurilingüismo '
        'documental) en su debut jugable expandido a tres lenguas + '
        'HF.10 (detección de omisiones del euskera en la documentación '
        'administrativa)', () {
      expect(CatalogoBrechas.brecha31.habilidadesEjercitadas,
          contains('HF.07'));
      expect(CatalogoBrechas.brecha31.habilidadesEjercitadas,
          contains('HF.10'));
    });

    test('el Fuero de Pamplona-San Cernin de 1129 es fuente primaria '
        'con sesgo oficialista (favorece la perspectiva franca, '
        'preserva material trazable real)', () {
      final fuero = CatalogoBrechas.brecha31.fuentes
          .firstWhere((f) => f.id == 'fuero_pamplona_san_cernin_1129');
      expect(fuero.propiedadesCanonicas.tipo, TipoFuente.primaria);
      expect(
        fuero.propiedadesCanonicas.sesgo,
        SesgoFuente.oficialista,
      );
      expect(fuero.tipoVisible, contains('1129'));
    });

    test('la carta de queja del concejo de la Navarrería al rey '
        'Sancho VI es fuente primaria con sesgo invisibilizador (sólo '
        'voz vasco-romance, oculta perspectivas de los otros dos '
        'burgos)', () {
      final carta = CatalogoBrechas.brecha31.fuentes
          .firstWhere((f) => f.id == 'carta_concejo_navarreria_sancho_vi');
      expect(carta.propiedadesCanonicas.tipo, TipoFuente.primaria);
      expect(
        carta.propiedadesCanonicas.sesgo,
        SesgoFuente.invisibilizador,
      );
    });

    test('los estudios filológicos modernos son fuente secundaria — '
        'aportan el marco interpretativo que permite leer las cuatro '
        'fuentes primarias con criterios filológicos consensuados', () {
      final estudios = CatalogoBrechas.brecha31.fuentes
          .firstWhere((f) => f.id == 'estudios_filologicos_plurilinguismo');
      expect(estudios.propiedadesCanonicas.tipo, TipoFuente.secundaria);
    });
  });

  group('CatalogoBrechas.brecha33 — Leyre y la leyenda del abad Virila '
      '(segunda Brecha jugable del Arco 3, debut narrativo pleno de '
      'PH.10 *la fuente como producto de su tiempo*)', () {
    test('id, título, ubicación y flag de completado estables', () {
      expect(CatalogoBrechas.brecha33.id, '3.3');
      expect(
        CatalogoBrechas.brecha33.titulo,
        'Leyre y la leyenda del abad Virila',
      );
      expect(
        CatalogoBrechas.brecha33.ubicacionVisible,
        'LEYRE — MONASTERIO + SCRIPTORIUM',
      );
      expect(
        CatalogoBrechas.brecha33.flagDeCompletado,
        'brecha_3_3_completada',
      );
    });

    test('catálogo: 5 fuentes (3 primarias — códice del s. XIII + listas '
        'de abades + versiones posteriores — y 2 secundarias — contexto '
        'monástico + estudios hagiográficos) y 6 afirmaciones canónicas '
        '— el doc 09 §3.3.4 lista las afirmaciones explícitamente, no '
        'son inferencia del implementador', () {
      expect(CatalogoBrechas.brecha33.fuentes, hasLength(5));
      expect(CatalogoBrechas.brecha33.afirmacionesCanonicas, hasLength(6));
    });

    test('minimoAfirmacionesParaConcilio: 4 — declarar 4 de 6 obliga '
        'a tocar al menos una de las 3 Probables (las inferencias '
        'interpretativas que el oficio sostiene desde el contexto), '
        'que es donde la Brecha ejercita PH.10 en pleno', () {
      expect(
        CatalogoBrechas.brecha33.minimoAfirmacionesParaConcilio,
        4,
      );
    });

    test('distribución pedagógica 3 Sólido + 3 Probable + 0 Disputado '
        '— las tres Sólidas son hechos directamente atestiguados por '
        'las fuentes (el códice del s. XIII existe; el Virila '
        'histórico aparece en listas; la conexión histórico↔legendario '
        'no puede establecerse, *Sólido (la incertidumbre)*); las tres '
        'Probables son las inferencias contextuales del PH.10 (la '
        'leyenda como producto del s. XIII, los trescientos años '
        'significantes, la información sobre la espiritualidad del s. '
        'XIII). La Brecha 3.3 deliberadamente no tiene Disputadas — '
        'el oficio en esta Estación se ejercita en el matiz Probable, '
        'no en la duda metodológica abierta', () {
      final niveles = CatalogoBrechas.brecha33.afirmacionesCanonicas
          .map((a) => a.calibracionCorrecta)
          .toList();
      expect(niveles.where((n) => n == NivelConfianza.solido), hasLength(3));
      expect(niveles.where((n) => n == NivelConfianza.probable), hasLength(3));
      expect(niveles.where((n) => n == NivelConfianza.disputado), hasLength(0));
    });

    test('la afirmación 3 `conexion_virila_historico_legendario` declara '
        'el matiz "Sólido (la incertidumbre)" en el texto — la '
        'imposibilidad de cerrar la conexión es factualmente '
        'atestiguable, y vive en el texto canónico, no como nivel '
        'nuevo del enum (preserva paridad Dart/PHP del core)', () {
      final conexion = CatalogoBrechas.brecha33.afirmacionesCanonicas
          .firstWhere((a) => a.id == 'conexion_virila_historico_legendario');
      expect(conexion.calibracionCorrecta, NivelConfianza.solido);
      expect(conexion.texto, contains('Sólido (la incertidumbre)'));
      expect(conexion.texto, contains('no puede establecerse'));
    });

    test('la afirmación 5 `trescientos_anos_significantes` se declara '
        'Probable — la coincidencia entre los trescientos años del '
        'milagro y los trescientos años entre fundación y redacción '
        'del códice es interpretativa; Joana lo cuestiona '
        'explícitamente en el Concilio (3.3.5) y pide buscar paralelos '
        'en otras leyendas monásticas con cifras simbólicas para '
        'sostenerla más firmemente', () {
      final cifra = CatalogoBrechas.brecha33.afirmacionesCanonicas
          .firstWhere((a) => a.id == 'trescientos_anos_significantes');
      expect(cifra.calibracionCorrecta, NivelConfianza.probable);
      expect(cifra.texto, contains('paralelos'));
      expect(cifra.texto, contains('Joana'));
    });

    test('la afirmación 6 `leyenda_informa_sobre_s_xiii` articula la '
        'lección integradora PH.10 con la cita literal del doc 09 '
        '§3.3.4 — *"La leyenda de Virila no cuenta lo que pasó en el '
        's. IX. Cuenta cómo Leyre del s. XIII se sentía mirando al s. '
        'IX"*', () {
      final pH10 = CatalogoBrechas.brecha33.afirmacionesCanonicas
          .firstWhere((a) => a.id == 'leyenda_informa_sobre_s_xiii');
      expect(pH10.calibracionCorrecta, NivelConfianza.probable);
      expect(
        pH10.texto,
        contains('no cuenta lo que pasó en el s. IX'),
      );
      expect(
        pH10.texto,
        contains('cómo Leyre del s. XIII se sentía mirando al s. IX'),
      );
    });

    test('todas las afirmaciones citan al menos una fuente del '
        'catálogo de la Brecha — ninguna afirmación queda sin '
        'anclaje', () {
      final idsValidos =
          CatalogoBrechas.brecha33.fuentes.map((f) => f.id).toSet();
      for (final afirmacion in CatalogoBrechas.brecha33.afirmacionesCanonicas) {
        expect(
          afirmacion.idsFuentesAnclaje,
          isNotEmpty,
          reason: 'afirmación ${afirmacion.id} sin fuentes',
        );
        for (final idFuente in afirmacion.idsFuentesAnclaje) {
          expect(
            idsValidos,
            contains(idFuente),
            reason:
                'afirmación ${afirmacion.id} cita la fuente $idFuente '
                'pero esa fuente no existe en el catálogo de la Brecha',
          );
        }
      }
    });

    test('habilidades ejercitadas incluyen PH.10 (la fuente como '
        'producto de su tiempo, debut narrativo pleno) + PH.06 '
        '(perspectiva histórica integradora) + HF.10 (detección de '
        'omisiones — el códice no contextualiza su propio momento de '
        'redacción)', () {
      expect(CatalogoBrechas.brecha33.habilidadesEjercitadas,
          contains('PH.10'));
      expect(CatalogoBrechas.brecha33.habilidadesEjercitadas,
          contains('PH.06'));
      expect(CatalogoBrechas.brecha33.habilidadesEjercitadas,
          contains('HF.10'));
    });

    test('el códice del s. XIII de Leyre es fuente primaria — la '
        'fuente principal del oficio en esta Estación, producida en '
        'el propio scriptorium del monasterio en su momento de '
        'declive político relativo', () {
      final codice = CatalogoBrechas.brecha33.fuentes
          .firstWhere((f) => f.id == 'codice_leyenda_virila_s_xiii');
      expect(codice.propiedadesCanonicas.tipo, TipoFuente.primaria);
      expect(codice.tipoVisible, contains('s. XIII'));
      expect(codice.tipoVisible, contains('Virila'));
    });

    test('las listas de abades de Leyre de los s. IX-X son fuente '
        'primaria — material trazable real que ancla la afirmación 2 '
        'sobre la existencia histórica de un abad llamado Virila', () {
      final listas = CatalogoBrechas.brecha33.fuentes
          .firstWhere((f) => f.id == 'listas_abades_leyre_s_ix_x');
      expect(listas.propiedadesCanonicas.tipo, TipoFuente.primaria);
      expect(listas.descripcion, contains('Material trazable real'));
    });

    test('la documentación contextual sobre Leyre en el s. XIII es '
        'fuente secundaria — aporta el marco que permite leer la '
        'leyenda como producto de su tiempo y sostener la afirmación '
        '4 (declive monástico relativo) y la 5 (trescientos años '
        'significantes)', () {
      final contexto = CatalogoBrechas.brecha33.fuentes
          .firstWhere((f) => f.id == 'contexto_monastico_leyre_s_xiii');
      expect(contexto.propiedadesCanonicas.tipo, TipoFuente.secundaria);
    });

    test('los estudios hagiográficos modernos son fuente secundaria — '
        'aportan el marco genérico para leer la leyenda dentro del '
        'género hagiográfico medieval e identificar paralelos '
        'sistemáticos con otras leyendas monásticas (la "Joana '
        'objection" del 3.3.5)', () {
      final hagiograficos = CatalogoBrechas.brecha33.fuentes
          .firstWhere((f) => f.id == 'estudios_hagiograficos_medievales');
      expect(hagiograficos.propiedadesCanonicas.tipo, TipoFuente.secundaria);
    });

    test('las versiones posteriores de la leyenda (s. XV y s. XVII) '
        'son fuente primaria — triangulan con el códice del s. XIII '
        'permitiendo distinguir el núcleo narrativo estable de las '
        'capas de reapropiación devocional añadidas en cada momento '
        '(observancia bajomedieval + Contrarreforma)', () {
      final versiones = CatalogoBrechas.brecha33.fuentes
          .firstWhere((f) => f.id == 'versiones_leyenda_s_xv_xvii');
      expect(versiones.propiedadesCanonicas.tipo, TipoFuente.primaria);
      expect(versiones.tipoVisible, contains('s. XV'));
      expect(versiones.tipoVisible, contains('s. XVII'));
    });
  });

  group('CatalogoBrechas.brecha34 — Roncesvalles (tercera Brecha '
      'jugable del Arco 3, debut de PH.10 ampliado a propaganda '
      'cruzada — la leyenda no sólo desplaza temporalmente como '
      'Virila en la 3.3 sino que reescribe identidades enteras)', () {
    test('id, título, ubicación y flag de completado estables', () {
      expect(CatalogoBrechas.brecha34.id, '3.4');
      expect(CatalogoBrechas.brecha34.titulo, 'Roncesvalles');
      expect(
        CatalogoBrechas.brecha34.ubicacionVisible,
        'RONCESVALLES — COLEGIATA + MESA DE TRABAJO',
      );
      expect(
        CatalogoBrechas.brecha34.flagDeCompletado,
        'brecha_3_4_completada',
      );
    });

    test('catálogo: 5 fuentes (3 carolingias contemporáneas — Vita '
        'Karoli + Annales Regni Francorum + menciones breves — + la '
        'Chanson de Roland h. 1100 como fuente legendaria + estudios '
        'modernos sobre el contexto cruzado) y 8 afirmaciones '
        'canónicas extraídas literalmente del doc 09 §3.4.5', () {
      expect(CatalogoBrechas.brecha34.fuentes, hasLength(5));
      expect(CatalogoBrechas.brecha34.afirmacionesCanonicas, hasLength(8));
    });

    test('minimoAfirmacionesParaConcilio: 5 — declarar 5 de 8 obliga '
        'a tocar al menos una de las 3 Probables (la motivación '
        'vascona del ataque, el contexto cruzado de la sustitución y '
        'la fijación de la memoria popular legendaria), donde el '
        'oficio se ejercita en pleno', () {
      expect(
        CatalogoBrechas.brecha34.minimoAfirmacionesParaConcilio,
        5,
      );
    });

    test('distribución pedagógica 5 Sólido + 3 Probable + 0 Disputado '
        '— los 5 Sólido incluyen el matiz "Sólido como afirmación '
        'metodológica" de la afirmación 8 sobre la distinción evento '
        'del 778 vs Chanson como obra literaria; las 3 Probables son '
        'las inferencias contextuales sobre motivación vascona, '
        'contexto cruzado y fijación de la memoria popular', () {
      final niveles = CatalogoBrechas.brecha34.afirmacionesCanonicas
          .map((a) => a.calibracionCorrecta)
          .toList();
      expect(niveles.where((n) => n == NivelConfianza.solido), hasLength(5));
      expect(niveles.where((n) => n == NivelConfianza.probable), hasLength(3));
      expect(niveles.where((n) => n == NivelConfianza.disputado), hasLength(0));
    });

    test('la afirmación 8 `evento_y_chanson_planos_distintos` declara '
        'el matiz "Sólido como afirmación metodológica" en el texto '
        '— la distinción entre evento del 778 y Chanson como obra '
        'literaria del s. XII es la condición metodológica para '
        'sostener cualquier afirmación; vive en el texto canónico, '
        'no como nivel nuevo del enum (preserva paridad Dart/PHP)',
        () {
      final metodologica = CatalogoBrechas.brecha34.afirmacionesCanonicas
          .firstWhere((a) => a.id == 'evento_y_chanson_planos_distintos');
      expect(metodologica.calibracionCorrecta, NivelConfianza.solido);
      expect(
        metodologica.texto,
        contains('Sólido como afirmación metodológica'),
      );
      expect(
        metodologica.texto,
        contains('honestidad histórica exige no confundirlos'),
      );
    });

    test('la afirmación 5 `sustitucion_refleja_contexto_cruzado` se '
        'declara Probable y articula el corazón pedagógico de la '
        'Brecha — *"propaganda cruzada — no manipulación deliberada, '
        'sino aire respirado"*. Karim la aprueba con énfasis en el '
        'Concilio (3.4.6)', () {
      final cruzado = CatalogoBrechas.brecha34.afirmacionesCanonicas
          .firstWhere((a) => a.id == 'sustitucion_refleja_contexto_cruzado');
      expect(cruzado.calibracionCorrecta, NivelConfianza.probable);
      expect(cruzado.texto, contains('propaganda cruzada'));
      expect(cruzado.texto, contains('aire respirado'));
      expect(cruzado.texto, contains('1095'));
      expect(cruzado.texto, contains('1100'));
    });

    test('las afirmaciones 1, 2, 4 y 6 son Sólido — las 4 Sólidas '
        'directas (no metodológicas): emboscada vascona del 778, '
        'identificación uniforme de los atacantes como vascones por '
        'las fuentes carolingias, sustitución vascones→musulmanes '
        'como núcleo de la Chanson, traición de Ganelón ausente de '
        'fuentes contemporáneas', () {
      final ids = [
        'emboscada_vascona_destruyo_retaguardia',
        'fuentes_carolingias_identifican_vascones',
        'chanson_reescribe_vascones_por_musulmanes',
        'chanson_anade_traicion_ganelon',
      ];
      for (final id in ids) {
        final a = CatalogoBrechas.brecha34.afirmacionesCanonicas
            .firstWhere((af) => af.id == id);
        expect(
          a.calibracionCorrecta,
          NivelConfianza.solido,
          reason: 'la afirmación $id debería ser Sólido',
        );
      }
    });

    test('todas las afirmaciones citan al menos una fuente del '
        'catálogo de la Brecha — ninguna afirmación queda sin '
        'anclaje', () {
      final idsValidos =
          CatalogoBrechas.brecha34.fuentes.map((f) => f.id).toSet();
      for (final afirmacion in CatalogoBrechas.brecha34.afirmacionesCanonicas) {
        expect(
          afirmacion.idsFuentesAnclaje,
          isNotEmpty,
          reason: 'afirmación ${afirmacion.id} sin fuentes',
        );
        for (final idFuente in afirmacion.idsFuentesAnclaje) {
          expect(
            idsValidos,
            contains(idFuente),
            reason:
                'afirmación ${afirmacion.id} cita la fuente $idFuente '
                'pero esa fuente no existe en el catálogo de la Brecha',
          );
        }
      }
    });

    test('habilidades ejercitadas incluyen PH.10 (la fuente como '
        'producto de su tiempo, ahora ampliada a reescritura '
        'completa de identidades para servir a una agenda '
        'contemporánea — propaganda cruzada) + PH.06 + HF.10 '
        '(detección de omisiones — la Chanson borra el contexto '
        'político real y los vascones)', () {
      expect(CatalogoBrechas.brecha34.habilidadesEjercitadas,
          contains('PH.10'));
      expect(CatalogoBrechas.brecha34.habilidadesEjercitadas,
          contains('PH.06'));
      expect(CatalogoBrechas.brecha34.habilidadesEjercitadas,
          contains('HF.10'));
    });

    test('la *Vita Karoli* de Eginardo es fuente primaria — biografía '
        'oficial de Carlomagno escrita en la corte carolingia entre '
        '817 y 836, una generación después del evento; identifica '
        'a los atacantes como vascones sin mención de musulmanes',
        () {
      final vita = CatalogoBrechas.brecha34.fuentes
          .firstWhere((f) => f.id == 'vita_karoli_eginardo');
      expect(vita.propiedadesCanonicas.tipo, TipoFuente.primaria);
      expect(vita.tipoVisible, contains('Eginardo'));
    });

    test('los *Annales Regni Francorum* son fuente primaria — anales '
        'oficiales del reino franco, entrada del 778 con redacción '
        'seca administrativa sin embellecimiento épico, registra la '
        'campaña hispana aliada con Sulayman al-Arabi de Zaragoza',
        () {
      final annales = CatalogoBrechas.brecha34.fuentes
          .firstWhere((f) => f.id == 'annales_regni_francorum');
      expect(annales.propiedadesCanonicas.tipo, TipoFuente.primaria);
      expect(annales.descripcion, contains('Sulayman al-Arabi'));
    });

    test('la *Chanson de Roland* (h. 1100) es fuente primaria — '
        'cantar de gesta del francés antiguo redactado en torno a '
        '1100 en el aire cruzado; reescribe el episodio del 778 '
        'sustituyendo vascones por musulmanes y añadiendo la '
        'traición de Ganelón', () {
      final chanson = CatalogoBrechas.brecha34.fuentes
          .firstWhere((f) => f.id == 'chanson_de_roland_h_1100');
      expect(chanson.propiedadesCanonicas.tipo, TipoFuente.primaria);
      expect(chanson.tipoVisible, contains('h. 1100'));
      expect(chanson.descripcion, contains('propaganda cruzada'));
      expect(chanson.descripcion, contains('aire respirado'));
    });

    test('los estudios modernos sobre la *Chanson* y el contexto '
        'cruzado del s. XI-XII son fuente secundaria — aportan el '
        'marco interpretativo para leer la sustitución '
        'vascones→moros como producto del contexto cruzado y '
        'no como simple corrupción narrativa', () {
      final estudios = CatalogoBrechas.brecha34.fuentes
          .firstWhere((f) => f.id == 'estudios_contexto_cruzado_s_xi_xii');
      expect(estudios.propiedadesCanonicas.tipo, TipoFuente.secundaria);
    });

    test('las menciones breves en otras fuentes carolingias del s. '
        'VIII-IX son fuente primaria — triangulan con la *Vita '
        'Karoli* y los *Annales* sosteniendo la identificación '
        'vascona uniforme y la ausencia de musulmanes entre los '
        'atacantes en todas las fuentes contemporáneas', () {
      final menciones = CatalogoBrechas.brecha34.fuentes
          .firstWhere((f) => f.id == 'menciones_breves_fuentes_carolingias');
      expect(menciones.propiedadesCanonicas.tipo, TipoFuente.primaria);
    });
  });

  group('CatalogoBrechas.brecha35 — Estella en su esplendor (cuarta '
      'y última Brecha jugable implementada del Arco 3, **Brecha de '
      'respiro** sin Disputado, lección del oficio sostenible)', () {
    test('id, título, ubicación y flag de completado estables', () {
      expect(CatalogoBrechas.brecha35.id, '3.5');
      expect(CatalogoBrechas.brecha35.titulo, 'Estella en su esplendor');
      expect(
        CatalogoBrechas.brecha35.ubicacionVisible,
        'ESTELLA — CONJUNTO ROMÁNICO + MESA DE TRABAJO',
      );
      expect(
        CatalogoBrechas.brecha35.flagDeCompletado,
        'brecha_3_5_completada',
      );
    });

    test('catálogo: 4 fuentes (carta puebla de 1090 + documentación '
        'municipal del s. XII + conjunto románico como fuente '
        'material + estudios modernos sobre fundaciones jacobeas '
        'como secundaria) y 6 afirmaciones canónicas extraídas '
        'literalmente del doc 09 §3.5.2', () {
      expect(CatalogoBrechas.brecha35.fuentes, hasLength(4));
      expect(CatalogoBrechas.brecha35.afirmacionesCanonicas, hasLength(6));
    });

    test('minimoAfirmacionesParaConcilio: 4 — Brecha de respiro bien '
        'acotada sin disputa metodológica grande, declarar 4 de 6 '
        'es coherente con la naturaleza serena de la Estación '
        'articulada por Aitor (3.5.3): *"se pueden hacer Brechas '
        'que no acaban contigo"*', () {
      expect(
        CatalogoBrechas.brecha35.minimoAfirmacionesParaConcilio,
        4,
      );
    });

    test('distribución pedagógica 4 Sólido + 2 Probable + **0 '
        'Disputado** — la Brecha 3.5 deliberadamente no tiene '
        'Disputadas ni matices metodológicos especiales, contraste '
        'con las Estaciones anteriores del Arco 3 (3.1 trilingüismo '
        '+ 3.3 leyenda desplazada + 3.4 propaganda cruzada). Las dos '
        'Probables son las inferencias contextuales razonables '
        '(continuidad de la población vasco-romance preexistente + '
        'lectura del esplendor cultural-económico desde los '
        'monumentos)', () {
      final niveles = CatalogoBrechas.brecha35.afirmacionesCanonicas
          .map((a) => a.calibracionCorrecta)
          .toList();
      expect(niveles.where((n) => n == NivelConfianza.solido), hasLength(4));
      expect(niveles.where((n) => n == NivelConfianza.probable), hasLength(2));
      expect(niveles.where((n) => n == NivelConfianza.disputado), hasLength(0));
    });

    test('la afirmación 1 `estella_fundada_1090_carta_puebla` es '
        'Sólido — la pieza fundacional documentada (carta puebla '
        'de Sancho Ramírez de 1090) ancla directamente el hecho de '
        'la fundación', () {
      final fundacion = CatalogoBrechas.brecha35.afirmacionesCanonicas
          .firstWhere((a) => a.id == 'estella_fundada_1090_carta_puebla');
      expect(fundacion.calibracionCorrecta, NivelConfianza.solido);
      expect(fundacion.texto, contains('1090'));
      expect(fundacion.texto, contains('Sancho Ramírez'));
    });

    test('la afirmación 4 `continuidad_poblacion_vasco_romance` se '
        'declara Probable — la presencia preexistente de población '
        'vasco-romance del valle aparece transversalmente en los '
        'registros sin ser tematizada por las fuentes; la '
        'continuidad es inferencia plausible pero no afirmación '
        'directa', () {
      final continuidad = CatalogoBrechas.brecha35.afirmacionesCanonicas
          .firstWhere((a) => a.id == 'continuidad_poblacion_vasco_romance');
      expect(continuidad.calibracionCorrecta, NivelConfianza.probable);
      expect(continuidad.texto, contains('vasco-romance'));
      expect(continuidad.texto, contains('inferencia'));
    });

    test('la afirmación 6 `conjunto_romanico_refleja_esplendor` se '
        'declara Probable — los monumentos (Santo Sepulcro, San '
        'Pedro de la Rúa, palacio de los Reyes, San Miguel) son el '
        'dato sólido, pero leerlos como esplendor económico-'
        'cultural es lectura plausible y no afirmación directa de '
        'la piedra', () {
      final esplendor = CatalogoBrechas.brecha35.afirmacionesCanonicas
          .firstWhere((a) => a.id == 'conjunto_romanico_refleja_esplendor');
      expect(esplendor.calibracionCorrecta, NivelConfianza.probable);
      expect(esplendor.texto, contains('Santo Sepulcro'));
      expect(esplendor.texto, contains('San Pedro de la Rúa'));
      expect(esplendor.texto, contains('palacio de los Reyes'));
      expect(esplendor.texto, contains('San Miguel'));
    });

    test('todas las afirmaciones citan al menos una fuente del '
        'catálogo de la Brecha — ninguna afirmación queda sin '
        'anclaje', () {
      final idsValidos =
          CatalogoBrechas.brecha35.fuentes.map((f) => f.id).toSet();
      for (final afirmacion in CatalogoBrechas.brecha35.afirmacionesCanonicas) {
        expect(
          afirmacion.idsFuentesAnclaje,
          isNotEmpty,
          reason: 'afirmación ${afirmacion.id} sin fuentes',
        );
        for (final idFuente in afirmacion.idsFuentesAnclaje) {
          expect(
            idsValidos,
            contains(idFuente),
            reason:
                'afirmación ${afirmacion.id} cita la fuente $idFuente '
                'pero esa fuente no existe en el catálogo de la Brecha',
          );
        }
      }
    });

    test('habilidades ejercitadas incluyen GH.04 (geografía urbana '
        'y trazado de villa-Camino) — debut de un dominio de habilidad '
        'que no había aparecido jugablemente en el Arco 3 hasta '
        'ahora; HF.07 (plurilingüismo: francos occitano-hablantes '
        '+ vasco-romance preexistente) en uso continuado', () {
      expect(CatalogoBrechas.brecha35.habilidadesEjercitadas,
          contains('GH.04'));
      expect(CatalogoBrechas.brecha35.habilidadesEjercitadas,
          contains('HF.07'));
      expect(CatalogoBrechas.brecha35.habilidadesEjercitadas,
          contains('PH.06'));
    });

    test('la carta puebla de 1090 es fuente primaria — pieza '
        'fundacional documentada otorgada por Sancho Ramírez en el '
        'auge del Camino de Santiago, ancla las 3 primeras '
        'afirmaciones', () {
      final cartaPuebla = CatalogoBrechas.brecha35.fuentes
          .firstWhere((f) => f.id == 'carta_puebla_estella_1090');
      expect(cartaPuebla.propiedadesCanonicas.tipo, TipoFuente.primaria);
      expect(cartaPuebla.tipoVisible, contains('1090'));
      expect(cartaPuebla.tipoVisible, contains('Sancho Ramírez'));
    });

    test('la documentación municipal del s. XII es fuente primaria '
        '— fueros sucesivos + regulaciones del mercado + contratos '
        'de hospederías + ordenanzas de peregrinos y mercaderes; '
        'sostiene la afirmación 5 (economía de ciudad-paso)', () {
      final municipal = CatalogoBrechas.brecha35.fuentes
          .firstWhere((f) => f.id == 'documentacion_municipal_estella_s_xii');
      expect(municipal.propiedadesCanonicas.tipo, TipoFuente.primaria);
      expect(municipal.descripcion, contains('hospederías'));
    });

    test('el conjunto románico de Estella es fuente primaria '
        'material — los cuatro monumentos como evidencia '
        'arquitectónica complementaria a la documentación textual',
        () {
      final conjunto = CatalogoBrechas.brecha35.fuentes
          .firstWhere((f) => f.id == 'conjunto_romanico_estella');
      expect(conjunto.propiedadesCanonicas.tipo, TipoFuente.primaria);
      expect(conjunto.tipoVisible, contains('palacio de los Reyes'));
    });

    test('los estudios modernos sobre las fundaciones del Camino '
        'de Santiago son fuente secundaria — aportan el marco '
        'interpretativo que permite leer la fundación de Estella '
        'como caso del patrón general villa-Camino del s. XI-XII '
        '(Estella, Logroño, Sangüesa, Puente la Reina, Pamplona-'
        'San Cernin)', () {
      final estudios = CatalogoBrechas.brecha35.fuentes
          .firstWhere((f) => f.id == 'estudios_fundaciones_camino_santiago');
      expect(estudios.propiedadesCanonicas.tipo, TipoFuente.secundaria);
      expect(estudios.descripcion, contains('Logroño'));
      expect(estudios.descripcion, contains('Puente la Reina'));
    });
  });
}
