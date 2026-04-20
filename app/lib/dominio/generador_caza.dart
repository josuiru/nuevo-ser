import 'dart:math' as math;

import 'distrito.dart';
import 'fragmento_en_tejado.dart';
import 'problema_decimal.dart' show decimalesConocidos;
import 'problema_porcentaje.dart' show porcentajesConocidos;

/// Genera Fragmentos que aparecen en el tejado a lo largo de una
/// sesión de caza. La dificultad sube **continuamente** con el número
/// de esquirlas acumuladas: denominadores más altos, aparición de
/// primos, compuestos más exigentes y tiempos de vida más cortos.
///
/// Biblia §6.2: un niño de 12 años que domina rápido no debe quedarse
/// con contenido de su edad; aquí no hay tope.
class GeneradorCaza {
  final math.Random _azar;

  /// Si viene un distrito, el generador usa su mezcla de puzzles como
  /// sesgo fuerte. Si es null, cae al reparto general por dificultad.
  final Distrito? distrito;

  GeneradorCaza({int? semilla, this.distrito}) : _azar = math.Random(semilla);

  FragmentoEnTejado siguiente({
    required int esquirlasAcumuladas,
    required DateTime ahora,
  }) {
    final dificultad = _nivelDificultadSegunEsquirlas(esquirlasAcumuladas);
    final tipo = distrito != null
        ? _elegirTipoSegunDistrito(distrito!, dificultad)
        : _elegirTipo(dificultad);

    if (tipo == TipoFragmentoEnTejado.decimal) {
      final decimalElegido =
          decimalesConocidos[_azar.nextInt(decimalesConocidos.length)];
      return FragmentoEnTejado(
        identificador: 'frag_${ahora.microsecondsSinceEpoch}_'
            '${_azar.nextInt(9999)}',
        numerador: decimalElegido.fraccionEquivalente.numerador,
        denominador: decimalElegido.fraccionEquivalente.denominador,
        tipo: tipo,
        etiquetaDecimal: decimalElegido.etiqueta,
        xNormalizado: 0.18 + _azar.nextDouble() * 0.64,
        yNormalizado: 0.2 + _azar.nextDouble() * 0.48,
        instanteAparicion: ahora,
        tiempoDeVida: _tiempoDeVida(dificultad),
      );
    }

    if (tipo == TipoFragmentoEnTejado.porcentaje) {
      final porcentajeElegido =
          porcentajesConocidos[_azar.nextInt(porcentajesConocidos.length)];
      return FragmentoEnTejado(
        identificador: 'frag_${ahora.microsecondsSinceEpoch}_'
            '${_azar.nextInt(9999)}',
        numerador: porcentajeElegido.fraccionEquivalente.numerador,
        denominador: porcentajeElegido.fraccionEquivalente.denominador,
        tipo: tipo,
        etiquetaDecimal: porcentajeElegido.etiqueta,
        xNormalizado: 0.18 + _azar.nextDouble() * 0.64,
        yNormalizado: 0.2 + _azar.nextDouble() * 0.48,
        instanteAparicion: ahora,
        tiempoDeVida: _tiempoDeVida(dificultad),
      );
    }

    if (tipo == TipoFragmentoEnTejado.impropio) {
      final denominadorImp = _elegirDenominadorImpropio(dificultad);
      final numeradorImp = _elegirNumeradorImpropio(denominadorImp, dificultad);
      return FragmentoEnTejado(
        identificador: 'frag_${ahora.microsecondsSinceEpoch}_'
            '${_azar.nextInt(9999)}',
        numerador: numeradorImp,
        denominador: denominadorImp,
        tipo: tipo,
        xNormalizado: 0.18 + _azar.nextDouble() * 0.64,
        yNormalizado: 0.2 + _azar.nextDouble() * 0.48,
        instanteAparicion: ahora,
        tiempoDeVida: _tiempoDeVida(dificultad),
      );
    }

    if (tipo == TipoFragmentoEnTejado.proporcional) {
      // Una razón "a:b" con a,b pequeños; el numerador/denominador del
      // Fragmento almacenan esos valores para que la pantalla use la
      // misma razón mostrada en el tejado.
      final a = 2 + _azar.nextInt(6);
      final b = 3 + _azar.nextInt(7);
      return FragmentoEnTejado(
        identificador: 'frag_${ahora.microsecondsSinceEpoch}_'
            '${_azar.nextInt(9999)}',
        numerador: a,
        denominador: b,
        tipo: tipo,
        etiquetaDecimal: '$a:$b',
        xNormalizado: 0.18 + _azar.nextDouble() * 0.64,
        yNormalizado: 0.2 + _azar.nextDouble() * 0.48,
        instanteAparicion: ahora,
        tiempoDeVida: _tiempoDeVida(dificultad),
      );
    }

    if (tipo == TipoFragmentoEnTejado.dual) {
      final (numA, denA, numB, denB) = _elegirSumandosDual(dificultad);
      return FragmentoEnTejado(
        identificador: 'frag_${ahora.microsecondsSinceEpoch}_'
            '${_azar.nextInt(9999)}',
        numerador: numA,
        denominador: denA,
        numeradorB: numB,
        denominadorB: denB,
        tipo: tipo,
        etiquetaDecimal: '$numA/$denA+$numB/$denB',
        xNormalizado: 0.18 + _azar.nextDouble() * 0.64,
        yNormalizado: 0.2 + _azar.nextDouble() * 0.48,
        instanteAparicion: ahora,
        tiempoDeVida: _tiempoDeVida(dificultad),
      );
    }

    final denominador = tipo == TipoFragmentoEnTejado.espejo
        ? _elegirDenominadorEspejo(dificultad)
        : _elegirDenominador(dificultad);
    final numerador = tipo == TipoFragmentoEnTejado.espejo
        ? _elegirNumeradorEspejo(denominador, dificultad)
        : _elegirNumerador(denominador, dificultad);

    return FragmentoEnTejado(
      identificador: 'frag_${ahora.microsecondsSinceEpoch}_'
          '${_azar.nextInt(9999)}',
      numerador: numerador,
      denominador: denominador,
      tipo: tipo,
      xNormalizado: 0.18 + _azar.nextDouble() * 0.64,
      yNormalizado: 0.2 + _azar.nextDouble() * 0.48,
      instanteAparicion: ahora,
      tiempoDeVida: _tiempoDeVida(dificultad),
    );
  }

