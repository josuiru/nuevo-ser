import '../dominio/fragmento_en_tejado.dart' show TipoFragmentoEnTejado;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../dominio/respuesta_puzzle.dart';

import '../datos/repositorio_progreso.dart';
import '../dominio/problema_razon.dart';
import '../l10n/app_localizations.dart';
import '../l10n/traducciones_narrativa.dart';
import '../nucleo/paleta.dart';
import 'escenario.dart';
import 'estado_pista_puzzle.dart';
import 'overlay_demo_puzzle.dart';
import '../dominio/contador_intentos_puzzle.dart';
import 'widgets/boton_ayuda_puzzle.dart';
import 'widgets/ayuda_tras_fallos.dart';

/// Puzzle PROP.01: el niño ve dos cantidades en un contexto concreto
/// y elige la razón reducida que las relaciona entre cuatro candidatos.
/// Mecánica clave: identificar que la razón es la forma mínima.
class PantallaRazon extends StatefulWidget {
  final ProblemaRazon? problemaPredeterminado;

  const PantallaRazon({super.key, this.problemaPredeterminado});

  @override
  State<PantallaRazon> createState() => _PantallaRazonState();
}

class _PantallaRazonState extends State<PantallaRazon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controladorCielo;
  late final EstadoPistaPuzzle _pista;
  late ProblemaRazon _problema;
  int? _indiceSeleccionado;
  bool _revelado = false;
  bool _mostrandoDemo = false;
  static const _idDemo = 'razon';

  @override
  void initState() {
    super.initState();
    _controladorCielo = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 16),
    )..repeat();
    _pista = EstadoPistaPuzzle(alCambiar: () => setState(() {}));
    _problema = widget.problemaPredeterminado ??
        GeneradorRazon().generar(dificultad: 1);
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
      UltimaRespuestaPuzzle.registrar(RespuestaPuzzle(
        acertado: true,
        respuestaDelNino: _problema.candidatos[indice].etiqueta,
        respuestaCorrecta: _problema.candidatos[_problema.indiceCorrecto].etiqueta,
        preguntaTexto: 'elige la opción correcta',
        opciones: _problema.candidatos.map((c) => c.etiqueta).toList(),
      ));
      Future.delayed(const Duration(milliseconds: 1100), () {
        if (!mounted) return;
        Navigator.of(context).pop(true);
      });
    } else {
      HapticFeedback.vibrate();
      contarFalloPuzzle();
      _pista.registrarFallo();
      comprobarYAyudarSiProcede(context, _pista, TipoFragmentoEnTejado.razon);
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
                          Text(AppLocalizations.of(contexto).puzzleHeaderRazon,
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
                        AppLocalizations.of(contexto).puzzleInstrRazon,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: PaletaNeon.textoPrincipal,
                          fontSize: 18,
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      const SizedBox(height: 22),
                      _TarjetaContexto(
                        primero: _problema.primero,
                        segundo: _problema.segundo,
                        etiquetaPrimero: traducirNarrativa(
                          _problema.etiquetaPrimero,
                          Localizations.localeOf(contexto),
                        ),
                        etiquetaSegundo: traducirNarrativa(
                          _problema.etiquetaSegundo,
                          Localizations.localeOf(contexto),
                        ),
                      ),
                      const SizedBox(height: 32),
                      Expanded(
                        child: GridView.count(
                          crossAxisCount: 2,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 1.4,
                          children: [
                            for (var indice = 0;
                                indice < _problema.candidatos.length;
                                indice++)
                              _TarjetaCandidato(
                                etiqueta:
                                    _problema.candidatos[indice].etiqueta,
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
              BotonAyudaPuzzle(destacar: _pista.activa, tipo: TipoFragmentoEnTejado.razon),
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

/// Caja con el contexto: dos cantidades con su etiqueta.
class _TarjetaContexto extends StatelessWidget {
  final int primero;
  final int segundo;
  final String etiquetaPrimero;
  final String etiquetaSegundo;

  const _TarjetaContexto({
    required this.primero,
    required this.segundo,
    required this.etiquetaPrimero,
    required this.etiquetaSegundo,
  });

  @override
  Widget build(BuildContext contexto) {
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _LineaContexto(numero: primero, etiqueta: etiquetaPrimero),
          const SizedBox(height: 8),
          Text(
            'y',
            style: TextStyle(
              color: PaletaNeon.textoTenue.withOpacity(0.8),
              fontSize: 18,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w300,
            ),
          ),
          const SizedBox(height: 8),
          _LineaContexto(numero: segundo, etiqueta: etiquetaSegundo),
        ],
      ),
    );
  }
}

class _LineaContexto extends StatelessWidget {
  final int numero;
  final String etiqueta;

  const _LineaContexto({required this.numero, required this.etiqueta});

  @override
  Widget build(BuildContext contexto) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          '$numero',
          style: const TextStyle(
            color: PaletaNeon.textoPrincipal,
            fontSize: 32,
            fontWeight: FontWeight.w300,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          etiqueta,
          style: const TextStyle(
            color: PaletaNeon.textoPrincipal,
            fontSize: 20,
            fontWeight: FontWeight.w300,
            letterSpacing: 0.8,
          ),
        ),
      ],
    );
  }
}

class _TarjetaCandidato extends StatelessWidget {
  final String etiqueta;
  final bool seleccionado;
  final bool marcarCorrecto;
  final bool marcarIncorrecto;
  final bool marcarPista;
  final VoidCallback alTocar;

  const _TarjetaCandidato({
    required this.etiqueta,
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
            etiqueta,
            style: TextStyle(
              color: marcarCorrecto
                  ? PaletaNeon.exitoSuave
                  : marcarIncorrecto
                      ? PaletaNeon.rosaAcento
                      : PaletaNeon.textoPrincipal,
              fontSize: 32,
              fontWeight: FontWeight.w300,
              letterSpacing: 1.2,
            ),
          ),
        ),
      ),
    );
  }
}
