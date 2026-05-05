import 'package:el_cuaderno/dominio/nivel_confianza.dart';
import 'package:el_cuaderno/dominio/observacion.dart';
import 'package:el_cuaderno/dominio/resumen_mes_sit_spot.dart';
import 'package:flutter_test/flutter_test.dart';

Observacion _obs({
  required String id,
  required DateTime cuando,
  String? sitSpotId,
  String texto = 'algo',
}) =>
    Observacion(
      id: id,
      cuandoCreada: cuando,
      cuandoOcurrio: cuando,
      dondeNombre: 'jardín',
      queVio: texto,
      confianza: NivelConfianza.noSegura,
      sitSpotId: sitSpotId,
    );

void main() {
  group('ResumenMesSitSpot.calcular', () {
    test('lista vacía → resumen vacío', () {
      final resumen = ResumenMesSitSpot.calcular(
        observaciones: const [],
        sitSpotId: 'roble',
        ahora: DateTime(2026, 5, 15),
      );
      expect(resumen.vacio, isTrue);
      expect(resumen.visitas, 0);
      expect(resumen.primera, isNull);
      expect(resumen.ultima, isNull);
    });

    test(
      'observaciones sin sitSpotId no entran al resumen aunque caigan '
      'en el mes',
      () {
        final resumen = ResumenMesSitSpot.calcular(
          observaciones: [
            _obs(id: 'a', cuando: DateTime(2026, 5, 5)),
            _obs(id: 'b', cuando: DateTime(2026, 5, 10), sitSpotId: 'otra'),
          ],
          sitSpotId: 'roble',
          ahora: DateTime(2026, 5, 15),
        );
        expect(resumen.vacio, isTrue);
      },
    );

    test('observaciones del mes anterior no cuentan', () {
      final resumen = ResumenMesSitSpot.calcular(
        observaciones: [
          _obs(id: 'a', cuando: DateTime(2026, 4, 30), sitSpotId: 'roble'),
        ],
        sitSpotId: 'roble',
        ahora: DateTime(2026, 5, 1),
      );
      expect(resumen.vacio, isTrue);
    });

    test(
      'el día 1 del mes a las 00:00 cuenta como del mes en curso',
      () {
        final resumen = ResumenMesSitSpot.calcular(
          observaciones: [
            _obs(id: 'a', cuando: DateTime(2026, 5, 1), sitSpotId: 'roble'),
          ],
          sitSpotId: 'roble',
          ahora: DateTime(2026, 5, 15),
        );
        expect(resumen.visitas, 1);
      },
    );

    test(
      'el último día del mes a las 23:59 cuenta como del mes en curso',
      () {
        final resumen = ResumenMesSitSpot.calcular(
          observaciones: [
            _obs(
              id: 'a',
              cuando: DateTime(2026, 5, 31, 23, 59),
              sitSpotId: 'roble',
            ),
          ],
          sitSpotId: 'roble',
          ahora: DateTime(2026, 5, 15),
        );
        expect(resumen.visitas, 1);
      },
    );

    test(
      'observaciones del mes siguiente no cuentan (frontera 1 de junio)',
      () {
        final resumen = ResumenMesSitSpot.calcular(
          observaciones: [
            _obs(id: 'a', cuando: DateTime(2026, 6, 1), sitSpotId: 'roble'),
          ],
          sitSpotId: 'roble',
          ahora: DateTime(2026, 5, 31),
        );
        expect(resumen.vacio, isTrue);
      },
    );

    test(
      'tres observaciones en dos días distintos → 2 visitas, no 3',
      () {
        final resumen = ResumenMesSitSpot.calcular(
          observaciones: [
            _obs(
              id: 'a',
              cuando: DateTime(2026, 5, 5, 9),
              sitSpotId: 'roble',
            ),
            _obs(
              id: 'b',
              cuando: DateTime(2026, 5, 5, 18),
              sitSpotId: 'roble',
            ),
            _obs(
              id: 'c',
              cuando: DateTime(2026, 5, 12, 10),
              sitSpotId: 'roble',
            ),
          ],
          sitSpotId: 'roble',
          ahora: DateTime(2026, 5, 15),
        );
        expect(resumen.visitas, 2);
      },
    );

    test(
      'primera y ultima vienen del orden cronológico, no del orden de '
      'inserción',
      () {
        final resumen = ResumenMesSitSpot.calcular(
          observaciones: [
            // Insertamos al revés del orden temporal.
            _obs(
              id: 'c',
              cuando: DateTime(2026, 5, 20),
              sitSpotId: 'roble',
              texto: 'tarde',
            ),
            _obs(
              id: 'a',
              cuando: DateTime(2026, 5, 3),
              sitSpotId: 'roble',
              texto: 'pronto',
            ),
            _obs(
              id: 'b',
              cuando: DateTime(2026, 5, 10),
              sitSpotId: 'roble',
              texto: 'medio',
            ),
          ],
          sitSpotId: 'roble',
          ahora: DateTime(2026, 5, 25),
        );
        expect(resumen.visitas, 3);
        expect(resumen.primera!.id, 'a');
        expect(resumen.ultima!.id, 'c');
      },
    );

    test(
      'una sola visita → primera y ultima son la misma observación',
      () {
        final resumen = ResumenMesSitSpot.calcular(
          observaciones: [
            _obs(id: 'a', cuando: DateTime(2026, 5, 12), sitSpotId: 'roble'),
          ],
          sitSpotId: 'roble',
          ahora: DateTime(2026, 5, 15),
        );
        expect(resumen.visitas, 1);
        expect(resumen.primera!.id, 'a');
        expect(resumen.ultima!.id, 'a');
      },
    );

    test('el mes de diciembre cruza año al calcular el siguiente', () {
      final resumen = ResumenMesSitSpot.calcular(
        observaciones: [
          _obs(id: 'a', cuando: DateTime(2026, 12, 5), sitSpotId: 'roble'),
          // Esta es de enero del año siguiente — fuera del mes en curso.
          _obs(id: 'b', cuando: DateTime(2027, 1, 1), sitSpotId: 'roble'),
        ],
        sitSpotId: 'roble',
        ahora: DateTime(2026, 12, 20),
      );
      expect(resumen.visitas, 1);
      expect(resumen.primera!.id, 'a');
    });
  });
}
