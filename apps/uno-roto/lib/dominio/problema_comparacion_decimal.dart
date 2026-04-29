import 'dart:math' as math;

/// Problema DEC.02: el niño ve dos números decimales y toca el mayor.
/// Mecánica gemela a [ProblemaComparacion] pero el formato y la
/// dificultad pedagógica son distintos — la trampa típica es leer "0,35"
/// como mayor que "0,4" por tener más dígitos.
class ProblemaComparacionDecimal {
  final String etiquetaA;
  final String etiquetaB;
  final double valorA;
  final double valorB;

  const ProblemaComparacionDecimal({
    required this.etiquetaA,
    required this.etiquetaB,
    required this.valorA,
    required this.valorB,
  });

  int? get indiceMayor {
    if (valorA > valorB) return 0;
    if (valorB > valorA) return 1;
    return null;
  }

  bool esCorrecto(int indiceElegido) => indiceElegido == indiceMayor;
}

/// Genera comparaciones de decimales con un sesgo deliberado hacia los
/// casos en los que el decimal con **más dígitos no es el mayor** —
/// que es justo el error sistemático que la habilidad pretende corregir.
class GeneradorComparacionDecimal {
  final math.Random _azar;

  GeneradorComparacionDecimal({int? semilla}) : _azar = math.Random(semilla);

  /// Pares curados. La mayoría son "trampa" (longitud distinta, el más
  /// largo no es el mayor). Algunos pares "fáciles" se mezclan para que
  /// la variedad no agote al niño.
  static const _paresTrampa = [
    ('0,35', '0,4'),
    ('0,7', '0,68'),
    ('0,12', '0,2'),
    ('1,5', '1,45'),
    ('0,9', '0,89'),
    ('2,3', '2,29'),
    ('0,08', '0,1'),
    ('1,2', '1,19'),
    ('0,5', '0,49'),
    ('3,4', '3,38'),
  ];

  static const _paresFaciles = [
    ('0,3', '0,7'),
    ('0,25', '0,5'),
    ('1,2', '0,9'),
    ('2,5', '1,8'),
    ('0,1', '0,9'),
    ('1,5', '2,5'),
  ];

  ProblemaComparacionDecimal generar({int dificultad = 1}) {
    // ~70 % trampa, 30 % fáciles a partir de dificultad 2; en
    // dificultad 1 dejamos más fáciles para introducir suave.
    final umbralTrampa = dificultad >= 2 ? 0.7 : 0.5;
    final usarTrampa = _azar.nextDouble() < umbralTrampa;
    final pares = usarTrampa ? _paresTrampa : _paresFaciles;
    final par = pares[_azar.nextInt(pares.length)];

    // Aleatorizamos el orden — sin esto, el "mayor" siempre estaría
    // en el mismo lado del par curado.
    final invertir = _azar.nextBool();
    final etiquetaA = invertir ? par.$2 : par.$1;
    final etiquetaB = invertir ? par.$1 : par.$2;

    return ProblemaComparacionDecimal(
      etiquetaA: etiquetaA,
      etiquetaB: etiquetaB,
      valorA: _aDouble(etiquetaA),
      valorB: _aDouble(etiquetaB),
    );
  }

  static double _aDouble(String etiqueta) =>
      double.parse(etiqueta.replaceAll(',', '.'));
}
