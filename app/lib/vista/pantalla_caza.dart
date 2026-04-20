import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../datos/repositorio_progreso.dart';
import '../dominio/fragmento_en_tejado.dart';
import '../dominio/generador_caza.dart';
import '../dominio/problema_decimal.dart';
import '../dominio/problema_porcentaje.dart';
import '../nucleo/paleta.dart';
import 'escenario.dart';
import 'pantalla_combate_enfoque.dart';
import 'pantalla_decimal.dart';
import 'pantalla_espejo.dart';
import 'pantalla_porcentaje.dart';
import 'pintor_fragmento_tejado.dart';
import 'sora_presencia.dart';

/// El nuevo bucle: un trozo del tejado donde los Fragmentos van
/// apareciendo. El niño decide cuál cazar, cuándo y en qué orden.
/// Si tarda demasiado, el Fragmento se escapa hacia la Montaña. Cada
/// captura deja una esquirla que engorda el contador arriba a la
/// derecha.
class PantallaCaza extends StatefulWidget {
  final RepositorioProgreso repositorio;

  const PantallaCaza({super.key, required this.repositorio});

  @override
  State<PantallaCaza> createState() => _PantallaCazaState();
}

class _PantallaCazaState extends State<PantallaCaza>
    with TickerProviderStateMixin {
  static const int _maxFragmentosEnTejado = 3;
  static const Duration _tickPeriodo = Duration(milliseconds: 120);

  final GeneradorCaza _generador = GeneradorCaza();
  final List<FragmentoEnTejado> _activos = [];

  int _esquirlasTotal = 0;
  int _esquirlasEstaSesion = 0;
  String? _lineaAmbienteSora;
  Timer? _temporizadorSpawn;
  Timer? _temporizadorTick;
  Timer? _temporizadorLineaSora;
  DateTime _ahoraRef = DateTime.now();

  late final AnimationController _controladorCielo;

  @override
  void initState() {
    super.initState();
    _controladorCielo = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 16),
    )..repeat();
    _cargarEstadoInicial();
  }

  Future<void> _cargarEstadoInicial() async {
    final total = await widget.repositorio.cargarEsquirlas();
    if (!mounted) return;
    setState(() => _esquirlasTotal = total);
    _programarSiguienteSpawn();
    _arrancarTickDeEscapes();
    _mostrarLineaAmbienteSora('Vamos. Los Fragmentos ya salen.');
  }

  @override
  void dispose() {
    _controladorCielo.dispose();
    _temporizadorSpawn?.cancel();
    _temporizadorTick?.cancel();
    _temporizadorLineaSora?.cancel();
    super.dispose();
  }

  void _programarSiguienteSpawn() {
    _temporizadorSpawn?.cancel();
    final esperaMs = 2400 + math.Random().nextInt(3000);
    _temporizadorSpawn = Timer(Duration(milliseconds: esperaMs), _intentarSpawn);
  }

  void _intentarSpawn() {
    if (!mounted) return;
    if (_activos.length < _maxFragmentosEnTejado) {
      final nuevo = _generador.siguiente(
        esquirlasAcumuladas: _esquirlasTotal + _esquirlasEstaSesion,
        ahora: DateTime.now(),
      );
      setState(() => _activos.add(nuevo));
    }
    _programarSiguienteSpawn();
  }

  void _arrancarTickDeEscapes() {
    _temporizadorTick?.cancel();
    _temporizadorTick = Timer.periodic(_tickPeriodo, (_) {
      if (!mounted) return;
      final ahora = DateTime.now();
      final seEscapanAhora = _activos
          .where((f) => f.seHaEscapado(ahora))
          .toList(growable: false);
      if (seEscapanAhora.isNotEmpty) {
        setState(() {
          for (final f in seEscapanAhora) {
            _activos.remove(f);
          }
          _ahoraRef = ahora;
        });
        _comentarTrasEscape(seEscapanAhora.length);
      } else {
        setState(() => _ahoraRef = ahora);
      }
    });
  }

  Future<void> _alTocarFragmento(FragmentoEnTejado fragmento) async {
    HapticFeedback.selectionClick();
    final capturado = await _abrirPuzzleSegunTipo(fragmento);
    if (!mounted) return;
    setState(() => _activos.remove(fragmento));
    if (capturado == true) {
      final esquirlasGanadas = switch (fragmento.tipo) {
        TipoFragmentoEnTejado.espejo => 2,
        TipoFragmentoEnTejado.decimal => 2,
        TipoFragmentoEnTejado.porcentaje => 2,
        TipoFragmentoEnTejado.unitario => fragmento.numerador,
      };
      setState(() {
        _esquirlasEstaSesion += esquirlasGanadas;
        _esquirlasTotal += esquirlasGanadas;
      });
      await widget.repositorio.guardarEsquirlas(_esquirlasTotal);
      _comentarTrasCaptura();
    } else {
      _mostrarLineaAmbienteSora('Ya volverá otro.');
    }
  }

  Future<bool?> _abrirPuzzleSegunTipo(FragmentoEnTejado fragmento) {
    switch (fragmento.tipo) {
      case TipoFragmentoEnTejado.espejo:
        return Navigator.of(context).push<bool>(
          MaterialPageRoute(
            builder: (_) => PantallaEspejo(
              numerador: fragmento.numerador,
              denominador: fragmento.denominador,
            ),
          ),
        );
      case TipoFragmentoEnTejado.decimal:
        final decimalObjetivo = _buscarDecimalConocido(
          fragmento.etiquetaDecimal,
        );
        return Navigator.of(context).push<bool>(
          MaterialPageRoute(
            builder: (_) =>
                PantallaDecimal(decimalObjetivo: decimalObjetivo),
          ),
        );
      case TipoFragmentoEnTejado.porcentaje:
        final porcentajeObjetivo = _buscarPorcentajeConocido(
          fragmento.etiquetaDecimal,
        );
        return Navigator.of(context).push<bool>(
          MaterialPageRoute(
            builder: (_) =>
                PantallaPorcentaje(porcentajeObjetivo: porcentajeObjetivo),
          ),
        );
      case TipoFragmentoEnTejado.unitario:
        return Navigator.of(context).push<bool>(
          MaterialPageRoute(
            builder: (_) => PantallaCombateEnfoque(
              numerador: fragmento.numerador,
              denominador: fragmento.denominador,
            ),
          ),
        );
    }
  }

  DecimalConocido? _buscarDecimalConocido(String? etiqueta) {
    if (etiqueta == null) return null;
    for (final d in decimalesConocidos) {
      if (d.etiqueta == etiqueta) return d;
    }
    return null;
  }

  PorcentajeConocido? _buscarPorcentajeConocido(String? etiqueta) {
    if (etiqueta == null) return null;
    for (final p in porcentajesConocidos) {
      if (p.etiqueta == etiqueta) return p;
    }
    return null;
  }

  void _comentarTrasCaptura() {
    final hitos = {
      1: 'Bien. El primero ya es tuyo.',
      5: 'Cinco. Te estás haciendo a esto.',
      10: 'Diez en una noche. Mira el barrio.',
      20: 'Veinte. A ver si te atreves con los primos.',
    };
    final mensajeHito = hitos[_esquirlasEstaSesion];
    if (mensajeHito != null) {
      _mostrarLineaAmbienteSora(mensajeHito);
      return;
    }
    if (_esquirlasEstaSesion % 3 == 0) {
      const variedad = [
        'Otro menos.',
        'Así.',
        'Bien visto.',
        'Sigue.',
      ];
      _mostrarLineaAmbienteSora(
          variedad[math.Random().nextInt(variedad.length)]);
    }
  }

  void _comentarTrasEscape(int cantidad) {
    if (cantidad == 1) {
      _mostrarLineaAmbienteSora('Se te ha ido. No pasa nada.');
    } else {
      _mostrarLineaAmbienteSora('Se han escapado varios. Atento.');
    }
  }

  void _mostrarLineaAmbienteSora(String texto) {
    _temporizadorLineaSora?.cancel();
    setState(() => _lineaAmbienteSora = texto);
    _temporizadorLineaSora = Timer(const Duration(seconds: 4), () {
      if (!mounted) return;
      setState(() => _lineaAmbienteSora = null);
    });
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
                  nivelRestauracion:
                      (_esquirlasTotal / 30).clamp(0.0, 1.0),
                ),
              ),
              SafeArea(
                child: Column(
                  children: [
                    _BarraSuperior(
                      esquirlas: _esquirlasTotal,
                      esquirlasNuevasDestello: _esquirlasEstaSesion,
                    ),
                    Expanded(
                      child: LayoutBuilder(
                        builder: (_, constraints) {
                          return Stack(
                            children: [
                              for (final fragmento in _activos)
                                _FragmentoEnMapa(
                                  key: ValueKey(fragmento.identificador),
                                  fragmento: fragmento,
                                  tamanoContenedor: constraints.biggest,
                                  ahora: _ahoraRef,
                                  fasePulso: _controladorCielo.value,
                                  alTocar: () => _alTocarFragmento(fragmento),
                                ),
                            ],
                          );
                        },
                      ),
                    ),
                    SoraPresencia(textoActivo: _lineaAmbienteSora),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _BarraSuperior extends StatelessWidget {
  final int esquirlas;
  final int esquirlasNuevasDestello;

  const _BarraSuperior({
    required this.esquirlas,
    required this.esquirlasNuevasDestello,
  });

  @override
  Widget build(BuildContext contexto) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
      child: Row(
        children: [
          const Text(
            'UNO ROTO',
            style: TextStyle(
              fontSize: 14,
              letterSpacing: 5,
              color: PaletaNeon.textoTenue,
              fontWeight: FontWeight.w300,
            ),
          ),
          const Spacer(),
          _ContadorEsquirlas(
            total: esquirlas,
            pulso: esquirlasNuevasDestello,
          ),
        ],
      ),
    );
  }
}

class _ContadorEsquirlas extends StatelessWidget {
  final int total;
  final int pulso;

  const _ContadorEsquirlas({required this.total, required this.pulso});

  @override
  Widget build(BuildContext contexto) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 260),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: PaletaNeon.fondoMedio.withOpacity(0.6),
        border: Border.all(
          color: PaletaNeon.azulNeon.withOpacity(0.6),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: pulso > 0
            ? [
                BoxShadow(
                  color: PaletaNeon.azulNeon.withOpacity(0.35),
                  blurRadius: 10,
                ),
              ]
            : const [],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 10,
            height: 10,
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: PaletaNeon.azulNeon,
              borderRadius: BorderRadius.circular(2),
              boxShadow: [
                BoxShadow(
                  color: PaletaNeon.azulNeon.withOpacity(0.6),
                  blurRadius: 8,
                ),
              ],
            ),
          ),
          Text(
            '$total esquirlas',
            style: const TextStyle(
              color: PaletaNeon.textoPrincipal,
              fontSize: 13,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _FragmentoEnMapa extends StatelessWidget {
  final FragmentoEnTejado fragmento;
  final Size tamanoContenedor;
  final DateTime ahora;
  final double fasePulso;
  final VoidCallback alTocar;

  const _FragmentoEnMapa({
    super.key,
    required this.fragmento,
    required this.tamanoContenedor,
    required this.ahora,
    required this.fasePulso,
    required this.alTocar,
  });

  @override
  Widget build(BuildContext contexto) {
    final fraccionVida = fragmento.fraccionVidaConsumida(ahora);
    final x = fragmento.xNormalizado * tamanoContenedor.width;
    final y = fragmento.yNormalizado * tamanoContenedor.height;
    final desplazaY = fraccionVida > 0.75
        ? -(fraccionVida - 0.75) / 0.25 * 80
        : 0.0;
    const diametro = 78.0;
    return Positioned(
      left: x - diametro / 2,
      top: y - diametro / 2 + desplazaY,
      child: GestureDetector(
        onTap: alTocar,
        child: SizedBox(
          width: diametro,
          height: diametro,
          child: CustomPaint(
            painter: PintorFragmentoTejado(
              fragmento: fragmento,
              fraccionVida: fraccionVida,
              fasePulso: fasePulso,
            ),
          ),
        ),
      ),
    );
  }
}
