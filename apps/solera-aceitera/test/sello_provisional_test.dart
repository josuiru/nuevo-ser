// Guardarraíl técnico del riesgo R1 (auditoría 2026-05-12). Ver el
// archivo equivalente en `apps/agro/test/sello_provisional_test.dart`
// para la justificación completa.
//
// Hasta que un técnico OCA real audite el formato del Cuaderno PAC
// olivar (RD 1311/2012) el subtítulo del PDF debe seguir llevando la
// palabra PROVISIONAL. Eliminarla sin la validación del técnico
// expondría al titular a una posible no conformidad en inspección.

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'generador_cuaderno_pac_pdf.dart conserva el sello PROVISIONAL hasta validación OCA',
    () {
      final fuente = File('lib/servicios/generador_cuaderno_pac_pdf.dart')
          .readAsStringSync();
      expect(
        fuente,
        contains("PROVISIONAL"),
        reason:
            'Si vas a quitar la palabra PROVISIONAL del Cuaderno PAC olivar, '
            'un técnico OCA / asesor APAE humano debe haber validado el '
            'formato primero. Documenta el commit + nombre del técnico en '
            'BLOQUEOS-PENDIENTES.md (bloqueo F1-A4) y actualiza este test '
            'antes de mergear. Ver auditoría 2026-05-12 riesgo R1.',
      );
    },
  );
}
