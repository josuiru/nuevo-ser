import 'dart:math' as math;

/// Modo del problema: el niño puede preguntarse el área (π·r²) o el
/// perímetro (2·π·r) del mismo círculo.
enum ModoCirculo { perimetro, area }

extension EtiquetaModoCirculo on ModoCirculo {
  String get etiqueta {
    switch (this) {
      case ModoCirculo.perimetro:
        return 'PERÍMETRO';
      case ModoCirculo.area:
        return 'ÁREA';
    }
  }

  String get formula {
    switch (this) {
      case ModoCirculo.perimetro:
        return 'P = 2 · π · r';
      case ModoCirculo.area:
        return 'A = π · r²';
    }
  }
}

/// Problema GEO.05: el niño ve un círculo con su radio etiquetado y
/// elige el área o el perímetro entre cuatro candidatos. Usa π ≈ 3,14.
/// Distractor estrella: confundir las dos fórmulas (área↔perímetro).
class ProblemaCirculo {
  final int radio;
  final ModoCirculo modo;
  final List<double> candidatos;
  final int indiceCorrecto;

  const ProblemaCirculo({
    required this.radio,
    required this.modo,
    required this.candidatos,
    required this.indiceCorrecto,
  });

  double get respuesta => candidatos[indiceCorrecto];

  bool esCorrecta(int indiceElegido) => indiceElegido == indiceCorrecto;
}

/// Aproximación de π usada para que los resultados curados den valores
/// limpios (típicamente con dos decimales).
const double piAproximado = 3.14;

double areaDelCirculo(int radio) =>
    _redondearADosCifras(piAproximado * radio * radio);

double perimetroDelCirculo(int radio) =>
    _redondearADosCifras(2 * piAproximado * radio);

double _redondearADosCifras(double valor) =>
    (valor * 100).round() / 100;

class GeneradorCirculo {
  final math.Random _azar;

  GeneradorCirculo({int? semilla}) : _azar = math.Random(semilla);

  /// Radios curados con π=3,14 que dan valores limpios. Excluimos r=2
  /// porque produce A = 12,56 = P numéricamente — el distractor
  /// estrella "confundir área con perímetro" colisiona con el correcto
  /// y se descarta, dejando el puzzle sin trampa pedagógica.
  static const List<int> radiosCurados = [3, 4, 5, 6, 8, 10];
  static int get cantidadDeRadiosCurados => radiosCurados.length;

  ProblemaCirculo generar({int dificultad = 1}) {
    final radio = radiosCurados[_azar.nextInt(radiosCurados.length)];
    final modo = _azar.nextBool() ? ModoCirculo.perimetro : ModoCirculo.area;
    return _construir(radio, modo);
  }

  ProblemaCirculo generarDesde(int radio, ModoCirculo modo) =>
      _construir(radio, modo);

  ProblemaCirculo _construir(int radio, ModoCirculo modo) {
    final correcto = modo == ModoCirculo.area
        ? areaDelCirculo(radio)
        : perimetroDelCirculo(radio);

    final candidatos = <double>[correcto];
    bool yaEsta(double valor) =>
        candidatos.any((c) => (c - valor).abs() < 1e-9);
    void anyadirSiNuevo(double valor) {
      if (valor <= 0) return;
      if (!yaEsta(valor)) candidatos.add(_redondearADosCifras(valor));
    }

    // Distractor estrella: confundir las fórmulas — el resultado de la
    // otra magnitud para el mismo radio.
    final otroResultado = modo == ModoCirculo.area
        ? perimetroDelCirculo(radio)
        : areaDelCirculo(radio);
    anyadirSiNuevo(otroResultado);
    // Distractor 2: usar diámetro en lugar de radio (2r en lugar de r).
    if (modo == ModoCirculo.area) {
      anyadirSiNuevo(piAproximado * (2 * radio) * (2 * radio));
    } else {
      anyadirSiNuevo(2 * piAproximado * (2 * radio));
    }
    // Distractor 3: olvidar π (multiplicar por 1 en su lugar).
    if (modo == ModoCirculo.area) {
      anyadirSiNuevo((radio * radio).toDouble());
    } else {
      anyadirSiNuevo((2 * radio).toDouble());
    }
    // Distractor 4: usar 3 en lugar de 3,14.
    if (modo == ModoCirculo.area) {
      anyadirSiNuevo((3 * radio * radio).toDouble());
    } else {
      anyadirSiNuevo((6 * radio).toDouble());
    }

    final cuatro = candidatos.take(4).toList()..shuffle(_azar);
    final indice = cuatro.indexWhere(
      (c) => (c - correcto).abs() < 1e-9,
    );
    return ProblemaCirculo(
      radio: radio,
      modo: modo,
      candidatos: cuatro,
      indiceCorrecto: indice,
    );
  }
}
