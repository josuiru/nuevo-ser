import 'dart:convert';

import 'package:el_cuaderno/dominio/exportador_cuaderno.dart';
import 'package:el_cuaderno/dominio/misterio.dart';
import 'package:el_cuaderno/dominio/nivel_confianza.dart';
import 'package:el_cuaderno/dominio/observacion.dart';
import 'package:el_cuaderno/dominio/sit_spot.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Observacion observacionEjemplo({
    String? fotoRutaLocal,
    String? dibujoRutaLocal,
  }) {
    return Observacion(
      id: 'obs-1',
      cuandoCreada: DateTime.utc(2026, 4, 30, 17, 48),
      cuandoOcurrio: DateTime.utc(2026, 4, 30, 17, 30),
      dondeNombre: 'El Roble Grande',
      queVio: 'Pájaro pequeño marrón',
      confianza: NivelConfianza.hipotesisActiva,
      creesQueEs: 'petirrojo',
      fotoRutaLocal: fotoRutaLocal,
      dibujoRutaLocal: dibujoRutaLocal,
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
    test('serializa observaciones, sit spot y misterios con versión 2',
        () async {
      final json = await ExportadorCuaderno.aJson(
        observaciones: [observacionEjemplo()],
        sitSpot: sitSpotEjemplo(),
        misterios: [misterioEjemplo()],
        exportadoEn: DateTime.utc(2026, 4, 30, 18, 0),
      );
      final mapa = jsonDecode(json) as Map<String, dynamic>;
      expect(mapa['version'], 2);
      expect(mapa['exportado_en'], '2026-04-30T18:00:00.000Z');
      expect((mapa['observaciones'] as List), hasLength(1));
      expect((mapa['observaciones'] as List).first['id'], 'obs-1');
      expect((mapa['sit_spot'] as Map?)?['id'], 'sp-1');
      expect((mapa['misterios'] as List), hasLength(1));
    });

    test('sin resolverMedio, no incluye campo "medios"', () async {
      final json = await ExportadorCuaderno.aJson(
        observaciones: [
          observacionEjemplo(fotoRutaLocal: 'medios/obs-1_foto.jpg'),
        ],
        misterios: const [],
        exportadoEn: DateTime.utc(2026, 4, 30),
      );
      final mapa = jsonDecode(json) as Map<String, dynamic>;
      expect(mapa.containsKey('medios'), isFalse);
    });

    test(
      'con resolverMedio, incluye manifiesto con cada ruta única',
      () async {
        final llamadasResolver = <String>[];
        final json = await ExportadorCuaderno.aJson(
          observaciones: [
            observacionEjemplo(
              fotoRutaLocal: 'medios/obs-1_foto.jpg',
              dibujoRutaLocal: 'medios/obs-1_dibujo.png',
            ),
          ],
          misterios: const [],
          exportadoEn: DateTime.utc(2026, 4, 30),
          resolverMedio: (ruta) async {
            llamadasResolver.add(ruta);
            return InfoMedioExportado(
              rutaRelativa: ruta,
              existe: true,
              tamanoBytes: ruta.endsWith('.jpg') ? 12345 : 678,
            );
          },
        );
        expect(llamadasResolver, contains('medios/obs-1_foto.jpg'));
        expect(llamadasResolver, contains('medios/obs-1_dibujo.png'));

        final mapa = jsonDecode(json) as Map<String, dynamic>;
        final medios = mapa['medios'] as List;
        expect(medios, hasLength(2));
        final foto = medios.firstWhere(
          (m) => (m as Map)['ruta_relativa'] == 'medios/obs-1_foto.jpg',
        ) as Map<String, dynamic>;
        expect(foto['existe'], isTrue);
        expect(foto['tamano_bytes'], 12345);
      },
    );

    test('manifiesto reporta "existe: false" para fichero huérfano',
        () async {
      final json = await ExportadorCuaderno.aJson(
        observaciones: [
          observacionEjemplo(fotoRutaLocal: 'medios/obs-1_foto.jpg'),
        ],
        misterios: const [],
        exportadoEn: DateTime.utc(2026, 4, 30),
        resolverMedio: (ruta) async => InfoMedioExportado(
          rutaRelativa: ruta,
          existe: false,
        ),
      );
      final mapa = jsonDecode(json) as Map<String, dynamic>;
      final medios = mapa['medios'] as List;
      expect(medios, hasLength(1));
      expect((medios.first as Map)['existe'], isFalse);
      expect((medios.first as Map).containsKey('tamano_bytes'), isFalse);
    });

    test(
      'no llama al resolver para observaciones sin foto ni dibujo',
      () async {
        var veces = 0;
        await ExportadorCuaderno.aJson(
          observaciones: [observacionEjemplo()],
          misterios: const [],
          exportadoEn: DateTime.utc(2026, 4, 30),
          resolverMedio: (ruta) async {
            veces++;
            return InfoMedioExportado(rutaRelativa: ruta, existe: true);
          },
        );
        expect(veces, 0);
      },
    );

    test('rutas duplicadas en distintas observaciones se sondean una vez',
        () async {
      final llamadas = <String>[];
      await ExportadorCuaderno.aJson(
        observaciones: [
          observacionEjemplo(fotoRutaLocal: 'medios/compartida.jpg'),
          Observacion(
            id: 'obs-2',
            cuandoCreada: DateTime.utc(2026, 4, 30),
            cuandoOcurrio: DateTime.utc(2026, 4, 30),
            dondeNombre: 'X',
            queVio: 'Y',
            confianza: NivelConfianza.hipotesisActiva,
            fotoRutaLocal: 'medios/compartida.jpg',
          ),
        ],
        misterios: const [],
        exportadoEn: DateTime.utc(2026, 4, 30),
        resolverMedio: (ruta) async {
          llamadas.add(ruta);
          return InfoMedioExportado(rutaRelativa: ruta, existe: true);
        },
      );
      expect(llamadas, ['medios/compartida.jpg']);
    });

    test('formato indentado para que el niño lo pueda leer a ojo', () async {
      final json = await ExportadorCuaderno.aJson(
        observaciones: [observacionEjemplo()],
        misterios: const [],
        exportadoEn: DateTime.utc(2026, 4, 30),
      );
      expect(json.contains('\n'), isTrue);
    });
  });

  group('ExportadorCuaderno.deJson', () {
    test('round-trip preserva foto/dibujo y manifiesto', () async {
      final observaciones = [
        observacionEjemplo(
          fotoRutaLocal: 'medios/obs-1_foto.jpg',
          dibujoRutaLocal: 'medios/obs-1_dibujo.png',
        ),
      ];
      final json = await ExportadorCuaderno.aJson(
        observaciones: observaciones,
        sitSpot: sitSpotEjemplo(),
        misterios: [misterioEjemplo()],
        exportadoEn: DateTime.utc(2026, 4, 30),
        resolverMedio: (ruta) async => InfoMedioExportado(
          rutaRelativa: ruta,
          existe: true,
          tamanoBytes: 100,
        ),
      );
      final importado = ExportadorCuaderno.deJson(json);
      expect(importado.version, 2);
      expect(importado.observaciones, hasLength(1));
      expect(
        importado.observaciones.first.fotoRutaLocal,
        'medios/obs-1_foto.jpg',
      );
      expect(
        importado.observaciones.first.dibujoRutaLocal,
        'medios/obs-1_dibujo.png',
      );
      expect(importado.medios, hasLength(2));
      expect(importado.medios.every((m) => m.existe), isTrue);
    });

    test('lee export v1 antiguo (sin manifiesto) en modo compat', () {
      // Export v1 generado antes de A5: sin clave "medios", versión 1.
      final jsonV1 = jsonEncode({
        'version': 1,
        'exportado_en': '2026-03-01T12:00:00.000Z',
        'observaciones': [
          {
            'id': 'obs-legacy',
            'cuandoCreada': '2026-03-01T12:00:00.000Z',
            'cuandoOcurrio': '2026-03-01T12:00:00.000Z',
            'dondeNombre': 'X',
            'queVio': 'Algo',
            'confianza': 'hipotesisActiva',
          },
        ],
        'sit_spot': null,
        'misterios': [],
      });
      final importado = ExportadorCuaderno.deJson(jsonV1);
      expect(importado.version, 1);
      expect(importado.observaciones, hasLength(1));
      expect(importado.medios, isEmpty);
    });

    test('versión no soportada lanza FormatException', () {
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
        'version': 2,
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
