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
    return CustomPaint(
      size: const Size(70, 90),
      painter: _PintorSiluetaKai(),
    );
  }
}

class _PintorSiluetaKai extends CustomPainter {
  // Paleta canónica (concept-art, ver biblia_visual.md):
  //  • Silueta: oscura azul-violeta (tono de fondo de la figura).
  //  • Sudadera azul cielo con capucha visible en la nuca.
  //  • Mechones borgoña en picos sobre la frente.
  //  • Pantalón morado oscuro asomando bajo la sudadera.
  //  • Zapatillas turquesa muy contrastadas.
  static const _siluetaCuerpo = Color(0xFF1B0C2A);
  static const _contornoAzul = Color(0xFF3FA9DE);
  static const _sudadera = Color(0xFF3FA9DE);
  static const _capucha = Color(0xFF2A7BAA);
  static const _peloPico = Color(0xFF6F2247);
  static const _pantalon = Color(0xFF5A2A4B);
  static const _zapatilla = Color(0xFF65D9C7);

  @override
  void paint(Canvas canvas, Size size) {
    final pinturaContorno = Paint()
      ..color = _contornoAzul.withOpacity(0.85)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final centroCabeza = Offset(size.width / 2, size.height * 0.26);
    final radioCabeza = size.width * 0.23;

    // Sudadera: caja redondeada amplia, larga (le llega casi al pie).
    final rectSudadera = Rect.fromLTWH(
      size.width * 0.20,
      size.height * 0.42,
      size.width * 0.60,
      size.height * 0.42,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(rectSudadera, const Radius.circular(8)),
      Paint()..color = _sudadera,
    );

    // Capucha caída por detrás del cuello (semicírculo oscuro detrás
    // de los hombros).
    final rectCapucha = Rect.fromCenter(
      center: Offset(centroCabeza.dx, size.height * 0.43),
      width: size.width * 0.45,
      height: size.height * 0.16,
    );
    canvas.drawArc(rectCapucha, 3.14, 3.14, true,
        Paint()..color = _capucha);

    // Cabeza con tez clara que destaca sobre la sudadera azul.
    canvas.drawCircle(
      centroCabeza,
      radioCabeza,
      Paint()..color = _siluetaCuerpo,
    );

    // Picos del pelo: 3 trazos cortos sobre la coronilla.
    final pinturaPelo = Paint()
      ..color = _peloPico
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    for (final desplaza in const [-0.55, 0.0, 0.55]) {
      canvas.drawLine(
        Offset(centroCabeza.dx + radioCabeza * desplaza,
            centroCabeza.dy - radioCabeza * 0.4),
        Offset(centroCabeza.dx + radioCabeza * desplaza * 1.2,
            centroCabeza.dy - radioCabeza * 1.25),
        pinturaPelo,
      );
    }

    // Contorno del torso por encima del relleno.
    canvas.drawRRect(
      RRect.fromRectAndRadius(rectSudadera, const Radius.circular(8)),
      pinturaContorno,
    );
    // Contorno de la cabeza.
    canvas.drawCircle(centroCabeza, radioCabeza, pinturaContorno);

    // Pantalón morado: dos trapecios verticales bajo la sudadera.
    final pinturaPantalon = Paint()..color = _pantalon;
    final rectPantalonIzq = Rect.fromLTWH(
      size.width * 0.32,
      size.height * 0.84,
      size.width * 0.14,
      size.height * 0.10,
    );
    final rectPantalonDer = Rect.fromLTWH(
      size.width * 0.54,
      size.height * 0.84,
      size.width * 0.14,
      size.height * 0.10,
    );
    canvas.drawRect(rectPantalonIzq, pinturaPantalon);
    canvas.drawRect(rectPantalonDer, pinturaPantalon);

    // Zapatillas turquesa: óvalos achatados al final de cada pierna.
    final pinturaZapatilla = Paint()..color = _zapatilla;
    final rectZapaIzq = Rect.fromLTWH(
      size.width * 0.30,
      size.height * 0.93,
      size.width * 0.18,
      size.height * 0.05,
    );
    final rectZapaDer = Rect.fromLTWH(
      size.width * 0.52,
      size.height * 0.93,
      size.width * 0.18,
      size.height * 0.05,
    );
    canvas.drawOval(rectZapaIzq, pinturaZapatilla);
    canvas.drawOval(rectZapaDer, pinturaZapatilla);
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
