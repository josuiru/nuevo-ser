import 'dart:math' as math;

/// Problema GEO.02: el niño ve un polígono dibujado con sus lados
/// etiquetados (números enteros) y elige el perímetro entre cuatro
/// candidatos. La habilidad: sumar todos los lados. Distractores
/// reales: olvidar un lado, multiplicar por número de lados,
/// confundir con la mitad.
class ProblemaPerimetro {
  /// Lista de longitudes de los lados, en el orden en que se dibujan
  /// alrededor del polígono. Para polígonos regulares todos son
  /// iguales; el problema admite también polígonos irregulares
  /// (rectángulos, trapecios sencillos).
  final List<int> lados;
  final List<int> candidatos;
  final int indiceCorrecto;

  const ProblemaPerimetro({
    required this.lados,
    required this.candidatos,
    required this.indiceCorrecto,
  });

  int get respuesta => candidatos[indiceCorrecto];

  bool esCorrecta(int indiceElegido) => indiceElegido == indiceCorrecto;
}

/// Caso curado: una lista de lados con su perímetro precalculado.
class _CasoPerimetro {
  final List<int> lados;
  const _CasoPerimetro(this.lados);
}

const _casosCurados = <_CasoPerimetro>[
  // Triángulos.
  _CasoPerimetro([3, 4, 5]), // perímetro 12
  _CasoPerimetro([6, 8, 10]), // perímetro 24
  _CasoPerimetro([5, 5, 5]), // equilátero 15
  // Cuadrados.
  _CasoPerimetro([4, 4, 4, 4]), // 16
  _CasoPerimetro([7, 7, 7, 7]), // 28
  // Rectángulos.
  _CasoPerimetro([5, 3, 5, 3]), // 16
  _CasoPerimetro([8, 4, 8, 4]), // 24
  _CasoPerimetro([10, 6, 10, 6]), // 32
  // Pentágonos regulares.
  _CasoPerimetro([4, 4, 4, 4, 4]), // 20
  _CasoPerimetro([6, 6, 6, 6, 6]), // 30
  // Hexágonos regulares.
  _CasoPerimetro([3, 3, 3, 3, 3, 3]), // 18
  _CasoPerimetro([5, 5, 5, 5, 5, 5]), // 30
];

class GeneradorPerimetro {
  final math.Random _azar;

  GeneradorPerimetro({int? semilla}) : _azar = math.Random(semilla);

  static int get cantidadDeCasosCurados => _casosCurados.length;

  ProblemaPerimetro generar({int dificultad = 1}) {
    // Dificultad 1: solo triángulos y cuadrados (3-4 lados).
    // Dificultad 2+: pool completo.
    final pool = dificultad >= 2
        ? List.generate(_casosCurados.length, (i) => i)
        : List.generate(_casosCurados.length, (i) => i)
            .where((i) => _casosCurados[i].lados.length <= 4)
            .toList();
    final indice = pool[_azar.nextInt(pool.length)];
    return _construir(_casosCurados[indice]);
  }

  ProblemaPerimetro generarPorIndice(int indice) {
    return _construir(
      _casosCurados[indice.clamp(0, _casosCurados.length - 1)],
    );
  }

  ProblemaPerimetro _construir(_CasoPerimetro caso) {
    final perimetro = caso.lados.fold<int>(0, (a, b) => a + b);
    final candidatos = <int>[perimetro];
    bool yaEsta(int valor) => candidatos.contains(valor);
    void anyadirSiNuevo(int valor) {
      if (valor <= 0) return;
      if (!yaEsta(valor)) candidatos.add(valor);
    }

    // Distractor 1: olvidar un lado (el primero).
    anyadirSiNuevo(perimetro - caso.lados.first);
    // Distractor 2: contar solo dos lados (típico en rectángulos).
    if (caso.lados.length >= 2) {
      anyadirSiNuevo(caso.lados[0] + caso.lados[1]);
    }
    // Distractor 3: la mitad del perímetro (semiperímetro).
    anyadirSiNuevo(perimetro ~/ 2);
    // Distractor 4: multiplicar el primer lado por número de lados (lo
    // correcto solo si es regular; en irregulares es trampa real).
    anyadirSiNuevo(caso.lados.first * caso.lados.length);
    // Distractor 5: el perímetro + 1 (off-by-one al contar).
    anyadirSiNuevo(perimetro + 1);

    final cuatro = candidatos.take(4).toList()..shuffle(_azar);
    final indice = cuatro.indexOf(perimetro);
    return ProblemaPerimetro(
      lados: caso.lados,
      candidatos: cuatro,
      indiceCorrecto: indice,
    );
  }
}
