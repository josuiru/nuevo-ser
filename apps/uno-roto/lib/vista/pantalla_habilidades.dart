import 'package:flutter/material.dart';

import '../datos/cache_tutor.dart';
import '../datos/catalogo_habilidades.dart';
import '../datos/cliente_api.dart';
import '../datos/cliente_tutor.dart';
import '../datos/config_api.dart';
import '../datos/repositorio_progreso.dart';
import '../dominio/habilidad.dart';
import '../dominio/rango_narrativo.dart';
import '../dominio/ritmo_juego.dart';
import '../dominio/tutor/servicio_tutor.dart';
import '../l10n/app_localizations.dart';
import '../l10n/textos_enums.dart';
import '../main.dart' show localeAppUnoRoto;
import '../nucleo/paleta.dart';
import 'pantalla_acerca_de.dart';
import 'pantalla_ajustes_sonido.dart';
import 'pantalla_cuenta.dart';
import 'pantalla_perfiles.dart';
import 'pantalla_tutor.dart';

/// Panel que lista las 66 habilidades del mapa pedagógico y muestra
/// para cada una el nivel actual del niño y su precisión. Accesible
/// desde el mapa con long-press. Futuro dashboard de padres (doc 03 §7)
/// en forma rudimentaria.
class PantallaHabilidades extends StatefulWidget {
  final RepositorioProgreso repositorio;

  /// Callback que el orquestador proporciona para reiniciar la app
  /// completa con el perfil activo. Se invoca tras elegir perfil en el
  /// selector abierto desde esta pantalla.
  final VoidCallback? alReiniciarConPerfilActivo;

  const PantallaHabilidades({
    super.key,
    required this.repositorio,
    this.alReiniciarConPerfilActivo,
  });

  @override
  State<PantallaHabilidades> createState() => _PantallaHabilidadesState();
}

