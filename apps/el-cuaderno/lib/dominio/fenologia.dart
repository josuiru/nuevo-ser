/// Servicio de fenología — calcula la **estación actual** a partir de
/// fecha y región, para alimentar el filtro `season` del catálogo de
/// Misterios.
///
/// Alcance del MVP (doc 03 §10, doc 06 §4):
/// - Cortes **astronómicos genéricos del hemisferio norte**: equinoccio
///   de primavera 20 mar, solsticio de verano 21 jun, equinoccio de
///   otoño 22 sep, solsticio de invierno 21 dic. Es lo suficientemente
///   bueno para todas las regiones piloto (todas en hemisferio norte
///   peninsular, donde el desfase astronómico vs fenológico real es de
///   2-3 semanas).
/// - **El calendario fenológico regional fino** (cuándo florece el
///   almendro en Pamplona, cuándo migran las golondrinas en Bilbao) es
///   trabajo humano pendiente — ornitólogos y botánicos del territorio
///   (ver memoria `decisiones_humanas_pendientes` ítem fenología).
///   Cuando llegue el dato, esta función se sustituye por una tabla
///   regional sin que el resto del juego se entere.
///
/// **Nota de hemisferio**: la función acepta `regionCode` para
/// reconocer regiones del hemisferio sur si algún día el piloto cruza
/// el ecuador. Hoy todos los region_code piloto (`ES-*`) están en el
/// norte; cualquier otro code se trata como norte por defecto.
library;

enum Estacion { primavera, verano, otono, invierno }

/// Convierte la estación al string que usa el wire del catálogo de
/// Misterios (`season` en `GET /el-cuaderno/misterios`). El `'otono'`
/// va sin tilde porque el backend usa identificadores ASCII.
String estacionAString(Estacion estacion) {
  switch (estacion) {
    case Estacion.primavera:
      return 'primavera';
    case Estacion.verano:
      return 'verano';
    case Estacion.otono:
      return 'otono';
    case Estacion.invierno:
      return 'invierno';
  }
}

/// Calcula la estación astronómica de [fecha] en la región dada por
/// [regionCode]. Devuelve [Estacion] enum (la conversión a string del
/// wire la hace [estacionAString]).
///
/// Cortes (hemisferio norte): primavera 20 mar → 20 jun, verano 21 jun
/// → 21 sep, otoño 22 sep → 20 dic, invierno 21 dic → 19 mar.
Estacion estacionDeFecha(DateTime fecha, {String regionCode = 'ES'}) {
  // Hoy todas las regiones piloto están en hemisferio norte. Sur queda
  // como TODO si el piloto se expande.
  final mes = fecha.month;
  final dia = fecha.day;
  if (mes < 3 || (mes == 3 && dia < 20)) return Estacion.invierno;
  if (mes < 6 || (mes == 6 && dia < 21)) return Estacion.primavera;
  if (mes < 9 || (mes == 9 && dia < 22)) return Estacion.verano;
  if (mes < 12 || (mes == 12 && dia < 21)) return Estacion.otono;
  return Estacion.invierno;
}

/// Helper de conveniencia para el call site del cliente: devuelve el
/// string del wire (`'primavera'|'verano'|'otono'|'invierno'`) en una
/// sola llamada. No añade lógica, solo orquesta los dos primitivos
/// para que el código que filtra Misterios lea de corrido.
String seasonParaListado(DateTime fecha, {String regionCode = 'ES'}) {
  return estacionAString(estacionDeFecha(fecha, regionCode: regionCode));
}
