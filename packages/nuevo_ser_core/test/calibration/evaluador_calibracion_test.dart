import 'package:flutter_test/flutter_test.dart';

import 'package:nuevo_ser_core/src/calibration/evaluador_calibracion.dart';
import 'package:nuevo_ser_core/src/calibration/nivel_confianza.dart';

void main() {
  group('CalibracionAfirmacion', () {
    test('acertar el nivel da score 1.0', () {
      const calibracion = CalibracionAfirmacion(
        nivelCorrecto: NivelConfianza.solido,
        nivelDeclarado: NivelConfianza.solido,
      );
      expect(calibracion.scoreNormalizado, 1.0);
      expect(calibracion.acierta, isTrue);
    });

    test('declarar el nivel opuesto da score 0.0', () {
      const calibracion = CalibracionAfirmacion(
        nivelCorrecto: NivelConfianza.disputado,
        nivelDeclarado: NivelConfianza.solido,
      );
      expect(calibracion.scoreNormalizado, 0.0);
      expect(calibracion.acierta, isFalse);
    });

    test('declarar nivel adyacente con predicción dura da también 0.0', () {
      // Documenta la conducta actual de la formulación hard. Cuando
      // se admita predicción suave (mapas de probabilidad), este
      // test puede relajarse.
      const calibracion = CalibracionAfirmacion(
        nivelCorrecto: NivelConfianza.solido,
        nivelDeclarado: NivelConfianza.probable,
      );
      expect(calibracion.scoreNormalizado, 0.0);
    });
  });

  group('ResultadoCalibracion', () {
    test('lista vacía → scoreMedio 0.0', () {
      const resultado = ResultadoCalibracion(porAfirmacion: []);
      expect(resultado.scoreMedio, 0.0);
      expect(resultado.aciertos, 0);
      expect(resultado.totalAfirmaciones, 0);
    });

    test('aciertos parciales se promedian', () {
      const resultado = ResultadoCalibracion(porAfirmacion: [
        CalibracionAfirmacion(
          nivelCorrecto: NivelConfianza.solido,
          nivelDeclarado: NivelConfianza.solido,
        ),
        CalibracionAfirmacion(
          nivelCorrecto: NivelConfianza.disputado,
          nivelDeclarado: NivelConfianza.solido,
        ),
      ]);
      expect(resultado.aciertos, 1);
      expect(resultado.totalAfirmaciones, 2);
      expect(resultado.scoreMedio, 0.5);
    });
  });

  group('EvaluadorCalibracion', () {
    const evaluador = EvaluadorCalibracion();

    test('devuelve resultado con la lista pasada sin reordenar', () {
      const calibraciones = [
        CalibracionAfirmacion(
          nivelCorrecto: NivelConfianza.solido,
          nivelDeclarado: NivelConfianza.solido,
        ),
        CalibracionAfirmacion(
          nivelCorrecto: NivelConfianza.probable,
          nivelDeclarado: NivelConfianza.probable,
        ),
        CalibracionAfirmacion(
          nivelCorrecto: NivelConfianza.disputado,
          nivelDeclarado: NivelConfianza.disputado,
        ),
      ];
      final resultado = evaluador.evaluar(calibraciones);
      expect(resultado.totalAfirmaciones, 3);
      expect(resultado.aciertos, 3);
      expect(resultado.scoreMedio, 1.0);
    });

    test('lista vacía → resultado vacío', () {
      final resultado = evaluador.evaluar(const []);
      expect(resultado.totalAfirmaciones, 0);
      expect(resultado.scoreMedio, 0.0);
    });
  });
}
