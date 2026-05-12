// Guardarraíl técnico del riesgo R1 (auditoría 2026-05-12). Ver el
// archivo equivalente en `apps/agro/test/sello_provisional_test.dart`
// para la justificación completa.
//
// Hasta que un técnico OCA real audite el formato del Cuaderno PAC
// olivar (RD 1311/2012) y un auditor AICA audite el Libro de
// Movimientos del Aceite (RD 760/2021), el subtítulo de cada PDF
// debe seguir llevando la palabra PROVISIONAL. Eliminarla sin la
// validación humana expondría al titular a una posible no conformidad
// en inspección.

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

  test(
    'generador_libro_aceite_pdf.dart conserva el sello PROVISIONAL hasta validación AICA',
    () {
      final fuente = File('lib/servicios/generador_libro_aceite_pdf.dart')
          .readAsStringSync();
      expect(
        fuente,
        contains("PROVISIONAL"),
        reason:
            'Si vas a quitar la palabra PROVISIONAL del Libro de Movimientos '
            'del Aceite, un auditor AICA humano debe haber validado el '
            'formato primero (RD 760/2021 + circulares AICA vigentes). '
            'Documenta el commit + nombre del auditor en '
            'BLOQUEOS-PENDIENTES.md (bloqueo F1-A5) y actualiza este test '
            'antes de mergear. Ver auditoría 2026-05-12 riesgo R1.',
      );
    },
  );

  test(
    'configuracion_fiscal.dart conserva el sello PROVISIONAL hasta validación fiscal',
    () {
      final fuente =
          File('lib/modelos/configuracion_fiscal.dart').readAsStringSync();
      expect(
        fuente,
        contains("PROVISIONAL"),
        reason:
            'Si vas a quitar la palabra PROVISIONAL de la configuración '
            'fiscal olivar, un asesor fiscal agroalimentario humano debe '
            'haber validado las reglas de IVA/REAGP para venta de '
            'aceituna, aceite envasado, aceite a granel y subproductos. '
            'Documenta el commit + nombre del asesor en '
            'BLOQUEOS-PENDIENTES.md (bloqueo F1-A9) y actualiza este test '
            'antes de mergear. Ver auditoría 2026-05-12 riesgo R1.',
      );
    },
  );

  test(
    'generador_extracto_economico.dart conserva el sello PROVISIONAL hasta validación fiscal',
    () {
      final fuente =
          File('lib/servicios/generador_extracto_economico.dart')
              .readAsStringSync();
      expect(
        fuente,
        contains("PROVISIONAL"),
        reason:
            'Si vas a quitar la palabra PROVISIONAL del extracto económico '
            'olivar, el asesor fiscal agroalimentario debe haber validado '
            'antes que el desglose por tipo y el modelo 347 implementados '
            'son correctos para el régimen REAGP del olivar. Documenta el '
            'commit + nombre del asesor en BLOQUEOS-PENDIENTES.md (bloqueo '
            'F1-A9) y actualiza este test antes de mergear. Ver auditoría '
            '2026-05-12 riesgo R1.',
      );
    },
  );
}
