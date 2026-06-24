import 'package:shared_preferences/shared_preferences.dart';

/// Destino del coordinador para el envío de informes (opción B, sin backend):
/// un correo configurable al que el testador manda sus PDF/CSV desde el menú
/// de compartir del dispositivo. Persistencia local con prefijo `zunbeltz.*`.
class Coordinador {
  static const _clave = 'zunbeltz.coordinador_email';

  static Future<String> cargarCorreo() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_clave) ?? '';
  }

  static Future<void> guardarCorreo(String correo) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_clave, correo.trim());
  }
}
