import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// Persiste las respuestas del Mosaico de un arco. Una clave por
/// arco, blob JSON `{idPrompt: textoRespuesta, …}`. Cuando el
/// cliente companion (`POST /companion/mosaicos`) se cablee, este
/// blob será el `content_meta` que sube al backend; mientras tanto
/// vive sólo en local.
///
/// Namespace: `nuevoser.lasversiones.mosaico.<idArco>` con string.
class RepositorioMosaico {
  static const String _prefijo = 'nuevoser.lasversiones.mosaico.';

  final Future<SharedPreferences> Function() _prefs;

  const RepositorioMosaico({
    Future<SharedPreferences> Function() prefs = SharedPreferences.getInstance,
  }) : _prefs = prefs;

  String _clave(String idArco) => '$_prefijo$idArco';

  /// Mapa idPrompt → textoRespuesta. Vacío si no hay nada o si el
  /// blob no se puede deserializar.
  Future<Map<String, String>> cargar(String idArco) async {
    final prefs = await _prefs();
    final crudo = prefs.getString(_clave(idArco));
    if (crudo == null || crudo.isEmpty) return const {};
    try {
      final mapa = jsonDecode(crudo);
      if (mapa is! Map) return const {};
      final resultado = <String, String>{};
      mapa.forEach((clave, valor) {
        if (clave is String && valor is String) {
          resultado[clave] = valor;
        }
      });
      return resultado;
    } catch (_) {
      return const {};
    }
  }

  /// Sobreescribe el mapa completo. Idempotente.
  Future<void> guardar(String idArco, Map<String, String> respuestas) async {
    final prefs = await _prefs();
    await prefs.setString(_clave(idArco), jsonEncode(respuestas));
  }

  /// Borra el blob del Mosaico. Tests + futuro "rehacer este
  /// Mosaico" desde Ajustes.
  Future<void> borrar(String idArco) async {
    final prefs = await _prefs();
    await prefs.remove(_clave(idArco));
  }
}
