import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../dominio/problema_comparacion_decimal.dart';
import '../l10n/app_localizations.dart';
import '../nucleo/paleta.dart';
import 'escenario.dart';
import '../dominio/contador_intentos_puzzle.dart';

/// Puzzle DEC.02: dos decimales lado a lado, el niño toca el mayor.
/// Visualmente paralelo a [PantallaComparacion] pero con etiquetas de
/// decimal y la pista pedagógica que importa aquí: leer todas las
/// cifras, no contar dígitos.
class PantallaComparacionDecimal extends StatefulWidget {
  /// Si llega un problema preconstruido (porque lo generó el cazador)
  /// se usa tal cual. Si es null, la pantalla genera uno propio.
  final ProblemaComparacionDecimal? problemaPredeterminado;

  const PantallaComparacionDecimal({
    super.key,
    this.problemaPredeterminado,
  });

  @override
  State<PantallaComparacionDecimal> createState() =>
      _PantallaComparacionDecimalState();
}

class _PantallaComparacionDecimalState
    extends State<PantallaComparacionDecimal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controladorCielo;
  late final ProblemaComparacionDecimal _problema;
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
        GeneradorComparacionDecimal().generar(dificultad: 2);
  }

  @override
  void dispose() {
    _controladorCielo.dispose();
    super.dispose();
  }

  void _elegir(int indice) {
    if (_revelado && _problema.esCorrecto(_indiceSeleccionado ?? -1)) return;
    setState(() {
      _indiceSeleccionado = indice;
      _revelado = true;
    });
    if (_problema.esCorrecto(indice)) {
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
                      Text(AppLocalizations.of(contexto).puzzleInstrLeerCifras,
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
                              child: _TarjetaOpcionDecimal(
                                etiqueta: _problema.etiquetaA,
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
                              child: _TarjetaOpcionDecimal(
                                etiqueta: _problema.etiquetaB,
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

class _TarjetaOpcionDecimal extends StatelessWidget {
  final String etiqueta;
  final bool seleccionado;
  final bool marcarCorrecto;
  final bool marcarIncorrecto;
  final VoidCallback alTocar;

  const _TarjetaOpcionDecimal({
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
              fontSize: 48,
              fontWeight: FontWeight.w300,
              letterSpacing: 1.4,
            ),
          ),
        ),
      ),
    );
  }
}
