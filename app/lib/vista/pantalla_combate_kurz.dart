import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../dominio/desafio_kurz.dart';
import '../dominio/voz_personaje.dart';
import '../nucleo/paleta.dart';
import 'escenario.dart';
import 'pantalla_cinematica.dart' show aplicarTokens;

/// Combate jugable contra Kurz. Doc 07 §1.5 / §1.10 / §1.12.
///
/// Una pregunta tras otra con tiempo límite. Cada acierto reduce el
/// valor de Kurz. Cada fallo (o expiración del tiempo) cuesta un punto
/// de ki. Termina cuando se acaban las preguntas (victoria) o el ki
/// llega a 0 (derrota).
class PantallaCombateKurz extends StatefulWidget {
  final DesafioKurz desafio;
  final String nombreJugador;
  final ValueChanged<ResultadoCombateKurz> alTerminar;

  const PantallaCombateKurz({
    super.key,
    required this.desafio,
    required this.alTerminar,
    this.nombreJugador = '',
  });

  @override
  State<PantallaCombateKurz> createState() => _PantallaCombateKurzState();
}

class _PantallaCombateKurzState extends State<PantallaCombateKurz>
    with TickerProviderStateMixin {
  late final AnimationController _controladorCielo;
  late final AnimationController _controladorPulso;
  late final AnimationController _controladorEntrada;

  int _indicePregunta = 0;
  int _ki = 0;
  int _aciertos = 0;
  int _segundosRestantes = 0;
  int _indiceValor = 0;
  String? _frasePresente;
  bool _bloqueado = false;
  Timer? _temporizadorPregunta;
  Timer? _temporizadorFrase;

  @override
  void initState() {
    super.initState();
    _ki = widget.desafio.kiInicial;
    _segundosRestantes = widget.desafio.segundosPorPregunta;
    _controladorCielo = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 16),
    )..repeat();
    _controladorPulso = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
    _controladorEntrada = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();
    _arrancarTemporizadorPregunta();
  }

  @override
  void dispose() {
    _controladorCielo.dispose();
    _controladorPulso.dispose();
    _controladorEntrada.dispose();
    _temporizadorPregunta?.cancel();
    _temporizadorFrase?.cancel();
    super.dispose();
  }

  void _arrancarTemporizadorPregunta() {
    _temporizadorPregunta?.cancel();
    setState(() {
      _segundosRestantes = widget.desafio.segundosPorPregunta;
    });
    _temporizadorPregunta =
        Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        _segundosRestantes--;
      });
      if (_segundosRestantes <= 0) {
        timer.cancel();
        _registrarFallo(porTiempo: true);
      }
    });
  }

  void _alElegir(int indice) {
    if (_bloqueado) return;
    final pregunta = widget.desafio.preguntas[_indicePregunta];
    if (indice == pregunta.indiceCorrecto) {
      _registrarAcierto();
    } else {
      HapticFeedback.lightImpact();
      _registrarFallo();
    }
  }

  String _conTokens(String texto) =>
      aplicarTokens(texto, widget.nombreJugador);

  void _registrarAcierto() {
    _temporizadorPregunta?.cancel();
    HapticFeedback.mediumImpact();
    setState(() {
      _bloqueado = true;
      _aciertos++;
      _indiceValor = (_indiceValor + 1)
          .clamp(0, widget.desafio.secuenciaValores.length - 1);
      _frasePresente = _conTokens(widget.desafio.fraseAcierto);
    });
    _temporizadorFrase?.cancel();
    _temporizadorFrase = Timer(
      const Duration(milliseconds: 900),
      _avanzarPregunta,
    );
  }

  void _registrarFallo({bool porTiempo = false}) {
    _temporizadorPregunta?.cancel();
    final pregunta = widget.desafio.preguntas[_indicePregunta];
    setState(() {
      _bloqueado = true;
      _ki = (_ki - 1).clamp(0, widget.desafio.kiInicial);
      _frasePresente = _conTokens(pregunta.fraseFalloKurz);
    });
    _temporizadorFrase?.cancel();
    _temporizadorFrase = Timer(
      const Duration(milliseconds: 1100),
      _avanzarPregunta,
    );
  }

  void _avanzarPregunta() {
    if (!mounted) return;
    final esUltima =
        _indicePregunta + 1 >= widget.desafio.preguntas.length;
    if (_ki <= 0 || esUltima) {
      _terminar();
      return;
    }
    setState(() {
      _indicePregunta++;
      _bloqueado = false;
      _frasePresente = null;
    });
    _arrancarTemporizadorPregunta();
  }

  void _terminar() {
    _temporizadorPregunta?.cancel();
    _temporizadorFrase?.cancel();
    final victoria = _ki > 0 &&
        _aciertos >= widget.desafio.preguntas.length;
    setState(() {
      _bloqueado = true;
      _frasePresente = _conTokens(
        victoria
            ? widget.desafio.fraseVictoria
            : widget.desafio.fraseDerrota,
      );
    });
    Future.delayed(const Duration(milliseconds: 1600), () {
      if (!mounted) return;
      widget.alTerminar(ResultadoCombateKurz(
        victoria: victoria,
        kiFinal: _ki,
        aciertos: _aciertos,
      ));
    });
  }

  @override
  Widget build(BuildContext contexto) {
    final pregunta = widget.desafio.preguntas[_indicePregunta];
    final valorKurz =
        widget.desafio.secuenciaValores[_indiceValor];
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          AnimatedBuilder(
            animation: _controladorCielo,
            builder: (_, __) => CustomPaint(
              painter: PintorEscenario(
                fasePulso: _controladorCielo.value,
                nivelRestauracion: 0.1,
              ),
            ),
          ),
          Container(color: PaletaNeon.fondoProfundo.withOpacity(0.45)),
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 12),
                AnimatedBuilder(
                  animation: _controladorEntrada,
                  builder: (_, hijo) {
                    final progreso = Curves.easeOutCubic
                        .transform(_controladorEntrada.value);
                    return Opacity(
                      opacity: progreso,
                      child: Transform.scale(
                        scale: 0.78 + 0.22 * progreso,
                        child: hijo,
                      ),
                    );
                  },
                  child: _CabeceraKurz(
                    nombreFragmento: widget.desafio.nombreFragmento,
                    valor: valorKurz,
                    pulso: _controladorPulso,
                    fraseReciente: _frasePresente,
                    vozQueHabla: widget.desafio.vozQueHabla,
                    colorHalo: _colorHaloDe(widget.desafio),
                    mostrarOjos: widget.desafio.mostrarOjos,
                  ),
                ),
                const Spacer(),
                _PreguntaArea(
                  enunciado: pregunta.enunciado,
                  opciones: pregunta.opciones,
                  bloqueado: _bloqueado,
                  alElegir: _alElegir,
                ),
                const SizedBox(height: 14),
                _PieEstado(
                  ki: _ki,
                  kiMax: widget.desafio.kiInicial,
                  segundos: _segundosRestantes,
                ),
                const SizedBox(height: 18),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Color _colorHaloDe(DesafioKurz desafio) {
  if (desafio.identificador.startsWith('zafran')) {
    return PaletaNeon.rojoOxidado;
  }
  return PaletaNeon.violetaNeon;
}

