import 'package:el_cuaderno/dominio/atlas.dart';
import 'package:el_cuaderno/dominio/nivel_confianza.dart';
import 'package:el_cuaderno/dominio/observacion.dart';
import 'package:flutter_test/flutter_test.dart';

Observacion _obs({
  required String id,
  required DateTime cuando,
  required String? creesQueEs,
}) =>
    Observacion(
      id: id,
      cuandoCreada: cuando,
      cuandoOcurrio: cuando,
      dondeNombre: 'jardín',
      queVio: 'algo',
      confianza: NivelConfianza.hipotesisActiva,
      creesQueEs: creesQueEs,
    );

void main() {
  group('Atlas.calcular', () {
    test('atlas vacío cuando no hay observaciones', () {
      final atlas = Atlas.calcular(const []);
      expect(atlas.estaVacio, isTrue);
      expect(atlas.primerasVeces, isEmpty);
      expect(atlas.loQueHasVisto, isEmpty);
    });

    test(
      'observaciones sin creesQueEs no entran al atlas',
      () {
        final atlas = Atlas.calcular([
          _obs(id: '1', cuando: DateTime(2026, 4, 1), creesQueEs: null),
          _obs(id: '2', cuando: DateTime(2026, 4, 2), creesQueEs: ''),
          _obs(id: '3', cuando: DateTime(2026, 4, 3), creesQueEs: '   '),
        ]);
        expect(atlas.estaVacio, isTrue);
      },
    );

    test('una sola observación con identificación → 1 primera vez', () {
      final atlas = Atlas.calcular([
        _obs(
          id: '1',
          cuando: DateTime(2026, 4, 1),
          creesQueEs: 'mariposa blanca',
        ),
      ]);
      expect(atlas.primerasVeces, hasLength(1));
      expect(atlas.primerasVeces.first.creesQueEs, 'mariposa blanca');
      expect(atlas.primerasVeces.first.conteo, 1);
      expect(atlas.loQueHasVisto, hasLength(1));
      expect(atlas.loQueHasVisto.first.conteo, 1);
    });

    test(
      'tres observaciones del mismo creesQueEs → 1 primera vez + conteo 3',
      () {
        final atlas = Atlas.calcular([
          _obs(
            id: '1',
            cuando: DateTime(2026, 4, 1),
            creesQueEs: 'mariposa blanca',
          ),
          _obs(
            id: '2',
            cuando: DateTime(2026, 4, 5),
            creesQueEs: 'mariposa blanca',
          ),
          _obs(
            id: '3',
            cuando: DateTime(2026, 4, 10),
            creesQueEs: 'mariposa blanca',
          ),
        ]);
        expect(atlas.primerasVeces, hasLength(1));
        expect(atlas.primerasVeces.first.idObservacionPrimera, '1');
        expect(atlas.loQueHasVisto, hasLength(1));
        expect(atlas.loQueHasVisto.first.conteo, 3);
        // La forma original de la primera observación se preserva.
        expect(atlas.loQueHasVisto.first.creesQueEs, 'mariposa blanca');
      },
    );

    test(
      'normalización: mayúsculas, tildes, espacios extra y ñ se agrupan',
      () {
        final atlas = Atlas.calcular([
          _obs(id: '1', cuando: DateTime(2026, 4, 1), creesQueEs: 'Araña'),
          _obs(id: '2', cuando: DateTime(2026, 4, 2), creesQueEs: 'arana'),
          _obs(
            id: '3',
            cuando: DateTime(2026, 4, 3),
            creesQueEs: '  ARAÑA  ',
          ),
        ]);
        expect(atlas.primerasVeces, hasLength(1));
        // La primera (Araña) gana — se preserva su forma.
        expect(atlas.primerasVeces.first.creesQueEs, 'Araña');
        expect(atlas.loQueHasVisto.first.conteo, 3);
      },
    );

    test(
      'orden de "lo que has visto": por conteo desc, en empate por primera vez '
      'descendente',
      () {
        final atlas = Atlas.calcular([
          _obs(
            id: '1',
            cuando: DateTime(2026, 4, 1),
            creesQueEs: 'hormiga',
          ),
          _obs(id: '2', cuando: DateTime(2026, 4, 2), creesQueEs: 'mirlo'),
          _obs(
            id: '3',
            cuando: DateTime(2026, 4, 3),
            creesQueEs: 'hormiga',
          ),
          _obs(id: '4', cuando: DateTime(2026, 4, 4), creesQueEs: 'mirlo'),
          _obs(
            id: '5',
            cuando: DateTime(2026, 4, 5),
            creesQueEs: 'hormiga',
          ),
        ]);
        // hormiga: 3, mirlo: 2 → hormiga primero.
        expect(atlas.loQueHasVisto[0].creesQueEs, 'hormiga');
        expect(atlas.loQueHasVisto[0].conteo, 3);
        expect(atlas.loQueHasVisto[1].creesQueEs, 'mirlo');
        expect(atlas.loQueHasVisto[1].conteo, 2);
      },
    );

    test(
      '"primeras veces" se devuelve cronológicamente inversa (último primero)',
      () {
        final atlas = Atlas.calcular([
          _obs(id: '1', cuando: DateTime(2026, 4, 1), creesQueEs: 'roble'),
          _obs(
            id: '2',
            cuando: DateTime(2026, 4, 5),
            creesQueEs: 'mariposa',
          ),
          _obs(id: '3', cuando: DateTime(2026, 4, 10), creesQueEs: 'mirlo'),
        ]);
        // El último anotado va arriba.
        expect(atlas.primerasVeces[0].creesQueEs, 'mirlo');
        expect(atlas.primerasVeces[1].creesQueEs, 'mariposa');
        expect(atlas.primerasVeces[2].creesQueEs, 'roble');
      },
    );

    test(
      'lista no ordenada en entrada → atlas estable: la primera por fecha gana',
      () {
        // Pasamos la observación más antigua AL FINAL — la lista de
        // entrada no está ordenada. El atlas debe ordenarla
        // internamente y detectar correctamente la primera vez.
        final atlas = Atlas.calcular([
          _obs(
            id: '3',
            cuando: DateTime(2026, 4, 10),
            creesQueEs: 'Liquen',
          ),
          _obs(
            id: '2',
            cuando: DateTime(2026, 4, 5),
            creesQueEs: 'liquen',
          ),
          _obs(
            id: '1',
            cuando: DateTime(2026, 4, 1),
            creesQueEs: 'LIQUEN',
          ),
        ]);
        // La de 4-1 es la primera (id=1, forma "LIQUEN").
        expect(atlas.primerasVeces.first.idObservacionPrimera, '1');
        expect(atlas.primerasVeces.first.creesQueEs, 'LIQUEN');
        expect(atlas.loQueHasVisto.first.conteo, 3);
      },
    );
  });

  group('Atlas.esPrimeraVezDeIdentificacion', () {
    test('true cuando es la única con esa identificación', () {
      final obs = _obs(
        id: '1',
        cuando: DateTime(2026, 4, 1),
        creesQueEs: 'mirlo',
      );
      expect(
        Atlas.esPrimeraVezDeIdentificacion(obs, [obs]),
        isTrue,
      );
    });

    test('true cuando es la más antigua de varias del mismo grupo', () {
      final primera = _obs(
        id: '1',
        cuando: DateTime(2026, 4, 1),
        creesQueEs: 'mirlo',
      );
      final segunda = _obs(
        id: '2',
        cuando: DateTime(2026, 4, 5),
        creesQueEs: 'mirlo',
      );
      expect(
        Atlas.esPrimeraVezDeIdentificacion(primera, [primera, segunda]),
        isTrue,
      );
      expect(
        Atlas.esPrimeraVezDeIdentificacion(segunda, [primera, segunda]),
        isFalse,
      );
    });

    test('false si creesQueEs es null o vacío', () {
      final obs = _obs(
        id: '1',
        cuando: DateTime(2026, 4, 1),
        creesQueEs: null,
      );
      expect(
        Atlas.esPrimeraVezDeIdentificacion(obs, [obs]),
        isFalse,
      );
    });

    test('normaliza: "Mirlo" y "mirlo" son la misma identificación', () {
      final mayus = _obs(
        id: '1',
        cuando: DateTime(2026, 4, 1),
        creesQueEs: 'Mirlo',
      );
      final minus = _obs(
        id: '2',
        cuando: DateTime(2026, 4, 5),
        creesQueEs: 'mirlo',
      );
      expect(
        Atlas.esPrimeraVezDeIdentificacion(minus, [mayus, minus]),
        isFalse,
      );
    });
  });
}
