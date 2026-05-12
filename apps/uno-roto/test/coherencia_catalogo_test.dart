// Asegura que el catálogo de habilidades (`assets/data/skills.json`) y
// el mapeo de habilidades a puzzles (`skillsConPuzzleImplementado` en
// `mapeo_habilidades_puzzle.dart`) se mantengan sincronizados. Si una
// habilidad se añade al catálogo sin puzzle (o viceversa), este test
// falla con la lista exacta de IDs descuajaringados.
//
// Existe porque el catálogo creció de 66 a 76 habilidades el 2026-05-12
// (commit 2f87a7e). La auditoría señaló que no había guardarraíl para
// la próxima vez.

import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:uno_roto/dominio/mapeo_habilidades_puzzle.dart';

void main() {
  test('todos los skill_id del catálogo tienen puzzle implementado', () {
    final ficheroCatalogo = File(
      '${Directory.current.path}/assets/data/skills.json',
    );
    expect(
      ficheroCatalogo.existsSync(),
      isTrue,
      reason: 'Falta assets/data/skills.json',
    );
    final catalogoRaw = jsonDecode(ficheroCatalogo.readAsStringSync())
        as Map<String, dynamic>;
    final habilidadesRaw = catalogoRaw['skills'] as List<dynamic>;
    final idsCatalogo = habilidadesRaw
        .map((s) => (s as Map<String, dynamic>)['id'] as String)
        .toSet();

    final totalDeclarado = catalogoRaw['total_skills'] as int;
    expect(
      idsCatalogo.length,
      totalDeclarado,
      reason: 'total_skills ($totalDeclarado) no cuadra con array skills (${idsCatalogo.length})',
    );

    final faltanPuzzle = idsCatalogo.difference(skillsConPuzzleImplementado);
    final puzzlesHuerfanos = skillsConPuzzleImplementado.difference(idsCatalogo);

    expect(
      faltanPuzzle,
      isEmpty,
      reason: 'habilidades en el catálogo sin entrada en skillsConPuzzleImplementado: $faltanPuzzle',
    );
    expect(
      puzzlesHuerfanos,
      isEmpty,
      reason: 'IDs en skillsConPuzzleImplementado que no existen en el catálogo: $puzzlesHuerfanos',
    );
  });
}
