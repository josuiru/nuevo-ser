import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../nucleo/paleta.dart';

class Particula {
  final double anguloRad;
  final double velocidadInicial;
  final double tamanoInicial;
  final double retardoSemilla;

  const Particula({
    required this.anguloRad,
    required this.velocidadInicial,
    required this.tamanoInicial,
    required this.retardoSemilla,
  });
}

/// Pintor de la rotura del Fragmento al derrotarlo.
///
/// [progreso] va de 0 (instante del impacto) a 1 (partículas completamente
/// disipadas). El pintor no anima por sí solo — recibe el progreso desde
/// un AnimationController externo.
class PintorRotura extends CustomPainter {
  final double progreso;
  final List<Particula> particulas;

  PintorRotura({required this.progreso, required this.particulas});

  static List<Particula> generar({int cantidad = 42, int semilla = 7}) {
    final generador = math.Random(semilla);
    return List.generate(cantidad, (indice) {
      final angulo = (indice / cantidad) * 2 * math.pi +
          (generador.nextDouble() - 0.5) * 0.4;
      return Particula(
        anguloRad: angulo,
        velocidadInicial: 180 + generador.nextDouble() * 220,
        tamanoInicial: 3.5 + generador.nextDouble() * 4.5,
        retardoSemilla: generador.nextDouble() * 0.15,
      );
    });
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (progreso <= 0 || progreso >= 1) return;
    final centro = Offset(size.width / 2, size.height / 2);

    for (final particula in particulas) {
      final tiempoLocal =
          (progreso - particula.retardoSemilla).clamp(0.0, 1.0);
      if (tiempoLocal <= 0) continue;
      final distancia = particula.velocidadInicial * tiempoLocal;
      final opacidad = (1 - tiempoLocal).clamp(0.0, 1.0);
      final tamano = particula.tamanoInicial * (1 - tiempoLocal * 0.6);

      final posicion = Offset(
        centro.dx + math.cos(particula.anguloRad) * distancia,
        centro.dy + math.sin(particula.anguloRad) * distancia,
      );

      final pinturaResplandor = Paint()
        ..color = PaletaNeon.azulNeon.withOpacity(0.45 * opacidad)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
      canvas.drawCircle(posicion, tamano * 1.6, pinturaResplandor);

      final pinturaFragmento = Paint()
        ..color = PaletaNeon.violetaNeon.withOpacity(opacidad);
      canvas.drawCircle(posicion, tamano, pinturaFragmento);

      final pinturaNucleo = Paint()
        ..color = PaletaNeon.textoPrincipal.withOpacity(0.8 * opacidad);
      canvas.drawCircle(posicion, tamano * 0.4, pinturaNucleo);
    }
  }

  @override
  bool shouldRepaint(covariant PintorRotura oldDelegate) {
    return oldDelegate.progreso != progreso ||
        !identical(oldDelegate.particulas, particulas);
  }
}
