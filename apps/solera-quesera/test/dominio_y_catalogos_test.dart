// Tests complementarios a `modelos_test.dart`. Cubren lo que ese test
// no llega:
// 1. Lógica derivada en modelos (`Pieza.perdidaPesoPorcentaje`).
// 2. Invariantes de los catálogos generados desde CSV.
// 3. Estado de revisión: ningún catálogo tiene `revisado_por` no vacío
//    hoy — señal estructural de provisionalidad (F1-5 / F1-10 del CLAUDE.md).
//
// Motivación: la auditoría 2026-05-12 (riesgo R2) señaló que con 1 sólo
// archivo de tests (~40 cases) para 14 modelos + 5 catálogos + generador
// PDF, una regresión en trazabilidad de lotes podía escaparse a producción.

import 'package:flutter_test/flutter_test.dart';

import 'package:solera_quesera/datos/catalogos_generados/defectos_queso.dart';
import 'package:solera_quesera/datos/catalogos_generados/do_quesos.dart';
import 'package:solera_quesera/datos/catalogos_generados/parametros_analitica.dart';
import 'package:solera_quesera/datos/catalogos_generados/razas_lecheras.dart';
import 'package:solera_quesera/datos/catalogos_generados/tipos_queso.dart';
import 'package:solera_quesera/modelos/pieza.dart';

