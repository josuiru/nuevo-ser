import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../dominio/contador_intentos_puzzle.dart';
import '../dominio/fragmento.dart';
import '../dominio/resolucion_corte.dart';
import '../l10n/app_localizations.dart';
import '../nucleo/paleta.dart';
import 'escenario.dart';
import 'lienzo_combate.dart';
import 'particulas_rotura.dart';
import 'pintor_fragmento.dart';

/// Pantalla focalizada en un único Fragmento. Sin Sora, sin dictado,
/// sin línea de "en tres partes". El niño solo ve la etiqueta 1/3 o
/// 2/5 y tiene que descubrir él mismo cuántos cortes hacen falta.
///
/// Devuelve `true` cuando el jugador derrota al Fragmento, `false` si
/// lo deja escapar.
class PantallaCombateEnfoque extends StatefulWidget {
  final int numerador;
  final int denominador;

  const PantallaCombateEnfoque({
    super.key,
    required this.numerador,
    required this.denominador,
  });

  @override
  State<PantallaCombateEnfoque> createState() => _PantallaCombateEnfoqueState();
}

enum _FaseEnfoque { dibujando, rompiendo }

class _PantallaCombateEnfoqueState extends State<PantallaCombateEnfoque>
    with TickerProviderStateMixin {
  static const _evaluador = EvaluadorCorte();

  int _subCombatesResueltos = 0;
  final List<RadioTrazado> _radiosConfirmados = [];
  RadioTrazado? _radioEnCurso;
  ResultadoIntento? _ultimoResultado;
  _FaseEnfoque _fase = _FaseEnfoque.dibujando;

  late final AnimationController _controladorRotura;
  late final AnimationController _controladorAparicion;
  late final AnimationController _controladorCielo;
  late final List<Particula> _particulasRotura;

  FragmentoUnitario get _unitarioActivo =>
      FragmentoUnitario(widget.denominador);

  int get _radiosObjetivo => _unitarioActivo.radiosRequeridos;

  bool get _esCompuesto => widget.numerador > 1;

  int get _subCombatesTotales => widget.numerador;

  bool get _aceptaNuevosTrazos =>
      _fase == _FaseEnfoque.dibujando &&
      _radiosConfirmados.length < _radiosObjetivo;

  bool get _puedeCortarAhora =>
      _fase == _FaseEnfoque.dibujando &&
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
        _gestionarFinSubCombate();
      }
    });
    _controladorAparicion = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..forward();
    _particulasRotura = PintorRotura.generar();
  }

  @override
  void dispose() {
    _controladorCielo.dispose();
    _controladorRotura.dispose();
    _controladorAparicion.dispose();
    super.dispose();
  }

  void _gestionarFinSubCombate() {
    if (_subCombatesResueltos >= _subCombatesTotales) {
      Navigator.of(context).pop(true);
      return;
    }
    setState(() {
      _radiosConfirmados.clear();
      _radioEnCurso = null;
      _ultimoResultado = null;
      _fase = _FaseEnfoque.dibujando;
    });
    _controladorRotura.reset();
    _controladorAparicion
      ..reset()
      ..forward();
  }

  void _agregarRadio(RadioTrazado radio) {
    if (!_aceptaNuevosTrazos) return;
    HapticFeedback.selectionClick();
    setState(() {
      _radiosConfirmados.add(radio);
      _ultimoResultado = null;
    });
  }

  void _actualizarRadioEnCurso(RadioTrazado? radio) {
    setState(() => _radioEnCurso = radio);
  }

  void _deshacerUltimo() {
    if (!_hayTrazos || _fase != _FaseEnfoque.dibujando) return;
    HapticFeedback.lightImpact();
    setState(() {
      _radiosConfirmados.removeLast();
      _ultimoResultado = null;
    });
  }

  /// Reposiciona un radio confirmado: el niño arrastró encima de él y el
  /// lienzo nos pasa el nuevo ángulo. Mantiene su índice; sólo cambia el
  /// valor angular. Coexiste con Deshacer.
  void _moverRadio(int indice, RadioTrazado nuevo) {
    if (_fase != _FaseEnfoque.dibujando) return;
    if (indice < 0 || indice >= _radiosConfirmados.length) return;
    setState(() {
      _radiosConfirmados[indice] = nuevo;
      _ultimoResultado = null;
    });
  }

  void _reiniciarIntento() {
    if (_fase != _FaseEnfoque.dibujando) return;
    setState(() {
      _radiosConfirmados.clear();
      _radioEnCurso = null;
      _ultimoResultado = null;
    });
  }

  void _evaluarAhora() {
    if (!_puedeCortarAhora) return;
    final resultado = _evaluador.evaluar(
      fragmento: _unitarioActivo,
      radios: _radiosConfirmados,
    );
    setState(() => _ultimoResultado = resultado);
    if (resultado.esExito) {
      _subCombatesResueltos++;
      HapticFeedback.heavyImpact();
      setState(() => _fase = _FaseEnfoque.rompiendo);
      _controladorRotura
        ..reset()
        ..forward();
    } else {
      HapticFeedback.vibrate();
      // Cada Cortar fallido cuenta como un intento del puzzle. Sin esto
      // el niño puede equivocarse infinitas veces y, al acertar al fin,
      // ganar las esquirlas como si fuera a la primera. El cazadero usa
      // `intentosPuzzleActual` para descontar la recompensa al cerrar.
      contarFalloPuzzle();
    }
  }

  void _huir() {
    Navigator.of(context).pop(false);
  }

  EstadoFragmento get _estadoFragmento {
    if (_fase == _FaseEnfoque.rompiendo) return EstadoFragmento.apacible;
    if (_ultimoResultado != null && !_ultimoResultado!.esExito) {
      return EstadoFragmento.sorprendido;
    }
    if (_puedeCortarAhora) return EstadoFragmento.nervioso;
    if (_radioEnCurso != null) return EstadoFragmento.alerta;
    return EstadoFragmento.tranquilo;
  }

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
                painter: PintorEscenario(
                  fasePulso: _controladorCielo.value,
                  nivelRestauracion: 0.2,
                ),
              ),
              SafeArea(
                child: Column(
                  children: [
                    _BarraEnfoque(
                      etiqueta: '${widget.numerador}/${widget.denominador}',
                      subCombatesResueltos: _subCombatesResueltos,
                      subCombatesTotales: _subCombatesTotales,
                      esCompuesto: _esCompuesto,
                      alHuir: _huir,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: AnimatedBuilder(
                          animation: Listenable.merge([
                            _controladorRotura,
                            _controladorAparicion,
                          ]),
                          builder: (_, __) {
                            return LienzoCombate(
                              fragmento: _unitarioActivo,
                              radiosConfirmados:
                                  List.unmodifiable(_radiosConfirmados),
                              radioEnCurso: _radioEnCurso,
                              estadoFragmento: _estadoFragmento,
                              destacarExito:
                                  _fase == _FaseEnfoque.rompiendo ||
                                      _ultimoResultado?.esExito == true,
                              destacarFallo: _ultimoResultado != null &&
                                  !_ultimoResultado!.esExito,
                              aceptaNuevosTrazos: _aceptaNuevosTrazos,
                              progresoRotura: _controladorRotura.value,
                              opacidadAparicion: _controladorAparicion.value,
                              particulasRotura: _particulasRotura,
                              onAgregarRadio: _agregarRadio,
                              onActualizarRadioEnCurso: _actualizarRadioEnCurso,
                              onMoverRadio: _moverRadio,
                            );
                          },
                        ),
                      ),
                    ),
                    if (_fase == _FaseEnfoque.dibujando)
                      _IndicadorTrazos(
                        trazosHechos: _radiosConfirmados.length,
                        trazosObjetivo: _radiosObjetivo,
                      ),
                    const SizedBox(height: 12),
                    _BarraAcciones(
                      hayTrazos: _hayTrazos,
                      puedeCortar: _puedeCortarAhora,
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

class _BarraEnfoque extends StatelessWidget {
  final String etiqueta;
  final int subCombatesResueltos;
  final int subCombatesTotales;
  final bool esCompuesto;
  final VoidCallback alHuir;

  const _BarraEnfoque({
    required this.etiqueta,
    required this.subCombatesResueltos,
    required this.subCombatesTotales,
    required this.esCompuesto,
    required this.alHuir,
  });

  @override
  Widget build(BuildContext contexto) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          GestureDetector(
            onTap: alHuir,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(
                  color: PaletaNeon.violetaBase,
                  width: 1.2,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                AppLocalizations.of(contexto).puzzleBotonHuir,
                style: const TextStyle(
                  color: PaletaNeon.textoPrincipal,
                  fontSize: 13,
                  letterSpacing: 1.5,
                ),
              ),
            ),
          ),
          const Spacer(),
          if (esCompuesto)
            Text(
              'trozo ${subCombatesResueltos + 1} de $subCombatesTotales · $etiqueta',
              style: const TextStyle(
                color: PaletaNeon.textoTenue,
                fontSize: 12,
                letterSpacing: 1.5,
              ),
            )
          else
            Text(
              etiqueta,
              style: const TextStyle(
                color: PaletaNeon.textoTenue,
                fontSize: 14,
                letterSpacing: 2,
              ),
            ),
          const Spacer(),
        ],
      ),
    );
  }
}

class _IndicadorTrazos extends StatelessWidget {
  final int trazosHechos;
  final int trazosObjetivo;

  const _IndicadorTrazos({
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
            etiqueta: AppLocalizations.of(contexto).combateBotonDeshacer,
            habilitado: hayTrazos,
            acentuado: false,
            alPulsar: alDeshacer,
          ),
          _BotonAccion(
            etiqueta: AppLocalizations.of(contexto).combateBotonDeNuevo,
            habilitado: hayTrazos,
            acentuado: false,
            alPulsar: alReiniciar,
          ),
          _BotonAccion(
            etiqueta: AppLocalizations.of(contexto).combateBotonCortar,
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
