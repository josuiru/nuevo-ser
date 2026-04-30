import 'package:flutter_test/flutter_test.dart';

import 'package:las_versiones/dominio/brecha.dart';
import 'package:las_versiones/dominio/evaluacion_fuente.dart';

const _canonicasPrimariaSinSesgo = PropiedadesFuente(
  tipo: TipoFuente.primaria,
  autor: 'autor',
  fecha: 'fecha',
  publico: 'publico',
  intereses: 'intereses',
  omisiones: 'omisiones',
  corroboraOContradice: 'corrobora',
);

const _canonicasSecundariaDifusionista = PropiedadesFuente(
  tipo: TipoFuente.secundaria,
  autor: 'autor',
  fecha: 'fecha',
  publico: 'publico',
  intereses: 'intereses',
  omisiones: 'omisiones',
  corroboraOContradice: 'corrobora',
  sesgo: SesgoFuente.difusionista,
);

void main() {
  group('RespuestaEvaluacionFuente', () {
    test('estaCompleta es false sin tipo o sin sesgo', () {
      expect(const RespuestaEvaluacionFuente().estaCompleta, isFalse);
      expect(
        const RespuestaEvaluacionFuente(tipoElegido: TipoFuente.primaria)
            .estaCompleta,
        isFalse,
      );
      expect(
        const RespuestaEvaluacionFuente(sesgoElegido: SesgoFuente.ninguno)
            .estaCompleta,
        isFalse,
      );
    });

    test('estaCompleta es true con ambos campos', () {
      const respuesta = RespuestaEvaluacionFuente(
        tipoElegido: TipoFuente.primaria,
        sesgoElegido: SesgoFuente.ninguno,
      );
      expect(respuesta.estaCompleta, isTrue);
    });

    test('copiarCon preserva el campo no sobreescrito', () {
      const original = RespuestaEvaluacionFuente(
        tipoElegido: TipoFuente.primaria,
      );
      final modificada =
          original.copiarCon(sesgoElegido: SesgoFuente.difusionista);
      expect(modificada.tipoElegido, TipoFuente.primaria);
      expect(modificada.sesgoElegido, SesgoFuente.difusionista);
    });
  });

  group('EvaluadorFuente', () {
    const evaluador = EvaluadorFuente();

    test('dos aciertos cuando coinciden tipo y sesgo', () {
      final resultado = evaluador.comparar(
        respuesta: const RespuestaEvaluacionFuente(
          tipoElegido: TipoFuente.primaria,
          sesgoElegido: SesgoFuente.ninguno,
        ),
        canonicas: _canonicasPrimariaSinSesgo,
      );
      expect(resultado.aciertoTipo, isTrue);
      expect(resultado.aciertoSesgo, isTrue);
      expect(resultado.aciertos, 2);
      expect(resultado.total, 2);
    });

    test('falla en tipo, acierta en sesgo', () {
      final resultado = evaluador.comparar(
        respuesta: const RespuestaEvaluacionFuente(
          tipoElegido: TipoFuente.primaria,
          sesgoElegido: SesgoFuente.difusionista,
        ),
        canonicas: _canonicasSecundariaDifusionista,
      );
      expect(resultado.aciertoTipo, isFalse);
      expect(resultado.aciertoSesgo, isTrue);
      expect(resultado.aciertos, 1);
    });

    test('cero aciertos', () {
      final resultado = evaluador.comparar(
        respuesta: const RespuestaEvaluacionFuente(
          tipoElegido: TipoFuente.primaria,
          sesgoElegido: SesgoFuente.oficialista,
        ),
        canonicas: _canonicasSecundariaDifusionista,
      );
      expect(resultado.aciertos, 0);
    });
  });
}
