import 'package:flutter/material.dart';
import 'package:nuevo_ser_companion/nuevo_ser_companion.dart' as companion;
import 'package:nuevo_ser_core/nuevo_ser_core.dart';

import '../../datos/almacenador_medios.dart';
import '../../datos/cliente_auth_cuaderno.dart';
import '../../datos/cola_sync_observaciones.dart';
import '../../datos/selector_imagen.dart';
import '../../datos/sincronizador_agregados.dart';
import '../../dominio/exportador_cuaderno.dart';
import '../../dominio/observacion.dart';
import '../../dominio/repositorio_local.dart';
import '../../nucleo/i18n/generado/textos_app.dart';
import '../pantalla_ajustes/pantalla_ajustes.dart';
import '../pantalla_observacion/pantalla_observacion.dart';
import '../pantalla_profesor/pantalla_login_profesor.dart';
import '../pantalla_tutor/pantalla_tutor.dart';
import '../tema/colores.dart';
import '../tema/tipografia.dart';
import 'estado_cuaderno.dart';
import 'seccion_ultima_pagina.dart';
import 'tarjeta_misterio.dart';
import 'tarjeta_sit_spot.dart';

/// Pantalla principal del juego. Bottom nav con cuatro pestañas; en
/// S1 solo Cuaderno y Tutor llevan a algo — Mapa y Misterios muestran
/// "próximamente" sin más fanfarria.
class PantallaCuaderno extends StatefulWidget {
  const PantallaCuaderno({
    super.key,
    required this.repositorio,
    required this.estado,
    this.repoIdioma,
    this.locale,
    this.alCambiarIdioma,
    this.enviarPreguntaTutor,
    this.repoCuenta,
    this.iniciarSesionAdulto,
    this.alCambiarToken,
    this.repoCuentaDebug,
    this.alCambiarTokenDebug,
    this.sincronizadorAgregados,
    this.alGuardarObservacion,
    this.intentarSincronizarObservaciones,
    this.selectorImagen,
    this.almacenadorMedios,
    this.resolverMedioParaExport,
    this.nombreParaTituloPdf,
    this.clienteAuthProfesor,
    this.clienteCompanionProfesor,
    this.repoCuentaProfesor,
    this.repoAulaProfesor,
  });

  final RepositorioLocal repositorio;
  final EstadoCuaderno estado;

  /// Inyectados por `main.dart`. Opcionales para que los tests de
  /// widget puedan instanciar la pantalla sin tocar `SharedPreferences`.
  /// Si llegan, el AppBar muestra el botón de Ajustes; si no, lo oculta.
  final RepositorioIdiomaApp? repoIdioma;
  final Locale? locale;
  final Future<void> Function()? alCambiarIdioma;

  /// Closure que la pantalla del Tutor consume al recibir una pregunta.
  /// `null` cuando no hay token guardado — la pantalla cae al canned
  /// response. La construcción de la closure (cliente HTTP + lectura
  /// de token) vive en `main.dart`.
  final EnviarPreguntaTutor? enviarPreguntaTutor;

  /// Repositorio de la cuenta del backend. Si llega no nulo, Ajustes
  /// muestra el bloque "Cuenta del adulto" para iniciar/cerrar sesión
  /// real contra `POST /login`. Tests que no tocan login pueden dejarlo
  /// null para instanciar la pantalla aislada.
  final RepositorioCuentaBackend? repoCuenta;

  /// Closure que invoca `ClienteAuthCuaderno.iniciarSesion`. Se inyecta
  /// como callback (en lugar de pasar el cliente entero) para que los
  /// tests puedan ejercitar el flujo con un stub.
  final Future<ResultadoLogin> Function({
    required String email,
    required String password,
  })? iniciarSesionAdulto;

  /// Notifica al orquestador (`main.dart`) que el token cambió tras
  /// iniciar/cerrar sesión, para que recompute la closure del Tutor.
  final VoidCallback? alCambiarToken;

  /// Inyectado solo en builds de debug. Se reenvía a `PantallaAjustes`
  /// para activar el bloque de pegado de JWT. En release siempre llega
  /// null.
  final RepositorioCuentaBackend? repoCuentaDebug;

  /// Callback debug: invocado desde el bloque de pegado de JWT de
  /// Ajustes tras guardar o borrar el token. `main.dart` lo cablea a
  /// un `setState` que refresca el `FutureBuilder` del Tutor.
  final VoidCallback? alCambiarTokenDebug;

  /// Sincronizador de agregados semanales con el companion. Se reenvía
  /// a `PantallaCuidador` para activar el botón "Compartir resumen con
  /// el adulto" — opt-in, lo dispara la persona adulta.
  final SincronizadorAgregadosCuaderno? sincronizadorAgregados;

