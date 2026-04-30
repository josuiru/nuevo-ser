import 'observacion.dart';

/// Agregado semanal del cuaderno del niño. **Solo metadatos**: counts y
/// porcentajes, nunca texto libre, nunca coords precisas. Lo que puede
/// cruzar red hacia `POST /companion/aggregates/weekly` para que el
/// LLM server-side genere el `summary_text` y la `conversation_prompt`
/// del cuidador (doc 03 §3.3, doc 15 §1).
///
/// Cada `iso_week` es la pareja `(añoIso, semanaIso)` formateada
/// `YYYY-Www`. Lunes inicia la semana ISO (norma europea).
class AgregadoSemanal {
  const AgregadoSemanal({
    required this.isoWeek,
    required this.regionCode,
    required this.observacionesTotal,
    required this.observacionesPorMisterio,
    required this.observacionesPorConfianza,
    required this.sitSpotVisitas,
    required this.misteriosDistintos,
  });

  /// Formato `YYYY-Www` (norma ISO 8601), p.ej. `2026-W18`.
  final String isoWeek;

  /// Código NUTS de la región del agregado. Cliente lo deriva con
  /// `normalizarRegion()` desde el sit spot del niño o desde la
  /// observación más reciente con coords. Si el niño tiene el GPS
  /// apagado, se manda `'ES'` (NUTS-0).
  final String regionCode;

  /// Cuántas observaciones el niño registró en la semana.
  final int observacionesTotal;

  /// Reparto por Misterio anclado (clave = misterioId, valor = count).
  /// El servidor recibe los IDs canónicos del catálogo, NO el texto del
  /// niño — por eso esto no viola la frontera de privacidad.
  final Map<String, int> observacionesPorMisterio;

  /// Reparto por nivel de confianza declarado (clave = enum.name,
  /// valor = count). Útil para que el cuidador tenga métrica de oficio
  /// ("esta semana ha hecho más hipótesis activas que consenso").
  final Map<String, int> observacionesPorConfianza;

  /// Cuántas veces visitó el sit spot esta semana (deriva de
  /// `Observacion.sitSpotId`).
  final int sitSpotVisitas;

  /// Cuántos Misterios distintos visitó (cardinality del map de
  /// arriba). Conveniente para el resumen, evita reaccular en plantilla.
  final int misteriosDistintos;

  /// Forma JSON para el body de `POST /companion/aggregates/weekly`.
  /// Cuidado: aquí no hay textos del niño, solo IDs y counts.
  Map<String, Object?> aJson() => {
        'iso_week': isoWeek,
        'region_code': regionCode,
        'observaciones_total': observacionesTotal,
        'observaciones_por_misterio': observacionesPorMisterio,
        'observaciones_por_confianza': observacionesPorConfianza,
        'sit_spot_visitas': sitSpotVisitas,
        'misterios_distintos': misteriosDistintos,
      };
}

/// Calcula el agregado semanal a partir de las observaciones del niño.
/// Función pura — no toca red, no toca disco.
///
/// [semanaPivote] es la fecha que define la semana ISO a agregar:
/// se calculan lunes-domingo locales (no UTC) inclusivos. Si es null,
/// se usa "ahora".
///
/// [regionCode] viaja al servidor; si null se asume `'ES'`.
AgregadoSemanal computarAgregadoSemanal(
  List<Observacion> observaciones, {
  DateTime? semanaPivote,
  String regionCode = 'ES',
}) {
  final pivote = semanaPivote ?? DateTime.now();
  final inicio = _inicioSemanaIso(pivote);
  final finExclusivo = inicio.add(const Duration(days: 7));

  final delaSemana = observaciones.where((observacion) {
    final cuando = observacion.cuandoOcurrio;
    return !cuando.isBefore(inicio) && cuando.isBefore(finExclusivo);
  }).toList();

  final porMisterio = <String, int>{};
  final porConfianza = <String, int>{};
  var visitasSitSpot = 0;
  for (final observacion in delaSemana) {
    final misterioId = observacion.misterioId;
    if (misterioId != null && misterioId.isNotEmpty) {
      porMisterio[misterioId] = (porMisterio[misterioId] ?? 0) + 1;
    }
    final claveConfianza = observacion.confianza.name;
    porConfianza[claveConfianza] = (porConfianza[claveConfianza] ?? 0) + 1;
    if (observacion.sitSpotId != null && observacion.sitSpotId!.isNotEmpty) {
      visitasSitSpot++;
    }
  }

  return AgregadoSemanal(
    isoWeek: _isoWeekDe(pivote),
    regionCode: regionCode,
    observacionesTotal: delaSemana.length,
    observacionesPorMisterio: porMisterio,
    observacionesPorConfianza: porConfianza,
    sitSpotVisitas: visitasSitSpot,
    misteriosDistintos: porMisterio.length,
  );
}

