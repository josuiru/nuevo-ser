import 'package:flutter/material.dart';

import '../nucleo/paleta.dart';

/// Presencia de Oryn: maestro de Sora. Avatar en el centro inferior de
/// la pantalla — su rol es figura tutelar, no compañero (izquierda) ni
/// rival (derecha). Bocadillo encima.
///
/// Paleta canónica del concept-art (`docs/personajes/concept-art/oryn.pdf`):
/// cabeza envuelta en vendas blanco-lavanda con un solo ojo verde
/// visible, traje azul con sombras violeta, bandolera negra cruzada,
/// pantalón rojo terroso con franja verde lateral, botas altas negras.
class OrynPresencia extends StatelessWidget {
  final String? textoActivo;
  final VoidCallback? alTocarBocadillo;

  const OrynPresencia({
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
        alignment: Alignment.center,
        children: [
          const Positioned(
            bottom: 0,
            child: _AvatarOryn(),
          ),
          if (textoActivo != null)
            Positioned(
              left: 16,
              right: 16,
              bottom: 96,
              child: _BocadilloOryn(
                texto: textoActivo!,
                alTocar: alTocarBocadillo,
              ),
            ),
        ],
      ),
    );
  }
}

class _AvatarOryn extends StatelessWidget {
  const _AvatarOryn();

  @override
  Widget build(BuildContext contexto) {
    return CustomPaint(
      size: const Size(78, 108),
      painter: _PintorSiluetaOryn(),
    );
  }
}

class _PintorSiluetaOryn extends CustomPainter {
  // Paleta canónica (concept-art, ver biblia_visual.md).
  static const _siluetaCuerpo = Color(0xFF0B1A33);
  static const _contornoFigura = Color(0xFFA5D45A);
  static const _vendaBase = Color(0xFFE6DCEF);
  static const _vendaSombra = Color(0xFF9988B5);
  static const _ojo = Color(0xFFD8E27A);
  static const _torsoBase = Color(0xFF2C5BB6);
  static const _torsoSombra = Color(0xFF6B3F8F);
  static const _bandolera = Color(0xFF1B1B1B);
  static const _pantalon = Color(0xFFA0432B);
  static const _franjaPantalon = Color(0xFF6A8F3E);
  static const _bota = Color(0xFF1B1B1B);

  @override
  void paint(Canvas canvas, Size size) {
    final pinturaContorno = Paint()
      ..color = _contornoFigura.withOpacity(0.85)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final centroCabeza = Offset(size.width / 2, size.height * 0.18);
    final radioCabeza = size.width * 0.20;

    // Torso: silueta marcial. Hombros amplios, V invertida hacia
    // cintura estrecha — más cuadrado que Sora/Kai para sugerir
    // físico marcial.
    final torso = Path()
      ..moveTo(size.width * 0.22, size.height * 0.32)
      ..lineTo(size.width * 0.78, size.height * 0.32)
      ..lineTo(size.width * 0.68, size.height * 0.62)
      ..lineTo(size.width * 0.32, size.height * 0.62)
      ..close();
    canvas.drawPath(torso, Paint()..color = _torsoBase);

    // Sombras violeta en el torso (pectorales).
    final sombraTorso = Path()
      ..moveTo(size.width * 0.30, size.height * 0.36)
      ..quadraticBezierTo(
        size.width * 0.50,
        size.height * 0.50,
        size.width * 0.30,
        size.height * 0.58,
      )
      ..close();
    canvas.drawPath(sombraTorso, Paint()..color = _torsoSombra);

    // Bandolera negra cruzada del hombro derecho a cintura izquierda.
    canvas.drawLine(
      Offset(size.width * 0.72, size.height * 0.34),
      Offset(size.width * 0.34, size.height * 0.60),
      Paint()
        ..color = _bandolera
        ..strokeWidth = 3.5
        ..strokeCap = StrokeCap.round,
    );

    // Cabeza vendada: óvalo lavanda con sombras curvas que sugieren
    // las vueltas de venda.
    canvas.drawCircle(
      centroCabeza,
      radioCabeza,
      Paint()..color = _vendaBase,
    );
    // Tres líneas curvas como pliegues de las vendas.
    final pinturaSombraVenda = Paint()
      ..color = _vendaSombra
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;
    for (final y in const [0.10, 0.20, 0.32]) {
      canvas.drawArc(
        Rect.fromCenter(
          center: Offset(centroCabeza.dx, centroCabeza.dy),
          width: radioCabeza * 2.05,
          height: radioCabeza * 2.05,
        ),
        2.6 + y,
        0.9,
        false,
        pinturaSombraVenda,
      );
    }
    // Ojo único visible: trazo verde-ámbar en el costado derecho de la cara.
    canvas.drawCircle(
      Offset(
        centroCabeza.dx + radioCabeza * 0.45,
        centroCabeza.dy + radioCabeza * 0.05,
      ),
      2.2,
      Paint()..color = _ojo,
    );

    // Contornos.
    canvas.drawCircle(centroCabeza, radioCabeza, pinturaContorno);
    canvas.drawPath(torso, pinturaContorno);

    // Pantalón rojo terroso con franja verde lateral.
    final pinturaPantalon = Paint()..color = _pantalon;
    final pinturaFranja = Paint()..color = _franjaPantalon;
    final rectPantalonIzq = Rect.fromLTWH(
      size.width * 0.30,
      size.height * 0.62,
      size.width * 0.18,
      size.height * 0.20,
    );
    final rectPantalonDer = Rect.fromLTWH(
      size.width * 0.52,
      size.height * 0.62,
      size.width * 0.18,
      size.height * 0.20,
    );
    canvas.drawRect(rectPantalonIzq, pinturaPantalon);
    canvas.drawRect(rectPantalonDer, pinturaPantalon);
    // Franja en el lado exterior de cada pierna.
    canvas.drawRect(
      Rect.fromLTWH(rectPantalonIzq.left, rectPantalonIzq.top,
          size.width * 0.025, rectPantalonIzq.height),
      pinturaFranja,
    );
    canvas.drawRect(
      Rect.fromLTWH(rectPantalonDer.right - size.width * 0.025,
          rectPantalonDer.top, size.width * 0.025, rectPantalonDer.height),
      pinturaFranja,
    );

    // Botas altas negras hasta media pantorrilla.
    final pinturaBota = Paint()..color = _bota;
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.28, size.height * 0.82, size.width * 0.22,
          size.height * 0.16),
      pinturaBota,
    );
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.50, size.height * 0.82, size.width * 0.22,
          size.height * 0.16),
      pinturaBota,
    );

    // Sutil silueta de fondo (apenas perceptible) para que el contraste
    // con el escenario funcione en cualquier paleta de distrito.
    final fondo = Paint()
      ..color = _siluetaCuerpo.withOpacity(0.20)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.18, size.height * 0.08, size.width * 0.64,
          size.height * 0.90),
      fondo,
    );
  }

  @override
  bool shouldRepaint(covariant _PintorSiluetaOryn oldDelegate) => false;
}

class _BocadilloOryn extends StatelessWidget {
  final String texto;
  final VoidCallback? alTocar;

  const _BocadilloOryn({required this.texto, this.alTocar});

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
              begin: const Offset(0, 0.05),
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
              topRight: Radius.circular(16),
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
            border: Border.all(
              color: PaletaNeon.exitoSuave.withOpacity(0.6),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: PaletaNeon.exitoSuave.withOpacity(0.25),
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
