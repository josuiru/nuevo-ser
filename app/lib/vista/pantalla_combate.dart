import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../dominio/fragmento.dart';
import '../dominio/resolucion_corte.dart';
import '../nucleo/dialogos_sora.dart';
import '../nucleo/paleta.dart';
import 'escenario.dart';
import 'lienzo_combate.dart';
import 'particulas_rotura.dart';
import 'pintor_fragmento.dart';
import 'sora_presencia.dart';

/// Estado del ciclo del intento.
///
/// - [intro]: Sora acaba de presentar un Fragmento nuevo; el jugador
///   todavía no ha tocado nada.
/// - [dibujando]: trazando radios, puede deshacer o cortar.
/// - [rompiendo]: acertó; animación de rotura en curso.
/// - [pausa]: breve pausa antes de que aparezca el siguiente Fragmento.
enum _FaseIntento { intro, dibujando, rompiendo, pausa }

class PantallaCombate extends StatefulWidget {
  const PantallaCombate({super.key});

  @override
  State<PantallaCombate> createState() => _PantallaCombateState();
}

class _PantallaCombateState extends State<PantallaCombate>
    with TickerProviderStateMixin {
  static const _denominadoresDisponibles = [2, 3, 4, 5];
  static const _evaluador = EvaluadorCorte();

  int _denominadorActivo = 2;
  final List<RadioTrazado> _radiosConfirmados = [];
  RadioTrazado? _radioEnCurso;
  ResultadoIntento? _ultimoResultado;
  _FaseIntento _fase = _FaseIntento.intro;
  int _victoriasAcumuladas = 0;
  int _fallosAcumulados = 0;
  bool _esPrimerCombate = true;
  String? _lineaSoraActiva;
  Timer? _temporizadorLineaSora;
  Timer? _temporizadorPausa;

  late final AnimationController _controladorRotura;
  late final AnimationController _controladorAparicion;
  late final AnimationController _controladorCielo;
  late final List<Particula> _particulasRotura;

  FragmentoUnitario get _fragmentoActivo =>
      FragmentoUnitario(_denominadorActivo);

  int get _radiosObjetivo => _fragmentoActivo.radiosRequeridos;

  bool get _aceptaNuevosTrazos =>
      _fase == _FaseIntento.dibujando &&
      _radiosConfirmados.length < _radiosObjetivo;

  bool get _puedeCortarAhora =>
      _fase == _FaseIntento.dibujando &&
      _radiosConfirmados.length == _radiosObjetivo;

  bool get _hayTrazos => _radiosConfirmados.isNotEmpty;

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
        _iniciarPausaTrasVictoria();
      }
    });
    _controladorAparicion = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 520),
      value: 0,
    );
    _particulasRotura = PintorRotura.generar();
    _agendarIntroSora();
    _controladorAparicion.forward();
  }

  @override
  void dispose() {
    _controladorCielo.dispose();
    _controladorRotura.dispose();
    _controladorAparicion.dispose();
    _temporizadorLineaSora?.cancel();
    _temporizadorPausa?.cancel();
    super.dispose();
  }

  void _agendarIntroSora() {
    _temporizadorLineaSora?.cancel();
    _temporizadorLineaSora = Timer(const Duration(milliseconds: 450), () {
      if (!mounted) return;
      setState(() {
        _lineaSoraActiva = DialogosSora.inicioCombate(
          denominador: _denominadorActivo,
          esPrimerCombate: _esPrimerCombate,
        );
        _fase = _FaseIntento.dibujando;
      });
    });
  }

  void _elegirDenominador(int denominador) {
    if (_fase == _FaseIntento.rompiendo) return;
    _temporizadorLineaSora?.cancel();
    _temporizadorPausa?.cancel();
    _controladorRotura.reset();
    setState(() {
      _denominadorActivo = denominador;
      _radiosConfirmados.clear();
      _radioEnCurso = null;
      _ultimoResultado = null;
      _fase = _FaseIntento.intro;
      _lineaSoraActiva = null;
    });
    _controladorAparicion
      ..reset()
      ..forward();
    _agendarIntroSora();
  }

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
    if (_fase != _FaseIntento.dibujando) return;
    HapticFeedback.lightImpact();
    setState(() {
      _radiosConfirmados.removeLast();
      _ultimoResultado = null;
    });
  }

  void _reiniciarIntento() {
    if (_fase != _FaseIntento.dibujando) return;
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
        _fase = _FaseIntento.rompiendo;
        _lineaSoraActiva =
            DialogosSora.felicitacionPara(_victoriasAcumuladas - 1);
      });
      _controladorRotura
        ..reset()
        ..forward();
    } else {
      _fallosAcumulados++;
      HapticFeedback.vibrate();
      setState(() {
        _lineaSoraActiva =
            DialogosSora.animoTrasFallo(_fallosAcumulados - 1);
      });
    }
  }

  void _iniciarPausaTrasVictoria() {
    setState(() {
      _fase = _FaseIntento.pausa;
    });
    _temporizadorPausa?.cancel();
    _temporizadorPausa = Timer(const Duration(milliseconds: 700), () {
      if (!mounted) return;
      setState(() {
        _radiosConfirmados.clear();
        _radioEnCurso = null;
        _ultimoResultado = null;
        _esPrimerCombate = false;
        _fase = _FaseIntento.intro;
        _lineaSoraActiva = null;
      });
      _controladorRotura.reset();
      _controladorAparicion
        ..reset()
        ..forward();
      _agendarIntroSora();
    });
  }

  EstadoFragmento get _estadoFragmento {
    if (_fase == _FaseIntento.rompiendo || _fase == _FaseIntento.pausa) {
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
      _fase == _FaseIntento.rompiendo ||
      _ultimoResultado?.esExito == true;

  bool get _destacarFallo =>
      _ultimoResultado != null && !_ultimoResultado!.esExito;

  @override
  Widget build(BuildContext contexto) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _controladorCielo,
        builder: (_, __) {
          return Stack(
            fit: StackFit.expand,
            children: [
              CustomPaint(
                painter: PintorEscenario(fasePulso: _controladorCielo.value),
              ),
              SafeArea(
                child: Column(
                  children: [
                    _BarraSuperior(
                      denominadoresDisponibles: _denominadoresDisponibles,
                      denominadorActivo: _denominadorActivo,
                      alElegir: _elegirDenominador,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: AnimatedBuilder(
                          animation: Listenable.merge(
                              [_controladorRotura, _controladorAparicion]),
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
                              opacidadAparicion: _controladorAparicion.value,
                              particulasRotura: _particulasRotura,
                              onAgregarRadio: _agregarRadio,
                              onActualizarRadioEnCurso: _actualizarRadioEnCurso,
                            );
                          },
                        ),
                      ),
                    ),
                    _IndicadorProgreso(
                      trazosHechos: _radiosConfirmados.length,
                      trazosObjetivo: _radiosObjetivo,
                    ),
                    SoraPresencia(textoActivo: _lineaSoraActiva),
                    _BarraAcciones(
                      hayTrazos: _hayTrazos,
                      puedeCortar: _puedeCortarAhora,
                      estaInactivo: _fase != _FaseIntento.dibujando,
                      alDeshacer: _deshacerUltimo,
                      alReiniciar: _reiniciarIntento,
                      alCortar: _evaluarAhora,
                    ),
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

class _BarraSuperior extends StatelessWidget {
  final List<int> denominadoresDisponibles;
  final int denominadorActivo;
  final ValueChanged<int> alElegir;

  const _BarraSuperior({
    required this.denominadoresDisponibles,
    required this.denominadorActivo,
    required this.alElegir,
  });

  @override
  Widget build(BuildContext contexto) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'UNO ROTO',
            style: TextStyle(
              fontSize: 16,
              letterSpacing: 6,
              color: PaletaNeon.textoTenue,
              fontWeight: FontWeight.w300,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            children: [
              for (final denominador in denominadoresDisponibles)
                _BotonDenominador(
                  denominador: denominador,
                  activo: denominador == denominadorActivo,
                  alPulsar: () => alElegir(denominador),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BotonDenominador extends StatelessWidget {
  final int denominador;
  final bool activo;
  final VoidCallback alPulsar;

  const _BotonDenominador({
    required this.denominador,
    required this.activo,
    required this.alPulsar,
  });

  @override
  Widget build(BuildContext contexto) {
    final colorBorde = activo ? PaletaNeon.azulNeon : PaletaNeon.violetaBase;
    final colorTexto =
        activo ? PaletaNeon.textoPrincipal : PaletaNeon.textoTenue;
    return GestureDetector(
      onTap: alPulsar,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: activo
              ? PaletaNeon.violetaBase.withOpacity(0.4)
              : Colors.transparent,
          border: Border.all(color: colorBorde, width: 1.5),
          borderRadius: BorderRadius.circular(24),
          boxShadow: activo
              ? [
                  BoxShadow(
                    color: PaletaNeon.azulNeon.withOpacity(0.35),
                    blurRadius: 14,
                  ),
                ]
              : const [],
        ),
        child: Text(
          '1/$denominador',
          style: TextStyle(
            color: colorTexto,
            fontSize: 16,
            fontWeight: FontWeight.w400,
            letterSpacing: 1.2,
          ),
        ),
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
  final bool estaInactivo;
  final VoidCallback alDeshacer;
  final VoidCallback alReiniciar;
  final VoidCallback alCortar;

  const _BarraAcciones({
    required this.hayTrazos,
    required this.puedeCortar,
    required this.estaInactivo,
    required this.alDeshacer,
    required this.alReiniciar,
    required this.alCortar,
  });

  @override
  Widget build(BuildContext contexto) {
    final deshacerActivo = hayTrazos && !estaInactivo;
    final cortarActivo = puedeCortar && !estaInactivo;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _BotonAccion(
            etiqueta: 'Deshacer',
            habilitado: deshacerActivo,
            acentuado: false,
            alPulsar: alDeshacer,
          ),
          _BotonAccion(
            etiqueta: 'De nuevo',
            habilitado: deshacerActivo,
            acentuado: false,
            alPulsar: alReiniciar,
          ),
          _BotonAccion(
            etiqueta: 'Cortar',
            habilitado: cortarActivo,
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
