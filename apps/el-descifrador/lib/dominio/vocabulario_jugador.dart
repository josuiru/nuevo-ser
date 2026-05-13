// Vocabulario del jugador: palabras marcadas por lengua.
//
// Las marcas verde/amarillo/rojo de la mecánica nuclear §3.2 quedan
// aquí. Una palabra se almacena por lengua principal del documento
// donde se marcó por primera vez. Si el niño cambia opinión más
// tarde, la marca se actualiza.
//
// Las hipótesis (texto libre asociado a marca amarilla, opcional)
// son del niño — el cuaderno respeta lo que escribe sin corregir
// (manifiesto Kids §9, biblia §2.4).

import 'lengua.dart';

/// Color de la marca que el niño aplica a una palabra.
enum MarcaColor {
  /// La conozco con seguridad.
  verde('verde'),

  /// Me suena, creo que significa X (hipótesis opcional).
  amarillo('amarillo'),

  /// No la conozco, no me suena.
  rojo('rojo');

  const MarcaColor(this.identificadorTecnico);

  final String identificadorTecnico;

  static MarcaColor desdeIdentificador(String identificador) {
    for (final marca in MarcaColor.values) {
      if (marca.identificadorTecnico == identificador) return marca;
    }
    throw ArgumentError('Marca de color desconocida: "$identificador"');
  }
}

/// Marca aplicada a una palabra concreta del corpus.
class MarcaPalabra {
  const MarcaPalabra({required this.color, this.hipotesis});

  final MarcaColor color;

  /// Hipótesis libre del niño. Típicamente asociada a marca amarilla
  /// ("creo que significa avergonzada"). Opcional en cualquier color.
  /// El cuaderno no la corrige aunque sea errónea.
  final String? hipotesis;

  Map<String, dynamic> serializar() {
    return {
      'color': color.identificadorTecnico,
      if (hipotesis != null && hipotesis!.isNotEmpty) 'hipotesis': hipotesis,
    };
  }

  factory MarcaPalabra.deserializar(Map<String, dynamic> mapa) {
    return MarcaPalabra(
      color: MarcaColor.desdeIdentificador(mapa['color'] as String),
      hipotesis: mapa['hipotesis'] as String?,
    );
  }
}

/// Estado inmutable del vocabulario del jugador. Cada palabra es
/// normalizada (ver `normalizarPalabra`) antes de almacenarse.
class VocabularioJugador {
  VocabularioJugador._(this._palabrasPorLengua);

  factory VocabularioJugador.inicial() {
    return VocabularioJugador._(const {});
  }

  factory VocabularioJugador.desdeMapa(
    Map<Lengua, Map<String, MarcaPalabra>> mapa,
  ) {
    return VocabularioJugador._(
      Map<Lengua, Map<String, MarcaPalabra>>.unmodifiable({
        for (final entrada in mapa.entries)
          entrada.key: Map<String, MarcaPalabra>.unmodifiable(entrada.value),
      }),
    );
  }

  final Map<Lengua, Map<String, MarcaPalabra>> _palabrasPorLengua;

  /// Marca asociada a esta palabra en esta lengua, o null si no se
  /// ha marcado.
  MarcaPalabra? marcaDe(Lengua lengua, String palabra) {
    final normalizada = normalizarPalabra(palabra);
    if (normalizada.isEmpty) return null;
    return _palabrasPorLengua[lengua]?[normalizada];
  }

  /// Todas las palabras marcadas en una lengua, ordenadas alfabéticamente.
  List<MapEntry<String, MarcaPalabra>> palabrasEn(Lengua lengua) {
    final mapa = _palabrasPorLengua[lengua];
    if (mapa == null) return const [];
    return mapa.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
  }

  /// Conjunto de lenguas con al menos una palabra marcada.
  Set<Lengua> lenguasConPalabrasMarcadas() {
    return _palabrasPorLengua.entries
        .where((entrada) => entrada.value.isNotEmpty)
        .map((entrada) => entrada.key)
        .toSet();
  }

