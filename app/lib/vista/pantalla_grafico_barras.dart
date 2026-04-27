import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../dominio/problema_grafico_barras.dart';
import '../nucleo/paleta.dart';
import 'escenario.dart';

/// Puzzle EST.01: el niño ve un gráfico de barras simple y elige el
/// valor de una barra concreta o el total entre cuatro candidatos.
class PantallaGraficoBarras extends StatefulWidget {
  final ProblemaGraficoBarras? problemaPredeterminado;

  const PantallaGraficoBarras({super.key, this.problemaPredeterminado});

  @override
  State<PantallaGraficoBarras> createState() => _PantallaGraficoBarrasState();
}

class _PantallaGraficoBarrasState extends State<PantallaGraficoBarras>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controladorCielo;
  late ProblemaGraficoBarras _problema;
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
        GeneradorGraficoBarras().generar(dificultad: 1);
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
                            'GRÁFICO',
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
                      Text(
                        _problema.preguntaTexto(),
                        style: const TextStyle(
                          color: PaletaNeon.textoPrincipal,
                          fontSize: 17,
                          letterSpacing: 1.0,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      const SizedBox(height: 18),
                      _TarjetaGrafico(
                        etiquetas: _problema.etiquetas,
                        valores: _problema.valores,
                        indiceResaltada:
                            _problema.modo == ModoGraficoBarras.valorDeBarra
                                ? _problema.indiceBarraPreguntada
                                : null,
                      ),
                      const SizedBox(height: 26),
                      Expanded(
                        child: GridView.count(
                          crossAxisCount: 2,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 1.7,
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

class _TarjetaGrafico extends StatelessWidget {
  final List<String> etiquetas;
  final List<int> valores;
  final int? indiceResaltada;
  const _TarjetaGrafico({
    required this.etiquetas,
    required this.valores,
    required this.indiceResaltada,
  });

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
        width: 280,
        height: 220,
        child: CustomPaint(
          painter: _PintorBarras(
            etiquetas: etiquetas,
            valores: valores,
            indiceResaltada: indiceResaltada,
          ),
        ),
      ),
    );
  }
}

class _PintorBarras extends CustomPainter {
  final List<String> etiquetas;
  final List<int> valores;
  final int? indiceResaltada;

  _PintorBarras({
    required this.etiquetas,
    required this.valores,
    required this.indiceResaltada,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final maximo = valores.reduce((a, b) => a > b ? a : b);
    const padIzq = 28.0;
    const padDer = 8.0;
    const padArriba = 12.0;
    const padAbajo = 30.0;
    final ancho = size.width - padIzq - padDer;
    final alto = size.height - padArriba - padAbajo;

    // Líneas guía horizontales — marcas de 1 en 1 hasta el máximo,
    // saltando si hay muchos valores.
    final paso = maximo > 8 ? 2 : 1;
    final pinturaGuia = Paint()
      ..color = PaletaNeon.azulNeon.withOpacity(0.18)
      ..strokeWidth = 0.8;
    for (var v = 0; v <= maximo; v += paso) {
      final y = padArriba + alto * (1 - v / maximo);
      canvas.drawLine(
        Offset(padIzq, y),
        Offset(size.width - padDer, y),
        pinturaGuia,
      );
      // Etiqueta numérica.
      final pintor = TextPainter(
        text: TextSpan(
          text: '$v',
          style: const TextStyle(
            color: PaletaNeon.textoTenue,
            fontSize: 11,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      pintor.paint(canvas, Offset(2, y - pintor.height / 2));
    }

    // Eje y vertical.
    final pinturaEje = Paint()
      ..color = PaletaNeon.azulNeon
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      const Offset(padIzq, padArriba),
      Offset(padIzq, padArriba + alto),
      pinturaEje,
    );
    canvas.drawLine(
      Offset(padIzq, padArriba + alto),
      Offset(size.width - padDer, padArriba + alto),
      pinturaEje,
    );

    // Barras.
    final n = valores.length;
    final anchoBarra = ancho / (n * 2);
    for (var i = 0; i < n; i++) {
      final x = padIzq + ancho * (i + 0.5) / n - anchoBarra / 2;
      final h = alto * valores[i] / maximo;
      final y = padArriba + alto - h;
      final esResaltada = indiceResaltada == i;
      final pinturaBarra = Paint()
        ..color = esResaltada
            ? PaletaNeon.rosaAcento.withOpacity(0.85)
            : PaletaNeon.azulNeon.withOpacity(0.65)
        ..style = PaintingStyle.fill;
      canvas.drawRect(Rect.fromLTWH(x, y, anchoBarra, h), pinturaBarra);
      // Borde de la barra.
      final pinturaBorde = Paint()
        ..color = esResaltada
            ? PaletaNeon.rosaAcento
            : PaletaNeon.azulNeon
        ..strokeWidth = 1.4
        ..style = PaintingStyle.stroke;
      canvas.drawRect(Rect.fromLTWH(x, y, anchoBarra, h), pinturaBorde);
      // Etiqueta debajo del eje.
      final pintor = TextPainter(
        text: TextSpan(
          text: etiquetas[i],
          style: TextStyle(
            color: esResaltada
                ? PaletaNeon.rosaAcento
                : PaletaNeon.textoPrincipal,
            fontSize: 12,
            fontWeight: esResaltada ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      pintor.paint(
        canvas,
        Offset(
          x + anchoBarra / 2 - pintor.width / 2,
          padArriba + alto + 6,
        ),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _PintorBarras oldDelegate) =>
      oldDelegate.indiceResaltada != indiceResaltada ||
      oldDelegate.valores != valores;
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
              fontSize: 28,
              fontWeight: FontWeight.w300,
              letterSpacing: 1.2,
            ),
          ),
        ),
      ),
    );
  }
}
