import 'package:nuevo_ser_core/nuevo_ser_core.dart';

import '../dominio/brecha.dart';

/// Persiste el estado de progreso de cada Brecha — qué fase está
/// activa para que la Cronista pueda dejarla y volver más tarde sin
/// perder el sitio. Por perfil.
///
/// Namespace: `<prefijoPerfilActivo>brecha.<id>.fase`. La Brecha
/// completa se marca en `RepositorioFlagsNarrativos` con el flag
/// `brecha_<id>_completada`, no aquí — esta clase sólo guarda fase
/// intermedia.
class RepositorioEstadoBrecha {
  static const String _sufijo = 'brecha.';

  final GestorPerfiles _gestor;

  const RepositorioEstadoBrecha({required GestorPerfiles gestor})
      : _gestor = gestor;

  Future<String> _claveFase(String idBrecha) async {
    final prefijo = await _gestor.prefijoActivo();
    return '$prefijo$_sufijo$idBrecha.fase';
  }

  /// Devuelve la fase activa de la Brecha o `null` si no se ha
  /// abierto todavía.
  Future<FaseBrecha?> faseActiva(String idBrecha) async {
    final prefs = await _gestor.prefsInicializadas();
    final nombre = prefs.getString(await _claveFase(idBrecha));
    if (nombre == null) return null;
    for (final fase in FaseBrecha.values) {
      if (fase.name == nombre) return fase;
    }
    return null;
  }

  /// Establece la fase activa.
  Future<void> establecerFase(String idBrecha, FaseBrecha fase) async {
    final prefs = await _gestor.prefsInicializadas();
    await prefs.setString(await _claveFase(idBrecha), fase.name);
  }

  /// Borra el estado de la Brecha.
  Future<void> borrar(String idBrecha) async {
    final prefs = await _gestor.prefsInicializadas();
    await prefs.remove(await _claveFase(idBrecha));
  }
}