  /// Cableado por el orquestador a `ColaSyncObservaciones.marcarPendiente`.
  /// Cada observación nueva queda apuntada para subir al backend cuando
  /// el adulto pulse "Sincronizar observaciones" en Ajustes (opt-in).
  /// Si es null, el cuaderno funciona sólo en local.
  final Future<void> Function(Observacion observacion)? alGuardarObservacion;

  /// Closure que el orquestador cablea a `ColaSyncObservaciones.intentarEnviar`
  /// con el `ClienteElCuaderno` ya construido. Si es null, el botón de
  /// sincronizar no aparece. Devuelve null si no hay token guardado.
  final Future<ResultadoSyncObservaciones?> Function()?
      intentarSincronizarObservaciones;

  /// Selector de imagen (cámara + galería) que `PantallaObservacion`
  /// usa para anclar una foto. Si es null, los botones de foto no
  /// aparecen — modo S1, builds de test que no quieren simular el
  /// flujo nativo.
  final SelectorImagen? selectorImagen;

  /// Almacenador que mueve la foto seleccionada al directorio privado
  /// de la app. Requerido si [selectorImagen] no es null.
  final AlmacenadorMedios? almacenadorMedios;

  /// Resuelve presencia y tamaño de cada fichero medio al exportar el
  /// cuaderno (export v2). Si es null, el export queda sin manifiesto
  /// — sigue siendo válido pero menos informativo.
  final ResolverMedioExportado? resolverMedioParaExport;

  /// Nombre del niño para encabezar el PDF exportado. Lo provee el
  /// orquestador desde el ValueNotifier global del perfil activo.
  final String? nombreParaTituloPdf;

  /// Conjunto de dependencias del modo profesor (B7 — fallback de
  /// experto pendiente de policy escolar). Se reenvían a Ajustes para
  /// que el bloque "Acceder como profesor" pueda construir las
  /// pantallas de login/dashboard. Si alguno es null, el bloque no se
  /// monta y los tests del cuaderno-niño pueden ignorarlo.
  final companion.ClienteAuthAdulto? clienteAuthProfesor;
  final companion.ClienteCompanion? clienteCompanionProfesor;
  final RepositorioCuentaBackend? repoCuentaProfesor;
  final RepositorioAulaProfesorContrato? repoAulaProfesor;

  @override
  State<PantallaCuaderno> createState() => _EstadoPantallaCuaderno();
}

class _EstadoPantallaCuaderno extends State<PantallaCuaderno> {
  int _indicePestana = 0;

  @override
  void initState() {
    super.initState();
    widget.estado.cargar();
  }

  @override
  Widget build(BuildContext context) {
    final esquema = Theme.of(context).colorScheme;
    final textos = TextosApp.of(context);

    final puedeAbrirAjustes = widget.repoIdioma != null &&
        widget.locale != null &&
        widget.alCambiarIdioma != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(textos.tituloApp),
        actions: [
          if (puedeAbrirAjustes)
            IconButton(
              icon: const Icon(Icons.settings_outlined),
              tooltip: textos.ajustesTitulo,
              onPressed: _abrirAjustes,
            ),
        ],
      ),
      body: SafeArea(
        child: IndexedStack(
          index: _indicePestana,
          children: [
            _VistaCuaderno(
              estado: widget.estado,
              alAbrirNuevaObservacion: _abrirNuevaObservacion,
            ),
            _VistaProximamente(textos: textos),
            _VistaProximamente(textos: textos),
            PantallaTutor(
              repositorio: widget.repositorio,
              enviarPregunta: widget.enviarPreguntaTutor,
            ),
          ],
        ),
      ),
      floatingActionButton: _indicePestana == 0
          ? FloatingActionButton(
              onPressed: _abrirNuevaObservacion,
              backgroundColor: esquema.primary,
              foregroundColor: esquema.onPrimary,
              child: const Icon(Icons.edit_outlined),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _indicePestana,
        onDestinationSelected: (indice) =>
            setState(() => _indicePestana = indice),
        backgroundColor: esquema.surface,
        indicatorColor: esquema.surfaceContainerHighest,
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.menu_book_outlined),
            selectedIcon: const Icon(Icons.menu_book),
            label: textos.navCuaderno,
          ),
          NavigationDestination(
            icon: const Icon(Icons.map_outlined),
            selectedIcon: const Icon(Icons.map),
            label: textos.navMapa,
          ),
          NavigationDestination(
            icon: const Icon(Icons.help_outline),
            selectedIcon: const Icon(Icons.help),
            label: textos.navMisterios,
          ),
          NavigationDestination(
            icon: const Icon(Icons.chat_outlined),
            selectedIcon: const Icon(Icons.chat),
            label: textos.navTutor,
          ),
        ],
      ),
    );
  }

  Future<void> _abrirNuevaObservacion() async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => PantallaObservacion(
          repositorio: widget.repositorio,
          misteriosAbiertos: widget.estado.misteriosAbiertos,
          sitSpotActivo: widget.estado.sitSpot,
          alGuardarObservacion: widget.alGuardarObservacion,
          selectorImagen: widget.selectorImagen,
          almacenadorMedios: widget.almacenadorMedios,
        ),
      ),
    );
    if (mounted) {
      await widget.estado.cargar();
    }
  }

  Future<void> _abrirAjustes() async {
    final repoIdioma = widget.repoIdioma!;
    final locale = widget.locale!;
    final alCambiarIdioma = widget.alCambiarIdioma!;
    await Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => PantallaAjustes(
          repositorio: widget.repositorio,
          repoIdioma: repoIdioma,
          locale: locale,
          alCambiarIdioma: alCambiarIdioma,
          repoCuenta: widget.repoCuenta,
          iniciarSesionAdulto: widget.iniciarSesionAdulto,
          alCambiarToken: widget.alCambiarToken,
          repoCuentaDebug: widget.repoCuentaDebug,
          alCambiarTokenDebug: widget.alCambiarTokenDebug,
          sincronizadorAgregados: widget.sincronizadorAgregados,
          intentarSincronizarObservaciones:
              widget.intentarSincronizarObservaciones,
          resolverMedioParaExport: widget.resolverMedioParaExport,
          nombreParaTituloPdf: widget.nombreParaTituloPdf,
          clienteAuthProfesor: widget.clienteAuthProfesor,
          clienteCompanionProfesor: widget.clienteCompanionProfesor,
          repoCuentaProfesor: widget.repoCuentaProfesor,
          repoAulaProfesor: widget.repoAulaProfesor,
        ),
      ),
    );
    if (mounted) {
      // Tras el borrado el estado puede haber cambiado.
      await widget.estado.cargar();
    }
  }
}

