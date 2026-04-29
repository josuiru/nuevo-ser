import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../dominio/problema_divisibilidad.dart';
import '../l10n/app_localizations.dart';
import '../nucleo/paleta.dart';
import 'escenario.dart';
import '../dominio/contador_intentos_puzzle.dart';

/// Puzzle DIV.03/DIV.01: el niño ve un número y un divisor; decide si
/// es divisible (DIV.03/04) o si es múltiplo (DIV.01) con un toque "sí"
/// o "no". Primera mecánica binaria del juego. El cálculo es el mismo;
/// el [modo] cambia la pregunta y la cabecera.
class PantallaDivisibilidad extends StatefulWidget {
  /// Si llega un problema preconstruido (porque lo generó el cazador)
  /// se usa tal cual. Si es null, la pantalla genera uno propio.
  final ProblemaDivisibilidad? problemaPredeterminado;

  /// Cómo se le formula la pregunta al niño.
  final ModoFraseoDivisibilidad modo;

  const PantallaDivisibilidad({
    super.key,
    this.problemaPredeterminado,
    this.modo = ModoFraseoDivisibilidad.divisible,
  });

  @override
  State<PantallaDivisibilidad> createState() =>
      _PantallaDivisibilidadState();
}

class _PantallaDivisibilidadState extends State<PantallaDivisibilidad>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controladorCielo;
  late ProblemaDivisibilidad _problema;
  bool? _respuestaDada;
  bool _revelado = false;

  @override
  void initState() {
    super.initState();
    _controladorCielo = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 16),
    )..repeat();
    _problema = widget.problemaPredeterminado ??
        GeneradorDivisibilidad().generar(dificultad: 1);
  }

  @override
  void dispose() {
    _controladorCielo.dispose();
    super.dispose();
  }

  void _responder(bool si) {
    if (_revelado && _problema.esCorrecta(_respuestaDada ?? false)) return;
    setState(() {
      _respuestaDada = si;
      _revelado = true;
    });
    if (_problema.esCorrecta(si)) {
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
                            widget.modo ==
                                    ModoFraseoDivisibilidad.multiplo
                                ? 'MÚLTIPLO'
                                : 'DIVISIBLE',
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
                        '${_problema.numero}',
                        style: const TextStyle(
                          color: PaletaNeon.textoPrincipal,
                          fontSize: 96,
                          fontWeight: FontWeight.w200,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        widget.modo == ModoFraseoDivisibilidad.multiplo
                            ? '¿es múltiplo de ${_problema.divisor}?'
                            : '¿es divisible entre ${_problema.divisor}?',
                        style: const TextStyle(
                          color: PaletaNeon.textoPrincipal,
                          fontSize: 22,
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Expanded(
                            child: _BotonRespuesta(
                              etiqueta: AppLocalizations.of(contexto).respuestaNo,
                              colorPrincipal: PaletaNeon.rosaAcento,
                              seleccionado: _respuestaDada == false,
                              marcarCorrecto: _revelado &&
                                  _respuestaDada == false &&
                                  _problema.esCorrecta(false),
                              marcarIncorrecto: _revelado &&
                                  _respuestaDada == false &&
                                  !_problema.esCorrecta(false),
                              alTocar: () => _responder(false),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _BotonRespuesta(
                              etiqueta: AppLocalizations.of(contexto).respuestaSi,
                              colorPrincipal: PaletaNeon.exitoSuave,
                              seleccionado: _respuestaDada == true,
                              marcarCorrecto: _revelado &&
                                  _respuestaDada == true &&
                                  _problema.esCorrecta(true),
                              marcarIncorrecto: _revelado &&
                                  _respuestaDada == true &&
                                  !_problema.esCorrecta(true),
                              alTocar: () => _responder(true),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
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

class _BotonRespuesta extends StatelessWidget {
  final String etiqueta;
  final Color colorPrincipal;
  final bool seleccionado;
  final bool marcarCorrecto;
  final bool marcarIncorrecto;
  final VoidCallback alTocar;

  const _BotonRespuesta({
    required this.etiqueta,
    required this.colorPrincipal,
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
                ? colorPrincipal
                : colorPrincipal.withOpacity(0.55);
    final brilloIntenso = marcarCorrecto || marcarIncorrecto || seleccionado;
    return GestureDetector(
      onTap: alTocar,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        height: 96,
        decoration: BoxDecoration(
          color: PaletaNeon.fondoMedio.withOpacity(0.55),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: colorBorde, width: 2),
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
              fontSize: 36,
              fontWeight: FontWeight.w300,
              letterSpacing: 2,
            ),
          ),
        ),
      ),
    );
  }
}
