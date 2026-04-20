import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../dominio/fragmento.dart';
import 'pintor_fragmento.dart';

/// Lienzo central del combate. Widget "tonto": recibe la lista de radios
/// confirmados y el radio en curso desde el padre, y solo:
///
/// 1. Dibuja el Fragmento con sus trazos.
/// 2. Detecta nuevos gestos y los reporta al padre mediante callbacks.
///
/// Toda la lógica de estado (acumular, deshacer, evaluar) vive en
/// [PantallaCombate] para que los botones de la UI puedan actuar sobre
/// la misma fuente de verdad.
class LienzoCombate extends StatefulWidget {
  final FragmentoUnitario fragmento;
  final List<RadioTrazado> radiosConfirmados;
  final RadioTrazado? radioEnCurso;
  final bool destacarExito;
  final bool destacarFallo;
  final bool aceptaNuevosTrazos;
  final ValueChanged<RadioTrazado> onAgregarRadio;
  final ValueChanged<RadioTrazado?> onActualizarRadioEnCurso;

  const LienzoCombate({
    super.key,
    required this.fragmento,
    required this.radiosConfirmados,
    required this.radioEnCurso,
    required this.destacarExito,
    required this.destacarFallo,
    required this.aceptaNuevosTrazos,
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
    if (!widget.aceptaNuevosTrazos) return;
    widget.onActualizarRadioEnCurso(_anguloDesdePunto(detalle.localPosition));
  }

  void _alActualizarTrazo(DragUpdateDetails detalle) {
    if (!widget.aceptaNuevosTrazos) return;
    widget.onActualizarRadioEnCurso(_anguloDesdePunto(detalle.localPosition));
  }

  void _alTerminarTrazo(DragEndDetails detalle) {
    final radio = widget.radioEnCurso;
    widget.onActualizarRadioEnCurso(null);
    if (radio == null) return;
    if (!widget.aceptaNuevosTrazos) return;
    widget.onAgregarRadio(radio);
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
          return CustomPaint(
            key: _claveLienzo,
            painter: PintorFragmento(
              fragmento: widget.fragmento,
              fasesLatido: _controladorLatido.value,
              radiosConfirmados: widget.radiosConfirmados,
              radioEnCurso: widget.radioEnCurso,
              destacarExito: widget.destacarExito,
              destacarFallo: widget.destacarFallo,
            ),
            size: Size.infinite,
          );
        },
      ),
    );
  }
}