/// Vista del cuaderno propiamente dicha — la primera pestaña. Scroll
/// vertical con cabecera + saludo + sit spot + Misterios + última
/// página, conforme al mockup descrito en biblia §5.4.
class _VistaCuaderno extends StatelessWidget {
  const _VistaCuaderno({
    required this.estado,
    required this.alAbrirNuevaObservacion,
  });

  final EstadoCuaderno estado;
  final VoidCallback alAbrirNuevaObservacion;

  @override
  Widget build(BuildContext context) {
    final textos = TextosApp.of(context);
    final esquema = Theme.of(context).colorScheme;

    return ListenableBuilder(
      listenable: estado,
      builder: (context, _) {
        if (estado.cargando && estado.sitSpot == null) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }

        final misteriosAMostrar =
            estado.misteriosAbiertos.take(3).toList(growable: false);

        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
          children: [
            Text(
              textos.saludoSinNombre,
              style: TipografiaCuaderno.serif(
                color: esquema.onSurface,
                tamano: TipografiaCuaderno.tamano17,
                peso: TipografiaCuaderno.pesoMedio,
              ),
            ),
            const SizedBox(height: 24),
            _Cabecera(textos.seccionSitSpot),
            const SizedBox(height: 8),
            TarjetaSitSpot(sitSpot: estado.sitSpot),
            const SizedBox(height: 24),
            _Cabecera(textos.seccionMisteriosAbiertos),
            const SizedBox(height: 8),
            if (misteriosAMostrar.isEmpty)
              Text(
                textos.misteriosVacio,
                style: TipografiaCuaderno.serif(
                  color: PaletaCuaderno.tintaTenue,
                  tamano: TipografiaCuaderno.tamano13,
                  altoLinea: 1.45,
                ),
              )
            else
              for (final misterio in misteriosAMostrar) ...[
                TarjetaMisterio(misterio: misterio),
                const SizedBox(height: 8),
              ],
            const SizedBox(height: 16),
            _Cabecera(textos.seccionUltimaPagina),
            const SizedBox(height: 8),
            SeccionUltimaPagina(observacion: estado.ultimaObservacion),
          ],
        );
      },
    );
  }
}

class _VistaProximamente extends StatelessWidget {
  const _VistaProximamente({required this.textos});

  final TextosApp textos;

  @override
  Widget build(BuildContext context) {
    final esquema = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Text(
          textos.navProximamente,
          textAlign: TextAlign.center,
          style: TipografiaCuaderno.serif(
            color: esquema.tertiary,
            tamano: TipografiaCuaderno.tamano14,
          ),
        ),
      ),
    );
  }
}

class _Cabecera extends StatelessWidget {
  const _Cabecera(this.texto);

  final String texto;

  @override
  Widget build(BuildContext context) {
    final esquema = Theme.of(context).colorScheme;
    return Text(
      texto,
      style: TipografiaCuaderno.sans(
        color: esquema.tertiary,
        tamano: TipografiaCuaderno.tamano12,
        peso: TipografiaCuaderno.pesoMedio,
      ),
    );
  }
}
