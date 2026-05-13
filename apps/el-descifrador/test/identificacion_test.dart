// Tests del modelo IdentificacionesPiezas, repositorio y servicio de
// candidatas de lengua.

import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:el_descifrador/datos/repositorio_identificaciones.dart';
import 'package:el_descifrador/dominio/identificaciones_lengua.dart';
import 'package:el_descifrador/dominio/lengua.dart';
import 'package:el_descifrador/dominio/servicio_candidatas_lengua.dart';

void main() {
  group('IdentificacionesPiezas', () {
    test('estado inicial: vacío', () {
      final identificaciones = IdentificacionesPiezas.inicial();
      expect(identificaciones.vacio, isTrue);
      expect(identificaciones.yaIdentificada('p1'), isFalse);
      expect(identificaciones.identificacionDe('p1'), isNull);
    });

    test('intento correcto al primer intento queda registrado así', () {
      final ahora = DateTime.utc(2026, 5, 13);
      final identificaciones = IdentificacionesPiezas.inicial().conIntento(
        idPieza: 'p1',
        lenguaIntentada: Lengua.portugues,
        lenguaCorrecta: Lengua.portugues,
        ahora: ahora,
      );
      final ident = identificaciones.identificacionDe('p1')!;
      expect(ident.acertadaEnPrimerIntento, isTrue);
      expect(ident.identificadaCorrectamente, isTrue);
      expect(ident.intentos, [Lengua.portugues]);
    });

    test('fallar y acertar: acertadaEnPrimerIntento queda en false', () {
      var identificaciones = IdentificacionesPiezas.inicial().conIntento(
        idPieza: 'p1',
        lenguaIntentada: Lengua.castellano,
        lenguaCorrecta: Lengua.portugues,
        ahora: DateTime.utc(2026, 5, 13),
      );
      identificaciones = identificaciones.conIntento(
        idPieza: 'p1',
        lenguaIntentada: Lengua.portugues,
        lenguaCorrecta: Lengua.portugues,
        ahora: DateTime.utc(2026, 5, 13, 1),
      );
      final ident = identificaciones.identificacionDe('p1')!;
      expect(ident.acertadaEnPrimerIntento, isFalse);
      expect(ident.identificadaCorrectamente, isTrue);
      expect(ident.intentos, [Lengua.castellano, Lengua.portugues]);
    });

    test('una vez identificada correctamente no se sobrescribe', () {
      var identificaciones = IdentificacionesPiezas.inicial().conIntento(
        idPieza: 'p1',
        lenguaIntentada: Lengua.portugues,
        lenguaCorrecta: Lengua.portugues,
        ahora: DateTime.utc(2026, 5, 13),
      );
      // Intentar reescribir con una errada → debe ignorarse.
      identificaciones = identificaciones.conIntento(
        idPieza: 'p1',
        lenguaIntentada: Lengua.castellano,
        lenguaCorrecta: Lengua.portugues,
        ahora: DateTime.utc(2026, 5, 14),
      );
      final ident = identificaciones.identificacionDe('p1')!;
      expect(ident.intentos, [Lengua.portugues]);
    });

    test('idsCorrectamenteIdentificadas filtra los aún fallidos', () {
      var identificaciones = IdentificacionesPiezas.inicial();
      identificaciones = identificaciones.conIntento(
        idPieza: 'p1',
        lenguaIntentada: Lengua.portugues,
        lenguaCorrecta: Lengua.portugues,
        ahora: DateTime.utc(2026, 5, 13),
      );
      identificaciones = identificaciones.conIntento(
        idPieza: 'p2',
        lenguaIntentada: Lengua.castellano,
        lenguaCorrecta: Lengua.portugues,
        ahora: DateTime.utc(2026, 5, 13),
      );
      expect(identificaciones.idsCorrectamenteIdentificadas(), {'p1'});
    });

    test('serialización ida y vuelta preserva contenido', () {
      var identificaciones = IdentificacionesPiezas.inicial();
      identificaciones = identificaciones.conIntento(
        idPieza: 'p1',
        lenguaIntentada: Lengua.castellano,
        lenguaCorrecta: Lengua.portugues,
        ahora: DateTime.utc(2026, 5, 13),
      );
      identificaciones = identificaciones.conIntento(
        idPieza: 'p1',
        lenguaIntentada: Lengua.portugues,
        lenguaCorrecta: Lengua.portugues,
        ahora: DateTime.utc(2026, 5, 13, 1),
      );
      final reconstruido =
          IdentificacionesPiezas.deserializar(identificaciones.serializar());
      final ident = reconstruido.identificacionDe('p1')!;
      expect(ident.intentos, [Lengua.castellano, Lengua.portugues]);
      expect(ident.acertadaEnPrimerIntento, isFalse);
      expect(ident.identificadaCorrectamente, isTrue);
    });

    test('deserialización tolera entradas mal formadas', () {
      final mapaConBasura = {
        'p1': {
          'id_pieza': 'p1',
          'intentos': ['pt'],
          'acertada_en_primer_intento': true,
          'identificada_correctamente': true,
          'fecha_primer_intento': '2026-05-13T00:00:00.000Z',
        },
        'p2': 'no es mapa',
      };
      final reconstruido = IdentificacionesPiezas.deserializar(mapaConBasura);
      expect(reconstruido.identificacionDe('p1'), isNotNull);
      expect(reconstruido.identificacionDe('p2'), isNull);
    });
  });

  group('RepositorioIdentificaciones', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('perfil nuevo: cargar devuelve vacío', () async {
      final repo = RepositorioIdentificaciones(idPerfil: 'test-1');
      final identificaciones = await repo.cargar();
      expect(identificaciones.vacio, isTrue);
    });

    test('registrarIntento persiste y se recupera', () async {
      final fechaFalsa = DateTime.utc(2026, 5, 13);
      final repo = RepositorioIdentificaciones(
        idPerfil: 'test-2',
        relojInyectado: () => fechaFalsa,
      );
      await repo.registrarIntento(
        idPieza: 'p1',
        lenguaIntentada: Lengua.portugues,
        lenguaCorrecta: Lengua.portugues,
      );
      final repoReabierto =
          RepositorioIdentificaciones(idPerfil: 'test-2');
      final identificaciones = await repoReabierto.cargar();
      expect(identificaciones.yaIdentificada('p1'), isTrue);
    });

    test('perfiles distintos no se contaminan', () async {
      final ana = RepositorioIdentificaciones(idPerfil: 'ana');
      final luis = RepositorioIdentificaciones(idPerfil: 'luis');
      await ana.registrarIntento(
        idPieza: 'p1',
        lenguaIntentada: Lengua.portugues,
        lenguaCorrecta: Lengua.portugues,
      );
      final idAna = await ana.cargar();
      final idLuis = await luis.cargar();
      expect(idAna.vacio, isFalse);
      expect(idLuis.vacio, isTrue);
    });
  });

  group('ServicioCandidatasLengua', () {
    test('siempre incluye la lengua correcta', () {
      final servicio = ServicioCandidatasLengua(aleatorio: Random(42));
      for (final lengua in Lengua.values) {
        final candidatas = servicio.candidatasPara(lenguaCorrecta: lengua);
        expect(
          candidatas,
          contains(lengua),
          reason: 'falla para $lengua',
        );
      }
    });

    test('tamaño entre 3 y 5', () {
      final servicio = ServicioCandidatasLengua(aleatorio: Random(42));
      for (final lengua in Lengua.values) {
        final candidatas = servicio.candidatasPara(
          lenguaCorrecta: lengua,
          tamanoObjetivo: 4,
        );
        expect(candidatas.length, inInclusiveRange(3, 5));
        expect(candidatas.toSet().length, candidatas.length,
            reason: 'sin duplicados');
      }
    });

    test('cooficial peninsular: las otras tres aparecen entre candidatas',
        () {
      final servicio = ServicioCandidatasLengua(aleatorio: Random(0));
      final candidatas = servicio.candidatasPara(
        lenguaCorrecta: Lengua.gallego,
        tamanoObjetivo: 5,
      );
      // El servicio prioriza las otras cooficiales como distractoras.
      expect(candidatas, contains(Lengua.castellano));
      expect(candidatas, contains(Lengua.catalan));
      expect(candidatas, contains(Lengua.euskara));
    });

    test('portugués: la confusión natural con gallego aparece', () {
      final servicio = ServicioCandidatasLengua(aleatorio: Random(0));
      final candidatas = servicio.candidatasPara(
        lenguaCorrecta: Lengua.portugues,
        tamanoObjetivo: 4,
      );
      expect(candidatas, contains(Lengua.gallego));
    });
  });
}
