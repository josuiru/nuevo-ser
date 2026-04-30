import 'package:el_cuaderno/dominio/fenologia.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('estacionDeFecha — hemisferio norte', () {
    test('20 marzo → primavera (equinoccio)', () {
      expect(estacionDeFecha(DateTime(2026, 3, 20)), Estacion.primavera);
    });

    test('19 marzo → invierno (un día antes del equinoccio)', () {
      expect(estacionDeFecha(DateTime(2026, 3, 19)), Estacion.invierno);
    });

    test('21 junio → verano (solsticio)', () {
      expect(estacionDeFecha(DateTime(2026, 6, 21)), Estacion.verano);
    });

    test('20 junio → primavera (un día antes del solsticio)', () {
      expect(estacionDeFecha(DateTime(2026, 6, 20)), Estacion.primavera);
    });

    test('22 septiembre → otoño (equinoccio)', () {
      expect(estacionDeFecha(DateTime(2026, 9, 22)), Estacion.otono);
    });

    test('21 septiembre → verano (un día antes del equinoccio)', () {
      expect(estacionDeFecha(DateTime(2026, 9, 21)), Estacion.verano);
    });

    test('21 diciembre → invierno (solsticio)', () {
      expect(estacionDeFecha(DateTime(2026, 12, 21)), Estacion.invierno);
    });

    test('20 diciembre → otoño (un día antes del solsticio)', () {
      expect(estacionDeFecha(DateTime(2026, 12, 20)), Estacion.otono);
    });

    test('1 enero → invierno (mitad de la temporada)', () {
      expect(estacionDeFecha(DateTime(2026, 1, 1)), Estacion.invierno);
    });

    test('15 julio → verano (mitad)', () {
      expect(estacionDeFecha(DateTime(2026, 7, 15)), Estacion.verano);
    });
  });

  group('estacionAString → wire del catálogo', () {
    test('primavera → "primavera"', () {
      expect(estacionAString(Estacion.primavera), 'primavera');
    });

    test('verano → "verano"', () {
      expect(estacionAString(Estacion.verano), 'verano');
    });

    test('otoño → "otono" (sin tilde, ASCII para el wire)', () {
      expect(estacionAString(Estacion.otono), 'otono');
    });

    test('invierno → "invierno"', () {
      expect(estacionAString(Estacion.invierno), 'invierno');
    });
  });

  group('seasonParaListado — orquestación', () {
    test('20 marzo en ES-NA-PA → "primavera"', () {
      expect(
        seasonParaListado(DateTime(2026, 3, 20), regionCode: 'ES-NA-PA'),
        'primavera',
      );
    });

    test('1 noviembre en ES-MD → "otono"', () {
      expect(
        seasonParaListado(DateTime(2026, 11, 1), regionCode: 'ES-MD'),
        'otono',
      );
    });

    test('regionCode desconocido cae al hemisferio norte por defecto', () {
      // Si llega un region_code no piloto el servicio no se rompe — el
      // doc deja claro que la calibración fina es trabajo humano
      // pendiente, así que el alcance del MVP es astronómico genérico.
      expect(
        seasonParaListado(DateTime(2026, 7, 15), regionCode: 'XX-DESCONOCIDO'),
        'verano',
      );
    });
  });
}
