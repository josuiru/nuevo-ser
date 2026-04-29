import 'dart:math' as math;

/// Problema GEO.04: el niño ve un triángulo con base y altura
/// etiquetadas y elige el área entre cuatro candidatos. Mecánica:
/// (b × h) / 2. Distractor estrella: olvidar el /2 (b × h) — la
/// trampa más común al pasar de rectángulos a triángulos.
class ProblemaAreaTriangulo {
  final int base;
  final int altura;
  final List<int> candidatos;
  final int indiceCorrecto;

  const ProblemaAreaTriangulo({
    required this.base,
    required this.altura,
    required this.candidatos,
    required this.indiceCorrecto,
  });

  int get respuesta => candidatos[indiceCorrecto];

  bool esCorrecta(int indiceElegido) => indiceElegido == indiceCorrecto;
}

class _CasoArea {
  final int base;
  final int altura;
  const _CasoArea(this.base, this.altura);
}

const _casosCurados = <_CasoArea>[
  // base × altura siempre par para que el área sea entera.
  _CasoArea(4, 3), // 6
  _CasoArea(6, 4), // 12
  _CasoArea(8, 5), // 20
  _CasoArea(10, 4), // 20
  _CasoArea(6, 6), // 18
  _CasoArea(12, 3), // 18
  _CasoArea(8, 6), // 24
  _CasoArea(10, 6), // 30
  _CasoArea(8, 4), // 16
  _CasoArea(14, 4), // 28
  _CasoArea(12, 5), // 30
  _CasoArea(10, 8), // 40
];

class GeneradorAreaTriangulo {
  final math.Random _azar;

  GeneradorAreaTriangulo({int? semilla}) : _azar = math.Random(semilla);

  static int get cantidadDeCasosCurados => _casosCurados.length;

  ProblemaAreaTriangulo generar({int dificultad = 1}) {
    // Dificultad 1: solo casos con base ≤ 8.
    final pool = dificultad >= 2
        ? List.generate(_casosCurados.length, (i) => i)
        : List.generate(_casosCurados.length, (i) => i)
            .where((i) => _casosCurados[i].base <= 8)
            .toList();
    final indice = pool[_azar.nextInt(pool.length)];
    return _construir(_casosCurados[indice]);
  }

  ProblemaAreaTriangulo generarPorIndice(int indice) {
    return _construir(
      _casosCurados[indice.clamp(0, _casosCurados.length - 1)],
    );
  }

  ProblemaAreaTriangulo _construir(_CasoArea caso) {
    assert((caso.base * caso.altura) % 2 == 0,
        'base × altura debe ser par para área entera');
    final area = (caso.base * caso.altura) ~/ 2;
    final candidatos = <int>[area];
    bool yaEsta(int valor) => candidatos.contains(valor);
    void anyadirSiNuevo(int valor) {
      if (valor <= 0) return;
      if (!yaEsta(valor)) candidatos.add(valor);
    }

    // Distractor 1: trampa estrella — b × h sin dividir entre 2.
    anyadirSiNuevo(caso.base * caso.altura);
    // Distractor 2: suma b+h.
    anyadirSiNuevo(caso.base + caso.altura);
    // Distractor 3: la mitad de la mitad (dividir dos veces).
    anyadirSiNuevo(area ~/ 2);
    // Distractor 4: doble del correcto.
    anyadirSiNuevo(area * 2);
    // Distractor 5: solo la base o solo la altura (sin operar).
    anyadirSiNuevo(caso.base);
    anyadirSiNuevo(caso.altura);

    final cuatro = candidatos.take(4).toList()..shuffle(_azar);
    final indice = cuatro.indexOf(area);
    return ProblemaAreaTriangulo(
      base: caso.base,
      altura: caso.altura,
      candidatos: cuatro,
      indiceCorrecto: indice,
    );
  }
}
