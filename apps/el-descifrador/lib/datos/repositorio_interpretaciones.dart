// Repositorio de interpretaciones del jugador.
//
// Persistencia por perfil en shared_preferences:
//   nuevoser.descifrador.perfil.<id>.interpretaciones

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../dominio/interpretacion_pieza.dart';

class RepositorioInterpretaciones {
  RepositorioInterpretaciones({
    required this.idPerfil,
    SharedPreferences? preferenciasInyectadas,
    DateTime Function()? relojInyectado,
  })  : _preferenciasInyectadas = preferenciasInyectadas,
        _reloj = relojInyectado ?? DateTime.now;

  final String idPerfil;
  final SharedPreferences? _preferenciasInyectadas;
  final DateTime Function() _reloj;

  String get _clave =>
      'nuevoser.descifrador.perfil.$idPerfil.interpretaciones';

  Future<SharedPreferences> _preferencias() async {
    return _preferenciasInyectadas ?? await SharedPreferences.getInstance();
  }

  Future<InterpretacionesPropuestas> cargar() async {
    final preferencias = await _preferencias();
    final json = preferencias.getString(_clave);
    if (json == null || json.isEmpty) {
      return InterpretacionesPropuestas.inicial();
    }
    try {
      final mapa = jsonDecode(json) as Map<String, dynamic>;
      return InterpretacionesPropuestas.deserializar(mapa);
    } catch (_) {
      return InterpretacionesPropuestas.inicial();
    }
  }

  Future<void> guardar(InterpretacionesPropuestas interpretaciones) async {
    final preferencias = await _preferencias();
    await preferencias.setString(
      _clave,
      jsonEncode(interpretaciones.serializar()),
    );
  }

  /// Conveniencia: registra (o revisa) una interpretación y persiste.
  Future<InterpretacionesPropuestas> proponerInterpretacion({
    required String idPieza,
    required String texto,
  }) async {
    final actual = await cargar();
    final siguiente = actual.conInterpretacion(
      idPieza: idPieza,
      texto: texto,
      ahora: _reloj(),
    );
    await guardar(siguiente);
    return siguiente;
  }

  Future<void> borrar() async {
    final preferencias = await _preferencias();
    await preferencias.remove(_clave);
  }
}
