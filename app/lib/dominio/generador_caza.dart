import 'dart:math' as math;

import 'fragmento_en_tejado.dart';

/// Genera Fragmentos que aparecen en el tejado a lo largo de una
/// sesión de caza. La dificultad sube **continuamente** con el número
/// de esquirlas acumuladas: denominadores más altos, aparición de
/// primos, compuestos más exigentes y tiempos de vida más cortos.
///
/// Biblia §6.2: un niño de 12 años que domina rápido no debe quedarse
/// con contenido de su edad; aquí no hay tope.
class GeneradorCaza {
  final math.Random _azar;

  GeneradorCaza({int? semilla}) : _azar = math.Random(semilla);

  FragmentoEnTejado siguiente({
    required int esquirlasAcumuladas,
    required DateTime ahora,
  }) {
    final dificultad = _nivelDificultadSegunEsquirlas(esquirlasAcumuladas);
    final denominador = _elegirDenominador(dificultad);
    final numerador = _elegirNumerador(denominador, dificultad);

    return FragmentoEnTejado(
      identificador: 'frag_${ahora.microsecondsSinceEpoch}_'
          '${_azar.nextInt(9999)}',
      numerador: numerador,
      denominador: denominador,
      xNormalizado: 0.18 + _azar.nextDouble() * 0.64,
      yNormalizado: 0.2 + _azar.nextDouble() * 0.48,
      instanteAparicion: ahora,
      tiempoDeVida: _tiempoDeVida(dificultad),
    );
  }

  /// Nivel de dificultad creciente sin tope. Cada "tier" mete
  /// denominadores más grandes, primos más frecuentes y compuestos
  /// más cerca de 1 (7/8, 11/12) para el niño avanzado.
  int _nivelDificultadSegunEsquirlas(int esquirlas) {
    if (esquirlas < 4) return 0;
    if (esquirlas < 10) return 1;
    if (esquirlas < 20) return 2;
    if (esquirlas < 35) return 3;
    if (esquirlas < 55) return 4;
    if (esquirlas < 80) return 5;
    if (esquirlas < 120) return 6;
    return 7;
  }

  int _elegirDenominador(int dificultad) {
    final candidatos = <int>[];
    switch (dificultad) {
      case 0:
        candidatos.addAll([2, 2, 3]);
        break;
      case 1:
        candidatos.addAll([2, 3, 3, 4, 5]);
        break;
      case 2:
        candidatos.addAll([2, 3, 4, 4, 5, 5, 6, 7]);
        break;
      case 3:
        candidatos.addAll([3, 4, 5, 5, 6, 6, 7, 8, 9]);
        break;
      case 4:
        candidatos.addAll([4, 5, 6, 7, 7, 8, 9, 10, 11]);
        break;
      case 5:
        candidatos.addAll([5, 6, 7, 8, 9, 10, 11, 11, 12]);
        break;
      case 6:
        candidatos.addAll([7, 8, 9, 10, 11, 12, 12]);
        break;
      case 7:
      default:
        // Territorio del Fraccionista avanzado: solo denominadores
        // grandes, muchos primos.
        candidatos.addAll([7, 9, 11, 11, 12, 13]);
    }
    return candidatos[_azar.nextInt(candidatos.length)];
  }

  int _elegirNumerador(int denominador, int dificultad) {
    if (denominador <= 2) return 1;
    if (dificultad < 2) return 1;

    // Probabilidad creciente de compuesto con el nivel.
    final probCompuesto = switch (dificultad) {
      2 => 0.33,
      3 => 0.42,
      4 => 0.5,
      5 => 0.58,
      6 => 0.65,
      _ => 0.7,
    };
    if (_azar.nextDouble() >= probCompuesto) return 1;

    // Compuesto: a niveles altos el numerador tiende al máximo
    // (7/8, 11/12) para que el compuesto se sienta casi-entero.
    final maximoNumerador = denominador - 1;
    if (dificultad >= 5 && _azar.nextInt(3) == 0) {
      return maximoNumerador; // caso extremo 7/8, 11/12
    }
    return 2 + _azar.nextInt(maximoNumerador - 1);
  }

  /// Tiempo de vida del Fragmento antes de empezar a escapar.
  /// A mayor dificultad, menos margen — el Fraccionista avanzado
  /// tiene que ser más rápido.
  Duration _tiempoDeVida(int dificultad) {
    const msBase = 16000;
    final msVariacion = 7000 - dificultad * 500;
    const msMinimo = 7000;
    final msDisponibles = math.max(msMinimo, msBase - dificultad * 1200);
    final ms = msDisponibles + _azar.nextInt(math.max(1, msVariacion));
    return Duration(milliseconds: ms);
  }
}
