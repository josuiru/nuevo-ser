import 'package:flutter/material.dart';

/// Centra el contenido y le pone un ancho máximo en pantallas anchas
/// (tablet/escritorio), para que los formularios y fichas no se estiren de
/// lado a lado. En móvil ocupa todo el ancho disponible.
class CuerpoResponsivo extends StatelessWidget {
  const CuerpoResponsivo({super.key, required this.child, this.maxAncho = 560});

  final Widget child;
  final double maxAncho;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxAncho),
        child: child,
      ),
    );
  }
}
