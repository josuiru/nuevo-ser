import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../tema/colores.dart';

/// Pantalla del lienzo de dibujo del cuaderno (biblia §3.2 — el niño
/// puede registrar lo observado dibujándolo además de escribiéndolo).
///
/// Versión enriquecida (B6 — fallback de experto pendiente de
/// validación con la ilustradora botánica). Sigue siendo deliberadamente
/// austera: una sola tinta, sin colores, sin presión variable, sin
/// capas. La biblia §8.1 prescribe carbón/tinta sobre papel — el
/// repertorio expresivo del niño se respeta dándole control sobre
/// **anchos de trazo** y **deshacer último trazo**, no añadiendo
/// paletas saturadas que romperían el tono del cuaderno botánico.
///
/// Diferencias con la versión MVP (A4):
/// - Tres anchos de trazo seleccionables (fino 1.5 px, medio 3 px,
///   grueso 6 px). Cada trazo guarda su propio ancho.
/// - Deshacer último trazo (Icons.undo en AppBar). No es multi-paso
///   ilimitado: respeta el principio de "sin fanfarria" — un undo
///   simple es suficiente para corregir un mal trazo, y la decisión
///   de cuántos pasos atrás permitir queda como decisión humana
///   (B6 con la ilustradora).
///
/// El gesto de pan sigue siendo la unidad: cada arrastre añade un
/// `Trazo`. Botón "borrar y empezar otra vez" vacía toda la pila.
/// Botón "guardar dibujo" renderiza el lienzo a PNG con
/// `RepaintBoundary.toImage()` y devuelve los bytes vía
/// `Navigator.pop`.
///
/// Si el niño cierra la pantalla sin guardar (botón atrás), el dibujo
/// se descarta — la biblia §2.7 prohíbe interrumpir al niño con
/// confirmaciones que no haya pedido.
class PantallaLienzoDibujo extends StatefulWidget {
  const PantallaLienzoDibujo({super.key, this.tituloAppBar});

  /// Título opcional. Por defecto el AppBar muestra solo los botones.
  final String? tituloAppBar;

  @override
  State<PantallaLienzoDibujo> createState() => _EstadoPantallaLienzoDibujo();
}

/// Tres anchos de trazo predefinidos. La elección concreta de los
/// pixeles es provisional — pendiente de validación con la
/// ilustradora botánica (B6). Los nombres son sentence case minúscula,
/// coherentes con el resto de la voz del cuaderno.
enum AnchoTrazo {
  fino(1.5),
  medio(3),
  grueso(6);

  const AnchoTrazo(this.pixeles);
  final double pixeles;
}

class _Trazo {
  _Trazo({required this.ancho}) : puntos = <Offset>[];
  final AnchoTrazo ancho;
  final List<Offset> puntos;
}

class _EstadoPantallaLienzoDibujo extends State<PantallaLienzoDibujo> {
  final List<_Trazo> _trazos = [];
  final GlobalKey _claveRepaint = GlobalKey();

  AnchoTrazo _anchoActual = AnchoTrazo.medio;

  bool get _hayTrazos => _trazos.isNotEmpty;

  /// Punto inicial del trazo en curso. Lo guardamos al PointerDown
  /// para insertarlo solo si el usuario llega a moverse (PointerMove)
  /// — así un tap suelto sin movimiento no deja un puntito en la
  /// pantalla.
  Offset? _puntoInicialPendiente;

  void _alPunteroPresionar(PointerDownEvent evento) {
    _puntoInicialPendiente = evento.localPosition;
  }

  void _alPunteroMover(PointerMoveEvent evento) {
    setState(() {
      // Si llega el primer move sin trazo abierto, abrimos uno con
      // el punto inicial guardado (o con la posición actual si el
      // PointerDown no pasó por aquí — caso raro de tester).
      if (_puntoInicialPendiente != null) {
        final trazo = _Trazo(ancho: _anchoActual)
          ..puntos.add(_puntoInicialPendiente!);
        _trazos.add(trazo);
        _puntoInicialPendiente = null;
      }
      if (_trazos.isNotEmpty) {
        _trazos.last.puntos.add(evento.localPosition);
      }
    });
  }

  void _alPunteroLevantar(PointerUpEvent evento) {
    // Tap sin movimiento → sin trazo. El niño no quería dibujar nada
    // y no le dejamos un punto huérfano.
    _puntoInicialPendiente = null;
  }

  void _borrarTodo() {
    if (!_hayTrazos) return;
    setState(_trazos.clear);
  }

  void _deshacerUltimoTrazo() {
    if (!_hayTrazos) return;
    setState(() {
      _trazos.removeLast();
    });
  }

  void _cambiarAncho(AnchoTrazo ancho) {
    if (ancho == _anchoActual) return;
    setState(() => _anchoActual = ancho);
  }

  Future<void> _guardarYSalir() async {
    if (!_hayTrazos) return;
    final bytes = await _exportarComoPng();
    if (bytes == null) return;
    if (!mounted) return;
    Navigator.of(context).pop(bytes);
  }

