import '../dominio/fragmento_en_tejado.dart' show TipoFragmentoEnTejado;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../dominio/respuesta_puzzle.dart';

import '../datos/repositorio_progreso.dart';
import '../dominio/problema_ordenar_decimales.dart';
import '../l10n/app_localizations.dart';
import '../nucleo/paleta.dart';
import 'escenario.dart';
import 'estado_pista_puzzle.dart';
import 'overlay_demo_puzzle.dart';
import '../dominio/contador_intentos_puzzle.dart';
import 'widgets/boton_ayuda_puzzle.dart';
import 'widgets/ayuda_tras_fallos.dart';

/// Puzzle DEC.03: el niño ve tres decimales presentados sin orden y
/// elige el ordenamiento correcto de menor a mayor entre cuatro
/// candidatos. Los distractores recuerdan al error de "más cifras =
/// mayor", al invertido y a la lectura parcial.
class PantallaOrdenarDecimales extends StatefulWidget {
  final ProblemaOrdenarDecimales? problemaPredeterminado;

  const PantallaOrdenarDecimales({
    super.key,
    this.problemaPredeterminado,
  });

  @override
  State<PantallaOrdenarDecimales> createState() =>
      _PantallaOrdenarDecimalesState();
}

class _PantallaOrdenarDecimalesState extends State<PantallaOrdenarDecimales>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controladorCielo;
  late final EstadoPistaPuzzle _pista;
  late ProblemaOrdenarDecimales _problema;
  int? _indiceSeleccionado;
  bool _revelado = false;
  bool _mostrandoDemo = false;
  static const _idDemo = 'ordenar_decimales';

  @override
  void initState() {
    super.initState();
    _controladorCielo = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 16),
    )..repeat();
    _pista = EstadoPistaPuzzle(alCambiar: () => setState(() {}));
    _problema = widget.problemaPredeterminado ??
        GeneradorOrdenarDecimales().generar(dificultad: 1);
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
      comprobarYAyudarSiProcede(context, _pista, TipoFragmentoEnTejado.ordenarDecimales);
      if (!mounted) return;
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
                          Text(AppLocalizations.of(contexto).puzzleHeaderOrdenar,
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
                        AppLocalizations.of(contexto).puzzleInstrOrdenar,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: PaletaNeon.textoPrincipal,
                          fontSize: 18,
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      const SizedBox(height: 18),
                      _FilaDecimalesPresentados(
                        decimales: _problema.presentados,
                      ),
                      const SizedBox(height: 30),
                      Expanded(
                        child: ListView.separated(
                          itemCount: _problema.candidatos.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 12),
                          itemBuilder: (_, indice) => _TarjetaCandidato(
                            ordenamiento: _problema.candidatos[indice],
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
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              BotonAyudaPuzzle(destacar: _pista.activa, tipo: TipoFragmentoEnTejado.ordenarDecimales),
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

/// Los tres decimales presentados sin ningún indicio del orden — el
/// niño los lee y compara mentalmente.
class _FilaDecimalesPresentados extends StatelessWidget {
  final List<String> decimales;

  const _FilaDecimalesPresentados({required this.decimales});

  @override
  Widget build(BuildContext contexto) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: PaletaNeon.violetaBase.withOpacity(0.4),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: PaletaNeon.azulNeon, width: 2),
        boxShadow: [
          BoxShadow(
            color: PaletaNeon.azulNeon.withOpacity(0.4),
            blurRadius: 20,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          for (final decimal in decimales)
            Text(
              decimal,
              style: const TextStyle(
                color: PaletaNeon.textoPrincipal,
                fontSize: 28,
                fontWeight: FontWeight.w300,
                letterSpacing: 1.4,
              ),
            ),
        ],
      ),
    );
  }
}

class _TarjetaCandidato extends StatelessWidget {
  final List<String> ordenamiento;
  final bool seleccionado;
  final bool marcarCorrecto;
  final bool marcarIncorrecto;
  final bool marcarPista;
  final VoidCallback alTocar;

  const _TarjetaCandidato({
    required this.ordenamiento,
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
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: PaletaNeon.fondoMedio.withOpacity(0.55),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colorBorde, width: 1.6),
          boxShadow: brilloIntenso
              ? [
                  BoxShadow(
                    color: colorBorde.withOpacity(0.4),
                    blurRadius: 16,
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var i = 0; i < ordenamiento.length; i++) ...[
              Text(
                ordenamiento[i],
                style: TextStyle(
                  color: colorTexto,
                  fontSize: 22,
                  fontWeight: FontWeight.w300,
                  letterSpacing: 1.2,
                ),
              ),
              if (i < ordenamiento.length - 1)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    '<',
                    style: TextStyle(
                      color: colorTexto.withOpacity(0.55),
                      fontSize: 22,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