class _PantallaHabilidadesState extends State<PantallaHabilidades> {
  CatalogoHabilidades? _catalogo;
  Map<String, EstadoHabilidad> _estados = {};
  RangoNarrativo _rangoActual = RangoNarrativo.aprendiz1;
  int _esquirlasActuales = 0;
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    final catalogo = await CatalogoHabilidades.cargar();
    final estados = <String, EstadoHabilidad>{};
    for (final h in catalogo.habilidades.values) {
      final estado = await widget.repositorio.cargarEstadoHabilidad(
        h.identificador,
      );
      if (estado != null) estados[h.identificador] = estado;
    }
    final rango = await widget.repositorio.cargarRango();
    final esquirlas = await widget.repositorio.cargarEsquirlas();
    if (!mounted) return;
    setState(() {
      _catalogo = catalogo;
      _estados = estados;
      _rangoActual = rango;
      _esquirlasActuales = esquirlas;
      _cargando = false;
    });
  }

  @override
  Widget build(BuildContext contexto) {
    final textos = AppLocalizations.of(contexto);
    return Scaffold(
      backgroundColor: PaletaNeon.fondoProfundo,
      appBar: AppBar(
        backgroundColor: PaletaNeon.fondoMedio,
        title: Text(
          textos.habTitulo,
          style: const TextStyle(
            color: PaletaNeon.textoPrincipal,
            fontSize: 16,
            letterSpacing: 4,
            fontWeight: FontWeight.w300,
          ),
        ),
        iconTheme: const IconThemeData(color: PaletaNeon.textoTenue),
        // Sólo las tres acciones más usadas son visibles. El resto
        // (ritmo, idioma, sync, tutor debug, reiniciar) viven en el
        // menú overflow `⋮` para que el AppBar no se monte sobre el
        // título en móviles estrechos.
        actions: [
          IconButton(
            tooltip: textos.habTooltipPerfiles,
            onPressed: _abrirPantallaPerfiles,
            icon: Icon(
              Icons.switch_account,
              color: PaletaNeon.textoTenue.withOpacity(0.7),
            ),
          ),
          IconButton(
            tooltip: textos.habTooltipSonido,
            onPressed: _abrirAjustesSonido,
            icon: Icon(
              Icons.volume_up_outlined,
              color: PaletaNeon.textoTenue.withOpacity(0.7),
            ),
          ),
          IconButton(
            tooltip: textos.habTooltipCuenta,
            onPressed: _abrirCuenta,
            icon: Icon(
              Icons.account_circle_outlined,
              color: PaletaNeon.textoTenue.withOpacity(0.7),
            ),
          ),
          PopupMenuButton<String>(
            tooltip: 'Más opciones',
            color: PaletaNeon.fondoMedio,
            iconColor: PaletaNeon.textoTenue.withOpacity(0.7),
            onSelected: (id) {
              switch (id) {
                case 'ritmo':
                  _abrirDialogoRitmo();
                case 'idioma':
                  _abrirDialogoIdioma();
                case 'acerca':
                  _abrirAcercaDe();
                case 'sync':
                  _sincronizar();
                case 'tutor':
                  _probarTutor();
                case 'reiniciar':
                  _confirmarYReiniciar();
              }
            },
            itemBuilder: (_) => [
              _itemMenu(
                id: 'ritmo',
                icono: Icons.speed,
                etiqueta: textos.habTooltipRitmo,
              ),
              _itemMenu(
                id: 'idioma',
                icono: Icons.translate,
                etiqueta: textos.habTooltipIdioma,
              ),
              _itemMenu(
                id: 'acerca',
                icono: Icons.info_outline,
                etiqueta: 'Acerca de Uno Roto',
              ),
              const PopupMenuDivider(),
              _itemMenu(
                id: 'sync',
                icono: Icons.cloud_sync_outlined,
                etiqueta: textos.habTooltipSync,
              ),
              _itemMenu(
                id: 'tutor',
                icono: Icons.chat_bubble_outline,
                etiqueta: textos.habTooltipDebugTutor,
              ),
              _itemMenu(
                id: 'reiniciar',
                icono: Icons.refresh,
                etiqueta: textos.habTooltipReiniciar,
              ),
            ],
          ),
        ],
      ),
      body: _cargando
          ? const Center(
              child: CircularProgressIndicator(color: PaletaNeon.azulNeon),
            )
          : _listaPorDominio(),
    );
  }

  /// Helper para construir cada entrada del menú overflow del AppBar.
  /// Centraliza estilo (icono tenue + texto pequeño) para que las
  /// cinco entradas debug se vean iguales.
  PopupMenuItem<String> _itemMenu({
    required String id,
    required IconData icono,
    required String etiqueta,
  }) {
    return PopupMenuItem<String>(
      value: id,
      child: Row(
        children: [
          Icon(icono, size: 16, color: PaletaNeon.textoTenue),
          const SizedBox(width: 12),
          Text(
            etiqueta,
            style: const TextStyle(
              color: PaletaNeon.textoPrincipal,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _abrirPantallaPerfiles() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PantallaPerfiles(
          repositorio: widget.repositorio,
          // Al elegir perfil delegamos al orquestador el reinicio
          // completo del flujo, para que la siguiente pantalla
          // corresponda al progreso del perfil recién activado.
          alPerfilSeleccionado: () {
            widget.alReiniciarConPerfilActivo?.call();
          },
        ),
      ),
    );
  }

  Future<void> _abrirAjustesSonido() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PantallaAjustesSonido(
          repositorio: widget.repositorio,
        ),
      ),
    );
  }

  Future<void> _abrirDialogoRitmo() async {
    final actual = await widget.repositorio.cargarRitmo();
    if (!mounted) return;
    final textos = AppLocalizations.of(context);
    final elegido = await showDialog<RitmoJuego>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: PaletaNeon.fondoMedio,
        title: Text(
          textos.habRitmoTitulo,
          style: const TextStyle(color: PaletaNeon.textoPrincipal),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final ritmo in RitmoJuego.values)
              RadioListTile<RitmoJuego>(
                value: ritmo,
                groupValue: actual,
                activeColor: PaletaNeon.violetaNeon,
                title: Text(
                  ritmo.nombreLocalizado(textos),
                  style: const TextStyle(
                    color: PaletaNeon.textoPrincipal,
                    fontSize: 14,
                  ),
                ),
                subtitle: Text(
                  ritmo.descripcionLocalizada(textos),
                  style: TextStyle(
                    color: PaletaNeon.textoTenue.withOpacity(0.75),
                    fontSize: 11,
                  ),
                ),
                onChanged: (v) => Navigator.of(ctx).pop(v),
              ),
          ],
        ),
      ),
    );
    if (elegido == null || elegido == actual) return;
    await widget.repositorio.guardarRitmo(elegido);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: PaletaNeon.fondoMedio,
        duration: const Duration(seconds: 3),
        content: Text(
          AppLocalizations.of(context).habRitmoSnack(
            elegido.nombreLocalizado(AppLocalizations.of(context)),
          ),
          style: const TextStyle(color: PaletaNeon.textoPrincipal),
        ),
      ),
    );
  }

  Future<void> _abrirCuenta() async {
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => PantallaCuenta(repositorio: widget.repositorio),
    ));
    if (!mounted) return;
    setState(() {});
  }

  Future<void> _abrirAcercaDe() async {
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => const PantallaAcercaDe(),
    ));
  }

  /// Abre el selector de idioma. Persiste la elección como clave global
  /// `uroto.idioma_app` y empuja el nuevo locale al `ValueNotifier` que
  /// alimenta `MaterialApp` — todos los textos `AppLocalizations.of(...)`
  /// rebuilden al instante. Las etiquetas del diálogo van en su propio
  /// idioma (Castellano/Euskara/Català) para que el niño las reconozca
  /// aunque haya elegido mal antes.
  Future<void> _abrirDialogoIdioma() async {
    final actual = await widget.repositorio.cargarIdiomaApp() ?? 'es';
    if (!mounted) return;
    final textos = AppLocalizations.of(context);
    final elegido = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: PaletaNeon.fondoMedio,
        title: Text(
          textos.habIdiomaTitulo,
          style: const TextStyle(color: PaletaNeon.textoPrincipal),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final entrada in const [
              ('es', 'Castellano'),
              ('eu', 'Euskara'),
              ('ca', 'Català'),
            ])
              RadioListTile<String>(
                value: entrada.$1,
                groupValue: actual,
                activeColor: PaletaNeon.violetaNeon,
                title: Text(
                  entrada.$2,
                  style: const TextStyle(
                    color: PaletaNeon.textoPrincipal,
                    fontSize: 14,
                  ),
                ),
                onChanged: (v) => Navigator.of(ctx).pop(v),
              ),
          ],
        ),
      ),
    );
    if (elegido == null || elegido == actual) return;
    await widget.repositorio.guardarIdiomaApp(elegido);
    localeAppUnoRoto.value = Locale(elegido);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: PaletaNeon.fondoMedio,
        duration: const Duration(seconds: 3),
        content: Text(
          AppLocalizations.of(context).habIdiomaSnack,
          style: const TextStyle(color: PaletaNeon.textoPrincipal),
        ),
      ),
    );
  }

  /// Sincroniza el progreso usando el token guardado. Si no hay
  /// cuenta vinculada o el token caducó, redirige al usuario a la
  /// pantalla de cuenta para que vincule o reinicie sesión —
  /// preferimos no bloquearlo con un mensaje técnico.
  Future<void> _sincronizar() async {
    final mensajero = ScaffoldMessenger.of(context);
    final textos = AppLocalizations.of(context);
    final token = await widget.repositorio.cargarTokenBackend();
    if (token == null || token.isEmpty) {
      mensajero.showSnackBar(
        SnackBar(
          backgroundColor: PaletaNeon.fondoMedio,
          content: Text(
            textos.habSyncFaltaToken,
            style: const TextStyle(color: PaletaNeon.textoTenue),
          ),
        ),
      );
      return;
    }
    final api = ClienteApi(
      urlBase: ConfigApi.urlBase,
      hostOverride: ConfigApi.hostOverride,
    );
    try {
      mensajero.showSnackBar(
        SnackBar(
          backgroundColor: PaletaNeon.fondoMedio,
          content: Text(
            textos.habSyncEnProgreso,
            style: const TextStyle(color: PaletaNeon.textoTenue),
          ),
        ),
      );
      final progreso =
          await widget.repositorio.exportarProgresoParaSync();
      final habilidades =
          await widget.repositorio.exportarHabilidadesParaSync();
      final resp = await api.sincronizar(
        token: token,
        progreso: progreso,
        habilidades: habilidades,
      );
      final devuelto = resp['progreso'] as Map<String, dynamic>?;
      final esquirlas = (devuelto?['esquirlas_total'] as num?)?.toInt();
      final flagsServidor = devuelto?['flags'] as Map? ?? const {};
      final habilidadesServidor =
          (resp['habilidades'] as List?)?.length ?? 0;

      if (!mounted) return;
      mensajero.hideCurrentSnackBar();
      mensajero.showSnackBar(
        SnackBar(
          backgroundColor: PaletaNeon.fondoMedio,
          duration: const Duration(seconds: 6),
          content: Text(
            textos.habSyncResumen(
              esquirlas ?? 0,
              flagsServidor.length,
              habilidadesServidor,
            ),
            style: const TextStyle(color: PaletaNeon.exitoSuave),
          ),
        ),
      );
    } on ExcepcionApi catch (e) {
      if (!mounted) return;
      mensajero.hideCurrentSnackBar();
      if (e.codigo == 401) {
        // Token caducado o inválido: borramos solo el token (mantenemos
        // el email para autocompletar) y mandamos al niño a iniciar
        // sesión otra vez.
        await widget.repositorio.borrarTokenBackend();
        if (!mounted) return;
        mensajero.showSnackBar(
          SnackBar(
            backgroundColor: PaletaNeon.fondoMedio,
            duration: const Duration(seconds: 5),
            content: Text(
              textos.habSyncSesionCaduco,
              style: const TextStyle(color: PaletaNeon.rosaAcento),
            ),
          ),
        );
      } else {
        mensajero.showSnackBar(
          SnackBar(
            backgroundColor: PaletaNeon.fondoMedio,
            duration: const Duration(seconds: 6),
            content: Text(
              textos.habApiError(e.codigo, e.mensaje),
              style: const TextStyle(color: PaletaNeon.rosaAcento),
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      mensajero.hideCurrentSnackBar();
      mensajero.showSnackBar(
        SnackBar(
          backgroundColor: PaletaNeon.fondoMedio,
          duration: const Duration(seconds: 6),
          content: Text(
            textos.habRedError(e.toString()),
            style: const TextStyle(color: PaletaNeon.rosaAcento),
          ),
        ),
      );
    } finally {
      api.cerrar();
    }
  }

  /// Atajo debug: abre PantallaTutor con FR.05 sin pasar por la
  /// oferta automática (que requiere 3 fallos consecutivos). Útil
  /// para probar el cableado app↔backend mientras no hay assets ni
  /// flujo de auth. Si no hay token guardado, llama primero a
  /// _probarSync para conseguir uno.
  Future<void> _probarTutor() async {
    final mensajero = ScaffoldMessenger.of(context);
    final textos = AppLocalizations.of(context);
    final token = await widget.repositorio.cargarTokenBackend();
    if (token == null || token.isEmpty) {
      mensajero.showSnackBar(
        SnackBar(
          backgroundColor: PaletaNeon.fondoMedio,
          content: Text(
            textos.habSyncFaltaToken,
            style: const TextStyle(color: PaletaNeon.rosaAcento),
          ),
        ),
      );
      return;
    }
    if (!mounted) return;
    final servicio = ServicioTutor(
      cache: CacheTutor(),
      cliente: ClienteTutor(
        urlBase: ConfigApi.urlBase,
        hostOverride: ConfigApi.hostOverride,
      ),
      repositorio: widget.repositorio,
      proveedorToken: () => token,
    );
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PantallaTutor(
          servicio: servicio,
          idHabilidad: 'FR.05',
          nombreHabilidad: 'Comparar fracciones · debug',
        ),
      ),
    );
  }

  Future<void> _confirmarYReiniciar() async {
    final textos = AppLocalizations.of(context);
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (contextoDialog) => AlertDialog(
        backgroundColor: PaletaNeon.fondoMedio,
        title: Text(
          textos.habReiniciarTitulo,
          style: const TextStyle(color: PaletaNeon.textoPrincipal),
        ),
        content: Text(
          textos.habReiniciarCuerpo,
          style: const TextStyle(color: PaletaNeon.textoTenue),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(contextoDialog).pop(false),
            child: Text(
              textos.comunCancelar,
              style: const TextStyle(
                color: PaletaNeon.textoTenue,
                letterSpacing: 2,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(contextoDialog).pop(true),
            child: Text(
              textos.habReiniciarBoton,
              style: const TextStyle(
                color: PaletaNeon.rosaAcento,
                letterSpacing: 2,
              ),
            ),
          ),
        ],
      ),
    );
    if (confirmar != true) return;
    await widget.repositorio.reiniciar();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: PaletaNeon.fondoMedio,
        content: Text(
          textos.habReiniciarHecho,
          style: const TextStyle(color: PaletaNeon.textoPrincipal),
        ),
        duration: const Duration(seconds: 5),
      ),
    );
  }

  Widget _listaPorDominio() {
    final catalogo = _catalogo!;
    final dominiosOrdenados = catalogo.dominios.entries.toList();
    // El encabezado va antes que los bloques por dominio.
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: dominiosOrdenados.length + 1,
      itemBuilder: (_, indice) {
        if (indice == 0) {
          return _CabeceraResumen(
            rango: _rangoActual,
            esquirlas: _esquirlasActuales,
            estados: _estados,
            totalHabilidades: catalogo.habilidades.length,
          );
        }
        final entrada = dominiosOrdenados[indice - 1];
        final habilidadesDelDominio = catalogo
            .habilidades.values
            .where((h) => h.dominio == entrada.key)
            .toList();
        return _BloqueDominio(
          codigo: entrada.key,
          nombre: entrada.value,
          habilidades: habilidadesDelDominio,
          estados: _estados,
        );
      },
    );
  }
}

