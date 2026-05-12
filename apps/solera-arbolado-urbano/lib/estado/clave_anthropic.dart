import 'package:shared_preferences/shared_preferences.dart';

/// Persistencia de la clave Anthropic del operario. **Solo local** —
/// nunca sale a ningún servidor. Modelo BYO key heredado de las
/// hermanas de la suite Solera.
class ClaveAnthropic {
  static const _claveStorage = 'solera_arbolado_urbano.anthropic.clave';

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
