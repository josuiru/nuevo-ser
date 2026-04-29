import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../dominio/problema_espejo.dart' show Fraccion;
import '../dominio/problema_probabilidad.dart';
import '../l10n/app_localizations.dart';
import '../nucleo/paleta.dart';
import 'escenario.dart';
import '../dominio/contador_intentos_puzzle.dart';

/// Puzzle EST.05: "saco con 3 rojas y 5 azules → P(roja) = ?" + cuatro
/// fracciones candidatas. Mecánica de Laplace básica con reducción.
class PantallaProbabilidad extends StatefulWidget {
  final ProblemaProbabilidad? problemaPredeterminado;

  const PantallaProbabilidad({super.key, this.problemaPredeterminado});

  @override
  State<PantallaProbabilidad> createState() => _PantallaProbabilidadState();
}

class _PantallaProbabilidadState extends State<PantallaProbabilidad>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controladorCielo;
  late ProblemaProbabilidad _problema;
  int? _indiceSeleccionado;
  bool _revelado = false;

  @override
  void initState() {
    super.initState();
    _controladorCielo = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 16),
    )..repeat();
    _problema = widget.problemaPredeterminado ??
        GeneradorProbabilidad().generar(dificultad: 1);
  }

  @override
  void dispose() {
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
      Future.delayed(const Duration(milliseconds: 1100), () {
        if (!mounted) return;
        Navigator.of(context).pop(true);
      });
    } else {
      HapticFeedback.vibrate();
      contarFalloPuzzle();
      Future.delayed(const Duration(milliseconds: 900), () {
        if (!mounted) return;
        setState(() => _revelado = false);
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
                                  color: PaletaNeon.textoTenue,
                                  fontSize: 13,
                                  letterSpacing: 1.5,
                                ),
                              ),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            AppLocalizations.of(contexto).puzzleHeaderProbabilidad,
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
                        AppLocalizations.of(contexto)
                            .puzzleInstrProbabilidadSaco(
                          _problema.favorables,
                          _problema.otros,
                        ),
                        style: const TextStyle(
                          color: PaletaNeon.textoPrincipal,
                          fontSize: 18,
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        AppLocalizations.of(contexto)
                            .puzzleInstrProbabilidadFormula,
                        style: const TextStyle(
                          color: PaletaNeon.azulNeon,
                          fontSize: 22,
                          fontWeight: FontWeight.w300,
                          letterSpacing: 1.2,
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
                              _TarjetaFraccion(
                                fraccion: _problema.candidatos[indice],
                                seleccionado: _indiceSeleccionado == indice,
                                marcarCorrecto: _revelado &&
                                    _indiceSeleccionado == indice &&
                                    indice == _problema.indiceCorrecto,
                                marcarIncorrecto: _revelado &&
                                    _indiceSeleccionado == indice &&
                                    indice != _problema.indiceCorrecto,
                                alTocar: () => _elegir(indice),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _TarjetaFraccion extends StatelessWidget {
  final Fraccion fraccion;
  final bool seleccionado;
  final bool marcarCorrecto;
  final bool marcarIncorrecto;
  final VoidCallback alTocar;

  const _TarjetaFraccion({
    required this.fraccion,
    required this.seleccionado,
    required this.marcarCorrecto,
    required this.marcarIncorrecto,
    required this.alTocar,
  });

  @override
  Widget build(BuildContext contexto) {
    final colorBorde = marcarCorrecto
        ? PaletaNeon.exitoSuave
        : marcarIncorrecto
            ? PaletaNeon.rosaAcento
            : seleccionado
                ? PaletaNeon.azulNeon
                : PaletaNeon.violetaBase;
    final colorTexto = marcarCorrecto
        ? PaletaNeon.exitoSuave
        : marcarIncorrecto
            ? PaletaNeon.rosaAcento
            : PaletaNeon.textoPrincipal;
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
              : const [],
        ),
        child: Center(
          child: fraccion.denominador == 1
              ? Text(
                  '${fraccion.numerador}',
                  style: TextStyle(
                    color: colorTexto,
                    fontSize: 32,
                    fontWeight: FontWeight.w300,
                  ),
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${fraccion.numerador}',
                      style: TextStyle(
                        color: colorTexto,
                        fontSize: 26,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    Container(
                      width: 36,
                      height: 1.6,
                      color: colorTexto.withOpacity(0.7),
                    ),
                    Text(
                      '${fraccion.denominador}',
                      style: TextStyle(
                        color: colorTexto,
                        fontSize: 26,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
