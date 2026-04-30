import 'dart:math' as math;

import 'observacion.dart' show Coordenadas;
import 'sit_spot.dart';

/// Contrato del servicio de geolocalización del juego. La
/// implementación real (con plugin `geolocator`) se cablea en
/// dispositivo; en tests se inyecta una implementación stub.
///
/// **Restricciones de diseño** (doc 03 §7.1):
/// - Las coordenadas precisas NUNCA cruzan red.
/// - Sin tracking continuo. Solo se piden coords puntuales cuando el
///   niño explícitamente registra observación o configura sit spot.
/// - Permiso "solo en uso", nunca background.
/// - El niño puede declinar geolocalización; en ese caso, este
///   servicio devuelve `Permiso.denegado` y la app cae a entrada
///   manual de `place_name` sin perder funcionalidad nuclear.
abstract class ServicioGeolocalizacion {
  /// Estado actual del permiso. La UI lo consulta antes de pedir
  /// coords para mostrar el primer copy explicativo.
  Future<PermisoGeo> permiso();

  /// Solicita el permiso. Devuelve el estado tras la respuesta del
  /// usuario. Si ya estaba concedido, devuelve `concedido` sin abrir
  /// diálogo.
  Future<PermisoGeo> pedirPermiso();

  /// Coordenadas actuales del niño. **Lectura puntual**: el servicio
  /// NO se suscribe a actualizaciones continuas. Si el permiso está
  /// denegado o el GPS no responde, devuelve null.
  ///
  /// El [tiempoEspera] controla cuánto se espera al GPS antes de dar
  /// por imposible la lectura — ofrecer al niño una espera infinita
  /// es peor que decirle "no consigo localizarte, pon el lugar a
  /// mano".
  Future<Coordenadas?> coordenadasActuales({
    Duration tiempoEspera = const Duration(seconds: 8),
  });
}

enum PermisoGeo {
  /// Aún no se ha pedido. La UI muestra el copy de pre-permiso.
  noSolicitado,

  /// El usuario ha concedido permiso "solo en uso" (foreground).
  concedido,

  /// El usuario ha denegado. La UI cae al modo manual sin volver a
  /// pedir el permiso a no ser que el niño explícitamente lo pida
  /// desde Ajustes.
  denegado,

  /// El usuario ha denegado y marcado "no preguntar más". El sistema
  /// operativo bloquea futuras solicitudes; hay que dirigir al niño a
  /// Ajustes del sistema.
  denegadoPermanente,
}

/// Detecta si las coordenadas [actual] están dentro del radio del
/// [sitSpot]. Si el sit spot no tiene coordenadas registradas, devuelve
/// `false` — el sistema no puede saberlo desde aquí.
///
/// Distancia en metros usando la fórmula de Haversine (esfera de radio
/// 6 371 008,8 m, radio medio de la WGS-84).
bool estaEnSitSpot(
  Coordenadas actual,
  SitSpot sitSpot, {
  double radioMetros = 50,
}) {
  final centro = sitSpot.coordenadas;
  if (centro == null) return false;
  return distanciaMetros(actual, centro) <= radioMetros;
}

/// Distancia ortodrómica entre dos puntos en metros (Haversine).
/// Útil para "¿estás en tu sit spot?" (radio 50 m del doc 03 §7.2)
/// y para tests.
double distanciaMetros(Coordenadas a, Coordenadas b) {
  const radioTierraMetros = 6371008.8;
  final lat1 = _grados2Rad(a.lat);
  final lat2 = _grados2Rad(b.lat);
  final dLat = _grados2Rad(b.lat - a.lat);
  final dLng = _grados2Rad(b.lng - a.lng);
  final h = math.sin(dLat / 2) * math.sin(dLat / 2) +
      math.cos(lat1) *
          math.cos(lat2) *
          math.sin(dLng / 2) *
          math.sin(dLng / 2);
  final c = 2 * math.atan2(math.sqrt(h), math.sqrt(1 - h));
  return radioTierraMetros * c;
}

double _grados2Rad(double grados) => grados * math.pi / 180.0;

/// Convierte coordenadas a un `region_code` aproximado (NUTS-3) sin
/// tocar red. La tabla embebida cubre las áreas previstas para el
/// **piloto inicial** (doc 03 §10, memoria
/// `decisiones_humanas_pendientes` ítem 8): cuando el piloto se
/// expanda a otras zonas, hay que añadir entradas aquí o sustituir
/// el lookup por una BD vectorial offline más completa.
///
/// Las bounding boxes son aproximadas (no recortan a la frontera
/// administrativa real); el doc 03 §7.1 acepta esta resolución porque
/// el region_code se usa para fenología, no para identificación.
///
/// Si el punto no encaja en ninguna entrada conocida, devuelve `'ES'`
/// como fallback NUTS-0.
String normalizarRegion(Coordenadas coord) {
  for (final entrada in _regionesPiloto) {
    if (entrada.contiene(coord)) return entrada.code;
  }
  return 'ES';
}

class _RegionPiloto {
  const _RegionPiloto({
    required this.code,
    required this.latMin,
    required this.latMax,
    required this.lngMin,
    required this.lngMax,
  });

  final String code;
  final double latMin;
  final double latMax;
  final double lngMin;
  final double lngMax;

  bool contiene(Coordenadas c) {
    return c.lat >= latMin &&
        c.lat <= latMax &&
        c.lng >= lngMin &&
        c.lng <= lngMax;
  }
}

const _regionesPiloto = <_RegionPiloto>[
  // Pamplona y comarca (Navarra capital).
  _RegionPiloto(
    code: 'ES-NA-PA',
    latMin: 42.71,
    latMax: 43.00,
    lngMin: -1.83,
    lngMax: -1.45,
  ),
  // Resto de Navarra (más amplio).
  _RegionPiloto(
    code: 'ES-NA',
    latMin: 41.90,
    latMax: 43.32,
    lngMin: -2.50,
    lngMax: -0.70,
  ),
  // Bizkaia (Bilbao).
  _RegionPiloto(
    code: 'ES-BI',
    latMin: 43.05,
    latMax: 43.50,
    lngMin: -3.45,
    lngMax: -2.40,
  ),
  // Madrid capital.
  _RegionPiloto(
    code: 'ES-MD',
    latMin: 40.30,
    latMax: 40.55,
    lngMin: -3.85,
    lngMax: -3.50,
  ),
  // Barcelona y comarca.
  _RegionPiloto(
    code: 'ES-BCN',
    latMin: 41.30,
    latMax: 41.55,
    lngMin: 1.95,
    lngMax: 2.30,
  ),
];
