import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../dominio/fragmento_en_tejado.dart' show ModoComparacion;
import '../dominio/problema_comparacion.dart';
import '../dominio/problema_espejo.dart' show Fraccion;
import '../nucleo/paleta.dart';
import 'escenario.dart';

/// Puzzle FR.05 / FR.06: el niño ve dos fracciones y tiene que tocar
/// la mayor. El modo decide qué se comparte (denominador o numerador)
/// y, con ello, la pista amable que acompaña al enunciado.
///
/// Devuelve `true` si acierta a la primera o tras reintentos, `false`
/// si huye.
class PantallaComparacion extends StatefulWidget {
  final Fraccion a;
  final Fraccion b;
  final ModoComparacion modo;

  const PantallaComparacion({
    super.key,
    required this.a,
    required this.b,
    required this.modo,
  });

  @override
  State<PantallaComparacion> createState() => _PantallaComparacionState();
}

class _PantallaComparacionState extends State<PantallaComparacion>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controladorCielo;
  late final ProblemaComparacion _problema;
  int? _indiceSeleccionado;
  bool _revelado = false;

  @override
  void initState() {
    super.initState();
    _controladorCielo = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 16),
    )..repeat();
    _problema = ProblemaComparacion(
      a: widget.a,
      b: widget.b,
      modo: widget.modo,
    );
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
      Future.delayed(const Duration(milliseconds: 900), () {
        if (!mounted) return;
        setState(() => _revelado = false);
      });
    }
  }

  void _huir() {
    Navigator.of(context).pop(false);
  }

  String get _pistaSegunModo {
    switch (widget.modo) {
      case ModoComparacion.mismoDenominador:
        return 'mismo tamaño de trozo';
      case ModoComparacion.mismoNumerador:
        return 'el mismo número de trozos';
    }
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
                        _pistaSegunModo,
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
                                etiqueta: _problema.a.etiqueta,
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
                                etiqueta: _problema.b.etiqueta,
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
  final String etiqueta;
  final bool seleccionado;
  final bool marcarCorrecto;
  final bool marcarIncorrecto;
  final VoidCallback alTocar;

  const _TarjetaOpcion({
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
              fontSize: 52,
              fontWeight: FontWeight.w300,
              letterSpacing: 1.4,
            ),
          ),
        ),
      ),
    );
  }
}
