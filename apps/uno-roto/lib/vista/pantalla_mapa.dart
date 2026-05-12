import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../datos/banco_ediciones_faro.dart';
import '../datos/repositorio_faro.dart';
import '../datos/repositorio_progreso.dart';
import '../dominio/catalogo_distritos.dart';
import '../dominio/cuaderno.dart';
import '../dominio/distrito.dart';
import '../dominio/faro_de_azula.dart';
import '../dominio/progreso_arco.dart';
import '../dominio/rango_narrativo.dart';
import '../l10n/app_localizations.dart';
import '../l10n/textos_enums.dart';
import '../l10n/traducciones_narrativa.dart';
import '../nucleo/paleta.dart';
import 'escenario.dart';
import 'pantalla_ajustes_sonido.dart';
import 'pantalla_caza.dart';
import 'pantalla_entrenamiento.dart';
import 'pantalla_progreso_distrito.dart';
import 'pantalla_faro.dart';
import 'pantalla_habilidades.dart';
import 'pantalla_instrucciones.dart';
import 'pantalla_mi_cuaderno.dart';
import 'pantalla_tour_educadores.dart';

/// Mapa de la ciudad. Muestra los distritos del catálogo posicionados
/// según biblia §3.4 y la Montaña al fondo. Los distritos bloqueados
/// aparecen apagados con el umbral de esquirlas visible. El jugador
/// toca un distrito disponible y entra a cazar allí.
class PantallaMapa extends StatefulWidget {
  final RepositorioProgreso repositorio;

  /// Callback opcional proporcionado por el orquestador para reiniciar
  /// el flujo al perfil activo tras un cambio. Se propaga a la pantalla
  /// de habilidades (y de ahí al selector de perfiles).
  final VoidCallback? alReiniciarConPerfilActivo;

  const PantallaMapa({
    super.key,
    required this.repositorio,
    this.alReiniciarConPerfilActivo,
  });

  @override
  State<PantallaMapa> createState() => _PantallaMapaState();
}

