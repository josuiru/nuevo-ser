import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'datos/repositorio_progreso.dart';
import 'dominio/catalogo_escenas.dart';
import 'dominio/desafio_kurz.dart';
import 'dominio/escena_cinematica.dart';
import 'dominio/rango_narrativo.dart';
import 'dominio/variantes_entrenamiento.dart';
import 'nucleo/paleta.dart';
import 'vista/pantalla_apertura.dart';
import 'vista/pantalla_cinematica.dart';
import 'vista/pantalla_combate_kurz.dart';
import 'vista/pantalla_mapa.dart';
import 'vista/pantalla_nombre.dart';

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

enum _FaseApp { cargando, apertura, nombre, cinematica, combateKurz, mapa }

class OrquestadorFases extends StatefulWidget {
  const OrquestadorFases({super.key});

  @override
  State<OrquestadorFases> createState() => _OrquestadorFasesState();
}

class _OrquestadorFasesState extends State<OrquestadorFases> {
  final RepositorioProgreso _repositorio = RepositorioProgreso();
  _FaseApp _fase = _FaseApp.cargando;
  EscenaCinematica? _escenaPendiente;
  DesafioKurz? _desafioKurzActivo;
  String? _nombreJugador;

  /// Impide que se dispare más de una variante de entrenamiento por
  /// transición — sin esto, al volver de la variante el orquestador
  /// intentaría disparar otra en bucle.
  bool _varianteYaDisparadaEnEstaTransicion = false;

  @override
  void initState() {
    super.initState();
    _inicializar();
  }

  Future<void> _inicializar() async {
    final yaVioApertura = await _repositorio.yaVioLaApertura();
    await _repositorio.guardarAhoraComoUltimaApertura();
    _nombreJugador = await _repositorio.cargarNombreJugador();
    if (!mounted) return;
    if (!yaVioApertura) {
      setState(() => _fase = _FaseApp.apertura);
      return;
    }
    if (_nombreJugador == null) {
      setState(() => _fase = _FaseApp.nombre);
      return;
    }
    await _resolverCinematicaPendienteOMapa();
  }

  Future<void> _alTerminarApertura() async {
    await _repositorio.marcarAperturaVista();
    if (!mounted) return;
    if (_nombreJugador == null) {
      setState(() => _fase = _FaseApp.nombre);
      return;
    }
    await _resolverCinematicaPendienteOMapa();
  }

  Future<void> _alConfirmarNombre(String nombre) async {
    await _repositorio.guardarNombreJugador(nombre);
    _nombreJugador = nombre;
    if (!mounted) return;
    await _resolverCinematicaPendienteOMapa();
  }

  /// Combate Kurz pendiente — devuelve el desafío correspondiente o
  /// null si no hay ninguno pendiente. Permite añadir combates futuros
  /// sin tocar el orquestador principal.
  Future<DesafioKurz?> _combateKurzPendiente() async {
    final vio15 = await _repositorio.flagNarrativoActivo('escena_1_5_vista');
    final completo1 =
        await _repositorio.flagNarrativoActivo('combate_kurz_1_completado');
    if (vio15 && !completo1) return DesafioKurz.primero;
    final vio110pre =
        await _repositorio.flagNarrativoActivo('escena_1_10_pre_vista');
    final completo2 =
        await _repositorio.flagNarrativoActivo('combate_kurz_2_completado');
    if (vio110pre && !completo2) return DesafioKurz.segundo;
    final vio112pre =
        await _repositorio.flagNarrativoActivo('escena_1_12_pre_vista');
    final completo3 =
        await _repositorio.flagNarrativoActivo('combate_kurz_3_completado');
    if (vio112pre && !completo3) return DesafioKurz.tercero;
    return null;
  }

  /// Busca la siguiente escena no vista **cuyos prerrequisitos se
  /// cumplan** y la reproduce. Antes de buscar la siguiente cinemática,
  /// comprueba si toca un combate jugable (Kurz). Si no hay ni combate
  /// ni cinemática disponible, va al mapa.
  Future<void> _resolverCinematicaPendienteOMapa() async {
    final combatePendiente = await _combateKurzPendiente();
    if (combatePendiente != null) {
      if (!mounted) return;
      setState(() {
        _desafioKurzActivo = combatePendiente;
        _fase = _FaseApp.combateKurz;
      });
      return;
    }
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
    if (await _intentarDispararVarianteEntrenamiento()) return;
    if (!mounted) return;
    setState(() {
      _fase = _FaseApp.mapa;
      _varianteYaDisparadaEnEstaTransicion = false;
    });
  }

