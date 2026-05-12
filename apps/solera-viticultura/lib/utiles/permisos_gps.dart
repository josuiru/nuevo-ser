import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

/// Asegura que la ubicación esté habilitada y que el usuario haya
/// concedido el permiso. Devuelve true si se puede pedir posición.
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

Future<bool> asegurarPermisoNotificaciones() async {
  final estado = await Permission.notification.status;
  if (estado.isDenied) {
    final nuevo = await Permission.notification.request();
    return nuevo.isGranted;
  }
  return estado.isGranted;
}
