import 'package:flutter_test/flutter_test.dart';
import 'package:nuevo_ser_core/nuevo_ser_core.dart';
import 'package:uno_roto/datos/catalogo_habilidades.dart';
import 'package:uno_roto/dominio/motor_maestria.dart';

/// Tests del decaimiento. Pin del comportamiento escalonado:
///
/// - 0..21d sin practicar desde maestría → sigue en maestría.
/// - 21..35d sin practicar desde maestría → cae a competente.
/// - >35d sin practicar desde maestría → cae a enDesarrollo.
/// - 0..14d sin practicar desde competente → sigue en competente.
/// - >14d sin practicar desde competente → cae a enDesarrollo.
///
/// Antes del fix, cruzar 21 días desde maestría caía DIRECTAMENTE
/// a enDesarrollo (saltándose competente) porque ambas condiciones
/// se evaluaban contra el mismo `dias` desde la última práctica
/// — y como 21 > 14, también se cumplía la segunda.
void main() {
  // Reglas estándar del catálogo del MVP.
  const reglas = ReglasDecaimiento(
    diasMaestriaACompetente: 21,
    diasCompetenteAEnDesarrollo: 14,
    nivelSuelo: 1, // introducida
  );

  // Catálogo sintético — sólo necesitamos las reglas; las habilidades
  // no participan en el cálculo de aplicarDecaimiento.
  final catalogo = CatalogoHabilidades.paraTests(
    reglasDecaimiento: reglas,
  );

  late MotorMaestria motor;

  setUp(() {
    motor = MotorMaestria(
      catalogo: catalogo,
      cargarEstado: (_) async => null,
      guardarEstado: (_) async {},
    );
  });

  EstadoHabilidad estadoEn(NivelMaestria nivel,
      {DateTime? ultimaPractica, int totalExposiciones = 5}) {
    final base = EstadoHabilidad.inicial('FR.05');
    return base.copiarCon(
      nivel: nivel,
      ultimaPractica: ultimaPractica ?? DateTime(2026, 4, 1),
      totalExposiciones: totalExposiciones,
    );
  }

  group('desde maestría', () {
    test('20 días → sigue en maestría', () {
      final estado = estadoEn(NivelMaestria.maestria,
          ultimaPractica: DateTime(2026, 4, 1));
      final resultado = motor.aplicarDecaimiento(
        estado,
        ahora: DateTime(2026, 4, 21), // 20 días
      );
      expect(resultado.nivel, NivelMaestria.maestria);
    });

    test('22 días → cae a competente (no a enDesarrollo)', () {
      // Este es el caso del bug arreglado: cruzar 21 días no debe
      // dumpearte dos niveles de golpe.
      final estado = estadoEn(NivelMaestria.maestria,
          ultimaPractica: DateTime(2026, 4, 1));
      final resultado = motor.aplicarDecaimiento(
        estado,
        ahora: DateTime(2026, 4, 23), // 22 días
      );
      expect(resultado.nivel, NivelMaestria.competente,
          reason: 'A los 22 días desde maestría debería caer SOLO un '
              'escalón (competente), no saltar dos a enDesarrollo.');
    });

    test('30 días → sigue en competente (escalón intermedio)', () {
      final estado = estadoEn(NivelMaestria.maestria,
          ultimaPractica: DateTime(2026, 4, 1));
      final resultado = motor.aplicarDecaimiento(
        estado,
        ahora: DateTime(2026, 5, 1), // 30 días
      );
      expect(resultado.nivel, NivelMaestria.competente,
          reason: 'Entre 21 y 35 días desde maestría, el nivel se '
              'estabiliza en competente.');
    });

    test('40 días → cae a enDesarrollo (cruza 21+14=35d)', () {
      final estado = estadoEn(NivelMaestria.maestria,
          ultimaPractica: DateTime(2026, 4, 1));
      final resultado = motor.aplicarDecaimiento(
        estado,
        ahora: DateTime(2026, 5, 11), // 40 días
      );
      expect(resultado.nivel, NivelMaestria.enDesarrollo);
    });
  });

  group('desde competente', () {
    test('10 días → sigue en competente', () {
      final estado = estadoEn(NivelMaestria.competente,
          ultimaPractica: DateTime(2026, 4, 1));
      final resultado = motor.aplicarDecaimiento(
        estado,
        ahora: DateTime(2026, 4, 11),
      );
      expect(resultado.nivel, NivelMaestria.competente);
    });

    test('15 días → cae a enDesarrollo', () {
      final estado = estadoEn(NivelMaestria.competente,
          ultimaPractica: DateTime(2026, 4, 1));
      final resultado = motor.aplicarDecaimiento(
        estado,
        ahora: DateTime(2026, 4, 16),
      );
      expect(resultado.nivel, NivelMaestria.enDesarrollo);
    });
  });

  group('niveles inferiores y suelo', () {
    test('inexplorada nunca decae aunque pasen meses', () {
      final estado = estadoEn(NivelMaestria.inexplorada,
          totalExposiciones: 0);
      final resultado = motor.aplicarDecaimiento(
        estado,
        ahora: DateTime(2026, 12, 31),
      );
      expect(resultado.nivel, NivelMaestria.inexplorada);
    });

    test('introducida no cae por debajo del suelo', () {
      // Suelo = 1 = introducida. Si el nivel ya es introducida, no
      // hay nada por debajo a lo que caer (excepto inexplorada, que
      // está reservada a "nunca tocada").
      final estado = estadoEn(NivelMaestria.introducida,
          ultimaPractica: DateTime(2026, 1, 1));
      final resultado = motor.aplicarDecaimiento(
        estado,
        ahora: DateTime(2026, 12, 31),
      );
      expect(resultado.nivel, NivelMaestria.introducida);
    });
  });
}
