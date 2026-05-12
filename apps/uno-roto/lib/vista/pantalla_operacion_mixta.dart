import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../datos/repositorio_progreso.dart';
import '../dominio/fragmento_en_tejado.dart' show SimboloOperador, TipoFragmentoEnTejado;

import '../dominio/problema_operacion_mixta.dart';
import '../dominio/problema_espejo.dart' show Fraccion;
import '../l10n/app_localizations.dart';
import '../nucleo/paleta.dart';
import 'escenario.dart';
import 'estado_pista_puzzle.dart';
import 'overlay_demo_puzzle.dart';
import '../dominio/contador_intentos_puzzle.dart';
import 'widgets/boton_ayuda_puzzle.dart';
import 'widgets/ayuda_tras_fallos.dart';

/// Puzzle OP.03: el niño ve "0,5 + 1/4" o "1/2 × 0,4" y elige el
/// resultado decimal correcto entre cuatro candidatos. La trampa
/// estrella: leer el numerador como décimas (1/4 → 0,4 en vez de
/// 0,25).
class PantallaOperacionMixta extends StatefulWidget {
  final ProblemaOperacionMixta? problemaPredeterminado;

  const PantallaOperacionMixta({
    super.key,
    this.problemaPredeterminado,
  });

  @override
  State<PantallaOperacionMixta> createState() => _PantallaOperacionMixtaState();
}

