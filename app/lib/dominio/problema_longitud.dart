import 'dart:math' as math;

/// Unidades de longitud del sistema métrico que el MVP soporta. El
/// orden refleja el factor 10 que separa cada peldaño.
enum UnidadLongitud { km, hm, dam, m, dm, cm, mm }

/// Devuelve la unidad cuyo símbolo coincide. Útil al reconstruir un
/// problema persistido como texto. Lanza [ArgumentError] si no hay
/// coincidencia para no enmascarar errores de empaquetado.
UnidadLongitud unidadDesdeSimbolo(String simbolo) {
  for (final unidad in UnidadLongitud.values) {
    if (unidad.simbolo == simbolo) return unidad;
  }
  throw ArgumentError('Símbolo de longitud desconocido: $simbolo');
}

extension SimboloUnidad on UnidadLongitud {
  String get simbolo {
    switch (this) {
      case UnidadLongitud.km:
        return 'km';
      case UnidadLongitud.hm:
        return 'hm';
      case UnidadLongitud.dam:
        return 'dam';
      case UnidadLongitud.m:
        return 'm';
      case UnidadLongitud.dm:
        return 'dm';
      case UnidadLongitud.cm:
        return 'cm';
      case UnidadLongitud.mm:
        return 'mm';
    }
  }

  /// Posición en la escalera (0 = km, 6 = mm). Cada peldaño multiplica
  /// el valor por 10.
  int get posicion {
    switch (this) {
      case UnidadLongitud.km:
        return 0;
      case UnidadLongitud.hm:
        return 1;
      case UnidadLongitud.dam:
        return 2;
      case UnidadLongitud.m:
        return 3;
      case UnidadLongitud.dm:
        return 4;
      case UnidadLongitud.cm:
        return 5;
      case UnidadLongitud.mm:
        return 6;
    }
  }
}

/// Problema MED.01: el niño ve "5 m = ? cm" y elige el resultado
/// entre cuatro candidatos. Distractores curados a los errores reales
/// de conversión (factor por orden de magnitud, dirección invertida).
class ProblemaLongitud {
  final int valorOrigen;
  final UnidadLongitud unidadOrigen;
  final UnidadLongitud unidadDestino;
  final List<int> candidatos;
  final int indiceCorrecto;

  const ProblemaLongitud({
    required this.valorOrigen,
    required this.unidadOrigen,
    required this.unidadDestino,
    required this.candidatos,
    required this.indiceCorrecto,
  });

  int get resultado => candidatos[indiceCorrecto];

  bool esCorrecta(int indiceElegido) => indiceElegido == indiceCorrecto;
}

/// Triplas curadas (valorOrigen, unidadOrigen, unidadDestino) que dan
/// resultado entero. Sesgadas a las conversiones más comunes en
/// primaria: m↔cm, m↔km, km↔m, m↔mm.
const _conversionesFaciles = <(int, UnidadLongitud, UnidadLongitud)>[
  (5, UnidadLongitud.m, UnidadLongitud.cm),    // 500
  (3, UnidadLongitud.km, UnidadLongitud.m),    // 3000
  (4, UnidadLongitud.m, UnidadLongitud.mm),    // 4000
  (2, UnidadLongitud.m, UnidadLongitud.cm),    // 200
  (1, UnidadLongitud.km, UnidadLongitud.m),    // 1000
  (6, UnidadLongitud.m, UnidadLongitud.cm),    // 600
  (8, UnidadLongitud.m, UnidadLongitud.dm),    // 80
  (7, UnidadLongitud.km, UnidadLongitud.hm),   // 70
];
const _conversionesMedias = <(int, UnidadLongitud, UnidadLongitud)>[
  (250, UnidadLongitud.cm, UnidadLongitud.dm),   // 25
  (300, UnidadLongitud.cm, UnidadLongitud.m),    // 3
  (500, UnidadLongitud.m, UnidadLongitud.km),    // ÷ no entero — descartar
  (4000, UnidadLongitud.m, UnidadLongitud.km),   // 4
  (250, UnidadLongitud.dm, UnidadLongitud.m),    // 25
  (12, UnidadLongitud.m, UnidadLongitud.cm),     // 1200
];

class GeneradorLongitud {
  final math.Random _azar;

  GeneradorLongitud({int? semilla}) : _azar = math.Random(semilla);

  ProblemaLongitud generar({int dificultad = 1}) {
    final pool = <(int, UnidadLongitud, UnidadLongitud)>[
      ..._conversionesFaciles,
      if (dificultad >= 2)
        ..._conversionesMedias.where((c) {
          final delta = c.$3.posicion - c.$2.posicion;
          // Entero solo si el factor multiplica o si valor divide
          // exactamente entre la potencia de 10.
          if (delta >= 0) return true;
          final divisor = math.pow(10, -delta).toInt();
          return c.$1 % divisor == 0;
        }),
    ];
    final (v, o, d) = pool[_azar.nextInt(pool.length)];
    return _construir(v, o, d);
  }

  ProblemaLongitud generarDesdeTerminos({
    required int valorOrigen,
    required UnidadLongitud unidadOrigen,
    required UnidadLongitud unidadDestino,
  }) =>
      _construir(valorOrigen, unidadOrigen, unidadDestino);

  ProblemaLongitud _construir(
    int valor,
    UnidadLongitud origen,
    UnidadLongitud destino,
  ) {
    final delta = destino.posicion - origen.posicion;
    final factor = math.pow(10, delta.abs()).toInt();
    final correcto = delta >= 0 ? valor * factor : valor ~/ factor;

    final propuestos = <int>[correcto];
    void anyadirSiNuevo(int v) {
      if (v <= 0) return;
      if (!propuestos.contains(v)) propuestos.add(v);
    }

    // 1. Off-by-orden-de-magnitud: el niño aplica un factor menor
    //    (×10 cuando era ×100, etc.).
    if (delta.abs() >= 2) {
      final factorErr = math.pow(10, delta.abs() - 1).toInt();
      anyadirSiNuevo(delta >= 0 ? valor * factorErr : valor ~/ factorErr);
    }
    // 2. Dirección invertida (multiplica cuando había que dividir y
    //    viceversa). Solo si da entero.
    if (delta.abs() >= 1) {
      if (delta >= 0) {
        if (valor % factor == 0) {
          anyadirSiNuevo(valor ~/ factor);
        }
      } else {
        anyadirSiNuevo(valor * factor);
      }
    }
    // 3. Valor original sin convertir.
    anyadirSiNuevo(valor);
    // 4. Off-by-orden-de-magnitud al alza (un cero más).
    if (delta.abs() >= 1) {
      final factorMas = math.pow(10, delta.abs() + 1).toInt();
      anyadirSiNuevo(delta >= 0 ? valor * factorMas : valor ~/ factorMas);
    }

    var paso = 1;
    while (propuestos.length < 4) {
      anyadirSiNuevo(correcto + paso);
      if (propuestos.length < 4) anyadirSiNuevo(correcto - paso);
      paso++;
      if (paso > 6) break;
    }

    final cuatro = propuestos.take(4).toList()..shuffle(_azar);
    final indice = cuatro.indexOf(correcto);
    return ProblemaLongitud(
      valorOrigen: valor,
      unidadOrigen: origen,
      unidadDestino: destino,
      candidatos: cuatro,
      indiceCorrecto: indice,
    );
  }
}
