import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uno_roto/datos/exportador_progreso.dart';
import 'package:uno_roto/datos/repositorio_progreso.dart';

void main() {
  group('ExportadorProgreso', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('export con perfil vacío produce JSON válido con lista vacía',
        () async {
      final repo = RepositorioProgreso();
      final exp = ExportadorProgreso(repo);

      final json = await exp.exportarPerfilActivoComoJson();
      final decoded = jsonDecode(json) as Map<String, dynamic>;

      expect(decoded['version'], ExportadorProgreso.versionFormato);
      expect(decoded['perfil'], 'principal');
      expect(decoded['entradas'], isEmpty);
      expect(decoded['exportadoEn'], isA<String>());
    });

    test('export recoge claves del perfil activo y omite globales',
        () async {
      SharedPreferences.setMockInitialValues({
        'uroto.perfil.principal.esquirlas_total': 42,
        'uroto.perfil.principal.nombre_jugador': 'Izan',
        'uroto.perfil.principal.flag.combate_kurz_1_completado': true,
        'uroto.perfil.principal.demos_puzzles_vistos': <String>['amplificar', 'comparacion'],
        'uroto.token_backend': 'jwt-secret', // global, debe excluirse
        'uroto.idioma_app': 'es', // global, debe excluirse
        'uroto.perfil.otro.esquirlas_total': 99, // otro perfil, debe excluirse
      });

      final repo = RepositorioProgreso();
      final exp = ExportadorProgreso(repo);
      final json = await exp.exportarPerfilActivoComoJson();
      final decoded = jsonDecode(json) as Map<String, dynamic>;
      final entradas = (decoded['entradas'] as List)
          .cast<Map<String, dynamic>>();

      final claves = entradas.map((e) => e['clave'] as String).toSet();
      expect(claves, contains('esquirlas_total'));
      expect(claves, contains('nombre_jugador'));
      expect(claves, contains('flag.combate_kurz_1_completado'));
      expect(claves, contains('demos_puzzles_vistos'));
      expect(claves.length, 4,
          reason: 'no debe exportar claves globales ni de otros perfiles');
    });

    test(
        'export → import ida y vuelta restaura exactamente el progreso',
        () async {
      SharedPreferences.setMockInitialValues({
        'uroto.perfil.principal.esquirlas_total': 127,
        'uroto.perfil.principal.nombre_jugador': 'Izan',
        'uroto.perfil.principal.rango_actual': 2,
        'uroto.perfil.principal.flag.escena_1_7_vista': true,
        'uroto.perfil.principal.demos_puzzles_vistos': <String>[
          'amplificar',
          'comparacion',
          'simplificar',
        ],
        'uroto.perfil.principal.audio.volumen.musica': 0.6,
      });

      final repo = RepositorioProgreso();
      final exp = ExportadorProgreso(repo);
      final json = await exp.exportarPerfilActivoComoJson();

      // Borramos para simular reinstalación
      final prefs = await SharedPreferences.getInstance();
      for (final clave in prefs.getKeys().toList()) {
        await prefs.remove(clave);
      }
      expect(prefs.getKeys(), isEmpty);

      final restauradas = await exp.importarPerfilActivoDesdeJson(json);
      expect(restauradas, 6);

      expect(prefs.getInt('uroto.perfil.principal.esquirlas_total'), 127);
      expect(prefs.getString('uroto.perfil.principal.nombre_jugador'), 'Izan');
      expect(prefs.getInt('uroto.perfil.principal.rango_actual'), 2);
      expect(
        prefs.getBool('uroto.perfil.principal.flag.escena_1_7_vista'),
        isTrue,
      );
      expect(
        prefs.getStringList('uroto.perfil.principal.demos_puzzles_vistos'),
        ['amplificar', 'comparacion', 'simplificar'],
      );
      expect(
        prefs.getDouble('uroto.perfil.principal.audio.volumen.musica'),
        0.6,
      );
    });

    test('import borra entradas previas del perfil antes de restaurar',
        () async {
      SharedPreferences.setMockInitialValues({
        'uroto.perfil.principal.esquirlas_total': 50,
        'uroto.perfil.principal.flag.escena_vieja': true,
      });

      final repo = RepositorioProgreso();
      final exp = ExportadorProgreso(repo);

      // Backup con SOLO esquirlas — no incluye la flag vieja
      final backup = jsonEncode({
        'version': ExportadorProgreso.versionFormato,
        'perfil': 'principal',
        'exportadoEn': '2026-05-01T10:00:00Z',
        'entradas': [
          {'clave': 'esquirlas_total', 'tipo': 'int', 'valor': 200},
        ],
      });

      await exp.importarPerfilActivoDesdeJson(backup);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getInt('uroto.perfil.principal.esquirlas_total'), 200);
      expect(
        prefs.getBool('uroto.perfil.principal.flag.escena_vieja'),
        isNull,
        reason:
            'la flag vieja debe haberse borrado — sin esto, restaurar un '
            'backup "limpio" arrastraría flags huérfanos del estado actual',
      );
    });

    test('import preserva otros perfiles y claves globales', () async {
      SharedPreferences.setMockInitialValues({
        'uroto.perfil.principal.esquirlas_total': 50,
        'uroto.perfil.alex.esquirlas_total': 99,
        'uroto.perfil.alex.nombre_jugador': 'Alex',
        'uroto.token_backend': 'jwt-secret',
        'uroto.idioma_app': 'ca',
      });

      final repo = RepositorioProgreso();
      final exp = ExportadorProgreso(repo);
      final backup = jsonEncode({
        'version': ExportadorProgreso.versionFormato,
        'perfil': 'principal',
        'exportadoEn': '2026-05-01T10:00:00Z',
        'entradas': [
          {'clave': 'esquirlas_total', 'tipo': 'int', 'valor': 300},
        ],
      });

      await exp.importarPerfilActivoDesdeJson(backup);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getInt('uroto.perfil.principal.esquirlas_total'), 300);
      expect(prefs.getInt('uroto.perfil.alex.esquirlas_total'), 99);
      expect(prefs.getString('uroto.perfil.alex.nombre_jugador'), 'Alex');
      expect(prefs.getString('uroto.token_backend'), 'jwt-secret');
      expect(prefs.getString('uroto.idioma_app'), 'ca');
    });

    test('import rechaza JSON malformado con FormatException', () async {
      final repo = RepositorioProgreso();
      final exp = ExportadorProgreso(repo);
      expect(
        () => exp.importarPerfilActivoDesdeJson('no es json'),
        throwsA(isA<FormatException>()),
      );
    });

    test('import rechaza versión futura con FormatException', () async {
      final repo = RepositorioProgreso();
      final exp = ExportadorProgreso(repo);
      final backup = jsonEncode({
        'version': 99,
        'perfil': 'principal',
        'entradas': [],
      });
      expect(
        () => exp.importarPerfilActivoDesdeJson(backup),
        throwsA(isA<FormatException>()),
      );
    });

    test('import sin lista de entradas falla', () async {
      final repo = RepositorioProgreso();
      final exp = ExportadorProgreso(repo);
      final backup = jsonEncode({
        'version': ExportadorProgreso.versionFormato,
        'perfil': 'principal',
      });
      expect(
        () => exp.importarPerfilActivoDesdeJson(backup),
        throwsA(isA<FormatException>()),
      );
    });
  });
}
