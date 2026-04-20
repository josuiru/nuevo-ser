import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../nucleo/paleta.dart';

/// Escenario urbano nocturno: cielo con estrellas, silueta de la Montaña
/// al fondo (biblia §4.7) y siluetas de edificios en primer plano, con
/// ventanas cálidas encendidas. Se pinta detrás de todo lo demás.
class PintorEscenario extends CustomPainter {
  final double fasePulso;

  PintorEscenario({required this.fasePulso});

  @override
  void paint(Canvas canvas, Size size) {
    _pintarCielo(canvas, size);
    _pintarEstrellas(canvas, size);
    _pintarMontana(canvas, size);
    _pintarEdificios(canvas, size);
  }

  void _pintarCielo(Canvas canvas, Size size) {
    final pintura = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          PaletaNeon.fondoProfundo,
          PaletaNeon.fondoMedio,
          PaletaNeon.violetaBase.withOpacity(0.35),
        ],
        stops: const [0, 0.55, 1],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, pintura);
  }

  void _pintarEstrellas(Canvas canvas, Size size) {
    final generador = math.Random(42);
    final pinturaEstrella = Paint()..color = PaletaNeon.textoTenue;
    for (var indice = 0; indice < 60; indice++) {
      final cordX = generador.nextDouble() * size.width;
      final cordY = generador.nextDouble() * size.height * 0.6;
      final brilloBase = 0.25 + generador.nextDouble() * 0.45;
      final parpadeo =
          math.sin((fasePulso * 2 * math.pi) + indice * 1.3) * 0.15 + 0.85;
      pinturaEstrella.color =
          PaletaNeon.textoTenue.withOpacity(brilloBase * parpadeo);
      canvas.drawCircle(
        Offset(cordX, cordY),
        0.6 + generador.nextDouble() * 0.8,
        pinturaEstrella,
      );
    }
  }

  void _pintarMontana(Canvas canvas, Size size) {
    final lineaHorizonte = size.height * 0.55;
    final trazado = Path()
      ..moveTo(-10, lineaHorizonte + 40)
      ..lineTo(size.width * 0.18, lineaHorizonte - 30)
      ..lineTo(size.width * 0.28, lineaHorizonte - 10)
      ..lineTo(size.width * 0.42, lineaHorizonte - 70)
      ..lineTo(size.width * 0.55, lineaHorizonte - 25)
      ..lineTo(size.width * 0.68, lineaHorizonte - 50)
      ..lineTo(size.width * 0.82, lineaHorizonte - 15)
      ..lineTo(size.width + 10, lineaHorizonte + 20)
      ..lineTo(size.width + 10, lineaHorizonte + 80)
      ..lineTo(-10, lineaHorizonte + 80)
      ..close();

    final pintura = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          PaletaNeon.violetaBase.withOpacity(0.45),
          PaletaNeon.fondoProfundo.withOpacity(0.85),
        ],
      ).createShader(trazado.getBounds());
    canvas.drawPath(trazado, pintura);
  }

  void _pintarEdificios(Canvas canvas, Size size) {
    final lineaSuelo = size.height - 24;
    final alturas = [110.0, 160.0, 95.0, 200.0, 130.0, 175.0, 80.0, 145.0];
    var cursorX = -10.0;
    final anchuras = [60.0, 45.0, 70.0, 55.0, 40.0, 65.0, 50.0, 75.0];

    final pinturaEdificio = Paint()
      ..color = const Color(0xFF07041A)
      ..style = PaintingStyle.fill;

    final pinturaBordeNeon = Paint()
      ..color = PaletaNeon.violetaNeon.withOpacity(0.35)
      ..strokeWidth = 1;

    for (var indice = 0; indice < alturas.length; indice++) {
      final ancho = anchuras[indice % anchuras.length];
      final alto = alturas[indice];
      final rectEdificio = Rect.fromLTWH(
        cursorX,
        lineaSuelo - alto,
        ancho,
        alto + 40,
      );
      canvas.drawRect(rectEdificio, pinturaEdificio);
      canvas.drawLine(
        Offset(cursorX, lineaSuelo - alto),
        Offset(cursorX + ancho, lineaSuelo - alto),
        pinturaBordeNeon,
      );
      _pintarVentanas(canvas, rectEdificio, indice);
      cursorX += ancho;
      if (cursorX > size.width) break;
    }
  }

  void _pintarVentanas(Canvas canvas, Rect edificio, int semilla) {
    final generador = math.Random(semilla * 17 + 3);
    final pinturaVentana = Paint()..color = const Color(0xFFFFD08A);
    const tamanoVentana = 3.5;
    const margen = 6.0;
    for (var cordY = edificio.top + 12;
        cordY < edificio.bottom - margen;
        cordY += 10) {
      for (var cordX = edificio.left + margen;
          cordX < edificio.right - margen;
          cordX += 8) {
        if (generador.nextDouble() < 0.35) {
          pinturaVentana.color = Color.fromRGBO(
            255,
            208,
            138,
            0.55 + generador.nextDouble() * 0.35,
          );
          canvas.drawRect(
            Rect.fromLTWH(cordX, cordY, tamanoVentana, tamanoVentana),
            pinturaVentana,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant PintorEscenario oldDelegate) {
    return oldDelegate.fasePulso != fasePulso;
  }
}
