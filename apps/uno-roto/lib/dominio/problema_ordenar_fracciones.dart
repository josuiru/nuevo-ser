import 'dart:math' as math;

import 'problema_espejo.dart' show Fraccion;

/// Problema FR.08: el niño ve tres fracciones y elige el ordenamiento
/// correcto de menor a mayor entre cuatro candidatos. Las fracciones
/// se eligen para que la comparación cruzada sea contraintuitiva (los
/// numeradores o denominadores mayores no marcan necesariamente la
/// fracción mayor).
class ProblemaOrdenarFracciones {
  final List<Fraccion> presentadas;
  final List<List<Fraccion>> candidatos;
  final int indiceCorrecto;

  const ProblemaOrdenarFracciones({
    required this.presentadas,
    required this.candidatos,
    required this.indiceCorrecto,
  });

  List<Fraccion> get correcto => candidatos[indiceCorrecto];

  bool esCorrecta(int indiceElegido) => indiceElegido == indiceCorrecto;
}

/// Triplas curadas de fracciones con orden conocido y comparación
/// cruzada (denominadores y numeradores diferentes para que el niño
/// no pueda atajar). Sesgadas a casos donde los atajos visuales
/// fallan.
const _triosFaciles = <List<(int, int)>>[
  [(1, 2), (1, 3), (1, 4)],     // 1/4 < 1/3 < 1/2 — mismo numerador.
  [(2, 3), (1, 2), (3, 4)],     // 1/2 < 2/3 < 3/4.
  [(1, 5), (2, 5), (3, 5)],     // 1/5 < 2/5 < 3/5 — mismo denominador.
  [(3, 4), (2, 3), (1, 2)],     // 1/2 < 2/3 < 3/4.
  [(1, 4), (3, 8), (1, 2)],     // 1/4 < 3/8 < 1/2.
  [(1, 3), (2, 5), (1, 2)],     // 1/3 < 2/5 < 1/2.
];
const _triosMedios = <List<(int, int)>>[
  [(2, 5), (3, 7), (1, 2)],     // 2/5 < 3/7 < 1/2 — todos cerca.
  [(3, 8), (2, 5), (5, 12)],    // 3/8 < 2/5 < 5/12.
  [(5, 6), (7, 8), (3, 4)],     // 3/4 < 5/6 < 7/8.
  [(2, 3), (5, 8), (3, 5)],     // 3/5 < 5/8 < 2/3 — los tres > 1/2.
  [(1, 4), (2, 7), (1, 3)],     // 1/4 < 2/7 < 1/3.
];

class GeneradorOrdenarFracciones {
  final math.Random _azar;

  GeneradorOrdenarFracciones({int? semilla}) : _azar = math.Random(semilla);

  ProblemaOrdenarFracciones generar({int dificultad = 1}) {
    final pool = <List<(int, int)>>[
      ..._triosFaciles,
      if (dificultad >= 2) ..._triosMedios,
    ];
    final pares = pool[_azar.nextInt(pool.length)];
    final trio = pares.map((p) => Fraccion(p.$1, p.$2)).toList();
    return _construir(trio);
  }

  ProblemaOrdenarFracciones generarDesdeTrio(List<Fraccion> trio) =>
      _construir(List<Fraccion>.from(trio));

  ProblemaOrdenarFracciones _construir(List<Fraccion> trio) {
    final presentadas = List<Fraccion>.from(trio)..shuffle(_azar);

    final ordenado = List<Fraccion>.from(presentadas)
      ..sort((a, b) => a.valor.compareTo(b.valor));

    // Distractores curados:
    // 1. Orden por numeradores (ignora denominadores) — error
    //    típico cuando el niño ve "más arriba = más grande".
    final porNumerador = List<Fraccion>.from(presentadas)
      ..sort((a, b) => a.numerador.compareTo(b.numerador));
    // 2. Orden por denominadores en sentido natural (atajo erróneo:
    //    "más abajo = más pequeño", pero a más denominador menos vale).
    final porDenominador = List<Fraccion>.from(presentadas)
      ..sort((a, b) => a.denominador.compareTo(b.denominador));
    // 3. Orden invertido del correcto (mayor a menor).
    final invertido = List<Fraccion>.from(ordenado.reversed);

    final candidatosBase = <List<Fraccion>>[
      ordenado,
      porNumerador,
      porDenominador,
      invertido,
    ];

    final unicos = <List<Fraccion>>[];
    for (final cand in candidatosBase) {
      if (!unicos.any((u) => _mismoOrden(u, cand))) {
        unicos.add(cand);
      }
    }

    var intentos = 0;
    while (unicos.length < 4 && intentos < 30) {
      final permutacion = List<Fraccion>.from(presentadas)..shuffle(_azar);
      if (!unicos.any((u) => _mismoOrden(u, permutacion))) {
        unicos.add(permutacion);
      }
      intentos++;
    }

    final cuatro = unicos.take(4).toList()..shuffle(_azar);
    final indice = cuatro.indexWhere((c) => _mismoOrden(c, ordenado));
    return ProblemaOrdenarFracciones(
      presentadas: presentadas,
      candidatos: cuatro,
      indiceCorrecto: indice,
    );
  }

  bool _mismoOrden(List<Fraccion> a, List<Fraccion> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i].numerador != b[i].numerador ||
          a[i].denominador != b[i].denominador) {
        return false;
      }
    }
    return true;
  }
}
