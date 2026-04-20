import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../dominio/fragmento_en_tejado.dart';
import '../nucleo/paleta.dart';

/// Dibuja un Fragmento flotando en el tejado a la espera de ser
/// cazado. Más pequeño y discreto que el del combate: el niño lo ve
/// como presencia ambiente, no como diana del momento.
class PintorFragmentoTejado extends CustomPainter {
  final FragmentoEnTejado fragmento;
  final double fraccionVida; // 0..1
  final double fasePulso;

  PintorFragmentoTejado({
    required this.fragmento,
    required this.fraccionVida,
    required this.fasePulso,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final centro = Offset(size.width / 2, size.height / 2);
    final radioBase = math.min(size.width, size.height) / 2 - 6;
    const amplitud = 2.5;
    final radio =
        radioBase + math.sin(fasePulso * 2 * math.pi) * amplitud;
    final escapando = fraccionVida >= 0.75;
    final opacidad = escapando
        ? (1 - (fraccionVida - 0.75) / 0.25).clamp(0.0, 1.0)
        : 1.0;

    final esEspejo = fragmento.tipo == TipoFragmentoEnTejado.espejo;
    final esDecimal = fragmento.tipo == TipoFragmentoEnTejado.decimal;
    final colorAura = escapando
        ? PaletaNeon.rosaAcento
        : esEspejo
            ? const Color(0xFFFFC36B)
            : esDecimal
                ? const Color(0xFF7EE8D7)
                : PaletaNeon.azulNeon;

    if (esEspejo && !escapando) {
      // Aro fantasma que insinúa el "espejo" del Fragmento.
      final pinturaEspejo = Paint()
        ..color = colorAura.withOpacity(0.3 * opacidad)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2;
      canvas.drawCircle(
        centro.translate(radioBase * 0.4, -radioBase * 0.3),
        radioBase * 0.8,
        pinturaEspejo,
      );
    }

    // Aura suave.
    for (var capa = 3; capa >= 1; capa--) {
      final pinturaAura = Paint()
        ..color = colorAura.withOpacity(0.09 * capa * opacidad)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 6.0 * capa);
      canvas.drawCircle(centro, radio + capa * 4.0, pinturaAura);
    }

    // Cuerpo.
    final pinturaInterior = Paint()
      ..color =
          PaletaNeon.violetaBase.withOpacity(0.85 * opacidad);
    canvas.drawCircle(centro, radio, pinturaInterior);

    final pinturaBorde = Paint()
      ..color = colorAura.withOpacity(opacidad)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6;
    canvas.drawCircle(centro, radio, pinturaBorde);

    // Etiqueta.
    final textoEstilo = TextStyle(
      color: PaletaNeon.textoPrincipal.withOpacity(0.9 * opacidad),
      fontSize: radio * 0.55,
      fontWeight: FontWeight.w300,
      letterSpacing: 1.1,
    );
    final pintorTexto = TextPainter(
      text: TextSpan(text: fragmento.etiqueta, style: textoEstilo),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    )..layout();
    pintorTexto.paint(
      canvas,
      Offset(
        centro.dx - pintorTexto.width / 2,
        centro.dy - pintorTexto.height / 2,
      ),
    );

    // Anillo de vida: se encoge según se acerca la fuga.
    if (fraccionVida > 0.1) {
      final pinturaAnilloVida = Paint()
        ..color = (escapando
                ? PaletaNeon.rosaAcento
                : PaletaNeon.azulNeon)
            .withOpacity(0.8 * opacidad)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round;
      const anguloInicio = -math.pi / 2;
      final anguloFin = anguloInicio + 2 * math.pi * (1 - fraccionVida);
      canvas.drawArc(
        Rect.fromCircle(center: centro, radius: radio + 4),
        anguloInicio,
        anguloFin - anguloInicio,
        false,
        pinturaAnilloVida,
      );
    }
  }

  @override
  bool shouldRepaint(covariant PintorFragmentoTejado oldDelegate) {
    return oldDelegate.fasePulso != fasePulso ||
        oldDelegate.fraccionVida != fraccionVida ||
        oldDelegate.fragmento.identificador != fragmento.identificador;
  }
}
