import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../dominio/problema_grafico_circular.dart';
import '../l10n/app_localizations.dart';
import '../nucleo/paleta.dart';
import 'escenario.dart';
import '../dominio/contador_intentos_puzzle.dart';

/// Puzzle EST.02: el niño ve un gráfico circular (pie chart) con
/// porciones, una resaltada en rosa, y elige el porcentaje correcto
/// entre cuatro candidatos.
class PantallaGraficoCircular extends StatefulWidget {
  final ProblemaGraficoCircular? problemaPredeterminado;

  const PantallaGraficoCircular({super.key, this.problemaPredeterminado});

  @override
  State<PantallaGraficoCircular> createState() =>
      _PantallaGraficoCircularState();
}

class _PantallaGraficoCircularState extends State<PantallaGraficoCircular>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controladorCielo;
  late ProblemaGraficoCircular _problema;
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
        GeneradorGraficoCircular().generar(dificultad: 1);
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
                          Text(AppLocalizations.of(contexto).puzzleHeaderCircular,
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
                        _problema.preguntaTexto(),
                        style: const TextStyle(
                          color: PaletaNeon.textoPrincipal,
                          fontSize: 17,
                          letterSpacing: 1.0,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      const SizedBox(height: 18),
                      _TarjetaCircular(
                        etiquetas: _problema.etiquetas,
                        porcentajes: _problema.porcentajes,
                        indiceResaltada: _problema.indicePorcionPreguntada,
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

class _TarjetaCircular extends StatelessWidget {
  final List<String> etiquetas;
  final List<int> porcentajes;
  final int indiceResaltada;
  const _TarjetaCircular({
    required this.etiquetas,
    required this.porcentajes,
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
        width: 240,
        height: 220,
        child: CustomPaint(
          painter: _PintorCircular(
            etiquetas: etiquetas,
            porcentajes: porcentajes,
            indiceResaltada: indiceResaltada,
          ),
        ),
      ),
    );
  }
}

class _PintorCircular extends CustomPainter {
  final List<String> etiquetas;
  final List<int> porcentajes;
  final int indiceResaltada;

  _PintorCircular({
    required this.etiquetas,
    required this.porcentajes,
    required this.indiceResaltada,
  });

  /// Paleta de colores para las porciones — distintos por porción
  /// pero todos en armonía con la paleta del juego.
  static const _coloresPorcion = <Color>[
    Color(0xFF7EE8D7),
    Color(0xFFFFC36B),
    Color(0xFFB392FF),
    Color(0xFFFF9A6B),
    Color(0xFFA8E6A3),
    Color(0xFFC5CAE9),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final centro = Offset(size.width / 2, size.height / 2);
    final radio = math.min(size.width, size.height) / 2 - 26;

    var anguloInicio = -math.pi / 2;
    for (var i = 0; i < porcentajes.length; i++) {
      final barrido = porcentajes[i] * 2 * math.pi / 100;
      final esResaltada = indiceResaltada == i;
      final colorBase = esResaltada
          ? PaletaNeon.rosaAcento
          : _coloresPorcion[i % _coloresPorcion.length];
      final pintura = Paint()
        ..color = colorBase.withOpacity(esResaltada ? 0.85 : 0.55)
        ..style = PaintingStyle.fill;
      final ruta = Path()
        ..moveTo(centro.dx, centro.dy)
        ..arcTo(
          Rect.fromCircle(center: centro, radius: radio),
          anguloInicio,
          barrido,
          false,
        )
        ..close();
      canvas.drawPath(ruta, pintura);
      // Borde.
      final pinturaBorde = Paint()
        ..color = esResaltada ? PaletaNeon.rosaAcento : PaletaNeon.fondoMedio
        ..strokeWidth = esResaltada ? 2.0 : 1.4
        ..style = PaintingStyle.stroke;
      canvas.drawPath(ruta, pinturaBorde);

      // Etiqueta de la porción en su centroide angular.
      final anguloMedio = anguloInicio + barrido / 2;
      final radioEtiqueta = radio + 18;
      final pos = centro +
          Offset(
            math.cos(anguloMedio) * radioEtiqueta,
            math.sin(anguloMedio) * radioEtiqueta,
          );
      _dibujarEtiqueta(canvas, etiquetas[i], pos, esResaltada);

      anguloInicio += barrido;
    }
  }

  void _dibujarEtiqueta(
    Canvas canvas,
    String texto,
    Offset centro,
    bool esResaltada,
  ) {
    final pinturaFondo = Paint()
      ..color = PaletaNeon.fondoMedio.withOpacity(0.85)
      ..style = PaintingStyle.fill;
    final pintor = TextPainter(
      text: TextSpan(
        text: texto,
        style: TextStyle(
          color: esResaltada
              ? PaletaNeon.rosaAcento
              : PaletaNeon.textoPrincipal,
          fontSize: 13,
          fontWeight: esResaltada ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    final rect = Rect.fromCenter(
      center: centro,
      width: pintor.width + 8,
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
  bool shouldRepaint(covariant _PintorCircular oldDelegate) =>
      oldDelegate.indiceResaltada != indiceResaltada ||
      oldDelegate.porcentajes != porcentajes;
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
            '$valor%',
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
