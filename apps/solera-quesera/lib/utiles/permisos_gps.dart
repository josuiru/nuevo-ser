import 'package:geolocator/geolocator.dart';

/// Solicita permiso de ubicación (solo mientras la app está en uso).
/// Devuelve `true` si el permiso está concedido.
Future<bool> asegurarPermisoUbicacion() async {
  var estado = await Geolocator.checkPermission();
  if (estado == LocationPermission.denied) {
    estado = await Geolocator.requestPermission();
  }
  return estado == LocationPermission.whileInUse ||
      estado == LocationPermission.always;
}

/// Obtiene la última posición conocida (rápido, puede ser null).
Future<Position?> ultimaPosicion() async {
  try {
    return await Geolocator.getLastKnownPosition();
  } catch (_) {
    return null;
  }
}
