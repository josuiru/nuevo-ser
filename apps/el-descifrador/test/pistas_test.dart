// Tests de PistasPedidas (modelo), RepositorioPistas (persistencia) y
// ServicioPistas (lógica de respuesta del maestro).

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:el_descifrador/datos/repositorio_pistas.dart';
import 'package:el_descifrador/dominio/decision_documento.dart';
import 'package:el_descifrador/dominio/habilidad_atomica.dart';
import 'package:el_descifrador/dominio/lengua.dart';
import 'package:el_descifrador/dominio/operacion_descifrador.dart';
import 'package:el_descifrador/dominio/pieza_corpus.dart';
import 'package:el_descifrador/dominio/pistas_pedidas.dart';
import 'package:el_descifrador/dominio/servicio_pistas.dart';
import 'package:el_descifrador/dominio/vocabulario_jugador.dart';
import 'package:el_descifrador/dominio/voz_remitente.dart';

PiezaCorpus _piezaTest({
  required String id,
  required VozRemitente? remitente,
  required String texto,
  Lengua lenguaPrincipal = Lengua.portugues,
  Map<String, String> glosario = const {},
}) {
  return PiezaCorpus(
    id: id,
    tipo: TipoPieza.carta,
    remitenteRecurrente: remitente,
    remitenteTextoLibre: remitente?.identificadorTecnico ?? 'voz-puntual',
    destinatario: 'oficina',
    lenguaPrincipal: lenguaPrincipal,
    lenguasInfiltradas: const [],
    ocasion: 'Test',
    habilidadesAtomicas: {HabilidadAtomica.b6LecturaAsistidaPortugues},
    operacionCentral: OperacionDescifrador.proponer,
    dificultad: 2,
    decisionesValidas: {DecisionDocumento.archivar},
    soporte: SoporteFisico.desdeMapa(const {}),
    crucesConCorpus: const [],
    textoDocumento: texto,
    estadoValidacion: EstadoValidacion.borrador,
    glosario: glosario,
  );
}

