import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'datos_simulados/seed.dart';
import 'dominio/repositorio_local.dart';
import 'infraestructura/isar/isar_setup.dart';
import 'infraestructura/isar/repositorio_isar.dart';
import 'nucleo/i18n/generado/textos_app.dart';
import 'vista/pantalla_cuaderno/estado_cuaderno.dart';
import 'vista/pantalla_cuaderno/pantalla_cuaderno.dart';
import 'vista/tema/tema.dart';

/// Arranque de El Cuaderno. Sprint 1: abre Isar local, siembra datos
/// si estamos en debug, monta la pantalla principal con el tema y los
/// localizationDelegates de los tres idiomas (es / eu / ca, con
/// castellano completo y placeholders en los otros dos).
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final setup = IsarSetup();
  final isar = await setup.abrir();
  final repositorio = RepositorioIsar(isar);

  if (kDebugMode) {
    await sembrarDatosDesarrollo(repositorio);
  }

  runApp(AppElCuaderno(repositorio: repositorio));
}

class AppElCuaderno extends StatefulWidget {
  const AppElCuaderno({super.key, required this.repositorio});

  final RepositorioLocal repositorio;

  @override
  State<AppElCuaderno> createState() => _EstadoAppElCuaderno();
}

class _EstadoAppElCuaderno extends State<AppElCuaderno> {
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
    return MaterialApp(
      onGenerateTitle: (context) => TextosApp.of(context).tituloApp,
      theme: TemaCuaderno.claro(),
      darkTheme: TemaCuaderno.oscuro(),
      // Modo oscuro respetado del sistema (doc 13 §11.5).
      themeMode: ThemeMode.system,
      localizationsDelegates: TextosApp.localizationsDelegates,
      supportedLocales: TextosApp.supportedLocales,
      home: PantallaCuaderno(
        repositorio: widget.repositorio,
        estado: _estado,
      ),
    );
  }
}
