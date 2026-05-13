// Repositorio de sellos del cuaderno.
//
// Persistencia por perfil en shared_preferences:
//   nuevoser.descifrador.perfil.<id>.sellos

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../dominio/sellos.dart';

class RepositorioSellos {
  RepositorioSellos({
    required this.idPerfil,
    SharedPreferences? preferenciasInyectadas,
    DateTime Function()? relojInyectado,
  })  : _preferenciasInyectadas = preferenciasInyectadas,
        _reloj = relojInyectado ?? DateTime.now;

  final String idPerfil;
  final SharedPreferences? _preferenciasInyectadas;
  final DateTime Function() _reloj;

  String get _clave => 'nuevoser.descifrador.perfil.$idPerfil.sellos';

  Future<SharedPreferences> _preferencias() async {
    return _preferenciasInyectadas ?? await SharedPreferences.getInstance();
  }

  Future<Sellos> cargar() async {
    final preferencias = await _preferencias();
    final json = preferencias.getString(_clave);
    if (json == null || json.isEmpty) return Sellos.inicial();
    try {
      final mapa = jsonDecode(json) as Map<String, dynamic>;
      return Sellos.deserializar(mapa);
    } catch (_) {
      return Sellos.inicial();
    }
  }

  Future<void> guardar(Sellos sellos) async {
    final preferencias = await _preferencias();
    await preferencias.setString(_clave, jsonEncode(sellos.serializar()));
  }

  /// Registra un sello si no existía. Devuelve los sellos resultantes
  /// y un bool indicando si era nuevo (para que la UI pueda celebrar
  /// con discreción).
  Future<(Sellos, bool)> registrarSelloSiNuevo(String claveSello) async {
    final actuales = await cargar();
    if (actuales.tieneSello(claveSello)) return (actuales, false);
    final siguientes =
        actuales.conSello(clave: claveSello, ahora: _reloj());
    await guardar(siguientes);
    return (siguientes, true);
  }

  Future<void> borrar() async {
    final preferencias = await _preferencias();
    await preferencias.remove(_clave);
  }
}
