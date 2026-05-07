import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../nucleo/i18n/generado/textos_app.dart';
import '../tema/colores.dart';

/// Pantalla del lienzo de dibujo del cuaderno (biblia §3.2 — el niño
/// puede registrar lo observado dibujándolo además de escribiéndolo).
///
/// Versión enriquecida (B6). **Decisión cerrada por el operador
/// 2026-05** con razón pedagógica explícita; ya no está pendiente de
/// validación por ilustradora externa porque el lienzo del niño es
/// por definición hecho a mano (el niño dibuja con el dedo) — la
/// prescripción "NUNCA IA generativa, hecho a mano" de biblia §8.1
/// se refiere a las **ilustraciones del catálogo de Misterios**, que
/// son contenido editorial y sí esperan encargo real cuando llegue.
/// Para el lienzo, la decisión de paleta y herramientas la cierra el
/// operador con criterio de cuaderno de campo naturalista.
///
/// El lienzo es deliberadamente sobrio: paleta limitada de cinco
/// tonos terrosos del cuaderno de campo histórico (tinta, sanguina,
/// sepia, ocre, verde botánico), sin saturaciones digitales, sin
/// pinceles, sin capas, sin efectos.
///
/// **Razón pedagógica del cambio "una sola tinta" → paleta limitada**
/// (registrado en `docs/el-cuaderno/decisiones-provisionales.md`):
///
/// El naturalista profesional **no trabaja en monocromo**. John Muir
/// Laws (*Laws Guide to Nature Drawing*), Roger Tory Peterson y los
/// dibujos botánicos de Anita Albus llevan paletas limitadas de tonos
/// terrosos porque el color es **diagnóstico**: un mirlo común y un
/// escribano cerillo se diferencian por su color, no por su silueta.
/// Forzar al niño a dibujar todo en negro le quita una herramienta
/// central de identificación y lo aleja del oficio que el cuaderno
/// pretende enseñar (biblia §3.3 identificar con humildad).
///
/// La paleta elegida emula los lápices de colores que un naturalista
/// llevaría en la mochila — terrosos, no saturados. Los hex se eligen
/// para encajar con el tono crema del papel del cuaderno
/// (`PaletaCuaderno.papelClaro` #F5EFE2) sin disonar.
///
/// **Lo que se mantiene de la biblia §8.1**: hecho a mano (sin IA
/// generativa), sin pinceles digitales, sin efectos, sin gradientes,
/// sin rellenos, sin capas, sin texto. El lienzo sigue siendo un
/// cuaderno, no un editor de imagen.
///
/// Diferencias con la versión MVP (A4):
/// - Tres anchos de trazo seleccionables (fino 1.5 px, medio 3 px,
///   grueso 6 px). Cada trazo guarda su propio ancho.
/// - Cinco colores seleccionables (tinta/sanguina/sepia/ocre/verde
///   botánico). Cada trazo guarda su propio color.
/// - Deshacer último trazo (Icons.undo en AppBar). No es multi-paso
///   ilimitado: respeta el principio de "sin fanfarria" — un undo
///   simple es suficiente para corregir un mal trazo.
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

/// Tres herramientas de trazo + goma. Ortogonal al color y al ancho.
/// Cada herramienta cambia opacidad y/o multiplicador de ancho del
/// trazo dibujado, simulando la textura del lapicero/carboncillo sin
/// recurrir a shaders. La goma no dibuja: en su modo, tocar un trazo
/// lo retira de la pila.
enum Herramienta {
  /// Trazo limpio, opacidad 100%, ancho exacto. Equivalente a la
  /// plumilla negra del cuaderno de campo clásico.
  plumilla(opacidad: 1.0, multiplicadorAncho: 1.0),

  /// Trazo suave, opacidad ~50%, ancho exacto. Simula el lápiz HB
  /// que el naturalista usa para bocetar antes de fijar con tinta.
  lapicero(opacidad: 0.5, multiplicadorAncho: 1.0),

  /// Trazo grueso semitransparente, ancho × 1.5, opacidad ~70%.
  /// Simula el carboncillo o el lápiz blando 4B-6B. La textura
  /// granulosa real requiere shader; aquí se aproxima visualmente
  /// con grosor + transparencia.
  carboncillo(opacidad: 0.7, multiplicadorAncho: 1.5),

  /// La goma no añade trazo; al tocar un trazo existente, lo
  /// retira de la pila. Reversible con undo.
  goma(opacidad: 0, multiplicadorAncho: 0);

