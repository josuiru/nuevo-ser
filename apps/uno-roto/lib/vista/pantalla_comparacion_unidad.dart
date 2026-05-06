import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../datos/repositorio_progreso.dart';
import '../dominio/problema_comparacion_unidad.dart';
import '../l10n/app_localizations.dart';
import '../nucleo/paleta.dart';
import 'escenario.dart';
import 'estado_pista_puzzle.dart';
import 'overlay_demo_puzzle.dart';
import '../dominio/contador_intentos_puzzle.dart';

/// Puzzle FR.04: el niño ve una fracción grande y elige si es menor,
/// igual o mayor que 1. Tres botones — primera mecánica de tres
/// opciones en Uno Roto (la divisibilidad fue binaria).
class PantallaComparacionUnidad extends StatefulWidget {
  final ProblemaComparacionUnidad? problemaPredeterminado;

  const PantallaComparacionUnidad({super.key, this.problemaPredeterminado});

  @override
  State<PantallaComparacionUnidad> createState() =>
      _PantallaComparacionUnidadState();
}

class _PantallaComparacionUnidadState extends State<PantallaComparacionUnidad>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controladorCielo;
  late final EstadoPistaPuzzle _pista;
  late ProblemaComparacionUnidad _problema;
  RelacionConUnidad? _respuestaDada;
  bool _revelado = false;
  bool _mostrandoDemo = false;
  static const _idDemo = 'comparacion_unidad';

  @override
  void initState() {
    super.initState();
    _controladorCielo = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 16),
    )..repeat();
    _pista = EstadoPistaPuzzle(alCambiar: () => setState(() {}));
    _problema = widget.problemaPredeterminado ??
        GeneradorComparacionUnidad().generar(dificultad: 1);
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

  void _responder(RelacionConUnidad opcion) {
    if (_revelado &&
        _respuestaDada != null &&
        _problema.esCorrecta(_respuestaDada!)) {
      return;
    }
    setState(() {
      _respuestaDada = opcion;
      _revelado = true;
    });
    if (_problema.esCorrecta(opcion)) {
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
                          Text(AppLocalizations.of(contexto).puzzleHeaderContraUno,
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
                      const Spacer(),
                      Text(
                        _problema.fraccion.etiqueta,
                        style: const TextStyle(
                          color: PaletaNeon.textoPrincipal,
                          fontSize: 96,
                          fontWeight: FontWeight.w200,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        AppLocalizations.of(contexto).puzzleInstrContraUno,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: PaletaNeon.textoPrincipal,
                          fontSize: 20,
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Expanded(
                            child: _BotonOpcion(
                              etiqueta: '< 1',
                              colorPrincipal: PaletaNeon.azulNeon,
                              opcion: RelacionConUnidad.menor,
                              respuestaDada: _respuestaDada,
                              revelado: _revelado,
                              esCorrecta: _problema.esCorrecta(
                                  RelacionConUnidad.menor),
                              marcarPista: _pista.activa &&
                                  _problema.esCorrecta(
                                      RelacionConUnidad.menor),
                              alTocar: () =>
                                  _responder(RelacionConUnidad.menor),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _BotonOpcion(
                              etiqueta: '= 1',
                              colorPrincipal: PaletaNeon.violetaNeon,
                              opcion: RelacionConUnidad.igual,
                              respuestaDada: _respuestaDada,
                              revelado: _revelado,
                              esCorrecta: _problema.esCorrecta(
                                  RelacionConUnidad.igual),
                              marcarPista: _pista.activa &&
                                  _problema.esCorrecta(
                                      RelacionConUnidad.igual),
                              alTocar: () =>
                                  _responder(RelacionConUnidad.igual),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _BotonOpcion(
                              etiqueta: '> 1',
                              colorPrincipal: PaletaNeon.exitoSuave,
                              opcion: RelacionConUnidad.mayor,
                              respuestaDada: _respuestaDada,
                              revelado: _revelado,
                              esCorrecta: _problema.esCorrecta(
                                  RelacionConUnidad.mayor),
                              marcarPista: _pista.activa &&
                                  _problema.esCorrecta(
                                      RelacionConUnidad.mayor),
                              alTocar: () =>
                                  _responder(RelacionConUnidad.mayor),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
              if (_mostrandoDemo)
                OverlayDemoPuzzle(
                  mensaje: AppLocalizations.of(contexto)
                      .demoPuzzleTocaResultado,
                  alCerrar: _cerrarDemo,
                  posicionRelativa: const Alignment(0, 0.55),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _BotonOpcion extends StatelessWidget {
  final String etiqueta;
  final Color colorPrincipal;
  final RelacionConUnidad opcion;
  final RelacionConUnidad? respuestaDada;
  final bool revelado;
  final bool esCorrecta;
  final bool marcarPista;
  final VoidCallback alTocar;

  const _BotonOpcion({
    required this.etiqueta,
    required this.colorPrincipal,
    required this.opcion,
    required this.respuestaDada,
    required this.revelado,
    required this.esCorrecta,
    required this.alTocar,
    this.marcarPista = false,
  });

  @override
  Widget build(BuildContext contexto) {
    final seleccionado = respuestaDada == opcion;
    final marcarCorrecto = revelado && seleccionado && esCorrecta;
    final marcarIncorrecto = revelado && seleccionado && !esCorrecta;
    final colorBorde = marcarCorrecto
        ? PaletaNeon.exitoSuave
        : marcarIncorrecto
            ? PaletaNeon.rosaAcento
            : seleccionado
                ? colorPrincipal
                : marcarPista
                    ? PaletaNeon.exitoSuave.withOpacity(0.6)
                    : colorPrincipal.withOpacity(0.55);
    final brilloIntenso = marcarCorrecto || marcarIncorrecto || seleccionado;
    return GestureDetector(
      onTap: alTocar,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        height: 92,
        decoration: BoxDecoration(
          color: PaletaNeon.fondoMedio.withOpacity(0.55),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: colorBorde, width: 2),
          boxShadow: brilloIntenso
              ? [
                  BoxShadow(
                    color: colorBorde.withOpacity(0.4),
                    blurRadius: 22,
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
            etiqueta,
            style: TextStyle(
              color: marcarCorrecto
                  ? PaletaNeon.exitoSuave
                  : marcarIncorrecto
                      ? PaletaNeon.rosaAcento
                      : PaletaNeon.textoPrincipal,
              fontSize: 28,
              fontWeight: FontWeight.w300,
              letterSpacing: 1.6,
            ),
          ),
        ),
      ),
    );
  }
}
