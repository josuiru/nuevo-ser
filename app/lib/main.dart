import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'datos/repositorio_progreso.dart';
import 'dominio/sesion.dart';
import 'nucleo/guion_primera_noche.dart';
import 'nucleo/paleta.dart';
import 'vista/pantalla_apertura.dart';
import 'vista/pantalla_cierre.dart';
import 'vista/pantalla_combate.dart';

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

enum _FaseApp { cargando, apertura, sesion, cierre }

class OrquestadorFases extends StatefulWidget {
  const OrquestadorFases({super.key});

  @override
  State<OrquestadorFases> createState() => _OrquestadorFasesState();
}

class _OrquestadorFasesState extends State<OrquestadorFases> {
  final RepositorioProgreso _repositorio = RepositorioProgreso();

  _FaseApp _fase = _FaseApp.cargando;
  int _indiceNoche = 0;
  SesionNoche _sesionActual = primeraNoche();

  @override
  void initState() {
    super.initState();
    _cargarProgreso();
  }

  Future<void> _cargarProgreso() async {
    final indiceGuardado = await _repositorio.cargarSiguienteNoche();
    final yaVioApertura = await _repositorio.yaVioLaApertura();
    await _repositorio.guardarAhoraComoUltimaApertura();

    if (!mounted) return;
    setState(() {
      _indiceNoche = indiceGuardado;
      _sesionActual = _sesionParaIndice(indiceGuardado);
      // Primera vez: splash + sesión. En reaperturas saltamos al combate
      // directamente para respetar el tiempo del niño.
      _fase = yaVioApertura ? _FaseApp.sesion : _FaseApp.apertura;
    });
  }

  SesionNoche _sesionParaIndice(int indice) {
    switch (indice) {
      case 0:
        return primeraNoche();
      case 1:
        return segundaNoche();
      case 2:
        return terceraNoche();
      case 3:
        return cuartaNoche();
      default:
        return cuartaNoche();
    }
  }

  Future<void> _alTerminarApertura() async {
    await _repositorio.marcarAperturaVista();
    if (!mounted) return;
    setState(() => _fase = _FaseApp.sesion);
  }

  Future<void> _alTerminarSesion() async {
    final siguienteIndice = _indiceNoche + 1;
    await _repositorio.guardarSiguienteNoche(siguienteIndice);
    if (!mounted) return;
    setState(() => _fase = _FaseApp.cierre);
  }

  void _alSeguirPracticando() {
    setState(() {
      _indiceNoche++;
      _sesionActual = _sesionParaIndice(_indiceNoche);
      _fase = _FaseApp.sesion;
    });
  }

  void _alCerrar() {
    // El botón "Buenas noches" ya llama a SystemNavigator.pop() en la
    // propia PantallaCierre. Aquí no hacemos nada adicional.
  }

  @override
  Widget build(BuildContext contexto) {
    switch (_fase) {
      case _FaseApp.cargando:
        return const ColoredBox(color: PaletaNeon.fondoProfundo);
      case _FaseApp.apertura:
        return PantallaApertura(alTerminarApertura: _alTerminarApertura);
      case _FaseApp.sesion:
        return PantallaCombate(
          key: ValueKey('noche_$_indiceNoche'),
          sesion: _sesionActual,
          alTerminarSesion: _alTerminarSesion,
        );
      case _FaseApp.cierre:
        return PantallaCierre(
          lineasDeSora:
              _sesionActual.lineasCierre.map((l) => l.texto).toList(),
          alCerrar: _alCerrar,
          alSeguirPracticando: _alSeguirPracticando,
        );
    }
  }
}
