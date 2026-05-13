// Repositorio de la localización actual del jugador en el puerto.
//
// Persistencia por perfil en shared_preferences:
//   nuevoser.descifrador.perfil.<id>.localizacion

import 'package:shared_preferences/shared_preferences.dart';

import '../dominio/localizacion.dart';

class RepositorioLocalizacion {
  RepositorioLocalizacion({
    required this.idPerfil,
    SharedPreferences? preferenciasInyectadas,
  }) : _preferenciasInyectadas = preferenciasInyectadas;

  final String idPerfil;
  final SharedPreferences? _preferenciasInyectadas;

  String get _clave => 'nuevoser.descifrador.perfil.$idPerfil.localizacion';

  Future<SharedPreferences> _preferencias() async {
    return _preferenciasInyectadas ?? await SharedPreferences.getInstance();
  }

  /// Carga la última localización. Si nunca se guardó, devuelve la
  /// oficina (default donde el aprendiz arranca su jornada).
  Future<Localizacion> cargar() async {
    final preferencias = await _preferencias();
    final identificador = preferencias.getString(_clave);
    if (identificador == null) return Localizacion.oficina;
    try {
      return Localizacion.desdeIdentificador(identificador);
    } on ArgumentError {
      return Localizacion.oficina;
    }
  }

  Future<void> guardar(Localizacion localizacion) async {
    final preferencias = await _preferencias();
    await preferencias.setString(_clave, localizacion.identificadorTecnico);
  }

  Future<void> borrar() async {
    final preferencias = await _preferencias();
    await preferencias.remove(_clave);
  }
}
