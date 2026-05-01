import 'package:shared_preferences/shared_preferences.dart';

/// Bool global "el adulto ha activado el mapa online provisional".
///
/// **Por qué un opt-in y no un toggle invisible** (biblia §2.9 sin
/// extracción + §2.8 offline-first): los tiles de OpenStreetMap viajan
/// por HTTP — cada request revela al servidor de tiles la zona del
/// mundo que el niño está mirando. La versión definitiva del mapa
/// bajará a MBTiles offline (B5, decisión humana sobre proveedor de
/// tiles + política offline). Hasta que entre, el mapa online es un
/// **fallback de experto** que NO se monta a menos que el adulto lo
/// active conscientemente con copy explícito que diga qué implica.
///
/// Global y no por-perfil: la decisión la toma el adulto del
/// dispositivo, igual que la presentación pedagógica del sit spot, y
/// se aplica al niño activo y a hermanos potenciales del futuro.
///
/// API mínima: `cargar` (default `false`) / `activar` / `desactivar` /
/// `borrar` (este último para tests + para el flujo "borrar mi
/// cuaderno" si se decide reset también del opt-in).
class RepositorioMapaOnlineOptIn {
  RepositorioMapaOnlineOptIn({
    required Future<SharedPreferences> Function() prefs,
    String clave = 'nuevoser.elcuaderno.mapa_online_opt_in',
  })  : _prefs = prefs,
        _clave = clave;

  final Future<SharedPreferences> Function() _prefs;
  final String _clave;

  Future<bool> cargar() async {
    final prefs = await _prefs();
    return prefs.getBool(_clave) ?? false;
  }

  Future<void> activar() async {
    final prefs = await _prefs();
    await prefs.setBool(_clave, true);
  }

  Future<void> desactivar() async {
    final prefs = await _prefs();
    await prefs.setBool(_clave, false);
  }

  Future<void> borrar() async {
    final prefs = await _prefs();
    await prefs.remove(_clave);
  }
}
