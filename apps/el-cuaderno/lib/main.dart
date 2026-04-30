import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nuevo_ser_core/nuevo_ser_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'datos_simulados/seed.dart';
import 'dominio/repositorio_local.dart';
import 'infraestructura/isar/isar_setup.dart';
import 'infraestructura/isar/repositorio_isar.dart';
import 'nucleo/i18n/generado/textos_app.dart';
import 'vista/pantalla_configuracion_inicial.dart';
import 'vista/pantalla_cuaderno/estado_cuaderno.dart';
import 'vista/pantalla_cuaderno/pantalla_cuaderno.dart';
import 'vista/tema/tema.dart';

/// Clave global del idioma elegido por el niño en el primer arranque.
/// Sigue el namespace `nuevoser.<juego>.*` que el CLAUDE.md raíz
/// prescribe para juegos nuevos. Otras claves globales del juego
/// (token JWT del backend, versión de paquete sonoro…) seguirán el
/// mismo patrón cuando lleguen.
const _claveIdiomaApp = 'nuevoser.elcuaderno.idioma_app';

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

  runApp(AppElCuaderno(
    repoIdioma: repoIdioma,
    repositorioCuaderno: repositorioCuaderno,
  ));
}

class AppElCuaderno extends StatelessWidget {
  final RepositorioIdiomaApp repoIdioma;
  final RepositorioLocal repositorioCuaderno;

  const AppElCuaderno({
    super.key,
    required this.repoIdioma,
    required this.repositorioCuaderno,
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
              : _OrquestadorJuego(repositorio: repositorioCuaderno),
        );
      },
    );
  }
}

class _OrquestadorJuego extends StatefulWidget {
  final RepositorioLocal repositorio;

  const _OrquestadorJuego({required this.repositorio});

  @override
  State<_OrquestadorJuego> createState() => _EstadoOrquestadorJuego();
}

class _EstadoOrquestadorJuego extends State<_OrquestadorJuego> {
  late final EstadoCuaderno _estado;

  @override
  void initState() {
    super.initState();
    _estado = EstadoCuaderno(repositorio: widget.repositorio);
  }

  @override
  void dispose() {
    _estado.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PantallaCuaderno(
      repositorio: widget.repositorio,
      estado: _estado,
    );
  }
}
