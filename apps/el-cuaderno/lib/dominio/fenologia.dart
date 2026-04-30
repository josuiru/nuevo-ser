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
///
/// **Extensión B11** (fallback de experto, pendiente de validación con
/// ornitólogos/botánicos Iberia):
/// - [estacionesEnTransicion] reconoce ventanas de ±15 días alrededor
///   de cada corte astronómico — así el cliente puede pedir Misterios
///   de la estación entrante mientras la saliente sigue activa, lo
///   que respeta mejor el solapamiento fenológico real.
/// - [NotasFenologicasIberia.para] devuelve textos cortos y
///   provisionales por (region, estación) que el catálogo o las
///   pantallas pueden mostrar como referencia — todos marcados como
///   `[VERIFICAR B11]`. Cuando llegue la persona naturalista, edita
///   esta función y el resto del juego no se entera.
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

/// Devuelve hasta dos estaciones aplicables a [fecha]: la principal
/// (cierta) y la vecina cuando estamos a ±[diasMargen] días de un
/// corte astronómico. Útil para que el cliente pida al backend
/// Misterios de la estación entrante mientras la saliente sigue
/// activa — la fenología real solapa.
///
/// El orden es siempre **principal primero**. Si no hay vecina, la
/// lista lleva un único elemento.
///
/// Ejemplos (con diasMargen=15, default):
/// - 1 jul 2026 → [verano] (lejos de cortes).
/// - 18 sep 2026 → [verano, otono] (cuatro días antes del 22 sep).
/// - 27 sep 2026 → [otono, verano] (cinco días después del 22 sep).
/// - 5 mar 2026 → [invierno, primavera] (quince días antes del 20 mar).
List<Estacion> estacionesEnTransicion(
  DateTime fecha, {
  String regionCode = 'ES',
  int diasMargen = 15,
}) {
  final principal = estacionDeFecha(fecha, regionCode: regionCode);
  final cercaDe = _cercaDeCorte(fecha, diasMargen: diasMargen);
  if (cercaDe == null) return [principal];
  // [cercaDe] es la estación al otro lado del corte más próximo. Si
  // coincide con la principal (porque ya hemos cruzado pero seguimos
  // dentro del margen), la vecina es la otra; si difiere, es la
  // entrante o saliente.
  if (cercaDe == principal) return [principal];
  return [principal, cercaDe];
}

/// Devuelve la estación al otro lado del corte astronómico más próximo
/// si la fecha está dentro del [diasMargen]. Null si está lejos de
/// todos los cortes.
Estacion? _cercaDeCorte(DateTime fecha, {required int diasMargen}) {
  final ano = fecha.year;
  final cortes = <_CorteEstacional>[
    _CorteEstacional(DateTime(ano, 3, 20), Estacion.invierno, Estacion.primavera),
    _CorteEstacional(DateTime(ano, 6, 21), Estacion.primavera, Estacion.verano),
    _CorteEstacional(DateTime(ano, 9, 22), Estacion.verano, Estacion.otono),
    _CorteEstacional(DateTime(ano, 12, 21), Estacion.otono, Estacion.invierno),
  ];
  for (final corte in cortes) {
    final delta = fecha.difference(corte.fecha).inDays;
    if (delta.abs() <= diasMargen) {
      return delta < 0 ? corte.entrante : corte.saliente;
    }
  }
  return null;
}

class _CorteEstacional {
  const _CorteEstacional(this.fecha, this.saliente, this.entrante);
  final DateTime fecha;
  final Estacion saliente;
  final Estacion entrante;
}

/// Notas fenológicas hardcoded por (region, estacion) para Iberia
/// peninsular norte. **Fallback de experto pendiente de validación
/// con ornitólogos y botánicos del territorio (B11)**. Todas las notas
/// llevan el marcador `[VERIFICAR B11]` en la documentación adjunta
/// (ver memoria `project_el_cuaderno_decisiones_humanas_pendientes`).
///
/// La estructura está pensada para que la persona naturalista que
/// valide pueda sustituir el contenido sin que el resto del juego
/// se entere — basta con editar el mapa interno y los tests siguen
/// funcionando.
class NotasFenologicasIberia {
  const NotasFenologicasIberia._();

