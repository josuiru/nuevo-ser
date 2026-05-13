// Tests del modelo AnotacionesPiezas + RepositorioAnotaciones.

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:el_descifrador/datos/repositorio_anotaciones.dart';
import 'package:el_descifrador/dominio/anotaciones_piezas.dart';

void main() {
  group('AnotacionesPiezas', () {
    test('estado inicial: vacío', () {
      final anotaciones = AnotacionesPiezas.inicial();
      expect(anotaciones.vacio, isTrue);
      expect(anotaciones.cantidadTotal, 0);
      expect(anotaciones.anotacionesDe('p1'), isEmpty);
    });

    test('añadir anotación nueva queda guardada bajo su pieza', () {
      final ahora = DateTime.utc(2026, 5, 13);
      final anotaciones = AnotacionesPiezas.inicial().conAnotacionNueva(
        id: 'a1',
        idPieza: 'p1',
        texto: 'Mirar pimentón de Vera, lo vi en otra carta.',
        ahora: ahora,
      );
      final propia = anotaciones.anotacionesDe('p1');
      expect(propia.length, 1);
      expect(propia.first.texto, 'Mirar pimentón de Vera, lo vi en otra carta.');
      expect(anotaciones.anotacionesDe('p2'), isEmpty);
    });

    test('texto en blanco no crea anotación', () {
      final anotaciones = AnotacionesPiezas.inicial().conAnotacionNueva(
        id: 'a1',
        idPieza: 'p1',
        texto: '   ',
        ahora: DateTime.utc(2026, 5, 13),
      );
      expect(anotaciones.vacio, isTrue);
    });

    test('múltiples anotaciones en la misma pieza, ordenadas por fecha', () {
      var anotaciones = AnotacionesPiezas.inicial();
      anotaciones = anotaciones.conAnotacionNueva(
        id: 'a1',
        idPieza: 'p1',
        texto: 'Primera.',
        ahora: DateTime.utc(2026, 5, 10),
      );
      anotaciones = anotaciones.conAnotacionNueva(
        id: 'a2',
        idPieza: 'p1',
        texto: 'Segunda.',
        ahora: DateTime.utc(2026, 5, 12),
      );
      final lista = anotaciones.anotacionesDe('p1');
      expect(lista.length, 2);
      expect(lista.first.id, 'a2');
      expect(lista.last.id, 'a1');
    });

    test('editar anotación actualiza texto y fechaUltimaEdicion', () {
      var anotaciones = AnotacionesPiezas.inicial().conAnotacionNueva(
        id: 'a1',
        idPieza: 'p1',
        texto: 'Original.',
        ahora: DateTime.utc(2026, 5, 13),
      );
      anotaciones = anotaciones.conAnotacionEditada(
        id: 'a1',
        texto: 'Reescrita.',
        ahora: DateTime.utc(2026, 5, 14),
      );
      final anotacion = anotaciones.anotacionConId('a1')!;
      expect(anotacion.texto, 'Reescrita.');
      expect(anotacion.fechaCreacion, DateTime.utc(2026, 5, 13));
      expect(anotacion.fechaUltimaEdicion, DateTime.utc(2026, 5, 14));
    });

    test('editar anotación inexistente es no-op', () {
      final original = AnotacionesPiezas.inicial();
      final tras = original.conAnotacionEditada(
        id: 'no-existe',
        texto: 'X',
        ahora: DateTime.utc(2026, 5, 13),
      );
      expect(tras.vacio, isTrue);
    });

    test('borrar anotación la elimina sin tocar otras de la misma pieza',
        () {
      var anotaciones = AnotacionesPiezas.inicial();
      anotaciones = anotaciones.conAnotacionNueva(
        id: 'a1',
        idPieza: 'p1',
        texto: 'A',
        ahora: DateTime.utc(2026, 5, 13),
      );
      anotaciones = anotaciones.conAnotacionNueva(
        id: 'a2',
        idPieza: 'p1',
        texto: 'B',
        ahora: DateTime.utc(2026, 5, 14),
      );
      anotaciones = anotaciones.sinAnotacion('a1');
      final lista = anotaciones.anotacionesDe('p1');
      expect(lista.length, 1);
      expect(lista.first.id, 'a2');
    });

    test('anotaciones de piezas distintas no se mezclan', () {
      var anotaciones = AnotacionesPiezas.inicial();
      anotaciones = anotaciones.conAnotacionNueva(
        id: 'a1',
        idPieza: 'p1',
        texto: 'De p1',
        ahora: DateTime.utc(2026, 5, 13),
      );
      anotaciones = anotaciones.conAnotacionNueva(
        id: 'a2',
        idPieza: 'p2',
        texto: 'De p2',
        ahora: DateTime.utc(2026, 5, 13),
      );
      expect(anotaciones.anotacionesDe('p1').single.id, 'a1');
      expect(anotaciones.anotacionesDe('p2').single.id, 'a2');
    });

    test('serialización ida y vuelta preserva contenido', () {
      var anotaciones = AnotacionesPiezas.inicial();
      anotaciones = anotaciones.conAnotacionNueva(
        id: 'a1',
        idPieza: 'p1',
        texto: 'Sin editar.',
        ahora: DateTime.utc(2026, 5, 13),
      );
      anotaciones = anotaciones.conAnotacionNueva(
        id: 'a2',
        idPieza: 'p1',
        texto: 'Editada después.',
        ahora: DateTime.utc(2026, 5, 14),
      );
      anotaciones = anotaciones.conAnotacionEditada(
        id: 'a2',
        texto: 'Editada y reescrita.',
        ahora: DateTime.utc(2026, 5, 15),
      );

      final reconstruido =
          AnotacionesPiezas.deserializar(anotaciones.serializar());
      expect(reconstruido.anotacionConId('a1')!.texto, 'Sin editar.');
      expect(reconstruido.anotacionConId('a2')!.texto, 'Editada y reescrita.');
      expect(
        reconstruido.anotacionConId('a2')!.fechaUltimaEdicion,
        DateTime.utc(2026, 5, 15),
      );
    });

    test('deserialización tolera entradas mal formadas', () {
      final mapaConBasura = {
        'a1': {
          'id': 'a1',
          'id_pieza': 'p1',
          'texto': 'Válida.',
          'fecha_creacion': '2026-05-13T00:00:00.000Z',
        },
        'a2': 'cadena suelta',
        'a3': {
          // falta id_pieza y texto → TypeError
          'id': 'a3',
        },
      };
      final reconstruido =
          AnotacionesPiezas.deserializar(mapaConBasura);
      expect(reconstruido.anotacionConId('a1'), isNotNull);
      expect(reconstruido.anotacionConId('a2'), isNull);
      expect(reconstruido.anotacionConId('a3'), isNull);
    });
  });

  group('RepositorioAnotaciones', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('perfil nuevo: cargar devuelve vacío', () async {
      final repo = RepositorioAnotaciones(idPerfil: 'test-1');
      final anotaciones = await repo.cargar();
      expect(anotaciones.vacio, isTrue);
    });

    test('anyadirAnotacion persiste con id generado', () async {
      var contadorId = 0;
      final repo = RepositorioAnotaciones(
        idPerfil: 'test-2',
        relojInyectado: () => DateTime.utc(2026, 5, 13),
        generadorIdInyectado: () => 'id-${++contadorId}',
      );
      await repo.anyadirAnotacion(idPieza: 'p1', texto: 'Primera.');
      await repo.anyadirAnotacion(idPieza: 'p1', texto: 'Segunda.');

      final repoReabierto = RepositorioAnotaciones(idPerfil: 'test-2');
      final anotaciones = await repoReabierto.cargar();
      expect(anotaciones.anotacionesDe('p1').length, 2);
    });

    test('editarAnotacion actualiza y persiste', () async {
      var ahora = DateTime.utc(2026, 5, 13);
      final repo = RepositorioAnotaciones(
        idPerfil: 'test-3',
        relojInyectado: () => ahora,
        generadorIdInyectado: () => 'unica',
      );
      await repo.anyadirAnotacion(idPieza: 'p1', texto: 'Original.');
      ahora = DateTime.utc(2026, 5, 15);
      await repo.editarAnotacion(id: 'unica', texto: 'Revisada.');

      final anotaciones = await repo.cargar();
      final anotacion = anotaciones.anotacionConId('unica')!;
      expect(anotacion.texto, 'Revisada.');
      expect(anotacion.fechaUltimaEdicion, DateTime.utc(2026, 5, 15));
    });

    test('borrarAnotacion elimina y persiste', () async {
      final repo = RepositorioAnotaciones(
        idPerfil: 'test-4',
        relojInyectado: () => DateTime.utc(2026, 5, 13),
        generadorIdInyectado: () => 'unica',
      );
      await repo.anyadirAnotacion(idPieza: 'p1', texto: 'Borrable.');
      await repo.borrarAnotacion('unica');
      final anotaciones = await repo.cargar();
      expect(anotaciones.vacio, isTrue);
    });

    test('perfiles distintos no se contaminan', () async {
      final ana = RepositorioAnotaciones(
        idPerfil: 'ana',
        generadorIdInyectado: () => 'ana-1',
      );
      final luis = RepositorioAnotaciones(idPerfil: 'luis');
      await ana.anyadirAnotacion(idPieza: 'p1', texto: 'De Ana.');

      final anotAna = await ana.cargar();
      final anotLuis = await luis.cargar();
      expect(anotAna.cantidadTotal, 1);
      expect(anotLuis.vacio, isTrue);
    });
  });
}
