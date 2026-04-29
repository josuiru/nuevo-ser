import 'package:shared_preferences/shared_preferences.dart';

/// Persistencia del aviso "¿quieres descargar el paquete sonoro?": un
/// bool global que vale `false` mientras el banner debe mostrarse y
/// pasa a `true` en cuanto el niño/adulto cierra la sugerencia (acepte
/// o rechace).
///
/// Una vez visto, NO se desmarca: rechazar el banner no debe acabar
/// reapareciendo en el siguiente arranque. Si en el futuro un juego
/// quiere reofrecerlo (p. ej. tras una actualización mayor del
/// paquete), bastará con llamar a [borrar] desde su pantalla de
/// ajustes.
///
/// Es **global** (no por-perfil): no tiene sentido reofrecerlo por
/// cada hermano del dispositivo cuando los OGG son los mismos para
/// todos.
///
/// Mismo patrón de callbacks invertidos que el resto de pequeños
/// repositorios del core: recibe `prefs` y la `clave` explícita, así
/// cada juego decide su namespace (`uroto.audio.sugerencia_vista`,
/// `nuevoser.lasversiones.audio.sugerencia_vista`…).
class RepositorioSugerenciaPaqueteAudio {
  RepositorioSugerenciaPaqueteAudio({
    required this.prefs,
    required this.clave,
  });

  final Future<SharedPreferences> Function() prefs;
  final String clave;

  /// `true` si el banner ya se mostró al menos una vez. `false` si
  /// nunca se ha mostrado todavía (o si se ha llamado a [borrar] para
  /// reofrecerlo).
  Future<bool> cargar() async {
    final almacen = await prefs();
    return almacen.getBool(clave) ?? false;
  }

  /// Marca el banner como visto. Idempotente: llamarlo dos veces deja
  /// el estado igual.
  Future<void> marcar() async {
    final almacen = await prefs();
    await almacen.setBool(clave, true);
  }

  /// Vuelve al estado de "no visto", útil para reofrecer el banner
  /// (p. ej. tras una actualización mayor del paquete) o para tests.
  Future<void> borrar() async {
    final almacen = await prefs();
    await almacen.remove(clave);
  }
}
