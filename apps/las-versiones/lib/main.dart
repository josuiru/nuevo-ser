import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:nuevo_ser_core/nuevo_ser_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'datos/repositorio_cuaderno.dart';
import 'datos/repositorio_estado_brecha.dart';
import 'datos/repositorio_flags_narrativos.dart';
import 'dominio/brecha.dart';
import 'dominio/catalogo_brechas.dart';
import 'dominio/cuaderno.dart';
import 'dominio/escenas_arco_1.dart';
import 'nucleo/paleta_archivo.dart';
import 'vista/pantalla_brecha.dart';
import 'vista/pantalla_cinematica.dart';
import 'vista/pantalla_configuracion_inicial.dart';
import 'vista/pantalla_cuaderno.dart';
import 'vista/pantalla_esqueleto.dart';

/// Clave global del idioma elegido por la Cronista en el primer
/// arranque. Sigue el namespace `nuevoser.<juego>.*` que el CLAUDE.md
/// raíz prescribe para juegos nuevos de la Colección. La cuenta del
/// backend, la versión de paquete sonoro, etc. seguirán el mismo
/// patrón cuando lleguen.
const _claveIdiomaApp = 'nuevoser.lasversiones.idioma_app';

/// Locale activo de la app. Es global para que `AppLasVersiones`
/// pueda quedarse `StatelessWidget` y a la vez reaccionar al cambio
/// de idioma sin tener que reconstruir todo el árbol manualmente.
final ValueNotifier<Locale?> localeAppLasVersiones =
    ValueNotifier<Locale?>(null);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));

  // Precarga del idioma elegido en sesiones previas. Si lo hay se
  // aplica al ValueNotifier ANTES del primer build de MaterialApp
  // para evitar un flash con el idioma del sistema. Si no lo hay
  // (primer arranque), el orquestador abrirá la configuración inicial.
  final repoIdioma = RepositorioIdiomaApp(
    prefs: SharedPreferences.getInstance,
    clave: _claveIdiomaApp,
  );
  final codigoIdiomaPersistido = await repoIdioma.cargar();
  if (codigoIdiomaPersistido != null) {
    localeAppLasVersiones.value = Locale(codigoIdiomaPersistido);
  }

  runApp(AppLasVersiones(
    repoIdioma: repoIdioma,
    repoFlags: const RepositorioFlagsNarrativos(),
    repoEstadoBrecha: const RepositorioEstadoBrecha(),
    repoCuaderno: const RepositorioCuaderno(),
  ));
}

class AppLasVersiones extends StatelessWidget {
  final RepositorioIdiomaApp repoIdioma;
  final RepositorioFlagsNarrativos repoFlags;
  final RepositorioEstadoBrecha repoEstadoBrecha;
  final RepositorioCuaderno repoCuaderno;

  const AppLasVersiones({
    super.key,
    required this.repoIdioma,
    required this.repoFlags,
    required this.repoEstadoBrecha,
    required this.repoCuaderno,
  });

  @override
  Widget build(BuildContext contexto) {
    return ValueListenableBuilder<Locale?>(
      valueListenable: localeAppLasVersiones,
      builder: (ctx, localeActivo, _) {
        return MaterialApp(
          title: 'Las Versiones',
          theme: _temaArchivo(),
          debugShowCheckedModeBanner: false,
          locale: localeActivo,
          // Hasta que arranque la generación gen-l10n no hay delegate
          // de strings — la pantalla esqueleto y la de configuración
          // inicial llevan sus textos hardcoded en los tres idiomas.
          // Pero sí declaramos los locales soportados para que Flutter
          // formatee fechas/números si algún componente los necesita.
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('es'),
            Locale('eu'),
            Locale('ca'),
          ],
          localeResolutionCallback: (localeDispositivo, soportados) {
            if (localeDispositivo != null) {
              for (final soportado in soportados) {
                if (soportado.languageCode == localeDispositivo.languageCode) {
                  return soportado;
                }
              }
            }
            return const Locale('es');
          },
          home: Orquestador(
            repoIdioma: repoIdioma,
            repoFlags: repoFlags,
            repoEstadoBrecha: repoEstadoBrecha,
            repoCuaderno: repoCuaderno,
          ),
        );
      },
    );
  }
}

ThemeData _temaArchivo() {
  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: PaletaArchivo.ambarLacre,
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: PaletaArchivo.fondoProfundo,
  );
}

