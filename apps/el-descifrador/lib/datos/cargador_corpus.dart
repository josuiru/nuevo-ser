// Cargador del corpus de El Descifrador desde assets/corpus/piezas/.
//
// El corpus base viene empaquetado con la app (50-80 piezas validadas
// en v1.0, ~5-10 MB). A partir de v1.1 podrá ampliarse por temporadas
// descargables — esa parte vive en otro componente (no aquí).
//
// El cargador es tolerante a una pieza individual rota (la marca como
// excluida y logueamos), pero falla en bloque si el manifiesto general
// está mal o si más de la mitad de las piezas fallan — eso indica un
// problema sistémico que debe revisarse antes de que un niño se
// encuentre el juego con corpus vacío.

import 'dart:convert';

import 'package:flutter/services.dart';

import '../dominio/pieza_corpus.dart';

/// Resultado de un intento de carga del corpus.
class ResultadoCargaCorpus {
  const ResultadoCargaCorpus({
    required this.piezasCargadas,
    required this.idsConError,
    required this.erroresPorPieza,
  });

  /// Piezas cargadas con éxito.
  final List<PiezaCorpus> piezasCargadas;

  /// IDs de piezas (o paths si el ID no pudo extraerse) que fallaron.
  final List<String> idsConError;

  /// Detalle de cada error por pieza, para logging y depuración.
  final Map<String, String> erroresPorPieza;

  int get total => piezasCargadas.length + idsConError.length;
  int get aciertos => piezasCargadas.length;
  int get fallos => idsConError.length;

  bool get cargaSuficientementeSana =>
      total > 0 && aciertos >= total / 2;
}

/// Carga el corpus de El Descifrador.
///
/// El cargador se inyecta en construcción para permitir tests con
/// AssetBundle de prueba. Por defecto usa `rootBundle` de Flutter.
class CargadorCorpus {
  CargadorCorpus({AssetBundle? bundle}) : _bundle = bundle ?? rootBundle;

  final AssetBundle _bundle;

  /// Path del manifiesto del corpus dentro de los assets.
  /// El manifiesto lista los archivos JSON de piezas que vienen
  /// empaquetados — se mantiene a mano por consistencia con la
  /// validación editorial.
  static const String pathManifiesto = 'assets/corpus/manifiesto.json';

  /// Carga todas las piezas declaradas en el manifiesto.
  ///
  /// Lanza StateError si el manifiesto no se puede cargar — sin
  /// manifiesto no hay corpus, no hay juego.
  Future<ResultadoCargaCorpus> cargarTodo() async {
    final String textoManifiesto;
    try {
      textoManifiesto = await _bundle.loadString(pathManifiesto);
    } catch (excepcion) {
      throw StateError(
        'No se puede cargar manifiesto del corpus en $pathManifiesto: '
        '$excepcion',
      );
    }

    final List<dynamic> rutasPiezas;
    try {
      final manifiesto = json.decode(textoManifiesto) as Map<String, dynamic>;
      rutasPiezas = manifiesto['piezas'] as List<dynamic>;
    } catch (excepcion) {
      throw StateError(
        'Manifiesto del corpus mal formado: $excepcion',
      );
    }

    final piezasCargadas = <PiezaCorpus>[];
    final idsConError = <String>[];
    final erroresPorPieza = <String, String>{};

    for (final ruta in rutasPiezas) {
      final rutaPieza = ruta as String;
      try {
        final textoPieza = await _bundle.loadString(rutaPieza);
        final mapaPieza = json.decode(textoPieza) as Map<String, dynamic>;
        final pieza = PiezaCorpus.desdeMapa(mapaPieza);
        piezasCargadas.add(pieza);
      } catch (excepcion) {
        idsConError.add(rutaPieza);
        erroresPorPieza[rutaPieza] = excepcion.toString();
      }
    }

    return ResultadoCargaCorpus(
      piezasCargadas: piezasCargadas,
      idsConError: idsConError,
      erroresPorPieza: erroresPorPieza,
    );
  }

  /// Filtro: piezas validadas para producción (listas para servirse al
  /// niño). El resto son borradores que el motor de selección ignora.
  static List<PiezaCorpus> soloProduccion(List<PiezaCorpus> piezas) {
    return piezas.where((pieza) => pieza.listaParaProduccion).toList();
  }
}
