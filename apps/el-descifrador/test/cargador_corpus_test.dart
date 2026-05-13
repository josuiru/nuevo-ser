// Tests del cargador de corpus.
//
// Verifican que las dos piezas que vienen empaquetadas en assets se
// cargan correctamente y que el cargador es robusto frente a piezas
// individuales rotas.

import 'package:flutter_test/flutter_test.dart';
import 'package:el_descifrador/datos/cargador_corpus.dart';
import 'package:el_descifrador/dominio/decision_documento.dart';
import 'package:el_descifrador/dominio/habilidad_atomica.dart';
import 'package:el_descifrador/dominio/lengua.dart';
import 'package:el_descifrador/dominio/operacion_descifrador.dart';
import 'package:el_descifrador/dominio/pieza_corpus.dart';
import 'package:el_descifrador/dominio/voz_remitente.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('CargadorCorpus', () {
    test('carga las dos piezas empaquetadas en v0.1.0', () async {
      final cargador = CargadorCorpus();
      final resultado = await cargador.cargarTodo();

      expect(resultado.aciertos, 2);
      expect(resultado.fallos, 0);
      expect(resultado.cargaSuficientementeSana, true);
    });

    test('la carta de Inês se parsea con todos los campos correctos', () async {
      final cargador = CargadorCorpus();
      final resultado = await cargador.cargarTodo();

      final ines = resultado.piezasCargadas.firstWhere(
        (pieza) => pieza.id == 'carta-ines-bacalao-001',
      );

      expect(ines.tipo, TipoPieza.carta);
      expect(ines.remitenteRecurrente, VozRemitente.inesCocineraLisboa);
      expect(ines.lenguaPrincipal, Lengua.portugues);
      expect(ines.lenguasInfiltradas, contains(Lengua.castellano));
      expect(ines.operacionCentral, OperacionDescifrador.proponer);
      expect(ines.dificultad, 2);
      expect(
        ines.habilidadesAtomicas,
        containsAll([
          HabilidadAtomica.b6LecturaAsistidaPortugues,
          HabilidadAtomica.b3FalsosAmigos,
          HabilidadAtomica.a10LexicoTecnicoPorDominio,
          HabilidadAtomica.a5Registro,
          HabilidadAtomica.a9Inferencia,
          HabilidadAtomica.c5DecisionCivil,
        ]),
      );
      expect(
        ines.decisionesValidas,
        containsAll([
          DecisionDocumento.entregarAlDestinatario,
          DecisionDocumento.archivar,
          DecisionDocumento.publicarEnBoletin,
        ]),
      );
      expect(ines.textoDocumento, contains('embaraçada'));
      expect(ines.estadoValidacion, EstadoValidacion.borradorClaudePendienteHumano);
      expect(
        ines.listaParaProduccion,
        false,
        reason: 'Pendiente de validación lingüística humana — '
            'NO se sirve al niño en producción.',
      );
    });

    test('la nota del compañero Niko es voz puntual no recurrente', () async {
      final cargador = CargadorCorpus();
      final resultado = await cargador.cargarTodo();

      final niko = resultado.piezasCargadas.firstWhere(
        (pieza) => pieza.id == 'nota-companero-aprendiz-026',
      );

      expect(
        niko.remitenteRecurrente,
        isNull,
        reason: 'Niko es el compañero aprendiz, voz puntual — no entra '
            'en los ocho remitentes recurrentes declarados.',
      );
      expect(niko.remitenteTextoLibre, 'aprendiz-companero-niko');
      expect(niko.lenguaPrincipal, Lengua.euskara);
      expect(niko.operacionCentral, OperacionDescifrador.identificar);
      expect(niko.textoDocumento, contains('Lagundu didezu'));
    });

    test('ningún pieza está marcada como lista para producción en v0.1', () async {
      final cargador = CargadorCorpus();
      final resultado = await cargador.cargarTodo();

      final paraProduccion = CargadorCorpus.soloProduccion(
        resultado.piezasCargadas,
      );

      expect(
        paraProduccion.length,
        0,
        reason:
            'En v0.1.0 todas las piezas son borradores Claude pendientes de '
            'validación humana. Si esto cambia, hay que actualizar el test '
            'con las piezas validadas.',
      );
    });
  });
}
