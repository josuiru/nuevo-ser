import 'dart:convert';

import 'package:el_cuaderno/dominio/exportador_cuaderno.dart';
import 'package:el_cuaderno/dominio/misterio.dart';
import 'package:el_cuaderno/dominio/nivel_confianza.dart';
import 'package:el_cuaderno/dominio/observacion.dart';
import 'package:el_cuaderno/dominio/sit_spot.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Observacion observacionEjemplo() {
    return Observacion(
      id: 'obs-1',
      cuandoCreada: DateTime.utc(2026, 4, 30, 17, 48),
      cuandoOcurrio: DateTime.utc(2026, 4, 30, 17, 30),
      dondeNombre: 'El Roble Grande',
      queVio: 'Pájaro pequeño marrón',
      confianza: NivelConfianza.hipotesisActiva,
      creesQueEs: 'petirrojo',
    );
  }

  SitSpot sitSpotEjemplo() {
    return SitSpot(
      id: 'sp-1',
      nombre: 'El Roble Grande',
      dondeNombre: 'al final del parque',
      creadoEn: DateTime.utc(2026, 3, 1),
    );
  }

  Misterio misterioEjemplo() {
    return Misterio(
      id: 'mist-1',
      pregunta: '¿Cuándo florece el almendro de tu calle?',
      descripcionCorta: 'El almendro suele ser la primera flor del año.',
      estado: NivelConfianza.consenso,
      abierto: true,
    );
  }

  group('ExportadorCuaderno.aJson', () {
    test('serializa observaciones, sit spot y misterios con versión', () {
      final json = ExportadorCuaderno.aJson(
        observaciones: [observacionEjemplo()],
        sitSpot: sitSpotEjemplo(),
        misterios: [misterioEjemplo()],
        exportadoEn: DateTime.utc(2026, 4, 30, 18, 0),
      );
      final mapa = jsonDecode(json) as Map<String, dynamic>;
      expect(mapa['version'], 1);
      expect(mapa['exportado_en'], '2026-04-30T18:00:00.000Z');
      expect((mapa['observaciones'] as List), hasLength(1));
      expect((mapa['observaciones'] as List).first['id'], 'obs-1');
      expect((mapa['sit_spot'] as Map?)?['id'], 'sp-1');
      expect((mapa['misterios'] as List), hasLength(1));
    });

    test('sit_spot null se serializa como null (no se omite)', () {
      final json = ExportadorCuaderno.aJson(
        observaciones: const [],
        misterios: const [],
        exportadoEn: DateTime.utc(2026, 4, 30),
      );
      final mapa = jsonDecode(json) as Map<String, dynamic>;
      expect(mapa['sit_spot'], isNull);
    });

    test('formato indentado para que el niño lo pueda leer a ojo', () {
      final json = ExportadorCuaderno.aJson(
        observaciones: [observacionEjemplo()],
        misterios: const [],
        exportadoEn: DateTime.utc(2026, 4, 30),
      );
      // El JSON con indentación tiene saltos de línea.
      expect(json.contains('\n'), isTrue);
    });
  });

  group('ExportadorCuaderno.deJson', () {
    test('rehidrata round-trip: aJson → deJson preserva los datos', () {
      final observaciones = [observacionEjemplo()];
      final sitSpot = sitSpotEjemplo();
      final misterios = [misterioEjemplo()];
      final json = ExportadorCuaderno.aJson(
        observaciones: observaciones,
        sitSpot: sitSpot,
        misterios: misterios,
        exportadoEn: DateTime.utc(2026, 4, 30),
      );
      final importado = ExportadorCuaderno.deJson(json);
      expect(importado.version, 1);
      expect(importado.observaciones, hasLength(1));
      expect(importado.observaciones.first.id, 'obs-1');
      expect(importado.observaciones.first.queVio, 'Pájaro pequeño marrón');
      expect(importado.sitSpot?.id, 'sp-1');
      expect(importado.misterios, hasLength(1));
      expect(importado.misterios.first.pregunta,
          '¿Cuándo florece el almendro de tu calle?');
    });

    test('versión incompatible lanza FormatException', () {
      final json = jsonEncode({
        'version': 99,
        'exportado_en': '2026-04-30T18:00:00.000Z',
        'observaciones': [],
        'misterios': [],
      });
      expect(() => ExportadorCuaderno.deJson(json),
          throwsA(isA<FormatException>()));
    });

    test('JSON sin "observaciones" lanza FormatException', () {
      final json = jsonEncode({
        'version': 1,
        'exportado_en': '2026-04-30T18:00:00.000Z',
        'misterios': [],
      });
      expect(() => ExportadorCuaderno.deJson(json),
          throwsA(isA<FormatException>()));
    });

    test('raíz que no es objeto lanza FormatException', () {
      expect(() => ExportadorCuaderno.deJson('[]'),
          throwsA(isA<FormatException>()));
    });
  });
}
