import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../dominio/fragmento.dart';
import '../dominio/resolucion_corte.dart';
import '../dominio/sesion.dart';
import '../nucleo/dialogos_sora.dart';
import '../nucleo/paleta.dart';
import 'escenario.dart';
import 'lienzo_combate.dart';
import 'particulas_rotura.dart';
import 'pintor_fragmento.dart';
import 'sora_presencia.dart';

/// Fases de la sesión narrativa.
///
/// - [presentacion]: Sora suelta las líneas iniciales. El jugador toca
///   el bocadillo para avanzar.
/// - [invocando]: Sora pronuncia la línea del contrato y el Fragmento
///   desciende del cielo.
/// - [dibujando]: combate propiamente dicho.
/// - [rompiendo]: partículas del Fragmento derrotado.
/// - [transicion]: una línea breve entre combates ("Ahí viene otro").
/// - [sesionCompleta]: se notifica al padre para mostrar el cierre.
enum _FaseSesion {
  presentacion,
  invocando,
  dibujando,
  rompiendo,
  transicion,
  sesionCompleta,
}

class PantallaCombate extends StatefulWidget {
  final SesionNoche sesion;
  final VoidCallback alTerminarSesion;

  const PantallaCombate({
    super.key,
    required this.sesion,
    required this.alTerminarSesion,
  });

  @override
  State<PantallaCombate> createState() => _PantallaCombateState();
}

