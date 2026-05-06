import 'dart:math' as math;

/// Puzzle ALG.01: el niño/usuario ve una ecuación lineal en x y elige
/// el valor de x entre cuatro candidatos. Primer puzzle del dominio
/// ALG (Álgebra) — entrada hacia arriba del rango pedagógico actual,
/// para chavales que dominan ya la aritmética y empiezan secundaria.
class ProblemaEcuacionLineal {
  /// Coeficiente que multiplica x. Siempre != 0.
  final int a;

  /// Término independiente del lado izquierdo (ax + b = c).
  final int b;

  /// Lado derecho de la ecuación.
  final int c;

  /// Modo de la ecuación: simple "ax = c" o con término "ax + b = c".
  final ModoEcuacionLineal modo;

  final List<int> candidatos;
  final int indiceCorrecto;

  const ProblemaEcuacionLineal({
    required this.a,
    required this.b,
    required this.c,
    required this.modo,
    required this.candidatos,
    required this.indiceCorrecto,
  });

  /// Solución: x = (c - b) / a. Siempre entera por construcción.
  int get correcto => (c - b) ~/ a;

  bool esCorrecta(int indice) => indice == indiceCorrecto;

  /// Etiqueta visual lista para mostrar en la cabecera del puzzle.
  String get etiqueta {
    final ladoIzquierdo = b == 0
        ? '${a == 1 ? '' : '$a'}x'
        : b > 0
            ? '${a == 1 ? '' : '$a'}x + $b'
            : '${a == 1 ? '' : '$a'}x − ${-b}';
    return '$ladoIzquierdo = $c';
  }
}

enum ModoEcuacionLineal { simple, conTermino }

/// Genera ecuaciones lineales con solución entera garantizada.
///   - Dif 1: ax = c (modo simple), a∈[2..5], x∈[1..9].
///   - Dif 2: ax + b = c (modo con término), a∈[2..5], x∈[1..9], b∈[1..9].
///   - Dif 3: ax + b = c con b negativo o x negativo permitidos.
///   - Dif 4: coeficientes mayores y x∈[-9..9].
class GeneradorEcuacionLineal {
  final math.Random _azar;

  GeneradorEcuacionLineal({int? semilla}) : _azar = math.Random(semilla);

  ProblemaEcuacionLineal generar({int dificultad = 1}) {
    final modo = dificultad == 1
        ? ModoEcuacionLineal.simple
        : ModoEcuacionLineal.conTermino;

    final maxA = switch (dificultad) { 1 => 5, 2 => 5, 3 => 7, _ => 9 };
    final permitirNegativos = dificultad >= 3;

    final a = 2 + _azar.nextInt(maxA - 1);
    final x = _generarValorX(dificultad, permitirNegativos);
    final b = modo == ModoEcuacionLineal.simple
        ? 0
        : _generarTerminoB(dificultad, permitirNegativos);
    final c = a * x + b;

    return _construir(a: a, b: b, c: c, modo: modo);
  }

  int _generarValorX(int dificultad, bool permitirNegativos) {
    final maxX = dificultad <= 2 ? 9 : 9;
    var x = 1 + _azar.nextInt(maxX);
    if (permitirNegativos && _azar.nextBool()) x = -x;
    return x;
  }

  int _generarTerminoB(int dificultad, bool permitirNegativos) {
    var b = 1 + _azar.nextInt(9);
    if (permitirNegativos && _azar.nextBool()) b = -b;
    return b;
  }

  ProblemaEcuacionLineal _construir({
    required int a,
    required int b,
    required int c,
    required ModoEcuacionLineal modo,
  }) {
    final correcto = (c - b) ~/ a;
    final distractores = <int>{};

    // Distractor estrella: olvidar dividir entre a (responder c-b
    // crudo, o c en modo simple).
    final sinDividir = c - b;
    if (sinDividir != correcto) distractores.add(sinDividir);

    // Distractor: sumar en lugar de restar el término b.
    if (modo == ModoEcuacionLineal.conTermino) {
      final sumandoB = (c + b) ~/ a;
      if (sumandoB != correcto && (c + b) % a == 0) {
        distractores.add(sumandoB);
      }
    }

    // Distractor: signo invertido del correcto.
    if (-correcto != correcto && -correcto != 0) {
      distractores.add(-correcto);
    }

    // Distractor: el coeficiente a literal (típico al ver "3x" y
    // pensar que x = 3).
    if (a != correcto) distractores.add(a);

    // Distractor: error de ±1.
    if (distractores.length < 3) distractores.add(correcto + 1);
    if (distractores.length < 3) distractores.add(correcto - 1);

    // Fallback ultra defensivo — varía k para garantizar unicidad.
    var k = 2;
    while (distractores.length < 3 && k < 50) {
      final candidato = correcto + k;
      k++;
      if (candidato == correcto) continue;
      if (distractores.contains(candidato)) continue;
      distractores.add(candidato);
    }

    final lista = <int>[correcto, ...distractores.take(3)];
    lista.shuffle(_azar);
    return ProblemaEcuacionLineal(
      a: a,
      b: b,
      c: c,
      modo: modo,
      candidatos: lista,
      indiceCorrecto: lista.indexOf(correcto),
    );
  }
}
