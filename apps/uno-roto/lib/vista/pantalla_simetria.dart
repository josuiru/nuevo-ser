import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../datos/repositorio_progreso.dart';
import '../dominio/problema_simetria.dart';
import '../l10n/app_localizations.dart';
import '../nucleo/paleta.dart';
import 'escenario.dart';
import 'estado_pista_puzzle.dart';
import 'overlay_demo_puzzle.dart';
import '../dominio/contador_intentos_puzzle.dart';

/// Puzzle GEO.07: el niño ve una figura con un eje (vertical u
/// horizontal) sobreimpreso, y decide si la figura es simétrica
/// respecto a ese eje. Decisión binaria sí/no.
class PantallaSimetria extends StatefulWidget {
  final ProblemaSimetria? problemaPredeterminado;

  const PantallaSimetria({super.key, this.problemaPredeterminado});

  @override
  State<PantallaSimetria> createState() => _PantallaSimetriaState();
}

class _PantallaSimetriaState extends State<PantallaSimetria>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controladorCielo;
  late final EstadoPistaPuzzle _pista;
  late ProblemaSimetria _problema;
  bool? _eleccion;
  bool _revelado = false;
  bool _mostrandoDemo = false;
  static const _idDemo = 'simetria';

  @override
  void initState() {
    super.initState();
    _controladorCielo = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 16),
    )..repeat();
    _pista = EstadoPistaPuzzle(alCambiar: () => setState(() {}));
    _problema = widget.problemaPredeterminado ??
        GeneradorSimetria().generar(dificultad: 1);
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

  void _elegir(bool valor) {
    if (_revelado && _problema.esCorrecta(_eleccion ?? !valor)) return;
    setState(() {
      _eleccion = valor;
      _revelado = true;
    });
    if (_problema.esCorrecta(valor)) {
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
        setState(() {
          _eleccion = null;
          _revelado = false;
        });
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
                          Text(AppLocalizations.of(contexto).puzzleHeaderSimetria,
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
                        _problema.eje == EjeSimetria.vertical
                            ? AppLocalizations.of(contexto)
                                .simetriaPreguntaVertical
                            : AppLocalizations.of(contexto)
                                .simetriaPreguntaHorizontal,
                        style: const TextStyle(
                          color: PaletaNeon.textoPrincipal,
                          fontSize: 17,
                          letterSpacing: 1.0,
                          fontWeight: FontWeight.w300,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 22),
                      _TarjetaFigura(
                        forma: _problema.forma,
                        eje: _problema.eje,
                      ),
                      const SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _BotonSiNo(
                            etiqueta:
                                AppLocalizations.of(contexto).respuestaSi,
                            seleccionado: _eleccion == true,
                            marcarCorrecto: _revelado &&
                                _eleccion == true &&
                                _problema.respuesta == true,
                            marcarIncorrecto: _revelado &&
                                _eleccion == true &&
                                _problema.respuesta != true,
                            marcarPista: _pista.activa &&
                                _problema.respuesta == true,
                            alTocar: () => _elegir(true),
                          ),
                          const SizedBox(width: 22),
                          _BotonSiNo(
                            etiqueta:
                                AppLocalizations.of(contexto).respuestaNo,
                            seleccionado: _eleccion == false,
                            marcarCorrecto: _revelado &&
                                _eleccion == false &&
                                _problema.respuesta == false,
                            marcarIncorrecto: _revelado &&
                                _eleccion == false &&
                                _problema.respuesta != false,
                            marcarPista: _pista.activa &&
                                _problema.respuesta == false,
                            alTocar: () => _elegir(false),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              if (_mostrandoDemo)
                OverlayDemoPuzzle(
                  mensaje: AppLocalizations.of(contexto).demoPuzzleTocaSiNo,
                  alCerrar: _cerrarDemo,
                  posicionRelativa: const Alignment(0, 0.55),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _TarjetaFigura extends StatelessWidget {
  final FormaSimetrica forma;
  final EjeSimetria eje;
  const _TarjetaFigura({required this.forma, required this.eje});

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
        width: 230,
        height: 220,
        child: CustomPaint(
          painter: _PintorFiguraConEje(forma: forma, eje: eje),
        ),
      ),
    );
  }
}

class _PintorFiguraConEje extends CustomPainter {
  final FormaSimetrica forma;
  final EjeSimetria eje;
  _PintorFiguraConEje({required this.forma, required this.eje});

  @override
  void paint(Canvas canvas, Size size) {
    final centro = Offset(size.width / 2, size.height / 2);

    // Eje primero (línea discontinua roja).
    final pinturaEje = Paint()
      ..color = PaletaNeon.rosaAcento.withOpacity(0.85)
      ..strokeWidth = 1.6
      ..style = PaintingStyle.stroke;
    if (eje == EjeSimetria.vertical) {
      _dibujarLineaDiscontinua(
        canvas,
        Offset(centro.dx, 8),
        Offset(centro.dx, size.height - 8),
        pinturaEje,
      );
    } else {
      _dibujarLineaDiscontinua(
        canvas,
        Offset(8, centro.dy),
        Offset(size.width - 8, centro.dy),
        pinturaEje,
      );
    }

    // Figura encima.
    final pinturaRelleno = Paint()
      ..color = PaletaNeon.azulNeon.withOpacity(0.22)
      ..style = PaintingStyle.fill;
    final pinturaTrazo = Paint()
      ..color = PaletaNeon.azulNeon
      ..strokeWidth = 2.4
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round;

    final ruta = _generarRuta(forma, centro, size);
    canvas.drawPath(ruta, pinturaRelleno);
    canvas.drawPath(ruta, pinturaTrazo);
  }

  Path _generarRuta(FormaSimetrica forma, Offset centro, Size size) {
    final lado = math.min(size.width, size.height) / 3;
    final ruta = Path();
    switch (forma) {
      case FormaSimetrica.cuadrado:
        ruta.addRect(Rect.fromCenter(
          center: centro,
          width: lado * 2,
          height: lado * 2,
        ));
        break;
      case FormaSimetrica.rectangulo:
        ruta.addRect(Rect.fromCenter(
          center: centro,
          width: lado * 2.4,
          height: lado * 1.4,
        ));
        break;
      case FormaSimetrica.trianguloEquilatero:
        final r = lado * 1.1;
        for (var i = 0; i < 3; i++) {
          final angulo = -math.pi / 2 + 2 * math.pi * i / 3;
          final p = centro +
              Offset(math.cos(angulo) * r, math.sin(angulo) * r);
          if (i == 0) {
            ruta.moveTo(p.dx, p.dy);
          } else {
            ruta.lineTo(p.dx, p.dy);
          }
        }
        ruta.close();
        break;
      case FormaSimetrica.trianguloIsosceles:
        ruta
          ..moveTo(centro.dx, centro.dy - lado * 1.2)
          ..lineTo(centro.dx - lado * 0.8, centro.dy + lado * 0.8)
          ..lineTo(centro.dx + lado * 0.8, centro.dy + lado * 0.8)
          ..close();
        break;
      case FormaSimetrica.trianguloEscaleno:
        ruta
          ..moveTo(centro.dx - lado * 1.2, centro.dy + lado * 0.4)
          ..lineTo(centro.dx + lado * 0.6, centro.dy - lado * 1.0)
          ..lineTo(centro.dx + lado * 1.0, centro.dy + lado * 0.6)
          ..close();
        break;
      case FormaSimetrica.pentagonoRegular:
        final r = lado * 1.1;
        for (var i = 0; i < 5; i++) {
          final angulo = -math.pi / 2 + 2 * math.pi * i / 5;
          final p = centro +
              Offset(math.cos(angulo) * r, math.sin(angulo) * r);
          if (i == 0) {
            ruta.moveTo(p.dx, p.dy);
          } else {
            ruta.lineTo(p.dx, p.dy);
          }
        }
        ruta.close();
        break;
      case FormaSimetrica.hexagonoRegular:
        final r = lado * 1.1;
        for (var i = 0; i < 6; i++) {
          final angulo = -math.pi / 2 + 2 * math.pi * i / 6;
          final p = centro +
              Offset(math.cos(angulo) * r, math.sin(angulo) * r);
          if (i == 0) {
            ruta.moveTo(p.dx, p.dy);
          } else {
            ruta.lineTo(p.dx, p.dy);
          }
        }
        ruta.close();
        break;
      case FormaSimetrica.letraT:
        // Forma de T: barra horizontal arriba + tronco vertical abajo.
        final h = lado * 2.0;
        final w = lado * 2.0;
        final grueso = lado * 0.5;
        ruta
          ..moveTo(centro.dx - w / 2, centro.dy - h / 2)
          ..lineTo(centro.dx + w / 2, centro.dy - h / 2)
          ..lineTo(centro.dx + w / 2, centro.dy - h / 2 + grueso)
          ..lineTo(centro.dx + grueso / 2, centro.dy - h / 2 + grueso)
          ..lineTo(centro.dx + grueso / 2, centro.dy + h / 2)
          ..lineTo(centro.dx - grueso / 2, centro.dy + h / 2)
          ..lineTo(centro.dx - grueso / 2, centro.dy - h / 2 + grueso)
          ..lineTo(centro.dx - w / 2, centro.dy - h / 2 + grueso)
          ..close();
        break;
      case FormaSimetrica.letraF:
        // Forma de F simplificada (asimétrica respecto a ambos ejes).
        final h = lado * 2.0;
        final w = lado * 1.5;
        final grueso = lado * 0.5;
        ruta
          ..moveTo(centro.dx - w / 2, centro.dy - h / 2)
          ..lineTo(centro.dx + w / 2, centro.dy - h / 2)
          ..lineTo(centro.dx + w / 2, centro.dy - h / 2 + grueso)
          ..lineTo(centro.dx - w / 2 + grueso, centro.dy - h / 2 + grueso)
          ..lineTo(centro.dx - w / 2 + grueso, centro.dy)
          ..lineTo(centro.dx + w / 4, centro.dy)
          ..lineTo(centro.dx + w / 4, centro.dy + grueso)
          ..lineTo(centro.dx - w / 2 + grueso, centro.dy + grueso)
          ..lineTo(centro.dx - w / 2 + grueso, centro.dy + h / 2)
          ..lineTo(centro.dx - w / 2, centro.dy + h / 2)
          ..close();
        break;
      case FormaSimetrica.letraR:
        // Forma de R simplificada (asimétrica).
        final h = lado * 2.0;
        final w = lado * 1.5;
        ruta
          ..moveTo(centro.dx - w / 2, centro.dy + h / 2)
          ..lineTo(centro.dx - w / 2, centro.dy - h / 2)
          ..lineTo(centro.dx + w / 4, centro.dy - h / 2)
          ..lineTo(centro.dx + w / 2, centro.dy - h / 4)
          ..lineTo(centro.dx + w / 4, centro.dy)
          ..lineTo(centro.dx + w / 2, centro.dy + h / 2)
          ..lineTo(centro.dx + w / 6, centro.dy + h / 2)
          ..lineTo(centro.dx, centro.dy + h / 6)
          ..lineTo(centro.dx - w / 4, centro.dy + h / 6)
          ..lineTo(centro.dx - w / 4, centro.dy + h / 2)
          ..close();
        break;
      case FormaSimetrica.flechaDerecha:
        // Flecha → simétrica respecto al eje horizontal.
        final h = lado * 1.2;
        final w = lado * 2.4;
        final grueso = lado * 0.4;
        ruta
          ..moveTo(centro.dx - w / 2, centro.dy - grueso)
          ..lineTo(centro.dx + w / 4, centro.dy - grueso)
          ..lineTo(centro.dx + w / 4, centro.dy - h / 2)
          ..lineTo(centro.dx + w / 2, centro.dy)
          ..lineTo(centro.dx + w / 4, centro.dy + h / 2)
          ..lineTo(centro.dx + w / 4, centro.dy + grueso)
          ..lineTo(centro.dx - w / 2, centro.dy + grueso)
          ..close();
        break;
      case FormaSimetrica.trapecioIsosceles:
        ruta
          ..moveTo(centro.dx - lado * 1.2, centro.dy + lado * 0.7)
          ..lineTo(centro.dx + lado * 1.2, centro.dy + lado * 0.7)
          ..lineTo(centro.dx + lado * 0.6, centro.dy - lado * 0.7)
          ..lineTo(centro.dx - lado * 0.6, centro.dy - lado * 0.7)
          ..close();
        break;
    }
    return ruta;
  }

  void _dibujarLineaDiscontinua(
    Canvas canvas,
    Offset desde,
    Offset hasta,
    Paint pintura,
  ) {
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

  @override
  bool shouldRepaint(covariant _PintorFiguraConEje oldDelegate) =>
      oldDelegate.forma != forma || oldDelegate.eje != eje;
}

class _BotonSiNo extends StatelessWidget {
  final String etiqueta;
  final bool seleccionado;
  final bool marcarCorrecto;
  final bool marcarIncorrecto;
  final bool marcarPista;
  final VoidCallback alTocar;

  const _BotonSiNo({
    required this.etiqueta,
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
    final colorTexto = marcarCorrecto
        ? PaletaNeon.exitoSuave
        : marcarIncorrecto
            ? PaletaNeon.rosaAcento
            : PaletaNeon.textoPrincipal;
    return GestureDetector(
      onTap: alTocar,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        width: 100,
        height: 80,
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
            etiqueta,
            style: TextStyle(
              color: colorTexto,
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
