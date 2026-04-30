import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nuevo_ser_companion/nuevo_ser_companion.dart' as companion;
import 'package:nuevo_ser_core/nuevo_ser_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:io';

import 'datos/almacenador_medios.dart';
import 'datos/cliente_auth_cuaderno.dart';
import 'datos/cliente_el_cuaderno.dart';
import 'datos/cliente_tutor_cuaderno.dart';
import 'datos/cola_sync_observaciones.dart';
import 'datos/repositorio_aula_profesor.dart';
import 'datos/repositorio_perfil_cuaderno.dart';
import 'datos/selector_imagen.dart';
import 'datos/servicio_geolocalizacion_plugin.dart';
import 'datos/sincronizador_agregados.dart';
import 'dominio/geolocalizacion_privacy_first.dart';
import 'datos_simulados/seed.dart';
import 'dominio/exportador_cuaderno.dart';
import 'dominio/observacion.dart';
import 'dominio/repositorio_local.dart';
import 'infraestructura/isar/isar_setup.dart';
import 'infraestructura/isar/repositorio_isar.dart';
import 'nucleo/i18n/generado/textos_app.dart';
import 'vista/pantalla_bienvenida_nombre.dart';
import 'vista/pantalla_configuracion_inicial.dart';
import 'vista/pantalla_cuaderno/estado_cuaderno.dart';
import 'vista/pantalla_cuaderno/pantalla_cuaderno.dart';
import 'vista/pantalla_tutor/pantalla_tutor.dart';
import 'vista/tema/tema.dart';

/// Clave global del idioma elegido por el niño en el primer arranque.
/// Sigue el namespace `nuevoser.<juego>.*` que el CLAUDE.md raíz
/// prescribe para juegos nuevos.
const _claveIdiomaApp = 'nuevoser.elcuaderno.idioma_app';

/// Claves globales del backend. El token JWT no es por-perfil: el
/// servidor codifica el `nino_id` dentro del propio token (ver
/// `RepositorioCuentaBackend`). Si en el futuro se cambia de niño en
/// el dispositivo, el token se reescribe.
const _claveTokenBackend = 'nuevoser.elcuaderno.token_backend';
const _claveEmailBackend = 'nuevoser.elcuaderno.email_backend';

/// Claves del modo profesor (B7 — fallback de experto pendiente de
/// policy escolar). Pareja paralela a las del adulto-cuidador, pero
/// con sufijo `_profesor` para que coexistan sin pisarse — si el
/// dispositivo lo usa la misma persona como adulto-cuidador y como
/// profesor, los dos tokens viven juntos.
const _claveTokenProfesor = 'nuevoser.elcuaderno.token_profesor';
const _claveEmailProfesor = 'nuevoser.elcuaderno.email_profesor';

/// Clave del aula activa del profesor — `int` con el `classroom_id`
/// que el profesor ha seleccionado por última vez. Persiste para que
/// al volver a la app caiga directamente al dashboard sin tener que
/// re-seleccionar.
const _claveAulaActivaProfesor = 'nuevoser.elcuaderno.profesor.aula_activa';

/// URL base del backend `nuevo-ser-core`. Provisional — la decisión
/// del dominio definitivo es humana (memoria
/// `project_el_cuaderno_decisiones_humanas_pendientes`). Cuando llegue
/// el dominio real, se sustituye sin tocar el cliente.
const _urlBaseBackend = 'https://nuevoser.example.org';

/// Locale activo de la app. Es global para que `AppElCuaderno` pueda
/// reaccionar al cambio sin tener que reconstruir todo el árbol
/// manualmente.
final ValueNotifier<Locale?> localeAppElCuaderno = ValueNotifier<Locale?>(null);

/// Nombre del niño dueño del cuaderno. Null hasta que se complete la
/// pantalla de bienvenida tras el primer arranque. Una vez completada,
/// el orquestador muestra `PantallaCuaderno`.
final ValueNotifier<String?> nombrePerfilElCuaderno = ValueNotifier<String?>(null);

