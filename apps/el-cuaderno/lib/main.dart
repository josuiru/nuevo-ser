import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nuevo_ser_companion/nuevo_ser_companion.dart' as companion;
import 'package:nuevo_ser_core/nuevo_ser_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'datos/cliente_tutor_cuaderno.dart';
import 'datos/sincronizador_agregados.dart';
import 'datos_simulados/seed.dart';
import 'dominio/repositorio_local.dart';
import 'infraestructura/isar/isar_setup.dart';
import 'infraestructura/isar/repositorio_isar.dart';
import 'nucleo/i18n/generado/textos_app.dart';
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

/// URL base del backend `nuevo-ser-core`. Provisional — la decisión
/// del dominio definitivo es humana (memoria
/// `project_el_cuaderno_decisiones_humanas_pendientes`). Cuando llegue
/// el dominio real, se sustituye sin tocar el cliente.
const _urlBaseBackend = 'https://nuevoser.example.org';

/// Locale activo de la app. Es global para que `AppElCuaderno` pueda
/// reaccionar al cambio sin tener que reconstruir todo el árbol
/// manualmente.
final ValueNotifier<Locale?> localeAppElCuaderno = ValueNotifier<Locale?>(null);

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

  runApp(AppElCuaderno(
    repoIdioma: repoIdioma,
    repositorioCuaderno: repositorioCuaderno,
    repoCuenta: repoCuenta,
  ));
}

class AppElCuaderno extends StatelessWidget {
  final RepositorioIdiomaApp repoIdioma;
  final RepositorioLocal repositorioCuaderno;
  final RepositorioCuentaBackend repoCuenta;

  const AppElCuaderno({
    super.key,
    required this.repoIdioma,
    required this.repositorioCuaderno,
    required this.repoCuenta,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale?>(
      valueListenable: localeAppElCuaderno,
      builder: (_, locale, __) {
        return MaterialApp(
          onGenerateTitle: (context) => TextosApp.of(context).tituloApp,
          theme: TemaCuaderno.claro(),
          darkTheme: TemaCuaderno.oscuro(),
          // Modo oscuro respetado del sistema (doc 13 §11.5).
          themeMode: ThemeMode.system,
          locale: locale,
          localizationsDelegates: TextosApp.localizationsDelegates,
          supportedLocales: TextosApp.supportedLocales,
          home: locale == null
              ? PantallaConfiguracionInicial(
                  alElegirIdioma: (codigo) async {
                    await repoIdioma.guardar(codigo);
                    localeAppElCuaderno.value = Locale(codigo);
                  },
                )
              : _OrquestadorJuego(
                  repositorio: repositorioCuaderno,
                  repoIdioma: repoIdioma,
                  repoCuenta: repoCuenta,
                  locale: locale,
                  alCambiarIdioma: () async {
                    await repoIdioma.borrar();
                    localeAppElCuaderno.value = null;
                  },
                ),
        );
      },
    );
  }
}

class _OrquestadorJuego extends StatefulWidget {
  final RepositorioLocal repositorio;
  final RepositorioIdiomaApp repoIdioma;
  final RepositorioCuentaBackend repoCuenta;
  final Locale locale;
  final Future<void> Function() alCambiarIdioma;

  const _OrquestadorJuego({
    required this.repositorio,
    required this.repoIdioma,
    required this.repoCuenta,
    required this.locale,
    required this.alCambiarIdioma,
  });

  @override
  State<_OrquestadorJuego> createState() => _EstadoOrquestadorJuego();
}

class _EstadoOrquestadorJuego extends State<_OrquestadorJuego> {
  late final EstadoCuaderno _estado;
  late final ClienteTutorCuaderno _clienteTutor;
  late final companion.ClienteCompanion _clienteCompanion;
  late final SincronizadorAgregadosCuaderno _sincronizadorAgregados;
  late Future<EnviarPreguntaTutor?> _futureEnviarPregunta;

  @override
  void initState() {
    super.initState();
    _estado = EstadoCuaderno(repositorio: widget.repositorio);
    _clienteTutor = ClienteTutorCuaderno(
      urlBase: _urlBaseBackend,
      obtenerToken: widget.repoCuenta.cargarToken,
    );
    _clienteCompanion = companion.ClienteCompanion(urlBase: _urlBaseBackend);
    _sincronizadorAgregados = SincronizadorAgregadosCuaderno(
      repositorio: widget.repositorio,
      repoCuenta: widget.repoCuenta,
      clienteCompanion: _clienteCompanion,
    );
    _futureEnviarPregunta = _resolverEnviarPregunta();
  }

  @override
  void dispose() {
    _estado.dispose();
    _clienteTutor.cerrar();
    _clienteCompanion.cerrar();
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
          repoCuentaDebug: kDebugMode ? widget.repoCuenta : null,
          alCambiarTokenDebug: kDebugMode ? _refrescarTokenTutor : null,
          sincronizadorAgregados: _sincronizadorAgregados,
        );
      },
    );
  }
}