/// Orquestador del juego. Cuatro estados posibles, en orden:
///
/// 1. **Configuración inicial** si la Cronista nunca eligió idioma.
/// 2. **Brecha** si una Brecha está abierta (su flag de disparo
///    activo y su flag de completado aún no). Las cinemáticas
///    pendientes que apunten al cierre de la Brecha (caso típico:
///    1.1.7 después de cerrar 1.1) esperan a que la Brecha termine.
/// 3. **Cinemática** si hay una escena pendiente cuyos
///    `flagsRequeridos` están todos activos y cuyo `flagDeSalida`
///    aún no lo está.
/// 4. **Esqueleto** si todas las unidades narrativas implementadas
///    están vistas.
class Orquestador extends StatefulWidget {
  final RepositorioIdiomaApp repoIdioma;
  final RepositorioFlagsNarrativos repoFlags;
  final RepositorioEstadoBrecha repoEstadoBrecha;
  final RepositorioCuaderno repoCuaderno;

  const Orquestador({
    super.key,
    required this.repoIdioma,
    required this.repoFlags,
    required this.repoEstadoBrecha,
    required this.repoCuaderno,
  });

  @override
  State<Orquestador> createState() => _OrquestadorState();
}

class _OrquestadorState extends State<Orquestador> {
  bool _cargando = true;
  bool _idiomaElegido = false;
  Set<String> _flagsActivos = const {};
  EscenaCinematica? _escenaEnReproduccion;
  Brecha? _brechaAbierta;
  FaseBrecha _faseBrechaActiva = FaseBrecha.formulacionPreguntas;

  @override
  void initState() {
    super.initState();
    _cargarEstadoInicial();
  }

  Future<void> _cargarEstadoInicial() async {
    final codigo = await widget.repoIdioma.cargar();
    final flags = await widget.repoFlags.activos();
    if (!mounted) return;
    _flagsActivos = flags;
    _idiomaElegido = codigo != null;
    final brecha = _proximaBrechaPendiente();
    FaseBrecha faseInicial = FaseBrecha.formulacionPreguntas;
    if (brecha != null) {
      faseInicial = await widget.repoEstadoBrecha.faseActiva(brecha.id) ??
          FaseBrecha.formulacionPreguntas;
    }
    if (!mounted) return;
    setState(() {
      _brechaAbierta = brecha;
      _faseBrechaActiva = faseInicial;
      _escenaEnReproduccion = brecha == null ? _proximaEscenaPendiente() : null;
      _cargando = false;
    });
  }

  /// Devuelve la primera escena del Arco 1 cuyos `flagsRequeridos`
  /// están todos activos y cuyo `flagDeSalida` aún no lo está. `null`
  /// si no hay nada que reproducir ahora.
  EscenaCinematica? _proximaEscenaPendiente() {
    if (!_idiomaElegido) return null;
    for (final escena in EscenasArco1.todas) {
      final yaVista = _flagsActivos.contains(escena.flagDeSalida);
      if (yaVista) continue;
      final precondicionesOk = escena.flagsRequeridos.every(
        _flagsActivos.contains,
      );
      if (precondicionesOk) return escena;
    }
    return null;
  }

  /// Devuelve la Brecha cuyo flag de disparo está activo y cuyo
  /// flag de completado aún no lo está. `null` si ninguna está
  /// abierta — entonces el orquestador pasa a evaluar cinemáticas
  /// como hasta ahora.
  Brecha? _proximaBrechaPendiente() {
    if (!_idiomaElegido) return null;
    for (final entrada in CatalogoBrechas.brechaPorFlagDeDisparo.entries) {
      final flagDisparo = entrada.key;
      final brecha = entrada.value;
      final disparada = _flagsActivos.contains(flagDisparo);
      final yaCompletada = _flagsActivos.contains(brecha.flagDeCompletado);
      if (disparada && !yaCompletada) return brecha;
    }
    return null;
  }

  Future<void> _alElegirIdioma(String codigo) async {
    await widget.repoIdioma.guardar(codigo);
    localeAppLasVersiones.value = Locale(codigo);
    if (!mounted) return;
    _idiomaElegido = true;
    final brecha = _proximaBrechaPendiente();
    FaseBrecha faseInicial = FaseBrecha.formulacionPreguntas;
    if (brecha != null) {
      faseInicial = await widget.repoEstadoBrecha.faseActiva(brecha.id) ??
          FaseBrecha.formulacionPreguntas;
    }
    if (!mounted) return;
    setState(() {
      _brechaAbierta = brecha;
      _faseBrechaActiva = faseInicial;
      _escenaEnReproduccion = brecha == null ? _proximaEscenaPendiente() : null;
    });
  }

  Future<void> _alEstablecerFlag(String flag) async {
    await widget.repoFlags.activar(flag);
    if (!mounted) return;
    // No reconstruimos la pantalla con cada flag — la cinemática
    // sigue su curso. Sólo guardamos que ya está activo para que el
    // próximo arranque lo recuerde.
    _flagsActivos = {..._flagsActivos, flag};
  }

