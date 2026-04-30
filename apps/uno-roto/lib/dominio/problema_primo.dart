import 'dart:math' as math;

/// Problema DIV.05: el niño ve un número y decide si es primo.
/// Mecánica binaria — el cálculo es trivial pero la mecánica del
/// puzzle son los **hechos memorizados** (1 no es primo, 2 sí, 9 no…).
class ProblemaPrimo {
  final int numero;

  const ProblemaPrimo({required this.numero});

  bool get esPrimo {
    if (numero < 2) return false;
    if (numero == 2) return true;
    if (numero.isEven) return false;
    for (var divisor = 3; divisor * divisor <= numero; divisor += 2) {
      if (numero % divisor == 0) return false;
    }
    return true;
  }

  bool esCorrecta(bool respuestaSi) => respuestaSi == esPrimo;
}

/// Pools curados por categoría pedagógica.
/// - Confusos no-primos: impares y cuadrados pequeños que el niño
///   confunde con primos por aspecto.
/// - Especiales: 1 (no es primo, contraintuitivo) y 2 (sí, único par).
/// - Primos claros: aparecen como contraste para no frustrar.
/// - Pares no-primos obvios: peso bajo, son demasiado fáciles.
const _confusosNoPrimosBasicos = <int>[1, 9, 15, 21, 25, 27, 33, 35];
const _confusosNoPrimosAvanzados = <int>[49, 51, 57, 65, 77, 91];
const _primosClarosBasicos = <int>[3, 5, 7, 11, 13, 17, 19, 23];
const _primosClarosAvanzados = <int>[29, 31, 37, 41, 43, 47];
const _paresNoPrimosObvios = <int>[4, 6, 8, 10, 12, 14];

class GeneradorPrimo {
  final math.Random _azar;

  GeneradorPrimo({int? semilla}) : _azar = math.Random(semilla);

  /// Reparto: 40 % confusos no-primos · 30 % primos claros ·
  /// 15 % especiales (1 o 2) · 15 % pares obvios.
  /// Dificultad 1: solo pools básicos.
  /// Dificultad 2: añade los pools avanzados.
  /// Dificultad 3: amplía hasta 100 con generación al vuelo, sin
  /// renunciar al sesgo a casos curados.
  ProblemaPrimo generar({int dificultad = 1}) {
    final tirada = _azar.nextDouble();
    final List<int> pool;
    if (tirada < 0.40) {
      pool = [
        ..._confusosNoPrimosBasicos,
        if (dificultad >= 2) ..._confusosNoPrimosAvanzados,
      ];
    } else if (tirada < 0.70) {
      pool = [
        ..._primosClarosBasicos,
        if (dificultad >= 2) ..._primosClarosAvanzados,
      ];
    } else if (tirada < 0.85) {
      // Especiales: 1 (no primo, sorpresa) o 2 (único par primo).
      return ProblemaPrimo(numero: _azar.nextBool() ? 1 : 2);
    } else {
      pool = _paresNoPrimosObvios;
    }

    if (dificultad >= 3 && _azar.nextDouble() < 0.35) {
      // En tier alto, una de cada tres tiradas la generamos al vuelo
      // hasta 100 — pero pre-equilibrada 50/50 sí-primo/no-primo.
      // Antes se sacaba al azar uniforme en [2, 100], lo que
      // sesgaba 25/75 hacia "no primo" y rompía el balance del
      // resto del generador.
      if (_azar.nextBool()) {
        return ProblemaPrimo(numero: _primoAleatorio());
      }
      return ProblemaPrimo(numero: _noPrimoAleatorio());
    }

    return ProblemaPrimo(numero: pool[_azar.nextInt(pool.length)]);
  }

  /// Primo al azar en [2, 100]. Lista pre-calculada para no perder
  /// tiempo en cribar.
  static const _primosHasta100 = <int>[
    2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59,
    61, 67, 71, 73, 79, 83, 89, 97,
  ];

  int _primoAleatorio() =>
      _primosHasta100[_azar.nextInt(_primosHasta100.length)];

  /// No-primo al azar en [4, 100], excluyendo 1 (que ya aparece como
  /// caso especial) — devolvemos un compuesto.
  int _noPrimoAleatorio() {
    while (true) {
      final candidato = 4 + _azar.nextInt(97);
      if (!_primosHasta100.contains(candidato)) return candidato;
    }
  }
}