  const Herramienta({
    required this.opacidad,
    required this.multiplicadorAncho,
  });

  final double opacidad;
  final double multiplicadorAncho;

  /// `true` si la herramienta dibuja (cualquier menos goma).
  bool get pinta => this != Herramienta.goma;
}

/// Paleta limitada del cuaderno de campo. Cinco tonos terrosos no
/// saturados que emulan los lápices de colores del naturalista. Los
/// hex se eligen para encajar con el tono crema del papel del
/// cuaderno sin disonar — ningún rosa fucsia, ningún azul eléctrico,
/// ningún verde fluorescente. Ver razón pedagógica en el doc-string
/// de [PantallaLienzoDibujo].
enum ColorTrazo {
  /// Negro carbón — equivalente al carboncillo o la plumilla negra.
  /// Para silueta y línea principal. Es el color por defecto.
  tinta(Color(0xFF2A2A2A)),

  /// Rojo terroso — emula el lápiz Sanguine de la tradición clásica.
  /// Para detalles vivos: una mancha del pecho del petirrojo, una
  /// flor roja, una marca diagnóstica.
  sanguina(Color(0xFF8B3A3A)),

  /// Marrón cálido — emula el lápiz Sepia. Para troncos, ramas,
  /// plumas pardas, suelo.
  sepia(Color(0xFF5C4033)),

  /// Amarillo apagado — emula el ocre amarillo. Para flores
  /// amarillas, frutos maduros, marcas amarillas en aves.
  ocre(Color(0xFFB8860B)),

  /// Verde apagado tipo lago verde Winsor & Newton. Para hojas,
  /// líquenes, musgo. Deliberadamente desaturado para no romper el
  /// tono del cuaderno botánico.
  verdeBotanico(Color(0xFF3A5F3A));

  const ColorTrazo(this.color);
  final Color color;
}

class _Trazo {
  _Trazo({
    required this.ancho,
    required this.color,
    required this.herramienta,
  }) : puntos = <Offset>[];
  final AnchoTrazo ancho;
  final ColorTrazo color;
  final Herramienta herramienta;
  final List<Offset> puntos;
}

class _EstadoPantallaLienzoDibujo extends State<PantallaLienzoDibujo> {
  final List<_Trazo> _trazos = [];
  final GlobalKey _claveRepaint = GlobalKey();

  AnchoTrazo _anchoActual = AnchoTrazo.medio;
  ColorTrazo _colorActual = ColorTrazo.tinta;
  Herramienta _herramientaActual = Herramienta.plumilla;

  bool get _hayTrazos => _trazos.isNotEmpty;

  /// Punto inicial del trazo en curso. Lo guardamos al PointerDown
  /// para insertarlo solo si el usuario llega a moverse (PointerMove)
  /// — así un tap suelto sin movimiento no deja un puntito en la
  /// pantalla.
  Offset? _puntoInicialPendiente;

  void _alPunteroPresionar(PointerDownEvent evento) {
    if (_herramientaActual == Herramienta.goma) {
      _borrarTrazoEnPunto(evento.localPosition);
      return;
    }
    _puntoInicialPendiente = evento.localPosition;
  }

