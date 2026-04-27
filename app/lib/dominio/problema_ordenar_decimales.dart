import 'dart:math' as math;

/// Problema DEC.03: el niño ve tres decimales y elige el ordenamiento
/// correcto de menor a mayor entre cuatro candidatos. Los decimales
/// se eligen para que el orden por número de cifras NO coincida con
/// el orden por valor — justo el atajo erróneo más extendido.
class ProblemaOrdenarDecimales {
  /// Los tres decimales en el orden de presentación (no ordenado).
  final List<String> presentados;

  /// Cuatro listas-candidato: cada una es una permutación de
  /// `presentados` que el niño puede elegir.
  final List<List<String>> candidatos;

  /// Índice de la lista correcta (orden ascendente por valor).
  final int indiceCorrecto;

  const ProblemaOrdenarDecimales({
    required this.presentados,
    required this.candidatos,
    required this.indiceCorrecto,
  });

  List<String> get correcto => candidatos[indiceCorrecto];

  bool esCorrecta(int indiceElegido) => indiceElegido == indiceCorrecto;
}

/// Listas curadas de tres decimales con orden conocido. Sesgadas a
/// casos contraintuitivos: el "más cifras = mayor" es el error
/// dominante, así que los conjuntos lo desafían.
const _triosFaciles = <List<String>>[
  ['0,5', '0,35', '0,8'],   // 0,35 < 0,5 < 0,8 — pero 0,35 tiene más cifras.
  ['0,4', '0,25', '0,6'],   // 0,25 < 0,4 < 0,6.
  ['1,2', '0,9', '1,05'],   // 0,9 < 1,05 < 1,2.
  ['0,7', '0,07', '0,17'],  // 0,07 < 0,17 < 0,7.
  ['2,5', '2,05', '2,5'],   // colisión — descartado en runtime.
];
const _triosMedios = <List<String>>[
  ['1,25', '1,3', '1,205'],   // 1,205 < 1,25 < 1,3.
  ['0,8', '0,75', '0,805'],   // 0,75 < 0,8 < 0,805.
  ['3,4', '3,04', '3,44'],    // 3,04 < 3,4 < 3,44.
  ['0,33', '0,3', '0,303'],   // 0,3 < 0,303 < 0,33.
  ['0,9', '0,109', '0,19'],   // 0,109 < 0,19 < 0,9.
];

/// Convierte "0,35" a 0.35 numérico para comparar valores reales.
double _aDouble(String etiqueta) =>
    double.parse(etiqueta.replaceAll(',', '.'));

class GeneradorOrdenarDecimales {
  final math.Random _azar;

  GeneradorOrdenarDecimales({int? semilla}) : _azar = math.Random(semilla);

  ProblemaOrdenarDecimales generar({int dificultad = 1}) {
    final pool = <List<String>>[
      ..._triosFaciles.where((trio) => trio.toSet().length == 3),
      if (dificultad >= 2) ..._triosMedios,
    ];
    final trio = List<String>.from(pool[_azar.nextInt(pool.length)]);
    return _construir(trio);
  }

  /// Reproduce un problema concreto a partir de los tres decimales.
  ProblemaOrdenarDecimales generarDesdeTrio(List<String> trio) =>
      _construir(List<String>.from(trio));

  ProblemaOrdenarDecimales _construir(List<String> trio) {
    final presentados = List<String>.from(trio)..shuffle(_azar);

    final ordenado = List<String>.from(presentados)
      ..sort((a, b) => _aDouble(a).compareTo(_aDouble(b)));

    // Distractores curados:
    // 1. Orden por número de cifras decimales (más cifras = mayor) — el
    //    error sistemático que la habilidad pretende corregir.
    final porCifras = List<String>.from(presentados)
      ..sort((a, b) => _cifrasDecimales(a).compareTo(_cifrasDecimales(b)));

    // 2. Orden invertido (mayor a menor en lugar de menor a mayor).
    final invertido = List<String>.from(ordenado.reversed);

    // 3. Orden por la primera cifra decimal solo (lectura parcial).
    final porPrimeraCifra = List<String>.from(presentados)
      ..sort((a, b) => _primeraCifra(a).compareTo(_primeraCifra(b)));

    final candidatosBase = <List<String>>[
      ordenado,
      porCifras,
      invertido,
      porPrimeraCifra,
    ];

    // Deduplicamos por contenido (algunas listas pueden coincidir).
    final unicos = <List<String>>[];
    for (final cand in candidatosBase) {
      if (!unicos.any((u) => _mismoOrden(u, cand))) {
        unicos.add(cand);
      }
    }

    // Si quedan menos de 4, rellenamos con permutaciones aleatorias
    // distintas hasta llegar a 4.
    var intentos = 0;
    while (unicos.length < 4 && intentos < 30) {
      final permutacion = List<String>.from(presentados)..shuffle(_azar);
      if (!unicos.any((u) => _mismoOrden(u, permutacion))) {
        unicos.add(permutacion);
      }
      intentos++;
    }

    final cuatro = unicos.take(4).toList()..shuffle(_azar);
    final indice = cuatro.indexWhere((c) => _mismoOrden(c, ordenado));
    return ProblemaOrdenarDecimales(
      presentados: presentados,
      candidatos: cuatro,
      indiceCorrecto: indice,
    );
  }

  int _cifrasDecimales(String etiqueta) {
    final coma = etiqueta.indexOf(',');
    if (coma < 0) return 0;
    return etiqueta.length - coma - 1;
  }

  /// Devuelve la primera cifra después de la coma, o 0 si no hay.
  int _primeraCifra(String etiqueta) {
    final coma = etiqueta.indexOf(',');
    if (coma < 0 || coma + 1 >= etiqueta.length) return 0;
    return int.tryParse(etiqueta[coma + 1]) ?? 0;
  }

  bool _mismoOrden(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
