import 'dart:math' as math;

import 'package:flutter/material.dart';

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
  });

  @override
  State<LienzoCombate> createState() => _LienzoCombateState();
}

class _LienzoCombateState extends State<LienzoCombate>
    with SingleTickerProviderStateMixin {
  final GlobalKey _claveLienzo = GlobalKey();
  late AnimationController _controladorLatido;
  Offset? _puntoDedo;

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

  RadioTrazado _anguloDesdePunto(Offset punto) {
    final centro = _centroDelLienzo();
    final dx = punto.dx - centro.dx;
    final dy = punto.dy - centro.dy;
    return RadioTrazado(math.atan2(dy, dx));
  }

  void _alIniciarTrazo(DragStartDetails detalle) {
    setState(() => _puntoDedo = detalle.localPosition);
    if (!widget.aceptaNuevosTrazos) return;
    widget.onActualizarRadioEnCurso(_anguloDesdePunto(detalle.localPosition));
  }

  void _alActualizarTrazo(DragUpdateDetails detalle) {
    setState(() => _puntoDedo = detalle.localPosition);
    if (!widget.aceptaNuevosTrazos) return;
    widget.onActualizarRadioEnCurso(_anguloDesdePunto(detalle.localPosition));
  }

  void _alTerminarTrazo(DragEndDetails detalle) {
    final radio = widget.radioEnCurso;
    widget.onActualizarRadioEnCurso(null);
    setState(() => _puntoDedo = null);
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
