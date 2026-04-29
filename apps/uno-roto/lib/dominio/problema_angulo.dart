import 'dart:math' as math;

/// Tipos de ángulo que el MVP clasifica.
enum TipoAngulo { agudo, recto, obtuso, llano, completo }

extension EtiquetaAngulo on TipoAngulo {
  String get etiqueta {
    switch (this) {
      case TipoAngulo.agudo:
        return 'agudo';
      case TipoAngulo.recto:
        return 'recto';
      case TipoAngulo.obtuso:
        return 'obtuso';
      case TipoAngulo.llano:
        return 'llano';
      case TipoAngulo.completo:
        return 'completo';
    }
  }
}

TipoAngulo clasificarAngulo(int grados) {
  if (grados == 360) return TipoAngulo.completo;
  if (grados == 180) return TipoAngulo.llano;
  if (grados == 90) return TipoAngulo.recto;
  if (grados < 90) return TipoAngulo.agudo;
  return TipoAngulo.obtuso;
}

/// Problema MED.04: el niño ve "65°" y elige entre cuatro etiquetas
/// candidatas (agudo / recto / obtuso / llano). Mecánica de
/// reconocimiento — no requiere cálculo, solo memoria.
class ProblemaAngulo {
  final int grados;
  final List<TipoAngulo> candidatos;
  final int indiceCorrecto;

  const ProblemaAngulo({
    required this.grados,
    required this.candidatos,
    required this.indiceCorrecto,
  });

  TipoAngulo get respuesta => candidatos[indiceCorrecto];

  bool esCorrecta(int indiceElegido) => indiceElegido == indiceCorrecto;
}

/// Pool curado de grados, sesgado a los casos pedagógicos clave:
/// los exactos (90, 180, 360) que se confunden y los cercanos a la
/// frontera (89, 91, 179, 181) que ponen a prueba la regla estricta.
const _gradosCurados = <int>[
  // Agudos típicos.
  30, 45, 60, 75, 89,
  // Recto exacto y vecinos.
  90,
  // Obtusos típicos.
  91, 100, 120, 135, 150, 179,
  // Llano y vecino.
  180,
  // Completo.
  360,
];

class GeneradorAngulo {
  final math.Random _azar;

  GeneradorAngulo({int? semilla}) : _azar = math.Random(semilla);

  ProblemaAngulo generar({int dificultad = 1}) {
    // Dificultad 1: descartar los casos "completo" (360) y los
    // exactos vecinos a la frontera (89, 91, 179) — sobran tras tener
    // base. Dificultad ≥ 2: pool completo.
    final pool = dificultad >= 2
        ? _gradosCurados
        : _gradosCurados.where((g) {
            return g != 89 && g != 91 && g != 179 && g != 360;
          }).toList();
    final grados = pool[_azar.nextInt(pool.length)];
    return _construir(grados);
  }

  ProblemaAngulo generarDesdeGrados(int grados) => _construir(grados);

  ProblemaAngulo _construir(int grados) {
    final correcto = clasificarAngulo(grados);
    // Las cuatro etiquetas son siempre las mismas — el puzzle es
    // identificar cuál corresponde. No hace falta distractor "extra":
    // el conjunto cerrado ya pone a prueba la regla.
    final candidatos = <TipoAngulo>[
      TipoAngulo.agudo,
      TipoAngulo.recto,
      TipoAngulo.obtuso,
      TipoAngulo.llano,
    ];
    // Si el correcto es "completo" (no está en el set de 4), lo
    // sustituimos por el llano para mantener cuatro opciones reales.
    // En la práctica el generador en dificultad 1 evita 360.
    if (correcto == TipoAngulo.completo) {
      candidatos[3] = TipoAngulo.completo;
    }
    candidatos.shuffle(_azar);
    final indice = candidatos.indexOf(correcto);
    return ProblemaAngulo(
      grados: grados,
      candidatos: candidatos,
      indiceCorrecto: indice,
    );
  }
}
