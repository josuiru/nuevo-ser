import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../dominio/fragmento.dart';
import 'particulas_rotura.dart';
import 'pintor_fragmento.dart';

/// Lienzo central del combate. Dibuja el Fragmento (con cara reactiva)
/// encima del fondo de la pantalla, y superpone las partículas cuando
/// [progresoRotura] es > 0.
class LienzoCombate extends StatefulWidget {
  final FragmentoUnitario fragmento;
  final List<RadioTrazado> radiosConfirmados;
  final RadioTrazado? radioEnCurso;
  final EstadoFragmento estadoFragmento;
  final bool destacarExito;
  final bool destacarFallo;
  final bool aceptaNuevosTrazos;
  final double progresoRotura;
  final double opacidadAparicion;
  final List<Particula> particulasRotura;
  final ValueChanged<RadioTrazado> onAgregarRadio;
  final ValueChanged<RadioTrazado?> onActualizarRadioEnCurso;

  /// Si el niño empieza a arrastrar encima de un radio ya confirmado, en
  /// lugar de iniciar un trazo nuevo se reposiciona ese radio: cada update
  /// llama a este callback con el índice y el nuevo ángulo. Opcional: si
  /// la pantalla no lo cablea, el arrastre encima de un radio cae en el
  /// flujo normal (trazo nuevo) y el botón Deshacer sigue siendo la única
  /// vía para corregir.
  final void Function(int indice, RadioTrazado nuevo)? onMoverRadio;

  const LienzoCombate({
    super.key,
    required this.fragmento,
    required this.radiosConfirmados,
    required this.radioEnCurso,
    required this.estadoFragmento,
    required this.destacarExito,
    required this.destacarFallo,
    required this.aceptaNuevosTrazos,
    required this.progresoRotura,
    required this.opacidadAparicion,
    required this.particulasRotura,
    required this.onAgregarRadio,
    required this.onActualizarRadioEnCurso,
    this.onMoverRadio,
  });

  @override
  State<LienzoCombate> createState() => _LienzoCombateState();
}

