import 'package:flutter/material.dart';

import 'fragmento_en_tejado.dart';

/// Un distrito de la ciudad donde el niño caza Fragmentos. Biblia §3.3.
/// Cada distrito tiene un "aire matemático" propio que se refleja en la
/// mezcla de tipos de Fragmento que aparecen allí.
class Distrito {
  final String identificador;
  final String nombre;
  final String descripcionCorta;
  final Color colorAcento;

  /// Umbral de esquirlas totales para desbloquear este distrito. El
  /// primero (Tejados del Centro) es 0 — disponible desde el primer
  /// instante.
  final int esquirlasParaDesbloquear;

  /// Posición normalizada (0-1) del nodo del distrito sobre el mapa.
  final double xMapa;
  final double yMapa;

  /// Pesos relativos de aparición de cada familia de Fragmento en este
  /// distrito. Normalizado internamente. Si un tipo no está en el mapa,
  /// su peso es 0 — en ese distrito no sale.
  final Map<TipoFragmentoEnTejado, double> mezclaPuzzles;

  /// Una línea corta que suelta Sora (u otro) al entrar por primera vez.
  final String saludoPrimeraVisita;

  const Distrito({
    required this.identificador,
    required this.nombre,
    required this.descripcionCorta,
    required this.colorAcento,
    required this.esquirlasParaDesbloquear,
    required this.xMapa,
    required this.yMapa,
    required this.mezclaPuzzles,
    required this.saludoPrimeraVisita,
  });

  bool estaDesbloqueado(int esquirlasTotales) =>
      esquirlasTotales >= esquirlasParaDesbloquear;
}
