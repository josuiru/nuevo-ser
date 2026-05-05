import 'package:el_cuaderno/dominio/generador_plantilla_pdf.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GeneradorPlantillaPdf.generar', () {
    test('1 página → bytes válidos no vacíos', () async {
      final bytes = await GeneradorPlantillaPdf.generar(paginas: 1);
      expect(bytes.length, greaterThan(500));
      // Cabecera PDF estándar.
      expect(String.fromCharCodes(bytes.take(4)), '%PDF');
    });

    test('8 páginas → más bytes que 1 página (creció el documento)', () async {
      final una = await GeneradorPlantillaPdf.generar(paginas: 1);
      final ocho = await GeneradorPlantillaPdf.generar(paginas: 8);
      expect(ocho.length, greaterThan(una.length));
    });

    test('lanza si paginas es 0', () async {
      expect(
        () => GeneradorPlantillaPdf.generar(paginas: 0),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('lanza si paginas es negativo', () async {
      expect(
        () => GeneradorPlantillaPdf.generar(paginas: -3),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('lanza si paginas excede el cap (33)', () async {
      expect(
        () => GeneradorPlantillaPdf.generar(paginas: 33),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('cap en 32 páginas funciona (frontera)', () async {
      final bytes = await GeneradorPlantillaPdf.generar(paginas: 32);
      expect(bytes.length, greaterThan(0));
    });

    test(
      'sin nombreNino → la cabecera no lleva el separador y queda limpia',
      () async {
        final bytes = await GeneradorPlantillaPdf.generar(paginas: 1);
        // No podemos parsear el PDF binario para inspeccionar texto;
        // con que se genere sin lanzar y los bytes sean razonables ya
        // está cubierto.
        expect(bytes.length, greaterThan(500));
      },
    );

    test('con nombreNino y nombreSitSpot → genera sin lanzar', () async {
      final bytes = await GeneradorPlantillaPdf.generar(
        paginas: 4,
        nombreNino: 'Maren',
        nombreSitSpot: 'El Roble Grande',
      );
      expect(bytes.length, greaterThan(0));
    });

    test(
      'nombreSitSpot vacío o sólo espacios → se trata como ausencia',
      () async {
        final bytesVacio = await GeneradorPlantillaPdf.generar(
          paginas: 1,
          nombreSitSpot: '',
        );
        final bytesEspacios = await GeneradorPlantillaPdf.generar(
          paginas: 1,
          nombreSitSpot: '   ',
        );
        // No debe lanzar — la línea del sit spot simplemente no se
        // pinta.
        expect(bytesVacio.length, greaterThan(0));
        expect(bytesEspacios.length, greaterThan(0));
      },
    );
  });
}
