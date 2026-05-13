// Repositorio de notas libres del jugador.
//
// Persistencia por perfil en shared_preferences:
//   nuevoser.descifrador.perfil.<id>.notas_libres

import 'dart:convert';
import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

import '../dominio/notas_libres.dart';

class RepositorioNotasLibres {
  RepositorioNotasLibres({
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

  String get _clave => 'nuevoser.descifrador.perfil.$idPerfil.notas_libres';

  Future<SharedPreferences> _preferencias() async {
    return _preferenciasInyectadas ?? await SharedPreferences.getInstance();
  }

  Future<NotasLibres> cargar() async {
    final preferencias = await _preferencias();
    final json = preferencias.getString(_clave);
    if (json == null || json.isEmpty) {
      return NotasLibres.inicial();
    }
    try {
      final mapa = jsonDecode(json) as Map<String, dynamic>;
      return NotasLibres.deserializar(mapa);
    } catch (_) {
      return NotasLibres.inicial();
    }
  }

  Future<void> guardar(NotasLibres notas) async {
    final preferencias = await _preferencias();
    await preferencias.setString(_clave, jsonEncode(notas.serializar()));
  }

  /// Añade una nota nueva con id generado y fecha actual.
  Future<NotasLibres> anyadirNota({required String texto}) async {
    final actuales = await cargar();
    final siguientes = actuales.conNotaNueva(
      id: _generadorId(),
      texto: texto,
      ahora: _reloj(),
    );
    await guardar(siguientes);
    return siguientes;
  }

  Future<NotasLibres> editarNota({
    required String id,
    required String texto,
  }) async {
    final actuales = await cargar();
    final siguientes = actuales.conNotaEditada(
      id: id,
      texto: texto,
      ahora: _reloj(),
    );
    await guardar(siguientes);
    return siguientes;
  }

  Future<NotasLibres> borrarNota(String id) async {
    final actuales = await cargar();
    final siguientes = actuales.sinNota(id);
    await guardar(siguientes);
    return siguientes;
  }

  Future<void> borrarTodas() async {
    final preferencias = await _preferencias();
    await preferencias.remove(_clave);
  }
}

/// Generador de id por defecto: timestamp + sufijo aleatorio. Lo
/// suficientemente único para el volumen de notas que un niño escribe
/// (decenas en una vida del cuaderno).
String _generadorIdPorDefecto() {
  final aleatorio = Random.secure();
  final sufijo = aleatorio.nextInt(0xFFFFFF).toRadixString(16).padLeft(6, '0');
  return 'nota-${DateTime.now().microsecondsSinceEpoch}-$sufijo';
}
