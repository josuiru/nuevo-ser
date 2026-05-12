import 'package:shared_preferences/shared_preferences.dart';

/// Persistencia de la clave Anthropic del usuario. **Solo local** —
/// nunca sale a ningún servidor de Solera. Las llamadas a la API de
/// Anthropic se hacen directamente desde el dispositivo del usuario.
///
/// Modelo "BYO key" típico de apps que usan IA en v1 sin backend
/// propio. Cuando llegue F4 (backend nube), la opción será
/// centralizar y cobrar por uso, pero esto requiere infraestructura
/// adicional y monetización ya cerrada.
class ClaveAnthropic {
  static const _claveStorage = 'agro.anthropic.clave';

  Future<String?> cargar() async {
    final prefs = await SharedPreferences.getInstance();
    final clave = prefs.getString(_claveStorage);
    if (clave == null || clave.trim().isEmpty) return null;
    return clave.trim();
  }

  Future<void> guardar(String clave) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_claveStorage, clave.trim());
  }

  Future<void> borrar() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_claveStorage);
  }

  Future<bool> tieneClave() async {
    final clave = await cargar();
    return clave != null && clave.length >= 16;
  }
}
