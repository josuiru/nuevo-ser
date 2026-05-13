import 'package:flutter_test/flutter_test.dart';

import 'package:el_descifrador/dominio/localizacion.dart';
import 'package:el_descifrador/dominio/personaje.dart';

void main() {
  group('Catálogo personajes puerto', () {
    test('cada personaje tiene identificador único', () {
      final identificadores = catalogoPersonajesPuerto
          .map((personaje) => personaje.identificadorTecnico)
          .toList();
      expect(identificadores.toSet().length, equals(identificadores.length));
    });

    test('posiciones normalizadas dentro del rango [0..1]', () {
      for (final personaje in catalogoPersonajesPuerto) {
        expect(personaje.posicionXEnEscena, inInclusiveRange(0.0, 1.0));
        expect(personaje.posicionYEnEscena, inInclusiveRange(0.0, 1.0));
        expect(personaje.alturaEnEscena, inInclusiveRange(0.0, 1.0));
      }
    });

    test('Antón está en el despacho del maestro', () {
      final anton = catalogoPersonajesPuerto.firstWhere(
        (personaje) => personaje.identificadorTecnico == 'anton',
      );
      expect(anton.localizacion, equals(Localizacion.despachoMaestro));
    });

    test('Aitziber está en la oficina', () {
      final aitziber = catalogoPersonajesPuerto.firstWhere(
        (personaje) => personaje.identificadorTecnico == 'aitziber',
      );
      expect(aitziber.localizacion, equals(Localizacion.oficina));
    });

    test('frases de presentación no contienen exclamaciones formularias',
        () {
      const exclamacionesProhibidas = ['¡bien!', '¡muy', '¡perfecto', '¡bravo'];
      for (final personaje in catalogoPersonajesPuerto) {
        final frase = personaje.frasePresentacion;
        if (frase == null) continue;
        for (final prohibida in exclamacionesProhibidas) {
          expect(
            frase.toLowerCase().contains(prohibida),
            isFalse,
            reason:
                '${personaje.nombreCanonico}: frase contiene "$prohibida"',
          );
        }
      }
    });
  });

  group('personajesEn', () {
    test('devuelve solo los personajes de esa localización', () {
      final enDespacho = personajesEn(Localizacion.despachoMaestro);
      expect(enDespacho, hasLength(1));
      expect(enDespacho.first.identificadorTecnico, equals('anton'));
    });

    test('devuelve lista vacía si no hay nadie en la localización', () {
      final enCalle = personajesEn(Localizacion.calleMayor);
      expect(enCalle, isEmpty);
    });

    test('cada localización con personaje aparece coherente', () {
      for (final personaje in catalogoPersonajesPuerto) {
        final personajesAlli = personajesEn(personaje.localizacion);
        expect(personajesAlli, contains(personaje));
      }
    });
  });
}