  void _alPunteroMover(PointerMoveEvent evento) {
    if (_herramientaActual == Herramienta.goma) {
      // En modo goma, arrastrar también borra los trazos que el
      // dedo cruza. Cómodo para limpiar varios trazos seguidos.
      _borrarTrazoEnPunto(evento.localPosition);
      return;
    }
    setState(() {
      // Si llega el primer move sin trazo abierto, abrimos uno con
      // el punto inicial guardado (o con la posición actual si el
      // PointerDown no pasó por aquí — caso raro de tester).
      if (_puntoInicialPendiente != null) {
        final trazo = _Trazo(
          ancho: _anchoActual,
          color: _colorActual,
          herramienta: _herramientaActual,
        )..puntos.add(_puntoInicialPendiente!);
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

  /// En modo goma, retira el primer trazo cuya banda (ancho efectivo
  /// + 8 px de margen para que sea fácil acertar con el dedo) toque
  /// el punto. Si no toca ninguno, no hace nada — silencioso.
  void _borrarTrazoEnPunto(Offset punto) {
    for (var indice = _trazos.length - 1; indice >= 0; indice--) {
      final trazo = _trazos[indice];
      final radio = trazo.ancho.pixeles *
              trazo.herramienta.multiplicadorAncho /
              2 +
          8;
      for (final p in trazo.puntos) {
        if ((p - punto).distanceSquared <= radio * radio) {
          setState(() => _trazos.removeAt(indice));
          return;
        }
      }
    }
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

  void _cambiarColor(ColorTrazo color) {
    if (color == _colorActual) return;
    setState(() => _colorActual = color);
  }

  void _cambiarHerramienta(Herramienta herramienta) {
    if (herramienta == _herramientaActual) return;
    setState(() => _herramientaActual = herramienta);
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
    final textos = TextosApp.of(context);
    return Scaffold(
      backgroundColor: PaletaCuaderno.papelClaro,
      appBar: AppBar(
        title: widget.tituloAppBar == null ? null : Text(widget.tituloAppBar!),
        backgroundColor: PaletaCuaderno.papelClaro,
        actions: [
          IconButton(
            tooltip: textos.lienzoTooltipDeshacer,
            onPressed: _hayTrazos ? _deshacerUltimoTrazo : null,
            icon: const Icon(Icons.undo),
          ),
          IconButton(
            tooltip: textos.lienzoTooltipBorrar,
            onPressed: _hayTrazos ? _borrarTodo : null,
            icon: const Icon(Icons.refresh),
          ),
          TextButton(
            onPressed: _hayTrazos ? _guardarYSalir : null,
            child: Text(textos.lienzoDibujoBotonGuardar),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            _BarraHerramienta(
              herramientaActual: _herramientaActual,
              alElegir: _cambiarHerramienta,
            ),
            _BarraAnchoTrazo(
              anchoActual: _anchoActual,
              alElegir: _cambiarAncho,
            ),
            _BarraColorTrazo(
              colorActual: _colorActual,
              alElegir: _cambiarColor,
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
    final textos = TextosApp.of(context);
    return Semantics(
      button: true,
      selected: activo,
      label: switch (ancho) {
        AnchoTrazo.fino => textos.lienzoAnchoFino,
        AnchoTrazo.medio => textos.lienzoAnchoMedio,
        AnchoTrazo.grueso => textos.lienzoAnchoGrueso,
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

/// Barra de selección de herramienta: plumilla, lapicero, carboncillo,
/// goma. Iconos de Material que sugieren cada función sin texto. La
/// herramienta activa va destacada con `papelMedio`. La goma cambia
/// el comportamiento del puntero a "tocar trazo lo retira".
class _BarraHerramienta extends StatelessWidget {
  const _BarraHerramienta({
    required this.herramientaActual,
    required this.alElegir,
  });

  final Herramienta herramientaActual;
  final void Function(Herramienta) alElegir;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          for (final herramienta in Herramienta.values) ...[
            _MuestraHerramienta(
              herramienta: herramienta,
              activa: herramienta == herramientaActual,
              alPulsar: () => alElegir(herramienta),
            ),
            const SizedBox(width: 12),
          ],
        ],
      ),
    );
  }
}

class _MuestraHerramienta extends StatelessWidget {
  const _MuestraHerramienta({
    required this.herramienta,
    required this.activa,
    required this.alPulsar,
  });

  final Herramienta herramienta;
  final bool activa;
  final VoidCallback alPulsar;

  IconData get _icono => switch (herramienta) {
        Herramienta.plumilla => Icons.create_outlined,
        Herramienta.lapicero => Icons.edit_outlined,
        Herramienta.carboncillo => Icons.brush_outlined,
        Herramienta.goma => Icons.cleaning_services_outlined,
      };

  String _etiqueta(TextosApp textos) => switch (herramienta) {
        Herramienta.plumilla => textos.lienzoHerramientaPlumilla,
        Herramienta.lapicero => textos.lienzoHerramientaLapicero,
        Herramienta.carboncillo => textos.lienzoHerramientaCarboncillo,
        Herramienta.goma => textos.lienzoHerramientaGoma,
      };

  @override
  Widget build(BuildContext context) {
    final textos = TextosApp.of(context);
    return Semantics(
      button: true,
      selected: activa,
      label: _etiqueta(textos),
      child: InkWell(
        onTap: alPulsar,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 44,
          height: 36,
          decoration: BoxDecoration(
            color: activa ? PaletaCuaderno.papelMedio : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: activa
                  ? PaletaCuaderno.tintaTenue
                  : PaletaCuaderno.papelOscuro,
              width: activa ? 2 : 1,
            ),
          ),
          child: Icon(
            _icono,
            size: 20,
            color: PaletaCuaderno.tinta,
          ),
        ),
      ),
    );
  }
}

/// Banda discreta sobre el lienzo con los cinco colores de la paleta
/// limitada. La muestra activa va destacada con borde más oscuro y
/// fondo `papelMedio`. Cada muestra es un círculo del color real,
/// para que el niño elija visualmente — sin etiquetas de texto,
/// igual que la barra de anchos.
class _BarraColorTrazo extends StatelessWidget {
  const _BarraColorTrazo({
    required this.colorActual,
    required this.alElegir,
  });

  final ColorTrazo colorActual;
  final void Function(ColorTrazo) alElegir;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          for (final color in ColorTrazo.values) ...[
            _MuestraColor(
              color: color,
              activo: color == colorActual,
              alPulsar: () => alElegir(color),
            ),
            const SizedBox(width: 12),
          ],
        ],
      ),
    );
  }
}

class _MuestraColor extends StatelessWidget {
  const _MuestraColor({
    required this.color,
    required this.activo,
    required this.alPulsar,
  });

  final ColorTrazo color;
  final bool activo;
  final VoidCallback alPulsar;

  @override
  Widget build(BuildContext context) {
    final textos = TextosApp.of(context);
    return Semantics(
      button: true,
      selected: activo,
      label: switch (color) {
        ColorTrazo.tinta => textos.lienzoColorTinta,
        ColorTrazo.sanguina => textos.lienzoColorSanguina,
        ColorTrazo.sepia => textos.lienzoColorSepia,
        ColorTrazo.ocre => textos.lienzoColorOcre,
        ColorTrazo.verdeBotanico => textos.lienzoColorVerdeBotanico,
      },
      child: InkWell(
        onTap: alPulsar,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: activo ? PaletaCuaderno.papelMedio : Colors.transparent,
            shape: BoxShape.circle,
            border: Border.all(
              color: activo
                  ? PaletaCuaderno.tintaTenue
                  : PaletaCuaderno.papelOscuro,
              width: activo ? 2 : 1,
            ),
          ),
          child: Center(
            child: Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: color.color,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PintorLienzo extends CustomPainter {
  /// Captura la firma del estado en construcción. La firma es un
  /// entero hash que cambia cuando: se añade/quita un trazo, se
  /// añade un punto al trazo activo, o cambia el ancho/color del
  /// último trazo.
  ///
  /// Sin esta captura, `shouldRepaint` comparaba `viejo.trazos`
  /// contra `trazos` siendo **la misma referencia mutable** — el
  /// `length` y `puntos.length` del último trazo eran idénticos en
  /// ambos lados del setState porque los punteros apuntan al mismo
  /// objeto. Resultado: el lienzo nunca se redibujaba al pasar el
  /// dedo aunque los puntos sí se acumulaban en memoria. Reportado
  /// en piloto interno como "le doy con el dedo y no se pinta nada".
  _PintorLienzo(this.trazos) : _firma = _calcularFirma(trazos);

  final List<_Trazo> trazos;
  final int _firma;

  static int _calcularFirma(List<_Trazo> trazos) {
    var firma = trazos.length;
    for (final trazo in trazos) {
      firma = firma * 31 +
          trazo.puntos.length * 7 +
          trazo.ancho.index * 3 +
          trazo.color.index * 5 +
          trazo.herramienta.index;
    }
    return firma;
  }

  @override
  void paint(Canvas canvas, Size size) {
    for (final trazo in trazos) {
      if (trazo.puntos.isEmpty) continue;
      if (!trazo.herramienta.pinta) continue; // Goma no deja trazo.
      final anchoEfectivo =
          trazo.ancho.pixeles * trazo.herramienta.multiplicadorAncho;
      final colorEfectivo =
          trazo.color.color.withAlpha((trazo.herramienta.opacidad * 255).round());
      final pintura = Paint()
        ..color = colorEfectivo
        ..strokeWidth = anchoEfectivo
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..style = PaintingStyle.stroke;
      if (trazo.puntos.length == 1) {
        canvas.drawCircle(
          trazo.puntos.first,
          anchoEfectivo / 2,
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
  bool shouldRepaint(covariant _PintorLienzo viejo) => viejo._firma != _firma;
}
