import 'package:shared_preferences/shared_preferences.dart';

/// Persistencia del código de idioma elegido manualmente por el niño
/// en la pantalla de configuración inicial.
///
/// Es **global** (no por-perfil): la elección se hace antes de
/// cualquier perfil, en cuanto la app arranca por primera vez. El
/// orquestador del juego lee esto al inicio para decidir si mostrar
/// la pantalla de selección de idioma; un valor `null` significa
/// "primer arranque, todavía no se ha elegido".
///
/// El repositorio NO valida los códigos: cada juego decide qué
/// idiomas soporta (Uno Roto: `'es' | 'eu' | 'ca'`; Las Versiones
/// puede tener un set distinto). Sólo se persiste y se lee la cadena
/// tal cual.
///
/// Mismo patrón de callbacks invertidos que [RepositorioCuentaBackend]:
/// recibe `prefs` y la `clave` explícita, así cada juego decide su
/// namespace (`uroto.idioma_app`, `nuevoser.lasversiones.idioma_app`…).
class RepositorioIdiomaApp {
  RepositorioIdiomaApp({
    required this.prefs,
    required this.clave,
  });

  final Future<SharedPreferences> Function() prefs;
  final String clave;

  Future<String?> cargar() async {
    final almacen = await prefs();
    return almacen.getString(clave);
  }

  Future<void> guardar(String codigoIdioma) async {
    final almacen = await prefs();
    await almacen.setString(clave, codigoIdioma);
  }

  /// Borra la elección — el siguiente arranque lo tratará como
  /// "primer arranque" y volverá a mostrar la pantalla de selección.
  /// Útil para tests, debug y si en el futuro un juego ofrece "cambiar
  /// idioma desde Ajustes".
  Future<void> borrar() async {
    final almacen = await prefs();
    await almacen.remove(clave);
  }
}