  /// Decide qué tipo de Fragmento aparece según el nivel.
  ///
  /// - Dificultad < 2: solo unitarios (el niño aún se hace al gesto).
  /// - Dificultad 2-3: aparecen Espejos.
  /// - Dificultad 3+: también aparecen Decimales.
  TipoFragmentoEnTejado _elegirTipo(int dificultad) {
    if (dificultad < 2) return TipoFragmentoEnTejado.unitario;

    final probEspejo = switch (dificultad) {
      2 => 0.18,
      3 => 0.2,
      4 => 0.22,
      5 => 0.22,
      6 => 0.24,
      _ => 0.26,
    };
    final probDecimal = dificultad < 3
        ? 0.0
        : switch (dificultad) {
            3 => 0.12,
            4 => 0.14,
            5 => 0.15,
            6 => 0.17,
            _ => 0.18,
          };
    final probPorcentaje = dificultad < 3
        ? 0.0
        : switch (dificultad) {
            3 => 0.1,
            4 => 0.12,
            5 => 0.13,
            6 => 0.14,
            _ => 0.15,
          };
    final probImpropio = dificultad < 4
        ? 0.0
        : switch (dificultad) {
            4 => 0.1,
            5 => 0.11,
            6 => 0.12,
            _ => 0.13,
          };
    final probProporcional = dificultad < 5
        ? 0.0
        : switch (dificultad) {
            5 => 0.07,
            6 => 0.09,
            _ => 0.1,
          };
    final probDual = dificultad < 5
        ? 0.0
        : switch (dificultad) {
            5 => 0.08,
            6 => 0.1,
            _ => 0.12,
          };

    final tirada = _azar.nextDouble();
    var umbral = probEspejo;
    if (tirada < umbral) return TipoFragmentoEnTejado.espejo;
    umbral += probDecimal;
    if (tirada < umbral) return TipoFragmentoEnTejado.decimal;
    umbral += probPorcentaje;
    if (tirada < umbral) return TipoFragmentoEnTejado.porcentaje;
    umbral += probImpropio;
    if (tirada < umbral) return TipoFragmentoEnTejado.impropio;
    umbral += probProporcional;
    if (tirada < umbral) return TipoFragmentoEnTejado.proporcional;
    umbral += probDual;
    if (tirada < umbral) return TipoFragmentoEnTejado.dual;
    return TipoFragmentoEnTejado.unitario;
  }

