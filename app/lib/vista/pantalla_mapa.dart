import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../datos/repositorio_progreso.dart';
import '../dominio/catalogo_distritos.dart';
import '../dominio/distrito.dart';
import '../dominio/progreso_arco.dart';
import '../dominio/rango_narrativo.dart';
import '../nucleo/paleta.dart';
import 'escenario.dart';
import 'pantalla_caza.dart';
import 'pantalla_habilidades.dart';

/// Mapa de la ciudad. Muestra los distritos del catálogo posicionados
/// según biblia §3.4 y la Montaña al fondo. Los distritos bloqueados
/// aparecen apagados con el umbral de esquirlas visible. El jugador
/// toca un distrito disponible y entra a cazar allí.
class PantallaMapa extends StatefulWidget {
  final RepositorioProgreso repositorio;

  const PantallaMapa({super.key, required this.repositorio});

  @override
  State<PantallaMapa> createState() => _PantallaMapaState();
}

class _PantallaMapaState extends State<PantallaMapa>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controladorCielo;
  int _esquirlas = 0;
  RangoNarrativo _rango = RangoNarrativo.aprendiz1;
  int _escenasArco1Vistas = 0;
  bool _cargado = false;

  @override
  void initState() {
    super.initState();
    _controladorCielo = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 16),
    )..repeat();
    _cargar();
  }

  @override
  void dispose() {
    _controladorCielo.dispose();
    super.dispose();
  }

  Future<void> _cargar() async {
    final total = await widget.repositorio.cargarEsquirlas();
    final rango = await widget.repositorio.cargarRango();
    final vistas = await ProgresoArco.arco1.contarVistas(
      widget.repositorio.flagNarrativoActivo,
    );
    if (!mounted) return;
    setState(() {
      _esquirlas = total;
      _rango = rango;
      _escenasArco1Vistas = vistas;
      _cargado = true;
    });
  }

  Future<void> _entrarADistrito(Distrito distrito) async {
    HapticFeedback.selectionClick();
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PantallaCaza(
          repositorio: widget.repositorio,
          distrito: distrito,
        ),
      ),
    );
    // Al volver del distrito, recargamos esquirlas para reflejar las
    // ganadas durante la sesión.
    await _cargar();
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
                      (_esquirlas / 100).clamp(0.0, 1.0),
                ),
              ),
              SafeArea(
                child: Column(
                  children: [
                    GestureDetector(
                      onLongPress: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => PantallaHabilidades(
                              repositorio: widget.repositorio,
                            ),
                          ),
                        );
                      },
                      behavior: HitTestBehavior.opaque,
                      child: _Encabezado(
                        esquirlas: _esquirlas,
                        rango: _rango,
                        escenasArco1Vistas: _escenasArco1Vistas,
                        totalEscenasArco1: ProgresoArco.arco1.totalEscenas,
                      ),
                    ),
                    Expanded(
                      child: _cargado
                          ? LayoutBuilder(
                              builder: (_, constraints) => _LienzoMapa(
                                esquirlas: _esquirlas,
                                tamano: constraints.biggest,
                                alEntrar: _entrarADistrito,
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
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

class _Encabezado extends StatelessWidget {
  final int esquirlas;
  final RangoNarrativo rango;
  final int escenasArco1Vistas;
  final int totalEscenasArco1;

  const _Encabezado({
    required this.esquirlas,
    required this.rango,
    required this.escenasArco1Vistas,
    required this.totalEscenasArco1,
  });

  @override
  Widget build(BuildContext contexto) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 4),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
              const SizedBox(height: 2),
              Text(
                rango.nombreVisible,
                style: TextStyle(
                  fontSize: 11,
                  letterSpacing: 2.5,
                  color: PaletaNeon.violetaNeon.withOpacity(0.85),
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 1),
              Text(
                'Arco ${ProgresoArco.arco1.nombreRomano} · $escenasArco1Vistas/$totalEscenasArco1',
                style: TextStyle(
                  fontSize: 9,
                  letterSpacing: 2,
                  color: PaletaNeon.textoTenue.withOpacity(0.55),
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              border: Border.all(
                color: PaletaNeon.azulNeon.withOpacity(0.6),
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '$esquirlas esquirlas',
              style: const TextStyle(
                color: PaletaNeon.textoPrincipal,
                fontSize: 12,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LienzoMapa extends StatelessWidget {
  final int esquirlas;
  final Size tamano;
  final ValueChanged<Distrito> alEntrar;

  const _LienzoMapa({
    required this.esquirlas,
    required this.tamano,
    required this.alEntrar,
  });

  @override
  Widget build(BuildContext contexto) {
    final ancho = tamano.width;
    final alto = tamano.height;
    return Stack(
      children: [
        // La Montaña al horizonte: inalcanzable, con marca de
        // próxima era. Biblia §4.7.
        Positioned(
          top: 4,
          left: 0,
          right: 0,
          child: Column(
            children: [
              const Text(
                'LA MONTAÑA',
                style: TextStyle(
                  color: PaletaNeon.violetaNeon,
                  fontSize: 12,
                  letterSpacing: 4,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'el horizonte espera',
                style: TextStyle(
                  color: PaletaNeon.textoTenue.withOpacity(0.7),
                  fontSize: 10,
                  letterSpacing: 1.4,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
        for (final distrito in CatalogoDistritos.todos)
          Positioned(
            left: distrito.xMapa * ancho - 68,
            top: distrito.yMapa * alto - 40,
            child: _NodoDistrito(
              distrito: distrito,
              desbloqueado: distrito.estaDesbloqueado(esquirlas),
              esquirlasDelJugador: esquirlas,
              alEntrar: alEntrar,
            ),
          ),
      ],
    );
  }
}

class _NodoDistrito extends StatelessWidget {
  final Distrito distrito;
  final bool desbloqueado;
  final int esquirlasDelJugador;
  final ValueChanged<Distrito> alEntrar;

  const _NodoDistrito({
    required this.distrito,
    required this.desbloqueado,
    required this.esquirlasDelJugador,
    required this.alEntrar,
  });

  @override
  Widget build(BuildContext contexto) {
    return GestureDetector(
      onTap: desbloqueado ? () => alEntrar(distrito) : null,
      child: Opacity(
        opacity: desbloqueado ? 1.0 : 0.45,
        child: Container(
          width: 136,
          padding: const EdgeInsets.symmetric(
              horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: PaletaNeon.fondoMedio.withOpacity(0.7),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: desbloqueado
                  ? distrito.colorAcento
                  : PaletaNeon.violetaBase,
              width: 1.6,
            ),
            boxShadow: desbloqueado
                ? [
                    BoxShadow(
                      color: distrito.colorAcento.withOpacity(0.35),
                      blurRadius: 12,
                    ),
                  ]
                : const [],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                distrito.nombre,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: desbloqueado
                      ? PaletaNeon.textoPrincipal
                      : PaletaNeon.textoTenue,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.6,
                  height: 1.15,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                desbloqueado
                    ? distrito.descripcionCorta
                    : 'se abre a las ${distrito.esquirlasParaDesbloquear} esquirlas',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: PaletaNeon.textoTenue.withOpacity(0.85),
                  fontSize: 10,
                  letterSpacing: 0.4,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
