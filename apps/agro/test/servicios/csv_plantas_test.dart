import 'package:agro/servicios/csv_plantas.dart';
import 'package:flutter_test/flutter_test.dart';

/// Tests de caracterización del parser CSV de agro previos a la
/// extracción de la lectura/escritura de tablas CSV al core.
///
/// Cubren el comportamiento observable de `parsearCsvPlantas` —
/// los helpers privados `_separarFilas`, `_parsearLinea` y
/// `_csvEscape` no son testeables directamente, pero se ejercitan
/// de pleno a través del parser de alto nivel.
void main() {
  group('parsearCsvPlantas — cabeceras', () {
    test('cabeceras mínimas obligatorias presentes: cultivo_id + lat + lon', () {
      final r = parsearCsvPlantas('cultivo_id,latitud,longitud\nolivo,40.5,-3.7');
      expect(r.filasValidas, hasLength(1));
      expect(r.filasInvalidas, isEmpty);
      expect(r.filasValidas.first.cultivoId, 'olivo');
      expect(r.filasValidas.first.latitud, 40.5);
      expect(r.filasValidas.first.longitud, -3.7);
    });

    test('alias de cabecera: cultivo / lat / lon / lng', () {
      final r = parsearCsvPlantas('cultivo,lat,lng\nolivo,40.5,-3.7');
      expect(r.filasValidas, hasLength(1));
      expect(r.filasValidas.first.cultivoId, 'olivo');
    });

    test('cabecera case-insensitive', () {
      final r = parsearCsvPlantas('CULTIVO_ID,Latitud,LONGITUD\nolivo,40.5,-3.7');
      expect(r.filasValidas, hasLength(1));
    });

    test('faltan obligatorias → fila inválida en línea 1', () {
      final r = parsearCsvPlantas('nombre,latitud\nfoo,40');
      expect(r.filasValidas, isEmpty);
      expect(r.filasInvalidas, hasLength(1));
      expect(r.filasInvalidas.first.numeroLinea, 1);
      expect(r.filasInvalidas.first.motivo, contains('cultivo_id'));
    });
  });

  group('parsearCsvPlantas — formato de fichero', () {
    test('BOM UTF-8 al inicio se descarta', () {
      final r = parsearCsvPlantas('﻿cultivo_id,latitud,longitud\nolivo,40,-3');
      expect(r.filasValidas, hasLength(1));
      expect(r.filasValidas.first.cultivoId, 'olivo');
    });

    test('delimitador ";" auto-detectado cuando no hay ","', () {
      final r = parsearCsvPlantas('cultivo_id;latitud;longitud\nolivo;40.5;-3.7');
      expect(r.filasValidas, hasLength(1));
      expect(r.filasValidas.first.cultivoId, 'olivo');
      expect(r.filasValidas.first.latitud, 40.5);
    });

    test('delimitador "," gana si la primera línea tiene ambos', () {
      final r = parsearCsvPlantas('cultivo_id,latitud,longitud,notas\nolivo,40,-3,"foo;bar"');
      expect(r.filasValidas, hasLength(1));
      expect(r.filasValidas.first.notas, 'foo;bar');
    });

    test('CRLF se acepta como salto de línea', () {
      final r = parsearCsvPlantas('cultivo_id,latitud,longitud\r\nolivo,40,-3\r\n');
      expect(r.filasValidas, hasLength(1));
    });

    test('líneas vacías intermedias se saltan', () {
      final r = parsearCsvPlantas('cultivo_id,latitud,longitud\nolivo,40,-3\n\nvid,41,-4');
      expect(r.filasValidas, hasLength(2));
    });

    test('campo entre comillas con coma dentro', () {
      final r = parsearCsvPlantas('cultivo_id,latitud,longitud,notas\nolivo,40,-3,"con, coma"');
      expect(r.filasValidas, hasLength(1));
      expect(r.filasValidas.first.notas, 'con, coma');
    });

    test('comillas escapadas dobles dentro de campo entrecomillado', () {
      final r = parsearCsvPlantas('cultivo_id,latitud,longitud,notas\nolivo,40,-3,"con ""comillas"" dentro"');
      expect(r.filasValidas, hasLength(1));
      expect(r.filasValidas.first.notas, 'con "comillas" dentro');
    });

    test('coma decimal en lat/lon se admite (10,5 → 10.5)', () {
      final r = parsearCsvPlantas('cultivo_id;latitud;longitud\nolivo;40,5;-3,7');
      expect(r.filasValidas, hasLength(1));
      expect(r.filasValidas.first.latitud, 40.5);
      expect(r.filasValidas.first.longitud, -3.7);
    });
  });

  group('parsearCsvPlantas — validación de filas', () {
    test('lat fuera de rango → inválida', () {
      final r = parsearCsvPlantas('cultivo_id,latitud,longitud\nolivo,99,0');
      expect(r.filasValidas, isEmpty);
      expect(r.filasInvalidas, hasLength(1));
      expect(r.filasInvalidas.first.motivo, contains('rango'));
    });

    test('lat o lon no numéricos → inválida', () {
      final r = parsearCsvPlantas('cultivo_id,latitud,longitud\nolivo,abc,0');
      expect(r.filasValidas, isEmpty);
      expect(r.filasInvalidas, hasLength(1));
      expect(r.filasInvalidas.first.motivo, contains('número'));
    });

    test('cultivo_id vacío → inválida', () {
      final r = parsearCsvPlantas('cultivo_id,latitud,longitud\n,40,-3');
      expect(r.filasValidas, isEmpty);
      expect(r.filasInvalidas, hasLength(1));
    });

    test('cultivo desconocido se acepta cayendo a "generico"', () {
      final r = parsearCsvPlantas('cultivo_id,latitud,longitud\nfoobar,40,-3');
      expect(r.filasValidas, hasLength(1));
      expect(r.filasValidas.first.cultivoId, 'generico');
    });

    test('fecha inválida: fila válida con fechaPlantacionMs == null', () {
      final r = parsearCsvPlantas('cultivo_id,latitud,longitud,fecha_plantacion\nolivo,40,-3,no-fecha');
      expect(r.filasValidas, hasLength(1));
      expect(r.filasValidas.first.fechaPlantacionMs, isNull);
    });

    test('fecha YYYY-MM-DD bien parseada', () {
      final r = parsearCsvPlantas('cultivo_id,latitud,longitud,fecha_plantacion\nolivo,40,-3,2020-03-15');
      expect(r.filasValidas, hasLength(1));
      final esperado = DateTime(2020, 3, 15).millisecondsSinceEpoch;
      expect(r.filasValidas.first.fechaPlantacionMs, esperado);
    });
  });

  group('parsearCsvPlantas — fincas detectadas', () {
    test('finca recogida en nombresFincasNuevas (ordenadas)', () {
      final r = parsearCsvPlantas(
        'cultivo_id,latitud,longitud,finca\nolivo,40,-3,Norte\nvid,41,-4,Sur\nolivo,40.1,-3.1,Norte',
      );
      expect(r.filasValidas, hasLength(3));
      expect(r.nombresFincasNuevas, ['Norte', 'Sur']);
    });

    test('alias finca_nombre también funciona', () {
      final r = parsearCsvPlantas('cultivo_id,latitud,longitud,finca_nombre\nolivo,40,-3,Cortijo');
      expect(r.nombresFincasNuevas, ['Cortijo']);
    });
  });
}
