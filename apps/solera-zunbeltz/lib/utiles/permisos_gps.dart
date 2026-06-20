import 'package:geolocator/geolocator.dart';

/// Asegura que la ubicación esté habilitada y con permiso concedido.
/// Devuelve `true` si se puede pedir posición. Patrón compartido con el
/// resto de la suite Solera: si el servicio está apagado o el permiso
/// denegado, el caller avisa y deja rellenar las coordenadas a mano.
Future<bool> asegurarPermisoUbicacion() async {
  final servicioActivo = await Geolocator.isLocationServiceEnabled();
  if (!servicioActivo) return false;
  var permiso = await Geolocator.checkPermission();
  if (permiso == LocationPermission.denied) {
    permiso = await Geolocator.requestPermission();
  }
  if (permiso == LocationPermission.denied ||
      permiso == LocationPermission.deniedForever) {
    return false;
  }
  return true;
}
