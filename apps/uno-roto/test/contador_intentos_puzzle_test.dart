import 'package:flutter_test/flutter_test.dart';
import 'package:uno_roto/dominio/contador_intentos_puzzle.dart';

void main() {
  setUp(() {
    reiniciarIntentosPuzzle();
    reiniciarFallosParaTutor();
  });

  group('esquirlasSegunIntentos — 4 opciones', () {
    test('acierto a la primera devuelve base completa', () {
      expect(esquirlasSegunIntentos(base: 4, totalOpciones: 4), 4);
      expect(esquirlasSegunIntentos(base: 3, totalOpciones: 4), 3);
      expect(esquirlasSegunIntentos(base: 2, totalOpciones: 4), 2);
    });

    test('un fallo resta una esquirla, mínimo 1', () {
      contarFalloPuzzle();
      expect(esquirlasSegunIntentos(base: 4, totalOpciones: 4), 3);
      expect(esquirlasSegunIntentos(base: 2, totalOpciones: 4), 1);
    });

    test('último intento posible devuelve 0 (regla del descarte)', () {
      contarFalloPuzzle();
      contarFalloPuzzle();
      contarFalloPuzzle();
      expect(esquirlasSegunIntentos(base: 4, totalOpciones: 4), 0);
      expect(esquirlasSegunIntentos(base: 2, totalOpciones: 4), 0);
    });
  });

  group('esquirlasSegunIntentos — 3 opciones', () {
    test('regla del descarte se aplica al tercer intento', () {
      contarFalloPuzzle();
      contarFalloPuzzle();
      expect(esquirlasSegunIntentos(base: 3, totalOpciones: 3), 0);
    });
  });

  group('esquirlasSegunIntentos — binarios (2 opciones)', () {
    test('acierto a la primera devuelve 1 esquirla', () {
      expect(esquirlasSegunIntentos(base: 1, totalOpciones: 2), 1);
    });

    test('acierto a la segunda también devuelve 1 — sin regla de descarte', () {
      contarFalloPuzzle();
      expect(esquirlasSegunIntentos(base: 1, totalOpciones: 2), 1);
    });

    test('tras varios toques nerviosos sigue dando 1', () {
      contarFalloPuzzle();
      contarFalloPuzzle();
      contarFalloPuzzle();
      expect(esquirlasSegunIntentos(base: 1, totalOpciones: 2), 1);
    });
  });

  group('reiniciarIntentosPuzzle', () {
    test('vuelve a contar como primera vez tras reset', () {
      contarFalloPuzzle();
      contarFalloPuzzle();
      reiniciarIntentosPuzzle();
      expect(esquirlasSegunIntentos(base: 4, totalOpciones: 4), 4);
    });
  });

  group('contador de fallos para el tutor', () {
    test('cada contarFalloPuzzle incrementa también el contador del tutor',
        () {
      expect(fallosParaTutorPuzzleActual, 0);
      contarFalloPuzzle();
      contarFalloPuzzle();
      contarFalloPuzzle();
      expect(fallosParaTutorPuzzleActual, 3);
    });

    test(
        'reiniciarIntentosPuzzle no toca el contador del tutor — '
        'el dialog tras-5-fallos lo llama para evitar la regla del descarte '
        'pero la oferta de Eco se basa en lo que de verdad le costó al niño',
        () {
      for (var i = 0; i < 5; i++) {
        contarFalloPuzzle();
      }
      expect(intentosPuzzleActual, 6); // 1 inicial + 5 fallos
      expect(fallosParaTutorPuzzleActual, 5);

      reiniciarIntentosPuzzle();
      expect(intentosPuzzleActual, 1);
      expect(fallosParaTutorPuzzleActual, 5,
          reason: 'los 5 fallos previos siguen contando para el tutor');
    });

    test('reiniciarFallosParaTutor sí lo borra (lo usa el cazadero al '
        'iniciar cada Fragmento)', () {
      contarFalloPuzzle();
      contarFalloPuzzle();
      expect(fallosParaTutorPuzzleActual, 2);
      reiniciarFallosParaTutor();
      expect(fallosParaTutorPuzzleActual, 0);
    });
  });
}
