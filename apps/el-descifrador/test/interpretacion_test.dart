// Tests del modelo InterpretacionesPropuestas + RepositorioInterpretaciones.

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:el_descifrador/datos/repositorio_interpretaciones.dart';
import 'package:el_descifrador/dominio/interpretacion_pieza.dart';

void main() {
  group('InterpretacionPieza', () {
    test('serialización ida y vuelta sin revisión', () {
      final original = InterpretacionPieza(
        idPieza: 'p1',
        texto: 'Creo que es una receta de sopa de pescado.',
        fechaPropuesta: DateTime.utc(2026, 5, 13, 10, 30),
      );
      final reconstruido =
          InterpretacionPieza.deserializar(original.serializar());
      expect(reconstruido.idPieza, 'p1');
      expect(reconstruido.texto, 'Creo que es una receta de sopa de pescado.');
      expect(reconstruido.fechaPropuesta, DateTime.utc(2026, 5, 13, 10, 30));
      expect(reconstruido.fechaUltimaRevision, isNull);
    });

    test('serialización ida y vuelta con revisión', () {
      final original = InterpretacionPieza(
        idPieza: 'p1',
        texto: 'Ahora creo que también pide dos limones.',
        fechaPropuesta: DateTime.utc(2026, 5, 13, 10, 30),
        fechaUltimaRevision: DateTime.utc(2026, 5, 14, 16, 0),
      );
      final reconstruido =
          InterpretacionPieza.deserializar(original.serializar());
      expect(reconstruido.fechaUltimaRevision, DateTime.utc(2026, 5, 14, 16, 0));
    });
  });

  group('InterpretacionesPropuestas', () {
    test('estado inicial: vacío', () {
      final interpretaciones = InterpretacionesPropuestas.inicial();
      expect(interpretaciones.vacio, isTrue);
      expect(interpretaciones.interpretacionDe('p1'), isNull);
      expect(interpretaciones.ordenadasPorFecha(), isEmpty);
    });

    test('proponer primera vez fija fechaPropuesta y deja revisión nula', () {
      final ahora = DateTime.utc(2026, 5, 13, 10, 0);
      final interpretaciones = InterpretacionesPropuestas.inicial()
          .conInterpretacion(
        idPieza: 'p1',
        texto: 'Una receta.',
        ahora: ahora,
      );
      final interpretacion = interpretaciones.interpretacionDe('p1');
      expect(interpretacion, isNotNull);
      expect(interpretacion!.texto, 'Una receta.');
      expect(interpretacion.fechaPropuesta, ahora);
      expect(interpretacion.fechaUltimaRevision, isNull);
    });

    test('revisar conserva fechaPropuesta y registra fechaUltimaRevision', () {
      final primera = DateTime.utc(2026, 5, 13, 10, 0);
      final segunda = DateTime.utc(2026, 5, 15, 17, 30);
      var interpretaciones = InterpretacionesPropuestas.inicial()
          .conInterpretacion(
        idPieza: 'p1',
        texto: 'Una receta.',
        ahora: primera,
      );
      interpretaciones = interpretaciones.conInterpretacion(
        idPieza: 'p1',
        texto: 'Una receta que pide dos limones.',
        ahora: segunda,
      );
      final interpretacion = interpretaciones.interpretacionDe('p1');
      expect(interpretacion!.fechaPropuesta, primera);
      expect(interpretacion.fechaUltimaRevision, segunda);
      expect(interpretacion.texto, 'Una receta que pide dos limones.');
    });

    test('texto en blanco se ignora (no se sobreescribe)', () {
      final ahora = DateTime.utc(2026, 5, 13);
      var interpretaciones = InterpretacionesPropuestas.inicial()
          .conInterpretacion(
        idPieza: 'p1',
        texto: 'Original.',
        ahora: ahora,
      );
      interpretaciones = interpretaciones.conInterpretacion(
        idPieza: 'p1',
        texto: '   ',
        ahora: DateTime.utc(2026, 5, 14),
      );
      // No hay revisión: el texto en blanco no debe registrar nada.
      final interpretacion = interpretaciones.interpretacionDe('p1');
      expect(interpretacion!.texto, 'Original.');
      expect(interpretacion.fechaUltimaRevision, isNull);
    });

    test('ordenadasPorFecha devuelve más recientes primero', () {
      var interpretaciones = InterpretacionesPropuestas.inicial();
      interpretaciones = interpretaciones.conInterpretacion(
        idPieza: 'antigua',
        texto: 'A',
        ahora: DateTime.utc(2026, 5, 10),
      );
      interpretaciones = interpretaciones.conInterpretacion(
        idPieza: 'reciente',
        texto: 'B',
        ahora: DateTime.utc(2026, 5, 15),
      );
      final ordenadas = interpretaciones.ordenadasPorFecha();
      expect(ordenadas.first.idPieza, 'reciente');
      expect(ordenadas.last.idPieza, 'antigua');
    });

    test('serialización ida y vuelta preserva todo', () {
      var interpretaciones = InterpretacionesPropuestas.inicial();
      interpretaciones = interpretaciones.conInterpretacion(
        idPieza: 'p1',
        texto: 'Receta de bacalao.',
        ahora: DateTime.utc(2026, 5, 13),
      );
      interpretaciones = interpretaciones.conInterpretacion(
        idPieza: 'p1',
        texto: 'Receta de bacalao con dos limones.',
        ahora: DateTime.utc(2026, 5, 14),
      );
      interpretaciones = interpretaciones.conInterpretacion(
        idPieza: 'p2',
        texto: 'Carta a un médico.',
        ahora: DateTime.utc(2026, 5, 15),
      );

      final reconstruido = InterpretacionesPropuestas.deserializar(
        interpretaciones.serializar(),
      );
      expect(reconstruido.interpretacionDe('p1')!.texto,
          'Receta de bacalao con dos limones.');
      expect(reconstruido.interpretacionDe('p1')!.fechaUltimaRevision,
          DateTime.utc(2026, 5, 14));
      expect(reconstruido.interpretacionDe('p2')!.texto, 'Carta a un médico.');
    });

    test('deserialización tolera entradas mal formadas', () {
      final mapaConBasura = {
        'p1': {
          'id_pieza': 'p1',
          'texto': 'Texto válido.',
          'fecha_propuesta': '2026-05-13T10:00:00.000Z',
        },
        'p2': 'no es un mapa', // basura
        'p3': {
          'id_pieza': 'p3',
          'texto': 'Sin fecha',
          // falta fecha_propuesta → tipo error al castear
        },
      };
      final reconstruido =
          InterpretacionesPropuestas.deserializar(mapaConBasura);
      expect(reconstruido.interpretacionDe('p1'), isNotNull);
      expect(reconstruido.interpretacionDe('p2'), isNull);
      expect(reconstruido.interpretacionDe('p3'), isNull);
    });
  });

  group('RepositorioInterpretaciones', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('perfil nuevo: cargar devuelve vacío', () async {
      final repo = RepositorioInterpretaciones(idPerfil: 'test-1');
      final interpretaciones = await repo.cargar();
      expect(interpretaciones.vacio, isTrue);
    });

    test('proponer persiste y se recupera al reabrir', () async {
      final fechaFalsa = DateTime.utc(2026, 5, 13, 12, 0);
      final repo = RepositorioInterpretaciones(
        idPerfil: 'test-2',
        relojInyectado: () => fechaFalsa,
      );
      await repo.proponerInterpretacion(
        idPieza: 'p1',
        texto: 'Mi primera hipótesis.',
      );

      final repoReabierto = RepositorioInterpretaciones(idPerfil: 'test-2');
      final interpretaciones = await repoReabierto.cargar();
      final interpretacion = interpretaciones.interpretacionDe('p1');
      expect(interpretacion!.texto, 'Mi primera hipótesis.');
      expect(interpretacion.fechaPropuesta, fechaFalsa);
    });

    test('revisar actualiza texto y fechaUltimaRevision', () async {
      final primera = DateTime.utc(2026, 5, 13);
      final segunda = DateTime.utc(2026, 5, 15);
      var reloj = primera;
      final repo = RepositorioInterpretaciones(
        idPerfil: 'test-3',
        relojInyectado: () => reloj,
      );
      await repo.proponerInterpretacion(
        idPieza: 'p1',
        texto: 'Primera versión.',
      );
      reloj = segunda;
      await repo.proponerInterpretacion(
        idPieza: 'p1',
        texto: 'Segunda versión.',
      );

      final interpretaciones = await repo.cargar();
      final interpretacion = interpretaciones.interpretacionDe('p1');
      expect(interpretacion!.texto, 'Segunda versión.');
      expect(interpretacion.fechaPropuesta, primera);
      expect(interpretacion.fechaUltimaRevision, segunda);
    });

    test('perfiles distintos no se contaminan', () async {
      final ana = RepositorioInterpretaciones(idPerfil: 'ana');
      final luis = RepositorioInterpretaciones(idPerfil: 'luis');

      await ana.proponerInterpretacion(
        idPieza: 'p1',
        texto: 'Lo de Ana.',
      );

      final interpretacionesAna = await ana.cargar();
      final interpretacionesLuis = await luis.cargar();
      expect(interpretacionesAna.interpretacionDe('p1'), isNotNull);
      expect(interpretacionesLuis.interpretacionDe('p1'), isNull);
    });
  });
}
