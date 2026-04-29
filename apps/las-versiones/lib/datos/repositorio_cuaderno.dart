import 'package:shared_preferences/shared_preferences.dart';

/// Persiste qué entradas del Cuaderno ya están escritas. La fuente
/// de verdad del **contenido** (id, fecha, texto) es
/// [CatalogoCuaderno] — este repositorio sólo guarda el conjunto de
/// IDs activos, equivalente a una lista de entradas "ya en el
/// cuaderno".
///
/// Cuando llegue la escritura libre del niño (futuro), este
/// repositorio crece para almacenar también entradas con texto
/// propio. Por ahora todo es read-only desde el catálogo.
///
/// Namespace: `nuevoser.lasversiones.cuaderno.entrada.<id>` (un
/// bool por entrada). Mantengo claves separadas en lugar de un
/// blob JSON para facilitar inspección y para que la app pueda
/// activar entradas individuales sin reescribir todo el almacén.
class RepositorioCuaderno {
  static const String _prefijo = 'nuevoser.lasversiones.cuaderno.entrada.';

  final Future<SharedPreferences> Function() _prefs;

  const RepositorioCuaderno({
    Future<SharedPreferences> Function() prefs = SharedPreferences.getInstance,
  }) : _prefs = prefs;

  String _clave(String idEntrada) => '$_prefijo$idEntrada';

  /// `true` si la entrada está ya en el Cuaderno.
  Future<bool> tieneEntrada(String idEntrada) async {
    final prefs = await _prefs();
    return prefs.getBool(_clave(idEntrada)) ?? false;
  }

  /// Marca la entrada como escrita en el Cuaderno. Idempotente.
  Future<void> registrarEntrada(String idEntrada) async {
    final prefs = await _prefs();
    await prefs.setBool(_clave(idEntrada), true);
  }

  /// IDs de las entradas registradas en este dispositivo. La
  /// pantalla del Cuaderno los cruza con el catálogo para filtrar
  /// la lista a mostrar.
  Future<Set<String>> idsRegistrados() async {
    final prefs = await _prefs();
    final claves = prefs.getKeys();
    final ids = <String>{};
    for (final clave in claves) {
      if (clave.startsWith(_prefijo) && (prefs.getBool(clave) ?? false)) {
        ids.add(clave.substring(_prefijo.length));
      }
    }
    return ids;
  }

  /// Borra todas las entradas registradas. Tests + futuro
  /// "empezar de nuevo" desde Ajustes.
  Future<void> borrarTodas() async {
    final prefs = await _prefs();
    final claves = prefs.getKeys().where((k) => k.startsWith(_prefijo)).toList();
    for (final clave in claves) {
      await prefs.remove(clave);
    }
  }
}
