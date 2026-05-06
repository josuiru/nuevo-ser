import 'ambiente_cielo.dart';

/// Eventos efímeros del calendario diegético — días del año en los que
/// el cielo del cazadero cambia respecto al clima normal del distrito
/// y, opcionalmente, Sora deja un comentario ambiental al entrar.
///
/// Razón de existir: dar al niño que ya cerró el MVP narrativo razones
/// concretas para volver a jugar **un día concreto**. Los anuncios de
/// estos eventos viven en el Faro de Azula:
///
/// - Equinoccio mayor con la luna pequeña (E19, redacción 1252) — la
///   luna pequeña pasa cerca del horizonte sur, rosa pálido, ~20 min.
/// - Procesión de los Setenta y Tres (E3, redacción 1236) — silencio,
///   velas por el centro, baja a los Canales y termina en el Puerto.
/// - Equinoccio menor (E10/E11, redacciones 1243-1244) — velas en
///   cada planta del Mercado.
///
/// Los eventos GANAN sobre el clima diario del distrito: si el día
/// del equinoccio mayor toca lluvia normal en las Afueras, el evento
/// la sobrescribe con cielo limpio para que se vea la luna. Esto es
/// deliberado — los eventos son momentos especiales, no observación
/// meteorológica.
///
/// Módulo puro (sin Flutter, sin reloj global). Determinista por fecha.
class CalendarioEventos {
  /// Devuelve el evento aplicable a [idDistrito] en la fecha [ahora],
  /// o `null` si no hay evento ese día. Si más de uno aplica, gana el
  /// primero declarado en [todos] (no debería ocurrir con el catálogo
  /// inicial, pero la regla queda fijada por si en el futuro hay
  /// solapamientos).
  static EventoCalendario? deHoy({
    required DateTime ahora,
    required String idDistrito,
  }) {
    for (final evento in todos) {
      if (evento.aplicaEn(ahora: ahora, idDistrito: idDistrito)) {
        return evento;
      }
    }
    return null;
  }

  /// Equinoccio mayor con la luna pequeña — 20-21 de marzo. Afecta a
  /// todos los distritos: el cielo se queda muy limpio para que se vea
  /// la luna pequeña pasar por el horizonte sur. Talin Mar lo anuncia
  /// en la redacción 1252 del Faro.
  static const EventoCalendario equinoccioMayor = EventoCalendario(
    id: 'equinoccio_mayor',
    tituloDiegetico: 'Equinoccio mayor',
    mesesActivos: [3],
    diasDelMesActivos: [20, 21],
    distritosAfectados: null,
    ambiente: AmbienteCielo.cieloLimpioMontana,
    mensajeAlEntrar:
        'Esta noche, la luna pequeña. Rosa pálido. Mira el horizonte sur.',
  );

  /// Equinoccio menor — la noche más corta del año en Azula. Se
  /// celebra en el Mercado con velas en cada planta, tradición que
  /// mantiene Naini desde su puesto. Solo afecta al distrito Mercado.
  static const EventoCalendario equinoccioMenor = EventoCalendario(
    id: 'equinoccio_menor',
    tituloDiegetico: 'Equinoccio menor',
    mesesActivos: [9],
    diasDelMesActivos: [22, 23],
    distritosAfectados: ['mercado'],
    ambiente: AmbienteCielo.nocheDespejada,
    mensajeAlEntrar:
        'Velas encendidas en cada planta del Mercado. Naini lleva años con esto.',
  );

  /// Procesión de los Setenta y Tres — tradición silenciosa que
  /// recorre el centro, baja a los Canales y termina en el Puerto.
  /// Anunciada en la redacción 1236 del Faro. Afecta a todos los
  /// distritos esa noche: niebla suave, atmósfera solemne.
  static const EventoCalendario procesionSetentaTres = EventoCalendario(
    id: 'procesion_setenta_tres',
    tituloDiegetico: 'Procesión de los Setenta y Tres',
    mesesActivos: [11],
    diasDelMesActivos: [5],
    distritosAfectados: null,
    ambiente: AmbienteCielo.nieblaSuave,
    mensajeAlEntrar:
        'Procesión silenciosa esta noche por el centro. La gente camina con velas. Sin discursos.',
  );

  /// Catálogo completo. El orden importa para resolver solapamientos
  /// (gana el primero que aplique).
  static const List<EventoCalendario> todos = [
    equinoccioMayor,
    equinoccioMenor,
    procesionSetentaTres,
  ];
}

/// Un evento concreto del calendario diegético.
class EventoCalendario {
  final String id;

  /// Nombre del evento tal y como aparece en el lore (Faro, voces de
  /// Maestros). No se muestra al niño; sirve para logs y referencia.
  final String tituloDiegetico;

  /// Meses (1..12) en los que el evento está activo. Una lista para
  /// permitir eventos que crucen frontera de mes en el futuro.
  final List<int> mesesActivos;

  /// Días del mes (1..31) activos. Combinado con [mesesActivos] forma
  /// el rango exacto: por ejemplo, marzo 20 y 21 = `[3]` y `[20, 21]`.
  final List<int> diasDelMesActivos;

  /// Distritos afectados. `null` = todos. Una lista cuando el evento
  /// es local (equinoccio menor del Mercado).
  final List<String>? distritosAfectados;

  /// Ambiente atmosférico que se aplica esa noche, sobrescribiendo el
  /// clima diario del distrito.
  final AmbienteCielo ambiente;

  /// Mensaje que se muestra al niño al entrar al cazadero ese día. Se
  /// renderiza con la misma mecánica que las líneas ambientales de
  /// Sora (auto-fade a los 4 s), aunque el evento no es voz suya.
  final String mensajeAlEntrar;

  const EventoCalendario({
    required this.id,
    required this.tituloDiegetico,
    required this.mesesActivos,
    required this.diasDelMesActivos,
    required this.distritosAfectados,
    required this.ambiente,
    required this.mensajeAlEntrar,
  });

  /// `true` si este evento aplica al distrito y la fecha indicados.
  /// Comprueba mes, día y distrito (si está restringido).
  bool aplicaEn({
    required DateTime ahora,
    required String idDistrito,
  }) {
    if (!mesesActivos.contains(ahora.month)) return false;
    if (!diasDelMesActivos.contains(ahora.day)) return false;
    final distritos = distritosAfectados;
    if (distritos != null && !distritos.contains(idDistrito)) return false;
    return true;
  }
}
