import 'dart:math' as math;

/// Tipo de figura simple que GEO.07 puede mostrar.
enum FormaSimetrica {
  cuadrado,
  rectangulo,
  trianguloEquilatero,
  trianguloIsosceles,
  trianguloEscaleno,
  pentagonoRegular,
  hexagonoRegular,
  letraT,
  letraF,
  letraR,
  flechaDerecha,
  trapecioIsosceles,
}

extension EtiquetaForma on FormaSimetrica {
  String get etiqueta {
    switch (this) {
      case FormaSimetrica.cuadrado:
        return 'cuadrado';
      case FormaSimetrica.rectangulo:
        return 'rectángulo';
      case FormaSimetrica.trianguloEquilatero:
        return 'triángulo equilátero';
      case FormaSimetrica.trianguloIsosceles:
        return 'triángulo isósceles';
      case FormaSimetrica.trianguloEscaleno:
        return 'triángulo escaleno';
      case FormaSimetrica.pentagonoRegular:
        return 'pentágono regular';
      case FormaSimetrica.hexagonoRegular:
        return 'hexágono regular';
      case FormaSimetrica.letraT:
        return 'letra T';
      case FormaSimetrica.letraF:
        return 'letra F';
      case FormaSimetrica.letraR:
        return 'letra R';
      case FormaSimetrica.flechaDerecha:
        return 'flecha →';
      case FormaSimetrica.trapecioIsosceles:
        return 'trapecio isósceles';
    }
  }
}

/// Eje de simetría a evaluar: vertical (línea de arriba abajo) o
/// horizontal (línea de izquierda a derecha).
enum EjeSimetria { vertical, horizontal }

/// Devuelve true si la forma es simétrica respecto al eje propuesto.
/// Tabla curada — refleja la geometría real, no asunciones de
/// orientación.
bool tieneEjeDeSimetria(FormaSimetrica forma, EjeSimetria eje) {
  switch (forma) {
    case FormaSimetrica.cuadrado:
      return true; // 4 ejes (ambas direcciones).
    case FormaSimetrica.rectangulo:
      return true; // 2 ejes (vertical y horizontal centrales).
    case FormaSimetrica.trianguloEquilatero:
      return eje == EjeSimetria.vertical;
    case FormaSimetrica.trianguloIsosceles:
      return eje == EjeSimetria.vertical;
    case FormaSimetrica.trianguloEscaleno:
      return false;
    case FormaSimetrica.pentagonoRegular:
      return eje == EjeSimetria.vertical;
    case FormaSimetrica.hexagonoRegular:
      return true;
    case FormaSimetrica.letraT:
      return eje == EjeSimetria.vertical;
    case FormaSimetrica.letraF:
      return false;
    case FormaSimetrica.letraR:
      return false;
    case FormaSimetrica.flechaDerecha:
      return eje == EjeSimetria.horizontal;
    case FormaSimetrica.trapecioIsosceles:
      return eje == EjeSimetria.vertical;
  }
}

/// Problema GEO.07: el niño ve una figura con un eje (vertical u
/// horizontal) sobreimpreso, y decide si la figura es simétrica
/// respecto a ese eje (sí/no). Decisión binaria.
class ProblemaSimetria {
  final FormaSimetrica forma;
  final EjeSimetria eje;
  final bool respuesta;

  const ProblemaSimetria({
    required this.forma,
    required this.eje,
    required this.respuesta,
  });

  bool esCorrecta(bool eligio) => eligio == respuesta;
}

class GeneradorSimetria {
  final math.Random _azar;

  GeneradorSimetria({int? semilla}) : _azar = math.Random(semilla);

  /// Lista de formas — el índice del Fragmento la selecciona.
  static const List<FormaSimetrica> formasCuradas = FormaSimetrica.values;
  static int get cantidadDeFormas => formasCuradas.length;

  ProblemaSimetria generar({int dificultad = 1}) {
    // Dificultad 1: solo formas con simetría más obvia (cuadrado,
    // rectángulo, equilátero, T, escaleno, F).
    final pool = dificultad >= 2
        ? List.generate(formasCuradas.length, (i) => i)
        : <int>[
            FormaSimetrica.cuadrado.index,
            FormaSimetrica.rectangulo.index,
            FormaSimetrica.trianguloEquilatero.index,
            FormaSimetrica.trianguloEscaleno.index,
            FormaSimetrica.letraT.index,
            FormaSimetrica.letraF.index,
          ];
    final indiceForma = pool[_azar.nextInt(pool.length)];
    final eje = _azar.nextBool() ? EjeSimetria.vertical : EjeSimetria.horizontal;
    return _construir(formasCuradas[indiceForma], eje);
  }

  ProblemaSimetria generarDesde(FormaSimetrica forma, EjeSimetria eje) =>
      _construir(forma, eje);

  ProblemaSimetria _construir(FormaSimetrica forma, EjeSimetria eje) {
    return ProblemaSimetria(
      forma: forma,
      eje: eje,
      respuesta: tieneEjeDeSimetria(forma, eje),
    );
  }
}
