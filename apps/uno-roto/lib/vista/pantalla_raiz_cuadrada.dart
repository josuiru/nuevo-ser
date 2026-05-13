import '../dominio/fragmento_en_tejado.dart' show TipoFragmentoEnTejado;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../dominio/respuesta_puzzle.dart';

import '../datos/repositorio_progreso.dart';
import '../dominio/contador_intentos_puzzle.dart';
import '../dominio/problema_raiz_cuadrada.dart';
import 'widgets/boton_ayuda_puzzle.dart';
import '../l10n/app_localizations.dart';
import '../nucleo/paleta.dart';
import 'escenario.dart';
import 'estado_pista_puzzle.dart';
import 'overlay_demo_puzzle.dart';
import 'widgets/cabecera_puzzle.dart';
import 'widgets/cuadro_formula.dart';
import 'widgets/tarjeta_numero.dart';
import 'widgets/ayuda_tras_fallos.dart';

/// Puzzle ARI.03: el niño ve `√64` y elige la raíz entre cuatro
/// candidatos. Inversa de ARI.02 — la radicación como operación
/// contraria a la potenciación.
class PantallaRaizCuadrada extends StatefulWidget {
  final ProblemaRaizCuadrada? problemaPredeterminado;
  final int dificultad;

  const PantallaRaizCuadrada({
    super.key,
    this.problemaPredeterminado,
    this.dificultad = 1,
  });

  @override
  State<PantallaRaizCuadrada> createState() => _PantallaRaizCuadradaState();
}

class _PantallaRaizCuadradaState extends State<PantallaRaizCuadrada>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controladorCielo;
  late final EstadoPistaPuzzle _pista;
  late ProblemaRaizCuadrada _problema;
  int? _indiceSeleccionado;
  bool _revelado = false;
  bool _mostrandoDemo = false;
  static const _idDemo = 'raiz_cuadrada';

  @override
  void initState() {
    super.initState();
    _controladorCielo = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 16),
    )..repeat();
    _pista = EstadoPistaPuzzle(alCambiar: () => setState(() {}));
    _problema = widget.problemaPredeterminado ??
        GeneradorRaizCuadrada().generar(dificultad: widget.dificultad);
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
      comprobarYAyudarSiProcede(context, _pista, TipoFragmentoEnTejado.raizCuadrada);
      if (!mounted) return;
      Future.delayed(const Duration(milliseconds: 900), () {
        if (!mounted) return;
        setState(() => _revelado = false);
        _pista.mostrarSiToca();
      });
    }
  }

  void _huir() => Navigator.of(context).pop(false);

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
                    CabeceraPuzzle(alHuir: _huir, titulo: 'RAÍZ CUADRADA'),
                    const SizedBox(height: 32),
                    const Text(
                      '¿Cuál es la raíz?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: PaletaNeon.textoPrincipal,
                        fontSize: 20,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    const SizedBox(height: 36),
                    CuadroFormula(etiqueta: _problema.etiqueta),
                    const SizedBox(height: 36),
                    Expanded(
                      child: GridView.count(
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 1.4,
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
                BotonAyudaPuzzle(destacar: _pista.activa, tipo: TipoFragmentoEnTejado.raizCuadrada),
          if (_mostrandoDemo)
              OverlayDemoPuzzle(
                mensaje:
                    AppLocalizations.of(contexto).demoPuzzleTocaResultado,
                alCerrar: _cerrarDemo,
                posicionRelativa: const Alignment(0, 0.4),
              ),
          ],
        ),
      ),
    );
  }
}