/// Resumen de progreso global: rango narrativo, esquirlas y reparto
/// de habilidades por nivel de maestría. Se pinta en la cabecera de
/// la lista de habilidades.
class _CabeceraResumen extends StatelessWidget {
  final RangoNarrativo rango;
  final int esquirlas;
  final Map<String, EstadoHabilidad> estados;
  final int totalHabilidades;

  const _CabeceraResumen({
    required this.rango,
    required this.esquirlas,
    required this.estados,
    required this.totalHabilidades,
  });

  @override
  Widget build(BuildContext contexto) {
    final conteoPorNivel = <NivelMaestria, int>{
      for (final n in NivelMaestria.values) n: 0,
    };
    for (final estado in estados.values) {
      conteoPorNivel[estado.nivel] = (conteoPorNivel[estado.nivel] ?? 0) + 1;
    }
    // Las inexploradas no figuran en estados — se calculan por diferencia.
    final tocadas = estados.length;
    conteoPorNivel[NivelMaestria.inexplorada] = totalHabilidades - tocadas;

    return Container(
      margin: const EdgeInsets.only(bottom: 22),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: PaletaNeon.fondoMedio.withOpacity(0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: PaletaNeon.violetaBase.withOpacity(0.6),
          width: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                rango
                    .nombreLocalizado(AppLocalizations.of(contexto))
                    .toUpperCase(),
                style: const TextStyle(
                  color: PaletaNeon.azulNeon,
                  fontSize: 14,
                  letterSpacing: 3,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Text(
                AppLocalizations.of(contexto).habEsquirlasResumen(esquirlas),
                style: const TextStyle(
                  color: PaletaNeon.textoTenue,
                  fontSize: 12,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 14,
            runSpacing: 6,
            children: [
              for (final nivel in [
                NivelMaestria.maestria,
                NivelMaestria.competente,
                NivelMaestria.enDesarrollo,
                NivelMaestria.introducida,
                NivelMaestria.inexplorada,
              ])
                _ChipNivel(
                  nivel: nivel,
                  cantidad: conteoPorNivel[nivel] ?? 0,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ChipNivel extends StatelessWidget {
  final NivelMaestria nivel;
  final int cantidad;
  const _ChipNivel({required this.nivel, required this.cantidad});

  Color _colorPorNivel() {
    switch (nivel) {
      case NivelMaestria.inexplorada:
        return PaletaNeon.textoTenue.withOpacity(0.5);
      case NivelMaestria.introducida:
        return PaletaNeon.rosaAcento.withOpacity(0.7);
      case NivelMaestria.enDesarrollo:
        return const Color(0xFFFFA552);
      case NivelMaestria.competente:
        return PaletaNeon.azulNeon;
      case NivelMaestria.maestria:
        return PaletaNeon.exitoSuave;
    }
  }

  String _etiqueta(AppLocalizations textos) {
    switch (nivel) {
      case NivelMaestria.inexplorada:
        return textos.habNivelInexplorada;
      case NivelMaestria.introducida:
        return textos.habNivelIntroducida;
      case NivelMaestria.enDesarrollo:
        return textos.habNivelEnDesarrollo;
      case NivelMaestria.competente:
        return textos.habNivelCompetente;
      case NivelMaestria.maestria:
        return textos.habNivelMaestria;
    }
  }

  @override
  Widget build(BuildContext contexto) {
    final color = _colorPorNivel();
    final textos = AppLocalizations.of(contexto);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          textos.habChipNivel(cantidad, _etiqueta(textos)),
          style: const TextStyle(
            color: PaletaNeon.textoPrincipal,
            fontSize: 12,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}

class _BloqueDominio extends StatelessWidget {
  final String codigo;
  final String nombre;
  final List<Habilidad> habilidades;
  final Map<String, EstadoHabilidad> estados;

  const _BloqueDominio({
    required this.codigo,
    required this.nombre,
    required this.habilidades,
    required this.estados,
  });

  @override
  Widget build(BuildContext contexto) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              '$codigo · ${nombre.toUpperCase()}',
              style: const TextStyle(
                color: PaletaNeon.azulNeon,
                fontSize: 12,
                letterSpacing: 3,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          ...habilidades.map(
            (habilidad) => _FilaHabilidad(
              habilidad: habilidad,
              estado: estados[habilidad.identificador],
            ),
          ),
        ],
      ),
    );
  }
}

class _FilaHabilidad extends StatelessWidget {
  final Habilidad habilidad;
  final EstadoHabilidad? estado;

  const _FilaHabilidad({required this.habilidad, this.estado});

  Color _colorPorNivel(NivelMaestria nivel) {
    switch (nivel) {
      case NivelMaestria.inexplorada:
        return PaletaNeon.textoTenue.withOpacity(0.3);
      case NivelMaestria.introducida:
        return PaletaNeon.rosaAcento.withOpacity(0.7);
      case NivelMaestria.enDesarrollo:
        return const Color(0xFFFFA552);
      case NivelMaestria.competente:
        return PaletaNeon.azulNeon;
      case NivelMaestria.maestria:
        return PaletaNeon.exitoSuave;
    }
  }

  @override
  Widget build(BuildContext contexto) {
    final nivel = estado?.nivel ?? NivelMaestria.inexplorada;
    final precision = estado?.precision ?? 0;
    final exposiciones = estado?.totalExposiciones ?? 0;
    final color = _colorPorNivel(nivel);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 32,
            color: color,
            margin: const EdgeInsets.only(right: 10),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text(
                      habilidad.identificador,
                      style: const TextStyle(
                        color: PaletaNeon.textoTenue,
                        fontSize: 11,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        habilidad.nombre,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: PaletaNeon.textoPrincipal,
                          fontSize: 13,
                          height: 1.2,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  AppLocalizations.of(contexto).habFilaResumen(
                    nivel.nombreLocalizado(AppLocalizations.of(contexto)),
                    (precision * 100).round(),
                    exposiciones,
                  ),
                  style: TextStyle(
                    color: color,
                    fontSize: 11,
                    letterSpacing: 0.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
