import 'fenologia.dart';
import 'misterio.dart';

/// Decide si un [Misterio] del catálogo aplica al contexto del niño
/// (estación actual + región actual). Helper puro, sin estado.
///
/// **Política del MVP** (biblia §5.3 + doc 06 §4): un Misterio
/// fenológico bien construido pierde valor pedagógico si se muestra
/// fuera de contexto — preguntar por las golondrinas en febrero o por
/// la primera flor del año en agosto rompe la mecánica de "vuelvo al
/// lugar y miro qué cambió". El filtrado **no esconde el catálogo** —
/// solo prioriza qué Misterios el niño ve abiertos en su pantalla
/// principal y en la pestaña Misterios; la página completa de un
/// Misterio sigue accesible si se llega por anclajes históricos.
///
/// Convenciones:
///
/// - `seasons` lista vacía o con valores no reconocidos → **aplica
///   siempre**. Es el caso de Misterios atemporales (líquenes, encina
///   vieja, hormigas).
/// - `regions` `null` o lista vacía → **global**. Es el default del
///   catálogo seminal: la mayoría son `[ES-*]`.
/// - `regions` con prefijos NUTS o el shorthand `ES-*` → coincide si
///   `regionActual` empieza por el prefijo (sin la cola `-*`). El
///   shorthand `ES-*` se interpreta como "España entera" (= prefijo
///   `ES`).
/// - `regionActual` `null` → no se aplica filtro de región (el niño
///   no ha establecido sit spot con coordenadas; sin contexto
///   geográfico es más amable mostrar el catálogo entero que recortar
///   por una región arbitraria).
bool aplicaMisterioEnContexto(
  Misterio misterio, {
  required Estacion estacionActual,
  String? regionActual,
}) {
  return _aplicaEstacion(misterio.seasons, estacionActual) &&
      _aplicaRegion(misterio.regions, regionActual);
}

bool _aplicaEstacion(List<String> seasons, Estacion estacionActual) {
  if (seasons.isEmpty) return true;
  final actualWire = estacionAString(estacionActual);
  return seasons.contains(actualWire);
}

bool _aplicaRegion(List<String>? regions, String? regionActual) {
  if (regions == null || regions.isEmpty) return true;
  if (regionActual == null) return true;
  for (final raw in regions) {
    final prefijo = _normalizarPrefijoRegion(raw);
    if (prefijo.isEmpty) continue;
    if (regionActual == prefijo || regionActual.startsWith('$prefijo-')) {
      return true;
    }
  }
  return false;
}

/// Normaliza el prefijo de región del catálogo a un código NUTS
/// limpio. `'ES-*'` → `'ES'`; `'ES-NA-*'` → `'ES-NA'`; `'ES-MD'` → tal
/// cual.
String _normalizarPrefijoRegion(String raw) {
  var p = raw;
  while (p.endsWith('-*')) {
    p = p.substring(0, p.length - 2);
  }
  return p;
}

/// Filtra una lista de Misterios al contexto. Conserva el orden.
List<Misterio> filtrarMisteriosAlContexto(
  List<Misterio> misterios, {
  required Estacion estacionActual,
  String? regionActual,
}) {
  return misterios
      .where(
        (misterio) => aplicaMisterioEnContexto(
          misterio,
          estacionActual: estacionActual,
          regionActual: regionActual,
        ),
      )
      .toList();
}
