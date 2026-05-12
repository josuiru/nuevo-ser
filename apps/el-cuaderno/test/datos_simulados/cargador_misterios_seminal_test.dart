import 'package:el_cuaderno/datos_simulados/cargador_misterios_seminal.dart';
import 'package:el_cuaderno/dominio/misterio.dart';
import 'package:el_cuaderno/dominio/nivel_confianza.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('parseCatalogoSeminalDesdeJson — invariantes del catálogo seminal v0.1', () {
    late List<Misterio> catalogo;

    setUpAll(() async {
      final contenido = await rootBundle.loadString(rutaAssetMisteriosSeminal);
      catalogo = parseCatalogoSeminalDesdeJson(contenido);
    });

    test('contiene exactamente 19 Misterios', () {
      expect(catalogo, hasLength(19));
    });

    test('exactamente 5 Misterios marcados como abierto:true (biblia §5.3)', () {
      final cuentaAbiertos = catalogo.where((m) => m.abierto).length;
      expect(cuentaAbiertos, 5);
    });

    test('todos los ids son únicos', () {
      final ids = catalogo.map((m) => m.id).toSet();
      expect(ids.length, catalogo.length);
    });

    test('todos los ids siguen el patrón seed-misterio-*', () {
      for (final misterio in catalogo) {
        expect(
          misterio.id,
          startsWith('seed-misterio-'),
          reason: 'id fuera de patrón: ${misterio.id}',
        );
      }
    });

    test('ningún Misterio tiene estado noSegura (prohibido por el constructor)', () {
      for (final misterio in catalogo) {
        expect(
          misterio.estado,
          isNot(NivelConfianza.noSegura),
          reason: 'Misterio ${misterio.id} con estado noSegura',
        );
      }
    });

    test('todos los Misterios tienen traducciones eu y ca', () {
      for (final misterio in catalogo) {
        expect(
          misterio.traducciones.keys,
          containsAll(<String>{'eu', 'ca'}),
          reason: 'Misterio ${misterio.id} sin traducción completa eu+ca',
        );
        expect(
          misterio.preguntaEn('eu'),
          isNot(misterio.pregunta),
          reason: 'traducción eu vacía o igual al castellano en ${misterio.id}',
        );
        expect(
          misterio.preguntaEn('ca'),
          isNot(misterio.pregunta),
          reason: 'traducción ca vacía o igual al castellano en ${misterio.id}',
        );
      }
    });

    test('seed-misterio-lluvia existe (ancla observación del seed)', () {
      final lluvia = catalogo.where((m) => m.id == 'seed-misterio-lluvia');
      expect(lluvia, hasLength(1));
      expect(lluvia.single.abierto, isTrue);
    });

    test('cigarras y hormigas-sendero llevan filtro por regions', () {
      final cigarras = catalogo.firstWhere(
        (m) => m.id == 'seed-misterio-cigarras-fin',
      );
      final hormigasSendero = catalogo.firstWhere(
        (m) => m.id == 'seed-misterio-hormigas-sendero',
      );
      expect(cigarras.regions, isNotNull);
      expect(cigarras.regions, isNotEmpty);
      expect(hormigasSendero.regions, isNotNull);
      expect(hormigasSendero.regions, isNotEmpty);
    });

    test('Misterios atemporales tienen seasons vacía', () {
      final atemporales = <String>{
        'seed-misterio-liquenes',
        'seed-misterio-encina-vieja',
        'seed-misterio-platano',
        'seed-misterio-dos-pequenos-marrones',
        'seed-misterio-aves-suelo-ramas',
        'seed-misterio-hormigas-sendero',
      };
      for (final id in atemporales) {
        final misterio = catalogo.firstWhere((m) => m.id == id);
        expect(
          misterio.seasons,
          isEmpty,
          reason: '$id debería ser atemporal (seasons vacía)',
        );
      }
    });
  });

  group('parseCatalogoSeminalDesdeJson — errores', () {
    test('lanza FormatException con JSON no objeto', () {
      expect(
        () => parseCatalogoSeminalDesdeJson('[]'),
        throwsFormatException,
      );
    });

    test('lanza FormatException si falta clave "misterios"', () {
      expect(
        () => parseCatalogoSeminalDesdeJson('{"foo": 1}'),
        throwsFormatException,
      );
    });

    test('lanza FormatException si "misterios" no es lista', () {
      expect(
        () => parseCatalogoSeminalDesdeJson('{"misterios": {}}'),
        throwsFormatException,
      );
    });
  });
}