/// Devuelve el lunes 00:00 de la semana ISO que contiene [fecha], en
/// hora local (no UTC).
DateTime _inicioSemanaIso(DateTime fecha) {
  final soloFecha = DateTime(fecha.year, fecha.month, fecha.day);
  // weekday: lunes=1 ... domingo=7
  final diasDesdeLunes = soloFecha.weekday - 1;
  return soloFecha.subtract(Duration(days: diasDesdeLunes));
}

/// Formatea [fecha] como `YYYY-Www` ISO 8601. Implementación basada en
/// el algoritmo del jueves: la semana ISO a la que pertenece una fecha
/// es la del jueves de su semana lunes-domingo.
String _isoWeekDe(DateTime fecha) {
  // Jueves de la semana lunes-domingo de [fecha].
  final jueves = _inicioSemanaIso(fecha).add(const Duration(days: 3));
  final anio = jueves.year;
  final inicioDelAnio = DateTime(anio, 1, 1);
  final diaDelAnio = jueves.difference(inicioDelAnio).inDays + 1;
  // Lunes de la semana 1: contiene el primer jueves del año.
  final diaSemanaInicioAnio = inicioDelAnio.weekday; // 1..7
  final diasHastaPrimerJueves = (4 - diaSemanaInicioAnio + 7) % 7;
  final primerJuevesDelAnio =
      inicioDelAnio.add(Duration(days: diasHastaPrimerJueves));
  final lunesSemana1 =
      primerJuevesDelAnio.subtract(const Duration(days: 3));
  final diasDesdeLunesSemana1 = jueves.difference(lunesSemana1).inDays;
  final semana = (diasDesdeLunesSemana1 ~/ 7) + 1;
  // Si fuera negativa (raro: fechas de principios de enero), recurrir
  // al año anterior. Se evita aquí porque siempre cogemos el jueves de
  // la semana, que cae en el año ISO correcto por construcción —
  // queda el día 1..366.
  if (diaDelAnio < 1 || semana < 1) {
    return _isoWeekDe(fecha.subtract(const Duration(days: 7)));
  }
  return '$anio-W${semana.toString().padLeft(2, '0')}';
}

/// Genera offline una pregunta para la cena (modo cuidador) a partir
/// del agregado semanal. **Plantillas hardcoded en castellano**
/// siguiendo la voz del doc 04 §1: voz adulta amable, sin diminutivos,
/// sin "¡bien hecho!", sin moralizar. Sin red. Sirve como fallback si
/// `/companion/aggregates/weekly` no está disponible o el niño no ha
/// dado permiso para compartir.
///
/// Cuando el LLM server-side produce su `conversation_prompt`, ese
/// texto sustituye a este — pero la API es la misma desde la vista del
/// cuidador.
String preguntaParaLaCenaOffline(AgregadoSemanal agregado) {
  if (agregado.observacionesTotal == 0) {
    return 'Esta semana el cuaderno descansó. ¿Hay algo del lugar que '
        'os apetezca volver a mirar despacio?';
  }
  if (agregado.misteriosDistintos == 0 && agregado.sitSpotVisitas == 0) {
    return '¿Qué cosa pequeña ha aparecido esta semana en el cuaderno '
        'que no estaba antes?';
  }
  if (agregado.sitSpotVisitas > 0 && agregado.misteriosDistintos == 0) {
    return 'Esta semana ha vuelto al lugar de regreso. ¿Qué le ha '
        'sonado distinto allí?';
  }
  if (agregado.misteriosDistintos == 1) {
    return 'Esta semana ha quedado dándole vueltas a una pregunta. '
        '¿Cuál cuenta hoy?';
  }
  return 'Esta semana ha tenido varias preguntas a la vez. ¿Cuál de '
      'todas le tiene más enganchada ahora mismo?';
}
