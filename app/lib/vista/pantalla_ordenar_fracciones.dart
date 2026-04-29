import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../dominio/problema_ordenar_fracciones.dart';
import '../l10n/app_localizations.dart';
import '../nucleo/paleta.dart';
import 'escenario.dart';
import '../dominio/contador_intentos_puzzle.dart';

/// Puzzle FR.08: el niño ve tres fracciones y elige el ordenamiento
/// correcto de menor a mayor entre cuatro candidatos. Distractores:
/// orden por numerador, por denominador, invertido.
class PantallaOrdenarFracciones extends StatefulWidget {
  final ProblemaOrdenarFracciones? problemaPredeterminado;

  const PantallaOrdenarFracciones({
    super.key,
    this.problemaPredeterminado,
  });

  @override
  State<PantallaOrdenarFracciones> createState() =>
      _PantallaOrdenarFraccionesState();
}

class _PantallaOrdenarFraccionesState extends State<PantallaOrdenarFracciones>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controladorCielo;
  late ProblemaOrdenarFracciones _problema;
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
        GeneradorOrdenarFracciones().generar(dificultad: 1);
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
                          Text(AppLocalizations.of(contexto).puzzleHeaderOrdenar,
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
                        AppLocalizations.of(contexto).puzzleInstrOrdenar,
                        style: const TextStyle(
                          color: PaletaNeon.textoPrincipal,
                          fontSize: 18,
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      const SizedBox(height: 18),
                      _FilaFraccionesPresentadas(
                        fracciones: _problema.presentadas,
                      ),
                      const SizedBox(height: 28),
                      Expanded(
                        child: ListView.separated(
                          itemCount: _problema.candidatos.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 12),
                          itemBuilder: (_, indice) => _TarjetaCandidato(
                            ordenamiento: _problema.candidatos[indice],
                            seleccionado: _indiceSeleccionado == indice,
                            marcarCorrecto: _revelado &&
                                _indiceSeleccionado == indice &&
                                indice == _problema.indiceCorrecto,
                            marcarIncorrecto: _revelado &&
                                _indiceSeleccionado == indice &&
                                indice != _problema.indiceCorrecto,
                            alTocar: () => _elegir(indice),
                          ),
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

class _FilaFraccionesPresentadas extends StatelessWidget {
  final List<dynamic> fracciones;

  const _FilaFraccionesPresentadas({required this.fracciones});

  @override
  Widget build(BuildContext contexto) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: PaletaNeon.violetaBase.withOpacity(0.4),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: PaletaNeon.azulNeon, width: 2),
        boxShadow: [
          BoxShadow(
            color: PaletaNeon.azulNeon.withOpacity(0.4),
            blurRadius: 20,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          for (final f in fracciones)
            _FraccionGrande(numerador: f.numerador, denominador: f.denominador),
        ],
      ),
    );
  }
}

class _FraccionGrande extends StatelessWidget {
  final int numerador;
  final int denominador;

  const _FraccionGrande({
    required this.numerador,
    required this.denominador,
  });

  @override
  Widget build(BuildContext contexto) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$numerador',
          style: const TextStyle(
            color: PaletaNeon.textoPrincipal,
            fontSize: 28,
            fontWeight: FontWeight.w300,
          ),
        ),
        Container(
          width: 30,
          height: 1.5,
          color: PaletaNeon.textoPrincipal,
          margin: const EdgeInsets.symmetric(vertical: 3),
        ),
        Text(
          '$denominador',
          style: const TextStyle(
            color: PaletaNeon.textoPrincipal,
            fontSize: 28,
            fontWeight: FontWeight.w300,
          ),
        ),
      ],
    );
  }
}

class _TarjetaCandidato extends StatelessWidget {
  final List<dynamic> ordenamiento;
  final bool seleccionado;
  final bool marcarCorrecto;
  final bool marcarIncorrecto;
  final VoidCallback alTocar;

  const _TarjetaCandidato({
    required this.ordenamiento,
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
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        decoration: BoxDecoration(
          color: PaletaNeon.fondoMedio.withOpacity(0.55),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colorBorde, width: 1.6),
          boxShadow: brilloIntenso
              ? [
                  BoxShadow(
                    color: colorBorde.withOpacity(0.4),
                    blurRadius: 16,
                  ),
                ]
              : const [],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var i = 0; i < ordenamiento.length; i++) ...[
              _FraccionPequena(
                numerador: ordenamiento[i].numerador,
                denominador: ordenamiento[i].denominador,
                color: colorTexto,
              ),
              if (i < ordenamiento.length - 1)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    '<',
                    style: TextStyle(
                      color: colorTexto.withOpacity(0.55),
                      fontSize: 22,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}

class _FraccionPequena extends StatelessWidget {
  final int numerador;
  final int denominador;
  final Color color;

  const _FraccionPequena({
    required this.numerador,
    required this.denominador,
    required this.color,
  });

  @override
  Widget build(BuildContext contexto) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$numerador',
          style: TextStyle(
            color: color,
            fontSize: 20,
            fontWeight: FontWeight.w300,
          ),
        ),
        Container(
          width: 22,
          height: 1.2,
          color: color,
          margin: const EdgeInsets.symmetric(vertical: 2),
        ),
        Text(
          '$denominador',
          style: TextStyle(
            color: color,
            fontSize: 20,
            fontWeight: FontWeight.w300,
          ),
        ),
      ],
    );
  }
}