  /// Si la 1.7 ya ocurrió y el Arco 1 sigue en curso (1.14 aún no vista),
  /// dispara la siguiente variante de entrenamiento no usada. Al agotar
  /// el pool, lo resetea y elige una nueva. Solo dispara una por
  /// transición para no encadenarlas.
  Future<bool> _intentarDispararVarianteEntrenamiento() async {
    if (_varianteYaDisparadaEnEstaTransicion) return false;
    final puedeSalir =
        await _repositorio.flagNarrativoActivo('escena_1_7_vista');
    if (!puedeSalir) return false;
    final arcoCerrado =
        await _repositorio.flagNarrativoActivo('escena_1_14_vista');
    if (arcoCerrado) return false;
    var usadas =
        await _repositorio.cargarVariantesEntrenamientoUsadas();
    var siguiente = VariantesEntrenamiento.elegirSiguiente(usadas);
    if (siguiente == null) {
      await _repositorio.resetearVariantesEntrenamiento();
      usadas = {};
      siguiente = VariantesEntrenamiento.elegirSiguiente(usadas);
    }
    if (siguiente == null) return false;
    await _repositorio.marcarVarianteEntrenamientoUsada(siguiente.id);
    if (!mounted) return false;
    setState(() {
      _escenaPendiente = siguiente;
      _fase = _FaseApp.cinematica;
      _varianteYaDisparadaEnEstaTransicion = true;
    });
    return true;
  }

  Future<void> _alTerminarCombateKurz(ResultadoCombateKurz resultado) async {
    final desafio = _desafioKurzActivo;
    if (desafio != null) {
      final id = desafio.identificador;
      await _repositorio.activarFlagNarrativo('combate_${id}_completado');
      await _repositorio.activarFlagNarrativo(
        resultado.victoria ? 'victoria_$id' : 'derrota_$id',
      );
      // Vencer a Kurz por tercera vez es el hito narrativo del Arco I:
      // garantiza Aprendiz II aunque no se haya alcanzado por esquirlas,
      // así la 1.13 (ceremonia) puede dispararse.
      if (id == 'kurz_3' && resultado.victoria) {
        await _repositorio.forzarRangoMinimo(RangoNarrativo.aprendiz2);
      }
    }
    if (!mounted) return;
    _desafioKurzActivo = null;
    await _resolverCinematicaPendienteOMapa();
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
    final eraCierreAmable = escena?.esCierreAmable ?? false;
    _escenaPendiente = null;
    if (eraCierreAmable) {
      // Respeto del principio de cierre: no encadenamos otra cinemática
      // en esta misma sesión — vamos directamente al mapa.
      setState(() => _fase = _FaseApp.mapa);
      return;
    }
    await _resolverCinematicaPendienteOMapa();
  }

  @override
  Widget build(BuildContext contexto) {
    switch (_fase) {
      case _FaseApp.cargando:
        return const ColoredBox(color: PaletaNeon.fondoProfundo);
      case _FaseApp.apertura:
        return PantallaApertura(alTerminarApertura: _alTerminarApertura);
      case _FaseApp.nombre:
        return PantallaNombre(alConfirmar: _alConfirmarNombre);
      case _FaseApp.cinematica:
        final escena = _escenaPendiente;
        if (escena == null) {
          return const ColoredBox(color: PaletaNeon.fondoProfundo);
        }
        return PantallaCinematica(
          escena: escena,
          nombreJugador: _nombreJugador ?? '',
          alTerminar: _alTerminarCinematica,
          alEstablecerFlag: _repositorio.activarFlagNarrativo,
        );
      case _FaseApp.combateKurz:
        final desafio = _desafioKurzActivo;
        if (desafio == null) {
          return const ColoredBox(color: PaletaNeon.fondoProfundo);
        }
        return PantallaCombateKurz(
          desafio: desafio,
          alTerminar: _alTerminarCombateKurz,
        );
      case _FaseApp.mapa:
        return PantallaMapa(repositorio: _repositorio);
    }
  }
}