  Future<Uint8List?> _exportarComoPng() async {
    final boundary = _claveRepaint.currentContext?.findRenderObject()
        as RenderRepaintBoundary?;
    if (boundary == null) return null;
    final imagen = await boundary.toImage(pixelRatio: 2);
    final byteData = await imagen.toByteData(format: ui.ImageByteFormat.png);
    return byteData?.buffer.asUint8List();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PaletaCuaderno.papelClaro,
      appBar: AppBar(
        title: widget.tituloAppBar == null ? null : Text(widget.tituloAppBar!),
        backgroundColor: PaletaCuaderno.papelClaro,
        actions: [
          IconButton(
            tooltip: 'deshacer',
            onPressed: _hayTrazos ? _deshacerUltimoTrazo : null,
            icon: const Icon(Icons.undo),
          ),
          IconButton(
            tooltip: 'borrar y empezar otra vez',
            onPressed: _hayTrazos ? _borrarTodo : null,
            icon: const Icon(Icons.refresh),
          ),
          TextButton(
            onPressed: _hayTrazos ? _guardarYSalir : null,
            child: const Text('guardar dibujo'),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            _BarraAnchoTrazo(
              anchoActual: _anchoActual,
              alElegir: _cambiarAncho,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: RepaintBoundary(
                  key: _claveRepaint,
                  child: Container(
                    color: PaletaCuaderno.papelClaro,
                    child: Listener(
                      key: const ValueKey('superficie-lienzo'),
                      // Listener capta eventos del puntero RAW, sin
                      // pasar por la gesture arena. Antes esto era un
                      // GestureDetector con onPanStart/onPanUpdate,
                      // pero en MIUI (y otros Android con gestos de
                      // navegación por borde) la arena se llevaba el
                      // pan a "pop de pantalla" y el lienzo no
                      // recibía nada — el niño veía la pantalla pero
                      // no podía dibujar. Listener no compite, recibe
                      // todos los eventos.
                      behavior: HitTestBehavior.opaque,
                      onPointerDown: _alPunteroPresionar,
                      onPointerMove: _alPunteroMover,
                      onPointerUp: _alPunteroLevantar,
                      child: CustomPaint(
                        painter: _PintorLienzo(_trazos),
                        size: Size.infinite,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Banda discreta sobre el lienzo con tres muestras del trazo. La
/// muestra activa va destacada con un fondo `papelMedio`; las otras
/// quedan transparentes. Sin etiquetas de texto — el ancho dibujado es
/// la propia indicación.
class _BarraAnchoTrazo extends StatelessWidget {
  const _BarraAnchoTrazo({
    required this.anchoActual,
    required this.alElegir,
  });

  final AnchoTrazo anchoActual;
  final void Function(AnchoTrazo) alElegir;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          for (final ancho in AnchoTrazo.values) ...[
            _MuestraAncho(
              ancho: ancho,
              activo: ancho == anchoActual,
              alPulsar: () => alElegir(ancho),
            ),
            const SizedBox(width: 12),
          ],
        ],
      ),
    );
  }
}

class _MuestraAncho extends StatelessWidget {
  const _MuestraAncho({
    required this.ancho,
    required this.activo,
    required this.alPulsar,
  });

  final AnchoTrazo ancho;
  final bool activo;
  final VoidCallback alPulsar;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: activo,
      label: switch (ancho) {
        AnchoTrazo.fino => 'trazo fino',
        AnchoTrazo.medio => 'trazo medio',
        AnchoTrazo.grueso => 'trazo grueso',
      },
      child: InkWell(
        onTap: alPulsar,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 56,
          height: 36,
          decoration: BoxDecoration(
            color: activo ? PaletaCuaderno.papelMedio : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: activo
                  ? PaletaCuaderno.tintaTenue
                  : PaletaCuaderno.papelOscuro,
              width: 1,
            ),
          ),
          child: CustomPaint(
            painter: _PintorMuestraAncho(ancho.pixeles),
          ),
        ),
      ),
    );
  }
}

class _PintorMuestraAncho extends CustomPainter {
  _PintorMuestraAncho(this.ancho);
  final double ancho;

  @override
  void paint(Canvas canvas, Size size) {
    final pintura = Paint()
      ..color = PaletaCuaderno.tinta
      ..strokeWidth = ancho
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final mediaY = size.height / 2;
    canvas.drawLine(
      Offset(8, mediaY),
      Offset(size.width - 8, mediaY),
      pintura,
    );
  }

  @override
  bool shouldRepaint(covariant _PintorMuestraAncho viejo) =>
      viejo.ancho != ancho;
}

class _PintorLienzo extends CustomPainter {
  _PintorLienzo(this.trazos);

  final List<_Trazo> trazos;

  @override
  void paint(Canvas canvas, Size size) {
    for (final trazo in trazos) {
      if (trazo.puntos.isEmpty) continue;
      final pintura = Paint()
        ..color = PaletaCuaderno.tinta
        ..strokeWidth = trazo.ancho.pixeles
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..style = PaintingStyle.stroke;
      if (trazo.puntos.length == 1) {
        canvas.drawCircle(
          trazo.puntos.first,
          trazo.ancho.pixeles / 2,
          pintura..style = PaintingStyle.fill,
        );
        continue;
      }
      final ruta = Path()..moveTo(trazo.puntos.first.dx, trazo.puntos.first.dy);
      for (var indice = 1; indice < trazo.puntos.length; indice++) {
        ruta.lineTo(trazo.puntos[indice].dx, trazo.puntos[indice].dy);
      }
      canvas.drawPath(ruta, pintura);
    }
  }

  @override
  bool shouldRepaint(covariant _PintorLienzo viejo) {
    if (viejo.trazos.length != trazos.length) return true;
    if (trazos.isNotEmpty &&
        viejo.trazos.last.puntos.length != trazos.last.puntos.length) {
      return true;
    }
    return false;
  }
}
