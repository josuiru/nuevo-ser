import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../datos/repositorio_progreso.dart';
import '../dominio/problema_volumen.dart';
import '../l10n/app_localizations.dart';
import '../nucleo/paleta.dart';
import 'escenario.dart';
import 'estado_pista_puzzle.dart';
import 'overlay_demo_puzzle.dart';
import '../dominio/contador_intentos_puzzle.dart';

/// Puzzle GEO.06: el niño ve una caja 3D (ortoedro) con sus tres
/// dimensiones etiquetadas y elige el volumen entre cuatro candidatos.
class PantallaVolumen extends StatefulWidget {
  final ProblemaVolumen? problemaPredeterminado;

  const PantallaVolumen({super.key, this.problemaPredeterminado});

  @override
  State<PantallaVolumen> createState() => _PantallaVolumenState();
}

class _PantallaVolumenState extends State<PantallaVolumen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controladorCielo;
  late final EstadoPistaPuzzle _pista;
  late ProblemaVolumen _problema;
  int? _indiceSeleccionado;
  bool _revelado = false;
  bool _mostrandoDemo = false;
  static const _idDemo = 'volumen';

  @override
  void initState() {
    super.initState();
    _controladorCielo = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 16),
    )..repeat();
    _pista = EstadoPistaPuzzle(alCambiar: () => setState(() {}));
    _problema = widget.problemaPredeterminado ??
        GeneradorVolumen().generar(dificultad: 1);
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
                          Text(AppLocalizations.of(contexto).puzzleHeaderVolumen,
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
                        AppLocalizations.of(contexto).puzzleInstrVolumenFormula,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: PaletaNeon.textoPrincipal,
                          fontSize: 17,
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      const SizedBox(height: 22),
                      _TarjetaCaja(
                        largo: _problema.largo,
                        ancho: _problema.ancho,
                        alto: _problema.alto,
                      ),
                      const SizedBox(height: 28),
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

class _TarjetaCaja extends StatelessWidget {
  final int largo;
  final int ancho;
  final int alto;
  const _TarjetaCaja({
    required this.largo,
    required this.ancho,
    required this.alto,
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
        width: 250,
        height: 200,
        child: CustomPaint(
          painter: _PintorOrtoedro(largo: largo, ancho: ancho, alto: alto),
        ),
      ),
    );
  }
}

