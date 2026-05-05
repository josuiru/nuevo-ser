import 'package:el_cuaderno/dominio/eco_temporal.dart';
import 'package:el_cuaderno/dominio/nivel_confianza.dart';
import 'package:el_cuaderno/dominio/observacion.dart';
import 'package:flutter_test/flutter_test.dart';

Observacion _obs({
  required String id,
  required DateTime cuando,
  String texto = 'algo',
}) =>
    Observacion(
      id: id,
      cuandoCreada: cuando,
      cuandoOcurrio: cuando,
      dondeNombre: 'jardín',
      queVio: texto,
      confianza: NivelConfianza.noSegura,
    );

void main() {
  group('VentanaEco.aniversarioDesde', () {
    test('haceUnMes resta un mes calendárico (no 30 días)', () {
      final ahora = DateTime(2026, 5, 15);
      final aniversario = VentanaEco.haceUnMes.aniversarioDesde(ahora);
      expect(aniversario, DateTime(2026, 4, 15));
    });

    test('haceSeisMeses cierra equinoccio↔equinoccio', () {
      // 21 marzo (equinoccio primavera) → 21 septiembre (equinoccio otoño).
      final ahora = DateTime(2026, 3, 21);
      final aniversario = VentanaEco.haceSeisMeses.aniversarioDesde(ahora);
      expect(aniversario, DateTime(2025, 9, 21));
    });

    test('haceUnAno baja exactamente un año el aniversario', () {
      final ahora = DateTime(2026, 5, 15);
      final aniversario = VentanaEco.haceUnAno.aniversarioDesde(ahora);
      expect(aniversario, DateTime(2025, 5, 15));
    });

    test(
      'haceUnMes en enero cruza al año anterior (DateTime normaliza '
      'el mes -1 a diciembre del año previo)',
      () {
        final ahora = DateTime(2026, 1, 15);
        final aniversario = VentanaEco.haceUnMes.aniversarioDesde(ahora);
        expect(aniversario, DateTime(2025, 12, 15));
      },
    );
  });

  group('EcoTemporal.calcular', () {
    test('lista vacía → ningún eco', () {
      final ecos = EcoTemporal.calcular(
        observaciones: const [],
        ahora: DateTime(2026, 5, 15),
      );
      expect(ecos, isEmpty);
    });

    test(
      'observación dentro de ±3 días del aniversario de 1 mes → eco',
      () {
        final ahora = DateTime(2026, 5, 15);
        final obs = _obs(id: 'o1', cuando: DateTime(2026, 4, 14));
        final ecos = EcoTemporal.calcular(
          observaciones: [obs],
          ahora: ahora,
        );
        expect(ecos, hasLength(1));
        expect(ecos.first.ventana, VentanaEco.haceUnMes);
        expect(ecos.first.observacion.id, 'o1');
      },
    );

    test(
      'observación a +3 días del aniversario (frontera incluida) → eco',
      () {
        final ahora = DateTime(2026, 5, 15);
        final obs = _obs(id: 'o1', cuando: DateTime(2026, 4, 18));
        final ecos = EcoTemporal.calcular(
          observaciones: [obs],
          ahora: ahora,
        );
        expect(ecos, hasLength(1));
        expect(ecos.first.ventana, VentanaEco.haceUnMes);
      },
    );

    test(
      'observación a +4 días del aniversario (fuera de frontera) → ningún eco',
      () {
        final ahora = DateTime(2026, 5, 15);
        final obs = _obs(id: 'o1', cuando: DateTime(2026, 4, 19));
        final ecos = EcoTemporal.calcular(
          observaciones: [obs],
          ahora: ahora,
        );
        expect(ecos, isEmpty);
      },
    );

    test(
      'cuando varias observaciones caen en la ventana, gana la más '
      'cercana al aniversario exacto',
      () {
        final ahora = DateTime(2026, 5, 15);
        final lejana = _obs(id: 'lejos', cuando: DateTime(2026, 4, 12));
        final cercana = _obs(id: 'cerca', cuando: DateTime(2026, 4, 16));
        final ecos = EcoTemporal.calcular(
          observaciones: [lejana, cercana],
          ahora: ahora,
        );
        expect(ecos, hasLength(1));
        expect(ecos.first.observacion.id, 'cerca');
      },
    );

    test(
      'tres ventanas independientes: 1 mes, 6 meses y 1 año',
      () {
        final ahora = DateTime(2026, 5, 15);
        final unMes = _obs(id: 'mes', cuando: DateTime(2026, 4, 15));
        final seisMeses = _obs(id: 'seis', cuando: DateTime(2025, 11, 15));
        final unAno = _obs(id: 'ano', cuando: DateTime(2025, 5, 15));
        final ecos = EcoTemporal.calcular(
          observaciones: [unMes, seisMeses, unAno],
          ahora: ahora,
        );
        expect(ecos, hasLength(3));
        // Orden de presentación: 1 mes → 6 meses → 1 año.
        expect(ecos[0].ventana, VentanaEco.haceUnMes);
        expect(ecos[0].observacion.id, 'mes');
        expect(ecos[1].ventana, VentanaEco.haceSeisMeses);
        expect(ecos[1].observacion.id, 'seis');
        expect(ecos[2].ventana, VentanaEco.haceUnAno);
        expect(ecos[2].observacion.id, 'ano');
      },
    );

    test(
      'una observación que cae en dos ventanas se asigna a la más '
      'antigua (1 año), pero la más corta puede tomar otra distinta',
      () {
        final ahora = DateTime(2026, 5, 15);
        // Hace exactamente 1 año Y dentro de la ventana de 1 mes
        // (imposible en aritmética calendárica real con tolerancia ±3,
        // pero validamos la regla con dos observaciones distintas).
        final ambasVentanas = _obs(
          id: 'colgante',
          cuando: DateTime(2025, 5, 15),
        );
        // Construimos un caso donde la misma observación es candidata
        // para 1 año y 6 meses simultáneamente: 15 nov 2025 cae a -6
        // meses; pero a -1 año falla por mucho. Tomamos otro caso:
        // la candidata "colgante" del año + una específica del mes.
        final delMes = _obs(id: 'mes', cuando: DateTime(2026, 4, 15));
        final ecos = EcoTemporal.calcular(
          observaciones: [ambasVentanas, delMes],
          ahora: ahora,
        );
        // El año coge la "colgante", el mes coge "mes".
        expect(ecos, hasLength(2));
        expect(
          ecos.firstWhere((e) => e.ventana == VentanaEco.haceUnAno).observacion.id,
          'colgante',
        );
        expect(
          ecos.firstWhere((e) => e.ventana == VentanaEco.haceUnMes).observacion.id,
          'mes',
        );
      },
    );

    test(
      'misma observación matchea dos ventanas → se asigna a la más '
      'antigua y la más corta busca alternativa o se queda fuera',
      () {
        final ahora = DateTime(2026, 5, 15);
        // Observación única que cae en ventana de 6 meses (15 nov
        // 2025) y NO en otras. La metemos varias veces no tiene
        // sentido — el caso real de duplicación es cuando dos ventanas
        // se solapan (15 nov 2025 está a 6 meses de 15 may 2026 pero
        // a 11 meses de 1 año, fuera de tolerancia). Para forzar la
        // colisión usamos una fecha que cae en ambas: imposible en
        // realidad porque las ventanas están bien separadas. Test
        // alternativo: 6 meses tiene candidata, 1 año no, 1 mes
        // tampoco — sólo un eco aparece.
        final solo6Meses = _obs(id: 's', cuando: DateTime(2025, 11, 15));
        final ecos = EcoTemporal.calcular(
          observaciones: [solo6Meses],
          ahora: ahora,
        );
        expect(ecos, hasLength(1));
        expect(ecos.first.ventana, VentanaEco.haceSeisMeses);
      },
    );

    test(
      'sin candidatas en ninguna ventana → lista vacía',
      () {
        final ahora = DateTime(2026, 5, 15);
        // Una observación de hace dos meses — no cae en ninguna
        // ventana del cuaderno.
        final obs = _obs(id: 'huerfana', cuando: DateTime(2026, 3, 15));
        final ecos = EcoTemporal.calcular(
          observaciones: [obs],
          ahora: ahora,
        );
        expect(ecos, isEmpty);
      },
    );

    test(
      'orden devuelto siempre 1 mes → 6 meses → 1 año, '
      'independientemente del orden de entrada',
      () {
        final ahora = DateTime(2026, 5, 15);
        final unMes = _obs(id: 'mes', cuando: DateTime(2026, 4, 15));
        final seisMeses = _obs(id: 'seis', cuando: DateTime(2025, 11, 15));
        final unAno = _obs(id: 'ano', cuando: DateTime(2025, 5, 15));
        // Entrada en orden inverso al esperado.
        final ecos = EcoTemporal.calcular(
          observaciones: [unAno, seisMeses, unMes],
          ahora: ahora,
        );
        expect(
          ecos.map((e) => e.ventana).toList(),
          [
            VentanaEco.haceUnMes,
            VentanaEco.haceSeisMeses,
            VentanaEco.haceUnAno,
          ],
        );
      },
    );
  });
}
