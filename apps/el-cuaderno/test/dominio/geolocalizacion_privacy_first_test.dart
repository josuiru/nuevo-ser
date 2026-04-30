import 'package:el_cuaderno/dominio/geolocalizacion_privacy_first.dart';
import 'package:el_cuaderno/dominio/observacion.dart' show Coordenadas;
import 'package:el_cuaderno/dominio/sit_spot.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('distanciaMetros (Haversine)', () {
    test('distancia cero entre el mismo punto', () {
      const punto = Coordenadas(lat: 42.8125, lng: -1.6458);
      expect(distanciaMetros(punto, punto), closeTo(0, 0.001));
    });

    test('Pamplona ↔ Madrid ≈ 317 km (gran círculo)', () {
      // Centro de Pamplona vs Puerta del Sol. La distancia ortodrómica
      // ronda los 316.5 km — la distancia "por carretera" es mayor,
      // pero Haversine mide línea recta sobre la esfera.
      const pamplona = Coordenadas(lat: 42.8125, lng: -1.6458);
      const madrid = Coordenadas(lat: 40.4168, lng: -3.7038);
      final metros = distanciaMetros(pamplona, madrid);
      expect(metros, closeTo(316500, 1000));
    });

    test('1 grado de latitud en el ecuador ≈ 111 km', () {
      const a = Coordenadas(lat: 0, lng: 0);
      const b = Coordenadas(lat: 1, lng: 0);
      final metros = distanciaMetros(a, b);
      expect(metros, closeTo(111195, 50));
    });

    test('simetría: a→b == b→a', () {
      const a = Coordenadas(lat: 42.81, lng: -1.65);
      const b = Coordenadas(lat: 42.82, lng: -1.66);
      expect(
        distanciaMetros(a, b),
        closeTo(distanciaMetros(b, a), 0.0001),
      );
    });
  });

  group('estaEnSitSpot', () {
    final sitSpotConCoords = SitSpot(
      id: 'sp-1',
      nombre: 'El Roble Grande',
      dondeNombre: 'parque cerca de casa',
      creadoEn: DateTime(2026, 4, 1),
      coordenadas: const Coordenadas(lat: 42.8125, lng: -1.6458),
    );

    final sitSpotSinCoords = SitSpot(
      id: 'sp-2',
      nombre: 'Mi banco',
      dondeNombre: 'al final del parque',
      creadoEn: DateTime(2026, 4, 1),
    );

    test('false si el sit spot no tiene coordenadas registradas', () {
      const ahora = Coordenadas(lat: 42.8125, lng: -1.6458);
      expect(estaEnSitSpot(ahora, sitSpotSinCoords), isFalse);
    });

    test('true cuando estoy exactamente sobre el centro', () {
      const ahora = Coordenadas(lat: 42.8125, lng: -1.6458);
      expect(estaEnSitSpot(ahora, sitSpotConCoords), isTrue);
    });

    test('true a 30 m del centro (radio default 50 m)', () {
      // ~30 m al norte: ~0.00027 grados de latitud.
      const ahora = Coordenadas(lat: 42.81277, lng: -1.6458);
      expect(estaEnSitSpot(ahora, sitSpotConCoords), isTrue);
    });

    test('false a más de 50 m del centro', () {
      // ~110 m al norte: ~0.001 grados de latitud.
      const ahora = Coordenadas(lat: 42.8135, lng: -1.6458);
      expect(estaEnSitSpot(ahora, sitSpotConCoords), isFalse);
    });

    test('radio personalizable: 200 m abre el círculo', () {
      const ahora = Coordenadas(lat: 42.8135, lng: -1.6458);
      expect(
        estaEnSitSpot(ahora, sitSpotConCoords, radioMetros: 200),
        isTrue,
      );
    });
  });

  group('normalizarRegion', () {
    test('Pamplona → ES-NA-PA (más específico que ES-NA)', () {
      const centroPamplona = Coordenadas(lat: 42.8125, lng: -1.6458);
      expect(normalizarRegion(centroPamplona), 'ES-NA-PA');
    });

    test('Tudela → ES-NA (Navarra fuera de Pamplona)', () {
      const tudela = Coordenadas(lat: 42.0633, lng: -1.6066);
      expect(normalizarRegion(tudela), 'ES-NA');
    });

    test('Bilbao → ES-BI', () {
      const bilbao = Coordenadas(lat: 43.2630, lng: -2.9350);
      expect(normalizarRegion(bilbao), 'ES-BI');
    });

    test('Madrid → ES-MD', () {
      const madrid = Coordenadas(lat: 40.4168, lng: -3.7038);
      expect(normalizarRegion(madrid), 'ES-MD');
    });

    test('Barcelona → ES-BCN', () {
      const barcelona = Coordenadas(lat: 41.3851, lng: 2.1734);
      expect(normalizarRegion(barcelona), 'ES-BCN');
    });

    test('Sevilla → ES (fallback NUTS-0, fuera del piloto)', () {
      const sevilla = Coordenadas(lat: 37.3886, lng: -5.9823);
      expect(normalizarRegion(sevilla), 'ES');
    });

    test('París → ES (fallback, no hay regiones fuera de España)', () {
      const paris = Coordenadas(lat: 48.8566, lng: 2.3522);
      expect(normalizarRegion(paris), 'ES');
    });
  });

  group('PermisoGeo', () {
    test('los cuatro estados están definidos', () {
      // Test trivial pero protege contra renombrados accidentales —
      // los strings circulan por la UI/i18n.
      expect(PermisoGeo.values.length, 4);
      expect(PermisoGeo.values, contains(PermisoGeo.noSolicitado));
      expect(PermisoGeo.values, contains(PermisoGeo.concedido));
      expect(PermisoGeo.values, contains(PermisoGeo.denegado));
      expect(PermisoGeo.values, contains(PermisoGeo.denegadoPermanente));
    });
  });
}
