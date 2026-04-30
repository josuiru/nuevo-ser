import 'package:flutter_test/flutter_test.dart';

import 'package:las_versiones/dominio/evaluador_preguntas.dart';

void main() {
  group('EvaluadorPreguntas', () {
    const evaluador = EvaluadorPreguntas();

    test('texto demasiado corto → no válido', () {
      final resultado = evaluador.evaluar('¿qué?');
      expect(resultado.esValida, isFalse);
      expect(resultado.tipo, TipoPregunta.indeterminada);
      expect(resultado.mensajePedagogico, contains('corta'));
    });

    test('texto sin signo interrogativo ni partícula → no válido', () {
      final resultado = evaluador.evaluar('Aquí pasaron muchas cosas, según parece.');
      expect(resultado.esValida, isFalse);
      expect(resultado.mensajePedagogico, contains('afirmación'));
    });

    test('pregunta factual con "qué" → válida y factual', () {
      final resultado = evaluador.evaluar('¿Qué pasó en este lugar hace mucho tiempo?');
      expect(resultado.esValida, isTrue);
      expect(resultado.tipo, TipoPregunta.factual);
    });

    test('pregunta con "cuándo" → factual', () {
      final resultado = evaluador.evaluar('¿Cuándo se construyó este monumento?');
      expect(resultado.esValida, isTrue);
      expect(resultado.tipo, TipoPregunta.factual);
    });

    test('pregunta causal con "por qué" → causal, no factual', () {
      final resultado = evaluador.evaluar(
          '¿Por qué decidieron construirlo aquí y no en el valle?');
      expect(resultado.esValida, isTrue);
      expect(resultado.tipo, TipoPregunta.causal);
    });

    test('pregunta de perspectiva con "qué intereses" → perspectiva', () {
      final resultado = evaluador.evaluar(
          '¿Qué intereses tenía quien lo construyó y a quién buscaba impresionar?');
      expect(resultado.esValida, isTrue);
      expect(resultado.tipo, TipoPregunta.perspectiva);
    });

    test('pregunta metodológica con "qué evidencia" → metodológica', () {
      final resultado = evaluador.evaluar(
          '¿Qué evidencia tenemos hoy para datar este conjunto?');
      expect(resultado.esValida, isTrue);
      expect(resultado.tipo, TipoPregunta.metodologica);
    });

    test('detección es robusta a tildes ausentes', () {
      final con = evaluador.evaluar('¿Por qué construyeron esto aquí?');
      final sin = evaluador.evaluar('¿Por que construyeron esto aqui?');
      expect(con.tipo, TipoPregunta.causal);
      expect(sin.tipo, TipoPregunta.causal);
    });

    test('pregunta acaba en ? sin partícula conocida → indeterminada pero válida',
        () {
      final resultado = evaluador.evaluar('¿Esto es realmente tan antiguo?');
      expect(resultado.esValida, isTrue);
      expect(resultado.tipo, TipoPregunta.indeterminada);
    });

    test('texto demasiado largo → no válido', () {
      final textoLargo = '¿${'palabra ' * 50}?';
      final resultado = evaluador.evaluar(textoLargo);
      expect(resultado.esValida, isFalse);
      expect(resultado.mensajePedagogico, contains('larga'));
    });

    test('espacios extremos se recortan antes de evaluar', () {
      final resultado =
          evaluador.evaluar('   ¿Cómo lo sabemos con certeza?   ');
      expect(resultado.esValida, isTrue);
      expect(resultado.textoNormalizado, '¿Cómo lo sabemos con certeza?');
    });
  });

  group('PoliticaCierreFormulacion', () {
    const politica = PoliticaCierreFormulacion();
    const evaluador = EvaluadorPreguntas();

    test('cero preguntas válidas → bloquea con mensaje claro', () {
      final razon = politica.razonParaNoAvanzar(const []);
      expect(razon, isNotNull);
      expect(razon, contains('3 preguntas'));
    });

    test('dos preguntas válidas (factual + causal) → sigue bloqueado', () {
      final evaluaciones = [
        evaluador.evaluar('¿Qué pasó en este lugar?'),
        evaluador.evaluar('¿Por qué se construyó aquí?'),
      ];
      expect(politica.razonParaNoAvanzar(evaluaciones), isNotNull);
    });

    test('tres preguntas válidas pero todas factuales → exige diversidad', () {
      final evaluaciones = [
        evaluador.evaluar('¿Qué pasó en este lugar hace tiempo?'),
        evaluador.evaluar('¿Cuándo se construyó esto?'),
        evaluador.evaluar('¿Quién lo levantó realmente?'),
      ];
      final razon = politica.razonParaNoAvanzar(evaluaciones);
      expect(razon, isNotNull);
      expect(razon, contains('mismo tipo'));
    });

    test('tres válidas con dos categorías distintas → desbloquea', () {
      final evaluaciones = [
        evaluador.evaluar('¿Qué pasó en este lugar hace tiempo?'),
        evaluador.evaluar('¿Por qué se construyó aquí y no en el valle?'),
        evaluador.evaluar('¿Cuándo se construyó esto?'),
      ];
      expect(politica.razonParaNoAvanzar(evaluaciones), isNull);
    });

    test('preguntas no válidas no cuentan para el mínimo', () {
      final evaluaciones = [
        evaluador.evaluar('¿Qué pasó en este lugar hace tiempo?'),
        evaluador.evaluar('Algo aquí no cuadra.'), // afirmación
        evaluador.evaluar('¿Por qué se construyó aquí?'),
      ];
      // Sólo 2 válidas: bloquea aunque haya 3 entradas.
      expect(politica.razonParaNoAvanzar(evaluaciones), isNotNull);
    });
  });
}
