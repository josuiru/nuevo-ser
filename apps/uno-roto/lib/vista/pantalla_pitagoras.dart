import '../dominio/fragmento_en_tejado.dart' show TipoFragmentoEnTejado;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../dominio/respuesta_puzzle.dart';

import '../datos/repositorio_progreso.dart';
import '../dominio/contador_intentos_puzzle.dart';
import '../dominio/problema_pitagoras.dart';
import 'widgets/boton_ayuda_puzzle.dart';
import '../l10n/app_localizations.dart';
import '../nucleo/paleta.dart';
import 'escenario.dart';
import 'estado_pista_puzzle.dart';
import 'overlay_demo_puzzle.dart';
import 'widgets/cabecera_puzzle.dart';
import 'widgets/tarjeta_numero.dart';
import 'widgets/ayuda_tras_fallos.dart';

/// Puzzle GEO.08: el niño ve un triángulo rectángulo dibujado con dos
/// lados etiquetados y elige el tercero. Aplicación de Pitágoras.
class PantallaPitagoras extends StatefulWidget {
  final ProblemaPitagoras? problemaPredeterminado;

  const PantallaPitagoras({super.key, this.problemaPredeterminado});

  @override
  State<PantallaPitagoras> createState() => _PantallaPitagorasState();
}

class _PantallaPitagorasState extends State<PantallaPitagoras>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controladorCielo;
  late final EstadoPistaPuzzle _pista;
  late ProblemaPitagoras _problema;
  int? _indiceSeleccionado;
  bool _revelado = false;
  bool _mostrandoDemo = false;
  static const _idDemo = 'pitagoras';

  @override
  void initState() {
    super.initState();
    _controladorCielo = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 16),
    )..repeat();
    _pista = EstadoPistaPuzzle(alCambiar: () => setState(() {}));
    _problema = widget.problemaPredeterminado ??
        GeneradorPitagoras().generar(dificultad: 1);
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
      UltimaRespuestaPuzzle.registrar(RespuestaPuzzle(
        acertado: true,
        respuestaDelNino: '${_problema.candidatos[indice]}',
        respuestaCorrecta: '${_problema.candidatos[_problema.indiceCorrecto]}',
        preguntaTexto: 'elige la opción correcta',
        opciones: _problema.candidatos.map((c) => '$c').toList(),
      ));
      Future.delayed(const Duration(milliseconds: 1100), () {
        if (!mounted) return;
        Navigator.of(context).pop(true);
      });
    } else {
      HapticFeedback.vibrate();
      contarFalloPuzzle();
      _pista.registrarFallo();
      comprobarYAyudarSiProcede(context, _pista, TipoFragmentoEnTejado.pitagoras);
      if (!mounted) return;
      Future.delayed(const Duration(milliseconds: 900), () {
        if (!mounted) return;
        setState(() => _revelado = false);
        _pista.mostrarSiToca();
      });
    }
  }

  void _huir() => Navigator.of(context).pop(false);

  String get _instruccion =>
      _problema.modo == ModoPitagoras.hipotenusa
          ? '¿Cuánto mide la hipotenusa?'
          : '¿Cuánto mide el otro cateto?';

  @override
  Widget build(BuildContext contexto) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _controladorCielo,
        builder: (_, __) => Stack(
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
                    CabeceraPuzzle(alHuir: _huir, titulo: 'PITÁGORAS'),
                    const SizedBox(height: 24),
                    Text(
                      _instruccion,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: PaletaNeon.textoPrincipal,
                        fontSize: 18,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    const SizedBox(height: 12),
                    AspectRatio(
                      aspectRatio: 1.0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: CustomPaint(
                          painter: _PintorTrianguloRectangulo(
                            problema: _problema,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: GridView.count(
                        crossAxisCount: 2,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 1.8,
                        children: [
                          for (var i = 0;
                              i < _problema.candidatos.length;
                              i++)
                            TarjetaNumero(
                              valor: _problema.candidatos[i].toString(),
                              seleccionado: _indiceSeleccionado == i,
                              marcarCorrecto: _revelado &&
                                  _indiceSeleccionado == i &&
                                  i == _problema.indiceCorrecto,
                              marcarIncorrecto: _revelado &&
                                  _indiceSeleccionado == i &&
                                  i != _problema.indiceCorrecto,
                              marcarPista: _pista.activa &&
                                  i == _problema.indiceCorrecto,
                              alTocar: () => _elegir(i),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
                BotonAyudaPuzzle(destacar: _pista.activa, tipo: TipoFragmentoEnTejado.pitagoras),
          if (_mostrandoDemo)
              OverlayDemoPuzzle(
                mensaje:
                    AppLocalizations.of(contexto).demoPuzzleTocaResultado,
                alCerrar: _cerrarDemo,
                posicionRelativa: const Alignment(0, 0.45),
              ),
          ],
        ),
      ),
    );
  }
}

/// Pinta un triángulo rectángulo con catetos a (horizontal abajo) y b
/// (vertical a la izquierda) e hipotenusa cerrando la diagonal.
/// Etiqueta los dos lados conocidos según el modo. El tamaño visual
/// se escala normalizando el cateto mayor al borde del lienzo.
class _PintorTrianguloRectangulo extends CustomPainter {
  final ProblemaPitagoras problema;

  _PintorTrianguloRectangulo({required this.problema});

  @override
  void paint(Canvas canvas, Size size) {
    final pincelLinea = Paint()
      ..color = PaletaNeon.azulNeon
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4;

    final pincelHipotenusa = Paint()
      ..color = problema.modo == ModoPitagoras.hipotenusa
          ? PaletaNeon.violetaNeon
          : PaletaNeon.azulNeon
      ..style = PaintingStyle.stroke
      ..strokeWidth = problema.modo == ModoPitagoras.hipotenusa ? 3.4 : 2.4;

    // Escalado: el lado más grande llena el 75% del lienzo.
    final escala = (size.width * 0.75) / problema.hipotenusa;
    final ladoA = problema.a * escala;
    final ladoB = problema.b * escala;

    // Esquina inferior izquierda fija como ángulo recto.
    final esquinaRect = Offset(
      (size.width - ladoA) / 2,
      size.height * 0.85,
    );
    final esquinaDcha = esquinaRect.translate(ladoA, 0);
    final esquinaArriba = esquinaRect.translate(0, -ladoB);

    // Catetos.
    canvas.drawLine(esquinaRect, esquinaDcha, pincelLinea);
    canvas.drawLine(esquinaRect, esquinaArriba, pincelLinea);

    // Hipotenusa (resaltada si es la incógnita).
    canvas.drawLine(esquinaArriba, esquinaDcha, pincelHipotenusa);

    // Marca de ángulo recto.
    final pincelMarca = Paint()
      ..color = PaletaNeon.textoTenue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;
    final tamMarca = 12.0;
    canvas.drawRect(
      Rect.fromLTWH(
        esquinaRect.dx,
        esquinaRect.dy - tamMarca,
        tamMarca,
        tamMarca,
      ),
      pincelMarca,
    );

    // Etiquetas — el cateto a se ve siempre. El cateto b se ve si la
    // incógnita es la hipotenusa; si la incógnita es b, lo ocultamos
    // y mostramos "?" en su sitio.
    final muestraB = problema.modo == ModoPitagoras.hipotenusa;
    final muestraHip = problema.modo == ModoPitagoras.cateto;
    _pintarTexto(
      canvas,
      texto: '${problema.a}',
      ancla: Offset(esquinaRect.dx + ladoA / 2, esquinaRect.dy + 18),
      color: PaletaNeon.textoPrincipal,
    );
    _pintarTexto(
      canvas,
      texto: muestraB ? '${problema.b}' : '?',
      ancla: Offset(esquinaRect.dx - 18, esquinaRect.dy - ladoB / 2),
      color: muestraB
          ? PaletaNeon.textoPrincipal
          : PaletaNeon.violetaNeon,
      tamano: muestraB ? 16 : 22,
    );
    _pintarTexto(
      canvas,
      texto: muestraHip ? '${problema.hipotenusa}' : '?',
      ancla: Offset(
        (esquinaArriba.dx + esquinaDcha.dx) / 2 + 18,
        (esquinaArriba.dy + esquinaDcha.dy) / 2 - 18,
      ),
      color: muestraHip
          ? PaletaNeon.textoPrincipal
          : PaletaNeon.violetaNeon,
      tamano: muestraHip ? 16 : 22,
    );
  }

  void _pintarTexto(
    Canvas canvas, {
    required String texto,
    required Offset ancla,
    required Color color,
    double tamano = 16,
  }) {
    final pincel = TextPainter(
      text: TextSpan(
        text: texto,
        style: TextStyle(
          color: color,
          fontSize: tamano,
          fontWeight: FontWeight.w400,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    pincel.paint(canvas, ancla - Offset(pincel.width / 2, pincel.height / 2));
  }

  @override
  bool shouldRepaint(_PintorTrianguloRectangulo viejo) =>
      viejo.problema != problema;
}
