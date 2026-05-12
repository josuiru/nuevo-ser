// Guardarraíl técnico del riesgo R1 (auditoría 2026-05-12). Ver el
// archivo equivalente en `apps/agro/test/sello_provisional_test.dart`
// para la justificación completa.

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'generador_extracto_economico.dart conserva el sello PROVISIONAL hasta validación fiscal',
    () {
      final fuente = File('lib/servicios/generador_extracto_economico.dart')
          .readAsStringSync();
      expect(
        fuente,
        contains("'PROVISIONAL"),
        reason:
            'Si vas a quitar la palabra PROVISIONAL del extracto económico, el '
            'asesor fiscal humano debe haber validado primero. Documenta el '
            'commit + nombre del asesor en BLOQUEOS-PENDIENTES.md y actualiza '
            'este test antes de mergear. Ver auditoría 2026-05-12 riesgo R1.',
      );
    },
  );
}