/// Arranque de El Cuaderno. Sprint 2-C: precarga el idioma elegido,
/// abre Isar local, siembra datos en debug, y monta la app pasando
/// por la configuración inicial si es el primer arranque.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1) Idioma persistido. Si lo hay, se aplica al ValueNotifier antes
  //    del primer build de MaterialApp para evitar un flash con el
  //    locale del sistema. Si no lo hay, el orquestador abrirá la
  //    pantalla de configuración inicial.
  final repoIdioma = RepositorioIdiomaApp(
    prefs: SharedPreferences.getInstance,
    clave: _claveIdiomaApp,
  );
  final codigoIdiomaPersistido = await repoIdioma.cargar();
  if (codigoIdiomaPersistido != null) {
    localeAppElCuaderno.value = Locale(codigoIdiomaPersistido);
  }

  // 2) Isar local — el cuaderno mismo (observaciones, sit spots,
  //    misterios, fotos, dibujos). Se abre antes del primer build
  //    porque la pantalla principal lo necesita listo.
  final setup = IsarSetup();
  final isar = await setup.abrir();
  final repositorioCuaderno = RepositorioIsar(isar);

  if (kDebugMode) {
    await sembrarDatosDesarrollo(repositorioCuaderno);
  }

  // 3) Repositorio de la cuenta del backend (token JWT + email del
  //    niño). Compartido por todas las llamadas REST que requieran
  //    autenticación: Tutor, sync de observaciones, sit-spot, …
  final repoCuenta = RepositorioCuentaBackend(
    prefs: SharedPreferences.getInstance,
    claveToken: _claveTokenBackend,
    claveEmail: _claveEmailBackend,
  );

  // 3.b) Repositorios del modo profesor (B7). Tokens y aula activa
  //      paralelos a los del niño, namespace `_profesor` para que
  //      coexistan en el mismo dispositivo si la misma persona los
  //      usa para los dos roles (poco probable, no imposible).
  final repoCuentaProfesor = RepositorioCuentaBackend(
    prefs: SharedPreferences.getInstance,
    claveToken: _claveTokenProfesor,
    claveEmail: _claveEmailProfesor,
  );
  final repoAulaProfesor = RepositorioAulaProfesor(
    prefs: SharedPreferences.getInstance,
    clave: _claveAulaActivaProfesor,
  );

  // 4) Repositorio de perfiles del Cuaderno. El nombre del niño se
  //    persiste como nombre del perfil activo. Si ya existe, se
  //    precarga al ValueNotifier para que el primer build muestre
  //    directo la pantalla principal sin flash de la bienvenida.
  final repoPerfil = RepositorioPerfilCuaderno();
  final nombreYaGuardado = await repoPerfil.nombrePerfilActivo();
  if (nombreYaGuardado != null) {
    nombrePerfilElCuaderno.value = nombreYaGuardado;
  }

  runApp(AppElCuaderno(
    repoIdioma: repoIdioma,
    repositorioCuaderno: repositorioCuaderno,
    repoCuenta: repoCuenta,
    repoPerfil: repoPerfil,
    repoCuentaProfesor: repoCuentaProfesor,
    repoAulaProfesor: repoAulaProfesor,
  ));
}

class AppElCuaderno extends StatelessWidget {
  final RepositorioIdiomaApp repoIdioma;
  final RepositorioLocal repositorioCuaderno;
  final RepositorioCuentaBackend repoCuenta;
  final RepositorioPerfilCuaderno repoPerfil;
  final RepositorioCuentaBackend repoCuentaProfesor;
  final RepositorioAulaProfesor repoAulaProfesor;

  const AppElCuaderno({
    super.key,
    required this.repoIdioma,
    required this.repositorioCuaderno,
    required this.repoCuenta,
    required this.repoPerfil,
    required this.repoCuentaProfesor,
    required this.repoAulaProfesor,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale?>(
      valueListenable: localeAppElCuaderno,
      builder: (_, locale, __) {
        return ValueListenableBuilder<String?>(
          valueListenable: nombrePerfilElCuaderno,
          builder: (_, nombrePerfil, __) {
            return MaterialApp(
              onGenerateTitle: (context) => TextosApp.of(context).tituloApp,
              theme: TemaCuaderno.claro(),
              darkTheme: TemaCuaderno.oscuro(),
              // Modo oscuro respetado del sistema (doc 13 §11.5).
              themeMode: ThemeMode.system,
              locale: locale,
              localizationsDelegates: TextosApp.localizationsDelegates,
              supportedLocales: TextosApp.supportedLocales,
              home: _decidirHome(locale, nombrePerfil),
            );
          },
        );
      },
    );
  }

  /// Tres caminos de arranque:
  /// - sin idioma → selector trilingüe.
  /// - con idioma sin perfil con nombre → pantalla bienvenida.
  /// - con perfil → pantalla principal.
  Widget _decidirHome(Locale? locale, String? nombrePerfil) {
    if (locale == null) {
      return PantallaConfiguracionInicial(
        alElegirIdioma: (codigo) async {
          await repoIdioma.guardar(codigo);
          localeAppElCuaderno.value = Locale(codigo);
        },
      );
    }
    if (nombrePerfil == null) {
      return PantallaBienvenidaNombre(
        alConfirmarNombre: (nombre) async {
          await repoPerfil.crearYActivarPerfil(nombre);
          nombrePerfilElCuaderno.value = nombre;
        },
      );
    }
    return _OrquestadorJuego(
      repositorio: repositorioCuaderno,
      repoIdioma: repoIdioma,
      repoCuenta: repoCuenta,
      repoCuentaProfesor: repoCuentaProfesor,
      repoAulaProfesor: repoAulaProfesor,
      locale: locale,
      alCambiarIdioma: () async {
        await repoIdioma.borrar();
        localeAppElCuaderno.value = null;
      },
    );
  }
}

class _OrquestadorJuego extends StatefulWidget {
  final RepositorioLocal repositorio;
  final RepositorioIdiomaApp repoIdioma;
  final RepositorioCuentaBackend repoCuenta;
  final RepositorioCuentaBackend repoCuentaProfesor;
  final RepositorioAulaProfesor repoAulaProfesor;
  final Locale locale;
  final Future<void> Function() alCambiarIdioma;

