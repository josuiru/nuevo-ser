import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

/// Fases de alto nivel de la aplicación:
/// apertura → sesión (primera noche) → cierre → (opcional) sesión otra vez.
enum _FaseApp { apertura, sesion, cierre }

class OrquestadorFases extends StatefulWidget {
  const OrquestadorFases({super.key});

  @override
  State<OrquestadorFases> createState() => _OrquestadorFasesState();
}

class _OrquestadorFasesState extends State<OrquestadorFases> {
  _FaseApp _fase = _FaseApp.apertura;
  SesionNoche _sesionActual = primeraNoche();

  void _alTerminarApertura() {
    setState(() => _fase = _FaseApp.sesion);
  }

  void _alTerminarSesion() {
    setState(() => _fase = _FaseApp.cierre);
  }

  void _alSeguirPracticando() {
    setState(() {
      _sesionActual = primeraNoche();
      _fase = _FaseApp.sesion;
    });
  }

  void _alCerrar() {
    // En producción esto cierra la app (SystemNavigator.pop en el botón).
    // Aquí simplemente mantenemos el cierre para que no se quede en blanco.
  }

  @override
  Widget build(BuildContext contexto) {
    switch (_fase) {
      case _FaseApp.apertura:
        return PantallaApertura(alTerminarApertura: _alTerminarApertura);
      case _FaseApp.sesion:
        return PantallaCombate(
          key: ValueKey(_sesionActual.hashCode),
          sesion: _sesionActual,
          alTerminarSesion: _alTerminarSesion,
        );
      case _FaseApp.cierre:
        return PantallaCierre(
          lineasDeSora: _sesionActual.lineasCierre.map((l) => l.texto).toList(),
          alCerrar: _alCerrar,
          alSeguirPracticando: _alSeguirPracticando,
        );
    }
  }
}
