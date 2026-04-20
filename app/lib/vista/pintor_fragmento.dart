import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../dominio/fragmento.dart';
import '../nucleo/paleta.dart';

class PintorFragmento extends CustomPainter {
  final FragmentoUnitario fragmento;
  final double fasesLatido;
  final List<RadioTrazado> radiosConfirmados;
  final RadioTrazado? radioEnCurso;
  final bool destacarExito;
  final bool destacarFallo;

  PintorFragmento({
    required this.fragmento,
    required this.fasesLatido,
    required this.radiosConfirmados,
    this.radioEnCurso,
    this.destacarExito = false,
    this.destacarFallo = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final centro = Offset(size.width / 2, size.height / 2);
    final radioBase = math.min(size.width, size.height) / 2 - 24;
    const amplitudLatido = 4.0;
    final radioLatido =
        radioBase + math.sin(fasesLatido * 2 * math.pi) * amplitudLatido;

    final colorAura = destacarExito
        ? PaletaNeon.exitoSuave
        : destacarFallo
            ? PaletaNeon.rosaAcento
            : PaletaNeon.azulNeon;

    for (var capaAura = 4; capaAura >= 1; capaAura--) {
      final pinturaAura = Paint()
        ..color = colorAura.withOpacity(0.08 * capaAura)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 8.0 * capaAura);
      canvas.drawCircle(centro, radioLatido + capaAura * 6.0, pinturaAura);
    }

    final pinturaInterior = Paint()
      ..shader = ui.Gradient.radial(
        centro,
        radioLatido,
        [
          PaletaNeon.violetaBase.withOpacity(0.9),
          PaletaNeon.fondoMedio.withOpacity(0.6),
        ],
      );
    canvas.drawCircle(centro, radioLatido, pinturaInterior);

    final pinturaBorde = Paint()
      ..color = colorAura
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(centro, radioLatido, pinturaBorde);

    for (final radioConfirmado in radiosConfirmados) {
      _dibujarRadio(
        lienzo: canvas,
        centro: centro,
        radioLongitud: radioLatido,
        anguloRad: radioConfirmado.anguloNormalizado,
        color: PaletaNeon.violetaNeon,
        grosor: 3,
      );
    }

    final trazoEnCurso = radioEnCurso;
    if (trazoEnCurso != null) {
      _dibujarRadio(
        lienzo: canvas,
        centro: centro,
        radioLongitud: radioLatido,
        anguloRad: trazoEnCurso.anguloNormalizado,
        color: PaletaNeon.rosaAcento,
        grosor: 2,
      );
    }

    _dibujarEtiqueta(
      lienzo: canvas,
      centro: centro,
      texto: fragmento.etiqueta,
    );
  }

  void _dibujarRadio({
    required Canvas lienzo,
    required Offset centro,
    required double radioLongitud,
    required double anguloRad,
    required Color color,
    required double grosor,
  }) {
    final puntoExterior = Offset(
      centro.dx + math.cos(anguloRad) * radioLongitud,
      centro.dy + math.sin(anguloRad) * radioLongitud,
    );

    final pinturaResplandor = Paint()
      ..color = color.withOpacity(0.5)
      ..strokeWidth = grosor + 6
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    lienzo.drawLine(centro, puntoExterior, pinturaResplandor);

    final pinturaLinea = Paint()
      ..color = color
      ..strokeWidth = grosor
      ..strokeCap = StrokeCap.round;
    lienzo.drawLine(centro, puntoExterior, pinturaLinea);
  }

  void _dibujarEtiqueta({
    required Canvas lienzo,
    required Offset centro,
    required String texto,
  }) {
    final constructor = ui.ParagraphBuilder(
      ui.ParagraphStyle(
        textAlign: TextAlign.center,
        fontSize: 28,
        fontWeight: FontWeight.w300,
      ),
    )
      ..pushStyle(ui.TextStyle(
        color: PaletaNeon.textoPrincipal.withOpacity(0.85),
        letterSpacing: 2,
      ))
      ..addText(texto);
    final parrafo = constructor.build()
      ..layout(const ui.ParagraphConstraints(width: 120));
    lienzo.drawParagraph(
      parrafo,
      Offset(centro.dx - 60, centro.dy - parrafo.height / 2),
    );
  }

  @override
  bool shouldRepaint(covariant PintorFragmento oldDelegate) {
    if (oldDelegate.fasesLatido != fasesLatido) return true;
    if (oldDelegate.fragmento.denominador != fragmento.denominador) return true;
    if (oldDelegate.radioEnCurso?.anguloRad != radioEnCurso?.anguloRad) {
      return true;
    }
    if (oldDelegate.destacarExito != destacarExito) return true;
    if (oldDelegate.destacarFallo != destacarFallo) return true;
    if (oldDelegate.radiosConfirmados.length != radiosConfirmados.length) {
      return true;
    }
    for (var indice = 0; indice < radiosConfirmados.length; indice++) {
      if (oldDelegate.radiosConfirmados[indice].anguloRad !=
          radiosConfirmados[indice].anguloRad) {
        return true;
      }
    }
    return false;
  }
}
