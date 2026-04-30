import 'package:el_cuaderno/dominio/misterio.dart';
import 'package:el_cuaderno/dominio/nivel_confianza.dart';
import 'package:el_cuaderno/dominio/sugeridor_misterio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Misterio crear(String id) => Misterio(
        id: id,
        pregunta: 'p',
        descripcionCorta: 'c',
        estado: NivelConfianza.consenso,
        abierto: true,
      );

  // Catálogo completo de IDs del seed seminal (los 19 que tienen
  // entrada en la tabla interna del sugeridor). Tests del sugeridor
  // no dependen del estado `abierto` — eso lo decide el caller en
  // producción cuando le pasa el subset.
  final catalogoSeminal = const [
    'seed-misterio-golondrinas',
    'seed-misterio-primera-hoja',
    'seed-misterio-primera-flor',
    'seed-misterio-cigarras-fin',
    'seed-misterio-petirrojo',
    'seed-misterio-polinizadores',
    'seed-misterio-liquenes',
    'seed-misterio-lluvia',
    'seed-misterio-hormigas-arbol',
    'seed-misterio-aves-suelo-ramas',
    'seed-misterio-dos-pequenos-marrones',
    'seed-misterio-mariposas-blancas',
    'seed-misterio-platano',
    'seed-misterio-pajaro-cola',
    'seed-misterio-flor-rara',
    'seed-misterio-hormigas-sendero',
    'seed-misterio-encina-vieja',
    'seed-misterio-grito-raro',
    'seed-misterio-polillas-farolas',
  ].map(crear).toList(growable: false);

  group('sugerirMisterio · texto vacío y sin match', () {
    test('queVio vacío → null', () {
      final r = sugerirMisterio(queVio: '', candidatos: catalogoSeminal);
      expect(r, isNull);
    });

    test('queVio solo espacios → null', () {
      final r =
          sugerirMisterio(queVio: '   ', candidatos: catalogoSeminal);
      expect(r, isNull);
    });

    test('texto sin coincidencias con ninguna keyword → null', () {
      final r = sugerirMisterio(
        queVio: 'el cielo estaba azul',
        candidatos: catalogoSeminal,
      );
      expect(r, isNull);
    });

    test('candidatos vacíos → null aunque el texto traiga keywords', () {
      final r = sugerirMisterio(
        queVio: 'una golondrina volaba',
        candidatos: const [],
      );
      expect(r, isNull);
    });

    test('id de Misterio sin entrada en la tabla → no se sugiere', () {
      final adHoc = crear('misterio-inventado');
      final r = sugerirMisterio(
        queVio: 'una golondrina',
        candidatos: [adHoc],
      );
      expect(r, isNull);
    });
  });

  group('sugerirMisterio · matches simples', () {
    test('"vi una golondrina" → seed-misterio-golondrinas', () {
      final r = sugerirMisterio(
        queVio: 'vi una golondrina cerca del balcón',
        candidatos: catalogoSeminal,
      );
      expect(r?.id, 'seed-misterio-golondrinas');
    });

    test('plural también encaja: "tres golondrinas"', () {
      final r = sugerirMisterio(
        queVio: 'había tres golondrinas en el cable',
        candidatos: catalogoSeminal,
      );
      expect(r?.id, 'seed-misterio-golondrinas');
    });

    test('accent-insensitive: "petirrojo" sin tilde tampoco la lleva → ok',
        () {
      final r = sugerirMisterio(
        queVio: 'un petirrojo en el seto',
        candidatos: catalogoSeminal,
      );
      expect(r?.id, 'seed-misterio-petirrojo');
    });

    test('con tildes: "vi un líquen amarillo en la corteza"', () {
      final r = sugerirMisterio(
        queVio: 'vi un líquen amarillo en la corteza',
        candidatos: catalogoSeminal,
      );
      expect(r?.id, 'seed-misterio-liquenes');
    });

    test('case-insensitive: MAYÚSCULAS también encajan', () {
      final r = sugerirMisterio(
        queVio: 'UN CARACOL TRAS LA LLUVIA',
        candidatos: catalogoSeminal,
      );
      expect(r?.id, 'seed-misterio-lluvia');
    });

    test('"polilla en la farola" → seed-misterio-polillas-farolas con dos '
        'matches', () {
      final r = sugerirMisterio(
        queVio: 'una polilla revoloteaba en la farola',
        candidatos: catalogoSeminal,
      );
      expect(r?.id, 'seed-misterio-polillas-farolas');
    });
  });

  group('sugerirMisterio · puntuación y desempate', () {
    test('texto que matchea más palabras de un Misterio gana al que '
        'matchea menos', () {
      // "mariposas blancas" matchea las dos keywords del Misterio de
      // mariposas. "blancas" sola no matchea ningún otro.
      final r = sugerirMisterio(
        queVio: 'tres mariposas blancas en el patio',
        candidatos: catalogoSeminal,
      );
      expect(r?.id, 'seed-misterio-mariposas-blancas');
    });

    test('candidatos restringidos: si el caller filtra fuera al Misterio '
        'que mejor matchea, no se sugiere', () {
      // Simulamos al caller pasando un subset que NO incluye al
      // petirrojo (filtrado fenológico fuera de temporada, p. ej.).
      final sinPetirrojo = catalogoSeminal
          .where((m) => m.id != 'seed-misterio-petirrojo')
          .toList(growable: false);
      final r = sugerirMisterio(
        queVio: 'un petirrojo en el jardín',
        candidatos: sinPetirrojo,
      );
      expect(r, isNull);
    });
  });
}
