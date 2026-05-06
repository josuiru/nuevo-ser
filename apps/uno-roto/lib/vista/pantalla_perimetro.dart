import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../datos/repositorio_progreso.dart';
import '../dominio/problema_perimetro.dart';
import '../l10n/app_localizations.dart';
import '../nucleo/paleta.dart';
import 'escenario.dart';
import 'estado_pista_puzzle.dart';
import 'overlay_demo_puzzle.dart';
import '../dominio/contador_intentos_puzzle.dart';

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
  late final EstadoPistaPuzzle _pista;
  late ProblemaPerimetro _problema;
  int? _indiceSeleccionado;
  bool _revelado = false;
  bool _mostrandoDemo = false;
  static const _idDemo = 'perimetro';

  @override
  void initState() {
    super.initState();
    _controladorCielo = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 16),
    )..repeat();
    _pista = EstadoPistaPuzzle(alCambiar: () => setState(() {}));
    _problema = widget.problemaPredeterminado ??
        GeneradorPerimetro().generar(dificultad: 1);
    _decidirSiMostrarDemo();
  }

  Future<void> _decidirSiMostrarDemo() async {
    final repositorio = RepositorioProgreso();
    final vistos = await repositorio.cargarDemosPuzzlesVistos();
    if (!mounted || vistos.contains(_idDemo)) return;
    setState(() => _mostrandoDemo = true);
  }

  Future<void> _cerrarDemo() async {
    if (!_mostrandoDemo) return;
    setState(() => _mostrandoDemo = false);
    await RepositorioProgreso().marcarDemoPuzzleVisto(_idDemo);
  }

  @override
  void dispose() {
    _pista.dispose();
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
      _pista.registrarAcierto();
      Future.delayed(const Duration(milliseconds: 1100), () {
        if (!mounted) return;
        Navigator.of(context).pop(true);
      });
    } else {
      HapticFeedback.vibrate();
      contarFalloPuzzle();
      _pista.registrarFallo();
      Future.delayed(const Duration(milliseconds: 900), () {
        if (!mounted) return;
        setState(() => _revelado = false);
        _pista.mostrarSiToca();
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
                                  color: PaletaNeon.textoPrincipal,
                                  fontSize: 13,
                                  letterSpacing: 1.5,
                                ),
                              ),
                            ),
                          ),
                          const Spacer(),
                          Text(AppLocalizations.of(contexto).puzzleHeaderPerimetro,
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
                        AppLocalizations.of(contexto).puzzleInstrPerimetro,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
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
                                marcarPista: _pista.activa &&
                                    indice == _problema.indiceCorrecto,
                                alTocar: () => _elegir(indice),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (_mostrandoDemo)
                OverlayDemoPuzzle(
                  mensaje: AppLocalizations.of(contexto)
                      .demoPuzzleTocaResultado,
                  alCerrar: _cerrarDemo,
                  posicionRelativa: const Alignment(0, 0.4),
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

    // Para rectángulos y cuadrados (4 lados con par 0,2 igual y par
    // 1,3 igual) dibujamos la figura real con base horizontal — un
    // cuadrado se pinta como cuadrado, no como rombo a 45°. Para
    // triángulos no equiláteros, construimos un triángulo escaleno
    // respetando las longitudes reales. Para polígonos regulares
    // (todos los lados iguales) y el resto, usamos el polígono
    // regular sobre una circunferencia.
    final esRectanguloOcuadrado = n == 4 &&
        lados[0] == lados[2] &&
        lados[1] == lados[3];
    final esTrianguloEscaleno = n == 3 &&
        !(lados[0] == lados[1] && lados[1] == lados[2]);

    final puntos = <Offset>[];
    if (esRectanguloOcuadrado) {
      // Escala uniforme respetando proporción real lados[0]:lados[1].
      final maxAncho = size.width - 50;
      final maxAlto = size.height - 50;
      final escalaPorAncho = maxAncho / lados[0];
      final escalaPorAlto = maxAlto / lados[1];
      final escala = math.min(escalaPorAncho, escalaPorAlto);
      final anchoFinal = lados[0] * escala;
      final altoFinal = lados[1] * escala;
      puntos.addAll([
        centro + Offset(-anchoFinal / 2, -altoFinal / 2),
        centro + Offset(anchoFinal / 2, -altoFinal / 2),
        centro + Offset(anchoFinal / 2, altoFinal / 2),
        centro + Offset(-anchoFinal / 2, altoFinal / 2),
      ]);
    } else if (esTrianguloEscaleno) {
      // Construcción del triángulo respetando las longitudes reales:
      // lados[0] = p0→p1, lados[1] = p1→p2, lados[2] = p2→p0.
      // Colocamos p0 en (0,0) y p1 en (lados[0], 0); p2 se obtiene por
      // intersección de las circunferencias de radio lados[2] desde p0
      // y de radio lados[1] desde p1. Trabajamos en coordenadas
      // matemáticas (y positiva hacia arriba) y al pintar negamos y
      // para adaptarnos al canvas.
      final ladoBase = lados[0].toDouble();
      final ladoDerecho = lados[1].toDouble();
      final ladoIzquierdo = lados[2].toDouble();
      final p2x = (ladoBase * ladoBase +
              ladoIzquierdo * ladoIzquierdo -
              ladoDerecho * ladoDerecho) /
          (2 * ladoBase);
      final p2yCuadrado = ladoIzquierdo * ladoIzquierdo - p2x * p2x;
      final p2y = p2yCuadrado <= 0 ? 0.0 : math.sqrt(p2yCuadrado);
      final crudos = <Offset>[
        const Offset(0, 0),
        Offset(ladoBase, 0),
        Offset(p2x, p2y),
      ];
      final minX = crudos.map((p) => p.dx).reduce(math.min);
      final maxX = crudos.map((p) => p.dx).reduce(math.max);
      final minY = crudos.map((p) => p.dy).reduce(math.min);
      final maxY = crudos.map((p) => p.dy).reduce(math.max);
      final anchoCrudo = maxX - minX;
      final altoCrudo = maxY - minY;
      final escala = math.min(
        (size.width - 60) / anchoCrudo,
        (size.height - 60) / altoCrudo,
      );
      final centroCrudoX = (minX + maxX) / 2;
      final centroCrudoY = (minY + maxY) / 2;
      for (final crudo in crudos) {
        final x = centro.dx + (crudo.dx - centroCrudoX) * escala;
        final y = centro.dy - (crudo.dy - centroCrudoY) * escala;
        puntos.add(Offset(x, y));
      }
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
  final bool marcarPista;
  final VoidCallback alTocar;

  const _TarjetaCandidato({
    required this.valor,
    required this.seleccionado,
    required this.marcarCorrecto,
    required this.marcarIncorrecto,
    required this.alTocar,
    this.marcarPista = false,
  });

  @override
  Widget build(BuildContext contexto) {
    final colorBorde = marcarCorrecto
        ? PaletaNeon.exitoSuave
        : marcarIncorrecto
            ? PaletaNeon.rosaAcento
            : seleccionado
                ? PaletaNeon.azulNeon
                : marcarPista
                    ? PaletaNeon.exitoSuave.withOpacity(0.6)
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
              : marcarPista
                  ? [
                      BoxShadow(
                        color: PaletaNeon.exitoSuave.withOpacity(0.35),
                        blurRadius: 16,
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
