// Tests unitarios de los modelos de dominio.
//
// Verifican el parseo de enums desde identificadores del JSON del
// corpus. Si una pieza del corpus llega con un identificador que no
// está en estos enums, el parseo lanza ArgumentError — esos errores
// se capturan en el CargadorCorpus y se reportan, no rompen la app.
//
// Pero los enums en sí deben ser sólidos. Estos tests aseguran que
// los identificadores canónicos del paquete documental están todos.

import 'package:flutter_test/flutter_test.dart';
import 'package:el_descifrador/dominio/decision_documento.dart';
import 'package:el_descifrador/dominio/habilidad_atomica.dart';
import 'package:el_descifrador/dominio/lengua.dart';
import 'package:el_descifrador/dominio/operacion_descifrador.dart';
import 'package:el_descifrador/dominio/voz_remitente.dart';

void main() {
  group('Lengua', () {
    test('parsea las cuatro cooficiales desde código ISO', () {
      expect(Lengua.desdeCodigo('es'), Lengua.castellano);
      expect(Lengua.desdeCodigo('eu'), Lengua.euskara);
      expect(Lengua.desdeCodigo('ca'), Lengua.catalan);
      expect(Lengua.desdeCodigo('gl'), Lengua.gallego);
    });

    test('parsea las L2 europeas y latín', () {
      expect(Lengua.desdeCodigo('pt'), Lengua.portugues);
      expect(Lengua.desdeCodigo('fr'), Lengua.frances);
      expect(Lengua.desdeCodigo('it'), Lengua.italiano);
      expect(Lengua.desdeCodigo('en'), Lengua.ingles);
      expect(Lengua.desdeCodigo('de'), Lengua.aleman);
      expect(Lengua.desdeCodigo('la'), Lengua.latin);
    });

    test('parsea variantes operativas internas (arcaico, americano)', () {
      expect(Lengua.desdeCodigo('es_arcaico'), Lengua.castellanoArcaico);
      expect(Lengua.desdeCodigo('es_americano'), Lengua.castellanoAmericano);
    });

    test('parsea árabe como caso especial', () {
      expect(Lengua.desdeCodigo('ar'), Lengua.arabe);
      expect(
        Lengua.arabe.descifrablePlenamente,
        false,
        reason: 'Biblia §2.10: árabe se identifica, no se descifra pleno.',
      );
    });

    test('lanza ArgumentError para lengua desconocida', () {
      expect(
        () => Lengua.desdeCodigo('zz'),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('las cuatro cooficiales son el conjunto declarado', () {
      expect(Lengua.cooficialesPeninsulares.length, 4);
      expect(
        Lengua.cooficialesPeninsulares,
        containsAll([
          Lengua.castellano,
          Lengua.euskara,
          Lengua.catalan,
          Lengua.gallego,
        ]),
      );
    });
  });

  group('VozRemitente', () {
    test('los ocho remitentes recurrentes están declarados', () {
      expect(VozRemitente.values.length, 8);
    });

    test('parsea desde identificador snake_case', () {
      expect(
        VozRemitente.desdeIdentificador('ines_cocinera_lisboa'),
        VozRemitente.inesCocineraLisboa,
      );
      expect(
        VozRemitente.desdeIdentificador('anton_maestro_oficina'),
        VozRemitente.antonMaestroOficina,
      );
      expect(
        VozRemitente.desdeIdentificador('aitziber_maestra_oficina'),
        VozRemitente.aitziberMaestraOficina,
      );
    });

    test('devuelve null para remitente no recurrente', () {
      expect(
        VozRemitente.desdeIdentificador('vecino_anonimo_muelle'),
        isNull,
      );
    });
  });

  group('OperacionDescifrador', () {
    test('parsea las seis operaciones de mecánica nuclear §3', () {
      expect(
        OperacionDescifrador.desdeIdentificador('identificar'),
        OperacionDescifrador.identificar,
      );
      expect(
        OperacionDescifrador.desdeIdentificador('marcar'),
        OperacionDescifrador.marcar,
      );
      expect(
        OperacionDescifrador.desdeIdentificador('anotar'),
        OperacionDescifrador.anotar,
      );
      expect(
        OperacionDescifrador.desdeIdentificador('proponer'),
        OperacionDescifrador.proponer,
      );
      expect(
        OperacionDescifrador.desdeIdentificador('verificar'),
        OperacionDescifrador.verificar,
      );
      expect(
        OperacionDescifrador.desdeIdentificador('decidir'),
        OperacionDescifrador.decidir,
      );
    });

    test('tolera operaciones compuestas del catálogo de muestra', () {
      // Algunas piezas del catálogo seminal v0.1 traen operaciones
      // compuestas como "interpretar_y_decidir". El parseo coge la
      // primera (que en este caso falla porque "interpretar" no es de
      // las seis — pero los JSON reales del corpus usan las seis
      // estrictas). Probamos con "verificar_y_decidir" como caso real.
      expect(
        OperacionDescifrador.desdeIdentificador('verificar_y_decidir'),
        OperacionDescifrador.verificar,
      );
    });

    test('lanza ArgumentError para operación desconocida', () {
      expect(
        () => OperacionDescifrador.desdeIdentificador('inventarse'),
        throwsA(isA<ArgumentError>()),
      );
    });
  });

  group('DecisionDocumento', () {
    test('parsea las cinco decisiones de mecánica nuclear §3.6', () {
      expect(
        DecisionDocumento.desdeIdentificador('archivar'),
        DecisionDocumento.archivar,
      );
      expect(
        DecisionDocumento.desdeIdentificador('devolver'),
        DecisionDocumento.devolverAlRemitente,
      );
      expect(
        DecisionDocumento.desdeIdentificador('entregar'),
        DecisionDocumento.entregarAlDestinatario,
      );
      expect(
        DecisionDocumento.desdeIdentificador('publicar'),
        DecisionDocumento.publicarEnBoletin,
      );
      expect(
        DecisionDocumento.desdeIdentificador('esperar'),
        DecisionDocumento.esperar,
      );
    });
  });

  group('HabilidadAtomica', () {
    test('cuatro dominios + transversales: 36 + 5 = 41 habilidades', () {
      expect(
        HabilidadAtomica.values.length,
        41,
        reason:
            'Mapa v0.1 declara 36 atómicas (10A + 10B + 10C + 6D) + 5T '
            'según doc 04. Si cambia el mapa, asesor pedagógico firma.',
      );
    });

    test('cada habilidad expone su dominio (primera letra)', () {
      expect(HabilidadAtomica.a1ReconocimientoMarcadoresOrtograficos.dominio, 'A');
      expect(HabilidadAtomica.b3FalsosAmigos.dominio, 'B');
      expect(HabilidadAtomica.c5DecisionCivil.dominio, 'C');
      expect(HabilidadAtomica.d5TitularBoletin.dominio, 'D');
      expect(HabilidadAtomica.t1Metaconocimiento.dominio, 'T');
    });

    test('parsea identificadores cortos del catálogo (A1, B3, C5...)', () {
      expect(
        HabilidadAtomica.desdeIdentificador('A1'),
        HabilidadAtomica.a1ReconocimientoMarcadoresOrtograficos,
      );
      expect(
        HabilidadAtomica.desdeIdentificador('B3'),
        HabilidadAtomica.b3FalsosAmigos,
      );
      expect(
        HabilidadAtomica.desdeIdentificador('T2'),
        HabilidadAtomica.t2Persistencia,
      );
    });
  });
}
