import 'package:el_cuaderno/datos/servicio_geolocalizacion_plugin.dart';
import 'package:el_cuaderno/dominio/geolocalizacion_privacy_first.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart' as geo;

/// Tests del mapeo de permisos. Las funciones nativas del plugin
/// (`Geolocator.checkPermission`, `getCurrentPosition`) NO se ejercitan
/// aquí — son trabajo del smoke manual del operador en dispositivo.
/// La parte del cliente que sí se testea es la traducción de los
/// enums del plugin al contrato `PermisoGeo` del dominio.
void main() {
  group('ServicioGeolocalizacionPlugin.traducirPermiso', () {
    test('LocationPermission.denied → PermisoGeo.denegado', () {
      expect(
        ServicioGeolocalizacionPlugin.traducirPermisoParaTest(
          geo.LocationPermission.denied,
        ),
        PermisoGeo.denegado,
      );
    });

    test('LocationPermission.deniedForever → PermisoGeo.denegadoPermanente',
        () {
      expect(
        ServicioGeolocalizacionPlugin.traducirPermisoParaTest(
          geo.LocationPermission.deniedForever,
        ),
        PermisoGeo.denegadoPermanente,
      );
    });

    test('LocationPermission.whileInUse → PermisoGeo.concedido', () {
      expect(
        ServicioGeolocalizacionPlugin.traducirPermisoParaTest(
          geo.LocationPermission.whileInUse,
        ),
        PermisoGeo.concedido,
      );
    });

    test('LocationPermission.always → PermisoGeo.concedido', () {
      // El juego pide solo "while in use", pero si el dispositivo
      // entrega "always" lo trata como concedido. El cliente no
      // distingue — la biblia §2.1 prohíbe tracking continuo y la app
      // no se subscribe a getPositionStream, así que da igual el alcance
      // que el SO conceda.
      expect(
        ServicioGeolocalizacionPlugin.traducirPermisoParaTest(
          geo.LocationPermission.always,
        ),
        PermisoGeo.concedido,
      );
    });

    test('LocationPermission.unableToDetermine → PermisoGeo.noSolicitado',
        () {
      expect(
        ServicioGeolocalizacionPlugin.traducirPermisoParaTest(
          geo.LocationPermission.unableToDetermine,
        ),
        PermisoGeo.noSolicitado,
      );
    });
  });
}
