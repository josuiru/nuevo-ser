import 'package:shared_preferences/shared_preferences.dart';

/// Persiste qué fuentes de qué Brecha ha recogido la Cronista en la
/// Fase 2. Una fuente "recogida" pasa a estar disponible en la Mesa
/// de Trabajo (Fase 3) — el repositorio sólo guarda IDs activos por
/// brecha, no toca el contenido (que vive en el catálogo).
///
/// Namespace: `nuevoser.lasversiones.brecha.<id>.fuente.<idFuente>`
/// con bool. Una clave por par (brecha, fuente) en lugar de un blob
/// JSON por brecha — facilita inspección y reactivación individual,
/// igual que `RepositorioCuaderno`.
class RepositorioRecoleccionFuentes {
  static const String _prefijo = 'nuevoser.lasversiones.brecha.';
  static const String _separador = '.fuente.';

  final Future<SharedPreferences> Function() _prefs;

  const RepositorioRecoleccionFuentes({
    Future<SharedPreferences> Function() prefs = SharedPreferences.getInstance,
  }) : _prefs = prefs;

  String _clave(String idBrecha, String idFuente) =>
      '$_prefijo$idBrecha$_separador$idFuente';

  String _prefijoBrecha(String idBrecha) =>
      '$_prefijo$idBrecha$_separador';

  /// `true` si la fuente está ya recogida.
  Future<bool> tieneFuente(String idBrecha, String idFuente) async {
    final prefs = await _prefs();
    return prefs.getBool(_clave(idBrecha, idFuente)) ?? false;
  }

  /// Marca la fuente como recogida. Idempotente.
  Future<void> registrarFuente(String idBrecha, String idFuente) async {
    final prefs = await _prefs();
    await prefs.setBool(_clave(idBrecha, idFuente), true);
  }

  /// IDs de fuentes recogidas para esta Brecha. La pantalla de
  /// recolección lo cruza con el catálogo `Brecha.fuentes` para
  /// pintar las que ya están en la Mesa.
  Future<Set<String>> idsFuentesRecogidas(String idBrecha) async {
    final prefs = await _prefs();
    final prefijoBrecha = _prefijoBrecha(idBrecha);
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

  /// Borra todas las marcas para esta Brecha. Útil para tests +
  /// futuro "rehacer la Brecha" desde Ajustes.
  Future<void> borrar(String idBrecha) async {
    final prefs = await _prefs();
    final prefijoBrecha = _prefijoBrecha(idBrecha);
    final claves =
        prefs.getKeys().where((k) => k.startsWith(prefijoBrecha)).toList();
    for (final clave in claves) {
      await prefs.remove(clave);
    }
  }
}