  /// Devuelve nueva instancia con la marca actualizada para esta
  /// palabra en esta lengua. Si la marca ya existía, la sustituye.
  VocabularioJugador conPalabraMarcada({
    required Lengua lengua,
    required String palabra,
    required MarcaPalabra marca,
  }) {
    final normalizada = normalizarPalabra(palabra);
    if (normalizada.isEmpty) return this;

    final nuevoMapa = Map<Lengua, Map<String, MarcaPalabra>>.from(
      _palabrasPorLengua,
    );
    final mapaLengua = Map<String, MarcaPalabra>.from(
      nuevoMapa[lengua] ?? const {},
    );
    mapaLengua[normalizada] = marca;
    nuevoMapa[lengua] = Map<String, MarcaPalabra>.unmodifiable(mapaLengua);

    return VocabularioJugador.desdeMapa(nuevoMapa);
  }

  /// Devuelve nueva instancia sin la marca de esta palabra (si existía).
  VocabularioJugador sinMarcaDe({
    required Lengua lengua,
    required String palabra,
  }) {
    final normalizada = normalizarPalabra(palabra);
    if (normalizada.isEmpty) return this;
    final mapaLengua = _palabrasPorLengua[lengua];
    if (mapaLengua == null || !mapaLengua.containsKey(normalizada)) {
      return this;
    }

    final nuevoMapa = Map<Lengua, Map<String, MarcaPalabra>>.from(
      _palabrasPorLengua,
    );
    final mapaActualizado = Map<String, MarcaPalabra>.from(mapaLengua)
      ..remove(normalizada);
    if (mapaActualizado.isEmpty) {
      nuevoMapa.remove(lengua);
    } else {
      nuevoMapa[lengua] = Map<String, MarcaPalabra>.unmodifiable(mapaActualizado);
    }
    return VocabularioJugador.desdeMapa(nuevoMapa);
  }

  /// Serializa a Map<String,Map<String,Map>> para persistencia JSON.
  Map<String, dynamic> serializar() {
    return {
      for (final entrada in _palabrasPorLengua.entries)
        entrada.key.codigoIso: {
          for (final palabra in entrada.value.entries)
            palabra.key: palabra.value.serializar(),
        },
    };
  }

  /// Deserializa desde Map. Tolera lenguas y marcas desconocidas
  /// (las ignora silenciosamente).
  factory VocabularioJugador.deserializar(Map<String, dynamic> mapa) {
    final resultado = <Lengua, Map<String, MarcaPalabra>>{};
    for (final entradaLengua in mapa.entries) {
      Lengua lengua;
      try {
        lengua = Lengua.desdeCodigo(entradaLengua.key);
      } on ArgumentError {
        continue; // lengua eliminada entre versiones
      }
      final mapaPalabras = entradaLengua.value;
      if (mapaPalabras is! Map<String, dynamic>) continue;
      final palabras = <String, MarcaPalabra>{};
      for (final entradaPalabra in mapaPalabras.entries) {
        final valor = entradaPalabra.value;
        if (valor is! Map<String, dynamic>) continue;
        try {
          palabras[entradaPalabra.key] = MarcaPalabra.deserializar(valor);
        } on ArgumentError {
          continue; // marca con color desconocido
        }
      }
      if (palabras.isNotEmpty) {
        resultado[lengua] = palabras;
      }
    }
    return VocabularioJugador.desdeMapa(resultado);
  }
}

/// Normaliza una palabra antes de almacenarla en el vocabulario.
///
/// - minúsculas (con conservación de tildes y eñe)
/// - sin puntuación al inicio o al final
/// - sin espacios alrededor
///
/// La normalización es ligera deliberadamente: queremos que "Caro,"
/// y "caro" sean la misma palabra, pero NO igualar "más" con "mas"
/// (las tildes son significativas en castellano).
String normalizarPalabra(String entrada) {
  final recortada = entrada.trim().toLowerCase();
  if (recortada.isEmpty) return '';
  const puntuacion = r'.,;:!?¿¡"' "'" r'()[]{}<>«»—–-…';
  var inicio = 0;
  var fin = recortada.length;
  while (inicio < fin && puntuacion.contains(recortada[inicio])) {
    inicio++;
  }
  while (fin > inicio && puntuacion.contains(recortada[fin - 1])) {
    fin--;
  }
  return recortada.substring(inicio, fin);
}
