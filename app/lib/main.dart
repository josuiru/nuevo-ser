import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'datos/repositorio_progreso.dart';
import 'nucleo/paleta.dart';
import 'vista/pantalla_apertura.dart';
import 'vista/pantalla_caza.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));
  runApp(const AppUnoRoto());
}

class AppUnoRoto extends StatelessWidget {
  const AppUnoRoto({super.key});

  @override
  Widget build(BuildContext contexto) {
    return MaterialApp(
      title: 'Uno Roto — Prototipo del combate',
      theme: temaUnoRoto(),
      debugShowCheckedModeBanner: false,
      home: const OrquestadorFases(),
    );
  }
}

enum _FaseApp { cargando, apertura, caza }

class OrquestadorFases extends StatefulWidget {
  const OrquestadorFases({super.key});

  @override
  State<OrquestadorFases> createState() => _OrquestadorFasesState();
}

class _OrquestadorFasesState extends State<OrquestadorFases> {
  final RepositorioProgreso _repositorio = RepositorioProgreso();
  _FaseApp _fase = _FaseApp.cargando;

  @override
  void initState() {
    super.initState();
    _inicializar();
  }

  Future<void> _inicializar() async {
    final yaVioApertura = await _repositorio.yaVioLaApertura();
    await _repositorio.guardarAhoraComoUltimaApertura();
    if (!mounted) return;
    setState(() {
      _fase = yaVioApertura ? _FaseApp.caza : _FaseApp.apertura;
    });
  }

  Future<void> _alTerminarApertura() async {
    await _repositorio.marcarAperturaVista();
    if (!mounted) return;
    setState(() => _fase = _FaseApp.caza);
  }

  @override
  Widget build(BuildContext contexto) {
    switch (_fase) {
      case _FaseApp.cargando:
        return const ColoredBox(color: PaletaNeon.fondoProfundo);
      case _FaseApp.apertura:
        return PantallaApertura(alTerminarApertura: _alTerminarApertura);
      case _FaseApp.caza:
        return PantallaCaza(repositorio: _repositorio);
    }
  }
}
