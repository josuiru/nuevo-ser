import 'dart:math' as math;

/// Problema EST.03: el niño ve un conjunto pequeño de números
/// ([4, 8, 6, 10]) y elige la media entre cuatro candidatos.
class ProblemaMedia {
  final List<int> datos;
  final List<int> candidatos;
  final int indiceCorrecto;

  const ProblemaMedia({
    required this.datos,
    required this.candidatos,
    required this.indiceCorrecto,
  });

  int get media => candidatos[indiceCorrecto];

  bool esCorrecta(int indiceElegido) => indiceElegido == indiceCorrecto;
}

/// Conjuntos curados con suma divisible entre la cantidad — media
/// entera garantizada. Sesgo a 4-5 datos (lo más común en primaria).
const _conjuntosFaciles = <List<int>>[
  [4, 6, 8, 10],          // media 7
  [3, 5, 7, 9],           // media 6
  [2, 4, 6, 8, 10],       // media 6
  [5, 5, 5, 5],           // media 5 (caso "todos iguales")
  [10, 20, 30],           // media 20
  [4, 8, 12],             // media 8
  [6, 12, 18, 24],        // media 15
  [8, 10, 12, 14],        // media 11
];
const _conjuntosMedios = <List<int>>[
  [12, 15, 18, 21, 24],   // media 18
  [25, 30, 35, 40, 45],   // media 35
  [50, 60, 70, 80, 90],   // media 70
];

class GeneradorMedia {
  final math.Random _azar;

  GeneradorMedia({int? semilla}) : _azar = math.Random(semilla);

  static List<List<int>> get poolCompleto =>
      [..._conjuntosFaciles, ..._conjuntosMedios];

  ProblemaMedia generar({int dificultad = 1}) {
    final pool = <List<int>>[
      ..._conjuntosFaciles,
      if (dificultad >= 2) ..._conjuntosMedios,
    ];
    final datos = pool[_azar.nextInt(pool.length)];
    return _construir(datos);
  }

  ProblemaMedia generarPorIndice(int indice) {
    final pool = poolCompleto;
    return _construir(pool[indice.clamp(0, pool.length - 1)]);
  }

  ProblemaMedia generarDesdeDatos(List<int> datos) => _construir(datos);

  ProblemaMedia _construir(List<int> datos) {
    final suma = datos.reduce((a, b) => a + b);
    final correcto = suma ~/ datos.length;

    final propuestos = <int>[correcto];
    void anyadirSiNuevo(int v) {
      if (v <= 0) return;
      if (!propuestos.contains(v)) propuestos.add(v);
    }

    // 1. La suma sin dividir — error muy común en primaria.
    anyadirSiNuevo(suma);
    // 2. El mayor del conjunto.
    anyadirSiNuevo(datos.reduce(math.max));
    // 3. El menor del conjunto.
    anyadirSiNuevo(datos.reduce(math.min));
    // 4. La cantidad de datos en lugar de la media.
    anyadirSiNuevo(datos.length);

    var paso = 1;
    while (propuestos.length < 4) {
      anyadirSiNuevo(correcto + paso);
      if (propuestos.length < 4) anyadirSiNuevo(correcto - paso);
      paso++;
      if (paso > 6) break;
    }

    final cuatro = propuestos.take(4).toList()..shuffle(_azar);
    final indice = cuatro.indexOf(correcto);
    return ProblemaMedia(
      datos: datos,
      candidatos: cuatro,
      indiceCorrecto: indice,
    );
  }
}
