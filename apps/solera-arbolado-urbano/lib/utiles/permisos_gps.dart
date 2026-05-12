import 'package:geolocator/geolocator.dart';

Future<bool> asegurarPermisoUbicacion() async {
  final servicioActivo = await Geolocator.isLocationServiceEnabled();
  if (!servicioActivo) return false;
  var permiso = await Geolocator.checkPermission();
  if (permiso == LocationPermission.denied) {
    permiso = await Geolocator.requestPermission();
  }
  if (permiso == LocationPermission.denied || permiso == LocationPermission.deniedForever) {
    return false;
  }
  return true;
}
