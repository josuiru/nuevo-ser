import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../dominio/fragmento_en_tejado.dart' show SimboloOperador;
import '../dominio/problema_jerarquia_fracciones.dart';
import '../dominio/problema_espejo.dart' show Fraccion;
import '../nucleo/paleta.dart';
import 'escenario.dart';

/// Puzzle OP.02: el niño ve "1/2 + 1/4 × 2/3" y elige el resultado
/// correcto entre cuatro candidatos. La trampa estrella: calcular
/// izquierda-a-derecha sin respetar la prioridad de × y ÷.
class PantallaJerarquiaFracciones extends StatefulWidget {
  final ProblemaJerarquiaFracciones? problemaPredeterminado;

  const PantallaJerarquiaFracciones({
    super.key,
    this.problemaPredeterminado,
  });

  @override
  State<PantallaJerarquiaFracciones> createState() =>
      _PantallaJerarquiaFraccionesState();
}

class _PantallaJerarquiaFraccionesState
    extends State<PantallaJerarquiaFracciones>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controladorCielo;
  late ProblemaJerarquiaFracciones _problema;
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
        GeneradorJerarquiaFracciones().generar(dificultad: 1);
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
                            'JERARQUÍA',
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
                      const SizedBox(height: 22),
                      const Text(
                        'recuerda × y ÷ antes que + y −',
                        style: TextStyle(
                          color: PaletaNeon.textoPrincipal,
                          fontSize: 18,
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      const SizedBox(height: 22),
                      _TarjetaExpresion(problema: _problema),
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

class _TarjetaExpresion extends StatelessWidget {
  final ProblemaJerarquiaFracciones problema;
  const _TarjetaExpresion({required this.problema});

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
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _Operando(fraccion: problema.a),
          const SizedBox(width: 12),
          _Operador(simbolo: problema.op1.simbolo),
          const SizedBox(width: 12),
          _Operando(fraccion: problema.b),
          const SizedBox(width: 12),
          _Operador(simbolo: problema.op2.simbolo),
          const SizedBox(width: 12),
          _Operando(fraccion: problema.c),
        ],
      ),
    );
  }
}

class _Operando extends StatelessWidget {
  final Fraccion fraccion;
  const _Operando({required this.fraccion});

  @override
  Widget build(BuildContext contexto) {
    if (fraccion.denominador == 1) {
      return Text(
        '${fraccion.numerador}',
        style: const TextStyle(
          color: PaletaNeon.textoPrincipal,
          fontSize: 30,
          fontWeight: FontWeight.w300,
        ),
      );
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '${fraccion.numerador}',
          style: const TextStyle(
            color: PaletaNeon.textoPrincipal,
            fontSize: 22,
            fontWeight: FontWeight.w300,
          ),
        ),
        Container(
          width: 26,
          height: 1.2,
          color: PaletaNeon.textoPrincipal.withOpacity(0.7),
        ),
        Text(
          '${fraccion.denominador}',
          style: const TextStyle(
            color: PaletaNeon.textoPrincipal,
            fontSize: 22,
            fontWeight: FontWeight.w300,
          ),
        ),
      ],
    );
  }
}

class _Operador extends StatelessWidget {
  final String simbolo;
  const _Operador({required this.simbolo});

  @override
  Widget build(BuildContext contexto) {
    return Text(
      simbolo,
      style: const TextStyle(
        color: PaletaNeon.azulNeon,
        fontSize: 28,
        fontWeight: FontWeight.w300,
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
          child: fraccion.denominador == 1
              ? Text(
                  '${fraccion.numerador}',
                  style: TextStyle(
                    color: colorTexto,
                    fontSize: 34,
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
                      width: 30,
                      height: 1.4,
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