  /// Elige un tipo respetando la mezcla del [Distrito]. Si el distrito
  /// pide un tipo que aún no se ha desbloqueado por dificultad (p. ej.
  /// el Mercado pide porcentajes pero estamos en dificultad 1), caemos
  /// al reparto general para que el niño no se quede sin Fragmentos en
  /// sus primeras visitas.
  TipoFragmentoEnTejado _elegirTipoSegunDistrito(
    Distrito distritoElegido,
    int dificultad,
  ) {
    final pesoTotal = distritoElegido.mezclaPuzzles.values
        .fold<double>(0, (acum, peso) => acum + peso);
    if (pesoTotal <= 0) return _elegirTipo(dificultad);

    final tirada = _azar.nextDouble() * pesoTotal;
    var acumulado = 0.0;
    for (final entrada in distritoElegido.mezclaPuzzles.entries) {
      acumulado += entrada.value;
      if (tirada < acumulado) {
        // Comprobamos que el tipo esté disponible por dificultad; si no,
        // nos quedamos con unitario en su lugar.
        if (_tipoDisponibleEnDificultad(entrada.key, dificultad)) {
          return entrada.key;
        }
        return TipoFragmentoEnTejado.unitario;
      }
    }
    return TipoFragmentoEnTejado.unitario;
  }

  bool _tipoDisponibleEnDificultad(
    TipoFragmentoEnTejado tipo,
    int dificultad,
  ) {
    switch (tipo) {
      case TipoFragmentoEnTejado.unitario:
        return true;
      case TipoFragmentoEnTejado.espejo:
        return dificultad >= 1;
      case TipoFragmentoEnTejado.decimal:
      case TipoFragmentoEnTejado.porcentaje:
        return dificultad >= 2;
      case TipoFragmentoEnTejado.impropio:
        return dificultad >= 3;
      case TipoFragmentoEnTejado.proporcional:
      case TipoFragmentoEnTejado.dual:
        return dificultad >= 4;
    }
  }

  /// Dos fracciones a sumar. Los denominadores son distintos y los
  /// numeradores siempre menores que sus denominadores para que la
  /// suma se parezca a ejercicios típicos de 6º de primaria.
  (int, int, int, int) _elegirSumandosDual(int dificultad) {
    final denominadoresPosibles = dificultad < 6
        ? const [2, 3, 3, 4, 4, 5, 6]
        : const [3, 4, 5, 6, 6, 8, 10, 12];
    final denA =
        denominadoresPosibles[_azar.nextInt(denominadoresPosibles.length)];
    int denB;
    do {
      denB = denominadoresPosibles[
          _azar.nextInt(denominadoresPosibles.length)];
    } while (denB == denA);
    final numA = 1 + _azar.nextInt(math.max(1, denA - 1));
    final numB = 1 + _azar.nextInt(math.max(1, denB - 1));
    return (numA, denA, numB, denB);
  }

  int _elegirDenominadorImpropio(int dificultad) {
    final candidatos = <int>[2, 3, 3, 4, 4, 5];
    if (dificultad >= 5) candidatos.addAll([6, 7]);
    if (dificultad >= 6) candidatos.addAll([8, 9]);
    return candidatos[_azar.nextInt(candidatos.length)];
  }

  int _elegirNumeradorImpropio(int denominador, int dificultad) {
    // Impropia: numerador > denominador. Cota superior más modesta para
    // que la parte entera no sea demasiado grande (1-3).
    final minimo = denominador + 1;
    final maximoBase = denominador * 3;
    final maximo = maximoBase - (_azar.nextInt(2));
    return minimo + _azar.nextInt(math.max(1, maximo - minimo));
  }

  /// Para Espejos interesa más variedad de denominadores pequeños
  /// (2, 3, 4, 5, 6, 8, 10) — equivalencias claras.
  int _elegirDenominadorEspejo(int dificultad) {
    final candidatos = <int>[2, 3, 4, 4, 5, 6, 6, 8];
    if (dificultad >= 3) candidatos.addAll([10, 10, 12]);
    if (dificultad >= 5) candidatos.addAll([9, 15]);
    return candidatos[_azar.nextInt(candidatos.length)];
  }

  /// En Espejos el numerador puede ser cualquiera < denominador. Al
  /// mostrar la fracción objetivo queremos que sea reducible y llamativa.
  int _elegirNumeradorEspejo(int denominador, int dificultad) {
    if (denominador <= 2) return 1;
    return 1 + _azar.nextInt(denominador - 1);
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
