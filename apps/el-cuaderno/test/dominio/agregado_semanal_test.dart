import 'package:el_cuaderno/dominio/agregado_semanal.dart';
import 'package:el_cuaderno/dominio/nivel_confianza.dart';
import 'package:el_cuaderno/dominio/observacion.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Observacion observacionDe({
    required String id,
    required DateTime cuandoOcurrio,
    NivelConfianza confianza = NivelConfianza.hipotesisActiva,
    String? misterioId,
    String? sitSpotId,
  }) {
    return Observacion(
      id: id,
      cuandoCreada: cuandoOcurrio,
      cuandoOcurrio: cuandoOcurrio,
      dondeNombre: 'cualquier sitio',
      queVio: 'algo',
      confianza: confianza,
      misterioId: misterioId,
      sitSpotId: sitSpotId,
    );
  }

  group('computarAgregadoSemanal — counts', () {
    test('lista vacía produce ceros', () {
      final agregado = computarAgregadoSemanal(
        const [],
        semanaPivote: DateTime(2026, 4, 30),
        regionCode: 'ES-NA-PA',
      );
      expect(agregado.observacionesTotal, 0);
      expect(agregado.observacionesPorMisterio, isEmpty);
      expect(agregado.observacionesPorConfianza, isEmpty);
      expect(agregado.sitSpotVisitas, 0);
      expect(agregado.misteriosDistintos, 0);
    });

    test('cuenta solo las observaciones de la semana del pivote', () {
      // Pivote: jueves 30 abril 2026.
      // Semana ISO 18: lunes 27 abril → domingo 3 mayo.
      final pivote = DateTime(2026, 4, 30, 12, 0);
      final observaciones = [
        // Dentro: lunes 27.
        observacionDe(id: 'a', cuandoOcurrio: DateTime(2026, 4, 27, 10, 0)),
        // Dentro: domingo 3 mayo.
        observacionDe(id: 'b', cuandoOcurrio: DateTime(2026, 5, 3, 18, 0)),
        // Fuera: domingo 26 abril (víspera de la semana).
        observacionDe(id: 'c', cuandoOcurrio: DateTime(2026, 4, 26, 23, 59)),
        // Fuera: lunes 4 mayo (siguiente semana).
        observacionDe(id: 'd', cuandoOcurrio: DateTime(2026, 5, 4, 0, 1)),
      ];
      final agregado = computarAgregadoSemanal(
        observaciones,
        semanaPivote: pivote,
      );
      expect(agregado.observacionesTotal, 2);
    });

    test('reparto por misterio agrega y cuenta distintos', () {
      final pivote = DateTime(2026, 4, 30);
      final observaciones = [
        observacionDe(
          id: '1',
          cuandoOcurrio: DateTime(2026, 4, 27),
          misterioId: 'MIST.AVES.GOLONDRINAS_OTONO',
        ),
        observacionDe(
          id: '2',
          cuandoOcurrio: DateTime(2026, 4, 28),
          misterioId: 'MIST.AVES.GOLONDRINAS_OTONO',
        ),
        observacionDe(
          id: '3',
          cuandoOcurrio: DateTime(2026, 4, 29),
          misterioId: 'MIST.PLANTAS.ALMENDRO',
        ),
        // Sin misterio anclado: no cuenta.
        observacionDe(id: '4', cuandoOcurrio: DateTime(2026, 4, 30)),
      ];
      final agregado = computarAgregadoSemanal(
        observaciones,
        semanaPivote: pivote,
      );
      expect(agregado.observacionesTotal, 4);
      expect(agregado.observacionesPorMisterio, {
        'MIST.AVES.GOLONDRINAS_OTONO': 2,
        'MIST.PLANTAS.ALMENDRO': 1,
      });
      expect(agregado.misteriosDistintos, 2);
    });

    test('reparto por confianza usa enum.name', () {
      final pivote = DateTime(2026, 4, 30);
      final observaciones = [
        observacionDe(
          id: '1',
          cuandoOcurrio: DateTime(2026, 4, 27),
          confianza: NivelConfianza.hipotesisActiva,
        ),
        observacionDe(
          id: '2',
          cuandoOcurrio: DateTime(2026, 4, 28),
          confianza: NivelConfianza.noSegura,
        ),
        observacionDe(
          id: '3',
          cuandoOcurrio: DateTime(2026, 4, 29),
          confianza: NivelConfianza.hipotesisActiva,
        ),
      ];
      final agregado = computarAgregadoSemanal(
        observaciones,
        semanaPivote: pivote,
      );
      expect(agregado.observacionesPorConfianza, {
        'hipotesisActiva': 2,
        'noSegura': 1,
      });
    });

    test('cuenta visitas al sit spot por sitSpotId no nulo', () {
      final pivote = DateTime(2026, 4, 30);
      final observaciones = [
        observacionDe(
          id: '1',
          cuandoOcurrio: DateTime(2026, 4, 27),
          sitSpotId: 'sp-roble',
        ),
        observacionDe(
          id: '2',
          cuandoOcurrio: DateTime(2026, 4, 28),
          sitSpotId: 'sp-roble',
        ),
        observacionDe(id: '3', cuandoOcurrio: DateTime(2026, 4, 29)),
      ];
      final agregado = computarAgregadoSemanal(
        observaciones,
        semanaPivote: pivote,
      );
      expect(agregado.sitSpotVisitas, 2);
    });
  });

  group('computarAgregadoSemanal — isoWeek', () {
    test('jueves 30 abril 2026 → 2026-W18', () {
      final agregado = computarAgregadoSemanal(
        const [],
        semanaPivote: DateTime(2026, 4, 30),
      );
      expect(agregado.isoWeek, '2026-W18');
    });

    test('lunes 28 dic 2026 → 2026-W53 (año ISO con 53 semanas)', () {
      final agregado = computarAgregadoSemanal(
        const [],
        semanaPivote: DateTime(2026, 12, 28),
      );
      expect(agregado.isoWeek, '2026-W53');
    });

    test('1 enero 2027 cae en semana del 2026 (ISO)', () {
      // 1 ene 2027 es viernes; la semana ISO va de lun 28 dic 2026 a
      // dom 3 ene 2027 — semana 53 de 2026.
      final agregado = computarAgregadoSemanal(
        const [],
        semanaPivote: DateTime(2027, 1, 1),
      );
      expect(agregado.isoWeek, '2026-W53');
    });

    test('formato pad-left a 2 dígitos: enero → W01..W04', () {
      // Lunes 5 ene 2026 → semana W02 (porque la W01 es la del 1 ene).
      final agregado = computarAgregadoSemanal(
        const [],
        semanaPivote: DateTime(2026, 1, 5),
      );
      expect(agregado.isoWeek, startsWith('2026-W'));
      expect(agregado.isoWeek.length, 8);
    });
  });

  group('AgregadoSemanal.aJson', () {
    test('serializa solo metadatos — sin texto libre', () {
      final pivote = DateTime(2026, 4, 30);
      final agregado = computarAgregadoSemanal(
        [
          observacionDe(
            id: '1',
            cuandoOcurrio: DateTime(2026, 4, 27),
            misterioId: 'MIST.AVES.GOLONDRINAS_OTONO',
            sitSpotId: 'sp-roble',
          ),
        ],
        semanaPivote: pivote,
        regionCode: 'ES-NA-PA',
      );
      final json = agregado.aJson();
      expect(json['iso_week'], '2026-W18');
      expect(json['region_code'], 'ES-NA-PA');
      expect(json['observaciones_total'], 1);
      expect(json['observaciones_por_misterio'],
          {'MIST.AVES.GOLONDRINAS_OTONO': 1});
      expect(json['observaciones_por_confianza'], {'hipotesisActiva': 1});
      expect(json['sit_spot_visitas'], 1);
      expect(json['misterios_distintos'], 1);
      // Frontera de privacidad: sin queVio, sin coordenadas, sin foto.
      expect(json.containsKey('que_vio'), isFalse);
      expect(json.containsKey('queVio'), isFalse);
      expect(json.containsKey('lat'), isFalse);
      expect(json.containsKey('lng'), isFalse);
    });
  });

  group('preguntaParaLaCenaOffline — voz del cuidador', () {
    AgregadoSemanal agregadoCon({
      int observaciones = 0,
      int misterios = 0,
      int sitSpot = 0,
    }) {
      return AgregadoSemanal(
        isoWeek: '2026-W18',
        regionCode: 'ES-NA-PA',
        observacionesTotal: observaciones,
        observacionesPorMisterio: {
          for (var indice = 0; indice < misterios; indice++) 'MIST.X$indice': 1,
        },
        observacionesPorConfianza: const {},
        sitSpotVisitas: sitSpot,
        misteriosDistintos: misterios,
      );
    }

    test('semana sin observaciones: invita a volver a mirar el lugar', () {
      final pregunta = preguntaParaLaCenaOffline(agregadoCon());
      expect(pregunta, contains('descansó'));
      expect(pregunta, contains('lugar'));
    });

    test('observaciones sin misterio ni sit spot: pregunta abierta', () {
      final pregunta = preguntaParaLaCenaOffline(
        agregadoCon(observaciones: 3),
      );
      expect(pregunta, contains('cosa pequeña'));
    });

    test('volvió al sit spot, sin misterios: pregunta sobre el lugar', () {
      final pregunta = preguntaParaLaCenaOffline(
        agregadoCon(observaciones: 3, sitSpot: 2),
      );
      expect(pregunta, contains('lugar de regreso'));
    });

    test('un solo misterio: pregunta acotada a esa pregunta', () {
      final pregunta = preguntaParaLaCenaOffline(
        agregadoCon(observaciones: 3, misterios: 1),
      );
      expect(pregunta, contains('una pregunta'));
    });

    test('varios misterios: pregunta sobre cuál enganchó más', () {
      final pregunta = preguntaParaLaCenaOffline(
        agregadoCon(observaciones: 5, misterios: 3),
      );
      expect(pregunta, contains('varias preguntas'));
    });

    test('voz adulta — no hay vocabulario prohibido del doc 04', () {
      // Test de regresión contra moralización / diminutivos / hurra
      // de la voz del cuaderno (doc 04 §2.3).
      final preguntas = [
        preguntaParaLaCenaOffline(agregadoCon()),
        preguntaParaLaCenaOffline(agregadoCon(observaciones: 3)),
        preguntaParaLaCenaOffline(agregadoCon(observaciones: 3, sitSpot: 2)),
        preguntaParaLaCenaOffline(agregadoCon(observaciones: 3, misterios: 1)),
        preguntaParaLaCenaOffline(agregadoCon(observaciones: 5, misterios: 3)),
      ];
      const prohibidas = [
        'bien hecho',
        '¡genial',
        'cariño',
        'campeón',
        'campeona',
        'felicidades',
        'qué bonito',
        'maravilloso',
        'naturaleza es',
      ];
      for (final pregunta in preguntas) {
        final minus = pregunta.toLowerCase();
        for (final mala in prohibidas) {
          expect(minus.contains(mala), isFalse,
              reason: 'Vocabulario prohibido "$mala" en: $pregunta');
        }
      }
    });
  });
}
