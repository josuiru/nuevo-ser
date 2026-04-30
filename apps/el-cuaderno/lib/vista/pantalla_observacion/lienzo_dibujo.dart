import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../tema/colores.dart';

/// Pantalla del lienzo de dibujo del cuaderno (biblia §3.2 — el niño
/// puede registrar lo observado dibujándolo además de escribiéndolo).
///
/// **MVP** — UX rica con paletas, presión variable, deshacer
/// multi-paso, capas, queda para B6 (decisión ilustradora) según el
/// plan. Esta versión es deliberadamente espartana:
///
/// - Una sola tinta negra de 3 px sobre el papel claro de la paleta.
/// - Gestos de pan: cada arrastre añade un trazo a la lista; al
///   levantar el dedo el trazo se cierra.
/// - Botón "borrar y empezar otra vez" que vacía todos los trazos.
/// - Botón "guardar dibujo" que renderiza el lienzo a PNG con
///   `RepaintBoundary.toImage()` y devuelve los bytes vía
///   `Navigator.pop`. La pantalla que abrió el lienzo es la
///   responsable de pasar esos bytes al `AlmacenadorMedios`.
///
/// Si el niño cierra la pantalla sin guardar (botón atrás del
/// AppBar), el dibujo se descarta. No hay autoguardado: la biblia §2.7
/// prohíbe interrumpir al niño con confirmaciones que no haya pedido.
class PantallaLienzoDibujo extends StatefulWidget {
  const PantallaLienzoDibujo({super.key, this.tituloAppBar});

  /// Título opcional. Por defecto el AppBar muestra solo los botones.
  final String? tituloAppBar;

  @override
  State<PantallaLienzoDibujo> createState() => _EstadoPantallaLienzoDibujo();
}

class _EstadoPantallaLienzoDibujo extends State<PantallaLienzoDibujo> {
  /// Cada elemento es la secuencia de puntos de un trazo (un pan).
  /// Una lista vacía interna nunca se inserta — solo añadimos el primer
  /// punto en `onPanStart`.
  final List<List<Offset>> _trazos = [];

  /// Clave del `RepaintBoundary` para poder pedir su `toImage()`.
  final GlobalKey _claveRepaint = GlobalKey();

  bool get _hayTrazos => _trazos.isNotEmpty;

  void _alIniciarTrazo(DragStartDetails detalles) {
    setState(() {
      _trazos.add(<Offset>[detalles.localPosition]);
    });
  }

  void _alContinuarTrazo(DragUpdateDetails detalles) {
    setState(() {
      _trazos.last.add(detalles.localPosition);
    });
  }

  void _borrarTodo() {
    if (!_hayTrazos) return;
    setState(_trazos.clear);
  }

  Future<void> _guardarYSalir() async {
    if (!_hayTrazos) return;
    final bytes = await _exportarComoPng();
    if (bytes == null) return;
    if (!mounted) return;
    Navigator.of(context).pop(bytes);
  }

  /// Renderiza el RepaintBoundary del lienzo a PNG con `pixelRatio: 2`
  /// para que el dibujo siga legible si se proyecta a otro tamaño.
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
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: RepaintBoundary(
            key: _claveRepaint,
            child: Container(
              color: PaletaCuaderno.papelClaro,
              child: GestureDetector(
                onPanStart: _alIniciarTrazo,
                onPanUpdate: _alContinuarTrazo,
                child: CustomPaint(
                  painter: _PintorLienzo(_trazos),
                  size: Size.infinite,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PintorLienzo extends CustomPainter {
  _PintorLienzo(this.trazos);

  final List<List<Offset>> trazos;

  @override
  void paint(Canvas canvas, Size size) {
    final pintura = Paint()
      ..color = PaletaCuaderno.tinta
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    for (final trazo in trazos) {
      if (trazo.isEmpty) continue;
      if (trazo.length == 1) {
        // Un punto solo se dibuja como un círculo pequeño para que se
        // vea (un Path con un único punto no renderiza con stroke).
        canvas.drawCircle(trazo.first, 1.5, pintura..style = PaintingStyle.fill);
        pintura.style = PaintingStyle.stroke;
        continue;
      }
      final ruta = Path()..moveTo(trazo.first.dx, trazo.first.dy);
      for (var indice = 1; indice < trazo.length; indice++) {
        ruta.lineTo(trazo[indice].dx, trazo[indice].dy);
      }
      canvas.drawPath(ruta, pintura);
    }
  }

  @override
  bool shouldRepaint(covariant _PintorLienzo viejo) {
    // Repaint barato — comparamos identidad de la lista. Como cada
    // setState reemplaza/extiende la lista en sitio, la referencia
    // muta pero la lista sigue siendo la misma; comparamos longitudes
    // del último trazo y del total para decidir.
    if (viejo.trazos.length != trazos.length) return true;
    if (trazos.isNotEmpty &&
        viejo.trazos.last.length != trazos.last.length) {
      return true;
    }
    return false;
  }
}
