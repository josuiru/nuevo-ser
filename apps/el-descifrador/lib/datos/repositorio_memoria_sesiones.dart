// Repositorio de la memoria de sesiones del jugador.
//
// Persistencia por perfil en shared_preferences:
//   nuevoser.descifrador.perfil.<id>.memoria_sesiones

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../dominio/memoria_sesiones.dart';

class RepositorioMemoriaSesiones {
  RepositorioMemoriaSesiones({
    required this.idPerfil,
    SharedPreferences? preferenciasInyectadas,
    DateTime Function()? relojInyectado,
  })  : _preferenciasInyectadas = preferenciasInyectadas,
        _reloj = relojInyectado ?? DateTime.now;

  final String idPerfil;
  final SharedPreferences? _preferenciasInyectadas;
  final DateTime Function() _reloj;

  String get _clave =>
      'nuevoser.descifrador.perfil.$idPerfil.memoria_sesiones';

  Future<SharedPreferences> _preferencias() async {
    return _preferenciasInyectadas ?? await SharedPreferences.getInstance();
  }

  /// Carga la memoria. Si no existe (primera vez del perfil), devuelve
  /// null. La pantalla que llama debe entonces registrar la apertura.
  Future<MemoriaSesiones?> cargar() async {
    final preferencias = await _preferencias();
    final json = preferencias.getString(_clave);
    if (json == null || json.isEmpty) return null;
    try {
      final mapa = jsonDecode(json) as Map<String, dynamic>;
      return MemoriaSesiones.deserializar(mapa);
    } catch (_) {
      return null;
    }
  }

  Future<void> guardar(MemoriaSesiones memoria) async {
    final preferencias = await _preferencias();
    await preferencias.setString(_clave, jsonEncode(memoria.serializar()));
  }

  /// Conveniencia: registra una visita y persiste. Si es la primera
  /// vez del perfil, crea memoria con apertura inicial.
  Future<MemoriaSesiones> registrarVisita() async {
    final ahora = _reloj();
    final previa = await cargar();
    final siguiente = previa == null
        ? MemoriaSesiones.aperturaInicial(ahora)
        : previa.conVisitaRegistrada(ahora);
    await guardar(siguiente);
    return siguiente;
  }

  Future<MemoriaSesiones> marcarHitoMostrado({
    required MemoriaSesiones memoriaActual,
    required int hito,
  }) async {
    final siguiente = memoriaActual.conHitoMostrado(hito);
    await guardar(siguiente);
    return siguiente;
  }

  Future<void> borrar() async {
    final preferencias = await _preferencias();
    await preferencias.remove(_clave);
  }
}