  Future<void> _alTerminarEscena(EscenaCinematica escena) async {
    // Cierre de escena: el flag de salida más los flags
    // institucionales declarados por el catálogo del juego.
    final flagsACerrar = <String>{
      escena.flagDeSalida,
      ...?EscenasArco1.flagsDeCierrePorEscena[escena.flagDeSalida],
    };
    for (final flag in flagsACerrar) {
      await widget.repoFlags.activar(flag);
    }
    // Si el flag de salida tiene entrada de Cuaderno asociada, se
    // registra al cerrar la escena. Mantenemos el catálogo del
    // Cuaderno separado del catálogo de escenas para poder editar
    // textos de Cuaderno sin tocar el de escenas.
    final entrada = CatalogoCuaderno.entradasPorFlag[escena.flagDeSalida];
    if (entrada != null) {
      await widget.repoCuaderno.registrarEntrada(entrada.id);
    }
    if (!mounted) return;
    _flagsActivos = {..._flagsActivos, ...flagsACerrar};
    // Tras cerrar la escena puede haberse abierto una Brecha (caso
    // 1.1.2 → flag aralar_dolmen_alcanzado activa Brecha 1.1).
    final brecha = _proximaBrechaPendiente();
    FaseBrecha faseInicial = FaseBrecha.formulacionPreguntas;
    if (brecha != null) {
      faseInicial = await widget.repoEstadoBrecha.faseActiva(brecha.id) ??
          FaseBrecha.formulacionPreguntas;
    }
    if (!mounted) return;
    setState(() {
      _brechaAbierta = brecha;
      _faseBrechaActiva = faseInicial;
      _escenaEnReproduccion = brecha == null ? _proximaEscenaPendiente() : null;
    });
  }

  Future<void> _alAvanzarFaseBrecha() async {
    final brecha = _brechaAbierta;
    if (brecha == null) return;
    final indiceSiguiente = _faseBrechaActiva.index + 1;
    if (indiceSiguiente >= FaseBrecha.values.length) return;
    final siguiente = FaseBrecha.values[indiceSiguiente];
    await widget.repoEstadoBrecha.establecerFase(brecha.id, siguiente);
    if (!mounted) return;
    setState(() => _faseBrechaActiva = siguiente);
  }

  Future<void> _alCompletarBrecha() async {
    final brecha = _brechaAbierta;
    if (brecha == null) return;
    await widget.repoFlags.activar(brecha.flagDeCompletado);
    await widget.repoEstadoBrecha.borrar(brecha.id);
    if (!mounted) return;
    _flagsActivos = {..._flagsActivos, brecha.flagDeCompletado};
    setState(() {
      _brechaAbierta = null;
      _escenaEnReproduccion = _proximaEscenaPendiente();
    });
  }

  /// Abre el Cuaderno como ruta superpuesta al estado actual del
  /// orquestador. Cruza el catálogo (fuente de verdad del contenido)
  /// con los IDs registrados en el repositorio (qué entradas ya
  /// están escritas) y respeta el orden del catálogo.
  Future<void> _alAbrirCuaderno() async {
    final idsRegistrados = await widget.repoCuaderno.idsRegistrados();
    final entradasVisibles = CatalogoCuaderno.todas
        .where((entrada) => idsRegistrados.contains(entrada.id))
        .toList(growable: false);
    if (!mounted) return;
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PantallaCuaderno(entradas: entradasVisibles),
      ),
    );
  }

  @override
  Widget build(BuildContext contexto) {
    if (_cargando) {
      return const Scaffold(
        backgroundColor: PaletaArchivo.fondoProfundo,
        body: SizedBox.expand(),
      );
    }
    if (!_idiomaElegido) {
      return PantallaConfiguracionInicial(alElegirIdioma: _alElegirIdioma);
    }
    final brecha = _brechaAbierta;
    if (brecha != null) {
      return PantallaBrecha(
        key: ValueKey('brecha-${brecha.id}-${_faseBrechaActiva.name}'),
        brecha: brecha,
        faseActiva: _faseBrechaActiva,
        alAvanzarFase: _alAvanzarFaseBrecha,
        alCompletarBrecha: _alCompletarBrecha,
        alAbrirCuaderno: _alAbrirCuaderno,
      );
    }
    final escena = _escenaEnReproduccion;
    if (escena != null) {
      // Key por id de escena para que el StatefulWidget se reinicie
      // limpio al cambiar de escena. Durante la cinemática el
      // Cuaderno NO está accesible: distrae del momento narrativo y
      // las cinemáticas son cortas.
      return PantallaCinematica(
        key: ValueKey(escena.id),
        escena: escena,
        alEstablecerFlag: _alEstablecerFlag,
        alTerminar: () => _alTerminarEscena(escena),
      );
    }
    return PantallaEsqueleto(alAbrirCuaderno: _alAbrirCuaderno);
  }
}
