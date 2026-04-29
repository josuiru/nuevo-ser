import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../dominio/problema_amplificar.dart';
import '../l10n/app_localizations.dart';
import '../nucleo/paleta.dart';
import 'escenario.dart';
import '../dominio/contador_intentos_puzzle.dart';

/// Puzzle FR.11: se muestra la ecuación "3/4 = ?/12" y el niño
/// elige el numerador que la completa. Mecánica de "rellenar el
/// hueco" — primera vez que aparece en Uno Roto.
class PantallaAmplificar extends StatefulWidget {
  final int numeradorBase;
  final int denominadorBase;
  final int denominadorObjetivo;

  const PantallaAmplificar({
    super.key,
    required this.numeradorBase,
    required this.denominadorBase,
    required this.denominadorObjetivo,
  });

  @override
  State<PantallaAmplificar> createState() => _PantallaAmplificarState();
}

class _PantallaAmplificarState extends State<PantallaAmplificar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controladorCielo;
  late ProblemaAmplificar _problema;
  int? _indiceSeleccionado;
  bool _revelado = false;

  @override
  void initState() {
    super.initState();
    _controladorCielo = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 16),
    )..repeat();
    // Dificultad calibrada; el Fragmento solo trae la intención —
    // denominadores concretos los decide el generador.
    _problema = GeneradorAmplificar().generar(dificultad: 2);
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
    if (indice == _problema.indiceCorrecto) {
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
                          Text(AppLocalizations.of(contexto).puzzleHeaderAmplificar,
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
                        AppLocalizations.of(contexto).puzzleInstrAmplificar,
                        style: const TextStyle(
                          color: PaletaNeon.textoPrincipal,
                          fontSize: 20,
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      const SizedBox(height: 32),
                      _Ecuacion(
                        numeradorBase: _problema.base.numerador,
                        denominadorBase: _problema.base.denominador,
                        denominadorObjetivo: _problema.denominadorObjetivo,
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
                                valor: _problema.candidatos[indice],
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

class _Ecuacion extends StatelessWidget {
  final int numeradorBase;
  final int denominadorBase;
  final int denominadorObjetivo;

  const _Ecuacion({
    required this.numeradorBase,
    required this.denominadorBase,
    required this.denominadorObjetivo,
  });

  @override
  Widget build(BuildContext contexto) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _Fraccion(
          numerador: '$numeradorBase',
          denominador: '$denominadorBase',
          colorNumerador: PaletaNeon.textoPrincipal,
        ),
        const SizedBox(width: 16),
        const Text(
          '=',
          style: TextStyle(
            color: PaletaNeon.textoTenue,
            fontSize: 42,
            fontWeight: FontWeight.w300,
          ),
        ),
        const SizedBox(width: 16),
        _Fraccion(
          numerador: '?',
          denominador: '$denominadorObjetivo',
          colorNumerador: PaletaNeon.azulNeon,
        ),
      ],
    );
  }
}

class _Fraccion extends StatelessWidget {
  final String numerador;
  final String denominador;
  final Color colorNumerador;

  const _Fraccion({
    required this.numerador,
    required this.denominador,
    required this.colorNumerador,
  });

  @override
  Widget build(BuildContext contexto) {
    final estiloNum = TextStyle(
      color: colorNumerador,
      fontSize: 56,
      fontWeight: FontWeight.w300,
      letterSpacing: 1.2,
    );
    const estiloDen = TextStyle(
      color: PaletaNeon.textoPrincipal,
      fontSize: 56,
      fontWeight: FontWeight.w300,
      letterSpacing: 1.2,
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(numerador, style: estiloNum),
        Container(
          width: 62,
          height: 2,
          margin: const EdgeInsets.symmetric(vertical: 2),
          color: PaletaNeon.textoTenue.withOpacity(0.7),
        ),
        Text(denominador, style: estiloDen),
      ],
    );
  }
}

class _TarjetaCandidato extends StatelessWidget {
  final int valor;
  final bool seleccionado;
  final bool marcarCorrecto;
  final bool marcarIncorrecto;
  final VoidCallback alTocar;

  const _TarjetaCandidato({
    required this.valor,
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
          child: Text(
            '$valor',
            style: TextStyle(
              color: marcarCorrecto
                  ? PaletaNeon.exitoSuave
                  : marcarIncorrecto
                      ? PaletaNeon.rosaAcento
                      : PaletaNeon.textoPrincipal,
              fontSize: 38,
              fontWeight: FontWeight.w300,
              letterSpacing: 1.2,
            ),
          ),
        ),
      ),
    );
  }
}
