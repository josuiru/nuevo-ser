import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../dominio/plano_escena.dart';
import '../nucleo/paleta.dart';

/// Widget del Fragmento Pleno usado en el tutorial (escena 1.2). Puede
/// estar:
/// - entero con el número 1 flotando encima,
/// - dividido en dos mitades con 1/2 cada una,
/// - con solo una mitad (tras desfragmentar la otra),
/// - vacío (tras desfragmentar las dos).
///
/// Notifica al padre cuando el niño completa la [accionEsperada].
class WidgetFragmentoTutorial extends StatefulWidget {
  final AccionEsperada accionEsperada;
  final EstadoFragmentoTutorial estadoInicial;
  final VoidCallback alCompletar;

  const WidgetFragmentoTutorial({
    super.key,
    required this.accionEsperada,
    required this.estadoInicial,
    required this.alCompletar,
  });

  @override
  State<WidgetFragmentoTutorial> createState() =>
      _WidgetFragmentoTutorialState();
}

class _WidgetFragmentoTutorialState extends State<WidgetFragmentoTutorial>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controladorPulso;
  late EstadoFragmentoTutorial _estado;

  @override
  void initState() {
    super.initState();
    _estado = widget.estadoInicial;
    _controladorPulso = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controladorPulso.dispose();
    super.dispose();
  }

  void _alDividir() {
    if (widget.accionEsperada != AccionEsperada.dividirPleno) return;
    if (_estado != EstadoFragmentoTutorial.plenoCompleto) return;
    HapticFeedback.mediumImpact();
    setState(() => _estado = EstadoFragmentoTutorial.dosMitades);
    Future.delayed(
      const Duration(milliseconds: 700),
      widget.alCompletar,
    );
  }

  void _alDesfragmentarMitad(bool izquierda) {
    if (widget.accionEsperada != AccionEsperada.desfragmentarMitades) return;
    HapticFeedback.selectionClick();
    setState(() {
      if (_estado == EstadoFragmentoTutorial.dosMitades) {
        _estado = EstadoFragmentoTutorial.unaMitad;
      } else if (_estado == EstadoFragmentoTutorial.unaMitad) {
        _estado = EstadoFragmentoTutorial.vacio;
        Future.delayed(
          const Duration(milliseconds: 500),
          widget.alCompletar,
        );
      }
    });
  }

  @override
  Widget build(BuildContext contexto) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onHorizontalDragEnd: (detalle) {
        if ((detalle.primaryVelocity ?? 0).abs() > 200) {
          _alDividir();
        }
      },
      child: SizedBox(
        width: 240,
        height: 240,
        child: Center(
          child: AnimatedBuilder(
            animation: _controladorPulso,
            builder: (_, __) {
              final pulso = 0.85 + 0.15 * _controladorPulso.value;
              return _construirEstado(pulso);
            },
          ),
        ),
      ),
    );
  }

  Widget _construirEstado(double pulso) {
    switch (_estado) {
      case EstadoFragmentoTutorial.plenoCompleto:
        return _Pleno(pulso: pulso);
      case EstadoFragmentoTutorial.dosMitades:
        return _DosMitades(
          pulso: pulso,
          izquierdaVisible: true,
          derechaVisible: true,
          alTocarIzquierda: () => _alDesfragmentarMitad(true),
          alTocarDerecha: () => _alDesfragmentarMitad(false),
        );
      case EstadoFragmentoTutorial.unaMitad:
        return _DosMitades(
          pulso: pulso,
          izquierdaVisible: false,
          derechaVisible: true,
          alTocarIzquierda: () {},
          alTocarDerecha: () => _alDesfragmentarMitad(false),
        );
      case EstadoFragmentoTutorial.vacio:
        return const SizedBox.shrink();
    }
  }
}

class _Pleno extends StatelessWidget {
  final double pulso;

  const _Pleno({required this.pulso});

  @override
  Widget build(BuildContext contexto) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 160 * pulso,
          height: 160 * pulso,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                PaletaNeon.textoPrincipal.withOpacity(0.85),
                PaletaNeon.azulNeon.withOpacity(0.4),
                PaletaNeon.fondoMedio.withOpacity(0.0),
              ],
              stops: const [0.2, 0.7, 1.0],
            ),
            boxShadow: [
              BoxShadow(
                color: PaletaNeon.azulNeon.withOpacity(0.25),
                blurRadius: 32,
                spreadRadius: 4,
              ),
            ],
          ),
        ),
        const Text(
          '1',
          style: TextStyle(
            fontSize: 46,
            fontWeight: FontWeight.w300,
            color: PaletaNeon.fondoProfundo,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }
}

class _DosMitades extends StatelessWidget {
  final double pulso;
  final bool izquierdaVisible;
  final bool derechaVisible;
  final VoidCallback alTocarIzquierda;
  final VoidCallback alTocarDerecha;

  const _DosMitades({
    required this.pulso,
    required this.izquierdaVisible,
    required this.derechaVisible,
    required this.alTocarIzquierda,
    required this.alTocarDerecha,
  });

  @override
  Widget build(BuildContext contexto) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (izquierdaVisible)
          _Mitad(
            pulso: pulso,
            ladoIzquierdo: true,
            alTocar: alTocarIzquierda,
          ),
        const SizedBox(width: 6),
        if (derechaVisible)
          _Mitad(
            pulso: pulso,
            ladoIzquierdo: false,
            alTocar: alTocarDerecha,
          ),
      ],
    );
  }
}

class _Mitad extends StatelessWidget {
  final double pulso;
  final bool ladoIzquierdo;
  final VoidCallback alTocar;

  const _Mitad({
    required this.pulso,
    required this.ladoIzquierdo,
    required this.alTocar,
  });

  @override
  Widget build(BuildContext contexto) {
    return GestureDetector(
      onTap: alTocar,
      child: SizedBox(
        width: 80 * pulso,
        height: 160 * pulso,
        child: CustomPaint(
          painter: _PintorMitad(ladoIzquierdo: ladoIzquierdo),
          child: const Center(
            child: Text(
              '1/2',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w400,
                color: PaletaNeon.fondoProfundo,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PintorMitad extends CustomPainter {
  final bool ladoIzquierdo;

  _PintorMitad({required this.ladoIzquierdo});

  @override
  void paint(Canvas canvas, Size size) {
    final pintura = Paint()
      ..shader = RadialGradient(
        colors: [
          PaletaNeon.textoPrincipal.withOpacity(0.85),
          PaletaNeon.azulNeon.withOpacity(0.4),
          PaletaNeon.fondoMedio.withOpacity(0.0),
        ],
        stops: const [0.2, 0.7, 1.0],
      ).createShader(Offset.zero & size);
    final caminoMitad = Path()
      ..moveTo(
        ladoIzquierdo ? size.width : 0,
        0,
      )
      ..lineTo(
        ladoIzquierdo ? size.width : 0,
        size.height,
      )
      ..arcTo(
        Rect.fromCircle(
          center: Offset(size.width / 2, size.height / 2),
          radius: math.min(size.width, size.height / 2),
        ),
        ladoIzquierdo ? math.pi / 2 : -math.pi / 2,
        math.pi,
        false,
      )
      ..close();
    canvas.drawPath(caminoMitad, pintura);
  }

  @override
  bool shouldRepaint(_PintorMitad anterior) =>
      anterior.ladoIzquierdo != ladoIzquierdo;
}
