import 'package:flutter_test/flutter_test.dart';
import 'package:uno_roto/dominio/ambiente_cielo.dart';
import 'package:uno_roto/dominio/clima_distrito.dart';

/// Tests del módulo puro `ClimaDistrito`. Verifican el contrato
/// determinista (mismo día → mismo ambiente, otro día → puede cambiar)
/// y que los seis distritos canónicos siempre devuelven un ambiente
/// del catálogo.
void main() {
  // Constantes de fecha para fijar tests sin depender del reloj real.
  final unaFecha = DateTime(2026, 5, 4, 21, 30);
  final misMaFechaOtraHora = DateTime(2026, 5, 4, 8, 15);
  final fechaSiguiente = DateTime(2026, 5, 5, 21, 30);
  final fechaLejana = DateTime(2026, 11, 12, 12, 0);

  const distritosCanonicos = [
    'tejados',
    'canales',
    'mercado',
    'industria',
    'puerto',
    'afueras',
  ];

  const ambientesValidos = [
    AmbienteCielo.nocheDespejada,
    AmbienteCielo.niebla,
    AmbienteCielo.nieblaSuave,
    AmbienteCielo.lluviaLigera,
    AmbienteCielo.cieloLimpioMontana,
  ];

  group('ClimaDistrito.delDia — determinismo', () {
    test('mismo (idDistrito, fecha) → mismo ambiente, ignorando hora', () {
      for (final id in distritosCanonicos) {
        final a = ClimaDistrito.delDia(idDistrito: id, ahora: unaFecha);
        final b =
            ClimaDistrito.delDia(idDistrito: id, ahora: misMaFechaOtraHora);
        expect(a, same(b),
            reason: 'En $id, distintas horas del mismo día deben dar '
                'el mismo ambiente.');
      }
    });

    test('llamadas repetidas con la misma fecha devuelven el mismo objeto', () {
      // Pedirlo varias veces seguidas no debe fluctuar.
      for (final id in distritosCanonicos) {
        final muestras = List.generate(
          5,
          (_) => ClimaDistrito.delDia(idDistrito: id, ahora: unaFecha),
        );
        expect(muestras.toSet().length, 1,
            reason: '$id debe devolver el mismo ambiente para 5 llamadas '
                'con la misma fecha');
      }
    });

    test('id de distrito desconocido cae a la tabla de tejados', () {
      final desconocido =
          ClimaDistrito.delDia(idDistrito: 'inventado', ahora: unaFecha);
      expect(ambientesValidos, contains(desconocido));
    });
  });

  group('ClimaDistrito.delDia — catálogo válido', () {
    test('cada distrito devuelve un ambiente del catálogo conocido', () {
      // Iteramos 30 días por distrito para cubrir varias semillas.
      for (final id in distritosCanonicos) {
        for (var dia = 0; dia < 30; dia++) {
          final fecha = unaFecha.add(Duration(days: dia));
          final ambiente =
              ClimaDistrito.delDia(idDistrito: id, ahora: fecha);
          expect(ambientesValidos, contains(ambiente),
              reason: 'En $id día +$dia, ambiente fuera del catálogo.');
        }
      }
    });

    test('Afueras tiene cieloLimpioMontana entre los climas posibles', () {
      // Distintivo del distrito según la crónica de Mire Cordo: las
      // Afueras tienen Montaña visible muchos días. Buscamos al menos
      // una aparición en 60 días.
      final ambientesEnAfueras = <AmbienteCielo>{};
      for (var dia = 0; dia < 60; dia++) {
        final fecha = unaFecha.add(Duration(days: dia));
        ambientesEnAfueras.add(
          ClimaDistrito.delDia(idDistrito: 'afueras', ahora: fecha),
        );
      }
      expect(ambientesEnAfueras, contains(AmbienteCielo.cieloLimpioMontana));
    });

    test('Canales tiene niebla entre los climas frecuentes', () {
      final ambientesEnCanales = <AmbienteCielo>{};
      for (var dia = 0; dia < 60; dia++) {
        final fecha = unaFecha.add(Duration(days: dia));
        ambientesEnCanales.add(
          ClimaDistrito.delDia(idDistrito: 'canales', ahora: fecha),
        );
      }
      expect(ambientesEnCanales, contains(AmbienteCielo.niebla));
    });

    test('Tejados rara vez tiene niebla densa', () {
      // El catálogo de tejados solo tiene nieblaSuave (no niebla
      // densa). En 60 días no debería aparecer la niebla densa.
      for (var dia = 0; dia < 60; dia++) {
        final fecha = unaFecha.add(Duration(days: dia));
        final ambiente =
            ClimaDistrito.delDia(idDistrito: 'tejados', ahora: fecha);
        expect(ambiente, isNot(same(AmbienteCielo.niebla)),
            reason: 'Tejados día +$dia tiene niebla densa, no debería.');
      }
    });
  });

  group('ClimaDistrito.delDia — variación entre días y distritos', () {
    test(
        'a lo largo de 30 días, un distrito ve más de un ambiente distinto',
        () {
      // No exigimos un mínimo concreto (depende del hash) pero al menos
      // dos ambientes deben aparecer — si todo el mes saliera idéntico,
      // sería sospechoso.
      for (final id in distritosCanonicos) {
        final ambientesVistos = <AmbienteCielo>{};
        for (var dia = 0; dia < 30; dia++) {
          final fecha = unaFecha.add(Duration(days: dia));
          ambientesVistos
              .add(ClimaDistrito.delDia(idDistrito: id, ahora: fecha));
        }
        expect(ambientesVistos.length, greaterThanOrEqualTo(2),
            reason: '$id en 30 días debe ver al menos 2 ambientes.');
      }
    });

    test(
        'el mismo día, distintos distritos pueden tener ambientes distintos',
        () {
      // No es obligatorio (puede haber colisiones), pero en un día
      // probado a mano debe haber variación entre los seis.
      final ambientesHoy = distritosCanonicos
          .map((id) => ClimaDistrito.delDia(idDistrito: id, ahora: fechaLejana))
          .toSet();
      expect(ambientesHoy.length, greaterThanOrEqualTo(2),
          reason: 'Los seis distritos no deberían colapsar al mismo '
              'ambiente cualquier día.');
    });

    test('la fecha sí influye: dos días distintos pueden cambiar', () {
      // Probamos varios distritos hasta encontrar al menos uno donde el
      // día siguiente cambia el ambiente. Si la función no usara la
      // fecha en absoluto, esto fallaría siempre.
      var huboCambio = false;
      for (final id in distritosCanonicos) {
        final hoy = ClimaDistrito.delDia(idDistrito: id, ahora: unaFecha);
        final manana =
            ClimaDistrito.delDia(idDistrito: id, ahora: fechaSiguiente);
        if (hoy != manana) huboCambio = true;
      }
      expect(huboCambio, isTrue,
          reason: 'Al menos un distrito debe cambiar entre dos días '
              'consecutivos.');
    });
  });
}