void main() {
  group('Pieza — lógica derivada', () {
    final ahora = DateTime.now().millisecondsSinceEpoch;

    test('perdidaPesoPorcentaje devuelve null si pesoActual es null', () {
      final p = Pieza(
        loteProduccionId: 1,
        numeroPieza: '20260101-001-01',
        pesoInicial: 2.5,
        // pesoActual: null por defecto
        fechaCreacionMs: ahora,
      );
      expect(p.perdidaPesoPorcentaje, isNull);
    });

    test('perdidaPesoPorcentaje devuelve null si pesoInicial es 0', () {
      final p = Pieza(
        loteProduccionId: 1,
        numeroPieza: '20260101-001-01',
        pesoInicial: 0,
        pesoActual: 2.0,
        fechaCreacionMs: ahora,
      );
      expect(
        p.perdidaPesoPorcentaje,
        isNull,
        reason: 'Sin peso inicial no se puede calcular pérdida — devolver null en lugar de inf/NaN',
      );
    });

    test('perdidaPesoPorcentaje devuelve null si pesoInicial es negativo (defensivo)', () {
      final p = Pieza(
        loteProduccionId: 1,
        numeroPieza: '20260101-001-01',
        pesoInicial: -1.0,
        pesoActual: 2.0,
        fechaCreacionMs: ahora,
      );
      expect(p.perdidaPesoPorcentaje, isNull);
    });

    test('perdidaPesoPorcentaje calcula bien una pérdida típica de afinado', () {
      // 2.5 kg → 2.0 kg = 20% de pérdida (típico tras 60 días de afinado).
      final p = Pieza(
        loteProduccionId: 1,
        numeroPieza: '20260101-001-01',
        pesoInicial: 2.5,
        pesoActual: 2.0,
        fechaCreacionMs: ahora,
      );
      expect(p.perdidaPesoPorcentaje, closeTo(20.0, 1e-9));
    });

    test('perdidaPesoPorcentaje puede ser negativa si la pieza gana peso (raro pero permitido)', () {
      // Caso atípico: pieza absorbe humedad en cava muy húmeda.
      final p = Pieza(
        loteProduccionId: 1,
        numeroPieza: '20260101-001-01',
        pesoInicial: 2.0,
        pesoActual: 2.1,
        fechaCreacionMs: ahora,
      );
      expect(p.perdidaPesoPorcentaje, closeTo(-5.0, 1e-9));
    });

    test('round-trip toMap/fromMap preserva pesoActual null', () {
      final original = Pieza(
        loteProduccionId: 7,
        numeroPieza: '20260101-007-02',
        pesoInicial: 3.0,
        fechaCreacionMs: ahora,
      );
      final recuperada = Pieza.fromMap(original.toMap());
      expect(recuperada.pesoInicial, 3.0);
      expect(recuperada.pesoActual, isNull);
      expect(recuperada.estado, 'afinando');
      expect(recuperada.ubicacionActual, '');
    });

    test('round-trip toMap/fromMap preserva estado y pesoActual cuando los hay', () {
      final original = Pieza(
        loteProduccionId: 7,
        numeroPieza: '20260101-007-02',
        pesoInicial: 3.0,
        pesoActual: 2.7,
        estado: 'lista',
        ubicacionActual: 'Cava A · estante 3',
        fechaCreacionMs: ahora,
      );
      final recuperada = Pieza.fromMap(original.toMap());
      expect(recuperada.pesoActual, 2.7);
      expect(recuperada.estado, 'lista');
      expect(recuperada.ubicacionActual, 'Cava A · estante 3');
    });
  });

  group('Catálogos generados — invariantes', () {
    test('tipos_queso tiene exactamente las 23 filas declaradas en F1-5', () {
      expect(todosTipoQuesos, hasLength(23));
    });

    test('razas_lecheras tiene exactamente las 17 filas declaradas en F1-5', () {
      expect(todosRazaLecheras, hasLength(17));
    });

    test('do_quesos tiene exactamente las 15 filas declaradas en F1-5', () {
      expect(todosDoQuesos, hasLength(15));
    });

    test('defectos_queso tiene exactamente las 18 filas declaradas en F1-5', () {
      expect(todosDefectoQuesos, hasLength(18));
    });

    test('parametros_analitica tiene exactamente las 14 filas declaradas en F1-5', () {
      expect(todosParametroAnaliticas, hasLength(14));
    });

    test('ningún tipo de queso DO tiene curacion_minima_dias vacía (load-bearing legal)', () {
      final dos = todosTipoQuesos.where((t) => t.categoria.startsWith('do_'));
      for (final t in dos) {
        expect(
          t.curacion_minima_dias,
          isNot(isEmpty),
          reason: 'Tipo DO "${t.id}" sin curacion_minima_dias — bloquea validación de pliego',
        );
      }
    });

    test('todos los IDs de catálogo son únicos dentro de su catálogo', () {
      void verificarUnicos<T>(List<T> filas, String Function(T) idDe, String nombreCatalogo) {
        final ids = filas.map(idDe).toSet();
        expect(
          ids.length,
          filas.length,
          reason: 'IDs duplicados en $nombreCatalogo',
        );
      }
      verificarUnicos<TipoQueso>(todosTipoQuesos, (t) => t.id, 'tipos_queso');
      verificarUnicos<RazaLechera>(todosRazaLecheras, (r) => r.id, 'razas_lecheras');
      verificarUnicos<DoQueso>(todosDoQuesos, (d) => d.id, 'do_quesos');
      verificarUnicos<DefectoQueso>(todosDefectoQuesos, (d) => d.id, 'defectos_queso');
      verificarUnicos<ParametroAnalitica>(
        todosParametroAnaliticas,
        (p) => p.id,
        'parametros_analitica',
      );
    });
  });

  group('Catálogos generados — estado de revisión (hard limit: marcar provisionalidad)', () {
    test('hoy ningún catálogo tiene revisado_por (señal de F1-5 provisional)', () {
      final sinRevisar = <String>[];
      for (final t in todosTipoQuesos) {
        if (t.revisado_por.isNotEmpty) sinRevisar.add('tipos_queso/${t.id}');
      }
      for (final r in todosRazaLecheras) {
        if (r.revisado_por.isNotEmpty) sinRevisar.add('razas_lecheras/${r.id}');
      }
      for (final d in todosDoQuesos) {
        if (d.revisado_por.isNotEmpty) sinRevisar.add('do_quesos/${d.id}');
      }
      for (final d in todosDefectoQuesos) {
        if (d.revisado_por.isNotEmpty) sinRevisar.add('defectos_queso/${d.id}');
      }
      for (final p in todosParametroAnaliticas) {
        if (p.revisado_por.isNotEmpty) sinRevisar.add('parametros_analitica/${p.id}');
      }
      // Cuando el asesor quesero revise alguno, el test fallará y forzará
      // a actualizar este test + el banner provisional en UI. Es un
      // recordatorio estructural, no una invariante a mantener para
      // siempre.
      expect(
        sinRevisar,
        isEmpty,
        reason: 'Si revisado_por aparece, hay que actualizar este test + retirar el banner "PROVISIONAL"',
      );
    });
  });
}
