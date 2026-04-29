import 'dart:math' as math;

/// Problema GEO.03: el niño ve un rectángulo (o cuadrado) con su base
/// y altura etiquetadas, y elige el área entre cuatro candidatos.
/// Mecánica: base × altura. Distractores reales: perímetro,
/// suma b+h, b² ignorando la altura.
class ProblemaAreaRectangulo {
  final int base;
  final int altura;
  final List<int> candidatos;
  final int indiceCorrecto;

  const ProblemaAreaRectangulo({
    required this.base,
    required this.altura,
    required this.candidatos,
    required this.indiceCorrecto,
  });

  bool get esCuadrado => base == altura;
  int get respuesta => candidatos[indiceCorrecto];

  bool esCorrecta(int indiceElegido) => indiceElegido == indiceCorrecto;
}

class _CasoArea {
  final int base;
  final int altura;
  const _CasoArea(this.base, this.altura);
}

const _casosCurados = <_CasoArea>[
  // Cuadrados.
  _CasoArea(3, 3), // 9
  _CasoArea(5, 5), // 25
  _CasoArea(6, 6), // 36
  _CasoArea(8, 8), // 64
  // Rectángulos sencillos.
  _CasoArea(4, 3), // 12
  _CasoArea(5, 4), // 20
  _CasoArea(6, 4), // 24
  _CasoArea(7, 5), // 35
  _CasoArea(8, 6), // 48
  _CasoArea(10, 4), // 40
  _CasoArea(9, 7), // 63
  _CasoArea(12, 5), // 60
];

class GeneradorAreaRectangulo {
  final math.Random _azar;

  GeneradorAreaRectangulo({int? semilla}) : _azar = math.Random(semilla);

  static int get cantidadDeCasosCurados => _casosCurados.length;

  ProblemaAreaRectangulo generar({int dificultad = 1}) {
    // Dificultad 1: solo casos con valores pequeños (≤ 6).
    final pool = dificultad >= 2
        ? List.generate(_casosCurados.length, (i) => i)
        : List.generate(_casosCurados.length, (i) => i)
            .where((i) =>
                _casosCurados[i].base <= 6 && _casosCurados[i].altura <= 6)
            .toList();
    final indice = pool[_azar.nextInt(pool.length)];
    return _construir(_casosCurados[indice]);
  }

  ProblemaAreaRectangulo generarPorIndice(int indice) {
    return _construir(
      _casosCurados[indice.clamp(0, _casosCurados.length - 1)],
    );
  }

  ProblemaAreaRectangulo _construir(_CasoArea caso) {
    final area = caso.base * caso.altura;
    final perimetro = 2 * (caso.base + caso.altura);
    final candidatos = <int>[area];
    bool yaEsta(int valor) => candidatos.contains(valor);
    void anyadirSiNuevo(int valor) {
      if (valor <= 0) return;
      if (!yaEsta(valor)) candidatos.add(valor);
    }

    // Distractor 1: perímetro (confundir las dos magnitudes).
    anyadirSiNuevo(perimetro);
    // Distractor 2: suma b+h (sin multiplicar).
    anyadirSiNuevo(caso.base + caso.altura);
    // Distractor 3: b² (cuadrar la base — frecuente en rectángulos).
    if (caso.base != caso.altura) {
      anyadirSiNuevo(caso.base * caso.base);
    } else {
      anyadirSiNuevo(caso.base * 2);
    }
    // Distractor 4: doble del área.
    anyadirSiNuevo(area * 2);
    // Distractor 5: mitad del área.
    anyadirSiNuevo(area ~/ 2);

    final cuatro = candidatos.take(4).toList()..shuffle(_azar);
    final indice = cuatro.indexOf(area);
    return ProblemaAreaRectangulo(
      base: caso.base,
      altura: caso.altura,
      candidatos: cuatro,
      indiceCorrecto: indice,
    );
  }
}
