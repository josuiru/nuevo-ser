import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../dominio/problema_comparacion_media.dart';
import '../l10n/app_localizations.dart';
import '../nucleo/paleta.dart';
import 'escenario.dart';
import '../dominio/contador_intentos_puzzle.dart';

/// Puzzle FR.03: el niño ve una fracción y elige si es menor, igual o
/// mayor que 1/2. Junto a la fracción se muestra una mitad de
/// referencia visual: rectángulo dividido en dos con una mitad
/// coloreada — el niño puede comparar a ojo si quiere, o calcular
/// el doble del numerador frente al denominador.
class PantallaComparacionMedia extends StatefulWidget {
  final ProblemaComparacionMedia? problemaPredeterminado;

  const PantallaComparacionMedia({super.key, this.problemaPredeterminado});

  @override
  State<PantallaComparacionMedia> createState() =>
      _PantallaComparacionMediaState();
}

class _PantallaComparacionMediaState extends State<PantallaComparacionMedia>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controladorCielo;
  late ProblemaComparacionMedia _problema;
  RelacionConMedia? _respuestaDada;
  bool _revelado = false;

  @override
  void initState() {
    super.initState();
    _controladorCielo = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 16),
    )..repeat();
    _problema = widget.problemaPredeterminado ??
        GeneradorComparacionMedia().generar(dificultad: 1);
  }

  @override
  void dispose() {
    _controladorCielo.dispose();
    super.dispose();
  }

  void _responder(RelacionConMedia opcion) {
    if (_revelado &&
        _respuestaDada != null &&
        _problema.esCorrecta(_respuestaDada!)) {
      return;
    }
    setState(() {
      _respuestaDada = opcion;
      _revelado = true;
    });
    if (_problema.esCorrecta(opcion)) {
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
                          Text(AppLocalizations.of(contexto).puzzleHeaderContraMitad,
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
                      const Spacer(),
                      Text(
                        _problema.fraccion.etiqueta,
                        style: const TextStyle(
                          color: PaletaNeon.textoPrincipal,
                          fontSize: 96,
                          fontWeight: FontWeight.w200,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        AppLocalizations.of(contexto).puzzleInstrContraMitad,
                        style: const TextStyle(
                          color: PaletaNeon.textoPrincipal,
                          fontSize: 18,
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Referencia visual: 1/2 dibujado como rectángulo
                      // mitad coloreado, mitad vacío. Sirve de ancla
                      // mental para el niño que aún piensa con dibujo.
                      SizedBox(
                        height: 36,
                        child: CustomPaint(
                          painter: _PintorMitadDeReferencia(),
                          size: Size.infinite,
                        ),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Expanded(
                            child: _BotonOpcion(
                              etiqueta: '< 1/2',
                              colorPrincipal: PaletaNeon.azulNeon,
                              opcion: RelacionConMedia.menor,
                              respuestaDada: _respuestaDada,
                              revelado: _revelado,
                              esCorrecta: _problema.esCorrecta(
                                  RelacionConMedia.menor),
                              alTocar: () =>
                                  _responder(RelacionConMedia.menor),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _BotonOpcion(
                              etiqueta: '= 1/2',
                              colorPrincipal: PaletaNeon.violetaNeon,
                              opcion: RelacionConMedia.igual,
                              respuestaDada: _respuestaDada,
                              revelado: _revelado,
                              esCorrecta: _problema.esCorrecta(
                                  RelacionConMedia.igual),
                              alTocar: () =>
                                  _responder(RelacionConMedia.igual),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _BotonOpcion(
                              etiqueta: '> 1/2',
                              colorPrincipal: PaletaNeon.exitoSuave,
                              opcion: RelacionConMedia.mayor,
                              respuestaDada: _respuestaDada,
                              revelado: _revelado,
                              esCorrecta: _problema.esCorrecta(
                                  RelacionConMedia.mayor),
                              alTocar: () =>
                                  _responder(RelacionConMedia.mayor),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
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

/// Rectángulo apaisado dividido en dos: mitad coloreada (azul) + mitad
/// vacía. Acompaña el texto "¿comparada con 1/2?" para anclar
/// visualmente la mitad como referencia mental.
class _PintorMitadDeReferencia extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final ancho = size.width;
    final alto = size.height;
    final mitadAncho = ancho / 2;
    const radio = Radius.circular(8);

    final pinturaColoreada = Paint()
      ..color = PaletaNeon.azulNeon.withOpacity(0.7);
    final pinturaVacia = Paint()
      ..color = PaletaNeon.violetaBase.withOpacity(0.25);
    final pinturaBorde = Paint()
      ..color = PaletaNeon.textoPrincipal.withOpacity(0.55)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    final pinturaDivision = Paint()
      ..color = PaletaNeon.textoPrincipal.withOpacity(0.45)
      ..strokeWidth = 1.2;

    final rectGlobal = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, ancho, alto),
      radio,
    );
    canvas.drawRRect(rectGlobal, pinturaVacia);

    final rectRelleno = RRect.fromRectAndCorners(
      Rect.fromLTWH(0, 0, mitadAncho, alto),
      topLeft: radio,
      bottomLeft: radio,
    );
    canvas.drawRRect(rectRelleno, pinturaColoreada);

    canvas.drawLine(
      Offset(mitadAncho, 0),
      Offset(mitadAncho, alto),
      pinturaDivision,
    );
    canvas.drawRRect(rectGlobal, pinturaBorde);
  }

  @override
  bool shouldRepaint(covariant _PintorMitadDeReferencia oldDelegate) => false;
}

class _BotonOpcion extends StatelessWidget {
  final String etiqueta;
  final Color colorPrincipal;
  final RelacionConMedia opcion;
  final RelacionConMedia? respuestaDada;
  final bool revelado;
  final bool esCorrecta;
  final VoidCallback alTocar;

  const _BotonOpcion({
    required this.etiqueta,
    required this.colorPrincipal,
    required this.opcion,
    required this.respuestaDada,
    required this.revelado,
    required this.esCorrecta,
    required this.alTocar,
  });

  @override
  Widget build(BuildContext contexto) {
    final seleccionado = respuestaDada == opcion;
    final marcarCorrecto = revelado && seleccionado && esCorrecta;
    final marcarIncorrecto = revelado && seleccionado && !esCorrecta;
    final colorBorde = marcarCorrecto
        ? PaletaNeon.exitoSuave
        : marcarIncorrecto
            ? PaletaNeon.rosaAcento
            : seleccionado
                ? colorPrincipal
                : colorPrincipal.withOpacity(0.55);
    final brilloIntenso = marcarCorrecto || marcarIncorrecto || seleccionado;
    return GestureDetector(
      onTap: alTocar,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        height: 92,
        decoration: BoxDecoration(
          color: PaletaNeon.fondoMedio.withOpacity(0.55),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: colorBorde, width: 2),
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
              fontSize: 26,
              fontWeight: FontWeight.w300,
              letterSpacing: 1.4,
            ),
          ),
        ),
      ),
    );
  }
}
