import 'package:shared_preferences/shared_preferences.dart';

/// El "apiario activo" es el apiario seleccionado en el filtro
/// principal del mapa. Persiste entre arranques. Si vale `null` se
/// muestran todas las colmenas (incluidas las puntuales sin apiario).
class ApiarioActivoPersistido {
  static const _clave = 'solera_apicola.apiario_activo.id';

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