class _CabeceraKurz extends StatelessWidget {
  final String nombreFragmento;
  final String valor;
  final Animation<double> pulso;
  final String? fraseReciente;
  final VozPersonaje vozQueHabla;
  final Color colorHalo;
  final bool mostrarOjos;

  const _CabeceraKurz({
    required this.nombreFragmento,
    required this.valor,
    required this.pulso,
    required this.fraseReciente,
    required this.vozQueHabla,
    required this.colorHalo,
    required this.mostrarOjos,
  });

  @override
  Widget build(BuildContext contexto) {
    final nombreVoz = vozQueHabla.nombreVisible;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Text(
            nombreFragmento,
            style: TextStyle(
              fontSize: 12,
              letterSpacing: 6,
              color: colorHalo.withOpacity(0.85),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 18),
          AnimatedBuilder(
            animation: pulso,
            builder: (_, __) {
              final escala = 0.92 + 0.08 * pulso.value;
              return Container(
                width: 180 * escala,
                height: 180 * escala,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      colorHalo.withOpacity(0.85),
                      colorHalo.withOpacity(0.4),
                      PaletaNeon.fondoMedio.withOpacity(0.0),
                    ],
                    stops: const [0.25, 0.75, 1.0],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: colorHalo.withOpacity(0.35),
                      blurRadius: 36,
                      spreadRadius: 6,
                    ),
                  ],
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Text(
                      valor,
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.w300,
                        color: PaletaNeon.textoPrincipal,
                        letterSpacing: 0.5,
                      ),
                    ),
                    if (mostrarOjos)
                      const Positioned(
                        top: 60,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _Ojo(),
                            SizedBox(width: 18),
                            _Ojo(),
                          ],
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 22),
          SizedBox(
            height: 64,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 280),
              child: fraseReciente == null
                  ? const SizedBox.shrink()
                  : Column(
                      key: ValueKey(fraseReciente),
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (nombreVoz.isNotEmpty)
                          Text(
                            nombreVoz.toUpperCase(),
                            style: TextStyle(
                              fontSize: 10,
                              letterSpacing: 3.5,
                              color: vozQueHabla.colorNombre,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        const SizedBox(height: 6),
                        Text(
                          fraseReciente!,
                          textAlign: TextAlign.center,
                          style: vozQueHabla
                              .estiloTextoCuerpo()
                              .copyWith(fontSize: 16),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Ojo extends StatelessWidget {
  const _Ojo();

  @override
  Widget build(BuildContext contexto) {
    return Container(
      width: 12,
      height: 6,
      decoration: BoxDecoration(
        color: PaletaNeon.fondoProfundo,
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}

class _PreguntaArea extends StatelessWidget {
  final String enunciado;
  final List<String> opciones;
  final bool bloqueado;
  final ValueChanged<int> alElegir;

  const _PreguntaArea({
    required this.enunciado,
    required this.opciones,
    required this.bloqueado,
    required this.alElegir,
  });

  @override
  Widget build(BuildContext contexto) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            enunciado,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              color: PaletaNeon.textoPrincipal,
              fontWeight: FontWeight.w300,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 20),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 10,
            runSpacing: 10,
            children: [
              for (var indice = 0; indice < opciones.length; indice++)
                _BotonRespuesta(
                  texto: opciones[indice],
                  habilitado: !bloqueado,
                  alPulsar: () => alElegir(indice),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BotonRespuesta extends StatelessWidget {
  final String texto;
  final bool habilitado;
  final VoidCallback alPulsar;

  const _BotonRespuesta({
    required this.texto,
    required this.habilitado,
    required this.alPulsar,
  });

  @override
  Widget build(BuildContext contexto) {
    return InkWell(
      onTap: habilitado ? alPulsar : null,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
        decoration: BoxDecoration(
          color: PaletaNeon.fondoMedio.withOpacity(habilitado ? 0.6 : 0.3),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: PaletaNeon.azulNeon.withOpacity(habilitado ? 0.55 : 0.18),
            width: 1.2,
          ),
        ),
        child: Text(
          texto,
          style: TextStyle(
            fontSize: 17,
            color: PaletaNeon.textoPrincipal
                .withOpacity(habilitado ? 1.0 : 0.45),
            letterSpacing: 0.3,
          ),
        ),
      ),
    );
  }
}

class _PieEstado extends StatelessWidget {
  final int ki;
  final int kiMax;
  final int segundos;

  const _PieEstado({
    required this.ki,
    required this.kiMax,
    required this.segundos,
  });

  @override
  Widget build(BuildContext contexto) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              for (var indice = 0; indice < kiMax; indice++)
                Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: indice < ki
                          ? PaletaNeon.azulNeon
                          : PaletaNeon.textoTenue.withOpacity(0.25),
                    ),
                  ),
                ),
            ],
          ),
          Text(
            '${segundos < 0 ? 0 : segundos}s',
            style: TextStyle(
              fontSize: 13,
              letterSpacing: 1.5,
              color: segundos <= 1
                  ? PaletaNeon.rosaAcento
                  : PaletaNeon.textoTenue,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
