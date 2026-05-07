import 'package:flutter/material.dart';

import '../../nucleo/paleta.dart';

/// Cuadro destacado donde aparece la fórmula/etiqueta del puzzle
/// (potencia, raíz, ecuación, etc). Estilo neón violeta+azul como en
/// las pantallas existentes del catálogo.
class CuadroFormula extends StatelessWidget {
  final String etiqueta;
  final double tamanoFuente;

  const CuadroFormula({
    super.key,
    required this.etiqueta,
    this.tamanoFuente = 44,
  });

  @override
  Widget build(BuildContext contexto) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 22),
      decoration: BoxDecoration(
        color: PaletaNeon.violetaBase.withOpacity(0.4),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: PaletaNeon.azulNeon, width: 2),
        boxShadow: [
          BoxShadow(
            color: PaletaNeon.azulNeon.withOpacity(0.4),
            blurRadius: 22,
          ),
        ],
      ),
      child: Text(
        etiqueta,
        style: TextStyle(
          color: PaletaNeon.textoPrincipal,
          fontSize: tamanoFuente,
          fontWeight: FontWeight.w300,
          letterSpacing: 1.4,
        ),
      ),
    );
  }
}