class _LienzoCombateState extends State<LienzoCombate>
    with SingleTickerProviderStateMixin {
  final GlobalKey _claveLienzo = GlobalKey();
  late AnimationController _controladorLatido;
  Offset? _puntoDedo;
  // Si el gesto actual está reposicionando un radio existente, guardamos
  // su índice. null = trazo nuevo (comportamiento clásico).
  int? _indiceMoviendo;

  @override
  void initState() {
    super.initState();
    _controladorLatido = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _controladorLatido.dispose();
    super.dispose();
  }

  Offset _centroDelLienzo() {
    final objetoRender =
        _claveLienzo.currentContext?.findRenderObject() as RenderBox?;
    if (objetoRender == null) return Offset.zero;
    return Offset(
      objetoRender.size.width / 2,
      objetoRender.size.height / 2,
    );
  }

  /// Snap angular: si el ángulo del dedo cae a menos de [_radSnap] de
  /// alguna de las 12 marcas tipo reloj (cada 30°, alineadas con las
  /// pintadas en `PintorFragmento`), ajustamos exactamente a esa marca.
  /// Para denominadores divisibles por 12 (2/3/4/6/12) las marcas
  /// alinean perfecto y el imán da una sensación de "click". Para 5/7/8
  /// el snap es estrecho a propósito (≈5°) y no interfiere — el niño
  /// usa las marcas solo como referencia visual.
  static const double _radSnap = 5 * math.pi / 180; // 5° en radianes
  static const int _totalMarcas = 12;

  double _snapAMarcaSiCerca(double anguloRad) {
    // Las marcas se pintan en `-π/2 + i·(2π/12)`. Recorremos las 12 y
    // nos quedamos con la más cercana si está dentro del umbral.
    const paso = 2 * math.pi / _totalMarcas;
    var mejorAngulo = anguloRad;
    var mejorDistancia = double.infinity;
    for (var i = 0; i < _totalMarcas; i++) {
      final anguloMarca = -math.pi / 2 + i * paso;
      // Diferencia angular mínima en módulo 2π.
      var delta = (anguloRad - anguloMarca).abs() % (2 * math.pi);
      if (delta > math.pi) delta = 2 * math.pi - delta;
      if (delta < mejorDistancia) {
        mejorDistancia = delta;
        mejorAngulo = anguloMarca;
      }
    }
    return mejorDistancia <= _radSnap ? mejorAngulo : anguloRad;
  }

  RadioTrazado _anguloDesdePunto(Offset punto) {
    final centro = _centroDelLienzo();
    final dx = punto.dx - centro.dx;
    final dy = punto.dy - centro.dy;
    return RadioTrazado(_snapAMarcaSiCerca(math.atan2(dy, dx)));
  }

  /// Umbral angular para "agarrar" un radio existente al iniciar arrastre.
  /// Generoso (12°) porque los dedos de los niños no son precisos sobre
  /// una línea fina. Si el dedo arranca a más de 12° de cualquier radio
  /// confirmado, se interpreta como trazo nuevo.
  static const double _radAgarre = 12 * math.pi / 180;

  /// Devuelve el índice del radio confirmado más cercano al punto, o null
  /// si ninguno está dentro del umbral angular de agarre.
  int? _indiceRadioCerca(Offset punto) {
    if (widget.radiosConfirmados.isEmpty) return null;
    final centro = _centroDelLienzo();
    final anguloPunto = math.atan2(punto.dy - centro.dy, punto.dx - centro.dx);
    int? mejorIndice;
    var mejorDistancia = double.infinity;
    for (var i = 0; i < widget.radiosConfirmados.length; i++) {
      var delta = (anguloPunto - widget.radiosConfirmados[i].anguloRad).abs() %
          (2 * math.pi);
      if (delta > math.pi) delta = 2 * math.pi - delta;
      if (delta < mejorDistancia) {
        mejorDistancia = delta;
        mejorIndice = i;
      }
    }
    return mejorDistancia <= _radAgarre ? mejorIndice : null;
  }

  void _alIniciarTrazo(DragStartDetails detalle) {
    setState(() => _puntoDedo = detalle.localPosition);
    // Primero: ¿el dedo arranca encima de un radio existente? Si sí y la
    // pantalla cablea onMoverRadio, agarramos ese radio para reposicionar
    // (no se crea un trazo nuevo). Esto funciona incluso con el objetivo
    // ya cubierto, porque mover no añade radios.
    final alMover = widget.onMoverRadio;
    if (alMover != null) {
      final indice = _indiceRadioCerca(detalle.localPosition);
      if (indice != null) {
        HapticFeedback.lightImpact();
        setState(() => _indiceMoviendo = indice);
        return;
      }
    }
    if (!widget.aceptaNuevosTrazos) return;
    widget.onActualizarRadioEnCurso(_anguloDesdePunto(detalle.localPosition));
  }

  void _alActualizarTrazo(DragUpdateDetails detalle) {
    setState(() => _puntoDedo = detalle.localPosition);
    final indiceMov = _indiceMoviendo;
    if (indiceMov != null) {
      widget.onMoverRadio?.call(
        indiceMov,
        _anguloDesdePunto(detalle.localPosition),
      );
      return;
    }
    if (!widget.aceptaNuevosTrazos) return;
    widget.onActualizarRadioEnCurso(_anguloDesdePunto(detalle.localPosition));
  }

  void _alTerminarTrazo(DragEndDetails detalle) {
    setState(() => _puntoDedo = null);
    if (_indiceMoviendo != null) {
      setState(() => _indiceMoviendo = null);
      return;
    }
    final radio = widget.radioEnCurso;
    widget.onActualizarRadioEnCurso(null);
    if (radio == null) return;
    if (!widget.aceptaNuevosTrazos) return;
    widget.onAgregarRadio(radio);
  }

  double _opacidadFragmento() {
    final progreso = widget.progresoRotura;
    final opacidadRotura = progreso <= 0
        ? 1.0
        : progreso >= 0.3
            ? 0.0
            : 1.0 - (progreso / 0.3);
    return opacidadRotura * widget.opacidadAparicion;
  }

  double _escalaAparicion() {
    // Aparecemos levemente más pequeños y crecemos hasta 1.0 al materializar.
    return 0.88 + widget.opacidadAparicion * 0.12;
  }

  @override
  Widget build(BuildContext contexto) {
    return GestureDetector(
      onPanStart: _alIniciarTrazo,
      onPanUpdate: _alActualizarTrazo,
      onPanEnd: _alTerminarTrazo,
      child: AnimatedBuilder(
        animation: _controladorLatido,
        builder: (_, __) {
          return Stack(
            fit: StackFit.expand,
            children: [
              Transform.scale(
                scale: _escalaAparicion(),
                child: CustomPaint(
                  key: _claveLienzo,
                  painter: PintorFragmento(
                    fragmento: widget.fragmento,
                    fasesLatido: _controladorLatido.value,
                    radiosConfirmados: widget.radiosConfirmados,
                    radioEnCurso: widget.radioEnCurso,
                    estado: widget.estadoFragmento,
                    puntoDeAtencion: _puntoDedo,
                    destacarExito: widget.destacarExito,
                    destacarFallo: widget.destacarFallo,
                    opacidad: _opacidadFragmento(),
                  ),
                  size: Size.infinite,
                ),
              ),
              if (widget.progresoRotura > 0 && widget.progresoRotura < 1)
                IgnorePointer(
                  child: CustomPaint(
                    painter: PintorRotura(
                      progreso: widget.progresoRotura,
                      particulas: widget.particulasRotura,
                    ),
                    size: Size.infinite,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
