// Repositorio del vocabulario del jugador.
//
// Persistencia por perfil en shared_preferences:
//   nuevoser.descifrador.perfil.<id>.vocabulario

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../dominio/lengua.dart';
import '../dominio/vocabulario_jugador.dart';

class RepositorioVocabulario {
  RepositorioVocabulario({
    required this.idPerfil,
    SharedPreferences? preferenciasInyectadas,
  }) : _preferenciasInyectadas = preferenciasInyectadas;

  final String idPerfil;
  final SharedPreferences? _preferenciasInyectadas;

  String get _clave => 'nuevoser.descifrador.perfil.$idPerfil.vocabulario';

  Future<SharedPreferences> _preferencias() async {
    return _preferenciasInyectadas ?? await SharedPreferences.getInstance();
  }

  Future<VocabularioJugador> cargar() async {
    final preferencias = await _preferencias();
    final json = preferencias.getString(_clave);
    if (json == null || json.isEmpty) {
      return VocabularioJugador.inicial();
    }
    try {
      final mapa = jsonDecode(json) as Map<String, dynamic>;
      return VocabularioJugador.deserializar(mapa);
    } catch (_) {
      return VocabularioJugador.inicial();
    }
  }

  Future<void> guardar(VocabularioJugador vocabulario) async {
    final preferencias = await _preferencias();
    await preferencias.setString(_clave, jsonEncode(vocabulario.serializar()));
  }

  /// Conveniencia: aplica una marca y persiste.
  Future<VocabularioJugador> registrarMarca({
    required Lengua lengua,
    required String palabra,
    required MarcaPalabra marca,
  }) async {
    final actual = await cargar();
    final siguiente = actual.conPalabraMarcada(
      lengua: lengua,
      palabra: palabra,
      marca: marca,
    );
    await guardar(siguiente);
    return siguiente;
  }

  /// Conveniencia: olvidar una marca y persistir.
  Future<VocabularioJugador> olvidarMarca({
    required Lengua lengua,
    required String palabra,
  }) async {
    final actual = await cargar();
    final siguiente = actual.sinMarcaDe(lengua: lengua, palabra: palabra);
    await guardar(siguiente);
    return siguiente;
  }

  Future<void> borrar() async {
    final preferencias = await _preferencias();
    await preferencias.remove(_clave);
  }
}
