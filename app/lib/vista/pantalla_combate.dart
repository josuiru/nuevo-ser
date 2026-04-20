import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../dominio/fragmento.dart';
import '../dominio/resolucion_corte.dart';
import '../nucleo/paleta.dart';
import 'lienzo_combate.dart';

/// Estado del ciclo del intento:
/// - [dibujando]: el jugador está trazando radios y puede deshacer o cortar.
/// - [celebrando]: ha acertado; breve pausa visual antes de reiniciar.
enum _FaseIntento { dibujando, celebrando }

class PantallaCombate extends StatefulWidget {
  const PantallaCombate({super.key});

  @override
  State<PantallaCombate> createState() => _PantallaCombateState();
}

class _PantallaCombateState extends State<PantallaCombate> {
  static const _denominadoresDisponibles = [2, 3, 4, 5];
  static const _evaluador = EvaluadorCorte();

  int _denominadorActivo = 2;
  final List<RadioTrazado> _radiosConfirmados = [];
  RadioTrazado? _radioEnCurso;
  ResultadoIntento? _ultimoResultado;
  _FaseIntento _fase = _FaseIntento.dibujando;
  Timer? _temporizadorCelebracion;

  FragmentoUnitario get _fragmentoActivo =>
      FragmentoUnitario(_denominadorActivo);

  int get _radiosObjetivo => _fragmentoActivo.radiosRequeridos;

  bool get _puedeCortarAhora =>
      _fase == _FaseIntento.dibujando &&
      _radiosConfirmados.length == _radiosObjetivo;

  bool get _aceptaNuevosTrazos =>
      _fase == _FaseIntento.dibujando &&
      _radiosConfirmados.length < _radiosObjetivo;

  @override
  void dispose() {
    _temporizadorCelebracion?.cancel();
    super.dispose();
  }

  void _elegirDenominador(int denominador) {
    _temporizadorCelebracion?.cancel();
    setState(() {
      _denominadorActivo = denominador;
      _radiosConfirmados.clear();
      _radioEnCurso = null;
      _ultimoResultado = null;
      _fase = _FaseIntento.dibujando;
    });
  }

  void _agregarRadio(RadioTrazado radio) {
    if (!_aceptaNuevosTrazos) return;
    HapticFeedback.selectionClick();
    setState(() {
      _radiosConfirmados.add(radio);
      // Al añadir un nuevo radio, el mensaje anterior (éxito/fallo) deja
      // de aplicar: estás ajustando un nuevo intento.
      _ultimoResultado = null;
    });
  }

  void _actualizarRadioEnCurso(RadioTrazado? radio) {
    setState(() => _radioEnCurso = radio);
  }

  void _deshacerUltimo() {
    if (_radiosConfirmados.isEmpty) return;
    if (_fase == _FaseIntento.celebrando) return;
    HapticFeedback.lightImpact();
    setState(() {
      _radiosConfirmados.removeLast();
      _ultimoResultado = null;
    });
  }

  void _reiniciarIntento() {
    if (_fase == _FaseIntento.celebrando) return;
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
      HapticFeedback.heavyImpact();
      setState(() => _fase = _FaseIntento.celebrando);
      _temporizadorCelebracion?.cancel();
      _temporizadorCelebracion = Timer(const Duration(milliseconds: 1800), () {
        if (!mounted) return;
        setState(() {
          _radiosConfirmados.clear();
          _radioEnCurso = null;
          _ultimoResultado = null;
          _fase = _FaseIntento.dibujando;
        });
      });
    } else {
      HapticFeedback.vibrate();
    }
    // En caso de fallo, NO se resetea: el jugador deshace los trazos que
    // estorben y añade otros. Principio biblia §2.3: los errores son
    // oportunidades, no castigos.
  }

  bool get _destacarExito =>
      _ultimoResultado?.esExito == true || _fase == _FaseIntento.celebrando;

  bool get _destacarFallo =>
      _ultimoResultado != null && !_ultimoResultado!.esExito;

  String _textoMensaje() {
    final resultado = _ultimoResultado;
    if (resultado != null) return resultado.mensajeAmable;

    final cantidad = _radiosConfirmados.length;
    final objetivo = _radiosObjetivo;
    if (cantidad == 0) {
      return 'Desliza desde el centro hacia fuera para trazar un corte.';
    }
    if (cantidad < objetivo) {
      final faltan = objetivo - cantidad;
      return 'Te queda(n) $faltan trazo(s). Si uno no cuadra, toca "Deshacer".';
    }
    return 'Ya tienes todos los trazos. Si encajan, dale a "Cortar".';
  }

  Color _colorMensaje() {
    final resultado = _ultimoResultado;
    if (resultado == null) return PaletaNeon.textoTenue;
    return resultado.esExito ? PaletaNeon.exitoSuave : PaletaNeon.rosaAcento;
  }

  @override
  Widget build(BuildContext contexto) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: PaletaNeon.fondoCiudad),
        child: SafeArea(
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
                  child: LienzoCombate(
                    fragmento: _fragmentoActivo,
                    radiosConfirmados: List.unmodifiable(_radiosConfirmados),
                    radioEnCurso: _radioEnCurso,
                    destacarExito: _destacarExito,
                    destacarFallo: _destacarFallo,
                    aceptaNuevosTrazos: _aceptaNuevosTrazos,
                    onAgregarRadio: _agregarRadio,
                    onActualizarRadioEnCurso: _actualizarRadioEnCurso,
                  ),
                ),
              ),
              _IndicadorProgreso(
                trazosHechos: _radiosConfirmados.length,
                trazosObjetivo: _radiosObjetivo,
              ),
              _FranjaMensaje(
                texto: _textoMensaje(),
                color: _colorMensaje(),
              ),
              _BarraAcciones(
                hayTrazos: _radiosConfirmados.isNotEmpty,
                puedeCortar: _puedeCortarAhora,
                estaCelebrando: _fase == _FaseIntento.celebrando,
                alDeshacer: _deshacerUltimo,
                alReiniciar: _reiniciarIntento,
                alCortar: _evaluarAhora,
              ),
            ],
          ),
        ),
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
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'UNO ROTO',
            style: TextStyle(
              fontSize: 18,
              letterSpacing: 6,
              color: PaletaNeon.textoTenue,
              fontWeight: FontWeight.w300,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Familia B — Unitarios',
            style: TextStyle(
              fontSize: 14,
              color: PaletaNeon.textoTenue,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
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
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
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
            fontSize: 18,
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
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
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

class _FranjaMensaje extends StatelessWidget {
  final String texto;
  final Color color;

  const _FranjaMensaje({required this.texto, required this.color});

  @override
  Widget build(BuildContext contexto) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 4, 24, 12),
      child: Text(
        texto,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: color,
          fontSize: 15,
          height: 1.4,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

class _BarraAcciones extends StatelessWidget {
  final bool hayTrazos;
  final bool puedeCortar;
  final bool estaCelebrando;
  final VoidCallback alDeshacer;
  final VoidCallback alReiniciar;
  final VoidCallback alCortar;

  const _BarraAcciones({
    required this.hayTrazos,
    required this.puedeCortar,
    required this.estaCelebrando,
    required this.alDeshacer,
    required this.alReiniciar,
    required this.alCortar,
  });

  @override
  Widget build(BuildContext contexto) {
    final deshacerActivo = hayTrazos && !estaCelebrando;
    final cortarActivo = puedeCortar && !estaCelebrando;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
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
            etiqueta: 'Empezar de nuevo',
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
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
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
