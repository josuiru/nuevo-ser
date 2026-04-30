import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart' as geo;

import '../dominio/geolocalizacion_privacy_first.dart';
import '../dominio/observacion.dart' show Coordenadas;

/// Implementación concreta de [ServicioGeolocalizacion] sobre el
/// plugin `geolocator` (B5 — fallback de experto pendiente de QA del
/// operador en dispositivos reales y de la decisión humana sobre
/// `flutter_map` + MBTiles).
///
/// Diseño:
/// - **Lectura puntual** (`getCurrentPosition`). NO se subscribe a
///   `getPositionStream`: la biblia §2.1 prohíbe tracking continuo.
/// - **Permiso "solo en uso"**, nunca background. El plugin lo pide
///   automáticamente en Android e iOS sin que tengamos que distinguir.
/// - **Precisión media** por defecto (~10 m): suficiente para "¿estás
///   en tu sit spot?" con radio 50 m, y consume mucho menos batería
///   que `LocationAccuracy.best` (~3 m). El niño no necesita saber
///   dónde está con precisión submétrica — el lugar es el que es.
/// - **Tiempo de espera explícito**: si el GPS no responde en
///   [tiempoEspera] segundos, devolvemos `null`. La pantalla cae al
///   modo manual con `place_name` escrito a mano. Mejor decirle "no
///   te localizo, dime tú" que dejarle esperando.
/// - **Tradución de los enums del plugin a [PermisoGeo]**: el plugin
///   distingue `denied` (puede volver a pedirse) de `deniedForever`
///   (el sistema operativo bloquea futuras solicitudes); el contrato
///   del juego mantiene esa distinción para que la UI dirija al niño
///   a Ajustes del sistema cuando proceda.
///
/// Tests del cliente puro (lógica de mapeo, fallback temporal) van
/// en `test/datos/`. Las llamadas al plugin nativo NO se ejercitan
/// en CI — son trabajo del smoke manual del operador en dispositivo.
class ServicioGeolocalizacionPlugin implements ServicioGeolocalizacion {
  ServicioGeolocalizacionPlugin({
    geo.LocationAccuracy precision = geo.LocationAccuracy.medium,
  }) : _precision = precision;

  final geo.LocationAccuracy _precision;

  @override
  Future<PermisoGeo> permiso() async {
    final habilitado = await geo.Geolocator.isLocationServiceEnabled();
    if (!habilitado) return PermisoGeo.denegado;
    final estado = await geo.Geolocator.checkPermission();
    return _traducirPermiso(estado);
  }

  @override
  Future<PermisoGeo> pedirPermiso() async {
    final habilitado = await geo.Geolocator.isLocationServiceEnabled();
    if (!habilitado) return PermisoGeo.denegado;
    var estado = await geo.Geolocator.checkPermission();
    if (estado == geo.LocationPermission.denied) {
      estado = await geo.Geolocator.requestPermission();
    }
    return _traducirPermiso(estado);
  }

  @override
  Future<Coordenadas?> coordenadasActuales({
    Duration tiempoEspera = const Duration(seconds: 8),
  }) async {
    final estado = await permiso();
    if (estado != PermisoGeo.concedido) return null;
    try {
      final posicion = await geo.Geolocator.getCurrentPosition(
        desiredAccuracy: _precision,
        timeLimit: tiempoEspera,
      );
      return Coordenadas(lat: posicion.latitude, lng: posicion.longitude);
    } catch (_) {
      // Cualquier excepción del plugin (timeout, GPS deshabilitado a
      // mitad de petición, permiso revocado en vivo) la tratamos como
      // "no consigo localizarte". La UI cae al modo manual.
      return null;
    }
  }

  @visibleForTesting
  static PermisoGeo traducirPermisoParaTest(geo.LocationPermission permiso) =>
      _traducirPermiso(permiso);

  static PermisoGeo _traducirPermiso(geo.LocationPermission permiso) {
    switch (permiso) {
      case geo.LocationPermission.denied:
        return PermisoGeo.denegado;
      case geo.LocationPermission.deniedForever:
        return PermisoGeo.denegadoPermanente;
      case geo.LocationPermission.whileInUse:
      case geo.LocationPermission.always:
        return PermisoGeo.concedido;
      case geo.LocationPermission.unableToDetermine:
        return PermisoGeo.noSolicitado;
    }
  }
}