class _PantallaOperacionMixtaState extends State<PantallaOperacionMixta>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controladorCielo;
  late final EstadoPistaPuzzle _pista;
  late ProblemaOperacionMixta _problema;
  int? _indiceSeleccionado;
  bool _revelado = false;
  bool _mostrandoDemo = false;
  static const _idDemo = 'operacion_mixta';

  @override
  void initState() {
    super.initState();
    _controladorCielo = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 16),
    )..repeat();
    _pista = EstadoPistaPuzzle(alCambiar: () => setState(() {}));
    _problema = widget.problemaPredeterminado ??
        GeneradorOperacionMixta().generar(dificultad: 1);
    _decidirSiMostrarDemo();
  }

  Future<void> _decidirSiMostrarDemo() async {
    final repositorio = RepositorioProgreso();
    final vistos = await repositorio.cargarDemosPuzzlesVistos();
    if (!mounted || vistos.contains(_idDemo)) return;
    setState(() => _mostrandoDemo = true);
  }

  Future<void> _cerrarDemo() async {
    if (!_mostrandoDemo) return;
    setState(() => _mostrandoDemo = false);
    await RepositorioProgreso().marcarDemoPuzzleVisto(_idDemo);
  }

  @override
  void dispose() {
    _pista.dispose();
    _controladorCielo.dispose();
    super.dispose();
  }

  void _elegir(int indice) {
    if (_revelado && _indiceSeleccionado == _problema.indiceCorrecto) return;
    setState(() {
      _indiceSeleccionado = indice;
      _revelado = true;
    });
    if (_problema.esCorrecta(indice)) {
      HapticFeedback.heavyImpact();
      _pista.registrarAcierto();
      Future.delayed(const Duration(milliseconds: 1100), () {
        if (!mounted) return;
        Navigator.of(context).pop(true);
      });
    } else {
      HapticFeedback.vibrate();
      contarFalloPuzzle();
      _pista.registrarFallo();
      comprobarYAyudarSiProcede(context, _pista, TipoFragmentoEnTejado.operacionMixta);
      if (!mounted) return;
      Future.delayed(const Duration(milliseconds: 900), () {
        if (!mounted) return;
        setState(() => _revelado = false);
        _pista.mostrarSiToca();
      });
    }
  }

  void _huir() {
    Navigator.of(context).pop(false);
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
                  nivelRestauracion: 0.3,
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: _huir,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
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
                          Text(AppLocalizations.of(contexto).puzzleHeaderDecimalFraccion,
                            style: const TextStyle(
                              color: PaletaNeon.textoTenue,
                              fontSize: 12,
                              letterSpacing: 3,
                            ),
                          ),
                          const Spacer(),
                          const SizedBox(width: 58),
                        ],
                      ),
                      const SizedBox(height: 22),
                      Text(
                        AppLocalizations.of(contexto).puzzleInstrFraccionDecimal,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: PaletaNeon.textoPrincipal,
                          fontSize: 17,
                          letterSpacing: 1.1,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      const SizedBox(height: 22),
                      _TarjetaExpresionMixta(problema: _problema),
                      const SizedBox(height: 32),
                      Expanded(
                        child: GridView.count(
                          crossAxisCount: 2,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 1.6,
                          children: [
                            for (var indice = 0;
                                indice < _problema.candidatosDecimales.length;
                                indice++)
                              _TarjetaCandidatoDecimal(
                                valor: _problema.candidatosDecimales[indice],
                                seleccionado: _indiceSeleccionado == indice,
                                marcarCorrecto: _revelado &&
                                    _indiceSeleccionado == indice &&
                                    indice == _problema.indiceCorrecto,
                                marcarIncorrecto: _revelado &&
                                    _indiceSeleccionado == indice &&
                                    indice != _problema.indiceCorrecto,
                                marcarPista: _pista.activa &&
                                    indice == _problema.indiceCorrecto,
                                alTocar: () => _elegir(indice),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              BotonAyudaPuzzle(destacar: _pista.activa, tipo: TipoFragmentoEnTejado.operacionMixta),
              if (_mostrandoDemo)
                OverlayDemoPuzzle(
                  mensaje: AppLocalizations.of(contexto)
                      .demoPuzzleTocaResultado,
                  alCerrar: _cerrarDemo,
                  posicionRelativa: const Alignment(0, 0.4),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _TarjetaExpresionMixta extends StatelessWidget {
  final ProblemaOperacionMixta problema;
  const _TarjetaExpresionMixta({required this.problema});

  @override
  Widget build(BuildContext contexto) {
    final hijos = problema.decimalPrimero
        ? <Widget>[
            _OperandoDecimal(valor: problema.valorDecimal),
            const SizedBox(width: 12),
            _OperadorMixto(simbolo: problema.operador.simbolo),
            const SizedBox(width: 12),
            _OperandoFraccion(fraccion: problema.fraccion),
          ]
        : <Widget>[
            _OperandoFraccion(fraccion: problema.fraccion),
            const SizedBox(width: 12),
            _OperadorMixto(simbolo: problema.operador.simbolo),
            const SizedBox(width: 12),
            _OperandoDecimal(valor: problema.valorDecimal),
          ];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
      decoration: BoxDecoration(
        color: PaletaNeon.violetaBase.withOpacity(0.4),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: PaletaNeon.azulNeon, width: 2),
        boxShadow: [
          BoxShadow(
            color: PaletaNeon.azulNeon.withOpacity(0.4),
            blurRadius: 22,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ...hijos,
          const SizedBox(width: 14),
          const Text(
            '=',
            style: TextStyle(
              color: PaletaNeon.azulNeon,
              fontSize: 28,
              fontWeight: FontWeight.w300,
            ),
          ),
          const SizedBox(width: 10),
          const Text(
            '?',
            style: TextStyle(
              color: PaletaNeon.textoPrincipal,
              fontSize: 30,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }
}

class _OperandoDecimal extends StatelessWidget {
  final double valor;
  const _OperandoDecimal({required this.valor});

  @override
  Widget build(BuildContext contexto) {
    return Text(
      formatearDecimalEsAOrtografia(valor),
      style: const TextStyle(
        color: PaletaNeon.textoPrincipal,
        fontSize: 30,
        fontWeight: FontWeight.w300,
      ),
    );
  }
}

class _OperandoFraccion extends StatelessWidget {
  final Fraccion fraccion;
  const _OperandoFraccion({required this.fraccion});

  @override
  Widget build(BuildContext contexto) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '${fraccion.numerador}',
          style: const TextStyle(
            color: PaletaNeon.textoPrincipal,
            fontSize: 22,
            fontWeight: FontWeight.w300,
          ),
        ),
        Container(
          width: 28,
          height: 1.4,
          color: PaletaNeon.textoPrincipal.withOpacity(0.7),
        ),
        Text(
          '${fraccion.denominador}',
          style: const TextStyle(
            color: PaletaNeon.textoPrincipal,
            fontSize: 22,
            fontWeight: FontWeight.w300,
          ),
        ),
      ],
    );
  }
}

class _OperadorMixto extends StatelessWidget {
  final String simbolo;
  const _OperadorMixto({required this.simbolo});

  @override
  Widget build(BuildContext contexto) {
    return Text(
      simbolo,
      style: const TextStyle(
        color: PaletaNeon.azulNeon,
        fontSize: 28,
        fontWeight: FontWeight.w300,
      ),
    );
  }
}

class _TarjetaCandidatoDecimal extends StatelessWidget {
  final double valor;
  final bool seleccionado;
  final bool marcarCorrecto;
  final bool marcarIncorrecto;
  final bool marcarPista;
  final VoidCallback alTocar;

  const _TarjetaCandidatoDecimal({
    required this.valor,
    required this.seleccionado,
    required this.marcarCorrecto,
    required this.marcarIncorrecto,
    required this.alTocar,
    this.marcarPista = false,
  });

  @override
  Widget build(BuildContext contexto) {
    final colorBorde = marcarCorrecto
        ? PaletaNeon.exitoSuave
        : marcarIncorrecto
            ? PaletaNeon.rosaAcento
            : seleccionado
                ? PaletaNeon.azulNeon
                : marcarPista
                    ? PaletaNeon.exitoSuave.withOpacity(0.6)
                    : PaletaNeon.violetaBase;
    final brilloIntenso = marcarCorrecto || marcarIncorrecto || seleccionado;
    final colorTexto = marcarCorrecto
        ? PaletaNeon.exitoSuave
        : marcarIncorrecto
            ? PaletaNeon.rosaAcento
            : PaletaNeon.textoPrincipal;
    return GestureDetector(
      onTap: alTocar,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        decoration: BoxDecoration(
          color: PaletaNeon.fondoMedio.withOpacity(0.55),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: colorBorde, width: 1.6),
          boxShadow: brilloIntenso
              ? [
                  BoxShadow(
                    color: colorBorde.withOpacity(0.4),
                    blurRadius: 18,
                  ),
                ]
              : marcarPista
                  ? [
                      BoxShadow(
                        color: PaletaNeon.exitoSuave.withOpacity(0.35),
                        blurRadius: 16,
                      ),
                    ]
                  : const [],
        ),
        child: Center(
          child: Text(
            formatearDecimalEsAOrtografia(valor),
            style: TextStyle(
              color: colorTexto,
              fontSize: 30,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
      ),
    );
  }
}
