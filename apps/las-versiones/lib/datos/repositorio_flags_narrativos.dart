import 'package:shared_preferences/shared_preferences.dart';

/// Flags narrativos persistidos del juego — los hitos de cinemática
/// vistos, las elecciones tomadas, los rangos alcanzados. Cada flag
/// es un booleano global (no por-perfil): el dispositivo guarda lo
/// que la Cronista de este aparato ha vivido.
///
/// Cuando llegue el sistema de perfiles (decisión pendiente, ver
/// `apps/las-versiones/CLAUDE.md`) los flags pasarán a vivir bajo
/// el prefijo del perfil activo, igual que en Uno Roto. Hoy son
/// globales para mantener el esqueleto pequeño.
///
/// El namespace `nuevoser.lasversiones.flag.<nombre>` sigue la
/// convención del CLAUDE.md raíz para juegos nuevos.
class RepositorioFlagsNarrativos {
  static const String _prefijo = 'nuevoser.lasversiones.flag.';

  final Future<SharedPreferences> Function() _prefs;

  const RepositorioFlagsNarrativos({
    Future<SharedPreferences> Function() prefs = SharedPreferences.getInstance,
  }) : _prefs = prefs;

  String _clave(String flag) => '$_prefijo$flag';

  /// `true` si el flag está activo en este dispositivo.
  Future<bool> estaActivo(String flag) async {
    final prefs = await _prefs();
    return prefs.getBool(_clave(flag)) ?? false;
  }

  /// Activa el flag. Idempotente.
  Future<void> activar(String flag) async {
    final prefs = await _prefs();
    await prefs.setBool(_clave(flag), true);
  }

  /// Conjunto de flags actualmente activos. Útil para que el
  /// orquestador resuelva precondiciones (`flagsRequeridos` de
  /// `EscenaCinematica`).
  Future<Set<String>> activos() async {
    final prefs = await _prefs();
    final claves = prefs.getKeys();
    final activos = <String>{};
    for (final clave in claves) {
      if (clave.startsWith(_prefijo) && (prefs.getBool(clave) ?? false)) {
        activos.add(clave.substring(_prefijo.length));
      }
    }
    return activos;
  }

  /// Borra todos los flags activos. Útil para tests y, en el futuro,
  /// para una opción de "empezar de nuevo" desde Ajustes.
  Future<void> borrarTodos() async {
    final prefs = await _prefs();
    final claves = prefs.getKeys().where((k) => k.startsWith(_prefijo)).toList();
    for (final clave in claves) {
      await prefs.remove(clave);
    }
  }
}
