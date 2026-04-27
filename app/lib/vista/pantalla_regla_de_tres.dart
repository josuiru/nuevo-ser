import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../dominio/problema_regla_de_tres.dart';
import '../nucleo/paleta.dart';
import 'escenario.dart';

/// Puzzle PROP.03: el niño ve una proporción "a → b, c → ?" y elige
/// el resultado entre cuatro candidatos. Mecánica de regla de tres
/// directa con trampas pedagógicas: invertir la relación, sumar todo,
/// confundir con el segundo término.
class PantallaReglaDeTres extends StatefulWidget {
  final ProblemaReglaDeTres? problemaPredeterminado;

  const PantallaReglaDeTres({
    super.key,
    this.problemaPredeterminado,
  });

  @override
  State<PantallaReglaDeTres> createState() => _PantallaReglaDeTresState();
}

class _PantallaReglaDeTresState extends State<PantallaReglaDeTres>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controladorCielo;
  late ProblemaReglaDeTres _problema;
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
        GeneradorReglaDeTres().generar(dificultad: 1);
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
                            'PROPORCIÓN',
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
                        'si esto, entonces…',
                        style: TextStyle(
                          color: PaletaNeon.textoPrincipal,
                          fontSize: 18,
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      const SizedBox(height: 22),
                      _TarjetaProporcion(
                        a: _problema.a,
                        b: _problema.b,
                        c: _problema.c,
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
                                etiqueta: '${_problema.candidatos[indice]}',
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

/// Muestra la proporción "a → b · c → ?" en dos filas claras, con
/// flechas y un signo de interrogación grande para el término que el
/// niño tiene que rellenar.
class _TarjetaProporcion extends StatelessWidget {
  final int a;
  final int b;
  final int c;

  const _TarjetaProporcion({
    required this.a,
    required this.b,
    required this.c,
  });

  @override
  Widget build(BuildContext contexto) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 22),
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _FilaProporcion(izquierda: '$a', derecha: '$b'),
          const SizedBox(height: 12),
          _FilaProporcion(izquierda: '$c', derecha: '?', destacarDerecha: true),
        ],
      ),
    );
  }
}

class _FilaProporcion extends StatelessWidget {
  final String izquierda;
  final String derecha;
  final bool destacarDerecha;

  const _FilaProporcion({
    required this.izquierda,
    required this.derecha,
    this.destacarDerecha = false,
  });

  @override
  Widget build(BuildContext contexto) {
    final colorDerecha = destacarDerecha
        ? PaletaNeon.azulNeon
        : PaletaNeon.textoPrincipal;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 60,
          child: Text(
            izquierda,
            textAlign: TextAlign.right,
            style: const TextStyle(
              color: PaletaNeon.textoPrincipal,
              fontSize: 32,
              fontWeight: FontWeight.w300,
              letterSpacing: 1.2,
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            '→',
            style: TextStyle(
              color: PaletaNeon.textoTenue,
              fontSize: 28,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
        SizedBox(
          width: 60,
          child: Text(
            derecha,
            textAlign: TextAlign.left,
            style: TextStyle(
              color: colorDerecha,
              fontSize: 32,
              fontWeight: FontWeight.w300,
              letterSpacing: 1.2,
            ),
          ),
        ),
      ],
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
            textAlign: TextAlign.center,
            style: TextStyle(
              color: marcarCorrecto
                  ? PaletaNeon.exitoSuave
                  : marcarIncorrecto
                      ? PaletaNeon.rosaAcento
                      : PaletaNeon.textoPrincipal,
              fontSize: 36,
              fontWeight: FontWeight.w300,
              letterSpacing: 1.2,
            ),
          ),
        ),
      ),
    );
  }
}
