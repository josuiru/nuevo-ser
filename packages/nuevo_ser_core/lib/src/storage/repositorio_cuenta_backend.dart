import 'package:shared_preferences/shared_preferences.dart';

/// Persistencia de la cuenta del backend (plugin `nuevo-ser-core`):
/// token JWT que autentica todas las llamadas REST y email asociado al
/// niño.
///
/// Es **global** (no por-perfil) en todos los juegos de la Colección:
/// la separación lógica entre niños la lleva el backend con el
/// `nino_id` codificado dentro del propio token. Los perfiles locales
/// del juego son una conveniencia del dispositivo; el backend conoce
/// un único niño por sesión.
///
/// El email es informativo (mostrarlo en UI). NUNCA se persiste la
/// contraseña.
///
/// Se construye con un callback [prefs] que devuelve el
/// `SharedPreferences` ya inicializado, y dos claves explícitas — cada
/// juego decide su namespace (`uroto.token_backend` para Uno Roto,
/// `nuevoser.lasversiones.token_backend` para Las Versiones, etc.).
/// El repositorio no asume nada del prefijo.
class RepositorioCuentaBackend {
  RepositorioCuentaBackend({
    required this.prefs,
    required this.claveToken,
    required this.claveEmail,
  });

  /// Acceso diferido al `SharedPreferences` para no obligar al
  /// constructor a ser asíncrono ni a recibir la instancia ya resuelta.
  final Future<SharedPreferences> Function() prefs;

  /// Clave de prefs donde se guarda el token JWT.
  final String claveToken;

  /// Clave de prefs donde se guarda el email asociado al token.
  final String claveEmail;

  Future<String?> cargarToken() async {
    final almacen = await prefs();
    return almacen.getString(claveToken);
  }

  Future<void> guardarToken(String token) async {
    final almacen = await prefs();
    await almacen.setString(claveToken, token);
  }

  Future<void> borrarToken() async {
    final almacen = await prefs();
    await almacen.remove(claveToken);
  }

  Future<String?> cargarEmail() async {
    final almacen = await prefs();
    return almacen.getString(claveEmail);
  }

  Future<void> guardarEmail(String email) async {
    final almacen = await prefs();
    await almacen.setString(claveEmail, email);
  }

  Future<void> borrarEmail() async {
    final almacen = await prefs();
    await almacen.remove(claveEmail);
  }

  /// Atajo: borra token y email a la vez. Equivale a "cerrar sesión".
  Future<void> cerrarSesion() async {
    await borrarToken();
    await borrarEmail();
  }
}
