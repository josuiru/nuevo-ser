import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../dominio/problema_espejo.dart' show Fraccion;
import '../dominio/problema_lectura_fraccion.dart';
import '../l10n/app_localizations.dart';
import '../l10n/traducciones_narrativa.dart';
import '../nucleo/paleta.dart';
import 'escenario.dart';
import '../dominio/contador_intentos_puzzle.dart';

/// Puzzle FR.02: el niño ve una fracción escrita en palabras
/// ("tres quintos") y elige la fracción equivalente entre cuatro
/// candidatos. Mecánica simétrica a DEC.01 (texto → número), pero
/// con las trampas propias de la lectura de fracciones: invertir
/// num/den, mismo número arriba y abajo, ordinales mal leídos.
class PantallaLecturaFraccion extends StatefulWidget {
  final ProblemaLecturaFraccion? problemaPredeterminado;

  const PantallaLecturaFraccion({super.key, this.problemaPredeterminado});

  @override
  State<PantallaLecturaFraccion> createState() =>
      _PantallaLecturaFraccionState();
}

class _PantallaLecturaFraccionState extends State<PantallaLecturaFraccion>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controladorCielo;
  late ProblemaLecturaFraccion _problema;
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
        GeneradorLecturaFraccion().generar(dificultad: 1);
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
                          Text(AppLocalizations.of(contexto).puzzleHeaderLeer,
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
                        AppLocalizations.of(contexto).puzzleInstrQueFraccion,
                        style: const TextStyle(
                          color: PaletaNeon.textoPrincipal,
                          fontSize: 18,
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      const SizedBox(height: 22),
                      _TarjetaTexto(
                        texto: traducirNarrativa(
                          _problema.texto,
                          Localizations.localeOf(contexto),
                        ),
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

class _TarjetaTexto extends StatelessWidget {
  final String texto;

  const _TarjetaTexto({required this.texto});

  @override
  Widget build(BuildContext contexto) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 22),
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
      child: Text(
        texto,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: PaletaNeon.textoPrincipal,
          fontSize: 28,
          fontWeight: FontWeight.w300,
          letterSpacing: 1.2,
          height: 1.25,
        ),
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
                  letterSpacing: 1.2,
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
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
