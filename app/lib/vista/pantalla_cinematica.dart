import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../dominio/escena_cinematica.dart';
import '../dominio/plano_escena.dart';
import '../dominio/voz_personaje.dart';
import '../nucleo/paleta.dart';
import 'escenario.dart';

/// Reproductor de escenas cinemáticas. Recorre los planos uno a uno
/// respetando:
/// - Silencios escritos (PlanoAmbiente auto-avanza tras su duración).
/// - Reveal letra-a-letra para diálogos (doc 13 §2.1 planos duran).
/// - Pausa entre frases del mismo personaje (pausaPrevia).
/// - Tap para completar el reveal o avanzar cuando está esperando.
/// Al terminar invoca [alTerminar].
class PantallaCinematica extends StatefulWidget {
  final EscenaCinematica escena;
  final VoidCallback alTerminar;

  const PantallaCinematica({
    super.key,
    required this.escena,
    required this.alTerminar,
  });

  @override
  State<PantallaCinematica> createState() => _PantallaCinematicaState();
}

enum _EstadoPlano { pausaPrevia, revelando, esperandoTap, saliendo }

class _PantallaCinematicaState extends State<PantallaCinematica>
    with TickerProviderStateMixin {
  static const Duration _duracionFade = Duration(milliseconds: 300);
  static const Duration _intervaloReveal = Duration(milliseconds: 32);

  late final AnimationController _controladorCielo;
  late final AnimationController _controladorFade;

  int _indicePlano = 0;
  int _caracteresRevelados = 0;
  _EstadoPlano _estado = _EstadoPlano.pausaPrevia;
  Timer? _temporizador;

  @override
  void initState() {
    super.initState();
    _controladorCielo = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 16),
    )..repeat();
    _controladorFade = AnimationController(
      vsync: this,
      duration: _duracionFade,
      value: 0,
    );
    _iniciarPlanoActual();
  }

  @override
  void dispose() {
    _controladorCielo.dispose();
    _controladorFade.dispose();
    _temporizador?.cancel();
    super.dispose();
  }

  PlanoEscena get _planoActual => widget.escena.planos[_indicePlano];

  Future<void> _iniciarPlanoActual() async {
    _temporizador?.cancel();
    _caracteresRevelados = 0;
    _estado = _EstadoPlano.pausaPrevia;

    await _controladorFade.forward();
    if (!mounted) return;

    final plano = _planoActual;
    switch (plano) {
      case PlanoAmbiente():
        setState(() => _estado = _EstadoPlano.revelando);
        _temporizador = Timer(plano.duracion, _avanzar);
      case PlanoDialogo():
        if (plano.pausaPrevia > Duration.zero) {
          _temporizador = Timer(plano.pausaPrevia, _empezarReveal);
        } else {
          _empezarReveal();
        }
    }
  }

  void _empezarReveal() {
    if (!mounted) return;
    final plano = _planoActual;
    if (plano is! PlanoDialogo) return;
    setState(() {
      _estado = _EstadoPlano.revelando;
      _caracteresRevelados = 0;
    });
    _temporizador = Timer.periodic(_intervaloReveal, (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        _caracteresRevelados++;
      });
      if (_caracteresRevelados >= plano.texto.length) {
        timer.cancel();
        setState(() => _estado = _EstadoPlano.esperandoTap);
      }
    });
  }

  void _alPulsar() {
    final plano = _planoActual;
    switch (plano) {
      case PlanoAmbiente():
        return;
      case PlanoDialogo():
        switch (_estado) {
          case _EstadoPlano.revelando:
            _temporizador?.cancel();
            HapticFeedback.selectionClick();
            setState(() {
              _caracteresRevelados = plano.texto.length;
              _estado = _EstadoPlano.esperandoTap;
            });
          case _EstadoPlano.esperandoTap:
            HapticFeedback.selectionClick();
            _avanzar();
          case _EstadoPlano.pausaPrevia:
          case _EstadoPlano.saliendo:
            return;
        }
    }
  }

  Future<void> _avanzar() async {
    if (!mounted) return;
    _temporizador?.cancel();
    setState(() => _estado = _EstadoPlano.saliendo);
    await _controladorFade.reverse();
    if (!mounted) return;

    if (_indicePlano + 1 >= widget.escena.planos.length) {
      widget.alTerminar();
      return;
    }
    setState(() => _indicePlano++);
    _iniciarPlanoActual();
  }

  @override
  Widget build(BuildContext contexto) {
    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _alPulsar,
        child: Stack(
          fit: StackFit.expand,
          children: [
            AnimatedBuilder(
              animation: _controladorCielo,
              builder: (_, __) => CustomPaint(
                painter: PintorEscenario(
                  fasePulso: _controladorCielo.value,
                  nivelRestauracion: 0.15,
                ),
              ),
            ),
            Container(color: PaletaNeon.fondoProfundo.withOpacity(0.35)),
            SafeArea(
              child: FadeTransition(
                opacity: _controladorFade,
                child: _construirContenidoDePlano(),
              ),
            ),
            _IndicadorSaltar(alPulsar: widget.alTerminar),
          ],
        ),
      ),
    );
  }

  Widget _construirContenidoDePlano() {
    final plano = _planoActual;
    switch (plano) {
      case PlanoAmbiente():
        return _VistaAmbiente(textoLectura: plano.textoLectura);
      case PlanoDialogo():
        return _VistaDialogo(
          voz: plano.voz,
          textoRevelado: plano.texto.substring(0, _caracteresRevelados),
          mostrandoIndicador: _estado == _EstadoPlano.esperandoTap,
        );
    }
  }
}

