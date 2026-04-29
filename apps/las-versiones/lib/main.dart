import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:nuevo_ser_core/nuevo_ser_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'datos/repositorio_flags_narrativos.dart';
import 'dominio/escenas_arco_1.dart';
import 'nucleo/paleta_archivo.dart';
import 'vista/pantalla_cinematica.dart';
import 'vista/pantalla_configuracion_inicial.dart';
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
  ));
}

class AppLasVersiones extends StatelessWidget {
  final RepositorioIdiomaApp repoIdioma;
  final RepositorioFlagsNarrativos repoFlags;

  const AppLasVersiones({
    super.key,
    required this.repoIdioma,
    required this.repoFlags,
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

/// Orquestador del esqueleto. Tres estados posibles, en orden:
///
/// 1. **Configuración inicial** si la Cronista nunca eligió idioma.
/// 2. **Cinemática** si hay una escena pendiente cuyos
///    `flagsRequeridos` están todos activos y cuyo `flagDeSalida`
///    aún no lo está.
/// 3. **Esqueleto** si todas las escenas implementadas están vistas
///    (mientras no haya Brechas jugables).
///
/// Cuando llegue el sistema de Brechas, esta clase crecerá hasta ser
/// hermana de `OrquestadorFases` de Uno Roto. Por ahora encarna sólo
/// el ritmo "elige idioma → vive la primera cinemática → espera lo
/// que viene".
class Orquestador extends StatefulWidget {
  final RepositorioIdiomaApp repoIdioma;
  final RepositorioFlagsNarrativos repoFlags;

  const Orquestador({
    super.key,
    required this.repoIdioma,
    required this.repoFlags,
  });

  @override
  State<Orquestador> createState() => _OrquestadorState();
}

class _OrquestadorState extends State<Orquestador> {
  bool _cargando = true;
  bool _idiomaElegido = false;
  Set<String> _flagsActivos = const {};
  EscenaCinematica? _escenaEnReproduccion;

  @override
  void initState() {
    super.initState();
    _cargarEstadoInicial();
  }

  Future<void> _cargarEstadoInicial() async {
    final codigo = await widget.repoIdioma.cargar();
    final flags = await widget.repoFlags.activos();
    if (!mounted) return;
    setState(() {
      _idiomaElegido = codigo != null;
      _flagsActivos = flags;
      _cargando = false;
      _escenaEnReproduccion = _proximaEscenaPendiente();
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

  Future<void> _alElegirIdioma(String codigo) async {
    await widget.repoIdioma.guardar(codigo);
    localeAppLasVersiones.value = Locale(codigo);
    if (!mounted) return;
    setState(() {
      _idiomaElegido = true;
      _escenaEnReproduccion = _proximaEscenaPendiente();
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
    if (!mounted) return;
    final nuevosFlags = {..._flagsActivos, ...flagsACerrar};
    setState(() {
      _flagsActivos = nuevosFlags;
      _escenaEnReproduccion = _proximaEscenaPendiente();
    });
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
    final escena = _escenaEnReproduccion;
    if (escena != null) {
      // Key por id de escena para que el StatefulWidget se reinicie
      // limpio si cambiamos a otra (no aplica todavía con sólo una,
      // pero lo dejamos cableado para cuando lleguen 1.0.2 y
      // siguientes).
      return PantallaCinematica(
        key: ValueKey(escena.id),
        escena: escena,
        alEstablecerFlag: _alEstablecerFlag,
        alTerminar: () => _alTerminarEscena(escena),
      );
    }
    return const PantallaEsqueleto();
  }
}
