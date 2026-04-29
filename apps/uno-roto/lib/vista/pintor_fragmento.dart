import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../dominio/fragmento.dart';
import '../nucleo/paleta.dart';

/// Estado emocional del Fragmento, que determina cómo se dibuja la cara.
enum EstadoFragmento {
  tranquilo,
  alerta,
  nervioso,
  sorprendido,
  apacible,
}

class PintorFragmento extends CustomPainter {
  final FragmentoUnitario fragmento;
  final double fasesLatido;
  final List<RadioTrazado> radiosConfirmados;
  final RadioTrazado? radioEnCurso;
  final bool destacarExito;
  final bool destacarFallo;
  final EstadoFragmento estado;
  final Offset? puntoDeAtencion;
  final double opacidad;

  PintorFragmento({
    required this.fragmento,
    required this.fasesLatido,
    required this.radiosConfirmados,
    required this.estado,
    this.radioEnCurso,
    this.puntoDeAtencion,
    this.destacarExito = false,
    this.destacarFallo = false,
    this.opacidad = 1.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (opacidad <= 0) return;
    final centro = Offset(size.width / 2, size.height / 2);
    final radioBase = math.min(size.width, size.height) / 2 - 24;
    final perfil = _PerfilTemperamento.paraFragmento(fragmento);

    final amplitudLatido = estado == EstadoFragmento.nervioso
        ? 7.0
        : perfil.amplitudLatido;
    final velocidadLatido = estado == EstadoFragmento.nervioso
        ? 2.5
        : perfil.velocidadLatido;
    final radioLatido = radioBase +
        math.sin(fasesLatido * 2 * math.pi * velocidadLatido) * amplitudLatido;

    final colorAura = _colorAuraSegunEstado(perfil);

    for (var capaAura = 4; capaAura >= 1; capaAura--) {
      final pinturaAura = Paint()
        ..color = colorAura.withOpacity(0.08 * capaAura * opacidad)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 8.0 * capaAura);
      canvas.drawCircle(centro, radioLatido + capaAura * 6.0, pinturaAura);
    }

    final pinturaInterior = Paint()
      ..shader = ui.Gradient.radial(
        centro,
        radioLatido,
        [
          PaletaNeon.violetaBase.withOpacity(0.9 * opacidad),
          PaletaNeon.fondoMedio.withOpacity(0.6 * opacidad),
        ],
      );
    canvas.drawCircle(centro, radioLatido, pinturaInterior);

    final pinturaBorde = Paint()
      ..color = colorAura.withOpacity(opacidad)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(centro, radioLatido, pinturaBorde);

    // Marcas tipo reloj: 12 rayitas cada 30° justo por fuera del borde,
    // como referencia visual + indicador de los puntos donde el snap
    // angular ajusta al soltar (ver `_LienzoCombateState`). Las cuatro
    // cardinales (12, 3, 6, 9) salen un punto más largas para que el
    // niño tenga "norte" rápido.
    _pintarMarcasReloj(
      canvas: canvas,
      centro: centro,
      radio: radioLatido,
      colorBase: colorAura,
    );

    _pintarCara(
      canvas: canvas,
      centro: centro,
      radio: radioLatido,
    );

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

  Color _colorAuraSegunEstado(_PerfilTemperamento perfil) {
    switch (estado) {
      case EstadoFragmento.apacible:
        return PaletaNeon.exitoSuave;
      case EstadoFragmento.sorprendido:
        return PaletaNeon.rosaAcento;
      case EstadoFragmento.nervioso:
        return PaletaNeon.rosaAcento;
      case EstadoFragmento.alerta:
      case EstadoFragmento.tranquilo:
        return perfil.colorAura;
    }
  }

  void _pintarCara({
    required Canvas canvas,
    required Offset centro,
    required double radio,
  }) {
    final distanciaOjo = radio * 0.3;
    final ojoIzquierdo = Offset(centro.dx - distanciaOjo, centro.dy - radio * 0.08);
    final ojoDerecho = Offset(centro.dx + distanciaOjo, centro.dy - radio * 0.08);
    final alturaOjo = _alturaOjoSegunEstado();
    final anchoOjo = radio * 0.13;

    _pintarOjo(
      canvas: canvas,
      centroOjo: ojoIzquierdo,
      ancho: anchoOjo,
      alto: anchoOjo * alturaOjo,
      atencion: puntoDeAtencion,
    );
    _pintarOjo(
      canvas: canvas,
      centroOjo: ojoDerecho,
      ancho: anchoOjo,
      alto: anchoOjo * alturaOjo,
      atencion: puntoDeAtencion,
    );

    _pintarBoca(
      canvas: canvas,
      centro: centro,
      radio: radio,
    );
  }

  double _alturaOjoSegunEstado() {
    switch (estado) {
      case EstadoFragmento.apacible:
        return 0.1;
      case EstadoFragmento.sorprendido:
        return 1.4;
      case EstadoFragmento.nervioso:
        return 1.2;
      case EstadoFragmento.alerta:
        return 1.05;
      case EstadoFragmento.tranquilo:
        return 0.9;
    }
  }

  void _pintarOjo({
    required Canvas canvas,
    required Offset centroOjo,
    required double ancho,
    required double alto,
    required Offset? atencion,
  }) {
    final blanco = Paint()
      ..color = PaletaNeon.textoPrincipal.withOpacity(0.9 * opacidad);
    canvas.drawOval(
      Rect.fromCenter(center: centroOjo, width: ancho, height: alto),
      blanco,
    );

    if (estado == EstadoFragmento.apacible) {
      final trazoCerrado = Paint()
        ..color = PaletaNeon.fondoProfundo.withOpacity(opacidad)
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke;
      canvas.drawLine(
        Offset(centroOjo.dx - ancho / 2, centroOjo.dy),
        Offset(centroOjo.dx + ancho / 2, centroOjo.dy),
        trazoCerrado,
      );
      return;
    }

    final desplazamiento = _desplazamientoPupila(
      centroOjo: centroOjo,
      ancho: ancho,
      alto: alto,
      atencion: atencion,
    );
    final centroPupila = centroOjo + desplazamiento;
    final colorPupila = estado == EstadoFragmento.sorprendido
        ? PaletaNeon.rosaAcento
        : PaletaNeon.violetaNeon;
    final pupila = Paint()..color = colorPupila.withOpacity(opacidad);
    canvas.drawCircle(centroPupila, ancho * 0.35, pupila);

    final brillo = Paint()
      ..color = PaletaNeon.textoPrincipal.withOpacity(0.9 * opacidad);
    canvas.drawCircle(
      centroPupila.translate(-ancho * 0.1, -ancho * 0.1),
      ancho * 0.08,
      brillo,
    );
  }

  Offset _desplazamientoPupila({
    required Offset centroOjo,
    required double ancho,
    required double alto,
    required Offset? atencion,
  }) {
    if (atencion == null) return Offset.zero;
    final vector = atencion - centroOjo;
    final distancia = vector.distance;
    if (distancia == 0) return Offset.zero;
    final limite = ancho * 0.28;
    final escala = math.min(limite / distancia, 1.0);
    return Offset(vector.dx * escala, vector.dy * escala);
  }

  void _pintarBoca({
    required Canvas canvas,
    required Offset centro,
    required double radio,
  }) {
    final alturaBoca = centro.dy + radio * 0.35;
    final anchoBoca = radio * 0.35;
    final pintura = Paint()
      ..color = PaletaNeon.textoPrincipal.withOpacity(0.55 * opacidad)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final trazo = Path();
    switch (estado) {
      case EstadoFragmento.apacible:
        trazo.moveTo(centro.dx - anchoBoca / 2, alturaBoca);
        trazo.quadraticBezierTo(
          centro.dx,
          alturaBoca + 8,
          centro.dx + anchoBoca / 2,
          alturaBoca,
        );
        break;
      case EstadoFragmento.sorprendido:
        canvas.drawOval(
          Rect.fromCenter(
            center: Offset(centro.dx, alturaBoca),
            width: anchoBoca * 0.4,
            height: anchoBoca * 0.5,
          ),
          pintura,
        );
        return;
      case EstadoFragmento.nervioso:
        trazo.moveTo(centro.dx - anchoBoca / 2, alturaBoca);
        trazo.quadraticBezierTo(
          centro.dx,
          alturaBoca - 5,
          centro.dx + anchoBoca / 2,
          alturaBoca,
        );
        break;
      case EstadoFragmento.alerta:
      case EstadoFragmento.tranquilo:
        trazo.moveTo(centro.dx - anchoBoca / 2, alturaBoca);
        trazo.lineTo(centro.dx + anchoBoca / 2, alturaBoca);
        break;
    }
    canvas.drawPath(trazo, pintura);
  }

  /// 12 marcas radiales por fuera del borde. Las cuatro cardinales
  /// (cada 90°: 12/3/6/9) son ligeramente más largas y opacas. El resto
  /// son rayitas finas. Sirven de referencia visual y coinciden con los
  /// puntos donde el snap angular del lienzo ajusta el radio al soltar.
  void _pintarMarcasReloj({
    required Canvas canvas,
    required Offset centro,
    required double radio,
    required Color colorBase,
  }) {
    const totalMarcas = 12;
    final largoCorto = radio * 0.04;
    final largoLargo = radio * 0.07;
    const separacion = 4.0; // Pequeño hueco entre el borde y la marca.

    for (var i = 0; i < totalMarcas; i++) {
      final esCardinal = i % 3 == 0;
      final largoMarca = esCardinal ? largoLargo : largoCorto;
      final opacidadMarca =
          (esCardinal ? 0.55 : 0.32) * opacidad;
      // 0° en la convención de Flutter apunta a la derecha; restamos π/2
      // para que la primera marca quede arriba (las "12" del reloj).
      final angulo = -math.pi / 2 + i * (2 * math.pi / totalMarcas);
      final puntoInterior = Offset(
        centro.dx + math.cos(angulo) * (radio + separacion),
        centro.dy + math.sin(angulo) * (radio + separacion),
      );
      final puntoExterior = Offset(
        centro.dx + math.cos(angulo) * (radio + separacion + largoMarca),
        centro.dy + math.sin(angulo) * (radio + separacion + largoMarca),
      );
      final pintura = Paint()
        ..color = colorBase.withOpacity(opacidadMarca)
        ..strokeWidth = esCardinal ? 1.6 : 1.0
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(puntoInterior, puntoExterior, pintura);
    }
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
      ..color = color.withOpacity(0.5 * opacidad)
      ..strokeWidth = grosor + 6
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    lienzo.drawLine(centro, puntoExterior, pinturaResplandor);

    final pinturaLinea = Paint()
      ..color = color.withOpacity(opacidad)
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
        fontSize: 20,
        fontWeight: FontWeight.w300,
      ),
    )
      ..pushStyle(ui.TextStyle(
        color: PaletaNeon.textoPrincipal.withOpacity(0.7 * opacidad),
        letterSpacing: 2,
      ))
      ..addText(texto);
    final parrafo = constructor.build()
      ..layout(const ui.ParagraphConstraints(width: 120));
    lienzo.drawParagraph(
      parrafo,
      Offset(centro.dx - 60, centro.dy + 24),
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
    if (oldDelegate.estado != estado) return true;
    if (oldDelegate.opacidad != opacidad) return true;
    if (oldDelegate.puntoDeAtencion != puntoDeAtencion) return true;
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

/// Datos estéticos y de comportamiento derivados del temperamento del
/// Fragmento. Dan personalidad sin revelar la solución matemática: el
/// niño nota que "este es más nervioso" pero no ve pistas del número
/// de sectores en que debe cortar.
class _PerfilTemperamento {
  final Color colorAura;
  final double amplitudLatido;
  final double velocidadLatido;
  final double frecuenciaParpadeo;

  const _PerfilTemperamento({
    required this.colorAura,
    required this.amplitudLatido,
    required this.velocidadLatido,
    required this.frecuenciaParpadeo,
  });

  static _PerfilTemperamento paraFragmento(FragmentoUnitario fragmento) {
    switch (fragmento.temperamento) {
      case TemperamentoFragmento.sereno:
        return const _PerfilTemperamento(
          colorAura: PaletaNeon.azulNeon,
          amplitudLatido: 3.5,
          velocidadLatido: 0.7,
          frecuenciaParpadeo: 0.08,
        );
      case TemperamentoFragmento.estable:
        return const _PerfilTemperamento(
          colorAura: Color(0xFF7CB5FF),
          amplitudLatido: 4.0,
          velocidadLatido: 0.95,
          frecuenciaParpadeo: 0.1,
        );
      case TemperamentoFragmento.metodico:
        return const _PerfilTemperamento(
          colorAura: Color(0xFF8A5CFF),
          amplitudLatido: 4.5,
          velocidadLatido: 1.1,
          frecuenciaParpadeo: 0.12,
        );
      case TemperamentoFragmento.inquieto:
        return const _PerfilTemperamento(
          colorAura: Color(0xFFFF6FB3),
          amplitudLatido: 5.5,
          velocidadLatido: 1.6,
          frecuenciaParpadeo: 0.22,
        );
    }
  }
}
