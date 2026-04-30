import 'package:el_cuaderno/dominio/contexto_misterio.dart';
import 'package:el_cuaderno/dominio/fenologia.dart';
import 'package:el_cuaderno/dominio/misterio.dart';
import 'package:el_cuaderno/dominio/nivel_confianza.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Misterio crear({
    String id = 'm-1',
    List<String> seasons = const [],
    List<String>? regions,
  }) =>
      Misterio(
        id: id,
        pregunta: 'pregunta',
        descripcionCorta: 'corta',
        estado: NivelConfianza.consenso,
        abierto: true,
        seasons: seasons,
        regions: regions,
      );

  group('aplicaMisterioEnContexto · estación', () {
    test('seasons vacía aplica en cualquier estación', () {
      final atemporal = crear();
      for (final estacion in Estacion.values) {
        expect(
          aplicaMisterioEnContexto(atemporal, estacionActual: estacion),
          isTrue,
        );
      }
    });

    test('estación coincidente aplica', () {
      final golondrinas = crear(seasons: const ['verano', 'otono']);
      expect(
        aplicaMisterioEnContexto(golondrinas, estacionActual: Estacion.verano),
        isTrue,
      );
      expect(
        aplicaMisterioEnContexto(golondrinas, estacionActual: Estacion.otono),
        isTrue,
      );
    });

    test('estación no coincidente NO aplica', () {
      final golondrinas = crear(seasons: const ['verano', 'otono']);
      expect(
        aplicaMisterioEnContexto(
          golondrinas,
          estacionActual: Estacion.invierno,
        ),
        isFalse,
      );
      expect(
        aplicaMisterioEnContexto(
          golondrinas,
          estacionActual: Estacion.primavera,
        ),
        isFalse,
      );
    });
  });

  group('aplicaMisterioEnContexto · región', () {
    test('regions null aplica en cualquier región', () {
      final global = crear();
      expect(
        aplicaMisterioEnContexto(
          global,
          estacionActual: Estacion.verano,
          regionActual: 'ES-NA-PA',
        ),
        isTrue,
      );
    });

    test('regions vacía aplica en cualquier región', () {
      final global = crear(regions: const []);
      expect(
        aplicaMisterioEnContexto(
          global,
          estacionActual: Estacion.verano,
          regionActual: 'ES-CT',
        ),
        isTrue,
      );
    });

    test('regionActual null no filtra (catálogo entero visible)', () {
      final mediterraneo = crear(regions: const ['ES-AN', 'ES-MD']);
      expect(
        aplicaMisterioEnContexto(
          mediterraneo,
          estacionActual: Estacion.verano,
        ),
        isTrue,
      );
    });

    test('prefijo NUTS coincide por igualdad exacta', () {
      final cigarras = crear(regions: const ['ES-MD', 'ES-AN']);
      expect(
        aplicaMisterioEnContexto(
          cigarras,
          estacionActual: Estacion.verano,
          regionActual: 'ES-MD',
        ),
        isTrue,
      );
    });

    test('prefijo NUTS coincide por jerarquía descendente', () {
      // ES-NA-PA debería caer bajo ES-NA si el catálogo lo dijera.
      final navarra = crear(regions: const ['ES-NA']);
      expect(
        aplicaMisterioEnContexto(
          navarra,
          estacionActual: Estacion.verano,
          regionActual: 'ES-NA-PA',
        ),
        isTrue,
      );
    });

    test('prefijo no relacionado NO aplica (Bilbao vs Madrid)', () {
      final cigarras = crear(regions: const ['ES-MD', 'ES-AN']);
      expect(
        aplicaMisterioEnContexto(
          cigarras,
          estacionActual: Estacion.verano,
          regionActual: 'ES-BI',
        ),
        isFalse,
      );
    });

    test('shorthand ES-* equivale a "España entera"', () {
      final global = crear(regions: const ['ES-*']);
      expect(
        aplicaMisterioEnContexto(
          global,
          estacionActual: Estacion.verano,
          regionActual: 'ES-NA-PA',
        ),
        isTrue,
      );
      expect(
        aplicaMisterioEnContexto(
          global,
          estacionActual: Estacion.verano,
          regionActual: 'ES',
        ),
        isTrue,
      );
    });
  });

  group('aplicaMisterioEnContexto · estación AND región', () {
    test(
      'cigarras (verano + Mediterráneo) en Bilbao en verano NO aplica',
      () {
        final cigarras = crear(
          seasons: const ['verano'],
          regions: const ['ES-MD', 'ES-AN', 'ES-VC'],
        );
        expect(
          aplicaMisterioEnContexto(
            cigarras,
            estacionActual: Estacion.verano,
            regionActual: 'ES-BI',
          ),
          isFalse,
        );
      },
    );

    test('cigarras en Madrid en invierno NO aplica (estación falla)', () {
      final cigarras = crear(
        seasons: const ['verano'],
        regions: const ['ES-MD'],
      );
      expect(
        aplicaMisterioEnContexto(
          cigarras,
          estacionActual: Estacion.invierno,
          regionActual: 'ES-MD',
        ),
        isFalse,
      );
    });

    test('cigarras en Madrid en verano SÍ aplica (todo encaja)', () {
      final cigarras = crear(
        seasons: const ['verano'],
        regions: const ['ES-MD'],
      );
      expect(
        aplicaMisterioEnContexto(
          cigarras,
          estacionActual: Estacion.verano,
          regionActual: 'ES-MD',
        ),
        isTrue,
      );
    });
  });

  group('filtrarMisteriosAlContexto', () {
    test('conserva orden y filtra los no aplicables', () {
      final atemporal = crear(id: 'liquenes');
      final invernal = crear(id: 'petirrojo', seasons: const ['invierno']);
      final estival = crear(id: 'golondrinas', seasons: const ['verano']);
      final filtrados = filtrarMisteriosAlContexto(
        [atemporal, invernal, estival],
        estacionActual: Estacion.verano,
      );
      expect(filtrados.map((m) => m.id), ['liquenes', 'golondrinas']);
    });

    test('lista vacía → lista vacía', () {
      final filtrados = filtrarMisteriosAlContexto(
        const [],
        estacionActual: Estacion.verano,
      );
      expect(filtrados, isEmpty);
    });
  });
}
