// Guardarraíl técnico del riesgo R1 (auditoría 2026-05-12): mientras el
// asesor fiscal no haya validado el libro/extracto económico, el PDF
// generado lleva el sello "PROVISIONAL" en cabecera. Si alguien lo
// retira sin haber actualizado primero `BLOQUEOS-PENDIENTES.md` y la
// declaración formal de validación, este test falla.
//
// El test inspecciona el código fuente del generador (no su salida)
// porque (a) instanciar el generador requiere `BaseDatosAgro` con
// sqflite, fuera de scope de un test unitario sin ffi, y (b) la
// invariante a proteger es que el LITERAL `PROVISIONAL` siga en el
// código mientras la validación humana no haya entrado.

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
