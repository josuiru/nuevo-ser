import 'dart:math' as math;

/// Modos de pregunta para EST.01: el niño puede leer una barra
/// concreta o calcular el total.
enum ModoGraficoBarras { valorDeBarra, total }

/// Una barra del gráfico — etiqueta + valor.
class _Barra {
  final String etiqueta;
  final int valor;
  const _Barra(this.etiqueta, this.valor);
}

/// Caso curado: una serie corta de barras y, opcionalmente, qué barra
/// se pregunta cuando el modo es valorDeBarra.
class _CasoGrafico {
  final List<_Barra> barras;
  const _CasoGrafico(this.barras);
}

const _casosCurados = <_CasoGrafico>[
  _CasoGrafico([
    _Barra('lun', 5),
    _Barra('mar', 3),
    _Barra('mié', 7),
    _Barra('jue', 4),
  ]),
  _CasoGrafico([
    _Barra('A', 8),
    _Barra('B', 5),
    _Barra('C', 6),
  ]),
  _CasoGrafico([
    _Barra('rojo', 4),
    _Barra('azul', 6),
    _Barra('verde', 2),
    _Barra('amar', 3),
  ]),
  _CasoGrafico([
    _Barra('1', 10),
    _Barra('2', 7),
    _Barra('3', 9),
    _Barra('4', 4),
  ]),
  _CasoGrafico([
    _Barra('ene', 12),
    _Barra('feb', 8),
    _Barra('mar', 5),
  ]),
  _CasoGrafico([
    _Barra('X', 6),
    _Barra('Y', 9),
    _Barra('Z', 3),
    _Barra('W', 5),
  ]),
];

class ProblemaGraficoBarras {
  final List<String> etiquetas;
  final List<int> valores;
  final ModoGraficoBarras modo;
  final int indiceBarraPreguntada;
  final List<int> candidatos;
  final int indiceCorrecto;

  const ProblemaGraficoBarras({
    required this.etiquetas,
    required this.valores,
    required this.modo,
    required this.indiceBarraPreguntada,
    required this.candidatos,
    required this.indiceCorrecto,
  });

  int get respuesta => candidatos[indiceCorrecto];

  /// La pregunta visible al niño (texto). Para modo valorDeBarra
  /// menciona la etiqueta concreta.
  String preguntaTexto() {
    switch (modo) {
      case ModoGraficoBarras.valorDeBarra:
        return '¿cuántos en "${etiquetas[indiceBarraPreguntada]}"?';
      case ModoGraficoBarras.total:
        return '¿cuál es el total?';
    }
  }

  bool esCorrecta(int indiceElegido) => indiceElegido == indiceCorrecto;
}

class GeneradorGraficoBarras {
  final math.Random _azar;

  GeneradorGraficoBarras({int? semilla}) : _azar = math.Random(semilla);

  static int get cantidadDeCasosCurados => _casosCurados.length;

  ProblemaGraficoBarras generar({int dificultad = 1}) {
    final indiceCaso = _azar.nextInt(_casosCurados.length);
    // Dificultad 1: solo lectura directa de barra. Dificultad 2+:
    // alterna con el modo "total" que exige sumar.
    final modo = dificultad >= 2 && _azar.nextBool()
        ? ModoGraficoBarras.total
        : ModoGraficoBarras.valorDeBarra;
    return _construir(_casosCurados[indiceCaso], modo, indiceCaso);
  }

  ProblemaGraficoBarras generarPorIndiceYModo(
    int indiceCaso,
    ModoGraficoBarras modo,
  ) {
    return _construir(
      _casosCurados[indiceCaso.clamp(0, _casosCurados.length - 1)],
      modo,
      indiceCaso,
    );
  }

  ProblemaGraficoBarras _construir(
    _CasoGrafico caso,
    ModoGraficoBarras modo,
    int seedSeleccion,
  ) {
    final etiquetas = caso.barras.map((b) => b.etiqueta).toList();
    final valores = caso.barras.map((b) => b.valor).toList();
    final total = valores.fold<int>(0, (a, b) => a + b);
    // La barra preguntada es estable según el caso (índice seedSeleccion
    // mod cantidad), para que el dispatcher reconstruya el mismo
    // problema desde el Fragmento.
    final indiceBarra = seedSeleccion % valores.length;
    final correcto = modo == ModoGraficoBarras.total
        ? total
        : valores[indiceBarra];

    final candidatos = <int>[correcto];
    bool yaEsta(int v) => candidatos.contains(v);
    void anyadir(int v) {
      if (v <= 0) return;
      if (!yaEsta(v)) candidatos.add(v);
    }

    if (modo == ModoGraficoBarras.valorDeBarra) {
      // Distractor 1: el valor de otra barra (la siguiente).
      anyadir(valores[(indiceBarra + 1) % valores.length]);
      // Distractor 2: el total (confundir lectura con suma).
      anyadir(total);
      // Distractor 3: ±1 (off-by-one al leer la altura).
      anyadir(correcto + 1);
      anyadir(correcto - 1);
    } else {
      // Distractor 1: olvidar el último valor.
      anyadir(total - valores.last);
      // Distractor 2: el valor más alto (confundir total con máximo).
      anyadir(valores.reduce((a, b) => a > b ? a : b));
      // Distractor 3: contar dos veces el primer valor. Plausible y
      // — clave pedagógicamente — **mayor** que el total. Sin este
      // distractor el correcto era siempre el número mayor de la
      // cuadrícula y el niño podía resolver el total con la
      // heurística trivial "siempre el más grande".
      anyadir(total + valores.first);
      // Distractor 4: total − 1.
      anyadir(total - 1);
    }

    final cuatro = candidatos.take(4).toList()..shuffle(_azar);
    final indiceCorrecto = cuatro.indexOf(correcto);
    return ProblemaGraficoBarras(
      etiquetas: etiquetas,
      valores: valores,
      modo: modo,
      indiceBarraPreguntada: indiceBarra,
      candidatos: cuatro,
      indiceCorrecto: indiceCorrecto,
    );
  }
}
