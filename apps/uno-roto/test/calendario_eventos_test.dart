import 'package:flutter_test/flutter_test.dart';
import 'package:uno_roto/dominio/ambiente_cielo.dart';
import 'package:uno_roto/dominio/calendario_eventos.dart';

/// Tests del calendario de eventos efímeros. Verifican que los tres
/// eventos del MVP se activan en sus fechas correctas, no se activan
/// fuera de ellas, y que el filtro por distrito funciona.
void main() {
  group('CalendarioEventos.deHoy', () {
    test('día normal sin eventos → null en todos los distritos', () {
      final unDiaCualquiera = DateTime(2026, 5, 4, 21, 0);
      const distritos = [
        'tejados',
        'canales',
        'mercado',
        'industria',
        'puerto',
        'afueras',
      ];
      for (final id in distritos) {
        final evento =
            CalendarioEventos.deHoy(ahora: unDiaCualquiera, idDistrito: id);
        expect(evento, isNull, reason: '$id en mayo no debe tener evento');
      }
    });

    test('20 de marzo activa el equinoccio mayor en todos los distritos', () {
      final equinoccio = DateTime(2026, 3, 20, 22, 0);
      const distritos = [
        'tejados',
        'canales',
        'mercado',
        'industria',
        'puerto',
        'afueras',
      ];
      for (final id in distritos) {
        final evento =
            CalendarioEventos.deHoy(ahora: equinoccio, idDistrito: id);
        expect(evento, isNotNull, reason: '$id en equinoccio debe tener evento');
        expect(evento!.id, 'equinoccio_mayor');
        expect(evento.ambiente, AmbienteCielo.cieloLimpioMontana);
      }
    });

    test('21 de marzo (segundo día) también activa el equinoccio mayor', () {
      final segundoDia = DateTime(2026, 3, 21, 21, 0);
      final evento = CalendarioEventos.deHoy(
        ahora: segundoDia,
        idDistrito: 'puerto',
      );
      expect(evento?.id, 'equinoccio_mayor');
    });

    test('19 de marzo (víspera) no tiene evento', () {
      final vispera = DateTime(2026, 3, 19, 22, 0);
      final evento = CalendarioEventos.deHoy(
        ahora: vispera,
        idDistrito: 'puerto',
      );
      expect(evento, isNull);
    });

    test('22 de septiembre activa el equinoccio menor SOLO en el Mercado',
        () {
      final equinoccioMenor = DateTime(2026, 9, 22, 22, 0);
      final eventoMercado = CalendarioEventos.deHoy(
        ahora: equinoccioMenor,
        idDistrito: 'mercado',
      );
      expect(eventoMercado, isNotNull);
      expect(eventoMercado!.id, 'equinoccio_menor');

      // Otros distritos: nada.
      const otros = ['tejados', 'canales', 'industria', 'puerto', 'afueras'];
      for (final id in otros) {
        final ev = CalendarioEventos.deHoy(
          ahora: equinoccioMenor,
          idDistrito: id,
        );
        expect(ev, isNull,
            reason: '$id no debe tener evento en el equinoccio menor');
      }
    });

    test('5 de noviembre activa la procesión de los Setenta y Tres en todos',
        () {
      final procesion = DateTime(2026, 11, 5, 23, 0);
      const distritos = [
        'tejados',
        'canales',
        'mercado',
        'industria',
        'puerto',
        'afueras',
      ];
      for (final id in distritos) {
        final evento =
            CalendarioEventos.deHoy(ahora: procesion, idDistrito: id);
        expect(evento?.id, 'procesion_setenta_tres', reason: 'falla en $id');
        expect(evento!.ambiente, AmbienteCielo.nieblaSuave);
      }
    });

    test('los tres eventos del MVP existen en el catálogo', () {
      final ids = CalendarioEventos.todos.map((e) => e.id).toSet();
      expect(ids, containsAll([
        'equinoccio_mayor',
        'equinoccio_menor',
        'procesion_setenta_tres',
      ]));
    });

    test('cada evento tiene mensaje no vacío', () {
      for (final ev in CalendarioEventos.todos) {
        expect(ev.mensajeAlEntrar.trim().isNotEmpty, isTrue,
            reason: '${ev.id} sin mensaje');
      }
    });

    test('hora del día se ignora — solo importa la fecha', () {
      final manana = DateTime(2026, 3, 20, 7, 0);
      final tarde = DateTime(2026, 3, 20, 19, 0);
      final noche = DateTime(2026, 3, 20, 23, 30);
      final eA = CalendarioEventos.deHoy(ahora: manana, idDistrito: 'tejados');
      final eB = CalendarioEventos.deHoy(ahora: tarde, idDistrito: 'tejados');
      final eC = CalendarioEventos.deHoy(ahora: noche, idDistrito: 'tejados');
      expect(eA?.id, 'equinoccio_mayor');
      expect(eB?.id, 'equinoccio_mayor');
      expect(eC?.id, 'equinoccio_mayor');
    });

    test('año distinto, misma fecha → mismo evento', () {
      // Los eventos se repiten cada año en la misma fecha calendárica.
      final hoy = DateTime(2026, 11, 5, 22, 0);
      final pasado = DateTime(2024, 11, 5, 22, 0);
      final futuro = DateTime(2030, 11, 5, 22, 0);
      final eA = CalendarioEventos.deHoy(ahora: hoy, idDistrito: 'canales');
      final eB = CalendarioEventos.deHoy(ahora: pasado, idDistrito: 'canales');
      final eC = CalendarioEventos.deHoy(ahora: futuro, idDistrito: 'canales');
      expect(eA?.id, 'procesion_setenta_tres');
      expect(eB?.id, 'procesion_setenta_tres');
      expect(eC?.id, 'procesion_setenta_tres');
    });
  });

  group('EventoCalendario.aplicaEn', () {
    test('aplica si el día y el distrito están dentro', () {
      final aplica = CalendarioEventos.equinoccioMenor.aplicaEn(
        ahora: DateTime(2026, 9, 23, 22, 0),
        idDistrito: 'mercado',
      );
      expect(aplica, isTrue);
    });

    test('no aplica si el distrito no está en la lista', () {
      final aplica = CalendarioEventos.equinoccioMenor.aplicaEn(
        ahora: DateTime(2026, 9, 23, 22, 0),
        idDistrito: 'puerto',
      );
      expect(aplica, isFalse);
    });

    test('distritosAfectados=null → aplica a cualquier distrito', () {
      final aplica = CalendarioEventos.equinoccioMayor.aplicaEn(
        ahora: DateTime(2026, 3, 20, 22, 0),
        idDistrito: 'industria',
      );
      expect(aplica, isTrue);
    });
  });
}
