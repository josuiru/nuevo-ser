import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../dominio/problema_dual.dart';
import '../dominio/problema_espejo.dart';
import '../nucleo/paleta.dart';
import 'escenario.dart';

/// Puzzle de Familia F (Duales). Se muestra una suma a/b + c/d y el
/// niño elige el resultado correcto entre cuatro candidatos.
class PantallaDual extends StatefulWidget {
  final int numeradorA;
  final int denominadorA;
  final int numeradorB;
  final int denominadorB;

  const PantallaDual({
    super.key,
    required this.numeradorA,
    required this.denominadorA,
    required this.numeradorB,
    required this.denominadorB,
  });

  @override
  State<PantallaDual> createState() => _PantallaDualState();
}

class _PantallaDualState extends State<PantallaDual>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controladorCielo;
  late ProblemaDual _problema;
  int? _indiceSeleccionado;
  bool _revelado = false;

  @override
  void initState() {
    super.initState();
    _controladorCielo = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 16),
    )..repeat();
    _problema = GeneradorDual().generarDesde(
      sumandoA: Fraccion(widget.numeradorA, widget.denominadorA),
      sumandoB: Fraccion(widget.numeradorB, widget.denominadorB),
    );
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
                              child: const Text(
                                'huir',
                                style: TextStyle(
                                  color: PaletaNeon.textoTenue,
                                  fontSize: 13,
                                  letterSpacing: 1.5,
                                ),
                              ),
                            ),
                          ),
                          const Spacer(),
                          const Text(
                            'DUAL',
                            style: TextStyle(
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
                      const Text(
                        'funde los dos en uno solo',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: PaletaNeon.textoTenue,
                          fontSize: 14,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 24),
                      _TarjetaSuma(problema: _problema),
                      const SizedBox(height: 36),
                      Expanded(
                        child: GridView.count(
                          crossAxisCount: 2,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 1.2,
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

class _TarjetaSuma extends StatelessWidget {
  final ProblemaDual problema;

  const _TarjetaSuma({required this.problema});

  @override
  Widget build(BuildContext contexto) {
    const colorAcento = Color(0xFFFF9A6B);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: PaletaNeon.violetaBase.withOpacity(0.4),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colorAcento, width: 2),
        boxShadow: [
          BoxShadow(
            color: colorAcento.withOpacity(0.35),
            blurRadius: 22,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            problema.sumandoA.etiqueta,
            style: const TextStyle(
              color: PaletaNeon.textoPrincipal,
              fontSize: 34,
              fontWeight: FontWeight.w300,
            ),
          ),
          const SizedBox(width: 16),
          const Text(
            '+',
            style: TextStyle(
              color: colorAcento,
              fontSize: 34,
              fontWeight: FontWeight.w300,
            ),
          ),
          const SizedBox(width: 16),
          Text(
            problema.sumandoB.etiqueta,
            style: const TextStyle(
              color: PaletaNeon.textoPrincipal,
              fontSize: 34,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }
}

class _TarjetaCandidato extends StatelessWidget {
  final String etiqueta;
  final bool seleccionado;
  final bool marcarCorrecto;
  final bool marcarIncorrecto;
  final VoidCallback alTocar;

  const _TarjetaCandidato({
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
            etiqueta,
            style: TextStyle(
              color: marcarCorrecto
                  ? PaletaNeon.exitoSuave
                  : marcarIncorrecto
                      ? PaletaNeon.rosaAcento
                      : PaletaNeon.textoPrincipal,
              fontSize: 28,
              fontWeight: FontWeight.w300,
              letterSpacing: 1.1,
            ),
          ),
        ),
      ),
    );
  }
}
