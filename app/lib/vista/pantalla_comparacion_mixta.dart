import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../dominio/problema_comparacion_mixta.dart';
import '../nucleo/paleta.dart';
import 'escenario.dart';

/// Puzzle DEC.03: el niño ve una fracción y un decimal lado a lado y
/// toca el de mayor valor. Mecánica de comparación cruzada — el niño
/// no puede atajar mirando solo cifras o solo términos.
class PantallaComparacionMixta extends StatefulWidget {
  final ProblemaComparacionMixta? problemaPredeterminado;

  const PantallaComparacionMixta({
    super.key,
    this.problemaPredeterminado,
  });

  @override
  State<PantallaComparacionMixta> createState() =>
      _PantallaComparacionMixtaState();
}

class _PantallaComparacionMixtaState extends State<PantallaComparacionMixta>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controladorCielo;
  late ProblemaComparacionMixta _problema;
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
        GeneradorComparacionMixta().generar(dificultad: 1);
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
                            'COMPARAR',
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
                      const SizedBox(height: 36),
                      const Text(
                        '¿cuál es mayor?',
                        style: TextStyle(
                          color: PaletaNeon.textoPrincipal,
                          fontSize: 20,
                          letterSpacing: 1.4,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'piensa el valor, no la forma',
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
                                opcion: _problema.a,
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
                                opcion: _problema.b,
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
  final OpcionComparacionMixta opcion;
  final bool seleccionado;
  final bool marcarCorrecto;
  final bool marcarIncorrecto;
  final VoidCallback alTocar;

  const _TarjetaOpcion({
    required this.opcion,
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
          child: opcion.esFraccion
              ? _ContenidoFraccion(etiqueta: opcion.etiqueta, color: colorTexto)
              : Text(
                  opcion.etiqueta,
                  style: TextStyle(
                    color: colorTexto,
                    fontSize: 56,
                    fontWeight: FontWeight.w300,
                    letterSpacing: 1.4,
                  ),
                ),
        ),
      ),
    );
  }
}

class _ContenidoFraccion extends StatelessWidget {
  /// La etiqueta llega como "3/4"; partimos por la barra para apilar.
  final String etiqueta;
  final Color color;

  const _ContenidoFraccion({required this.etiqueta, required this.color});

  @override
  Widget build(BuildContext contexto) {
    final partes = etiqueta.split('/');
    final numerador = partes[0];
    final denominador = partes.length > 1 ? partes[1] : '1';
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          numerador,
          style: TextStyle(
            color: color,
            fontSize: 48,
            fontWeight: FontWeight.w300,
          ),
        ),
        Container(
          width: 56,
          height: 2,
          color: color,
          margin: const EdgeInsets.symmetric(vertical: 6),
        ),
        Text(
          denominador,
          style: TextStyle(
            color: color,
            fontSize: 48,
            fontWeight: FontWeight.w300,
          ),
        ),
      ],
    );
  }
}
