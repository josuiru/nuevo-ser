import '../dominio/fragmento_en_tejado.dart' show TipoFragmentoEnTejado;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../dominio/respuesta_puzzle.dart';

import '../datos/repositorio_progreso.dart';
import '../dominio/contador_intentos_puzzle.dart';
import '../dominio/problema_relacion_lineal.dart';
import 'widgets/boton_ayuda_puzzle.dart';
import '../l10n/app_localizations.dart';
import '../nucleo/paleta.dart';
import 'escenario.dart';
import 'estado_pista_puzzle.dart';
import 'overlay_demo_puzzle.dart';
import 'widgets/cabecera_puzzle.dart';
import 'widgets/tarjeta_numero.dart';
import 'widgets/ayuda_tras_fallos.dart';

/// Puzzle FUN.01: el niño ve una tabla `(x, y)` y elige la función
/// `y = mx + n` correspondiente.
class PantallaRelacionLineal extends StatefulWidget {
  final ProblemaRelacionLineal? problemaPredeterminado;

  const PantallaRelacionLineal({super.key, this.problemaPredeterminado});

  @override
  State<PantallaRelacionLineal> createState() =>
      _PantallaRelacionLinealState();
}

class _PantallaRelacionLinealState extends State<PantallaRelacionLineal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controladorCielo;
  late final EstadoPistaPuzzle _pista;
  late ProblemaRelacionLineal _problema;
  int? _indiceSeleccionado;
  bool _revelado = false;
  bool _mostrandoDemo = false;
  static const _idDemo = 'relacion_lineal';

  @override
  void initState() {
    super.initState();
    _controladorCielo = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 16),
    )..repeat();
    _pista = EstadoPistaPuzzle(alCambiar: () => setState(() {}));
    _problema = widget.problemaPredeterminado ??
        GeneradorRelacionLineal().generar(dificultad: 1);
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
      comprobarYAyudarSiProcede(context, _pista, TipoFragmentoEnTejado.relacionLineal);
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
                    CabeceraPuzzle(alHuir: _huir, titulo: 'RELACIÓN'),
                    const SizedBox(height: 20),
                    const Text(
                      '¿Qué fórmula da esta tabla?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: PaletaNeon.textoPrincipal,
                        fontSize: 18,
                        letterSpacing: 1.0,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    const SizedBox(height: 18),
                    _Tabla(tabla: _problema.tabla),
                    const SizedBox(height: 18),
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
                              valor: formatearRectaCanonica(
                                _problema.candidatos[i].m,
                                _problema.candidatos[i].n,
                              ),
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
                BotonAyudaPuzzle(destacar: _pista.activa, tipo: TipoFragmentoEnTejado.relacionLineal),
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

class _Tabla extends StatelessWidget {
  final List<({int x, int y})> tabla;

  const _Tabla({required this.tabla});

  @override
  Widget build(BuildContext contexto) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      decoration: BoxDecoration(
        color: PaletaNeon.violetaBase.withOpacity(0.4),
        borderRadius: BorderRadius.circular(18),
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
          _Columna(
            titulo: 'x',
            valores: tabla.map((p) => p.x).toList(),
          ),
          Container(
            width: 1.4,
            height: tabla.length * 28.0 + 20,
            color: PaletaNeon.azulNeon.withOpacity(0.5),
          ),
          _Columna(
            titulo: 'y',
            valores: tabla.map((p) => p.y).toList(),
          ),
        ],
      ),
    );
  }
}

class _Columna extends StatelessWidget {
  final String titulo;
  final List<int> valores;

  const _Columna({required this.titulo, required this.valores});

  String _fmt(int n) => n < 0 ? '−${-n}' : '$n';

  @override
  Widget build(BuildContext contexto) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          titulo,
          style: TextStyle(
            color: PaletaNeon.textoTenue.withOpacity(0.9),
            fontSize: 14,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 8),
        for (final v in valores)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Text(
              _fmt(v),
              style: const TextStyle(
                color: PaletaNeon.textoPrincipal,
                fontSize: 22,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
      ],
    );
  }
}