void main() {
  group('PistasPedidas', () {
    test('estado inicial: vacío', () {
      final pistas = PistasPedidas.inicial();
      expect(pistas.vacio, isTrue);
      expect(
        pistas.nivelesPedidos(idPieza: 'p1', palabra: 'bacalhau'),
        isEmpty,
      );
    });

    test('registrar pista normaliza la palabra', () {
      final pistas = PistasPedidas.inicial().conPista(
        idPieza: 'p1',
        palabra: 'Bacalhau,',
        nivel: NivelPista.tono,
        ahora: DateTime.utc(2026, 5, 13),
      );
      // Búsqueda con forma distinta debe encontrarla.
      expect(
        pistas.nivelesPedidos(idPieza: 'p1', palabra: 'BACALHAU'),
        {NivelPista.tono},
      );
    });

    test('múltiples niveles sobre la misma palabra', () {
      var pistas = PistasPedidas.inicial();
      pistas = pistas.conPista(
        idPieza: 'p1',
        palabra: 'bacalhau',
        nivel: NivelPista.tono,
        ahora: DateTime.utc(2026, 5, 13),
      );
      pistas = pistas.conPista(
        idPieza: 'p1',
        palabra: 'bacalhau',
        nivel: NivelPista.traduccion,
        ahora: DateTime.utc(2026, 5, 14),
      );
      expect(
        pistas.nivelesPedidos(idPieza: 'p1', palabra: 'bacalhau'),
        {NivelPista.tono, NivelPista.traduccion},
      );
    });

    test('palabrasConPistaEn devuelve solo de esa pieza', () {
      var pistas = PistasPedidas.inicial();
      pistas = pistas.conPista(
        idPieza: 'p1',
        palabra: 'bacalhau',
        nivel: NivelPista.tono,
        ahora: DateTime.utc(2026, 5, 13),
      );
      pistas = pistas.conPista(
        idPieza: 'p2',
        palabra: 'azeite',
        nivel: NivelPista.tono,
        ahora: DateTime.utc(2026, 5, 13),
      );
      expect(pistas.palabrasConPistaEn('p1'), {'bacalhau'});
      expect(pistas.palabrasConPistaEn('p2'), {'azeite'});
    });

    test('serialización ida y vuelta preserva contenido', () {
      var pistas = PistasPedidas.inicial();
      pistas = pistas.conPista(
        idPieza: 'p1',
        palabra: 'bacalhau',
        nivel: NivelPista.tono,
        ahora: DateTime.utc(2026, 5, 13),
      );
      pistas = pistas.conPista(
        idPieza: 'p1',
        palabra: 'bacalhau',
        nivel: NivelPista.traduccion,
        ahora: DateTime.utc(2026, 5, 14),
      );
      final reconstruido = PistasPedidas.deserializar(pistas.serializar());
      expect(
        reconstruido.nivelesPedidos(idPieza: 'p1', palabra: 'bacalhau'),
        {NivelPista.tono, NivelPista.traduccion},
      );
    });

    test('deserialización tolera nivel y formato desconocidos', () {
      final mapaConBasura = {
        'p1': {
          'bacalhau': {
            'tono': '2026-05-13T00:00:00.000Z',
            'inexistente': '2026-05-13T00:00:00.000Z',
          },
          'rota': 'no es un mapa',
        },
        'p2': 42,
      };
      final pistas = PistasPedidas.deserializar(mapaConBasura);
      expect(
        pistas.nivelesPedidos(idPieza: 'p1', palabra: 'bacalhau'),
        {NivelPista.tono},
      );
      expect(pistas.palabrasConPistaEn('p2'), isEmpty);
    });
  });

  group('RepositorioPistas', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('perfil nuevo: cargar devuelve vacío', () async {
      final repo = RepositorioPistas(idPerfil: 'test-1');
      final pistas = await repo.cargar();
      expect(pistas.vacio, isTrue);
    });

    test('registrarPista persiste y se recupera', () async {
      final fechaFalsa = DateTime.utc(2026, 5, 13);
      final repo = RepositorioPistas(
        idPerfil: 'test-2',
        relojInyectado: () => fechaFalsa,
      );
      await repo.registrarPista(
        idPieza: 'p1',
        palabra: 'bacalhau',
        nivel: NivelPista.tono,
      );

      final repoReabierto = RepositorioPistas(idPerfil: 'test-2');
      final pistas = await repoReabierto.cargar();
      expect(
        pistas.nivelesPedidos(idPieza: 'p1', palabra: 'bacalhau'),
        {NivelPista.tono},
      );
    });

    test('perfiles distintos no se contaminan', () async {
      final ana = RepositorioPistas(idPerfil: 'ana');
      final luis = RepositorioPistas(idPerfil: 'luis');
      await ana.registrarPista(
        idPieza: 'p1',
        palabra: 'bacalhau',
        nivel: NivelPista.tono,
      );
      final pistasAna = await ana.cargar();
      final pistasLuis = await luis.cargar();
      expect(pistasAna.vacio, isFalse);
      expect(pistasLuis.vacio, isTrue);
    });
  });

  group('ServicioPistas — pista de tono', () {
    const servicio = ServicioPistas();

    test('palabra ya marcada en vocabulario: maestro dirige al cuaderno', () {
      final pieza = _piezaTest(
        id: 'p1',
        remitente: VozRemitente.inesCocineraLisboa,
        texto: 'Texto cualquiera con bacalhau dentro.',
      );
      final vocabulario = VocabularioJugador.inicial().conPalabraMarcada(
        lengua: Lengua.portugues,
        palabra: 'bacalhau',
        marca: const MarcaPalabra(color: MarcaColor.verde),
      );

      final respuesta = servicio.responder(
        nivel: NivelPista.tono,
        piezaActual: pieza,
        palabraOriginal: 'bacalhau',
        vocabulario: vocabulario,
        piezasResueltas: const [],
      );
      expect(respuesta.nivel, NivelPista.tono);
      expect(respuesta.texto.toLowerCase(), contains('cuaderno'));
    });

    test('palabra nunca tocada: maestro devuelve la búsqueda al niño', () {
      final pieza = _piezaTest(
        id: 'p1',
        remitente: VozRemitente.inesCocineraLisboa,
        texto: 'Texto cualquiera.',
      );

      final respuesta = servicio.responder(
        nivel: NivelPista.tono,
        piezaActual: pieza,
        palabraOriginal: 'desconocida',
        vocabulario: VocabularioJugador.inicial(),
        piezasResueltas: const [],
      );
      expect(respuesta.texto.toLowerCase(), contains('contexto'));
    });
  });

  group('ServicioPistas — pista de comparación', () {
    const servicio = ServicioPistas();

    test('encuentra pieza paralela del mismo remitente', () {
      final actual = _piezaTest(
        id: 'p1',
        remitente: VozRemitente.inesCocineraLisboa,
        texto: 'Caro João, manda-me bacalhau.',
      );
      final paralela = _piezaTest(
        id: 'p2',
        remitente: VozRemitente.inesCocineraLisboa,
        texto: 'O bacalhau de hoje saiu seco.',
      );

      final respuesta = servicio.responder(
        nivel: NivelPista.comparacion,
        piezaActual: actual,
        palabraOriginal: 'bacalhau',
        vocabulario: VocabularioJugador.inicial(),
        piezasResueltas: [paralela],
      );
      expect(respuesta.piezaParalela?.id, 'p2');
    });

    test('sin pieza paralela: maestro pide releer el contexto', () {
      final actual = _piezaTest(
        id: 'p1',
        remitente: VozRemitente.inesCocineraLisboa,
        texto: 'Texto cualquiera.',
      );
      final respuesta = servicio.responder(
        nivel: NivelPista.comparacion,
        piezaActual: actual,
        palabraOriginal: 'palabra-sola',
        vocabulario: VocabularioJugador.inicial(),
        piezasResueltas: const [],
      );
      expect(respuesta.piezaParalela, isNull);
      expect(respuesta.texto.toLowerCase(), contains('contexto'));
    });

    test('palabra suelta no debe matchear como substring', () {
      // "azeite" no debe matchear "azeiteiro" (otra palabra que la
      // contiene como prefijo).
      final actual = _piezaTest(
        id: 'p1',
        remitente: VozRemitente.inesCocineraLisboa,
        texto: 'Bom.',
      );
      final paralelaQueContieneSubcadena = _piezaTest(
        id: 'p2',
        remitente: VozRemitente.inesCocineraLisboa,
        texto: 'Falamos com o azeiteiro do porto.',
      );
      final respuesta = servicio.responder(
        nivel: NivelPista.comparacion,
        piezaActual: actual,
        palabraOriginal: 'azeite',
        vocabulario: VocabularioJugador.inicial(),
        piezasResueltas: [paralelaQueContieneSubcadena],
      );
      expect(respuesta.piezaParalela, isNull);
    });
  });

  group('ServicioPistas — pista de traducción', () {
    const servicio = ServicioPistas();

    test('palabra en glosario: maestro la traduce', () {
      final pieza = _piezaTest(
        id: 'p1',
        remitente: VozRemitente.inesCocineraLisboa,
        texto: 'Caro João, bacalhau.',
        glosario: const {'bacalhau': 'bacalao'},
      );
      final respuesta = servicio.responder(
        nivel: NivelPista.traduccion,
        piezaActual: pieza,
        palabraOriginal: 'Bacalhau,',
        vocabulario: VocabularioJugador.inicial(),
        piezasResueltas: const [],
      );
      expect(respuesta.texto, contains('bacalao'));
      expect(respuesta.texto, contains('bacalhau'));
    });

    test('palabra fuera del glosario: maestro devuelve al niño', () {
      final pieza = _piezaTest(
        id: 'p1',
        remitente: VozRemitente.inesCocineraLisboa,
        texto: 'Caro.',
        glosario: const {'bacalhau': 'bacalao'},
      );
      final respuesta = servicio.responder(
        nivel: NivelPista.traduccion,
        piezaActual: pieza,
        palabraOriginal: 'sardinha',
        vocabulario: VocabularioJugador.inicial(),
        piezasResueltas: const [],
      );
      expect(respuesta.texto.toLowerCase(), contains('contexto'));
    });
  });

  group('PiezaCorpus — glosario opcional', () {
    test('PiezaCorpus.desdeMapa parsea glosario si está', () {
      final mapa = <String, dynamic>{
        'id': 'p1',
        'tipo': 'carta',
        'remitente': 'ines_cocinera_lisboa',
        'destinatario': 'oficina',
        'lengua_principal': 'pt',
        'lenguas_infiltradas': <String>[],
        'ocasion': 'Test',
        'habilidades_atomicas': <String>['B6'],
        'operacion_central': 'proponer',
        'dificultad': 2,
        'decisiones_validas': <String>['archivar'],
        'soporte': <String, dynamic>{},
        'cruces_con_corpus': <String>[],
        'texto_documento': 'Texto.',
        'estado_validacion': 'borrador',
        'glosario': <String, dynamic>{
          'Bacalhau': 'bacalao',
          'embaraçada': 'avergonzada',
        },
      };
      final pieza = PiezaCorpus.desdeMapa(mapa);
      // Normalización: las claves se almacenan en minúscula.
      expect(pieza.glosario['bacalhau'], 'bacalao');
      expect(pieza.glosario['embaraçada'], 'avergonzada');
    });

    test('PiezaCorpus.desdeMapa funciona sin glosario', () {
      final mapa = <String, dynamic>{
        'id': 'p1',
        'tipo': 'carta',
        'remitente': 'ines_cocinera_lisboa',
        'destinatario': 'oficina',
        'lengua_principal': 'pt',
        'lenguas_infiltradas': <String>[],
        'ocasion': 'Test',
        'habilidades_atomicas': <String>['B6'],
        'operacion_central': 'proponer',
        'dificultad': 2,
        'decisiones_validas': <String>['archivar'],
        'soporte': <String, dynamic>{},
        'cruces_con_corpus': <String>[],
        'texto_documento': 'Texto.',
        'estado_validacion': 'borrador',
      };
      final pieza = PiezaCorpus.desdeMapa(mapa);
      expect(pieza.glosario, isEmpty);
    });
  });
}
