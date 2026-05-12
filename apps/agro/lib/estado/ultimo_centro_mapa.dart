import 'package:shared_preferences/shared_preferences.dart';

/// Persistencia del último centro de mapa visualizado, para que la
/// próxima apertura arranque ahí (instantáneo, sin esperar al fix
/// GPS). Se actualiza ante cualquier cambio relevante (resolver GPS,
/// abrir ficha de planta, etc.). Si no hay valor guardado se cae al
/// centro de Iberia como ya hacía la pantalla mapa.
class UltimoCentroMapa {
  static const _claveLat = 'agro.mapa.ultimo_lat';
  static const _claveLon = 'agro.mapa.ultimo_lon';
  static const _claveZoom = 'agro.mapa.ultimo_zoom';

  Future<({double latitud, double longitud, double zoom})?> cargar() async {
    final prefs = await SharedPreferences.getInstance();
    final lat = prefs.getDouble(_claveLat);
    final lon = prefs.getDouble(_claveLon);
    if (lat == null || lon == null) return null;
    final zoom = prefs.getDouble(_claveZoom) ?? 16.0;
    return (latitud: lat, longitud: lon, zoom: zoom);
  }

  Future<void> guardar({required double latitud, required double longitud, required double zoom}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_claveLat, latitud);
    await prefs.setDouble(_claveLon, longitud);
    await prefs.setDouble(_claveZoom, zoom);
  }
}
