import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'datos/repositorio_progreso.dart';
import 'dominio/catalogo_escenas.dart';
import 'dominio/escena_cinematica.dart';
import 'nucleo/paleta.dart';
import 'vista/pantalla_apertura.dart';
import 'vista/pantalla_cinematica.dart';
import 'vista/pantalla_mapa.dart';

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

enum _FaseApp { cargando, apertura, cinematica, mapa }

class OrquestadorFases extends StatefulWidget {
  const OrquestadorFases({super.key});

  @override
  State<OrquestadorFases> createState() => _OrquestadorFasesState();
}

class _OrquestadorFasesState extends State<OrquestadorFases> {
  final RepositorioProgreso _repositorio = RepositorioProgreso();
  _FaseApp _fase = _FaseApp.cargando;
  EscenaCinematica? _escenaPendiente;

  @override
  void initState() {
    super.initState();
    _inicializar();
  }

  Future<void> _inicializar() async {
    final yaVioApertura = await _repositorio.yaVioLaApertura();
    await _repositorio.guardarAhoraComoUltimaApertura();
    if (!mounted) return;
    if (yaVioApertura) {
      await _resolverCinematicaPendienteOMapa();
    } else {
      setState(() => _fase = _FaseApp.apertura);
    }
  }

  Future<void> _alTerminarApertura() async {
    await _repositorio.marcarAperturaVista();
    if (!mounted) return;
    await _resolverCinematicaPendienteOMapa();
  }

  /// Busca la siguiente escena no vista **cuyos prerrequisitos se
  /// cumplan** y la reproduce. Si no hay ninguna disponible, va al mapa.
  Future<void> _resolverCinematicaPendienteOMapa() async {
    for (final escena in CatalogoEscenas.todas) {
      final vista = await _repositorio.flagNarrativoActivo(escena.flagDeSalida);
      if (vista) continue;
      final prerrequisitosOk =
          await _todosLosFlagsActivos(escena.flagsRequeridos);
      if (!prerrequisitosOk) continue;
      if (!mounted) return;
      setState(() {
        _escenaPendiente = escena;
        _fase = _FaseApp.cinematica;
      });
      return;
    }
    if (!mounted) return;
    setState(() => _fase = _FaseApp.mapa);
  }

  Future<bool> _todosLosFlagsActivos(Set<String> flags) async {
    for (final flag in flags) {
      if (!await _repositorio.flagNarrativoActivo(flag)) return false;
    }
    return true;
  }

  Future<void> _alTerminarCinematica() async {
    final escena = _escenaPendiente;
    if (escena != null) {
      await _repositorio.activarFlagNarrativo(escena.flagDeSalida);
    }
    if (!mounted) return;
    _escenaPendiente = null;
    await _resolverCinematicaPendienteOMapa();
  }

  @override
  Widget build(BuildContext contexto) {
    switch (_fase) {
      case _FaseApp.cargando:
        return const ColoredBox(color: PaletaNeon.fondoProfundo);
      case _FaseApp.apertura:
        return PantallaApertura(alTerminarApertura: _alTerminarApertura);
      case _FaseApp.cinematica:
        final escena = _escenaPendiente;
        if (escena == null) {
          return const ColoredBox(color: PaletaNeon.fondoProfundo);
        }
        return PantallaCinematica(
          escena: escena,
          alTerminar: _alTerminarCinematica,
          alEstablecerFlag: _repositorio.activarFlagNarrativo,
        );
      case _FaseApp.mapa:
        return PantallaMapa(repositorio: _repositorio);
    }
  }
}
