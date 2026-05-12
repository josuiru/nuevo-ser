import 'package:shared_preferences/shared_preferences.dart';

const String _claveApiKey = 'anthropic_api_key';
const String _claveApiKeyDeepseek = 'deepseek_api_key';
const String _claveModelo = 'modelo_claude';
const String modeloPorDefecto = 'claude-haiku-4-5';

class Configuracion {
  static Future<String> obtenerApiKey() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_claveApiKey) ?? '';
  }

  static Future<String> obtenerApiKeyDeepseek() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_claveApiKeyDeepseek) ?? '';
  }

  static Future<String> obtenerModelo() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_claveModelo) ?? modeloPorDefecto;
  }

  static Future<void> guardarApiKey(String apiKey) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_claveApiKey, apiKey);
  }

  static Future<void> guardarApiKeyDeepseek(String apiKey) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_claveApiKeyDeepseek, apiKey.trim());
  }

  static Future<void> guardarModelo(String modelo) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_claveModelo, modelo);
  }
}
