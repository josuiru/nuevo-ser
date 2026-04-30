import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:nuevo_ser_core/src/calibration/evaluador_calibracion.dart';
import 'package:nuevo_ser_core/src/calibration/nivel_confianza.dart';

/// La fixture vive en `test/fixtures/calibracion_brier.json` y la
/// consume tanto este test como su espejo PHP — `NS_Calibracion`
/// del plugin debe producir exactamente los mismos `score_medio`
/// que el `EvaluadorCalibracion` Dart. Si esta paridad se rompe, los
/// agregados semanales del backend dejarán de cuadrar con el
/// feedback que el cliente muestra al niño.
void main() {
  test('paridad Brier multiclass — fixture compartida con PHP', () {
    final fichero = File('test/fixtures/calibracion_brier.json');
    final raw = fichero.readAsStringSync();
    final fixture = jsonDecode(raw) as Map<String, dynamic>;
    final casos = fixture['casos'] as List<dynamic>;
    const evaluador = EvaluadorCalibracion();

    for (final caso in casos) {
      final mapa = caso as Map<String, dynamic>;
      final nombre = mapa['nombre'] as String;
      final entradas = (mapa['entradas'] as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList();
      final esperado = (mapa['score_medio_esperado'] as num).toDouble();

      final calibraciones = entradas
          .map((entrada) => CalibracionAfirmacion(
                nivelCorrecto: _nivel(entrada['correcto'] as String),
                nivelDeclarado: _nivel(entrada['declarado'] as String),
              ))
          .toList();
      final resultado = evaluador.evaluar(calibraciones);

      expect(
        resultado.scoreMedio,
        closeTo(esperado, 1e-12),
        reason: 'caso "$nombre": esperado $esperado, calculado '
            '${resultado.scoreMedio}',
      );
    }
  });
}

NivelConfianza _nivel(String nombre) {
  for (final valor in NivelConfianza.values) {
    if (valor.name == nombre) return valor;
  }
  throw ArgumentError('Nivel desconocido en fixture: $nombre');
}
