import 'package:shared_preferences/shared_preferences.dart';

/// Bool global "ya he visto la presentación pedagógica del sit spot".
/// Una vez marcada, no vuelve a aparecer entre el flujo de bienvenida y
/// la pantalla principal.
///
/// Por qué global y no por-perfil: hoy el juego sólo soporta un perfil
/// por dispositivo (la pantalla de bienvenida sólo aparece la primera
/// vez); el flag se acopla a la decisión "ya se conoce el oficio del
/// sit spot en este dispositivo". Si en el futuro se añade soporte
/// multi-perfil real (cambio de hermano), basta con migrar esta clave
/// al patrón `nuevoser.elcuaderno.perfil.<id>.<sufijo>` reutilizando
/// `GestorPerfiles` del core como hace `RepositorioAvatarPerfil`.
///
/// API mínima: cargar (default `false`) / marcar / borrar (este último
/// para tests + para volver a presentar tras un "borrar mi cuaderno").
class RepositorioPresentacionSitSpot {
  RepositorioPresentacionSitSpot({
    required Future<SharedPreferences> Function() prefs,
    String clave = 'nuevoser.elcuaderno.presentacion_sit_spot.vista',
  })  : _prefs = prefs,
        _clave = clave;

  final Future<SharedPreferences> Function() _prefs;
  final String _clave;

  /// `true` si la presentación ya se mostró alguna vez en este
  /// dispositivo. `false` por defecto en el primer arranque.
  Future<bool> cargar() async {
    final prefs = await _prefs();
    return prefs.getBool(_clave) ?? false;
  }

  /// Marca la presentación como vista. Idempotente: una segunda llamada
  /// sigue devolviendo `true` desde [cargar].
  Future<void> marcar() async {
    final prefs = await _prefs();
    await prefs.setBool(_clave, true);
  }

  /// Borra el flag. El siguiente arranque vuelve a mostrar la
  /// presentación. Útil para tests y para el flujo "borrar mi cuaderno"
  /// si en el futuro queremos que el cuaderno re-empiece desde cero.
  Future<void> borrar() async {
    final prefs = await _prefs();
    await prefs.remove(_clave);
  }
}
