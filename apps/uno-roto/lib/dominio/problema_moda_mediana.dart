import 'dart:math' as math;

enum ModoEstadistico { moda, mediana }

extension EtiquetaModo on ModoEstadistico {
  String get etiqueta {
    switch (this) {
      case ModoEstadistico.moda:
        return 'moda';
      case ModoEstadistico.mediana:
        return 'mediana';
    }
  }
}

/// Problema EST.04: el niño ve un conjunto pequeño y elige la moda o
/// la mediana entre cuatro candidatos (según [modo]).
class ProblemaModaMediana {
  final ModoEstadistico modo;
  final List<int> datos;
  final List<int> candidatos;
  final int indiceCorrecto;

  const ProblemaModaMediana({
    required this.modo,
    required this.datos,
    required this.candidatos,
    required this.indiceCorrecto,
  });

  int get respuesta => candidatos[indiceCorrecto];

  bool esCorrecta(int indiceElegido) => indiceElegido == indiceCorrecto;
}

/// Devuelve la moda como `int` si hay un único valor más frecuente,
/// o `null` si todos aparecen con la misma frecuencia o hay empate
/// entre dos modas (no son conjuntos pedagógicamente válidos para la
/// mecánica del puzzle).
int? _calcularModa(List<int> datos) {
  final cuentas = <int, int>{};
  for (final v in datos) {
    cuentas[v] = (cuentas[v] ?? 0) + 1;
  }
  var mejor = datos.first;
  var mejorCuenta = 0;
  var hayEmpate = false;
  cuentas.forEach((valor, cuenta) {
    if (cuenta > mejorCuenta) {
      mejor = valor;
      mejorCuenta = cuenta;
      hayEmpate = false;
    } else if (cuenta == mejorCuenta && valor != mejor) {
      hayEmpate = true;
    }
  });
  if (hayEmpate || mejorCuenta <= 1) return null;
  return mejor;
}

/// Mediana redondeada a entero. Para longitud impar es el central.
/// Para longitud par es el promedio de los dos centrales — antes el
/// generador devolvía sólo `ordenados[length~/2]` (uno de los dos),
/// que es matemáticamente incorrecto.
int _calcularMediana(List<int> datos) {
  final ordenados = [...datos]..sort();
  final medio = ordenados.length ~/ 2;
  if (ordenados.length.isOdd) return ordenados[medio];
  return ((ordenados[medio - 1] + ordenados[medio]) / 2).round();
}

/// Conjuntos curados con moda clara (un único valor más frecuente).
const _conjuntosModa = <List<int>>[
  [3, 5, 5, 7, 8],         // moda 5
  [2, 4, 6, 6, 6, 9],      // moda 6
  [10, 10, 12, 14, 16],    // moda 10
  [4, 5, 7, 7, 7, 10, 12], // moda 7
  [1, 3, 3, 5, 7],         // moda 3
];

/// Conjuntos de longitud impar para mediana clara.
const _conjuntosMediana = <List<int>>[
  [3, 5, 7, 9, 11],     // mediana 7
  [2, 4, 6, 8, 10],     // mediana 6
  [1, 3, 5],            // mediana 3
  [10, 12, 14, 16, 18], // mediana 14
  [5, 7, 9, 11, 13],    // mediana 9
  [2, 4, 6, 7, 8, 10, 12], // mediana 7
];

class GeneradorModaMediana {
  final math.Random _azar;

  GeneradorModaMediana({int? semilla}) : _azar = math.Random(semilla);

  static int get cantidadModaCurada => _conjuntosModa.length;
  static int get cantidadMedianaCurada => _conjuntosMediana.length;

  ProblemaModaMediana generar({int dificultad = 1}) {
    final modo = _azar.nextBool()
        ? ModoEstadistico.moda
        : ModoEstadistico.mediana;
    final pool =
        modo == ModoEstadistico.moda ? _conjuntosModa : _conjuntosMediana;
    return _construir(modo, pool[_azar.nextInt(pool.length)]);
  }

  ProblemaModaMediana generarPorIndice(ModoEstadistico modo, int indice) {
    final pool =
        modo == ModoEstadistico.moda ? _conjuntosModa : _conjuntosMediana;
    return _construir(modo, pool[indice.clamp(0, pool.length - 1)]);
  }

  ProblemaModaMediana _construir(ModoEstadistico modo, List<int> datos) {
    final correcto = modo == ModoEstadistico.moda
        ? (_calcularModa(datos) ?? datos.first)
        : _calcularMediana(datos);
    // En modo mediana, los conjuntos curados están elegidos para no
    // tener moda — _calcularModa devuelve null y omitimos ese
    // distractor. En modo moda, la mediana siempre existe.
    final otroValor = modo == ModoEstadistico.moda
        ? _calcularMediana(datos)
        : _calcularModa(datos);

    final propuestos = <int>[correcto];
    void anyadirSiNuevo(int? v) {
      if (v == null || v <= 0) return;
      if (!propuestos.contains(v)) propuestos.add(v);
    }

    // 1. La otra estadística (moda↔mediana) — error de confundirlas.
    anyadirSiNuevo(otroValor);
    // 2. El mayor del conjunto.
    anyadirSiNuevo(datos.reduce(math.max));
    // 3. El menor del conjunto.
    anyadirSiNuevo(datos.reduce(math.min));

    var paso = 1;
    while (propuestos.length < 4) {
      anyadirSiNuevo(correcto + paso);
      if (propuestos.length < 4) anyadirSiNuevo(correcto - paso);
      paso++;
      if (paso > 6) break;
    }

    final cuatro = propuestos.take(4).toList()..shuffle(_azar);
    final indice = cuatro.indexOf(correcto);
    return ProblemaModaMediana(
      modo: modo,
      datos: datos,
      candidatos: cuatro,
      indiceCorrecto: indice,
    );
  }
}
