import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../dominio/problema_espejo.dart' show Fraccion;
import '../dominio/problema_mixto_a_impropio.dart';
import '../l10n/app_localizations.dart';
import '../nucleo/paleta.dart';
import 'escenario.dart';
import '../dominio/contador_intentos_puzzle.dart';

/// Puzzle FR.13: el niño ve un número mixto ("2 y 3/4") y elige la
/// fracción impropia equivalente entre cuatro candidatos. Inverso de
/// FR.12 — los distractores reflejan los errores reales que comete el
/// niño al hacer la conversión.
class PantallaMixtoAImpropio extends StatefulWidget {
  final ProblemaMixtoAImpropio? problemaPredeterminado;

  const PantallaMixtoAImpropio({super.key, this.problemaPredeterminado});

  @override
  State<PantallaMixtoAImpropio> createState() =>
      _PantallaMixtoAImpropioState();
}

class _PantallaMixtoAImpropioState extends State<PantallaMixtoAImpropio>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controladorCielo;
  late ProblemaMixtoAImpropio _problema;
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
        GeneradorMixtoAImpropio().generar(dificultad: 1);
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
                          Text(AppLocalizations.of(contexto).puzzleHeaderConvertir,
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
                      const SizedBox(height: 32),
                      Text(
                        AppLocalizations.of(contexto).puzzleInstrConvertirImpropia,
                        style: const TextStyle(
                          color: PaletaNeon.textoPrincipal,
                          fontSize: 18,
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      const SizedBox(height: 22),
                      _TarjetaMixto(
                        entero: _problema.entero,
                        numerador: _problema.numerador,
                        denominador: _problema.denominador,
                      ),
                      const SizedBox(height: 36),
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

class _TarjetaMixto extends StatelessWidget {
  final int entero;
  final int numerador;
  final int denominador;

  const _TarjetaMixto({
    required this.entero,
    required this.numerador,
    required this.denominador,
  });

  @override
  Widget build(BuildContext contexto) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 22),
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '$entero',
            style: const TextStyle(
              color: PaletaNeon.textoPrincipal,
              fontSize: 56,
              fontWeight: FontWeight.w300,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(width: 16),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$numerador',
                style: const TextStyle(
                  color: PaletaNeon.textoPrincipal,
                  fontSize: 36,
                  fontWeight: FontWeight.w300,
                ),
              ),
              Container(
                width: 44,
                height: 1.8,
                color: PaletaNeon.textoPrincipal,
                margin: const EdgeInsets.symmetric(vertical: 4),
              ),
              Text(
                '$denominador',
                style: const TextStyle(
                  color: PaletaNeon.textoPrincipal,
                  fontSize: 36,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TarjetaCandidato extends StatelessWidget {
  final Fraccion fraccion;
  final bool seleccionado;
  final bool marcarCorrecto;
  final bool marcarIncorrecto;
  final VoidCallback alTocar;

  const _TarjetaCandidato({
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
              : const [],
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${fraccion.numerador}',
                style: TextStyle(
                  color: colorTexto,
                  fontSize: 32,
                  fontWeight: FontWeight.w300,
                ),
              ),
              Container(
                width: 36,
                height: 1.6,
                color: colorTexto,
                margin: const EdgeInsets.symmetric(vertical: 4),
              ),
              Text(
                '${fraccion.denominador}',
                style: TextStyle(
                  color: colorTexto,
                  fontSize: 32,
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
