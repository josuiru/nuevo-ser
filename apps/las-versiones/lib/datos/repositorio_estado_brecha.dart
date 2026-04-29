import 'package:shared_preferences/shared_preferences.dart';

import '../dominio/brecha.dart';

/// Persiste el estado de progreso de cada Brecha — qué fase está
/// activa para que la Cronista pueda dejarla y volver más tarde sin
/// perder el sitio.
///
/// Sigue el namespace `nuevoser.lasversiones.brecha.<id>.fase`
/// previsto por el CLAUDE.md raíz. Cuando se abra la Brecha por
/// primera vez la fase es `formulacionPreguntas`; el orquestador
/// avanza con `pasarASiguienteFase` cuando cada fase se completa.
///
/// La Brecha completa se marca en `RepositorioFlagsNarrativos` con
/// el flag `brecha_<id>_completada`, no aquí — esta clase sólo
/// guarda fase intermedia. Al completar el Concilio, el orquestador
/// borra la fase activa (la Brecha cerrada no necesita estado).
class RepositorioEstadoBrecha {
  static const String _prefijo = 'nuevoser.lasversiones.brecha.';

  final Future<SharedPreferences> Function() _prefs;

  const RepositorioEstadoBrecha({
    Future<SharedPreferences> Function() prefs = SharedPreferences.getInstance,
  }) : _prefs = prefs;

  String _claveFase(String idBrecha) => '$_prefijo$idBrecha.fase';

  /// Devuelve la fase activa de la Brecha o `null` si no se ha
  /// abierto todavía. El orquestador usa `null` como señal para
  /// arrancarla en `formulacionPreguntas` (fase inicial).
  Future<FaseBrecha?> faseActiva(String idBrecha) async {
    final prefs = await _prefs();
    final nombre = prefs.getString(_claveFase(idBrecha));
    if (nombre == null) return null;
    for (final fase in FaseBrecha.values) {
      if (fase.name == nombre) return fase;
    }
    // Valor desconocido (corrupción, downgrade) — empezar de nuevo.
    return null;
  }

  /// Establece la fase activa. Se persiste por `name` del enum para
  /// que el almacén sea legible en debug y para que añadir nuevos
  /// valores no rompa los antiguos (los desconocidos se ignoran y
  /// se reinicia limpio).
  Future<void> establecerFase(String idBrecha, FaseBrecha fase) async {
    final prefs = await _prefs();
    await prefs.setString(_claveFase(idBrecha), fase.name);
  }

  /// Borra el estado de la Brecha — útil al cerrar el Concilio
  /// (la Brecha completa no necesita fase) y para tests.
  Future<void> borrar(String idBrecha) async {
    final prefs = await _prefs();
    await prefs.remove(_claveFase(idBrecha));
  }
}