  const _OrquestadorJuego({
    required this.repositorio,
    required this.repoIdioma,
    required this.repoCuenta,
    required this.repoCuentaProfesor,
    required this.repoAulaProfesor,
    required this.locale,
    required this.alCambiarIdioma,
  });

  @override
  State<_OrquestadorJuego> createState() => _EstadoOrquestadorJuego();
}

class _EstadoOrquestadorJuego extends State<_OrquestadorJuego> {
  late final EstadoCuaderno _estado;
  late final ClienteTutorCuaderno _clienteTutor;
  late final ClienteElCuaderno _clienteCuaderno;
  late final ClienteAuthCuaderno _clienteAuth;
  late final ColaSyncObservaciones _colaSyncObservaciones;
  late final companion.ClienteCompanion _clienteCompanion;
  late final companion.ClienteAuthAdulto _clienteAuthProfesor;
  late final SincronizadorAgregadosCuaderno _sincronizadorAgregados;
  late final SelectorImagen _selectorImagen;
  late final AlmacenadorMedios _almacenadorMedios;
  // Cableado para inyección futura. Las pantallas todavía no lo
  // consumen — el copy de pre-permiso del niño es decisión humana
  // pendiente (B5 del plan + voz adulta amable doc 04). Cuando
  // llegue la asesoría del adulto, este servicio se inyecta a
  // pantalla_observacion para que el niño pueda anclar coordenadas
  // (que NO cruzan red) a la observación.
  // ignore: unused_field
  late final ServicioGeolocalizacion _servicioGeolocalizacion;
  late Future<EnviarPreguntaTutor?> _futureEnviarPregunta;

  @override
  void initState() {
    super.initState();
    _estado = EstadoCuaderno(repositorio: widget.repositorio);
    _clienteTutor = ClienteTutorCuaderno(
      urlBase: _urlBaseBackend,
      obtenerToken: widget.repoCuenta.cargarToken,
    );
    _clienteCuaderno = ClienteElCuaderno(
      urlBase: _urlBaseBackend,
      obtenerToken: widget.repoCuenta.cargarToken,
    );
    _clienteAuth = ClienteAuthCuaderno(urlBase: _urlBaseBackend);
    _colaSyncObservaciones = ColaSyncObservaciones(
      prefs: SharedPreferences.getInstance,
    );
    _clienteCompanion = companion.ClienteCompanion(urlBase: _urlBaseBackend);
    _clienteAuthProfesor =
        companion.ClienteAuthAdulto(urlBase: _urlBaseBackend);
    _sincronizadorAgregados = SincronizadorAgregadosCuaderno(
      repositorio: widget.repositorio,
      repoCuenta: widget.repoCuenta,
      clienteCompanion: _clienteCompanion,
    );
    _selectorImagen = SelectorImagenImagePicker();
    _almacenadorMedios = AlmacenadorMedios();
    _servicioGeolocalizacion = ServicioGeolocalizacionPlugin();
    _futureEnviarPregunta = _resolverEnviarPregunta();
  }

  @override
  void dispose() {
    _estado.dispose();
    _clienteTutor.cerrar();
    _clienteCuaderno.cerrar();
    _clienteAuth.cerrar();
    _clienteCompanion.cerrar();
    _clienteAuthProfesor.cerrar();
    super.dispose();
  }

