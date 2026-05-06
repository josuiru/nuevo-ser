import 'package:nuevo_ser_core/nuevo_ser_core.dart';

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
/// Namespace: `<prefijoPerfilActivo>cuaderno.entrada.<id>` (un
/// bool por entrada). Mantengo claves separadas en lugar de un
/// blob JSON para facilitar inspección y para que la app pueda
/// activar entradas individuales sin reescribir todo el almacén.
/// El prefijo de perfil viene del [GestorPerfiles] del core.
class RepositorioCuaderno {
  static const String _sufijo = 'cuaderno.entrada.';

  final GestorPerfiles _gestor;

  const RepositorioCuaderno({required GestorPerfiles gestor})
      : _gestor = gestor;

  Future<String> _claveDe(String idEntrada) async {
    final prefijo = await _gestor.prefijoActivo();
    return '$prefijo$_sufijo$idEntrada';
  }

  /// `true` si la entrada está ya en el Cuaderno.
  Future<bool> tieneEntrada(String idEntrada) async {
    final prefs = await _gestor.prefsInicializadas();
    return prefs.getBool(await _claveDe(idEntrada)) ?? false;
  }

  /// Marca la entrada como escrita en el Cuaderno. Idempotente.
  Future<void> registrarEntrada(String idEntrada) async {
    final prefs = await _gestor.prefsInicializadas();
    await prefs.setBool(await _claveDe(idEntrada), true);
  }

  /// IDs de las entradas registradas en este dispositivo. La
  /// pantalla del Cuaderno los cruza con el catálogo para filtrar
  /// la lista a mostrar.
  Future<Set<String>> idsRegistrados() async {
    final prefs = await _gestor.prefsInicializadas();
    final prefijoCompleto = '${await _gestor.prefijoActivo()}$_sufijo';
    final ids = <String>{};
    for (final clave in prefs.getKeys()) {
      if (clave.startsWith(prefijoCompleto) &&
          (prefs.getBool(clave) ?? false)) {
        ids.add(clave.substring(prefijoCompleto.length));
      }
    }
    return ids;
  }

  /// Borra todas las entradas registradas del perfil activo. Tests
  /// + futuro "empezar de nuevo" desde Ajustes.
  Future<void> borrarTodas() async {
    final prefs = await _gestor.prefsInicializadas();
    final prefijoCompleto = '${await _gestor.prefijoActivo()}$_sufijo';
    final claves = prefs
        .getKeys()
        .where((k) => k.startsWith(prefijoCompleto))
        .toList();
    for (final clave in claves) {
      await prefs.remove(clave);
    }
  }
}
