import 'package:flutter_test/flutter_test.dart';
import 'package:nuevo_ser_core/nuevo_ser_core.dart';

void main() {
  group('compararVersiones', () {
    test('1.0.13 > 1.0.2 (NO orden lexicográfico)', () {
      // El bug clásico de comparar versiones como strings: "1.0.13"
      // sería menor que "1.0.2" porque '1' < '2'. Aquí debe ganar 13.
      expect(compararVersiones('1.0.13', '1.0.2'), greaterThan(0));
      expect(compararVersiones('1.0.2', '1.0.13'), lessThan(0));
    });

    test('versiones idénticas', () {
      expect(compararVersiones('1.0.3', '1.0.3'), 0);
      expect(compararVersiones('1.0.3+4', '1.0.3+4'), 0);
    });

    test('build mayor con mismo semver es update', () {
      expect(compararVersiones('1.0.3+5', '1.0.3+4'), greaterThan(0));
      expect(compararVersiones('1.0.3+4', '1.0.3+5'), lessThan(0));
    });

    test('major.minor.patch domina sobre build', () {
      expect(compararVersiones('1.0.4+1', '1.0.3+99'), greaterThan(0));
    });

    test('falta build se trata como 0', () {
      expect(compararVersiones('1.0.3', '1.0.3+0'), 0);
      expect(compararVersiones('1.0.3+1', '1.0.3'), greaterThan(0));
    });

    test('semver de longitud diferente: rellena con ceros', () {
      // "1.0" debe equivaler a "1.0.0".
      expect(compararVersiones('1.0', '1.0.0'), 0);
      expect(compararVersiones('1.0', '1.0.1'), lessThan(0));
    });

    test('major sube de versión', () {
      expect(compararVersiones('2.0.0', '1.99.99'), greaterThan(0));
    });
  });

  group('ConfigActualizaciones', () {
    test('claveCache es estable y única por config', () {
      final a = ConfigActualizaciones(
        repoOwner: 'JosuIru',
        repoName: 'cuadernos-de-campo',
        prefijoTag: 'naturaleza-v',
      );
      final b = ConfigActualizaciones(
        repoOwner: 'JosuIru',
        repoName: 'cuadernos-de-campo',
        prefijoTag: 'fosiles-v',
      );
      expect(a.claveCache, isNot(equals(b.claveCache)));
      expect(a.claveCache, contains('naturaleza-v'));
      expect(b.claveCache, contains('fosiles-v'));
    });

    test('defaults razonables', () {
      const c = ConfigActualizaciones(
        repoOwner: 'X',
        repoName: 'Y',
      );
      expect(c.prefijoTag, '');
      expect(c.sufijoAsset, '.apk');
    });
  });

  group('ActualizacionDisponible serializa y deserializa', () {
    test('round-trip JSON', () {
      const original = ActualizacionDisponible(
        versionInstalada: '1.0.2+3',
        versionDisponible: '1.0.3+4',
        tagRelease: 'naturaleza-v1.0.3',
        urlAsset:
            'https://github.com/JosuIru/cuadernos-de-campo/releases/download/naturaleza-v1.0.3/naturaleza-1.0.3+4.apk',
        notas: 'Notas de la release',
        publicadoMs: 1747500000000,
      );
      final json = original.toJson();
      final reconstruido = ActualizacionDisponible.fromJson(json);
      expect(reconstruido.versionInstalada, original.versionInstalada);
      expect(reconstruido.versionDisponible, original.versionDisponible);
      expect(reconstruido.tagRelease, original.tagRelease);
      expect(reconstruido.urlAsset, original.urlAsset);
      expect(reconstruido.notas, original.notas);
      expect(reconstruido.publicadoMs, original.publicadoMs);
    });
  });
}
