import 'package:flutter/material.dart';

import '../nucleo/paleta.dart';

/// Presencia de Kai: avatar en silueta en la esquina inferior DERECHA
/// con un bocadillo a su izquierda. Aparece puntualmente para
/// interrumpir sesiones (biblia §4.3).
///
/// Paleta rojo bermellón + dorado, opuesta a Sora (mostaza + violeta).
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
    return CustomPaint(
      size: const Size(70, 90),
      painter: _PintorSiluetaKai(),
    );
  }
}

class _PintorSiluetaKai extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final pinturaSilueta = Paint()..color = const Color(0xFF160509);
    final pinturaContorno = Paint()
      ..color = const Color(0xFFFF4F4F).withOpacity(0.9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final pinturaDorado = Paint()
      ..color = const Color(0xFFD9B34A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    final pinturaMechon = Paint()
      ..color = const Color(0xFFE85050)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final centroCabeza = Offset(size.width / 2, size.height * 0.28);
    final radioCabeza = size.width * 0.22;

    // Cabeza + flequillo lateral: Kai lo lleva cuidado (biblia §4.2).
    canvas.drawCircle(centroCabeza, radioCabeza, pinturaSilueta);
    canvas.drawCircle(centroCabeza, radioCabeza, pinturaContorno);

    // Mechón carmesí que cae sobre la sien derecha.
    final trazoMechon = Path()
      ..moveTo(
          centroCabeza.dx + radioCabeza * 0.2, centroCabeza.dy - radioCabeza)
      ..quadraticBezierTo(
        centroCabeza.dx + radioCabeza * 1.0,
        centroCabeza.dy - radioCabeza * 0.5,
        centroCabeza.dx + radioCabeza * 0.6,
        centroCabeza.dy + radioCabeza * 0.2,
      );
    canvas.drawPath(trazoMechon, pinturaMechon);

    // Cortaviento rojo.
    final rectCortaviento = Rect.fromLTWH(
      size.width * 0.22,
      size.height * 0.42,
      size.width * 0.56,
      size.height * 0.5,
    );
    final pinturaCortaviento = Paint()..color = const Color(0xFF2A0808);
    canvas.drawRRect(
      RRect.fromRectAndRadius(rectCortaviento, const Radius.circular(6)),
      pinturaCortaviento,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(rectCortaviento, const Radius.circular(6)),
      pinturaContorno,
    );

    // Cremallera dorada y detalle cruzado del bolso.
    canvas.drawLine(
      Offset(rectCortaviento.center.dx, rectCortaviento.top + 6),
      Offset(rectCortaviento.center.dx, rectCortaviento.bottom - 6),
      pinturaDorado,
    );
    canvas.drawLine(
      Offset(rectCortaviento.left + 4, rectCortaviento.top + 12),
      Offset(rectCortaviento.right - 6, rectCortaviento.top + 26),
      pinturaDorado,
    );
  }

  @override
  bool shouldRepaint(covariant _PintorSiluetaKai oldDelegate) => false;
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
              color: const Color(0xFFFF5757).withOpacity(0.7),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFF5757).withOpacity(0.2),
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
