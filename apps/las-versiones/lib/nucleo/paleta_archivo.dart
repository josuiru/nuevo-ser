import 'package:flutter/material.dart';

/// Paleta provisional del Archivo — pendiente de cerrar contra el
/// doc 11 (guía visual) cuando esa fase se aborde.
///
/// Tonos sepia/papel envejecido como fondo, tinta como texto, ámbar
/// (cera de lacrar) como acento para llamadas a la acción. Es la
/// dirección estética coherente con el universo diegético del juego
/// — un Archivo antiguo donde la Cronista trabaja con manuscritos —
/// y deliberadamente distinta de la paleta neón violeta de Uno Roto:
/// los dos juegos son hermanos, no clones.
///
/// Cuando se materialice el doc 11 esta clase se reescribe. Mientras,
/// que un toque a un botón quede definido en alguna parte.
class PaletaArchivo {
  PaletaArchivo._();

  // Fondo — papel envejecido en tres profundidades.
  static const Color fondoProfundo = Color(0xFF1F1A14);
  static const Color fondoMedio = Color(0xFF2C261E);
  static const Color fondoPapel = Color(0xFFE8DDC9);

  // Tinta — para texto sobre papel claro.
  static const Color tintaNegra = Color(0xFF1A1612);
  static const Color tintaTenue = Color(0xFF6B6055);

  // Texto sobre fondo profundo (la pantalla de configuración inicial,
  // y cualquier pantalla diegéticamente nocturna).
  static const Color textoPrincipal = Color(0xFFE8DDC9);
  static const Color textoTenue = Color(0xFFA89B85);

  // Acento — cera de lacrar / sello del Archivo. Se reserva para
  // botones primarios y elementos de "rúbrica" de la Cronista.
  static const Color ambarLacre = Color(0xFFC8893A);
}
