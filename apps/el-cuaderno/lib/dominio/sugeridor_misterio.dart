import 'misterio.dart';

/// Sugiere un Misterio del catálogo abierto a partir del texto que el
/// niño está escribiendo en `queVio`. Heurística simple, sin LLM:
/// match por substring contra una tabla de **palabras clave** por id
/// de Misterio. La sugerencia es **opcional**: la pantalla la muestra
/// como chip "¿anotas evidencia para «X»?" con sí/no; el niño puede
/// rechazarla y la pantalla no insiste hasta que cambie el texto.
///
/// Convenciones:
/// - `queVio` se normaliza accent+case-insensitive antes de buscar.
/// - Las palabras clave en la tabla viven en minúsculas, ya
///   normalizadas (sin tildes, ñ → n) — el match es directo.
/// - **Match por substring**: "vi unas golondrinas" contiene
///   "golondrina" → match. El niño no tiene que escribir la palabra
///   clave exacta.
/// - Se puntúa por **número de palabras clave coincidentes** del
///   Misterio. Empate por orden en la lista de candidatos (estabilidad
///   con orden alfabético del repositorio).
/// - Si hay 0 matches, devuelve `null` — la pantalla esconde el chip.
///
/// **Tabla mantenida a mano** ([_palabrasClavePorId]) para que la
/// validación humana del catálogo (B1) o las nuevas keywords
/// territoriales que aporten naturalistas locales puedan editarse
/// sin tocar el modelo Isar ni el JSON del wire. Si un id de Misterio
/// no aparece en la tabla, simplemente no se sugiere — comportamiento
/// honesto, no error.
Misterio? sugerirMisterio({
  required String queVio,
  required List<Misterio> candidatos,
}) {
  final texto = _normalizar(queVio);
  if (texto.isEmpty) return null;

  Misterio? mejor;
  var mejorPuntuacion = 0;
  for (final misterio in candidatos) {
    final palabras = _palabrasClavePorId[misterio.id];
    if (palabras == null || palabras.isEmpty) continue;
    var puntuacion = 0;
    for (final palabra in palabras) {
      if (texto.contains(palabra)) puntuacion++;
    }
    if (puntuacion > mejorPuntuacion) {
      mejorPuntuacion = puntuacion;
      mejor = misterio;
    }
  }
  return mejor;
}

/// Normaliza texto para matching: trim + lowercase + accent-fold +
/// ñ → n + ç → c. Mismo shape que la búsqueda de la lista de
/// observaciones — código duplicado a propósito para no acoplar el
/// dominio del sugeridor con la capa de vista; un refactor a un
/// helper compartido en `dominio/` queda como deuda menor cuando
/// haya un tercer caller.
String _normalizar(String texto) {
  final base = texto.trim().toLowerCase();
  if (base.isEmpty) return base;
  final buffer = StringBuffer();
  for (final caracter in base.runes) {
    switch (caracter) {
      case 0x00E1: // á
      case 0x00E0: // à
      case 0x00E4: // ä
      case 0x00E2: // â
        buffer.writeCharCode(0x61); // a
      case 0x00E9: // é
      case 0x00E8: // è
      case 0x00EB: // ë
      case 0x00EA: // ê
        buffer.writeCharCode(0x65); // e
      case 0x00ED: // í
      case 0x00EC: // ì
      case 0x00EF: // ï
      case 0x00EE: // î
        buffer.writeCharCode(0x69); // i
      case 0x00F3: // ó
      case 0x00F2: // ò
      case 0x00F6: // ö
      case 0x00F4: // ô
        buffer.writeCharCode(0x6F); // o
      case 0x00FA: // ú
      case 0x00F9: // ù
      case 0x00FC: // ü
      case 0x00FB: // û
        buffer.writeCharCode(0x75); // u
      case 0x00F1: // ñ
        buffer.writeCharCode(0x6E); // n
      case 0x00E7: // ç
        buffer.writeCharCode(0x63); // c
      default:
        buffer.writeCharCode(caracter);
    }
  }
  return buffer.toString();
}

/// Palabras clave por id de Misterio del seed seminal. Las cadenas
/// se almacenan como **stems** o sufijos parciales pensados para
/// matchear singular y plural por substring: `'golondrina'` cubre
/// "golondrina" y "golondrinas"; `'blanc'` cubre "blanca/o/as/os".
/// Si stems comunes generaran demasiados falsos positivos entre dos
/// Misterios cercanos (ambos hablan de hormigas, ambos hablan de
/// flores), se prefiere bigrama específico antes que stem corto.
///
/// La función [sugerirMisterio] puntúa por número de coincidencias.
/// Con dos Misterios candidatos, gana el que más stems empareje en
/// el texto del niño. Empate → primero del orden recibido.
const Map<String, List<String>> _palabrasClavePorId = {
  'seed-misterio-golondrinas': ['golondrina'],
  'seed-misterio-primera-hoja': [
    'hoja amarill',
    'primera hoja',
    'hoja seca',
    'cae la hoja',
    'caen las hojas',
  ],
  'seed-misterio-primera-flor': [
    'primera flor',
    'almendro',
    'mimosa',
    'flor temprana',
  ],
  'seed-misterio-cigarras-fin': ['cigarra'],
  'seed-misterio-petirrojo': ['petirrojo'],
  'seed-misterio-polinizadores': [
    'abeja',
    'avispa',
    'polinizador',
    'visit',
  ],
  'seed-misterio-liquenes': ['liquen'],
  'seed-misterio-lluvia': [
    'caracol',
    'lombriz',
    'tras la lluvia',
    'despues de llover',
    'tras llover',
  ],
  // Hormigas-árbol y hormigas-sendero comparten dominio. Para evitar
  // ambigüedad usamos bigramas específicos en cada uno; si el texto
  // dice "vi hormigas" sin más, ningún Misterio matchea (honesto: el
  // sistema no inventa sugerencia cuando la señal es ambigua).
  'seed-misterio-hormigas-arbol': [
    'hormigas en el arbol',
    'hormiga en el arbol',
    'hormigas suben',
  ],
  'seed-misterio-aves-suelo-ramas': [
    'come en el suelo',
    'come en las ramas',
    'paloma',
    'urraca',
    'mirlo',
  ],
  'seed-misterio-dos-pequenos-marrones': [
    'pajaro pequeno marron',
    'pajaros pequenos marrones',
    'gorrion',
  ],
  'seed-misterio-mariposas-blancas': ['mariposa', 'blanc'],
  'seed-misterio-platano': ['platano de sombra', 'sicomoro'],
  'seed-misterio-pajaro-cola': ['mueve la cola', 'lavandera'],
  'seed-misterio-flor-rara': [
    'flor rara',
    'flor unica',
    'flor que no conozco',
  ],
  'seed-misterio-hormigas-sendero': [
    'nido de hormig',
    'hormiguero',
    'hormigas en el sendero',
    'hormigas en la acera',
    'hormigas pasan',
  ],
  'seed-misterio-encina-vieja': [
    'encina',
    'arbol viejo',
    'arbol grande',
    'arbol antiguo',
  ],
  'seed-misterio-grito-raro': [
    'grito',
    'aullido',
    'ladrido raro',
    'sonido raro de noche',
    'ulul',
  ],
  'seed-misterio-polillas-farolas': ['polilla', 'farola'],
};
