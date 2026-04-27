import 'dart:math' as math;

/// Las tres unidades de tiempo sexagesimal del MVP.
enum UnidadTiempo { hora, minuto, segundo }

extension SimboloTiempo on UnidadTiempo {
  String get simbolo {
    switch (this) {
      case UnidadTiempo.hora:
        return 'h';
      case UnidadTiempo.minuto:
        return 'min';
      case UnidadTiempo.segundo:
        return 's';
    }
  }
}

UnidadTiempo unidadTiempoDesdeSimbolo(String simbolo) {
  for (final unidad in UnidadTiempo.values) {
    if (unidad.simbolo == simbolo) return unidad;
  }
  throw ArgumentError('Símbolo de tiempo desconocido: $simbolo');
}

/// Modo del problema MED.03.
/// - [simple]: una sola unidad → otra (3 h → ? min).
/// - [compuesto]: "a h y b min → ? min" (la trampa de "2 h 30 = 230").
enum ModoTiempo { simple, compuesto }

/// Problema MED.03: el niño ve una conversión sexagesimal y elige el
/// resultado entre cuatro candidatos. Mecánica fundamental: el sistema
/// es base 60 (no base 10), así que "2 h 30 min" no es 230 sino 150.
class ProblemaTiempo {
  final ModoTiempo modo;

  /// Para [ModoTiempo.simple]: el valor de origen. Para
  /// [ModoTiempo.compuesto]: la parte mayor (las horas en "2 h y 30 min").
  final int valorMayor;

  /// Solo en [ModoTiempo.compuesto]: la parte menor ("30" en "2 h y 30 min").
  /// 0 en modo simple.
  final int valorMenor;

  final UnidadTiempo unidadOrigen;
  final UnidadTiempo unidadDestino;

  final List<int> candidatos;
  final int indiceCorrecto;

  const ProblemaTiempo({
    required this.modo,
    required this.valorMayor,
    required this.valorMenor,
    required this.unidadOrigen,
    required this.unidadDestino,
    required this.candidatos,
    required this.indiceCorrecto,
  });

  int get resultado => candidatos[indiceCorrecto];

  bool esCorrecta(int indiceElegido) => indiceElegido == indiceCorrecto;
}

/// Conversiones simples curadas.
const _conversionesSimples =
    <(int, UnidadTiempo, UnidadTiempo)>[
  (3, UnidadTiempo.hora, UnidadTiempo.minuto),     // 180
  (2, UnidadTiempo.hora, UnidadTiempo.minuto),     // 120
  (5, UnidadTiempo.minuto, UnidadTiempo.segundo),  // 300
  (4, UnidadTiempo.minuto, UnidadTiempo.segundo),  // 240
  (180, UnidadTiempo.minuto, UnidadTiempo.hora),   // 3
  (120, UnidadTiempo.minuto, UnidadTiempo.hora),   // 2
  (300, UnidadTiempo.segundo, UnidadTiempo.minuto),// 5
  (180, UnidadTiempo.segundo, UnidadTiempo.minuto),// 3
];

/// Compuestos: (horas, minutos) → minutos. Casos curados a la trampa
/// "2 h 30 = 230" y similares.
const _compuestosHMaMin = <(int, int)>[
  (2, 30),    // 150
  (1, 45),    // 105
  (3, 15),    // 195
  (2, 45),    // 165
  (1, 30),    // 90
  (3, 30),    // 210
  (4, 15),    // 255
];

class GeneradorTiempo {
  final math.Random _azar;

  GeneradorTiempo({int? semilla}) : _azar = math.Random(semilla);

  ProblemaTiempo generar({int dificultad = 1}) {
    // Dificultad 1: solo simples. Dificultad ≥2: introducimos compuestos
    // (la trampa pedagógica).
    final usarCompuesto = dificultad >= 2 && _azar.nextDouble() < 0.5;
    if (usarCompuesto) {
      final (h, m) = _compuestosHMaMin[
          _azar.nextInt(_compuestosHMaMin.length)];
      return _construirCompuesto(h, m);
    }
    final (v, o, d) =
        _conversionesSimples[_azar.nextInt(_conversionesSimples.length)];
    return _construirSimple(v, o, d);
  }

