import 'dart:math' as math;

/// Una forma canónica de "lectura" de decimal: el texto en castellano
/// y la etiqueta numérica con coma. Las dos cadenas se mantienen como
/// texto puro — las comparaciones se hacen sobre la etiqueta.
class FormaLecturaDecimal {
  final String texto;
  final String etiquetaCorrecta;
  final List<String> distractoresEtiqueta;

  const FormaLecturaDecimal({
    required this.texto,
    required this.etiquetaCorrecta,
    required this.distractoresEtiqueta,
  });
}

/// Problema DEC.01: el niño ve un decimal escrito en palabras y
/// elige la etiqueta numérica equivalente entre cuatro candidatos.
class ProblemaLecturaDecimal {
  final String texto;
  final List<String> candidatos;
  final int indiceCorrecto;

  const ProblemaLecturaDecimal({
    required this.texto,
    required this.candidatos,
    required this.indiceCorrecto,
  });

  String get etiquetaCorrecta => candidatos[indiceCorrecto];
}

/// Genera problemas DEC.01 a partir de una lista curada de formas. Los
/// distractores son los que el niño realmente confunde — desplazar la
/// coma a la izquierda o a la derecha (0,3 vs 0,03 vs 3,0). No
/// generamos algorítmicamente porque el "valor de posición" tiene
/// muchas trampas idiomáticas mejor tratadas a mano.
class GeneradorLecturaDecimal {
  final math.Random _azar;

  GeneradorLecturaDecimal({int? semilla}) : _azar = math.Random(semilla);

  static const _formas = <FormaLecturaDecimal>[
    FormaLecturaDecimal(
      texto: 'tres décimas',
      etiquetaCorrecta: '0,3',
      distractoresEtiqueta: ['0,03', '3,0', '0,003'],
    ),
    FormaLecturaDecimal(
      texto: 'siete décimas',
      etiquetaCorrecta: '0,7',
      distractoresEtiqueta: ['0,07', '7,0', '0,007'],
    ),
    FormaLecturaDecimal(
      texto: 'veinticinco centésimas',
      etiquetaCorrecta: '0,25',
      distractoresEtiqueta: ['0,025', '2,5', '0,0025'],
    ),
    FormaLecturaDecimal(
      texto: 'cuarenta centésimas',
      etiquetaCorrecta: '0,4',
      distractoresEtiqueta: ['0,04', '4,0', '0,40 décimas'],
    ),
    FormaLecturaDecimal(
      texto: 'siete centésimas',
      etiquetaCorrecta: '0,07',
      distractoresEtiqueta: ['0,7', '0,007', '7,0'],
    ),
    FormaLecturaDecimal(
      texto: 'cinco milésimas',
      etiquetaCorrecta: '0,005',
      distractoresEtiqueta: ['0,5', '0,05', '5,0'],
    ),
    FormaLecturaDecimal(
      texto: 'doscientas treinta milésimas',
      etiquetaCorrecta: '0,23',
      distractoresEtiqueta: ['0,230', '0,023', '2,3'],
    ),
    FormaLecturaDecimal(
      texto: 'una unidad y dos décimas',
      etiquetaCorrecta: '1,2',
      distractoresEtiqueta: ['0,12', '12,0', '1,02'],
    ),
    FormaLecturaDecimal(
      texto: 'dos unidades y cinco centésimas',
      etiquetaCorrecta: '2,05',
      distractoresEtiqueta: ['2,5', '2,005', '0,25'],
    ),
    FormaLecturaDecimal(
      texto: 'tres unidades y siete décimas',
      etiquetaCorrecta: '3,7',
      distractoresEtiqueta: ['0,37', '37,0', '3,07'],
    ),
  ];

  /// Construye un problema a partir del [texto] dado — usado cuando el
  /// Fragmento ya se ha mostrado en el tejado y queremos garantizar
  /// la misma forma. Si no encontramos el texto, generamos uno nuevo.
  ProblemaLecturaDecimal generarDesdeTexto(String texto) {
    final encontrada = _formas.firstWhere(
      (f) => f.texto == texto,
      orElse: () => _formas[_azar.nextInt(_formas.length)],
    );
    return _construirDesde(encontrada);
  }

  ProblemaLecturaDecimal generar({int dificultad = 1}) {
    // Filtramos por longitud aproximada del texto: en dificultad baja
    // dejamos las formas más simples (sin "unidades y …"); subiendo
    // entran las mixtas y las milésimas.
    Iterable<FormaLecturaDecimal> reservaPosibles() {
      if (dificultad >= 3) return _formas;
      if (dificultad >= 2) {
        return _formas.where((f) => !f.texto.contains('milésimas'));
      }
      return _formas.where((f) =>
          !f.texto.contains('milésimas') &&
          !f.texto.contains('unidad'));
    }

    final candidatasPosibles = reservaPosibles().toList();
    final eleccion =
        candidatasPosibles[_azar.nextInt(candidatasPosibles.length)];
    return _construirDesde(eleccion);
  }

  ProblemaLecturaDecimal _construirDesde(FormaLecturaDecimal forma) {
    final candidatos = <String>[
      forma.etiquetaCorrecta,
      ...forma.distractoresEtiqueta,
    ];
    candidatos.shuffle(_azar);
    final indice = candidatos.indexOf(forma.etiquetaCorrecta);
    return ProblemaLecturaDecimal(
      texto: forma.texto,
      candidatos: candidatos,
      indiceCorrecto: indice,
    );
  }
}
