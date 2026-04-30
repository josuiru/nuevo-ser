import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// Persiste las preguntas que la Cronista ha formulado en la Fase 1
/// de una Brecha. Vive aquí (no en `RepositorioEstadoBrecha`) porque
/// el conjunto de preguntas crece y mengua, mientras que el estado
/// de fase es un valor escalar.
///
/// Namespace: `nuevoser.lasversiones.brecha.<id>.preguntas` — un
/// JSON con la lista de strings tal como las escribió la Cronista.
/// Si el JSON se corrompe (formato inesperado), [cargar] devuelve
/// lista vacía en lugar de propagar la excepción: una corrupción
/// puntual no debe bloquear la fase y la Cronista podrá reformularlas.
class RepositorioPreguntasBrecha {
  static const String _prefijo = 'nuevoser.lasversiones.brecha.';
  static const String _sufijo = '.preguntas';

  final Future<SharedPreferences> Function() _prefs;

  const RepositorioPreguntasBrecha({
    Future<SharedPreferences> Function() prefs = SharedPreferences.getInstance,
  }) : _prefs = prefs;

  String _clave(String idBrecha) => '$_prefijo$idBrecha$_sufijo';

  /// Devuelve la lista de preguntas guardadas para esta Brecha.
  /// Lista vacía si nunca se guardó nada o si el blob está corrupto.
  Future<List<String>> cargar(String idBrecha) async {
    final prefs = await _prefs();
    final crudo = prefs.getString(_clave(idBrecha));
    if (crudo == null || crudo.isEmpty) return const [];
    try {
      final decodificado = jsonDecode(crudo);
      if (decodificado is! List) return const [];
      return decodificado.whereType<String>().toList(growable: false);
    } catch (_) {
      return const [];
    }
  }

  /// Sobreescribe la lista completa. Idempotente: si la lista no
  /// cambió respecto a lo persistido, igualmente reescribe sin
  /// efectos secundarios.
  Future<void> guardar(String idBrecha, List<String> preguntas) async {
    final prefs = await _prefs();
    await prefs.setString(_clave(idBrecha), jsonEncode(preguntas));
  }

  /// Borra el blob de preguntas. Útil para tests + futuro "empezar
  /// de nuevo" desde Ajustes.
  Future<void> borrar(String idBrecha) async {
    final prefs = await _prefs();
    await prefs.remove(_clave(idBrecha));
  }
}