  /// Closure que la pantalla del Tutor invoca con la pregunta del
  /// niño. Lee el token cada vez (puede haber cambiado entre
  /// llamadas); si no hay, devuelve null para que la pantalla caiga al
  /// canned response. Si hay, llama al cliente real y devuelve el
  /// `respuesta` ya filtrado server-side.
  ///
  /// Las excepciones tipadas (`CuotaTutorAgotada`, `ExcepcionApi`) las
  /// propaga sin envolverlas — la pantalla decide cómo presentarlas.
  Future<String> _enviarPreguntaTutor(String pregunta) async {
    final r = await _clienteTutor.preguntar(pregunta: pregunta);
    return r.respuesta;
  }

  Future<EnviarPreguntaTutor?> _resolverEnviarPregunta() async {
    final token = await widget.repoCuenta.cargarToken();
    if (token == null || token.isEmpty) return null;
    return _enviarPreguntaTutor;
  }

  /// Invocado desde el bloque debug de Ajustes tras guardar o borrar el
  /// token. Recompone el `Future` para que el `FutureBuilder` reevalúe
  /// la presencia de token y la pantalla del Tutor cambie de canal sin
  /// reiniciar la app.
  void _refrescarTokenTutor() {
    setState(() {
      _futureEnviarPregunta = _resolverEnviarPregunta();
    });
  }

  /// Llamado por la pantalla de nueva observación cuando el niño guarda.
  /// Apunta el UUID en la cola para que el adulto pueda subirlas más
  /// tarde desde Ajustes (opt-in). No hace red — sólo persistencia
  /// clave-valor local.
  Future<void> _alGuardarObservacion(Observacion observacion) async {
    await _colaSyncObservaciones.marcarPendiente(observacion.id);
  }

  /// Llamado por el bloque "Sincronizar mis observaciones" de Ajustes.
  /// Devuelve null si no hay token (la UI muestra el aviso de cuenta no
  /// vinculada). Si hay token, llama a la cola con el cliente real y
  /// devuelve el resumen del intento.
  Future<ResultadoSyncObservaciones?> _intentarSincronizarObservaciones() async {
    final token = await widget.repoCuenta.cargarToken();
    if (token == null || token.isEmpty) return null;
    return _colaSyncObservaciones.intentarEnviar(
      repositorio: widget.repositorio,
      cliente: _clienteCuaderno,
      regionCode: 'ES',
    );
  }

  /// Resuelve, para una ruta relativa apuntada por una observación, el
  /// estado del fichero medio en disco — alimenta el manifiesto del
  /// export v2 (A5). Uso del `_almacenadorMedios.resolverAbsoluta` +
  /// `dart:io` directo para sondear `existe` y `length` sin añadir
  /// dependencias nuevas.
  Future<InfoMedioExportado> _resolverMedioParaExport(
    String rutaRelativa,
  ) async {
    final rutaAbsoluta =
        await _almacenadorMedios.resolverAbsoluta(rutaRelativa);
    final fichero = File(rutaAbsoluta);
    if (!await fichero.exists()) {
      return InfoMedioExportado(rutaRelativa: rutaRelativa, existe: false);
    }
    final tamano = await fichero.length();
    return InfoMedioExportado(
      rutaRelativa: rutaRelativa,
      existe: true,
      tamanoBytes: tamano,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<EnviarPreguntaTutor?>(
      future: _futureEnviarPregunta,
      builder: (context, snapshot) {
        return PantallaCuaderno(
          repositorio: widget.repositorio,
          estado: _estado,
          repoIdioma: widget.repoIdioma,
          locale: widget.locale,
          alCambiarIdioma: widget.alCambiarIdioma,
          enviarPreguntaTutor: snapshot.data,
          repoCuenta: widget.repoCuenta,
          iniciarSesionAdulto: _clienteAuth.iniciarSesion,
          alCambiarToken: _refrescarTokenTutor,
          repoCuentaDebug: kDebugMode ? widget.repoCuenta : null,
          alCambiarTokenDebug: kDebugMode ? _refrescarTokenTutor : null,
          sincronizadorAgregados: _sincronizadorAgregados,
          alGuardarObservacion: _alGuardarObservacion,
          intentarSincronizarObservaciones: _intentarSincronizarObservaciones,
          selectorImagen: _selectorImagen,
          almacenadorMedios: _almacenadorMedios,
          resolverMedioParaExport: _resolverMedioParaExport,
          nombreParaTituloPdf: nombrePerfilElCuaderno.value,
          clienteAuthProfesor: _clienteAuthProfesor,
          clienteCompanionProfesor: _clienteCompanion,
          repoCuentaProfesor: widget.repoCuentaProfesor,
          repoAulaProfesor: widget.repoAulaProfesor,
        );
      },
    );
  }
}
