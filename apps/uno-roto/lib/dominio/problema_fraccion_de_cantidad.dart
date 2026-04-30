import 'dart:math' as math;

/// Problema FR.22: el niño ve "los 3/5 de 20 = ?" y elige el
/// resultado entre cuatro candidatos. Mecánica de cálculo directo:
/// resultado = numerador × cantidad / denominador.
class ProblemaFraccionDeCantidad {
  final int numerador;
  final int denominador;
  final int cantidad;
  final List<int> candidatos;
  final int indiceCorrecto;

  const ProblemaFraccionDeCantidad({
    required this.numerador,
    required this.denominador,
    required this.cantidad,
    required this.candidatos,
    required this.indiceCorrecto,
  });

  int get resultado => candidatos[indiceCorrecto];

  bool esCorrecta(int indiceElegido) => indiceElegido == indiceCorrecto;
}

/// Triplas (numerador, denominador, cantidad) curadas con resultado
/// entero garantizado. La cantidad es múltiplo del denominador.
const _triplasFaciles = <(int, int, int)>[
  (1, 2, 20),   // 10
  (1, 2, 14),   // 7
  (1, 4, 12),   // 3
  (1, 4, 20),   // 5
  (1, 3, 15),   // 5
  (1, 5, 25),   // 5
  (1, 5, 20),   // 4
  (1, 3, 12),   // 4
];
const _triplasMedias = <(int, int, int)>[
  (3, 5, 25),   // 15
  (3, 5, 20),   // 12
  (2, 3, 18),   // 12
  (3, 4, 16),   // 12
  (3, 4, 20),   // 15
  (2, 5, 30),   // 12
  (4, 5, 15),   // 12
  (2, 3, 24),   // 16
];

class GeneradorFraccionDeCantidad {
  final math.Random _azar;

  GeneradorFraccionDeCantidad({int? semilla}) : _azar = math.Random(semilla);

  ProblemaFraccionDeCantidad generar({int dificultad = 1}) {
    final pool = <(int, int, int)>[
      ..._triplasFaciles,
      if (dificultad >= 2) ..._triplasMedias,
    ];
    final (n, d, c) = pool[_azar.nextInt(pool.length)];
    return _construir(n, d, c);
  }

  ProblemaFraccionDeCantidad generarDesdeTerminos({
    required int numerador,
    required int denominador,
    required int cantidad,
  }) =>
      _construir(numerador, denominador, cantidad);

  ProblemaFraccionDeCantidad _construir(int n, int d, int c) {
    final correcto = (n * c) ~/ d;

    final propuestos = <int>[correcto];
    void anyadirSiNuevo(int valor) {
      if (valor > 0 && !propuestos.contains(valor)) {
        propuestos.add(valor);
      }
    }

    // 1. Solo dividir cantidad entre el denominador (ignora numerador).
    //    Distractor estrella en el caso n>1. Cuando n=1 colisiona
    //    con el correcto (porque correcto = 1·c/d = c/d), así que
    //    sustituimos por c × d (multiplicar en lugar de dividir,
    //    error opuesto típico del niño que no sabe qué operación
    //    aplica el numerador/denominador).
    final ignorarNumerador = c ~/ d;
    anyadirSiNuevo(ignorarNumerador == correcto ? c * d : ignorarNumerador);
    // 2. Producto sin dividir entre denominador (n × c) — error
    //    pedagógico clásico: aplicar la operación a medias.
    anyadirSiNuevo(n * c);
    // 3. Confundir con el numerador literal.
    anyadirSiNuevo(n);
    // 4. Confundir con la suma de los términos.
    anyadirSiNuevo(n + d + c);
    // 5. Cantidad − resultado (resta intuitiva). Con d=2 el complementario
    //    de la mitad es la otra mitad y coincide con el correcto;
    //    sustituimos por c + correcto (sumar en lugar de restar).
    final cantidadMenos = c - correcto;
    anyadirSiNuevo(cantidadMenos == correcto ? c + correcto : cantidadMenos);

    var paso = 1;
    while (propuestos.length < 4) {
      anyadirSiNuevo(correcto + paso);
      if (propuestos.length < 4) anyadirSiNuevo(correcto - paso);
      paso++;
      if (paso > 6) break;
    }

    final cuatro = propuestos.take(4).toList()..shuffle(_azar);
    final indice = cuatro.indexOf(correcto);
    return ProblemaFraccionDeCantidad(
      numerador: n,
      denominador: d,
      cantidad: c,
      candidatos: cuatro,
      indiceCorrecto: indice,
    );
  }
}
