import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:uno_roto/datos/banco_ediciones_faro.dart';
import 'package:uno_roto/dominio/faro_de_azula.dart';

/// Tests del banco extendido del Faro (asset JSON v0.2).
///
/// Cargan el asset desde disco (no por `rootBundle`, así no hace
/// falta `ServicesBinding`) y verifican forma + correcciones que
/// aplicamos al doc fuente:
///
/// - 20 ediciones, numeradas 1234..1253 sin huecos.
/// - E3 dice producto **8** (no 12).
/// - E1 dice "próximas seis semanas" (no siete).
/// - E7 dice "Diecisiete personas" y "dos horas".
/// - E10 menciona "antes de la edad habitual".
/// - E20 cierra el hilo del faro lejano y revela K. R. T.
/// - Todos los acertijos tienen solucionCanonica no vacía.
void main() {
  late List<EdicionFaro> banco;

  setUpAll(() {
    final crudo = File('assets/data/faro_banco_v0_2.json').readAsStringSync();
    banco = parseBancoDesdeJson(crudo);
  });

  test('hay 20 ediciones en el banco extendido v0.2', () {
    expect(banco.length, 20);
  });

  test('numeros canónicos del periódico van 1234..1253', () {
    final numeros = banco.map((e) => e.numeroEdicion).toList();
    final esperados = List<int>.generate(20, (i) => 1234 + i);
    expect(numeros, esperados);
  });

  test('numeroSemana va 1..20 sin huecos', () {
    final semanas = banco.map((e) => e.numeroSemana).toList();
    final esperados = List<int>.generate(20, (i) => i + 1);
    expect(semanas, esperados);
  });

  test('todas las ediciones son del año 412 de la Orden', () {
    for (final e in banco) {
      expect(e.anioOrden, 412, reason: 'Edición ${e.numeroEdicion}');
    }
  });

  test('todos los acertijos tienen solución canónica no vacía', () {
    for (final e in banco) {
      expect(e.acertijo.solucionCanonica.trim().isNotEmpty, isTrue,
          reason: 'Edición ${e.numeroSemana} sin solución');
    }
  });

  test('todas las ediciones tienen al menos una noticia, una crónica y un acertijo',
      () {
    for (final e in banco) {
      expect(e.portada.isNotEmpty, isTrue,
          reason: 'Edición ${e.numeroSemana} sin portada');
      expect(e.cronica.titulo.trim().isNotEmpty, isTrue);
      expect(e.cronica.cuerpo.trim().isNotEmpty, isTrue);
      expect(e.acertijo.enunciado.trim().isNotEmpty, isTrue);
    }
  });

  test('E3 acertijo dice producto 8 (no 12)', () {
    final e3 = banco.firstWhere((e) => e.numeroSemana == 3);
    expect(e3.acertijo.enunciado, contains('producto de sus rangos es **8**'),
        reason: 'La corrección del bug matemático debe estar reflejada en el banco');
    expect(e3.acertijo.enunciado, isNot(contains('producto de sus rangos es **12**')));
    expect(e3.acertijo.solucionCanonica, contains('1, 2 y 4'));
  });

  test('E1 portada dice "próximas seis semanas" (no siete)', () {
    final e1 = banco.firstWhere((e) => e.numeroSemana == 1);
    final cuerpoPortada = e1.portada.first.cuerpo;
    expect(cuerpoPortada, contains('próximas seis semanas'));
    expect(cuerpoPortada, isNot(contains('próximas siete semanas')));
  });

  test('E7 portada del equinoccio dice "Diecisiete personas" y "dos horas"', () {
    final e7 = banco.firstWhere((e) => e.numeroSemana == 7);
    final equinoccio = e7.portada.firstWhere((n) => n.titulo == 'El equinoccio');
    expect(equinoccio.cuerpo, contains('Diecisiete personas'));
    expect(equinoccio.cuerpo,
        isNot(contains('Veintiséis personas no pudieron acceder')));
    expect(equinoccio.cuerpo, contains('dos horas'));
    expect(equinoccio.cuerpo,
        isNot(contains('Tres turnos de observación de **una hora y media**')));
  });

  test('E9 disculpa del intercambio es escueta y no incluye "espera, repensemos"',
      () {
    final e9 = banco.firstWhere((e) => e.numeroSemana == 9);
    final disculpa = e9.portada.first;
    expect(disculpa.cuerpo, contains('mal planteado'));
    expect(disculpa.cuerpo, isNot(contains('espera, repensemos')),
        reason: 'el reconocimiento confuso debe estar limpio');
  });

  test('E10 crónica de Tora Berlin menciona la excepción a los doce años', () {
    final e10 = banco.firstWhere((e) => e.numeroSemana == 10);
    expect(e10.cronica.cuerpo, contains('antes de la edad habitual'));
    expect(e10.cronica.cuerpo, contains('los doce años'));
  });

  test('E20 portada cierra el hilo de las iniciales K. R. T.', () {
    final e20 = banco.firstWhere((e) => e.numeroSemana == 20);
    final iniciales = e20.portada.firstWhere(
      (n) => n.titulo == 'Las tres iniciales',
    );
    expect(iniciales.cuerpo, contains('Iren Tov'));
    expect(iniciales.cuerpo, contains('Kelo, Rasi y Tene'));
    expect(iniciales.cuerpo, contains('No deduzcan'),
        reason: 'la moraleja de no extrapolar a otras pintadas debe estar');
  });

  test('E20 crónica de Maren cierra el hilo del faro lejano cada 31 años', () {
    final e20 = banco.firstWhere((e) => e.numeroSemana == 20);
    expect(e20.cronica.firma, 'por Maren Olbéa');
    expect(e20.cronica.cuerpo, contains('cada 31 años'));
    expect(e20.cronica.cuerpo, contains('186 años'));
  });

  test('niveles de dificultad escalan suavemente', () {
    // No imponemos un orden estricto, pero el primero debe ser
    // aprendizI y el último iniciadoII (calibración del doc).
    expect(banco.first.acertijo.dificultad, NivelDificultadAcertijo.aprendizI);
    expect(banco.last.acertijo.dificultad, NivelDificultadAcertijo.iniciadoII);
  });

  test('parser síncrono lanza FormatException si falta "ediciones"', () {
    expect(
      () => parseBancoDesdeJson('{"version":"0.1"}'),
      throwsA(isA<FormatException>()),
    );
  });

  test('parser síncrono lanza FormatException si dificultad es desconocida', () {
    const malo = '''
{"version":"0.1","ediciones":[{
  "numeroSemana":1,"anioOrden":412,"numeroEdicion":1,
  "portada":[{"titulo":"x","cuerpo":"y"}],
  "cronica":{"titulo":"a","firma":"b","introduccion":"c","cuerpo":"d"},
  "cartas":[{"pregunta":"p","firmante":"f","respuesta":"r"}],
  "acertijo":{"titulo":"t","enunciado":"e","solucionCanonica":"s","dificultad":"superMaestro"}
}]}
''';
    expect(() => parseBancoDesdeJson(malo), throwsA(isA<FormatException>()));
  });
}
