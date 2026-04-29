import 'dart:math' as math;

/// Una porción del gráfico circular — etiqueta + porcentaje.
class _Porcion {
  final String etiqueta;
  final int porcentaje;
  const _Porcion(this.etiqueta, this.porcentaje);
}

class _CasoPie {
  final List<_Porcion> porciones;
  const _CasoPie(this.porciones);
}

/// Casos curados: la suma de los porcentajes es siempre 100, y los
/// valores son típicos de gráficos pedagógicos (25/50/75 o múltiplos
/// de 5/10).
const _casosCurados = <_CasoPie>[
  _CasoPie([
    _Porcion('rojo', 50),
    _Porcion('azul', 25),
    _Porcion('verde', 25),
  ]),
  _CasoPie([
    _Porcion('A', 40),
    _Porcion('B', 30),
    _Porcion('C', 20),
    _Porcion('D', 10),
  ]),
  _CasoPie([
    _Porcion('sí', 75),
    _Porcion('no', 25),
  ]),
  _CasoPie([
    _Porcion('uno', 60),
    _Porcion('dos', 30),
    _Porcion('tres', 10),
  ]),
  _CasoPie([
    _Porcion('A', 25),
    _Porcion('B', 25),
    _Porcion('C', 25),
    _Porcion('D', 25),
  ]),
  _CasoPie([
    _Porcion('rojo', 35),
    _Porcion('azul', 45),
    _Porcion('verde', 20),
  ]),
];

class ProblemaGraficoCircular {
  final List<String> etiquetas;
  final List<int> porcentajes;
  final int indicePorcionPreguntada;
  final List<int> candidatos;
  final int indiceCorrecto;

  const ProblemaGraficoCircular({
    required this.etiquetas,
    required this.porcentajes,
    required this.indicePorcionPreguntada,
    required this.candidatos,
    required this.indiceCorrecto,
  });

  int get respuesta => candidatos[indiceCorrecto];

  String preguntaTexto() =>
      '¿qué % representa "${etiquetas[indicePorcionPreguntada]}"?';

  bool esCorrecta(int indiceElegido) => indiceElegido == indiceCorrecto;
}

class GeneradorGraficoCircular {
  final math.Random _azar;

  GeneradorGraficoCircular({int? semilla}) : _azar = math.Random(semilla);

  static int get cantidadDeCasosCurados => _casosCurados.length;

  ProblemaGraficoCircular generar({int dificultad = 1}) {
    final indiceCaso = _azar.nextInt(_casosCurados.length);
    return generarPorIndice(indiceCaso);
  }

  ProblemaGraficoCircular generarPorIndice(int indiceCaso) {
    final caso = _casosCurados[indiceCaso.clamp(0, _casosCurados.length - 1)];
    return _construir(caso, indiceCaso);
  }

  ProblemaGraficoCircular _construir(_CasoPie caso, int seedSeleccion) {
    final etiquetas = caso.porciones.map((p) => p.etiqueta).toList();
    final porcentajes = caso.porciones.map((p) => p.porcentaje).toList();
    // La porción preguntada es estable por el seed para el dispatcher.
    final indicePorcion = seedSeleccion % porcentajes.length;
    final correcto = porcentajes[indicePorcion];

    final candidatos = <int>[correcto];
    bool yaEsta(int v) => candidatos.contains(v);
    void anyadir(int v) {
      if (v <= 0 || v > 100) return;
      if (!yaEsta(v)) candidatos.add(v);
    }

    // Distractor 1: el porcentaje de la porción contigua.
    anyadir(porcentajes[(indicePorcion + 1) % porcentajes.length]);
    // Distractor 2: el complementario (100 − correcto).
    anyadir(100 - correcto);
    // Distractor 3: el doble (si cabe en 100) o la mitad.
    anyadir(correcto * 2);
    anyadir(correcto ~/ 2);
    // Distractor 4: ±5.
    anyadir(correcto + 5);
    anyadir(correcto - 5);

    final cuatro = candidatos.take(4).toList()..shuffle(_azar);
    final indiceCorrecto = cuatro.indexOf(correcto);
    return ProblemaGraficoCircular(
      etiquetas: etiquetas,
      porcentajes: porcentajes,
      indicePorcionPreguntada: indicePorcion,
      candidatos: cuatro,
      indiceCorrecto: indiceCorrecto,
    );
  }
}
