import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../dominio/problema_perimetro.dart';
import '../nucleo/paleta.dart';
import 'escenario.dart';

/// Puzzle GEO.02: el niño ve un polígono con sus lados etiquetados y
/// elige el perímetro entre cuatro candidatos.
class PantallaPerimetro extends StatefulWidget {
  final ProblemaPerimetro? problemaPredeterminado;

  const PantallaPerimetro({super.key, this.problemaPredeterminado});

  @override
  State<PantallaPerimetro> createState() => _PantallaPerimetroState();
}

class _PantallaPerimetroState extends State<PantallaPerimetro>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controladorCielo;
  late ProblemaPerimetro _problema;
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
        GeneradorPerimetro().generar(dificultad: 1);
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
                            'PERÍMETRO',
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
                        'suma todos los lados',
                        style: TextStyle(
                          color: PaletaNeon.textoPrincipal,
                          fontSize: 18,
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      const SizedBox(height: 22),
                      _TarjetaPoligonoConLados(lados: _problema.lados),
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

class _TarjetaPoligonoConLados extends StatelessWidget {
  final List<int> lados;
  const _TarjetaPoligonoConLados({required this.lados});

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
        width: 220,
        height: 200,
        child: CustomPaint(
          painter: _PintorPoligonoConLados(lados: lados),
        ),
      ),
    );
  }
}

class _PintorPoligonoConLados extends CustomPainter {
  final List<int> lados;
  _PintorPoligonoConLados({required this.lados});

  @override
  void paint(Canvas canvas, Size size) {
    final centro = Offset(size.width / 2, size.height / 2);
    final n = lados.length;

    // Para rectángulos (4 lados con par 0,2 igual y par 1,3 igual)
    // dibujamos el rectángulo real. En el resto, polígono regular.
    final esRectangulo = n == 4 &&
        lados[0] == lados[2] &&
        lados[1] == lados[3] &&
        lados[0] != lados[1];

    final puntos = <Offset>[];
    if (esRectangulo) {
      final ancho = size.width - 50;
      final alto = ancho * lados[1] / lados[0];
      final media = math.min(alto, size.height - 50);
      final escala = media / alto;
      final anchoFinal = ancho * escala;
      final altoFinal = alto * escala;
      puntos.addAll([
        centro + Offset(-anchoFinal / 2, -altoFinal / 2),
        centro + Offset(anchoFinal / 2, -altoFinal / 2),
        centro + Offset(anchoFinal / 2, altoFinal / 2),
        centro + Offset(-anchoFinal / 2, altoFinal / 2),
      ]);
    } else {
      final radio = math.min(size.width, size.height) / 2 - 30;
      for (var i = 0; i < n; i++) {
        final angulo = -math.pi / 2 + 2 * math.pi * i / n;
        puntos.add(centro +
            Offset(math.cos(angulo) * radio, math.sin(angulo) * radio));
      }
    }

    final ruta = Path();
    ruta.moveTo(puntos[0].dx, puntos[0].dy);
    for (var i = 1; i < puntos.length; i++) {
      ruta.lineTo(puntos[i].dx, puntos[i].dy);
    }
    ruta.close();

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

    // Etiquetar cada lado en su punto medio.
    final pinturaTextoFondo = Paint()
      ..color = PaletaNeon.fondoMedio.withOpacity(0.85)
      ..style = PaintingStyle.fill;
    for (var i = 0; i < puntos.length; i++) {
      final actual = puntos[i];
      final siguiente = puntos[(i + 1) % puntos.length];
      final medio = Offset(
        (actual.dx + siguiente.dx) / 2,
        (actual.dy + siguiente.dy) / 2,
      );
      final hacia = Offset(
        siguiente.dx - actual.dx,
        siguiente.dy - actual.dy,
      );
      final longitud = hacia.distance;
      final perpendicular = longitud == 0
          ? Offset.zero
          : Offset(-hacia.dy / longitud, hacia.dx / longitud);
      final etiquetaPos = medio + perpendicular * 16;

      final pintor = TextPainter(
        text: TextSpan(
          text: '${lados[i]}',
          style: const TextStyle(
            color: PaletaNeon.textoPrincipal,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      pintor.layout();
      final rect = Rect.fromCenter(
        center: etiquetaPos,
        width: pintor.width + 8,
        height: pintor.height + 4,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(4)),
        pinturaTextoFondo,
      );
      pintor.paint(
        canvas,
        Offset(
          etiquetaPos.dx - pintor.width / 2,
          etiquetaPos.dy - pintor.height / 2,
        ),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _PintorPoligonoConLados oldDelegate) =>
      !_listaIgual(oldDelegate.lados, lados);

  bool _listaIgual(List<int> a, List<int> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
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
