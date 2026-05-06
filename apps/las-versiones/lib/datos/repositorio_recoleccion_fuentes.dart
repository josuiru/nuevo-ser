import 'package:nuevo_ser_core/nuevo_ser_core.dart';

/// Persiste qué fuentes de qué Brecha ha recogido la Cronista en la
/// Fase 2. Una fuente "recogida" pasa a estar disponible en la Mesa
/// de Trabajo (Fase 3). Por perfil.
///
/// Namespace: `<prefijoPerfilActivo>brecha.<id>.fuente.<idFuente>`
/// con bool — una clave por par para facilitar inspección.
class RepositorioRecoleccionFuentes {
  static const String _sufijoBase = 'brecha.';
  static const String _separador = '.fuente.';

  final GestorPerfiles _gestor;

  const RepositorioRecoleccionFuentes({required GestorPerfiles gestor})
      : _gestor = gestor;

  Future<String> _clave(String idBrecha, String idFuente) async {
    final prefijo = await _gestor.prefijoActivo();
    return '$prefijo$_sufijoBase$idBrecha$_separador$idFuente';
  }

  Future<String> _prefijoBrecha(String idBrecha) async {
    final prefijo = await _gestor.prefijoActivo();
    return '$prefijo$_sufijoBase$idBrecha$_separador';
  }

  /// `true` si la fuente está ya recogida en el perfil activo.
  Future<bool> tieneFuente(String idBrecha, String idFuente) async {
    final prefs = await _gestor.prefsInicializadas();
    return prefs.getBool(await _clave(idBrecha, idFuente)) ?? false;
  }

  /// Marca la fuente como recogida. Idempotente.
  Future<void> registrarFuente(String idBrecha, String idFuente) async {
    final prefs = await _gestor.prefsInicializadas();
    await prefs.setBool(await _clave(idBrecha, idFuente), true);
  }

  /// IDs de fuentes recogidas para esta Brecha en el perfil activo.
  Future<Set<String>> idsFuentesRecogidas(String idBrecha) async {
    final prefs = await _gestor.prefsInicializadas();
    final prefijoBrecha = await _prefijoBrecha(idBrecha);
    final claves = prefs.getKeys();
    final ids = <String>{};
    for (final clave in claves) {
      if (clave.startsWith(prefijoBrecha) &&
          (prefs.getBool(clave) ?? false)) {
        ids.add(clave.substring(prefijoBrecha.length));
      }
    }
    return ids;
  }

  /// Borra todas las marcas para esta Brecha del perfil activo.
  Future<void> borrar(String idBrecha) async {
    final prefs = await _gestor.prefsInicializadas();
    final prefijoBrecha = await _prefijoBrecha(idBrecha);
    final claves =
        prefs.getKeys().where((k) => k.startsWith(prefijoBrecha)).toList();
    for (final clave in claves) {
      await prefs.remove(clave);
    }
  }
}
