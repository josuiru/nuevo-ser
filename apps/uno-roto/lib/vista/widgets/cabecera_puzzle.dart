import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../nucleo/paleta.dart';

/// Cabecera estándar de las pantallas de puzzle: botón "huir" a la
/// izquierda, título centrado en mayúsculas tenues, hueco simétrico a
/// la derecha. Compartida por las pantallas nuevas (Era 3) para
/// evitar replicar el mismo Row en cada una.
class CabeceraPuzzle extends StatelessWidget {
  final VoidCallback alHuir;
  final String titulo;

  const CabeceraPuzzle({
    super.key,
    required this.alHuir,
    required this.titulo,
  });

  @override
  Widget build(BuildContext contexto) {
    return Row(
      children: [
        GestureDetector(
          onTap: alHuir,
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(color: PaletaNeon.violetaBase, width: 1.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              AppLocalizations.of(contexto).puzzleBotonHuir,
              style: const TextStyle(
                color: PaletaNeon.textoPrincipal,
                fontSize: 13,
                letterSpacing: 1.5,
              ),
            ),
          ),
        ),
        const Spacer(),
        Text(
          titulo,
          style: const TextStyle(
            color: PaletaNeon.textoTenue,
            fontSize: 12,
            letterSpacing: 3,
          ),
        ),
        const Spacer(),
        const SizedBox(width: 58),
      ],
    );
  }
}
