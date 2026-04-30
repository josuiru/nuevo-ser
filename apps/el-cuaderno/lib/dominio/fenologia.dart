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

  /// Devuelve **una** nota fenológica del día — la elección rota cada
  /// día sin ser aleatoria, así dos niños del mismo lugar y la misma
  /// fecha leen la misma frase (estabilidad pedagógica) y un mismo
  /// niño no ve siempre la misma. La rotación usa `mes*100 + día`
  /// como semilla; al cabo de un año se completa el ciclo.
  ///
  /// Devuelve `null` si para la pareja `(region, estacion)` no hay
  /// notas (la pantalla que la consume oculta el tip entero, no
  /// muestra placeholder).
  static String? notaDelDia({
    required String regionCode,
    required Estacion estacion,
    required DateTime fecha,
  }) {
    final notas = para(regionCode: regionCode, estacion: estacion);
    if (notas.isEmpty) return null;
    final indice = (fecha.month * 100 + fecha.day) % notas.length;
    return notas[indice];
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

  /// Mapa hardcoded provisional. **Toda esta tabla es un fallback de
  /// experto pendiente de validación con ornitólogos/botánicos
  /// locales (B11)** — la asesoría definitiva se documentará en
  /// `docs/el-cuaderno/calendario-fenologico-validado.md` cuando
  /// llegue.
  ///
  /// Dos capas conviven:
  ///
  /// 1. **NUTS-3 piloto con afirmaciones específicas** (Pamplona,
  ///    Bilbao, Madrid). Mencionan especies y rangos temporales
  ///    concretos — son las que necesitan más revisión humana porque
  ///    una fecha mal puesta envejece mal y el niño la lee como
  ///    autoridad.
  ///
  /// 2. **Autonómicas con afirmaciones genéricas** (Cataluña,
  ///    Andalucía, Asturias, Canarias y otras). Sólo afirman
  ///    geografía / climatología / biología obvia (esclerófilas
  ///    aguantan calor, pinos perennes, alisios, etc.) — sin fechas
  ///    concretas, sin especies-clave que requieran calendario
  ///    territorial. Una asesoría local podría aún así pulirlas,
  ///    pero no comprometen al juego con afirmaciones falsificables.
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

    // Cataluña — gradiente costa mediterránea ↔ Pirineo. Sin fechas
    // concretas; sólo patrones espaciales obvios.
    'ES-CT': {
      Estacion.primavera: [
        'Los almendros suelen ser de los primeros frutales en florecer.',
        'En el Pirineo la primavera llega más tarde que en la costa.',
      ],
      Estacion.verano: [
        'Los pinos resinosos sueltan aroma con el calor.',
        'La encina aguanta el calor sin perder hoja.',
      ],
      Estacion.otono: [
        'El paisaje del Pirineo cambia más deprisa que el de la costa.',
        'Las primeras lluvias de otoño suelen ser fuertes.',
      ],
      Estacion.invierno: [
        'El viento del norte (tramontana) puede ser intenso.',
        'En la costa las heladas son raras; tierra adentro son habituales.',
      ],
    },

    // Andalucía — mediterráneo cálido seco. Esclerófilas y olivos
    // como anclas seguras.
    'ES-AN': {
      Estacion.primavera: [
        'Las jaras y los olivos atraen muchos insectos al florecer.',
        'El campo se llena de flores tras las lluvias de marzo.',
      ],
      Estacion.verano: [
        'Las encinas y olivos resisten el calor sin perder hoja.',
        'A mediodía muchas aves descansan a la sombra y cantan menos.',
      ],
      Estacion.otono: [
        'Las primeras lluvias después del verano traen vida al campo.',
        'Las hojas de las encinas se renuevan poco a poco, no de golpe.',
      ],
      Estacion.invierno: [
        'Los inviernos son suaves; muchas plantas siguen verdes.',
        'Las naranjas y mandarinas maduran en los árboles.',
      ],
    },

    // Asturias — atlántico húmedo de montaña. Verde intenso y bosques
    // caducifolios.
    'ES-AS': {
      Estacion.primavera: [
        'El paisaje se vuelve verde intenso con las lluvias.',
        'Los bosques de robles y hayas tardan en sacar la hoja nueva.',
      ],
      Estacion.verano: [
        'La niebla baja del monte tras los días calurosos.',
        'Los musgos están bien donde hay sombra y humedad.',
      ],
      Estacion.otono: [
        'Las hayas y los robles tiñen los valles del cobre.',
        'Las setas aparecen tras las lluvias largas.',
      ],
      Estacion.invierno: [
        'La nieve cubre las cumbres aunque la costa esté templada.',
        'Los acebos y laureles siguen verdes en pleno invierno.',
      ],
    },

    // Galicia — atlántico húmedo costero. Patrón parecido a
    // Asturias; lo separamos porque la costa gallega tiene rasgos
    // propios (rías, vegetación litoral).
    'ES-GA': {
      Estacion.primavera: [
        'Tras los inviernos lluviosos, los prados estallan en verde.',
        'Las camelias florecen pronto en muchos jardines.',
      ],
      Estacion.verano: [
        'Las nieblas de mañana se levantan despacio cerca del mar.',
        'Los pinos y eucaliptos dominan grandes manchas de bosque.',
      ],
      Estacion.otono: [
        'Las castañeras dan fruto al final del otoño.',
        'Las setas son muy abundantes tras las lluvias.',
      ],
      Estacion.invierno: [
        'Los inviernos son lluviosos y suaves cerca de la costa.',
        'Muchas aves marinas se acercan a las rías cuando hay temporal.',
      ],
    },

    // Canarias — clima subtropical, sin invierno marcado. Las
    // estaciones del calendario peninsular encajan poco aquí — las
    // notas lo dicen sin disimular.
    'ES-CN': {
      Estacion.primavera: [
        'Aquí las estaciones se notan menos que en la península.',
        'Muchas plantas florecen en cualquier época si llueve.',
      ],
      Estacion.verano: [
        'Los alisios refrescan la tarde en muchas zonas costeras.',
        'Por encima del mar de nubes el clima es seco y soleado.',
      ],
      Estacion.otono: [
        'Octubre y noviembre suelen traer las lluvias más esperadas.',
        'El laurisilva se mantiene siempre verde, pase la estación que pase.',
      ],
      Estacion.invierno: [
        'Los pinos canarios mantienen hoja todo el año.',
        'En la costa el invierno se siente como una primavera fresca.',
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
