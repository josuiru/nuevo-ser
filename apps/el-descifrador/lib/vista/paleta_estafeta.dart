// Paleta visual provisional según doc 11 §1.1.
//
// Valores orientativos — el ilustrador asignado afinará. Aquí se
// centralizan para que la UI sea coherente y refactorable cuando
// lleguen los hex definitivos.

import 'package:flutter/material.dart';

class PaletaEstafeta {
  PaletaEstafeta._();

  /// Fondo principal: papel envejecido cálido.
  static const Color papel = Color(0xFFF4ECDD);

  /// Texto: casi-negro con tinte sepia.
  static const Color tinta = Color(0xFF1F1A14);

  /// Trazo a línea, márgenes, mobiliario.
  static const Color sepia = Color(0xFF7A5C3A);

  /// Sombra estructural (mesa, archivador).
  static const Color madera = Color(0xFF3D2C20);

  /// Papel ligeramente apagado para documentos ya resueltos.
  static const Color papelResuelto = Color(0xFFE6DECF);
}