  /// Devuelve las notas para una `region` y `estacion`. La búsqueda
  /// es jerárquica: NUTS-3 (`ES-NA-PA`) → NUTS-2 (`ES-NA`) → NUTS-1
  /// (`ES`). Si una región no tiene notas, cae al país.
  ///
  /// La lista puede estar vacía — la persona naturalista decide qué
  /// notas cubrir. La pantalla que la consume debe tolerarlo.
  static List<String> para({
    required String regionCode,
    required Estacion estacion,
  }) {
    final candidatos = _candidatosJerarquicos(regionCode);
    for (final candidato in candidatos) {
      final notas = _mapa[candidato]?[estacion];
      if (notas != null && notas.isNotEmpty) return List.unmodifiable(notas);
    }
    return const <String>[];
  }

  /// Versión NUTS-3 → NUTS-2 → NUTS-1 → 'ES' del code de búsqueda.
  /// Para `ES-NA-PA` devuelve `[ES-NA-PA, ES-NA, ES]`.
  static List<String> _candidatosJerarquicos(String regionCode) {
    final partes = regionCode.split('-');
    final lista = <String>[];
    for (var n = partes.length; n > 0; n--) {
      lista.add(partes.take(n).join('-'));
    }
    return lista;
  }

  /// Mapa hardcoded provisional. Cobertura mínima: tres regiones
  /// piloto (Pamplona/Navarra, Bilbao/Vizcaya, Madrid) en estaciones
  /// con eventos fenológicos especialmente reconocibles. El resto se
  /// quedan vacíos a propósito — antes de inventar más notas sin
  /// fuente, prefiero que la persona naturalista decida qué cubrir.
  ///
  /// **Convención de redacción** (mantener si se editan):
  /// - sentence case con punto final;
  /// - verbo en presente o futuro inmediato ("suele florecer", "llegan");
  /// - sin diminutivos, sin exclamaciones;
  /// - el niño no aparece como sujeto — el sujeto es el ser vivo.
  static const Map<String, Map<Estacion, List<String>>> _mapa = {
    // Pamplona / Cuenca de Pamplona — clima atlántico-pirenaico.
    'ES-NA-PA': {
      Estacion.primavera: [
        'Las golondrinas suelen llegar entre marzo y abril.',
        'El almendro florece antes que el cerezo.',
      ],
      Estacion.verano: [
        'Las cigüeñas crían en los campanarios.',
        'Los milanos planean alto en las tardes calurosas.',
      ],
      Estacion.otono: [
        'Las hayas pasan del verde al cobre desde finales de septiembre.',
        'Las grullas pasan altas en bandadas en forma de uve.',
      ],
      Estacion.invierno: [
        'El petirrojo es residente — se ve todo el año.',
        'Los robles aún sostienen hojas marrones hasta marzo.',
      ],
    },

    // Bilbao / Vizcaya — clima atlántico costero.
    'ES-BI': {
      Estacion.primavera: [
        'Los acebos brotan después que los robles.',
        'Las primeras orquídeas silvestres aparecen en abril.',
      ],
      Estacion.verano: [
        'Las nieblas matinales se levantan tarde junto al mar.',
        'Los charranes y gaviotas crían cerca de la costa.',
      ],
      Estacion.otono: [
        'Los hongos aparecen tras las primeras lluvias largas.',
        'El haya y el castaño cambian a la vez.',
      ],
      Estacion.invierno: [
        'Los pinzones bajan al jardín cuando hace frío.',
        'El musgo está más vivo en invierno que en verano.',
      ],
    },

    // Madrid — clima mediterráneo continental.
    'ES-MD': {
      Estacion.primavera: [
        'El cerezo de las afueras florece a finales de marzo.',
        'Los vencejos llegan a comienzos de mayo.',
      ],
      Estacion.verano: [
        'Los abejarucos pasan en bandadas hacia el sur.',
        'Los robles y encinas resisten el calor sin perder hoja.',
      ],
      Estacion.otono: [
        'Los robles y quejigos amarillean tarde, hasta noviembre.',
        'Las cigüeñas se quedan más cada año, sin emigrar.',
      ],
      Estacion.invierno: [
        'Los petirrojos bajan a los jardines cuando hiela.',
        'Los olmos siguen sin hojas hasta marzo.',
      ],
    },

    // Fallback país — notas que cualquier región peninsular puede
    // reconocer. Sin pretender ser exhaustivas.
    'ES': {
      Estacion.primavera: [
        'Hay más cantos al amanecer que en cualquier otra estación.',
      ],
      Estacion.verano: [
        'Muchos árboles crecen rápido en junio y luego paran.',
      ],
      Estacion.otono: [
        'Las hojas no caen el mismo día — fíjate en el orden.',
      ],
      Estacion.invierno: [
        'Las aves residentes son más fáciles de ver con el bosque pelado.',
      ],
    },
  };
}
