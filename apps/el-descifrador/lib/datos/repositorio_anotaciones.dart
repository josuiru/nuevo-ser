// Repositorio de anotaciones marginales por pieza.
//
// Persistencia por perfil en shared_preferences:
//   nuevoser.descifrador.perfil.<id>.anotaciones_piezas

import 'dart:convert';
import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

import '../dominio/anotaciones_piezas.dart';

class RepositorioAnotaciones {
  RepositorioAnotaciones({
    required this.idPerfil,
    SharedPreferences? preferenciasInyectadas,
    DateTime Function()? relojInyectado,
    String Function()? generadorIdInyectado,
  })  : _preferenciasInyectadas = preferenciasInyectadas,
        _reloj = relojInyectado ?? DateTime.now,
        _generadorId = generadorIdInyectado ?? _generadorIdPorDefecto;

  final String idPerfil;
  final SharedPreferences? _preferenciasInyectadas;
  final DateTime Function() _reloj;
  final String Function() _generadorId;

  String get _clave =>
      'nuevoser.descifrador.perfil.$idPerfil.anotaciones_piezas';

  Future<SharedPreferences> _preferencias() async {
    return _preferenciasInyectadas ?? await SharedPreferences.getInstance();
  }

  Future<AnotacionesPiezas> cargar() async {
    final preferencias = await _preferencias();
    final json = preferencias.getString(_clave);
    if (json == null || json.isEmpty) {
      return AnotacionesPiezas.inicial();
    }
    try {
      final mapa = jsonDecode(json) as Map<String, dynamic>;
      return AnotacionesPiezas.deserializar(mapa);
    } catch (_) {
      return AnotacionesPiezas.inicial();
    }
  }

  Future<void> guardar(AnotacionesPiezas anotaciones) async {
    final preferencias = await _preferencias();
    await preferencias.setString(
      _clave,
      jsonEncode(anotaciones.serializar()),
    );
  }

  Future<AnotacionesPiezas> anyadirAnotacion({
    required String idPieza,
    required String texto,
  }) async {
    final actuales = await cargar();
    final siguientes = actuales.conAnotacionNueva(
      id: _generadorId(),
      idPieza: idPieza,
      texto: texto,
      ahora: _reloj(),
    );
    await guardar(siguientes);
    return siguientes;
  }

  Future<AnotacionesPiezas> editarAnotacion({
    required String id,
    required String texto,
  }) async {
    final actuales = await cargar();
    final siguientes = actuales.conAnotacionEditada(
      id: id,
      texto: texto,
      ahora: _reloj(),
    );
    await guardar(siguientes);
    return siguientes;
  }

  Future<AnotacionesPiezas> borrarAnotacion(String id) async {
    final actuales = await cargar();
    final siguientes = actuales.sinAnotacion(id);
    await guardar(siguientes);
    return siguientes;
  }

  Future<void> borrarTodas() async {
    final preferencias = await _preferencias();
    await preferencias.remove(_clave);
  }
}

String _generadorIdPorDefecto() {
  final aleatorio = Random.secure();
  final sufijo = aleatorio.nextInt(0xFFFFFF).toRadixString(16).padLeft(6, '0');
  return 'anotacion-${DateTime.now().microsecondsSinceEpoch}-$sufijo';
}