class _VistaAmbiente extends StatelessWidget {
  final String? textoLectura;

  const _VistaAmbiente({this.textoLectura});

  @override
  Widget build(BuildContext contexto) {
    if (textoLectura == null) return const SizedBox.shrink();
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(32, 0, 32, 80),
        child: Text(
          textoLectura!,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            letterSpacing: 2,
            fontStyle: FontStyle.italic,
            color: PaletaNeon.textoTenue.withOpacity(0.55),
            fontWeight: FontWeight.w300,
          ),
        ),
      ),
    );
  }
}

class _VistaDialogo extends StatelessWidget {
  final VozPersonaje voz;
  final String textoRevelado;
  final bool mostrandoIndicador;

  const _VistaDialogo({
    required this.voz,
    required this.textoRevelado,
    required this.mostrandoIndicador,
  });

  @override
  Widget build(BuildContext contexto) {
    final nombre = voz.nombreVisible;
    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 0, 28, 56),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (nombre.isNotEmpty)
            Text(
              nombre.toUpperCase(),
              style: TextStyle(
                fontSize: 11,
                letterSpacing: 4,
                color: voz.colorNombre,
                fontWeight: FontWeight.w500,
              ),
            ),
          const SizedBox(height: 10),
          Text(textoRevelado, style: voz.estiloTextoCuerpo()),
          const SizedBox(height: 18),
          AnimatedOpacity(
            opacity: mostrandoIndicador ? 0.55 : 0.0,
            duration: const Duration(milliseconds: 220),
            child: Row(
              children: [
                Text(
                  'toca para continuar',
                  style: TextStyle(
                    fontSize: 11,
                    letterSpacing: 2.2,
                    color: PaletaNeon.textoTenue.withOpacity(0.7),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _IndicadorSaltar extends StatelessWidget {
  final VoidCallback alPulsar;

  const _IndicadorSaltar({required this.alPulsar});

  @override
  Widget build(BuildContext contexto) {
    return SafeArea(
      child: Align(
        alignment: Alignment.topRight,
        child: Padding(
          padding: const EdgeInsets.only(top: 8, right: 12),
          child: TextButton(
            onPressed: alPulsar,
            style: TextButton.styleFrom(
              foregroundColor: PaletaNeon.textoTenue.withOpacity(0.55),
            ),
            child: const Text(
              'saltar',
              style: TextStyle(
                fontSize: 11,
                letterSpacing: 2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
