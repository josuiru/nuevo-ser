import 'dart:convert';

import 'package:nuevo_ser_core/nuevo_ser_core.dart';

/// Persiste las preguntas que la Cronista ha formulado en la Fase 1
/// de una Brecha. Por perfil.
///
/// Namespace: `<prefijoPerfilActivo>brecha.<id>.preguntas` — un JSON
/// con la lista de strings. Si el JSON se corrompe, [cargar] devuelve
/// lista vacía.
class RepositorioPreguntasBrecha {
  static const String _sufijoBase = 'brecha.';
  static const String _sufijoFinal = '.preguntas';

  final GestorPerfiles _gestor;

  const RepositorioPreguntasBrecha({required GestorPerfiles gestor})
      : _gestor = gestor;

  Future<String> _clave(String idBrecha) async {
    final prefijo = await _gestor.prefijoActivo();
    return '$prefijo$_sufijoBase$idBrecha$_sufijoFinal';
  }

  /// Devuelve la lista de preguntas guardadas para esta Brecha.
  Future<List<String>> cargar(String idBrecha) async {
    final prefs = await _gestor.prefsInicializadas();
    final crudo = prefs.getString(await _clave(idBrecha));
    if (crudo == null || crudo.isEmpty) return const [];
    try {
      final decodificado = jsonDecode(crudo);
      if (decodificado is! List) return const [];
      return decodificado.whereType<String>().toList(growable: false);
    } catch (_) {
      return const [];
    }
  }

  /// Sobreescribe la lista completa. Idempotente.
  Future<void> guardar(String idBrecha, List<String> preguntas) async {
    final prefs = await _gestor.prefsInicializadas();
    await prefs.setString(await _clave(idBrecha), jsonEncode(preguntas));
  }

  /// Borra el blob de preguntas del perfil activo.
  Future<void> borrar(String idBrecha) async {
    final prefs = await _gestor.prefsInicializadas();
    await prefs.remove(await _clave(idBrecha));
  }
}
