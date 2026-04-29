import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../dominio/problema_comparacion_distinta.dart';
import '../l10n/app_localizations.dart';
import '../nucleo/paleta.dart';
import 'escenario.dart';
import '../dominio/contador_intentos_puzzle.dart';

/// Puzzle FR.07: el niño ve dos fracciones sin nada en común
/// (denominadores y numeradores distintos) y toca la mayor. El sesgo
/// del generador hace que la intuición simple ("más numerador gana"
/// o "menos denominador gana") falle a menudo — la pista es justo
/// no fiarse de las cifras sueltas.
class PantallaComparacionDistinta extends StatefulWidget {
  final ProblemaComparacionDistinta? problemaPredeterminado;

  const PantallaComparacionDistinta({
    super.key,
    this.problemaPredeterminado,
  });

  @override
  State<PantallaComparacionDistinta> createState() =>
      _PantallaComparacionDistintaState();
}

class _PantallaComparacionDistintaState
    extends State<PantallaComparacionDistinta>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controladorCielo;
  late final ProblemaComparacionDistinta _problema;
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
        GeneradorComparacionDistinta().generar(dificultad: 1);
  }

  @override
  void dispose() {
    _controladorCielo.dispose();
    super.dispose();
  }

  void _elegir(int indice) {
    if (_revelado &&
        _indiceSeleccionado != null &&
        _problema.esCorrecta(_indiceSeleccionado!)) {
      return;
    }
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
                          Text(AppLocalizations.of(contexto).puzzleHeaderComparar,
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
                      const SizedBox(height: 36),
                      Text(
                        AppLocalizations.of(contexto).puzzleInstrCualEsMayor,
                        style: const TextStyle(
                          color: PaletaNeon.textoPrincipal,
                          fontSize: 20,
                          letterSpacing: 1.4,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(AppLocalizations.of(contexto).puzzleInstrMiraValor,
                        style: TextStyle(
                          color: PaletaNeon.textoTenue.withOpacity(0.8),
                          fontSize: 12,
                          letterSpacing: 1.4,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 32),
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: _TarjetaOpcion(
                                etiqueta: _problema.a.etiqueta,
                                seleccionado: _indiceSeleccionado == 0,
                                marcarCorrecto: _revelado &&
                                    _indiceSeleccionado == 0 &&
                                    _problema.indiceMayor == 0,
                                marcarIncorrecto: _revelado &&
                                    _indiceSeleccionado == 0 &&
                                    _problema.indiceMayor != 0,
                                alTocar: () => _elegir(0),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _TarjetaOpcion(
                                etiqueta: _problema.b.etiqueta,
                                seleccionado: _indiceSeleccionado == 1,
                                marcarCorrecto: _revelado &&
                                    _indiceSeleccionado == 1 &&
                                    _problema.indiceMayor == 1,
                                marcarIncorrecto: _revelado &&
                                    _indiceSeleccionado == 1 &&
                                    _problema.indiceMayor != 1,
                                alTocar: () => _elegir(1),
                              ),
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

class _TarjetaOpcion extends StatelessWidget {
  final String etiqueta;
  final bool seleccionado;
  final bool marcarCorrecto;
  final bool marcarIncorrecto;
  final VoidCallback alTocar;

  const _TarjetaOpcion({
    required this.etiqueta,
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
    final brilloIntenso = marcarCorrecto || marcarIncorrecto || seleccionado;
    return GestureDetector(
      onTap: alTocar,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        constraints: const BoxConstraints(minHeight: 220),
        decoration: BoxDecoration(
          color: PaletaNeon.fondoMedio.withOpacity(0.55),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: colorBorde, width: 1.8),
          boxShadow: brilloIntenso
              ? [
                  BoxShadow(
                    color: colorBorde.withOpacity(0.4),
                    blurRadius: 22,
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
              fontSize: 52,
              fontWeight: FontWeight.w300,
              letterSpacing: 1.4,
            ),
          ),
        ),
      ),
    );
  }
}