class _PintorOrtoedro extends CustomPainter {
  final int largo;
  final int ancho;
  final int alto;
  _PintorOrtoedro({
    required this.largo,
    required this.ancho,
    required this.alto,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Proyección isométrica con los tres ejes proyectando la misma
    // longitud: una unidad real ocupa el mismo número de píxeles en
    // largo, ancho y alto. Eje x→derecha, eje y→abajo, eje z
    // (profundidad)→arriba-derecha a 30°: una unidad de profundidad se
    // proyecta como (cos 30°, -sin 30°) ≈ (0,866, -0,5).
    const cos30 = 0.8660254037844387;
    const sin30 = 0.5;
    final escala = math.min(
      (size.width - 60) / (largo + ancho * cos30),
      (size.height - 60) / (alto + ancho * sin30),
    );
    final dx = largo * escala;
    final dy = alto * escala;
    final profX = ancho * escala * cos30;
    final profY = -ancho * escala * sin30;

    final origenX = (size.width - dx - profX) / 2;
    final origenY = (size.height + dy + profY) / 2 - 10;

    // Cara frontal (x-y).
    final frenteInferiorIzquierda = Offset(origenX, origenY);
    final frenteInferiorDerecha = Offset(origenX + dx, origenY);
    final frenteSuperiorIzquierda = Offset(origenX, origenY - dy);
    final frenteSuperiorDerecha = Offset(origenX + dx, origenY - dy);
    // Cara trasera (desplazada por la profundidad).
    final atrasInferiorIzquierda = frenteInferiorIzquierda.translate(profX, profY);
    final atrasInferiorDerecha = frenteInferiorDerecha.translate(profX, profY);
    final atrasSuperiorIzquierda = frenteSuperiorIzquierda.translate(profX, profY);
    final atrasSuperiorDerecha = frenteSuperiorDerecha.translate(profX, profY);

    final pinturaRelleno = Paint()
      ..color = PaletaNeon.azulNeon.withOpacity(0.22)
      ..style = PaintingStyle.fill;
    final pinturaTrazo = Paint()
      ..color = PaletaNeon.azulNeon
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round;
    final pinturaTrazoTenue = Paint()
      ..color = PaletaNeon.azulNeon.withOpacity(0.5)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    // Cara frontal.
    final frente = Path()
      ..moveTo(frenteInferiorIzquierda.dx, frenteInferiorIzquierda.dy)
      ..lineTo(frenteInferiorDerecha.dx, frenteInferiorDerecha.dy)
      ..lineTo(frenteSuperiorDerecha.dx, frenteSuperiorDerecha.dy)
      ..lineTo(frenteSuperiorIzquierda.dx, frenteSuperiorIzquierda.dy)
      ..close();
    canvas.drawPath(frente, pinturaRelleno);

    // Aristas traseras (visibles a través, dibujadas tenues primero).
    canvas.drawLine(
      atrasInferiorIzquierda,
      atrasInferiorDerecha,
      pinturaTrazoTenue,
    );
    canvas.drawLine(
      atrasInferiorIzquierda,
      atrasSuperiorIzquierda,
      pinturaTrazoTenue,
    );

    // Cara superior.
    final superior = Path()
      ..moveTo(frenteSuperiorIzquierda.dx, frenteSuperiorIzquierda.dy)
      ..lineTo(frenteSuperiorDerecha.dx, frenteSuperiorDerecha.dy)
      ..lineTo(atrasSuperiorDerecha.dx, atrasSuperiorDerecha.dy)
      ..lineTo(atrasSuperiorIzquierda.dx, atrasSuperiorIzquierda.dy)
      ..close();
    canvas.drawPath(superior, pinturaRelleno);
    canvas.drawPath(superior, pinturaTrazo);

    // Cara lateral derecha.
    final lateral = Path()
      ..moveTo(frenteInferiorDerecha.dx, frenteInferiorDerecha.dy)
      ..lineTo(frenteSuperiorDerecha.dx, frenteSuperiorDerecha.dy)
      ..lineTo(atrasSuperiorDerecha.dx, atrasSuperiorDerecha.dy)
      ..lineTo(atrasInferiorDerecha.dx, atrasInferiorDerecha.dy)
      ..close();
    canvas.drawPath(lateral, pinturaRelleno);
    canvas.drawPath(lateral, pinturaTrazo);

    // Aristas frontales encima.
    canvas.drawPath(frente, pinturaTrazo);

    // Etiquetas.
    _dibujarEtiqueta(
      canvas,
      '$largo',
      Offset((frenteInferiorIzquierda.dx + frenteInferiorDerecha.dx) / 2,
          frenteInferiorIzquierda.dy + 16),
    );
    _dibujarEtiqueta(
      canvas,
      '$ancho',
      Offset((frenteInferiorDerecha.dx + atrasInferiorDerecha.dx) / 2 + 12,
          (frenteInferiorDerecha.dy + atrasInferiorDerecha.dy) / 2 + 8),
    );
    _dibujarEtiqueta(
      canvas,
      '$alto',
      Offset(frenteSuperiorIzquierda.dx - 18,
          (frenteInferiorIzquierda.dy + frenteSuperiorIzquierda.dy) / 2),
    );
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
          fontSize: 16,
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
  bool shouldRepaint(covariant _PintorOrtoedro oldDelegate) =>
      oldDelegate.largo != largo ||
      oldDelegate.ancho != ancho ||
      oldDelegate.alto != alto;
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
