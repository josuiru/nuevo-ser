// Servicio que prepara las candidatas de lengua que se ofrecen al niño
// cuando llega una pieza nueva. Mecánica nuclear §3.1.
//
// El documento se presenta sin etiqueta. El niño hipotetiza qué lengua
// es entre 3-5 candidatas plausibles. La idea es que las distractoras
// vengan de la misma familia o ámbito geográfico, no aleatorias del
// repertorio. Pedagógicamente, distinguir gallego de portugués es lo
// interesante; gallego vs alemán es trivial.

import 'dart:math';

import 'lengua.dart';

class ServicioCandidatasLengua {
  ServicioCandidatasLengua({Random? aleatorio})
      : _aleatorio = aleatorio ?? Random();

  final Random _aleatorio;

  /// Devuelve la lista de candidatas que se muestran al niño. Siempre
  /// incluye `lenguaCorrecta`. Tamaño total entre 3 y 5 (configurable
  /// por `tamanoObjetivo`, clamp interno). El orden es aleatorio.
  List<Lengua> candidatasPara({
    required Lengua lenguaCorrecta,
    int tamanoObjetivo = 4,
  }) {
    final tamano = tamanoObjetivo.clamp(3, 5);
    final pool = <Lengua>{lenguaCorrecta};

    // Distractoras de la misma familia, priorizando peninsulares
    // cuando aplica.
    for (final candidata in _distractorasPreferidas(lenguaCorrecta)) {
      if (pool.length >= tamano) break;
      pool.add(candidata);
    }

    // Si todavía faltan, rellenar con lenguas de cualquier otra familia
    // distinta de la correcta — pero excluyendo árabe (caso especial,
    // ver biblia §2.10), salvo cuando la correcta sí es árabe.
    if (pool.length < tamano) {
      final relleno = Lengua.values.where((l) {
        if (pool.contains(l)) return false;
        if (l == Lengua.arabe && lenguaCorrecta != Lengua.arabe) return false;
        return true;
      }).toList();
      relleno.shuffle(_aleatorio);
      for (final candidata in relleno) {
        if (pool.length >= tamano) break;
        pool.add(candidata);
      }
    }

    final lista = pool.toList()..shuffle(_aleatorio);
    return lista;
  }

  /// Lista de distractoras preferidas para una lengua correcta, en
  /// orden de prioridad pedagógica.
  Iterable<Lengua> _distractorasPreferidas(Lengua correcta) sync* {
    // Las cuatro cooficiales se confunden entre sí — caso central
    // del juego.
    if (Lengua.cooficialesPeninsulares.contains(correcta)) {
      for (final hermana in Lengua.cooficialesPeninsulares) {
        if (hermana != correcta) yield hermana;
      }
      if (correcta == Lengua.gallego) yield Lengua.portugues;
      if (correcta == Lengua.castellano) {
        yield Lengua.castellanoArcaico;
        yield Lengua.castellanoAmericano;
      }
      return;
    }

    switch (correcta) {
      case Lengua.portugues:
        yield Lengua.gallego;
        yield Lengua.castellano;
        yield Lengua.catalan;
        yield Lengua.italiano;
        break;
      case Lengua.italiano:
        yield Lengua.castellano;
        yield Lengua.catalan;
        yield Lengua.portugues;
        yield Lengua.frances;
        break;
      case Lengua.frances:
        yield Lengua.italiano;
        yield Lengua.catalan;
        yield Lengua.castellano;
        yield Lengua.latin;
        break;
      case Lengua.ingles:
        yield Lengua.aleman;
        yield Lengua.frances;
        yield Lengua.castellano;
        break;
      case Lengua.aleman:
        yield Lengua.ingles;
        yield Lengua.frances;
        yield Lengua.latin;
        break;
      case Lengua.latin:
        yield Lengua.castellanoArcaico;
        yield Lengua.italiano;
        yield Lengua.castellano;
        break;
      case Lengua.castellanoArcaico:
        yield Lengua.castellano;
        yield Lengua.latin;
        yield Lengua.catalan;
        break;
      case Lengua.castellanoAmericano:
        yield Lengua.castellano;
        yield Lengua.portugues;
        break;
      case Lengua.arabe:
        yield Lengua.castellano;
        yield Lengua.aleman;
        yield Lengua.frances;
        break;
      // Las cooficiales ya están cubiertas arriba.
      case Lengua.castellano:
      case Lengua.euskara:
      case Lengua.catalan:
      case Lengua.gallego:
        break;
    }
  }
}
