import 'package:flutter_test/flutter_test.dart';

import 'package:las_versiones/dominio/brecha.dart';
import 'package:las_versiones/dominio/calibracion.dart';

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

    test('declarar nivel adyacente da también 0 con predicción dura', () {
      // Con la formulación hard-prediction sólo hay 0 o 1; el matiz
      // de "más cerca / más lejos" llegará cuando se admita
      // probabilidades. Mientras tanto, el test documenta la
      // conducta actual.
      const calibracion = CalibracionAfirmacion(
        nivelCorrecto: NivelConfianza.solido,
        nivelDeclarado: NivelConfianza.probable,
      );
      expect(calibracion.scoreNormalizado, 0.0);
    });
  });

  group('ResultadoCalibracionBrecha', () {
    test('lista vacía → scoreMedio 0.0', () {
      const resultado = ResultadoCalibracionBrecha(porAfirmacion: []);
      expect(resultado.scoreMedio, 0.0);
      expect(resultado.aciertos, 0);
      expect(resultado.totalAfirmaciones, 0);
    });

    test('aciertos parciales se promedian', () {
      const resultado = ResultadoCalibracionBrecha(porAfirmacion: [
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
    const afirmacionA = AfirmacionCanonica(
      id: 'A',
      texto: 'a',
      calibracionCorrecta: NivelConfianza.solido,
    );
    const afirmacionB = AfirmacionCanonica(
      id: 'B',
      texto: 'b',
      calibracionCorrecta: NivelConfianza.disputado,
    );

    test('todas las afirmaciones declaradas con su nivel correcto', () {
      final resultado = evaluador.evaluar(
        afirmacionesDeclaradas: const [afirmacionA, afirmacionB],
        nivelDeclaradoPorId: const {
          'A': NivelConfianza.solido,
          'B': NivelConfianza.disputado,
        },
      );
      expect(resultado.totalAfirmaciones, 2);
      expect(resultado.aciertos, 2);
      expect(resultado.scoreMedio, 1.0);
    });

    test('afirmación declarada sin nivel asignado se ignora', () {
      final resultado = evaluador.evaluar(
        afirmacionesDeclaradas: const [afirmacionA, afirmacionB],
        nivelDeclaradoPorId: const {
          'A': NivelConfianza.solido,
          // 'B' no tiene nivel
        },
      );
      expect(resultado.totalAfirmaciones, 1,
          reason: 'sólo se cuentan las afirmaciones con nivel asignado');
      expect(resultado.aciertos, 1);
    });

    test('exceso de niveles en el mapa para afirmaciones no declaradas '
        'no afecta', () {
      final resultado = evaluador.evaluar(
        afirmacionesDeclaradas: const [afirmacionA],
        nivelDeclaradoPorId: const {
          'A': NivelConfianza.solido,
          'fantasma': NivelConfianza.probable,
        },
      );
      expect(resultado.totalAfirmaciones, 1);
      expect(resultado.aciertos, 1);
    });
  });
}