class _PantallaCombateState extends State<PantallaCombate>
    with TickerProviderStateMixin {
  static const _evaluador = EvaluadorCorte();

  int _indicePresentacion = 0;
  int _indiceContrato = 0;
  final List<RadioTrazado> _radiosConfirmados = [];
  RadioTrazado? _radioEnCurso;
  ResultadoIntento? _ultimoResultado;
  _FaseSesion _fase = _FaseSesion.presentacion;
  int _victoriasAcumuladas = 0;
  int _fallosAcumulados = 0;
  String? _lineaSoraActiva;
  bool _lineaEsperaPulsacion = true;

  Timer? _temporizadorLineaSora;
  Timer? _temporizadorPausa;

  late final AnimationController _controladorRotura;
  late final AnimationController _controladorAparicion;
  late final AnimationController _controladorCielo;
  late final AnimationController _controladorRestauracion;
  late final List<Particula> _particulasRotura;

  ContratoFragmento get _contratoActivo =>
      widget.sesion.contratos[_indiceContrato];

  FragmentoUnitario get _fragmentoActivo => _contratoActivo.aFragmento();

  int get _radiosObjetivo => _fragmentoActivo.radiosRequeridos;

  bool get _aceptaNuevosTrazos =>
      _fase == _FaseSesion.dibujando &&
      _radiosConfirmados.length < _radiosObjetivo;

  bool get _puedeCortarAhora =>
      _fase == _FaseSesion.dibujando &&
      _radiosConfirmados.length == _radiosObjetivo;

  bool get _hayTrazos => _radiosConfirmados.isNotEmpty;

  bool get _mostrarFragmento =>
      _fase != _FaseSesion.presentacion && _fase != _FaseSesion.transicion;

  @override
  void initState() {
    super.initState();
    _controladorCielo = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 16),
    )..repeat();
    _controladorRotura = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _controladorRotura.addStatusListener((estadoAnim) {
      if (estadoAnim == AnimationStatus.completed) {
        _iniciarTransicion();
      }
    });
    _controladorAparicion = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 620),
      value: 0,
    );
    _controladorRestauracion = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
      value: 0,
    );
    _particulasRotura = PintorRotura.generar();
    _mostrarLineaPresentacionActual();
  }

  @override
  void dispose() {
    _controladorCielo.dispose();
    _controladorRotura.dispose();
    _controladorAparicion.dispose();
    _controladorRestauracion.dispose();
    _temporizadorLineaSora?.cancel();
    _temporizadorPausa?.cancel();
    super.dispose();
  }

  /// ---- Fase: presentación de Sora ---------------------------------

  void _mostrarLineaPresentacionActual() {
    final linea = widget.sesion.lineasIntro[_indicePresentacion];
    setState(() {
      _fase = _FaseSesion.presentacion;
      _lineaSoraActiva = linea.texto;
      _lineaEsperaPulsacion = linea.esperaPulsacion;
    });
  }

  void _avanzarPresentacion() {
    HapticFeedback.selectionClick();
    if (_indicePresentacion < widget.sesion.lineasIntro.length - 1) {
      setState(() => _indicePresentacion++);
      _mostrarLineaPresentacionActual();
    } else {
      _iniciarInvocacion();
    }
  }

  /// ---- Fase: invocación del Fragmento -----------------------------

  void _iniciarInvocacion() {
    setState(() {
      _fase = _FaseSesion.invocando;
      _lineaSoraActiva = _contratoActivo.invocacion.texto;
      _lineaEsperaPulsacion = true;
      _radiosConfirmados.clear();
      _radioEnCurso = null;
      _ultimoResultado = null;
    });
    _controladorAparicion
      ..reset()
      ..forward();
  }

  void _avanzarInvocacion() {
    HapticFeedback.selectionClick();
    setState(() {
      _fase = _FaseSesion.dibujando;
      _lineaSoraActiva = null;
    });
  }

  /// ---- Fase: combate ----------------------------------------------

  void _agregarRadio(RadioTrazado radio) {
    if (!_aceptaNuevosTrazos) return;
    HapticFeedback.selectionClick();
    setState(() {
      _radiosConfirmados.add(radio);
      _ultimoResultado = null;
      _lineaSoraActiva = null;
    });
  }

  void _actualizarRadioEnCurso(RadioTrazado? radio) {
    setState(() => _radioEnCurso = radio);
  }

  void _deshacerUltimo() {
    if (!_hayTrazos) return;
    if (_fase != _FaseSesion.dibujando) return;
    HapticFeedback.lightImpact();
    setState(() {
      _radiosConfirmados.removeLast();
      _ultimoResultado = null;
    });
  }

  void _reiniciarIntento() {
    if (_fase != _FaseSesion.dibujando) return;
    setState(() {
      _radiosConfirmados.clear();
      _radioEnCurso = null;
      _ultimoResultado = null;
    });
  }

  void _evaluarAhora() {
    if (!_puedeCortarAhora) return;
    final resultado = _evaluador.evaluar(
      fragmento: _fragmentoActivo,
      radios: _radiosConfirmados,
    );
    setState(() => _ultimoResultado = resultado);

    if (resultado.esExito) {
      _victoriasAcumuladas++;
      HapticFeedback.heavyImpact();
      setState(() {
        _fase = _FaseSesion.rompiendo;
        _lineaSoraActiva =
            DialogosSora.felicitacionPara(_victoriasAcumuladas - 1);
        _lineaEsperaPulsacion = false;
      });
      _controladorRotura
        ..reset()
        ..forward();
      Future.delayed(const Duration(milliseconds: 350), () {
        if (!mounted) return;
        _actualizarRestauracion();
      });
    } else {
      _fallosAcumulados++;
      HapticFeedback.vibrate();
      setState(() {
        _lineaSoraActiva =
            DialogosSora.animoTrasFallo(_fallosAcumulados - 1);
        _lineaEsperaPulsacion = false;
      });
    }
  }

  /// ---- Fase: transición entre contratos ---------------------------

  void _iniciarTransicion() {
    setState(() => _fase = _FaseSesion.transicion);
    _temporizadorPausa?.cancel();
    _temporizadorPausa = Timer(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      final hayMasContratos =
          _indiceContrato < widget.sesion.contratos.length - 1;
      if (hayMasContratos) {
        setState(() {
          _indiceContrato++;
          _radiosConfirmados.clear();
          _radioEnCurso = null;
          _ultimoResultado = null;
        });
        _controladorRotura.reset();
        _iniciarInvocacion();
      } else {
        setState(() => _fase = _FaseSesion.sesionCompleta);
        widget.alTerminarSesion();
      }
    });
  }

  /// ---- Restauración diegética de la ciudad ------------------------

  double _nivelRestauracionObjetivo = 0;

  void _actualizarRestauracion() {
    final totalVictoriasEsperadas = widget.sesion.numeroCombates;
    _nivelRestauracionObjetivo =
        (_victoriasAcumuladas / totalVictoriasEsperadas).clamp(0.0, 1.0);
    final valorPrevio = _controladorRestauracion.value;
    _controladorRestauracion.stop();
    _controladorRestauracion.value = valorPrevio;
    _controladorRestauracion.animateTo(
      _nivelRestauracionObjetivo,
      duration: const Duration(milliseconds: 1200),
      curve: Curves.easeOutCubic,
    );
  }

  /// ---- Callbacks de la UI ----------------------------------------

  void _alTocarBocadillo() {
    if (!_lineaEsperaPulsacion) return;
    switch (_fase) {
      case _FaseSesion.presentacion:
        _avanzarPresentacion();
        break;
      case _FaseSesion.invocando:
        _avanzarInvocacion();
        break;
      default:
        break;
    }
  }

  EstadoFragmento get _estadoFragmento {
    if (_fase == _FaseSesion.rompiendo || _fase == _FaseSesion.transicion) {
      return EstadoFragmento.apacible;
    }
    if (_ultimoResultado != null && !_ultimoResultado!.esExito) {
      return EstadoFragmento.sorprendido;
    }
    if (_puedeCortarAhora) return EstadoFragmento.nervioso;
    if (_radioEnCurso != null) return EstadoFragmento.alerta;
    return EstadoFragmento.tranquilo;
  }

  bool get _destacarExito =>
      _fase == _FaseSesion.rompiendo ||
      _ultimoResultado?.esExito == true;

  bool get _destacarFallo =>
      _ultimoResultado != null && !_ultimoResultado!.esExito;

  @override
  Widget build(BuildContext contexto) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: Listenable.merge(
            [_controladorCielo, _controladorRestauracion]),
        builder: (_, __) {
          return Stack(
            fit: StackFit.expand,
            children: [
              CustomPaint(
                painter: PintorEscenario(
                  fasePulso: _controladorCielo.value,
                  nivelRestauracion: _controladorRestauracion.value,
                ),
              ),
              SafeArea(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: _mostrarFragmento
                            ? AnimatedBuilder(
                                animation: Listenable.merge([
                                  _controladorRotura,
                                  _controladorAparicion,
                                ]),
                                builder: (_, __) {
                                  return LienzoCombate(
                                    fragmento: _fragmentoActivo,
                                    radiosConfirmados:
                                        List.unmodifiable(_radiosConfirmados),
                                    radioEnCurso: _radioEnCurso,
                                    estadoFragmento: _estadoFragmento,
                                    destacarExito: _destacarExito,
                                    destacarFallo: _destacarFallo,
                                    aceptaNuevosTrazos: _aceptaNuevosTrazos,
                                    progresoRotura: _controladorRotura.value,
                                    opacidadAparicion:
                                        _controladorAparicion.value,
                                    particulasRotura: _particulasRotura,
                                    onAgregarRadio: _agregarRadio,
                                    onActualizarRadioEnCurso:
                                        _actualizarRadioEnCurso,
                                  );
                                },
                              )
                            : const SizedBox.shrink(),
                      ),
                    ),
                    if (_fase == _FaseSesion.dibujando)
                      _IndicadorProgreso(
                        trazosHechos: _radiosConfirmados.length,
                        trazosObjetivo: _radiosObjetivo,
                      ),
                    SoraPresencia(
                      textoActivo: _lineaSoraActiva,
                      alTocarBocadillo: _lineaEsperaPulsacion
                          ? _alTocarBocadillo
                          : null,
                    ),
                    if (_lineaEsperaPulsacion &&
                        (_fase == _FaseSesion.presentacion ||
                            _fase == _FaseSesion.invocando))
                      const Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: Text(
                          'toca para continuar',
                          style: TextStyle(
                            color: PaletaNeon.textoTenue,
                            fontSize: 11,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                    if (_fase == _FaseSesion.dibujando)
                      _BarraAcciones(
                        hayTrazos: _hayTrazos,
                        puedeCortar: _puedeCortarAhora,
                        alDeshacer: _deshacerUltimo,
                        alReiniciar: _reiniciarIntento,
                        alCortar: _evaluarAhora,
                      )
                    else
                      const SizedBox(height: 72),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _IndicadorProgreso extends StatelessWidget {
  final int trazosHechos;
  final int trazosObjetivo;

  const _IndicadorProgreso({
    required this.trazosHechos,
    required this.trazosObjetivo,
  });

  @override
  Widget build(BuildContext contexto) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(trazosObjetivo, (indice) {
          final hecho = indice < trazosHechos;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 28,
              height: 4,
              decoration: BoxDecoration(
                color: hecho
                    ? PaletaNeon.azulNeon
                    : PaletaNeon.violetaBase.withOpacity(0.5),
                borderRadius: BorderRadius.circular(2),
                boxShadow: hecho
                    ? [
                        BoxShadow(
                          color: PaletaNeon.azulNeon.withOpacity(0.5),
                          blurRadius: 6,
                        ),
                      ]
                    : const [],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _BarraAcciones extends StatelessWidget {
  final bool hayTrazos;
  final bool puedeCortar;
  final VoidCallback alDeshacer;
  final VoidCallback alReiniciar;
  final VoidCallback alCortar;

  const _BarraAcciones({
    required this.hayTrazos,
    required this.puedeCortar,
    required this.alDeshacer,
    required this.alReiniciar,
    required this.alCortar,
  });

  @override
  Widget build(BuildContext contexto) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _BotonAccion(
            etiqueta: 'Deshacer',
            habilitado: hayTrazos,
            acentuado: false,
            alPulsar: alDeshacer,
          ),
          _BotonAccion(
            etiqueta: 'De nuevo',
            habilitado: hayTrazos,
            acentuado: false,
            alPulsar: alReiniciar,
          ),
          _BotonAccion(
            etiqueta: 'Cortar',
            habilitado: puedeCortar,
            acentuado: true,
            alPulsar: alCortar,
          ),
        ],
      ),
    );
  }
}

class _BotonAccion extends StatelessWidget {
  final String etiqueta;
  final bool habilitado;
  final bool acentuado;
  final VoidCallback alPulsar;

  const _BotonAccion({
    required this.etiqueta,
    required this.habilitado,
    required this.acentuado,
    required this.alPulsar,
  });

  @override
  Widget build(BuildContext contexto) {
    final colorBorde = !habilitado
        ? PaletaNeon.violetaBase.withOpacity(0.3)
        : acentuado
            ? PaletaNeon.azulNeon
            : PaletaNeon.violetaNeon;
    final colorTexto = !habilitado
        ? PaletaNeon.textoTenue.withOpacity(0.4)
        : acentuado
            ? PaletaNeon.textoPrincipal
            : PaletaNeon.textoPrincipal.withOpacity(0.85);
    final colorFondo = !habilitado
        ? Colors.transparent
        : acentuado
            ? PaletaNeon.azulNeon.withOpacity(0.15)
            : Colors.transparent;

    return Opacity(
      opacity: habilitado ? 1 : 0.5,
      child: GestureDetector(
        onTap: habilitado ? alPulsar : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: colorFondo,
            border: Border.all(color: colorBorde, width: 1.5),
            borderRadius: BorderRadius.circular(28),
            boxShadow: habilitado && acentuado
                ? [
                    BoxShadow(
                      color: PaletaNeon.azulNeon.withOpacity(0.35),
                      blurRadius: 14,
                    ),
                  ]
                : const [],
          ),
          child: Text(
            etiqueta,
            style: TextStyle(
              color: colorTexto,
              fontSize: 14,
              letterSpacing: 1.1,
              fontWeight: acentuado ? FontWeight.w500 : FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}
