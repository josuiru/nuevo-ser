import 'dart:math' as math;

/// Problema GEO.06: el niño ve un ortoedro (caja 3D) con su largo,
/// ancho y alto etiquetados, y elige el volumen entre cuatro
/// candidatos. Mecánica: l × a × h. Distractores reales: área de una
/// cara, suma de las tres dimensiones, área superficial.
class ProblemaVolumen {
  final int largo;
  final int ancho;
  final int alto;
  final List<int> candidatos;
  final int indiceCorrecto;

  const ProblemaVolumen({
    required this.largo,
    required this.ancho,
    required this.alto,
    required this.candidatos,
    required this.indiceCorrecto,
  });

  int get respuesta => candidatos[indiceCorrecto];

  bool esCorrecta(int indiceElegido) => indiceElegido == indiceCorrecto;
}

class _CasoVolumen {
  final int largo;
  final int ancho;
  final int alto;
  const _CasoVolumen(this.largo, this.ancho, this.alto);
}

const _casosCurados = <_CasoVolumen>[
  // Cubos pequeños.
  _CasoVolumen(2, 2, 2), // 8
  _CasoVolumen(3, 3, 3), // 27
  _CasoVolumen(4, 4, 4), // 64
  // Ortoedros sencillos.
  _CasoVolumen(3, 2, 2), // 12
  _CasoVolumen(4, 3, 2), // 24
  _CasoVolumen(5, 3, 2), // 30
  _CasoVolumen(5, 4, 3), // 60
  _CasoVolumen(6, 4, 2), // 48
  _CasoVolumen(6, 3, 3), // 54
  _CasoVolumen(8, 5, 2), // 80
  _CasoVolumen(7, 4, 3), // 84
  _CasoVolumen(10, 4, 3), // 120
];

class GeneradorVolumen {
  final math.Random _azar;

  GeneradorVolumen({int? semilla}) : _azar = math.Random(semilla);

  static int get cantidadDeCasosCurados => _casosCurados.length;

  ProblemaVolumen generar({int dificultad = 1}) {
    // Dificultad 1: solo casos con dimensiones ≤ 5.
    final pool = dificultad >= 2
        ? List.generate(_casosCurados.length, (i) => i)
        : List.generate(_casosCurados.length, (i) => i)
            .where((i) {
              final c = _casosCurados[i];
              return c.largo <= 5 && c.ancho <= 5 && c.alto <= 5;
            })
            .toList();
    final indice = pool[_azar.nextInt(pool.length)];
    return _construir(_casosCurados[indice]);
  }

  ProblemaVolumen generarPorIndice(int indice) {
    return _construir(
      _casosCurados[indice.clamp(0, _casosCurados.length - 1)],
    );
  }

  ProblemaVolumen _construir(_CasoVolumen caso) {
    final volumen = caso.largo * caso.ancho * caso.alto;
    final candidatos = <int>[volumen];
    bool yaEsta(int valor) => candidatos.contains(valor);
    void anyadirSiNuevo(int valor) {
      if (valor <= 0) return;
      if (!yaEsta(valor)) candidatos.add(valor);
    }

    // Distractor 1: suma l+a+h.
    anyadirSiNuevo(caso.largo + caso.ancho + caso.alto);
    // Distractor 2: producto de dos dimensiones (área de una cara).
    anyadirSiNuevo(caso.largo * caso.ancho);
    // Distractor 3: área superficial (2(la+lh+ah)).
    anyadirSiNuevo(
      2 *
          (caso.largo * caso.ancho +
              caso.largo * caso.alto +
              caso.ancho * caso.alto),
    );
    // Distractor 4: doble del correcto.
    anyadirSiNuevo(volumen * 2);
    // Distractor 5: la mitad.
    anyadirSiNuevo(volumen ~/ 2);

    final cuatro = candidatos.take(4).toList()..shuffle(_azar);
    final indice = cuatro.indexOf(volumen);
    return ProblemaVolumen(
      largo: caso.largo,
      ancho: caso.ancho,
      alto: caso.alto,
      candidatos: cuatro,
      indiceCorrecto: indice,
    );
  }
}
