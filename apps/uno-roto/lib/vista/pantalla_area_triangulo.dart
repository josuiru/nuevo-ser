import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../dominio/problema_area_triangulo.dart';
import '../l10n/app_localizations.dart';
import '../nucleo/paleta.dart';
import 'escenario.dart';
import '../dominio/contador_intentos_puzzle.dart';

/// Puzzle GEO.04: el niño ve un triángulo con base y altura
/// etiquetadas, y elige el área entre cuatro candidatos. La habilidad:
/// (b × h) / 2. Distractor estrella: olvidar el /2.
class PantallaAreaTriangulo extends StatefulWidget {
  final ProblemaAreaTriangulo? problemaPredeterminado;

  const PantallaAreaTriangulo({super.key, this.problemaPredeterminado});

  @override
  State<PantallaAreaTriangulo> createState() => _PantallaAreaTrianguloState();
}

class _PantallaAreaTrianguloState extends State<PantallaAreaTriangulo>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controladorCielo;
  late ProblemaAreaTriangulo _problema;
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
        GeneradorAreaTriangulo().generar(dificultad: 1);
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
                          Text(AppLocalizations.of(contexto).puzzleHeaderTriangulo,
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
                        AppLocalizations.of(contexto).puzzleInstrAreaTriangulo,
                        style: const TextStyle(
                          color: PaletaNeon.textoPrincipal,
                          fontSize: 18,
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      const SizedBox(height: 22),
                      _TarjetaTriangulo(
                        base: _problema.base,
                        altura: _problema.altura,
                      ),
                      const SizedBox(height: 32),
                      Expanded(
                        child: GridView.count(
                          crossAxisCount: 2,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 1.6,
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

class _TarjetaTriangulo extends StatelessWidget {
  final int base;
  final int altura;
  const _TarjetaTriangulo({required this.base, required this.altura});

  @override
  Widget build(BuildContext contexto) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
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
      child: SizedBox(
        width: 250,
        height: 200,
        child: CustomPaint(
          painter: _PintorTriangulo(base: base, altura: altura),
        ),
      ),
    );
  }
}

class _PintorTriangulo extends CustomPainter {
  final int base;
  final int altura;
  _PintorTriangulo({required this.base, required this.altura});

  @override
  void paint(Canvas canvas, Size size) {
    final maxBase = size.width - 70;
    final maxAltura = size.height - 60;
    final escalaBase = maxBase / base;
    final escalaAltura = maxAltura / altura;
    final escala = math.min(escalaBase, escalaAltura);
    final ancho = base * escala;
    final alto = altura * escala;

    final centroX = size.width / 2;
    final yBase = size.height - 30;
    final esquinaIzquierda = Offset(centroX - ancho / 2, yBase);
    final esquinaDerecha = Offset(centroX + ancho / 2, yBase);
    final cuspide = Offset(centroX - ancho / 6, yBase - alto);

    final ruta = Path()
      ..moveTo(esquinaIzquierda.dx, esquinaIzquierda.dy)
      ..lineTo(esquinaDerecha.dx, esquinaDerecha.dy)
      ..lineTo(cuspide.dx, cuspide.dy)
      ..close();

    final pinturaRelleno = Paint()
      ..color = PaletaNeon.azulNeon.withOpacity(0.18)
      ..style = PaintingStyle.fill;
    canvas.drawPath(ruta, pinturaRelleno);

    final pinturaTrazo = Paint()
      ..color = PaletaNeon.azulNeon
      ..strokeWidth = 2.4
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(ruta, pinturaTrazo);

    // Línea de altura discontinua desde la cúspide perpendicular a la base.
    final pieAltura = Offset(cuspide.dx, yBase);
    _dibujarLineaDiscontinua(canvas, cuspide, pieAltura);

    // Marca de ángulo recto en el pie de la altura.
    final pinturaAngulo = Paint()
      ..color = PaletaNeon.azulNeon.withOpacity(0.5)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;
    const ladoMarca = 8.0;
    canvas.drawRect(
      Rect.fromLTWH(pieAltura.dx, pieAltura.dy - ladoMarca, ladoMarca, ladoMarca),
      pinturaAngulo,
    );

    // Etiqueta de base (debajo).
    _dibujarEtiqueta(
      canvas,
      '$base',
      Offset(centroX, yBase + 16),
    );
    // Etiqueta de altura (a la izquierda de la línea).
    _dibujarEtiqueta(
      canvas,
      '$altura',
      Offset(cuspide.dx - 18, yBase - alto / 2),
    );
  }

  void _dibujarLineaDiscontinua(Canvas canvas, Offset desde, Offset hasta) {
    final pintura = Paint()
      ..color = PaletaNeon.azulNeon.withOpacity(0.5)
      ..strokeWidth = 1.4
      ..style = PaintingStyle.stroke;
    final dx = hasta.dx - desde.dx;
    final dy = hasta.dy - desde.dy;
    final largoTotal = math.sqrt(dx * dx + dy * dy);
    final pasos = (largoTotal / 6).floor();
    for (var i = 0; i < pasos; i += 2) {
      final t1 = i / pasos;
      final t2 = (i + 1) / pasos;
      canvas.drawLine(
        Offset(desde.dx + dx * t1, desde.dy + dy * t1),
        Offset(desde.dx + dx * t2, desde.dy + dy * t2),
        pintura,
      );
    }
  }

  void _dibujarEtiqueta(Canvas canvas, String texto, Offset centro) {
    final pinturaFondo = Paint()
      ..color = PaletaNeon.fondoMedio.withOpacity(0.85)
      ..style = PaintingStyle.fill;
    final pintor = TextPainter(
      text: TextSpan(
        text: texto,
        style: const TextStyle(
          color: PaletaNeon.textoPrincipal,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    pintor.layout();
    final rect = Rect.fromCenter(
      center: centro,
      width: pintor.width + 10,
      height: pintor.height + 4,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(4)),
      pinturaFondo,
    );
    pintor.paint(
      canvas,
      Offset(
        centro.dx - pintor.width / 2,
        centro.dy - pintor.height / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant _PintorTriangulo oldDelegate) =>
      oldDelegate.base != base || oldDelegate.altura != altura;
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
              fontSize: 30,
              fontWeight: FontWeight.w300,
              letterSpacing: 1.2,
            ),
          ),
        ),
      ),
    );
  }
}
