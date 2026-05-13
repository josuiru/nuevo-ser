// Repositorio de pistas pedidas por el jugador.
//
// Persistencia por perfil en shared_preferences:
//   nuevoser.descifrador.perfil.<id>.pistas

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../dominio/pistas_pedidas.dart';

class RepositorioPistas {
  RepositorioPistas({
    required this.idPerfil,
    SharedPreferences? preferenciasInyectadas,
    DateTime Function()? relojInyectado,
  })  : _preferenciasInyectadas = preferenciasInyectadas,
        _reloj = relojInyectado ?? DateTime.now;

  final String idPerfil;
  final SharedPreferences? _preferenciasInyectadas;
  final DateTime Function() _reloj;

  String get _clave => 'nuevoser.descifrador.perfil.$idPerfil.pistas';

  Future<SharedPreferences> _preferencias() async {
    return _preferenciasInyectadas ?? await SharedPreferences.getInstance();
  }

  Future<PistasPedidas> cargar() async {
    final preferencias = await _preferencias();
    final json = preferencias.getString(_clave);
    if (json == null || json.isEmpty) {
      return PistasPedidas.inicial();
    }
    try {
      final mapa = jsonDecode(json) as Map<String, dynamic>;
      return PistasPedidas.deserializar(mapa);
    } catch (_) {
      return PistasPedidas.inicial();
    }
  }

  Future<void> guardar(PistasPedidas pistas) async {
    final preferencias = await _preferencias();
    await preferencias.setString(_clave, jsonEncode(pistas.serializar()));
  }

  /// Registra una pista y persiste.
  Future<PistasPedidas> registrarPista({
    required String idPieza,
    required String palabra,
    required NivelPista nivel,
  }) async {
    final actuales = await cargar();
    final siguientes = actuales.conPista(
      idPieza: idPieza,
      palabra: palabra,
      nivel: nivel,
      ahora: _reloj(),
    );
    await guardar(siguientes);
    return siguientes;
  }

  Future<void> borrar() async {
    final preferencias = await _preferencias();
    await preferencias.remove(_clave);
  }
}