class _PantallaMapaState extends State<PantallaMapa>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controladorCielo;
  int _esquirlas = 0;
  RangoNarrativo _rango = RangoNarrativo.aprendiz1;
  ProgresoArco _arcoMostrado = ProgresoArco.arco1;
  int _escenasDelArcoVistas = 0;
  int _entradasCuadernoDisponibles = 0;
  bool _cargado = false;
  bool _hayEdicionFaroNueva = false;
  List<EdicionFaro>? _bancoFaroCacheado;

  @override
  void initState() {
    super.initState();
    _controladorCielo = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 16),
    )..repeat();
    _cargar();
    _mostrarOnboardingSiPrimeraVez();
  }

  Future<void> _mostrarOnboardingSiPrimeraVez() async {
    final yaVisto = await widget.repositorio.flagNarrativoActivo('onboarding_mapa_visto');
    if (yaVisto || !mounted) return;
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    await showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.7),
      builder: (ctx) => AlertDialog(
        backgroundColor: PaletaNeon.fondoMedio,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: PaletaNeon.violetaNeon.withOpacity(0.3),
          ),
        ),
        title: const Text(
          'Bienvenido a Azula',
          style: TextStyle(
            color: PaletaNeon.textoPrincipal,
            fontSize: 18,
            fontWeight: FontWeight.w300,
            letterSpacing: 2,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _onbParrafo('Este es el mapa de la ciudad. Cada zona tiene Fragmentos matemáticos diferentes.'),
              _onbParrafo('Para empezar, toca un distrito. Allí verás Fragmentos flotando: tócalos para resolver puzzles.'),
              _onbParrafo('Si te atascas, pulsa el botón ? en cada puzzle. Si fallas varias veces, recibirás ayuda.'),
              _onbParrafo('Desde arriba puedes entrenar por temas, ver tu cuaderno o ajustar el sonido.'),
              _onbParrafo('\u{1F917} ¡Sora te guiará!'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await widget.repositorio.activarFlagNarrativo('onboarding_mapa_visto');
              if (ctx.mounted) Navigator.of(ctx).pop();
            },
            child: const Text(
              '¡A JUGAR!',
              style: TextStyle(
                color: PaletaNeon.violetaNeon,
                letterSpacing: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _onbParrafo(String texto) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        texto,
        style: TextStyle(
          color: PaletaNeon.textoTenue.withOpacity(0.9),
          fontSize: 14,
          height: 1.5,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controladorCielo.dispose();
    super.dispose();
  }

  Future<void> _cargar() async {
    final total = await widget.repositorio.cargarEsquirlas();
    final rango = await widget.repositorio.cargarRango();
    final arco = await ProgresoArco.arcoActual(
      widget.repositorio.flagNarrativoActivo,
    );
    final vistas = await arco.contarVistas(
      widget.repositorio.flagNarrativoActivo,
    );
    final entradas = await CatalogoCuaderno.disponibles(
      widget.repositorio.flagNarrativoActivo,
    );
    final hayFaroNuevo = await _hayEdicionFaroNoLeida();
    if (!mounted) return;
    setState(() {
      _esquirlas = total;
      _rango = rango;
      _arcoMostrado = arco;
      _escenasDelArcoVistas = vistas;
      _entradasCuadernoDisponibles = entradas.length;
      _hayEdicionFaroNueva = hayFaroNuevo;
      _cargado = true;
    });
    _quizasSugerirDescargaAudio();
  }

  /// `true` cuando hay un número del Faro que el niño todavía no ha
  /// abierto en este perfil. La regla concreta vive en la función
  /// pura `tieneEdicionFaroNoLeida`; aquí sólo cargamos los valores
  /// del repositorio + el banco y delegamos.
  Future<bool> _hayEdicionFaroNoLeida() async {
    final repo = widget.repositorio.faro;
    final primeraVistaMs = await repo.cargarPrimeraVistaMs();
    final ultimaVista = await repo.cargarUltimaEdicionVista();
    if (primeraVistaMs == null || ultimaVista == null) return true;
    final banco = await _cargarBancoFaroSiHaceFalta();
    final semana = calcularNumeroSemanaActual(
      ahora: DateTime.now(),
      primeraVistaMs: primeraVistaMs,
      totalEdiciones: banco.length,
    );
    return tieneEdicionFaroNoLeida(
      primeraVistaMs: primeraVistaMs,
      ultimaEdicionVista: ultimaVista,
      semanaActual: semana,
    );
  }

  Future<List<EdicionFaro>> _cargarBancoFaroSiHaceFalta() async {
    final cacheado = _bancoFaroCacheado;
    if (cacheado != null) return cacheado;
    final banco = await cargarBancoEdicionesFaro();
    _bancoFaroCacheado = banco;
    return banco;
  }

  /// Una sola vez por instalación: si el paquete de sonido aún no se
  /// descargó, le proponemos al niño/adulto bajarlo. La sugerencia se
  /// marca como vista en cuanto el banner aparece — no reaparece
  /// aunque la rechace, para no resultar pesada.
  Future<void> _quizasSugerirDescargaAudio() async {
    final yaSugerido =
        await widget.repositorio.cargarAudioSugerenciaVista();
    if (yaSugerido) return;
    final version =
        await widget.repositorio.cargarVersionPaqueteAudio();
    if (version != null) return;
    if (!mounted) return;
    await widget.repositorio.marcarAudioSugerenciaVista();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: PaletaNeon.fondoMedio,
        duration: const Duration(seconds: 12),
        behavior: SnackBarBehavior.floating,
        content: const Text(
          'Música y voces (~3,5 MB). Mejora mucho el ambiente. '
          '¿Descargar ahora con wifi?',
          style: TextStyle(
            color: PaletaNeon.textoPrincipal,
            height: 1.35,
          ),
        ),
        action: SnackBarAction(
          label: 'DESCARGAR',
          textColor: PaletaNeon.azulNeon,
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => PantallaAjustesSonido(
                  repositorio: widget.repositorio,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _abrirMiCuaderno() async {
    HapticFeedback.selectionClick();
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) =>
            PantallaMiCuaderno(repositorio: widget.repositorio),
      ),
    );
    // Recargamos por si se abrieron entradas o subió maestría dentro.
    _cargar();
  }

  Future<void> _abrirEntrenamiento() async {
    HapticFeedback.selectionClick();
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) =>
            PantallaEntrenamiento(repositorio: widget.repositorio),
      ),
    );
    // Al volver del entrenamiento puede haber esquirlas nuevas que
    // afectan al desbloqueo de distritos en el mapa.
    await _cargar();
  }

  Future<void> _abrirInstrucciones() async {
    HapticFeedback.selectionClick();
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const PantallaInstrucciones(),
      ),
    );
  }

  Future<void> _abrirTour() async {
    HapticFeedback.selectionClick();
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const PantallaTourEducadores(),
      ),
    );
  }

  Future<void> _abrirFaro() async {
    HapticFeedback.selectionClick();
    final banco = await _cargarBancoFaroSiHaceFalta();
    if (!mounted) return;
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PantallaFaro(
          repositorioFaro: widget.repositorio.faro,
          banco: banco,
        ),
      ),
    );
    // La pantalla del Faro marca su edición como vista al abrirla,
    // así que al volver el badge debería desaparecer.
    await _cargar();
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

  Future<void> _abrirProgreso(Distrito distrito) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PantallaProgresoDistrito(
          distrito: distrito,
          repositorio: widget.repositorio,
        ),
      ),
    );
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
                              alReiniciarConPerfilActivo:
                                  widget.alReiniciarConPerfilActivo,
                            ),
                          ),
                        );
                      },
                      behavior: HitTestBehavior.opaque,
                      child: _Encabezado(
                        esquirlas: _esquirlas,
                        rango: _rango,
                        arco: _arcoMostrado,
                        escenasVistasDelArco: _escenasDelArcoVistas,
                        entradasCuaderno: _entradasCuadernoDisponibles,
                        hayFaroNuevo: _hayEdicionFaroNueva,
                        alAbrirCuaderno: _abrirMiCuaderno,
                        alAbrirEntrenamiento: _abrirEntrenamiento,
                        alAbrirFaro: _abrirFaro,
                        alAbrirInstrucciones: _abrirInstrucciones,
                        alAbrirTour: _abrirTour,
                      ),
                    ),
                    Expanded(
                      child: _cargado
                          ? LayoutBuilder(
                              builder: (_, constraints) => _LienzoMapa(
                                esquirlas: _esquirlas,
                                tamano: constraints.biggest,
                                alEntrar: _entrarADistrito,
                                onVerProgreso: (d) => _abrirProgreso(d),
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
  final ProgresoArco arco;
  final int escenasVistasDelArco;
  final int entradasCuaderno;
  final bool hayFaroNuevo;
  final VoidCallback alAbrirCuaderno;
  final VoidCallback alAbrirEntrenamiento;
  final VoidCallback alAbrirFaro;
  final VoidCallback alAbrirInstrucciones;
  final VoidCallback alAbrirTour;

  const _Encabezado({
    required this.esquirlas,
    required this.rango,
    required this.arco,
    required this.escenasVistasDelArco,
    required this.entradasCuaderno,
    required this.hayFaroNuevo,
    required this.alAbrirCuaderno,
    required this.alAbrirEntrenamiento,
    required this.alAbrirFaro,
    required this.alAbrirInstrucciones,
    required this.alAbrirTour,
  });

  @override
  Widget build(BuildContext contexto) {
    // Diseño compacto fijo. Antes se intentaba mostrar etiquetas en
    // móviles "anchos" y ocultarlas en estrechos, pero el cálculo era
    // frágil — un Redmi Note 8 a 440 dpi tiene 392 dp lógicos y los
    // chips con texto sumaban más que el ancho disponible, aplastando
    // la columna izquierda hasta romper "UNO ROTO" letra a letra. Con
    // iconos siempre + tooltips la barra cabe en cualquier teléfono y
    // queda holgada en tablet (donde igualmente no estorba).
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 4),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'UNO ROTO',
                style: TextStyle(
                  fontSize: 14,
                  letterSpacing: 5,
                  color: PaletaNeon.textoTenue,
                  fontWeight: FontWeight.w300,
                ),
                maxLines: 1,
                softWrap: false,
              ),
              const SizedBox(height: 2),
              Text(
                rango.nombreLocalizado(AppLocalizations.of(contexto)),
                style: TextStyle(
                  fontSize: 11,
                  letterSpacing: 2.5,
                  color: PaletaNeon.violetaNeon.withOpacity(0.85),
                  fontWeight: FontWeight.w400,
                ),
                maxLines: 1,
                softWrap: false,
                overflow: TextOverflow.fade,
              ),
              const SizedBox(height: 1),
              Text(
                AppLocalizations.of(contexto).mapaArcoResumen(
                  arco.nombreRomano,
                  escenasVistasDelArco,
                  arco.totalEscenas,
                ),
                style: TextStyle(
                  fontSize: 9,
                  letterSpacing: 2,
                  color: PaletaNeon.textoTenue.withOpacity(0.55),
                  fontWeight: FontWeight.w300,
                ),
                maxLines: 1,
                softWrap: false,
                overflow: TextOverflow.fade,
              ),
            ],
          ),
          const Spacer(),
          _ChipAccion(
            icono: Icons.menu_book,
            color: PaletaNeon.azulNeon,
            badge: entradasCuaderno > 0
                ? entradasCuaderno.toString()
                : null,
            alPulsar: alAbrirCuaderno,
            tooltip: 'Mi cuaderno',
          ),
          const SizedBox(width: 8),
          _ChipAccion(
            icono: Icons.newspaper,
            color: PaletaNeon.ambarCanales,
            badge: hayFaroNuevo ? '·' : null,
            alPulsar: alAbrirFaro,
            tooltip: 'El Faro de Azula',
          ),
          const SizedBox(width: 8),
          _ChipAccion(
            icono: Icons.fitness_center,
            color: PaletaNeon.violetaNeon,
            alPulsar: alAbrirEntrenamiento,
            tooltip: AppLocalizations.of(contexto).mapaBotonEntrenar,
          ),
          const SizedBox(width: 8),
          _ChipAccion(
            icono: Icons.help_outline,
            color: PaletaNeon.textoTenue,
            alPulsar: alAbrirInstrucciones,
            tooltip: AppLocalizations.of(contexto).mapaBotonInstrucciones,
          ),
          const SizedBox(width: 8),
          _ChipAccion(
            icono: Icons.school,
            color: PaletaNeon.exitoSuave,
            alPulsar: alAbrirTour,
            tooltip: 'Tour para educadores',
          ),
          const SizedBox(width: 8),
          Tooltip(
            message: AppLocalizations.of(contexto)
                .habEsquirlasResumen(esquirlas),
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                border: Border.all(
                  color: PaletaNeon.azulNeon.withOpacity(0.6),
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                esquirlas.toString(),
                style: const TextStyle(
                  color: PaletaNeon.textoPrincipal,
                  fontSize: 12,
                  letterSpacing: 1.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Chip circular del encabezado del mapa: icono pequeño + borde de
/// color, opcional badge numérico (p. ej. entradas nuevas en el
/// cuaderno). El [tooltip] suple la etiqueta porque no hay texto
/// visible — la barra prioriza compactación sobre verbosidad.
class _ChipAccion extends StatelessWidget {
  final IconData icono;
  final Color color;
  final String? badge;
  final VoidCallback alPulsar;
  final String tooltip;

  const _ChipAccion({
    required this.icono,
    required this.color,
    required this.alPulsar,
    required this.tooltip,
    this.badge,
  });

  @override
  Widget build(BuildContext contexto) {
    final hijo = Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(color: color.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icono, size: 16, color: color.withOpacity(0.85)),
          if (badge != null) ...[
            const SizedBox(width: 6),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              decoration: BoxDecoration(
                color: color.withOpacity(0.25),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                badge!,
                style: const TextStyle(
                  color: PaletaNeon.textoPrincipal,
                  fontSize: 9,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ],
      ),
    );
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: alPulsar,
        borderRadius: BorderRadius.circular(20),
        child: hijo,
      ),
    );
  }
}

class _LienzoMapa extends StatelessWidget {
  final int esquirlas;
  final Size tamano;
  final ValueChanged<Distrito> alEntrar;
  final ValueChanged<Distrito>? onVerProgreso;

  const _LienzoMapa({
    required this.esquirlas,
    required this.tamano,
    required this.alEntrar,
    this.onVerProgreso,
  });

  @override
  Widget build(BuildContext contexto) {
    final ancho = tamano.width;
    final alto = tamano.height;
    return Stack(
      children: [
        for (final distrito in CatalogoDistritos.todos)
          Positioned(
            left: distrito.xMapa * ancho - 68,
            top: distrito.yMapa * alto - 40,
            child: _NodoDistrito(
              distrito: distrito,
              desbloqueado: distrito.estaDesbloqueado(esquirlas),
              esquirlasDelJugador: esquirlas,
              alEntrar: alEntrar,
              onLongPress: onVerProgreso != null
                  ? () => onVerProgreso!(distrito)
                  : null,
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
  final VoidCallback? onLongPress;

  const _NodoDistrito({
    required this.distrito,
    required this.desbloqueado,
    required this.esquirlasDelJugador,
    required this.alEntrar,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext contexto) {
    return GestureDetector(
      onTap: desbloqueado ? () => alEntrar(distrito) : null,
      onLongPress: onLongPress,
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
                traducirNarrativa(
                  distrito.nombre,
                  Localizations.localeOf(contexto),
                ),
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
                    ? traducirNarrativa(
                        distrito.descripcionCorta,
                        Localizations.localeOf(contexto),
                      )
                    : AppLocalizations.of(contexto)
                        .mapaDistritoBloqueado(distrito.esquirlasParaDesbloquear),
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
