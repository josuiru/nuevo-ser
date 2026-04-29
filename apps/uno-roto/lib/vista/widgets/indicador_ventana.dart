import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../dominio/estado_cuaderno.dart';
import '../../nucleo/paleta.dart';

/// Indicador visual de maestría con la metáfora de una "ventana del
/// distrito que se ilumina". Cinco etapas, sin números:
///
///   latente  → silueta apagada (ventana cerrada de noche)
///   vista    → luz muy tenue tras el cristal
///   practica → media iluminación
///   firme    → totalmente iluminada
///   dominada → iluminada con halo cálido **que respira** (~2.2 s)
///
/// El [colorAcento] es el del distrito y tiñe la luz para que cada
/// distrito conserve su identidad cromática.
///
/// El estado "dominada" es el único que anima — un latido lento del
/// halo cálido. Los otros estados son estáticos: no queremos que la
/// pantalla parpadee si el niño aún no ha alcanzado la maestría.
class IndicadorVentana extends StatefulWidget {
  final EstadoCuaderno estado;
  final Color colorAcento;
  final double tamano;

  const IndicadorVentana({
    super.key,
    required this.estado,
    required this.colorAcento,
    this.tamano = 36,
  });

  @override
  State<IndicadorVentana> createState() => _IndicadorVentanaState();
}

class _IndicadorVentanaState extends State<IndicadorVentana>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );
    if (widget.estado == EstadoCuaderno.dominada) {
      _ctrl.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant IndicadorVentana viejo) {
    super.didUpdateWidget(viejo);
    if (widget.estado != viejo.estado) {
      if (widget.estado == EstadoCuaderno.dominada) {
        if (!_ctrl.isAnimating) _ctrl.repeat(reverse: true);
      } else {
        _ctrl.stop();
        _ctrl.value = 0;
      }
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.tamano,
      height: widget.tamano,
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (_, __) => CustomPaint(
          painter: _PintorVentana(
            estado: widget.estado,
            colorAcento: widget.colorAcento,
            faseLatido: _ctrl.value,
          ),
        ),
      ),
    );
  }
}

class _PintorVentana extends CustomPainter {
  final EstadoCuaderno estado;
  final Color colorAcento;

  /// Fase del latido del halo (0..1). Solo se usa cuando el estado es
  /// `dominada`; en otros estados no afecta al dibujo.
  final double faseLatido;

  _PintorVentana({
    required this.estado,
    required this.colorAcento,
    required this.faseLatido,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final lado = math.min(size.width, size.height);
    final centro = Offset(size.width / 2, size.height / 2);
    final marcoLado = lado * 0.78;
    final marcoTL = Offset(
      centro.dx - marcoLado / 2,
      centro.dy - marcoLado / 2,
    );
    final marcoRect = Rect.fromLTWH(
      marcoTL.dx,
      marcoTL.dy,
      marcoLado,
      marcoLado,
    );
    const radioMarco = Radius.circular(2);

    // 1. Halo cálido — solo en estado "dominada", **respira** entre
    //    una opacidad baja (0.22) y otra cálida (0.42). El radio
    //    también oscila ligeramente para reforzar el latido sin
    //    mareo.
    if (estado == EstadoCuaderno.dominada) {
      final opacidadHalo = 0.22 + 0.20 * faseLatido;
      final radioHalo = marcoLado * (0.74 + 0.06 * faseLatido);
      final halo = Paint()
        ..color = colorAcento.withOpacity(opacidadHalo)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
      canvas.drawCircle(centro, radioHalo, halo);
    }

    // 2. Cristal interior — luz según estado.
    final intensidad = _intensidadLuz();
    if (intensidad > 0) {
      final cristal = Paint()
        ..color = Color.lerp(
          PaletaNeon.fondoProfundo,
          colorAcento,
          intensidad,
        )!;
      canvas.drawRRect(
        RRect.fromRectAndRadius(marcoRect, radioMarco),
        cristal,
      );
    } else {
      // Silueta apagada: cristal muy oscuro azulado, casi negro.
      final apagado = Paint()..color = const Color(0xFF1A1330);
      canvas.drawRRect(
        RRect.fromRectAndRadius(marcoRect, radioMarco),
        apagado,
      );
    }

    // 3. Cruz de la ventana (peinazos): siempre presente, contraste
    //    sobre el cristal.
    final colorMarco = estado == EstadoCuaderno.latente
        ? PaletaNeon.textoTenue.withOpacity(0.55)
        : PaletaNeon.textoPrincipal.withOpacity(0.85);
    final lapizMarco = Paint()
      ..color = colorMarco
      ..strokeWidth = lado * 0.05
      ..style = PaintingStyle.stroke;

    // Borde exterior.
    canvas.drawRRect(
      RRect.fromRectAndRadius(marcoRect, radioMarco),
      lapizMarco,
    );
    // Peinazo vertical.
    canvas.drawLine(
      Offset(centro.dx, marcoRect.top),
      Offset(centro.dx, marcoRect.bottom),
      lapizMarco,
    );
    // Peinazo horizontal.
    canvas.drawLine(
      Offset(marcoRect.left, centro.dy),
      Offset(marcoRect.right, centro.dy),
      lapizMarco,
    );
  }

  /// Cuánto se mezcla el color del distrito con el fondo profundo
  /// dentro del cristal — 0 es ventana apagada, 1 es ventana llena.
  double _intensidadLuz() {
    switch (estado) {
      case EstadoCuaderno.latente:
        return 0;
      case EstadoCuaderno.vista:
        return 0.20;
      case EstadoCuaderno.practica:
        return 0.50;
      case EstadoCuaderno.firme:
        return 0.85;
      case EstadoCuaderno.dominada:
        return 1.0;
    }
  }

  @override
  bool shouldRepaint(covariant _PintorVentana viejo) =>
      viejo.estado != estado ||
      viejo.colorAcento != colorAcento ||
      viejo.faseLatido != faseLatido;
}
