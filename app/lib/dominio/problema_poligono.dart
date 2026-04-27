import 'dart:math' as math;

/// Tipos de polígono regular que el MVP clasifica por número de lados.
enum TipoPoligono {
  triangulo,
  cuadrado,
  pentagono,
  hexagono,
  heptagono,
  octagono,
}

extension EtiquetaPoligono on TipoPoligono {
  String get etiqueta {
    switch (this) {
      case TipoPoligono.triangulo:
        return 'triángulo';
      case TipoPoligono.cuadrado:
        return 'cuadrado';
      case TipoPoligono.pentagono:
        return 'pentágono';
      case TipoPoligono.hexagono:
        return 'hexágono';
      case TipoPoligono.heptagono:
        return 'heptágono';
      case TipoPoligono.octagono:
        return 'octágono';
    }
  }

  int get numeroDeLados {
    switch (this) {
      case TipoPoligono.triangulo:
        return 3;
      case TipoPoligono.cuadrado:
        return 4;
      case TipoPoligono.pentagono:
        return 5;
      case TipoPoligono.hexagono:
        return 6;
      case TipoPoligono.heptagono:
        return 7;
      case TipoPoligono.octagono:
        return 8;
    }
  }
}

TipoPoligono poligonoConLados(int n) {
  switch (n) {
    case 3:
      return TipoPoligono.triangulo;
    case 4:
      return TipoPoligono.cuadrado;
    case 5:
      return TipoPoligono.pentagono;
    case 6:
      return TipoPoligono.hexagono;
    case 7:
      return TipoPoligono.heptagono;
    case 8:
      return TipoPoligono.octagono;
    default:
      throw ArgumentError('número de lados fuera de rango: $n');
  }
}

/// Problema GEO.01: el niño ve un polígono regular dibujado y elige
/// su nombre entre cuatro candidatos. Mecánica visual de
/// reconocimiento — el primer puzzle del dominio GEO. La habilidad
/// es contar lados y aplicar el nombre griego correspondiente.
class ProblemaPoligono {
  final int numeroDeLados;
  final List<TipoPoligono> candidatos;
  final int indiceCorrecto;

  const ProblemaPoligono({
    required this.numeroDeLados,
    required this.candidatos,
    required this.indiceCorrecto,
  });

  TipoPoligono get respuesta => candidatos[indiceCorrecto];

  bool esCorrecta(int indiceElegido) => indiceElegido == indiceCorrecto;
}

class GeneradorPoligono {
  final math.Random _azar;

  GeneradorPoligono({int? semilla}) : _azar = math.Random(semilla);

  ProblemaPoligono generar({int dificultad = 1}) {
    // Dificultad 1: solo formas familiares (3, 4, 5, 6) —
    // triángulo/cuadrado/pentágono/hexágono. Dificultad ≥ 2 mete
    // heptágono y octágono, que son menos familiares.
    final lados = dificultad >= 2
        ? <int>[3, 4, 5, 6, 7, 8]
        : <int>[3, 4, 5, 6];
    final n = lados[_azar.nextInt(lados.length)];
    return generarDesdeLados(n);
  }

  ProblemaPoligono generarDesdeLados(int numeroDeLados) {
    final correcto = poligonoConLados(numeroDeLados);
    // Distractores: el polígono con un lado menos, uno más, y otro
    // alejado (dos lados de distancia). Si alguno cae fuera de rango,
    // se sustituye por el más cercano.
    final candidatos = <TipoPoligono>[correcto];
    void anyadirSiEsValido(int n) {
      if (n < 3 || n > 8) return;
      final candidato = poligonoConLados(n);
      if (!candidatos.contains(candidato)) candidatos.add(candidato);
    }

    anyadirSiEsValido(numeroDeLados - 1);
    anyadirSiEsValido(numeroDeLados + 1);
    anyadirSiEsValido(numeroDeLados + 2);
    anyadirSiEsValido(numeroDeLados - 2);
    final cuatro = candidatos.take(4).toList()..shuffle(_azar);
    final indice = cuatro.indexOf(correcto);
    return ProblemaPoligono(
      numeroDeLados: numeroDeLados,
      candidatos: cuatro,
      indiceCorrecto: indice,
    );
  }
}