  ProblemaTiempo generarSimpleDesdeTerminos({
    required int valor,
    required UnidadTiempo origen,
    required UnidadTiempo destino,
  }) =>
      _construirSimple(valor, origen, destino);

  ProblemaTiempo generarCompuestoDesdeTerminos({
    required int horas,
    required int minutos,
  }) =>
      _construirCompuesto(horas, minutos);

  int _factor(UnidadTiempo origen, UnidadTiempo destino) {
    final niveles = [
      UnidadTiempo.hora,
      UnidadTiempo.minuto,
      UnidadTiempo.segundo,
    ];
    final dif = niveles.indexOf(destino) - niveles.indexOf(origen);
    return dif >= 0
        ? math.pow(60, dif).toInt()
        : -math.pow(60, -dif).toInt();
  }

  ProblemaTiempo _construirSimple(
    int valor,
    UnidadTiempo origen,
    UnidadTiempo destino,
  ) {
    final factor = _factor(origen, destino);
    final correcto =
        factor > 0 ? valor * factor : valor ~/ (-factor);

    final propuestos = <int>[correcto];
    void anyadirSiNuevo(int v) {
      if (v <= 0) return;
      if (!propuestos.contains(v)) propuestos.add(v);
    }

    // 1. Trampa "base 10": multiplicar/dividir por 100 en lugar de 60.
    if (factor > 0) {
      anyadirSiNuevo(valor * 100);
    } else {
      anyadirSiNuevo(valor ~/ 100);
    }
    // 2. Trampa "factor 10": confundir 60 con 10.
    if (factor > 0) {
      anyadirSiNuevo(valor * 10);
    } else {
      anyadirSiNuevo(valor ~/ 10);
    }
    // 3. Valor sin convertir.
    anyadirSiNuevo(valor);

    var paso = 5;
    while (propuestos.length < 4) {
      anyadirSiNuevo(correcto + paso);
      if (propuestos.length < 4) anyadirSiNuevo(correcto - paso);
      paso += 5;
      if (paso > 60) break;
    }

    final cuatro = propuestos.take(4).toList()..shuffle(_azar);
    final indice = cuatro.indexOf(correcto);
    return ProblemaTiempo(
      modo: ModoTiempo.simple,
      valorMayor: valor,
      valorMenor: 0,
      unidadOrigen: origen,
      unidadDestino: destino,
      candidatos: cuatro,
      indiceCorrecto: indice,
    );
  }

  ProblemaTiempo _construirCompuesto(int horas, int minutos) {
    final correcto = horas * 60 + minutos;

    final propuestos = <int>[correcto];
    void anyadirSiNuevo(int v) {
      if (v <= 0) return;
      if (!propuestos.contains(v)) propuestos.add(v);
    }

    // 1. La trampa estrella: leer "2 h 30" como "230".
    anyadirSiNuevo(int.parse('$horas$minutos'));
    // 2. Trampa: pasar las horas a min pero olvidar sumar.
    anyadirSiNuevo(horas * 60);
    // 3. Trampa: tratar las horas como minutos (h * 100 + min).
    anyadirSiNuevo(horas * 100 + minutos);
    // 4. Solo los minutos sueltos.
    anyadirSiNuevo(minutos);

    var paso = 5;
    while (propuestos.length < 4) {
      anyadirSiNuevo(correcto + paso);
      if (propuestos.length < 4) anyadirSiNuevo(correcto - paso);
      paso += 5;
      if (paso > 60) break;
    }

    final cuatro = propuestos.take(4).toList()..shuffle(_azar);
    final indice = cuatro.indexOf(correcto);
    return ProblemaTiempo(
      modo: ModoTiempo.compuesto,
      valorMayor: horas,
      valorMenor: minutos,
      unidadOrigen: UnidadTiempo.hora,
      unidadDestino: UnidadTiempo.minuto,
      candidatos: cuatro,
      indiceCorrecto: indice,
    );
  }
}
