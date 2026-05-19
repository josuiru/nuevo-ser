import 'package:flutter/material.dart';

import '../nucleo/paleta.dart';

/// Presencia de Kai: avatar en silueta en la esquina inferior DERECHA
/// con un bocadillo a su izquierda. Aparece puntualmente para
/// interrumpir sesiones (biblia §4.3).
///
/// Paleta canónica (concept-art 2026-05-19): pelo borgoña, sudadera
/// azul cielo con capucha, pantalón morado, zapatillas turquesa.
/// Ver `docs/personajes/biblia_visual.md` y `concept-art/kai*.pdf`.
class KaiPresencia extends StatelessWidget {
  final String? textoActivo;
  final VoidCallback? alTocarBocadillo;

  const KaiPresencia({
    super.key,
    required this.textoActivo,
    this.alTocarBocadillo,
  });

  @override
  Widget build(BuildContext contexto) {
    return SizedBox(
      height: 120,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          const Positioned(
            right: 16,
            bottom: 0,
            child: _AvatarKai(),
          ),
          if (textoActivo != null)
            Positioned(
              left: 16,
              right: 96,
              bottom: 30,
              child: _BocadilloKai(
                texto: textoActivo!,
                alTocar: alTocarBocadillo,
              ),
            ),
        ],
      ),
    );
  }
}

class _AvatarKai extends StatelessWidget {
  const _AvatarKai();

  @override
  Widget build(BuildContext contexto) {
    // PNG escaneado del concept-art original (kai.pdf). Cabe en el
    // SizedBox de 120 del padre — si lo subimos más rompemos el
    // layout de pantalla_combate (que asume franja de 120 al fondo).
    return Image.asset(
      'assets/personajes/kai.png',
      width: 95,
      height: 120,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.medium,
    );
  }
}


class _BocadilloKai extends StatelessWidget {
  final String texto;
  final VoidCallback? alTocar;

  const _BocadilloKai({required this.texto, this.alTocar});

  @override
  Widget build(BuildContext contexto) {
    return GestureDetector(
      onTap: alTocar,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 280),
        transitionBuilder: (hijo, animacion) => FadeTransition(
          opacity: animacion,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.05, 0),
              end: Offset.zero,
            ).animate(animacion),
            child: hijo,
          ),
        ),
        child: Container(
          key: ValueKey(texto),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: PaletaNeon.fondoProfundo.withOpacity(0.85),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(4),
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
            border: Border.all(
              color: PaletaNeon.rosaAcento.withOpacity(0.6),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: PaletaNeon.rosaAcento.withOpacity(0.2),
                blurRadius: 14,
              ),
            ],
          ),
          child: Text(
            texto,
            style: const TextStyle(
              color: PaletaNeon.textoPrincipal,
              fontSize: 14,
              height: 1.4,
              letterSpacing: 0.3,
            ),
          ),
        ),
      ),
    );
  }
}
