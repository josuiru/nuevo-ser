import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../dominio/problema_espejo.dart' show Fraccion;
import '../dominio/problema_representacion_fraccion.dart';
import '../nucleo/paleta.dart';
import 'escenario.dart';

/// Puzzle FR.03: el niño ve un rectángulo dividido en partes con
/// algunas coloreadas y elige la fracción correcta entre cuatro
/// candidatos. Mecánica visual: la lectura ocurre mirando el dibujo.
class PantallaRepresentacionFraccion extends StatefulWidget {
  final ProblemaRepresentacionFraccion? problemaPredeterminado;

  const PantallaRepresentacionFraccion({
    super.key,
    this.problemaPredeterminado,
  });

  @override
  State<PantallaRepresentacionFraccion> createState() =>
      _PantallaRepresentacionFraccionState();
}

class _PantallaRepresentacionFraccionState
    extends State<PantallaRepresentacionFraccion>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controladorCielo;
  late ProblemaRepresentacionFraccion _problema;
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
        GeneradorRepresentacionFraccion().generar(dificultad: 1);
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
                            'REPRESENTAR',
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
                        '¿qué fracción está coloreada?',
                        style: TextStyle(
                          color: PaletaNeon.textoPrincipal,
                          fontSize: 18,
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      const SizedBox(height: 22),
                      SizedBox(
                        height: 110,
                        child: CustomPaint(
                          painter: _PintorReglaFraccion(
                            partesTotales: _problema.denominador,
                            partesColoreadas: _problema.numerador,
                          ),
                          size: Size.infinite,
                        ),
                      ),
                      const SizedBox(height: 30),
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

/// Pinta un rectángulo dividido en `partesTotales` columnas, con las
/// primeras `partesColoreadas` rellenas con el color principal y el
/// resto vacías. Las divisiones se ven como líneas finas.
class _PintorReglaFraccion extends CustomPainter {
  final int partesTotales;
  final int partesColoreadas;

  _PintorReglaFraccion({
    required this.partesTotales,
    required this.partesColoreadas,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final ancho = size.width;
    final alto = size.height;
    final anchoParte = ancho / partesTotales;

    final pinturaColoreada = Paint()
      ..color = PaletaNeon.azulNeon.withOpacity(0.7);
    final pinturaVacia = Paint()
      ..color = PaletaNeon.violetaBase.withOpacity(0.25);
    final pinturaBorde = Paint()
      ..color = PaletaNeon.textoPrincipal.withOpacity(0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final pinturaDivision = Paint()
      ..color = PaletaNeon.textoPrincipal.withOpacity(0.5)
      ..strokeWidth = 1.4;

    const radio = Radius.circular(10);

    // Fondo: rectángulo entero vacío.
    final rectGlobal = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, ancho, alto),
      radio,
    );
    canvas.drawRRect(rectGlobal, pinturaVacia);

    // Partes coloreadas (rellenas con un rectángulo a la izquierda).
    if (partesColoreadas > 0) {
      final anchoRelleno = anchoParte * partesColoreadas;
      final rectRelleno = RRect.fromRectAndCorners(
        Rect.fromLTWH(0, 0, anchoRelleno, alto),
        topLeft: radio,
        bottomLeft: radio,
        topRight: partesColoreadas == partesTotales ? radio : Radius.zero,
        bottomRight:
            partesColoreadas == partesTotales ? radio : Radius.zero,
      );
      canvas.drawRRect(rectRelleno, pinturaColoreada);
    }

    // Líneas de división interiores.
    for (var i = 1; i < partesTotales; i++) {
      final x = anchoParte * i;
      canvas.drawLine(Offset(x, 0), Offset(x, alto), pinturaDivision);
    }

    // Borde exterior.
    canvas.drawRRect(rectGlobal, pinturaBorde);
  }

  @override
  bool shouldRepaint(covariant _PintorReglaFraccion oldDelegate) =>
      oldDelegate.partesTotales != partesTotales ||
      oldDelegate.partesColoreadas != partesColoreadas;
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
