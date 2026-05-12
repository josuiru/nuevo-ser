import 'package:agro/modelos/cosecha.dart';
import 'package:agro/servicios/generador_pdf.dart';
import 'package:flutter_test/flutter_test.dart';

/// Tests caracterización de la función pura `agruparCosechasPorPlanta`,
/// extraída del flujo de `generarPdfCampana` para que la lógica de
/// agregación viva fuera del render PDF (que se cubre en el core).
///
/// La función se invoca con cosechas en bruto y un rango temporal;
/// devuelve por-planta y totales del periodo. Sin BD, sin PDF.
void main() {
  Cosecha cosecha({
    required int plantaId,
    required int fechaMs,
    double? kilos,
    int? unidades,
  }) =>
      Cosecha(plantaId: plantaId, fechaMs: fechaMs, kilos: kilos, unidades: unidades);

  group('agruparCosechasPorPlanta — sin filtro temporal', () {
    test('lista vacía: totales en cero', () {
      final r = agruparCosechasPorPlanta(cosechas: const []);
      expect(r.porPlanta, isEmpty);
      expect(r.totalKilos, 0);
      expect(r.totalUnidades, 0);
      expect(r.totalCosechas, 0);
    });

    test('una cosecha por planta: agregada a esa planta', () {
      final r = agruparCosechasPorPlanta(cosechas: [
        cosecha(plantaId: 1, fechaMs: 1000, kilos: 5.5),
      ]);
      expect(r.porPlanta.keys, [1]);
      expect(r.porPlanta[1]!.kilos, 5.5);
      expect(r.porPlanta[1]!.unidades, 0);
      expect(r.porPlanta[1]!.numCosechas, 1);
      expect(r.totalKilos, 5.5);
    });

    test('varias cosechas a la misma planta: suma kilos y unidades, cuenta registros', () {
      final r = agruparCosechasPorPlanta(cosechas: [
        cosecha(plantaId: 1, fechaMs: 1000, kilos: 3.0),
        cosecha(plantaId: 1, fechaMs: 2000, kilos: 2.0, unidades: 10),
        cosecha(plantaId: 1, fechaMs: 3000, unidades: 5),
      ]);
      expect(r.porPlanta[1]!.kilos, 5.0);
      expect(r.porPlanta[1]!.unidades, 15);
      expect(r.porPlanta[1]!.numCosechas, 3);
      expect(r.totalKilos, 5.0);
      expect(r.totalUnidades, 15);
      expect(r.totalCosechas, 3);
    });

    test('plantas distintas: agregadas por separado', () {
      final r = agruparCosechasPorPlanta(cosechas: [
        cosecha(plantaId: 1, fechaMs: 1000, kilos: 3.0),
        cosecha(plantaId: 2, fechaMs: 2000, kilos: 2.0),
      ]);
      expect(r.porPlanta.keys.toSet(), {1, 2});
      expect(r.porPlanta[1]!.kilos, 3.0);
      expect(r.porPlanta[2]!.kilos, 2.0);
      expect(r.totalKilos, 5.0);
      expect(r.totalCosechas, 2);
    });

    test('kilos null y unidades null no rompen (cuentan como 0)', () {
      final r = agruparCosechasPorPlanta(cosechas: [
        cosecha(plantaId: 1, fechaMs: 1000),
      ]);
      expect(r.porPlanta[1]!.kilos, 0);
      expect(r.porPlanta[1]!.unidades, 0);
      expect(r.porPlanta[1]!.numCosechas, 1);
      expect(r.totalCosechas, 1);
    });
  });

  group('agruparCosechasPorPlanta — con filtro temporal [inicioMs, finMs)', () {
    final ene2025 = DateTime(2025, 1, 1).millisecondsSinceEpoch;
    final ene2026 = DateTime(2026, 1, 1).millisecondsSinceEpoch;
    final mid2025 = DateTime(2025, 6, 15).millisecondsSinceEpoch;
    final dic2024 = DateTime(2024, 12, 31).millisecondsSinceEpoch;

    test('cosecha dentro del rango se incluye', () {
      final r = agruparCosechasPorPlanta(
        cosechas: [cosecha(plantaId: 1, fechaMs: mid2025, kilos: 5)],
        inicioMs: ene2025,
        finMs: ene2026,
      );
      expect(r.porPlanta.containsKey(1), true);
      expect(r.totalKilos, 5);
    });

    test('cosecha anterior al inicio se filtra', () {
      final r = agruparCosechasPorPlanta(
        cosechas: [cosecha(plantaId: 1, fechaMs: dic2024, kilos: 5)],
        inicioMs: ene2025,
        finMs: ene2026,
      );
      expect(r.porPlanta, isEmpty);
      expect(r.totalKilos, 0);
    });

    test('cosecha igual al inicio se incluye (>=)', () {
      final r = agruparCosechasPorPlanta(
        cosechas: [cosecha(plantaId: 1, fechaMs: ene2025, kilos: 5)],
        inicioMs: ene2025,
        finMs: ene2026,
      );
      expect(r.porPlanta.containsKey(1), true);
    });

    test('cosecha igual al fin se filtra (rango semi-abierto, fin exclusivo)', () {
      final r = agruparCosechasPorPlanta(
        cosechas: [cosecha(plantaId: 1, fechaMs: ene2026, kilos: 5)],
        inicioMs: ene2025,
        finMs: ene2026,
      );
      expect(r.porPlanta, isEmpty);
    });

    test('inicioMs null + finMs null: equivale a sin filtro', () {
      final r = agruparCosechasPorPlanta(
        cosechas: [
          cosecha(plantaId: 1, fechaMs: dic2024, kilos: 1),
          cosecha(plantaId: 1, fechaMs: mid2025, kilos: 2),
          cosecha(plantaId: 1, fechaMs: ene2026, kilos: 3),
        ],
      );
      expect(r.totalCosechas, 3);
      expect(r.totalKilos, 6);
    });

    test('solo inicioMs: se filtra por debajo, no por encima', () {
      final r = agruparCosechasPorPlanta(
        cosechas: [
          cosecha(plantaId: 1, fechaMs: dic2024, kilos: 1),
          cosecha(plantaId: 1, fechaMs: mid2025, kilos: 2),
        ],
        inicioMs: ene2025,
      );
      expect(r.totalCosechas, 1);
      expect(r.totalKilos, 2);
    });

    test('solo finMs: se filtra por encima, no por debajo', () {
      final r = agruparCosechasPorPlanta(
        cosechas: [
          cosecha(plantaId: 1, fechaMs: dic2024, kilos: 1),
          cosecha(plantaId: 1, fechaMs: mid2025, kilos: 2),
        ],
        finMs: ene2025,
      );
      expect(r.totalCosechas, 1);
      expect(r.totalKilos, 1);
    });
  });
}
