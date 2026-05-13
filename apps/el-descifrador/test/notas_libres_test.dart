// Tests del modelo NotasLibres y RepositorioNotasLibres.

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:el_descifrador/datos/repositorio_notas_libres.dart';
import 'package:el_descifrador/dominio/notas_libres.dart';

void main() {
  group('NotasLibres', () {
    test('estado inicial: vacío', () {
      final notas = NotasLibres.inicial();
      expect(notas.vacio, isTrue);
      expect(notas.cantidad, 0);
      expect(notas.notaConId('cualquiera'), isNull);
    });

    test('añadir nota la guarda', () {
      final ahora = DateTime.utc(2026, 5, 13);
      final notas = NotasLibres.inicial().conNotaNueva(
        id: 'n1',
        texto: 'El portugués y el gallego se parecen mucho.',
        ahora: ahora,
      );
      final nota = notas.notaConId('n1')!;
      expect(nota.texto, 'El portugués y el gallego se parecen mucho.');
      expect(nota.fechaCreacion, ahora);
      expect(nota.fechaUltimaEdicion, isNull);
    });

    test('texto en blanco no crea nota', () {
      final notas = NotasLibres.inicial().conNotaNueva(
        id: 'n1',
        texto: '   ',
        ahora: DateTime.utc(2026, 5, 13),
      );
      expect(notas.vacio, isTrue);
    });

    test('editar nota actualiza texto y fechaUltimaEdicion', () {
      var notas = NotasLibres.inicial().conNotaNueva(
        id: 'n1',
        texto: 'Idea inicial.',
        ahora: DateTime.utc(2026, 5, 13),
      );
      notas = notas.conNotaEditada(
        id: 'n1',
        texto: 'Idea reescrita después de pensarlo.',
        ahora: DateTime.utc(2026, 5, 15),
      );
      final nota = notas.notaConId('n1')!;
      expect(nota.texto, 'Idea reescrita después de pensarlo.');
      expect(nota.fechaCreacion, DateTime.utc(2026, 5, 13));
      expect(nota.fechaUltimaEdicion, DateTime.utc(2026, 5, 15));
    });

    test('editar nota inexistente es no-op', () {
      final original = NotasLibres.inicial();
      final tras = original.conNotaEditada(
        id: 'no-existe',
        texto: 'Algo',
        ahora: DateTime.utc(2026, 5, 13),
      );
      expect(tras.vacio, isTrue);
    });

    test('borrar nota la elimina', () {
      var notas = NotasLibres.inicial().conNotaNueva(
        id: 'n1',
        texto: 'Borrable.',
        ahora: DateTime.utc(2026, 5, 13),
      );
      expect(notas.cantidad, 1);
      notas = notas.sinNota('n1');
      expect(notas.cantidad, 0);
    });

    test('ordenadasPorFecha más recientes primero', () {
      var notas = NotasLibres.inicial();
      notas = notas.conNotaNueva(
        id: 'antigua',
        texto: 'A',
        ahora: DateTime.utc(2026, 5, 10),
      );
      notas = notas.conNotaNueva(
        id: 'reciente',
        texto: 'B',
        ahora: DateTime.utc(2026, 5, 15),
      );
      final lista = notas.ordenadasPorFecha();
      expect(lista.first.id, 'reciente');
      expect(lista.last.id, 'antigua');
    });

    test('serialización ida y vuelta preserva contenido', () {
      var notas = NotasLibres.inicial();
      notas = notas.conNotaNueva(
        id: 'n1',
        texto: 'Texto uno.',
        ahora: DateTime.utc(2026, 5, 13),
      );
      notas = notas.conNotaEditada(
        id: 'n1',
        texto: 'Texto uno reescrito.',
        ahora: DateTime.utc(2026, 5, 14),
      );
      notas = notas.conNotaNueva(
        id: 'n2',
        texto: 'Texto dos.',
        ahora: DateTime.utc(2026, 5, 15),
      );
      final reconstruido = NotasLibres.deserializar(notas.serializar());
      expect(reconstruido.notaConId('n1')!.texto, 'Texto uno reescrito.');
      expect(
        reconstruido.notaConId('n1')!.fechaUltimaEdicion,
        DateTime.utc(2026, 5, 14),
      );
      expect(reconstruido.notaConId('n2')!.texto, 'Texto dos.');
    });

    test('deserialización tolera entradas mal formadas', () {
      final mapaConBasura = {
        'n1': {
          'id': 'n1',
          'texto': 'Válida.',
          'fecha_creacion': '2026-05-13T00:00:00.000Z',
        },
        'n2': 'cadena suelta no es nota',
        'n3': {
          'id': 'n3',
          // falta texto, falta fecha → TypeError al castear
        },
      };
      final reconstruido = NotasLibres.deserializar(mapaConBasura);
      expect(reconstruido.notaConId('n1'), isNotNull);
      expect(reconstruido.notaConId('n2'), isNull);
      expect(reconstruido.notaConId('n3'), isNull);
    });
  });

  group('RepositorioNotasLibres', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('perfil nuevo: cargar devuelve vacío', () async {
      final repo = RepositorioNotasLibres(idPerfil: 'test-1');
      final notas = await repo.cargar();
      expect(notas.vacio, isTrue);
    });

    test('anyadirNota persiste y se recupera con id generado', () async {
      var contadorId = 0;
      final repo = RepositorioNotasLibres(
        idPerfil: 'test-2',
        relojInyectado: () => DateTime.utc(2026, 5, 13),
        generadorIdInyectado: () => 'id-fijo-${++contadorId}',
      );
      await repo.anyadirNota(texto: 'Primera.');
      await repo.anyadirNota(texto: 'Segunda.');

      final repoReabierto = RepositorioNotasLibres(idPerfil: 'test-2');
      final notas = await repoReabierto.cargar();
      expect(notas.cantidad, 2);
      expect(notas.notaConId('id-fijo-1')!.texto, 'Primera.');
      expect(notas.notaConId('id-fijo-2')!.texto, 'Segunda.');
    });

    test('editarNota actualiza y persiste fechaUltimaEdicion', () async {
      var ahora = DateTime.utc(2026, 5, 13);
      final repo = RepositorioNotasLibres(
        idPerfil: 'test-3',
        relojInyectado: () => ahora,
        generadorIdInyectado: () => 'unica',
      );
      await repo.anyadirNota(texto: 'Original.');
      ahora = DateTime.utc(2026, 5, 15);
      await repo.editarNota(id: 'unica', texto: 'Revisada.');

      final notas = await repo.cargar();
      final nota = notas.notaConId('unica')!;
      expect(nota.texto, 'Revisada.');
      expect(nota.fechaUltimaEdicion, DateTime.utc(2026, 5, 15));
    });

    test('borrarNota elimina y persiste', () async {
      final repo = RepositorioNotasLibres(
        idPerfil: 'test-4',
        relojInyectado: () => DateTime.utc(2026, 5, 13),
        generadorIdInyectado: () => 'unica',
      );
      await repo.anyadirNota(texto: 'Borrable.');
      await repo.borrarNota('unica');

      final notas = await repo.cargar();
      expect(notas.vacio, isTrue);
    });

    test('perfiles distintos no se contaminan', () async {
      final ana = RepositorioNotasLibres(
        idPerfil: 'ana',
        generadorIdInyectado: () => 'ana-1',
      );
      final luis = RepositorioNotasLibres(idPerfil: 'luis');
      await ana.anyadirNota(texto: 'Nota de Ana.');

      final notasAna = await ana.cargar();
      final notasLuis = await luis.cargar();
      expect(notasAna.cantidad, 1);
      expect(notasLuis.vacio, isTrue);
    });
  });
}
