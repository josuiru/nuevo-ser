import 'package:shared_preferences/shared_preferences.dart';

/// La "finca activa" es la finca seleccionada en el filtro principal.
/// Persiste entre arranques en SharedPreferences. Si vale `null` la
/// pantalla de mapa muestra todas las plantas (incluidos puntos
/// sueltos); si tiene valor, sólo las de esa finca.
///
/// Está separado del modelo `Finca` porque es estado de UI/preferencia,
/// no un dato del dominio.
class FincaActivaPersistida {
  static const _clave = 'agro.finca_activa.id';

  Future<int?> cargar() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_clave);
  }

  Future<void> guardar(int? id) async {
    final prefs = await SharedPreferences.getInstance();
    if (id == null) {
      await prefs.remove(_clave);
    } else {
      await prefs.setInt(_clave, id);
    }
  }
}
