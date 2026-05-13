// Repositorio de identificaciones de lengua del jugador.
//
// Persistencia por perfil en shared_preferences:
//   nuevoser.descifrador.perfil.<id>.identificaciones

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../dominio/identificaciones_lengua.dart';
import '../dominio/lengua.dart';

class RepositorioIdentificaciones {
  RepositorioIdentificaciones({
    required this.idPerfil,
    SharedPreferences? preferenciasInyectadas,
    DateTime Function()? relojInyectado,
  })  : _preferenciasInyectadas = preferenciasInyectadas,
        _reloj = relojInyectado ?? DateTime.now;

  final String idPerfil;
  final SharedPreferences? _preferenciasInyectadas;
  final DateTime Function() _reloj;

  String get _clave =>
      'nuevoser.descifrador.perfil.$idPerfil.identificaciones';

  Future<SharedPreferences> _preferencias() async {
    return _preferenciasInyectadas ?? await SharedPreferences.getInstance();
  }

  Future<IdentificacionesPiezas> cargar() async {
    final preferencias = await _preferencias();
    final json = preferencias.getString(_clave);
    if (json == null || json.isEmpty) {
      return IdentificacionesPiezas.inicial();
    }
    try {
      final mapa = jsonDecode(json) as Map<String, dynamic>;
      return IdentificacionesPiezas.deserializar(mapa);
    } catch (_) {
      return IdentificacionesPiezas.inicial();
    }
  }

  Future<void> guardar(IdentificacionesPiezas identificaciones) async {
    final preferencias = await _preferencias();
    await preferencias.setString(
      _clave,
      jsonEncode(identificaciones.serializar()),
    );
  }

  /// Registra un intento y persiste.
  Future<IdentificacionesPiezas> registrarIntento({
    required String idPieza,
    required Lengua lenguaIntentada,
    required Lengua lenguaCorrecta,
  }) async {
    final actuales = await cargar();
    final siguientes = actuales.conIntento(
      idPieza: idPieza,
      lenguaIntentada: lenguaIntentada,
      lenguaCorrecta: lenguaCorrecta,
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
