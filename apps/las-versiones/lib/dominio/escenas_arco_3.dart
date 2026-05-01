import 'package:nuevo_ser_core/nuevo_ser_core.dart';

import 'ambiente_archivo.dart';
import 'voz_personaje.dart';

/// Catálogo de escenas cinemáticas del Arco 3 — *La forja del reino*
/// (doc 09). Cubre el periodo Aprendiz II → Aprendiz III, ~12-14
/// semanas de curso (marzo-mayo).
///
/// Estado: primera tanda implementada (F2-20a). Cubre la apertura
/// del Arco 3 (3.0.1 *Apertura del arco* + 3.0.2 *Eider y la
/// distancia*), la Estación 1 completa (3.1.1–3.1.5 *San Cernin*) y
/// la cinemática latente post-Estación 1 (3.A.1 *Marina y los
/// puentes*). Las restantes 5 Estaciones (3.2 Tudela y los Banu
/// Qasi, 3.3 Leyre y la leyenda del abad Virila, 3.4 Roncesvalles,
/// 3.5 Estella en su esplendor, 3.6 La Brecha del incendio de la
/// judería de Tudela de 1378) + las latentes 3.B.1/3.C.1/3.D.1 +
/// el cierre 3.Z + la ficha M3 quedan pendientes.
///
/// **TUDELA-1378** (Brecha 3.6) está marcada como **pendiente de
/// validación** del comité provisional según el README de
/// `coleccion-nuevo-ser-paquete-documental-v0.3` — es la más
/// sensible de las cinco validaciones críticas. Su implementación
/// no se aborda hasta que esa validación cierre.
///
/// El Arco 3 introduce el manejo de fuentes plurilingües (latín +
/// romance navarro + occitano gascón en San Cernin; árabe en Tudela)
/// y el primer encuentro narrativo con Tasio en la Estación 3.2 —
/// arco más cargado del MVP según anuncia el cabecero del doc 09.
class EscenasArco3 {
  EscenasArco3._();

  /// Lista ordenada de escenas del Arco 3 disponibles para el
  /// orquestador. La 3.0.1 requiere `arco_2_cerrado_por_la_cronista`
  /// (que la 2.Z.2 *La grabación* del Arco 2 activa). La 3.A.1 se
  /// ordena detrás de 3.1.5 porque requiere
  /// `arco_3_estacion_1_cerrada` (que la 3.1.5 activa). La Estación
  /// 3.2 arranca con 3.2.1 que requiere `escena_3_a_1_vista` (la
  /// latente de Marina cierra antes del viaje a Tudela). La 3.B.1
  /// se ordena detrás de 3.2.8 porque requiere
  /// `arco_3_estacion_2_cerrada` (que la 3.2.8 activa).
  static const List<EscenaCinematica> todas = [
    aperturaDelArco,
    eiderYLaDistancia,
    sanCernin,
    tresLenguas,
    elBarrioOccitano,
    concilioSanCernin,
    irunaCosmopolita,
    marinaYLosPuentes,
    caminoATudela,
    tudelaYLosBanuQasi,
    lasFuentesArabes,
    laCafeteria,
    elEncuentroConTasio,
    vueltaAlTrabajo,
    reconstruccionYConcilioBanuQasi,
    elSilencioDeMaren,
    teTratoBien,
    caminoALeyre,
    elMonasterio,
    laLeyendaDeVirila,
    cuandoSeEscribio,
    concilioLeyre,
    laLeyendaNoMienteDesplaza,
    naiaPreguntaOtraVez,
    caminoARoncesvalles,
    elPaso,
    lasDosVersiones,
    laChanson,
    reconstruccionRoncesvalles,
    concilioRoncesvalles,
    loBonitoMiente,
    eiderSeVa,
  ];

  /// Flags institucionales adicionales que el orquestador activa al
  /// cerrar una escena del Arco 3. Mismo patrón que en Arcos 1 y 2.
  static const Map<String, Set<String>> flagsDeCierrePorEscena = {
    'escena_3_0_1_vista': {
      'arco_3_iniciado',
      'tudela_1378_anunciada',
    },
    'escena_3_0_2_vista': {
      'eider_distancia_3_0_2_vista',
    },
    'escena_3_1_1_vista': {
      'san_cernin_visitado',
      'tres_burgos_aprendidos',
    },
    'escena_3_1_2_vista': {
      'tres_lenguas_trabajadas',
    },
    'escena_3_1_3_vista': {
      'toponimos_occitanos_aprendidos',
    },
    'escena_3_1_4_vista': {
      'concilio_3_1_cerrado',
    },
    'escena_3_1_5_vista': {
      'arco_3_estacion_1_cerrada',
    },
    'escena_3_a_1_vista': {
      'consejo_marina_puentes_recibido',
    },
    'escena_3_2_1_vista': {
      'aviso_aitor_tasio_recibido',
      'viaje_a_tudela_iniciado',
    },
    'escena_3_2_2_vista': {
      'mezquita_catedral_visitada',
    },
    'escena_3_2_3_vista': {
      'fuentes_arabes_estudiadas',
    },
    'escena_3_2_4_vista': {
      'cafeteria_tudela_alcanzada',
    },
    'escena_3_2_5_vista': {
      'met_tasio',
      'tasio_first_encounter',
    },
    'escena_3_2_6_vista': {
      'reconstruccion_banu_qasi_iniciada',
    },
    'escena_3_2_7_vista': {
      'concilio_3_2_cerrado',
    },
    'escena_3_2_8_vista': {
      'arco_3_estacion_2_cerrada',
    },
    'escena_3_b_1_vista': {
      'isaura_supo_de_tasio',
    },
    'escena_3_3_1_vista': {
      'leyenda_virila_oida',
      'viaje_a_leyre_iniciado',
    },
    'escena_3_3_2_vista': {
      'monasterio_leyre_visitado',
    },
    'escena_3_3_3_vista': {
      'leyenda_virila_documentada_aprendida',
    },
    'escena_3_3_4_vista': {
      'leyenda_virila_estudiada',
    },
    'escena_3_3_5_vista': {
      'concilio_3_3_cerrado',
    },
    'escena_3_3_6_vista': {
      'arco_3_estacion_3_cerrada',
    },
    'escena_3_c_1_vista': {
      'naia_pregunto_oficio',
    },
    'escena_3_4_1_vista': {
      'aviso_chanson_recibido',
      'viaje_a_roncesvalles_iniciado',
    },
    'escena_3_4_2_vista': {
      'paso_roncesvalles_alcanzado',
    },
    'escena_3_4_3_vista': {
      'dos_versiones_estudiadas',
    },
    'escena_3_4_4_vista': {
      'chanson_como_propaganda_aprendida',
    },
    'escena_3_4_5_vista': {
      'reconstruccion_roncesvalles_producida',
    },
    'escena_3_4_6_vista': {
      'concilio_3_4_cerrado',
    },
    'escena_3_4_7_vista': {
      'arco_3_estacion_4_cerrada',
    },
    'escena_3_d_1_vista': {
      'eider_se_va',
    },
  };

  /// 3.0.1 — *Apertura del arco*. Despacho de Isaura, primer día
  /// tras el descanso entre Arcos 2 y 3 (finales de febrero /
  /// principios de marzo). Isaura anuncia el calendario del arco
  /// (San Cernin → Tudela → Leyre → Roncesvalles → Estella) y, en el
  /// momento clave de la cinemática, le anticipa a Maren la Brecha
  /// del incendio de la judería de Tudela de 1378 — la que rompió
  /// la relación entre Tasio e Isaura. Le explica el porqué de
  /// elegirla a ella: porque es la persona del Archivo que puede
  /// llegar a una versión nueva sin estar atrapada en la suya o en
  /// la de Tasio. Doc 09 §3.0.1.
  static const EscenaCinematica aperturaDelArco = EscenaCinematica(
    id: '3.0.1',
    titulo: 'Apertura del arco',
    flagDeSalida: 'escena_3_0_1_vista',
    flagsRequeridos: {'arco_2_cerrado_por_la_cronista'},
    ambiente: AmbienteArchivo.despachoIsaura,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Maren entra al despacho. Isaura está terminando de '
            'revisar carpetas de varias Brechas pendientes.',
      ),
      PlanoDialogo(voz: VozPersonaje.isaura, texto: 'Aprendiz II.'),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Bien.'),
      PlanoAmbiente(
        duracion: Duration(milliseconds: 1500),
        textoLectura: 'Isaura cierra la carpeta.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: 'Este arco son tres meses. Vas a viajar mucho.',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: '¿A dónde?'),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto:
            'San Cernin para empezar — está aquí mismo. Después '
            'Tudela. Leyre. Roncesvalles. Estella.',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: '¿Tudela?'),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: 'Tarde o temprano.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 2),
        textoLectura: 'Maren no insiste.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto:
            'Y al final del arco hay una Brecha que vas a tener que '
            'trabajar.',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: '¿Cuál?'),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: 'La del incendio de la judería de Tudela de 1378.',
        pausaPrevia: Duration(milliseconds: 1000),
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura: 'Silencio largo. Maren mira a Isaura.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: '¿La que rompió a Tasio contigo?',
      ),
      PlanoDialogo(voz: VozPersonaje.isaura, texto: 'Esa.'),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Vale.',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto:
            'Te lo digo ahora para que lo lleves contigo. No vas a '
            'trabajarla hasta el final del arco. Pero quiero que '
            'sepas que viene.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: '¿Por qué me tocas a mí?',
        pausaPrevia: Duration(milliseconds: 1000),
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto:
            'Porque ahora mismo eres la persona del Archivo que puede '
            'llegar a una versión nueva sin estar atrapada en la mía '
            'o en la suya.',
        pausaPrevia: Duration(milliseconds: 1800),
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'No estoy segura de poder.',
        pausaPrevia: Duration(milliseconds: 1000),
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto:
            'Yo tampoco lo estoy. Pero tienes tres meses para '
            'prepararte.',
      ),
      PlanoAmbiente(duracion: Duration(milliseconds: 1500)),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto:
            'Esta semana San Cernin. Cosas más sencillas. Vamos a '
            'empezar suave.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Maren asiente. Sale del despacho. La cámara se queda '
            'con Isaura, que mira la carpeta de la Brecha de 1378 '
            'sobre la mesa. La abre. Ve dos páginas. La cierra. La '
            'guarda en el cajón donde tiene su cuaderno marrón.',
      ),
    ],
  );

  /// 3.0.2 — *Eider y la distancia*. Sábado tarde. Banco en la
  /// plaza del Castillo. Eider le dice a Maren que se va a perder
  /// su partido importante de baloncesto. Maren está fuera ese
  /// día (Tudela). Eider responde corta — *"Otra vez fuera"* — y se
  /// va sin despedirse del todo. Maren se queda sola con el refresco
  /// a medio tomar. Voz del Cuaderno breve. Doc 09 §3.0.2.
  static const EscenaCinematica eiderYLaDistancia = EscenaCinematica(
    id: '3.0.2',
    titulo: 'Eider y la distancia',
    flagDeSalida: 'escena_3_0_2_vista',
    flagsRequeridos: {'escena_3_0_1_vista'},
    ambiente: AmbienteArchivo.plazaCastilloIruna,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Sábado tarde. Las dos sentadas en un banco con un '
            'refresco. Eider tiene que irse pronto al baloncesto.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.eider,
        texto: 'Tía. Te vas a perder mi partido importante.',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: '¿Cuándo?'),
      PlanoDialogo(
        voz: VozPersonaje.eider,
        texto: 'El 12. Final de la liga juvenil.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Joder. Estoy fuera el 12. Tudela.',
      ),
      PlanoDialogo(voz: VozPersonaje.eider, texto: 'Otra vez fuera.'),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Sí.'),
      PlanoDialogo(
        voz: VozPersonaje.eider,
        texto: 'Bueno.',
        pausaPrevia: Duration(milliseconds: 1000),
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura: 'Eider mira el reloj.',
      ),
      PlanoDialogo(voz: VozPersonaje.eider, texto: 'Me tengo que ir.'),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Vale.'),
      PlanoDialogo(
        voz: VozPersonaje.eider,
        texto: '¿Sabes qué? Da igual.',
        pausaPrevia: Duration(milliseconds: 1000),
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'No da igual.',
        pausaPrevia: Duration(milliseconds: 800),
      ),
      PlanoDialogo(
        voz: VozPersonaje.eider,
        texto: 'No me lo digas para que me sienta mejor.',
        pausaPrevia: Duration(milliseconds: 1000),
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Maren no contesta. Eider se va. Maren se queda sentada '
            'con el refresco a medio tomar.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto: 'Eider está enfadada. Tiene razón.',
        pausaPrevia: Duration(milliseconds: 1200),
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto: 'No sé qué hacer.',
      ),
    ],
  );

  /// 3.1.1 — *San Cernin*. Iglesia de San Saturnino (San Cernin) en
  /// Iruña, plaza Consistorial cercana. Isaura le explica a Maren
  /// que la iglesia la fundaron los francos del Camino, y que el
  /// santo titular procede de Tolosa de Francia (Saturnino → Sernin
  /// → Cernin). Le presenta el modelo de los tres burgos medievales
  /// de Pamplona: Navarrería (vasco-romance), San Cernin (francos
  /// occitano-hablantes del Camino), San Nicolás (burgueses
  /// comerciantes). Cada uno con sus propios fueros, murallas y
  /// enemistades. Doc 09 §3.1.1.
  ///
  /// Material trazable: iglesia de San Saturnino real en Pamplona,
  /// fundación franca documentada, modelo de los tres burgos
  /// medievales con sus murallas separadas y conflictos resueltos
  /// por el Privilegio de la Unión de 1423.
  static const EscenaCinematica sanCernin = EscenaCinematica(
    id: '3.1.1',
    titulo: 'San Cernin',
    flagDeSalida: 'escena_3_1_1_vista',
    flagsRequeridos: {'escena_3_0_2_vista'},
    ambiente: AmbienteArchivo.iglesiaSanCernin,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Maren e Isaura caminan por el casco viejo de Iruña. '
            'Llegan a la iglesia de San Cernin. Iglesia gótica con '
            'dos torres asimétricas. Plaza pequeña delante.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto:
            'Ésta es la iglesia. La fundaron los francos del Camino. '
            'Fíjate en el nombre.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'San Cernin. ¿De dónde es ese santo?',
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto:
            'Tolosa de Francia. Saturnino, Sernin, Cernin — la misma '
            'palabra en distintas pronunciaciones.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Entonces la iglesia se llama como un santo francés.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto:
            'Sí. Y el barrio entero, durante siglos, fue de gente que '
            'venía de fuera. Francos. Hablaban occitano gascón '
            'mayoritariamente. Tenían sus propios fueros, su propia '
            'administración. Iruña fue durante doscientos años tres '
            'ciudades en una.',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: '¿Tres?'),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto:
            'Navarrería — la antigua, vasco-romance. San Cernin — los '
            'francos del Camino. San Nicolás — los burgueses '
            'comerciantes que vinieron después. Cada una con sus '
            'murallas, sus fueros, sus enemistades.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura:
            'Maren mira las torres asimétricas. Diferentes alturas.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Parece que cada una se hizo en una época distinta.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: 'Lo está. Tu Brecha es esto.',
      ),
    ],
  );

  /// 3.1.2 — *Tres lenguas*. Mesa de Trabajo del Archivo. Maren
  /// trabaja con tres tipos de documentos plurilingües del Iruña
  /// medieval del s. XII-XIII: el Fuero de Pamplona-San Cernin
  /// (1129) en latín jurídico, una carta de queja del concejo de la
  /// Navarrería al rey Sancho VI en romance navarro (s. XII), y un
  /// fragmento de regla interna de los burgueses de San Cernin en
  /// occitano gascón (s. XIII). HF.07 (lectura en lengua original)
  /// extendida a tres lenguas. Doc 09 §3.1.2.
  ///
  /// Las afirmaciones que la Cronista produce (no jugables todavía
  /// — la Brecha 3.1 jugable llegará en un slice posterior; este
  /// slice cubre sólo la cinemática narrativa): plurilingüismo
  /// estructural del Iruña medieval (Probable, basado en evidencia
  /// indirecta para el uso oral cotidiano del euskera bajo el
  /// trilingüismo escrito), conflictos entre los tres burgos
  /// duraron casi dos siglos resueltos por el Privilegio de la
  /// Unión de 1423 (Sólido). Material trazable.
  static const EscenaCinematica tresLenguas = EscenaCinematica(
    id: '3.1.2',
    titulo: 'Tres lenguas',
    flagDeSalida: 'escena_3_1_2_vista',
    flagsRequeridos: {'escena_3_1_1_vista'},
    ambiente: AmbienteArchivo.mesaTrabajoArchivo,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Mesa de Trabajo del Archivo. Días siguientes. Maren con '
            'tres tipos de documentos delante: latín jurídico, romance '
            'navarro y occitano gascón.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            '1. Latín — el Fuero de Pamplona-San Cernin (1129), '
            'redactado en latín jurídico medieval.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            '2. Romance navarro — una carta de queja del concejo de '
            'la Navarrería al rey Sancho VI, del s. XII.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            '3. Occitano gascón — un fragmento de regla interna de '
            'los burgueses de San Cernin, del s. XIII.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'La interfaz le permite leer cada uno con apoyo del tutor. '
            'Las tres lenguas tienen aire familiar — comparten raíz '
            'romance — pero divergen en ortografía, vocabulario, '
            'sintaxis.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto: 'Tres lenguas para tres comunidades en la misma ciudad.',
        pausaPrevia: Duration(milliseconds: 1200),
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto:
            'Esto es muy distinto de lo que yo pensaba que era una '
            'ciudad medieval. Yo pensaba que había una iglesia, un '
            'señor, un castillo, gente que servía. Pero aquí había '
            'tres comunidades distintas con sus propios fueros, '
            'peleadas entre sí, y tres lenguas escritas a la vez.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto: '¿Por qué no sabía esto?',
        pausaPrevia: Duration(milliseconds: 800),
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'La Cronista produce 7 afirmaciones. La más interesante: '
            'que los conflictos entre los tres burgos duraron casi '
            'dos siglos y se resolvieron sólo por el Privilegio de la '
            'Unión de 1423 — Sólido. Y que el plurilingüismo del '
            'Iruña medieval es estructural, no accidental — Probable.',
      ),
    ],
  );

  /// 3.1.3 — *El barrio occitano*. Paseo por la calle de la
  /// Navarrería y zonas adyacentes. Isaura le señala a Maren las
  /// huellas occitanas en el callejero del casco viejo (*"Calle
  /// Mayor"* viene de *"Carrera Maior"* occitana, no del castellano).
  /// Maren pregunta por los topónimos vascos: Isaura le explica que
  /// el sustrato vasco se conservó en muchos nombres de barrios y
  /// montes pero no se escribió formalmente — los oficios institu-
  /// cionales del medievo eran en latín, romance y occitano; el
  /// euskera quedó como lengua del paisaje en glosas y formas
  /// castellanizadas. Maren conecta: *"Eso es Wamba otra vez."*
  /// Doc 09 §3.1.3.
  static const EscenaCinematica elBarrioOccitano = EscenaCinematica(
    id: '3.1.3',
    titulo: 'El barrio occitano',
    flagDeSalida: 'escena_3_1_3_vista',
    flagsRequeridos: {'escena_3_1_2_vista'},
    ambiente: AmbienteArchivo.calleNavarreria,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Caminan por el casco viejo. Isaura le va señalando '
            'placas, edificios, calles cuyos nombres tienen origen '
            'distinto.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto:
            'Calle Mayor. Esa palabra es occitana, no castellana. '
            'Carrera Maior.',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: '¿Y los topónimos vascos?'),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto:
            'Sustrato. Muchos nombres de barrios y montes. Los oficios '
            'formales del medievo eran en latín, en romance, en '
            'occitano. Los nombres del paisaje siguieron siendo en '
            'euskera para mucha gente — pero no se escribieron salvo '
            'en glosas o en formas castellanizadas.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Eso es Wamba otra vez.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: 'Una versión menos brutal pero estructural igual.',
      ),
    ],
  );

  /// 3.1.4 — *Concilio* de la Estación 3.1. Salón del Concilio.
  /// Aitor revisor + Karim. La Cronista presenta su reconstrucción.
  /// Aitor le hace preguntas técnicas. Karim le hace la pregunta
  /// pedagógica clave: por qué declaró Probable y no Sólido el
  /// plurilingüismo estructural del Iruña medieval. Maren responde
  /// articulando la diferencia metodológica — la documentación
  /// trilingüe es Sólida, pero la inferencia sobre la presencia
  /// hablada del euskera bajo todo se basa en evidencia indirecta
  /// (toponimia, glosas, menciones en otras fuentes); declararla
  /// Sólido sería afirmar como hecho lo que es altísimamente
  /// probable pero no documentado en uso oral cotidiano. Doc 09
  /// §3.1.4.
  static const EscenaCinematica concilioSanCernin = EscenaCinematica(
    id: '3.1.4',
    titulo: 'Concilio de San Cernin',
    flagDeSalida: 'escena_3_1_4_vista',
    flagsRequeridos: {'escena_3_1_3_vista'},
    ambiente: AmbienteArchivo.salonConcilio,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Salón del Concilio. Aitor (revisor) y Karim a la mesa. '
            'La Cronista presenta su reconstrucción. Aitor le hace '
            'preguntas técnicas sobre las fuentes.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.karim,
        texto:
            'Has declarado Probable que el plurilingüismo de Iruña '
            'medieval es estructural, no accidental. ¿Por qué Probable '
            'y no Sólido?',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto:
            'Porque la documentación trilingüe es Sólida, pero la '
            'inferencia sobre la presencia hablada del euskera bajo '
            'todo se basa en evidencia indirecta — toponimia, glosas, '
            'menciones en otras fuentes. Si declaro Sólido el '
            'plurilingüismo estructural, estoy afirmando como hecho lo '
            'que es altísimamente probable pero no documentado en su '
            'uso oral cotidiano.',
        pausaPrevia: Duration(milliseconds: 1000),
      ),
      PlanoDialogo(voz: VozPersonaje.karim, texto: 'Bien.'),
      PlanoDialogo(voz: VozPersonaje.aitor, texto: 'Sellada.'),
    ],
  );

  /// 3.1.5 — *Iruña cosmopolita*. Esa noche, voz del Cuaderno.
  /// Cierre de la Estación 3.1 con la lección integradora — Iruña
  /// como tres ciudades superpuestas históricamente (Navarrería /
  /// San Cernin / San Nicolás en romance / occitano / latín
  /// jurídico, con el euskera del paisaje siempre debajo) y
  /// contemporáneamente (la que pisa Antonio en castellano, la que
  /// pisa Eider en euskera, la que pisan juntas Maren y Eider sin
  /// pensarlo). Doc 09 §3.1.5.
  static const EscenaCinematica irunaCosmopolita = EscenaCinematica(
    id: '3.1.5',
    titulo: 'Iruña cosmopolita',
    flagDeSalida: 'escena_3_1_5_vista',
    flagsRequeridos: {'escena_3_1_4_vista'},
    ambiente: AmbienteArchivo.cuartoCasaMaren,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura:
            'Es de noche. Maren en su mesa, cuaderno abierto.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto:
            'Iruña ha sido siempre tres ciudades, no una. La que pisa '
            'mi padre en castellano. La que pisa Eider en euskera. La '
            'que pisamos juntas las dos sin pensar.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto:
            'Y antes había otra trinidad: Navarrería, San Cernin, San '
            'Nicolás. En romance, en occitano, en latín jurídico. Y '
            'debajo, siempre, el euskera del paisaje.',
        pausaPrevia: Duration(milliseconds: 800),
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto:
            'Esto cambia algo de cómo veo la calle Mayor cuando la '
            'cruzo.',
        pausaPrevia: Duration(milliseconds: 800),
      ),
    ],
  );

  /// 3.A.1 — *Marina y los puentes*. Latente post-Estación 3.1.
  /// ~10 días después. Cocina del Archivo. Marina entra mientras
  /// Maren se hace un café. Le ofrece su consejo de hermana mayor
  /// para futuras Brechas plurilingües: *"no las trates como
  /// traducciones unas de otras. Cada lengua es un puente al
  /// pensamiento de quien la hablaba. Y el puente tiene su propia
  /// geografía."* Maren conecta el consejo con la lección de
  /// Quintiliano (Estación 2.2). Marina sonríe y apunta el patrón:
  /// *"las cosas que enseñan las hermanas mayores son las que ya se
  /// te están formando."* Doc 09 §3.A.1.
  static const EscenaCinematica marinaYLosPuentes = EscenaCinematica(
    id: '3.A.1',
    titulo: 'Marina y los puentes',
    flagDeSalida: 'escena_3_a_1_vista',
    flagsRequeridos: {'arco_3_estacion_1_cerrada'},
    ambiente: AmbienteArchivo.cocinaArchivo,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura: 'Maren se hace un café. Marina entra.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.marina,
        texto: '¿Qué tal San Cernin?',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Tres lenguas. Difícil pero bonito.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.marina,
        texto: 'Mi consejo de hermana mayor.',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Vale.'),
      PlanoDialogo(
        voz: VozPersonaje.marina,
        texto:
            'Cuando trabajes Brechas con varias lenguas, no las trates '
            'como traducciones unas de otras. Cada lengua es un puente '
            'al pensamiento de quien la hablaba. Y el puente tiene su '
            'propia geografía.',
      ),
      PlanoAmbiente(duracion: Duration(milliseconds: 1500)),
      PlanoDialogo(
        voz: VozPersonaje.marina,
        texto:
            'Si traduces sin tener en cuenta la geografía del puente, '
            'te pierdes lo importante.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Eso es como Quintiliano.',
        pausaPrevia: Duration(milliseconds: 1000),
      ),
      PlanoDialogo(voz: VozPersonaje.marina, texto: 'Exacto.'),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto:
            'Pasa mucho contigo, Marina. Dices algo y yo encuentro un '
            'eco con algo que ya pasó.',
        pausaPrevia: Duration(milliseconds: 1000),
      ),
      PlanoDialogo(
        voz: VozPersonaje.marina,
        texto:
            'Eso es porque las cosas que enseñan las hermanas mayores '
            'son las que ya se te están formando.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 2),
        textoLectura: 'Marina sale.',
      ),
    ],
  );

  /// 3.2.1 — *Camino a Tudela*. Mediados de marzo. Aitor lleva a
  /// Maren a Tudela en su C4 (Isaura tiene tribunal ese día). Hora
  /// y media de viaje. Aitor le avisa explícitamente: *"Tasio está
  /// en Tudela. Es probable que te encuentre. Esto no es
  /// coincidencia accidental — él sabe que tú vas a venir aquí esta
  /// semana. Lo sabe porque alguien del Archivo se lo dice por
  /// costumbre."* Karim como informante honesto. Aitor declina ser
  /// mentor de la situación (*"yo no soy tu mentor en esto"*) pero
  /// le da el consejo metodológico clave: *"si hablas con él, no te
  /// tienes que defender. No te está atacando. Pero tampoco te está
  /// cuidando. Está examinándote. No hay nada malo en dejarse
  /// examinar — pero tienes que saber qué le enseñas tú."* Doc 09
  /// §3.2.1.
  static const EscenaCinematica caminoATudela = EscenaCinematica(
    id: '3.2.1',
    titulo: 'Camino a Tudela',
    flagDeSalida: 'escena_3_2_1_vista',
    flagsRequeridos: {'escena_3_a_1_vista'},
    ambiente: AmbienteArchivo.cocheAitor,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Aitor conduce un C4 más nuevo que el de Isaura. Maren '
            'va de copiloto. Hora y media de viaje hasta la Ribera.',
      ),
      PlanoDialogo(voz: VozPersonaje.aitor, texto: 'Te aviso de algo.'),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Vale.'),
      PlanoDialogo(
        voz: VozPersonaje.aitor,
        texto: 'Tasio está en Tudela. Lo sabes.',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Lo sabía.'),
      PlanoDialogo(
        voz: VozPersonaje.aitor,
        texto:
            'Es probable que te encuentre. Esto no es coincidencia '
            'accidental — él sabe que tú vas a venir aquí esta '
            'semana. Lo sabe porque alguien del Archivo se lo dice '
            'por costumbre.',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: '¿Quién?'),
      PlanoDialogo(
        voz: VozPersonaje.aitor,
        texto:
            'Karim. Pero Karim es honesto y te lo diría a la cara si '
            'se lo preguntas.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: '¿Tasio va a aparecer?',
        pausaPrevia: Duration(milliseconds: 1000),
      ),
      PlanoDialogo(
        voz: VozPersonaje.aitor,
        texto: 'Probable. Sólido tirando a Probable.',
      ),
      PlanoAmbiente(duracion: Duration(milliseconds: 1500)),
      PlanoDialogo(voz: VozPersonaje.maren, texto: '¿Qué hago?'),
      PlanoDialogo(
        voz: VozPersonaje.aitor,
        texto: 'Lo que decidas.',
        pausaPrevia: Duration(milliseconds: 1000),
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Eso no es respuesta.'),
      PlanoDialogo(
        voz: VozPersonaje.aitor,
        texto: 'Es la única que tengo. Yo no soy tu mentor en esto.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Maren mira el paisaje. La Ribera se abre — campos de '
            'regadío, el Ebro a lo lejos.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.aitor,
        texto: 'Pero te voy a decir una cosa.',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Vale.'),
      PlanoDialogo(
        voz: VozPersonaje.aitor,
        texto:
            'Si hablas con él, no te tienes que defender. No te está '
            'atacando. Pero tampoco te está cuidando. Está '
            'examinándote. No hay nada malo en dejarse examinar — '
            'pero tienes que saber qué le enseñas tú.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Vale.',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
    ],
  );

  /// 3.2.2 — *Tudela y los Banu Qasi*. Llegan a Tudela. Distinta al
  /// norte: calor más pronto en el año, ladrillo en lugar de piedra,
  /// casas con galería. Visitan la mezquita-catedral por fuera —
  /// edificio que es las dos cosas a la vez (mezquita aljama del s.
  /// IX al XII, catedral cristiana tras 1119). Capiteles que
  /// reutilizan piezas islámicas, inscripciones árabes parcialmente
  /// borradas en una sala lateral. Aitor le explica que la cuestión
  /// de qué se conservó y qué no es ya parte de su Brecha. Doc 09
  /// §3.2.2.
  ///
  /// Material trazable: Catedral de Santa María de Tudela real,
  /// construcción cristiana sobre la mezquita aljama tras la
  /// conquista de 1119, conservación parcial de elementos islámicos
  /// como hecho arqueológico documentado. BANU-QASI Prioridad 2 del
  /// comité provisional sin validar — registro en BLOQUEOS.
  static const EscenaCinematica tudelaYLosBanuQasi = EscenaCinematica(
    id: '3.2.2',
    titulo: 'Tudela y los Banu Qasi',
    flagDeSalida: 'escena_3_2_2_vista',
    flagsRequeridos: {'escena_3_2_1_vista'},
    ambiente: AmbienteArchivo.mezquitaCatedralTudela,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Tudela. Distinto al norte. Calor más pronto en el año. '
            'Ladrillo en lugar de piedra. Casas con galería. La '
            'mezquita-catedral por fuera — un edificio que es las dos '
            'cosas a la vez.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.aitor,
        texto:
            'Esto fue mezquita aljama del s. IX al XII. Tras la '
            'conquista cristiana, catedral. Conserva elementos de las '
            'dos cosas dentro.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Entran. Las naves cristianas medievales tienen capiteles '
            'que reutilizan piezas islámicas. Inscripciones árabes '
            'parcialmente borradas en una sala lateral.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: '¿La conservaron así a propósito?',
      ),
      PlanoDialogo(
        voz: VozPersonaje.aitor,
        texto:
            'En parte sí, en parte no llegaron a destruir todo. La '
            'cuestión de qué se conservó y qué no es ya tu Brecha.',
      ),
    ],
  );

  /// 3.2.3 — *Las fuentes árabes*. Sala de trabajo cedida por el
  /// museo de Tudela con material árabe sobre los Banu Qasi. La
  /// conservadora del museo (sin nombre en el doc) le presenta el
  /// material: Ibn Hayyán *Muqtabis* (s. XI, fuente cordobesa
  /// hostil cuando los Banu Qasi se rebelan), Al-Razi (s. X,
  /// descripción geográfica de Tudela), crónica anónima del periodo,
  /// inscripciones árabes locales, *Crónica de Alfonso III* y otras
  /// cristianas que mencionan a los Banu Qasi como aliados o
  /// enemigos según conveniencia, material arqueológico (alcazaba,
  /// cerámica, monedas). Voz del Cuaderno articulando que los
  /// Banu Qasi eran muladíes — descendientes hispano-godos
  /// convertidos al islam — y que la pregunta moderna *"¿musulmanes
  /// o hispanos?"* presupone una dicotomía que en su época no
  /// funcionaba así. Doc 09 §3.2.3.
  static const EscenaCinematica lasFuentesArabes = EscenaCinematica(
    id: '3.2.3',
    titulo: 'Las fuentes árabes',
    flagDeSalida: 'escena_3_2_3_vista',
    flagsRequeridos: {'escena_3_2_2_vista'},
    ambiente: AmbienteArchivo.salaMuseoTudela,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Sala de trabajo cedida por el museo de Tudela. La '
            'conservadora le presenta el material a Maren. Las '
            'fuentes árabes principales para los Banu Qasi están '
            'sobre la mesa.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 6),
        textoLectura:
            '1. Ibn Hayyán (s. XI), Muqtabis — fuente cordobesa '
            'hostil a los Banu Qasi cuando se rebelan.\n'
            '2. Al-Razi (s. X) — descripción geográfica que '
            'menciona Tudela.\n'
            '3. Crónica anónima del periodo, fragmentos.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 6),
        textoLectura:
            '4. Inscripciones árabes locales conservadas, algunas '
            'datadas, otras no.\n'
            '5. Crónicas cristianas — la Crónica de Alfonso III y '
            'otras que mencionan a los Banu Qasi como aliados o '
            'enemigos según conveniencia.\n'
            '6. Material arqueológico — alcazaba, restos cerámicos, '
            'monedas.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Maren trabaja durante varias horas. La interfaz le '
            'permite leer fragmentos en árabe original con apoyo del '
            'tutor, comparar con versiones cristianas paralelas.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto:
            'Los Banu Qasi son fascinantes. Eran muladíes — '
            'descendientes hispano-godos convertidos. Su nombre Qasi '
            'viene de Casio, el conde visigodo que se convirtió al '
            'islam tras la invasión.',
        pausaPrevia: Duration(milliseconds: 1000),
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto:
            'Eran cristianos hace tres generaciones. Después fueron '
            'musulmanes plenos. Después se aliaron con vascones de '
            'Pamplona contra Córdoba. Después fueron derrotados por '
            'Córdoba y reabsorbidos.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto:
            'La cuestión de su identidad es difícil. ¿Eran '
            '"musulmanes pero hispanos"? ¿"Hispanos pero musulmanes"? '
            'Las dos cosas a la vez. La pregunta presupone una '
            'dicotomía que en su época no funcionaba así.',
      ),
    ],
  );

  /// 3.2.4 — *La cafetería*. 13:30, salen del museo. Aitor conoce
  /// un sitio en el casco viejo de Tudela: cafetería pequeña de
  /// cinco mesas y una barra. El dueño le saluda con la cabeza —
  /// Aitor es cliente habitual de otras visitas. Se sientan, piden,
  /// Aitor lee correo en el móvil, Maren bebe agua. **Tres minutos
  /// después, Tasio entra.** Doc 09 §3.2.4.
  static const EscenaCinematica laCafeteria = EscenaCinematica(
    id: '3.2.4',
    titulo: 'La cafetería',
    flagDeSalida: 'escena_3_2_4_vista',
    flagsRequeridos: {'escena_3_2_3_vista'},
    ambiente: AmbienteArchivo.cafeteriaCascoViejoTudela,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Salen del museo a las 13:30. Aitor conoce un sitio en '
            'el casco viejo.',
      ),
      PlanoDialogo(voz: VozPersonaje.aitor, texto: 'Aquí. Comen bien.'),
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Cafetería pequeña, cinco mesas, una barra. El dueño los '
            'conoce a Aitor de otras visitas — saluda con la cabeza.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Se sientan. Piden. Aitor lee un correo en el móvil. '
            'Maren bebe agua.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura: 'Tres minutos después, Tasio entra.',
      ),
    ],
  );

  /// 3.2.5 — *El encuentro con Tasio*. Misma cafetería. Primer
  /// encuentro narrativo con Tasio (32 años, camisa azul lavada,
  /// vaqueros, botas; cara abierta, ni sonrisa simpática ni mirada
  /// agresiva, sólo presencia). Tasio invita a Maren a un café —
  /// *"Esto no es soborno. Es protocolo."* La conversación que
  /// sigue es un examen pedagógico sin disfrazarse: Tasio le hace
  /// tres preguntas clave (*"¿Crees que el Archivo es reformable
  /// desde dentro?"* / *"¿Tú quieres ser Isaura?"* / *"¿Qué quieres
  /// ser?"*) y le deja una cuarta pregunta para mascar sola (sobre
  /// la asunción de que ser Isaura es el techo). Cierre con la
  /// petición clave: *"Cuando trabajes la Brecha del incendio de la
  /// judería de Tudela del 1378, recuérdame. Porque la Brecha tiene
  /// tres lecturas: la de Isaura, la mía, y la tercera. La tercera
  /// es la tuya, si la haces. No la fuerces. Pero no la evites
  /// tampoco."* Aitor se queda en su mesa sin intervenir. Doc 09
  /// §3.2.5.
  static const EscenaCinematica elEncuentroConTasio = EscenaCinematica(
    id: '3.2.5',
    titulo: 'El encuentro con Tasio',
    flagDeSalida: 'escena_3_2_5_vista',
    flagsRequeridos: {'escena_3_2_4_vista'},
    ambiente: AmbienteArchivo.cafeteriaCascoViejoTudela,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Tasio. 32 años. Camisa azul lavada, vaqueros, botas. '
            'Cara abierta — ni la sonrisa simpática ni la mirada '
            'agresiva. Sólo presencia.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura:
            'Mira hacia la mesa de Aitor. Aitor levanta la vista del '
            'móvil.',
      ),
      PlanoDialogo(voz: VozPersonaje.tasio, texto: 'Aitor.'),
      PlanoDialogo(voz: VozPersonaje.aitor, texto: 'Tasio.'),
      PlanoDialogo(
        voz: VozPersonaje.tasio,
        texto: '¿Tú eres la nueva de Isaura?',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura: 'Maren tarda tres segundos.',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Soy Maren.'),
      PlanoDialogo(
        voz: VozPersonaje.tasio,
        texto:
            'Lo sé. ¿Te puedo invitar a un café cuando termines la '
            'comida?',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura:
            'Maren mira a Aitor. Aitor le hace un asentimiento '
            'mínimo: tú decides. Vuelve al móvil.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Vale.',
        pausaPrevia: Duration(milliseconds: 1000),
      ),
      PlanoDialogo(
        voz: VozPersonaje.tasio,
        texto: 'Quince minutos. Estoy en la barra.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Tasio se va a la barra. Pide un café. Lee un libro '
            'pequeño.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura: 'Aitor habla en voz muy baja sin mirar a Maren.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.aitor,
        texto:
            'Yo me quedo aquí. Si necesitas que intervenga, mira '
            'hacia mí. Si no, no me meto.',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Vale.'),
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Aitor sigue con el móvil. Maren come. Acaba en quince '
            'minutos. Va a la barra. Tasio cierra el libro. Le hace '
            'señas para que se siente en una mesa pequeña al fondo.',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Café también.'),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'El camarero trae los cafés. Tasio paga los dos antes de '
            'que Maren pueda intervenir.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.tasio,
        texto: 'Esto no es soborno. Es protocolo.',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Ya.'),
      PlanoAmbiente(
        duracion: Duration(seconds: 2),
        textoLectura: 'Tasio bebe.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.tasio,
        texto: '¿Cuánto llevas en el oficio?',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Ocho meses.'),
      PlanoDialogo(voz: VozPersonaje.tasio, texto: 'Y ya en Tudela.'),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Vine a trabajar los Banu Qasi.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.tasio,
        texto: 'Buen lugar para empezar la Ribera.',
      ),
      PlanoAmbiente(duracion: Duration(milliseconds: 1500)),
      PlanoDialogo(voz: VozPersonaje.tasio, texto: '¿Qué te parece la Brecha?'),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto:
            'Difícil. Las fuentes árabes son riquísimas pero hay que '
            'aprender a leerlas. Las cristianas son hostiles y '
            'filtran lo importante. Y los restos arqueológicos están '
            'limitados — la alcazaba se ha estudiado pero el barrio '
            'musulmán fuera, menos.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.tasio,
        texto: '¿Y eso te dice algo?',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Que la mirada arqueológica también ha sido sesgada.',
        pausaPrevia: Duration(milliseconds: 800),
      ),
      PlanoDialogo(voz: VozPersonaje.tasio, texto: 'Bien.'),
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura:
            'Tasio cambia de tono ligeramente. Más directo.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.tasio,
        texto: 'Maren. ¿Te puedo preguntar algo más directo?',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Vale.'),
      PlanoDialogo(
        voz: VozPersonaje.tasio,
        texto: '¿Crees que el Archivo es reformable desde dentro?',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura:
            'Maren se queda. Aitor desde su mesa no levanta la vista.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'No sé.',
        pausaPrevia: Duration(milliseconds: 1000),
      ),
      PlanoDialogo(
        voz: VozPersonaje.tasio,
        texto:
            'Esa respuesta es buena. La gente que está segura de que '
            'sí está mintiendo. La gente que está segura de que no '
            'está vendiendo el oficio entero.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Pero tú decidiste que no.',
        pausaPrevia: Duration(milliseconds: 1000),
      ),
      PlanoDialogo(
        voz: VozPersonaje.tasio,
        texto: 'Yo decidí que para mí no. Eso no es lo mismo.',
        pausaPrevia: Duration(milliseconds: 1000),
      ),
      PlanoAmbiente(duracion: Duration(seconds: 2)),
      PlanoDialogo(
        voz: VozPersonaje.tasio,
        texto: 'Otra. ¿Tú quieres ser Isaura?',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura: 'Pausa muy larga.',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'No.'),
      PlanoDialogo(voz: VozPersonaje.tasio, texto: '¿Qué quieres ser?'),
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura: 'Pausa más larga aún.',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'No lo sé.'),
      PlanoDialogo(
        voz: VozPersonaje.tasio,
        texto:
            'Tampoco lo sabía yo a tu edad. Pero tenía la sensación '
            'de que ser Isaura era el techo. ¿La tienes tú?',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'No me la había hecho hasta ahora.',
        pausaPrevia: Duration(milliseconds: 1000),
      ),
      PlanoDialogo(
        voz: VozPersonaje.tasio,
        texto:
            'La pregunta no es trampa. Te la dejo para que la masques '
            'sola.',
        pausaPrevia: Duration(milliseconds: 800),
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Vale.'),
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura:
            'Tasio termina su café. Mira a Maren con seriedad nueva.',
      ),
      PlanoDialogo(voz: VozPersonaje.tasio, texto: 'Una última.'),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Vale.'),
      PlanoDialogo(
        voz: VozPersonaje.tasio,
        texto:
            'Cuando trabajes la Brecha del incendio de la judería de '
            'Tudela del 1378, recuérdame.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: '¿Por qué?',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
      PlanoDialogo(
        voz: VozPersonaje.tasio,
        texto:
            'Porque la Brecha tiene tres lecturas: la de Isaura, la '
            'mía, y la tercera. La tercera es la tuya, si la haces. '
            'No la fuerces. Pero no la evites tampoco.',
      ),
      PlanoAmbiente(duracion: Duration(milliseconds: 1500)),
      PlanoDialogo(
        voz: VozPersonaje.tasio,
        texto:
            'Si llegas a una versión propia, defiéndela bien. Si no '
            'llegas, no te inventes una para complacer a nadie. Ni a '
            'Isaura, ni a mí.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Tasio se levanta. Le tiende la mano. Maren se la da. '
            'Apretón breve, firme.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.tasio,
        texto: 'Vas a ser buena. Tú decide a qué.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Tasio sale. La puerta de la cafetería se cierra. Maren '
            'se queda sentada en la mesa con el café a medio terminar. '
            'Aitor desde su mesa la mira por primera vez. No comenta.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.aitor,
        texto: '¿Volvemos al museo?',
        pausaPrevia: Duration(milliseconds: 2000),
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Sí.'),
    ],
  );

  /// 3.2.6 — *Vuelta al trabajo*. Esa tarde. Sala del museo de
  /// Tudela. Maren vuelve al trabajo durante tres horas más con las
  /// fuentes. Aitor lee en una silla cercana sin molestarla. Maren
  /// produce una reconstrucción inicial de los Banu Qasi. Termina a
  /// las seis y le pide a Aitor volver a Iruña. En el coche, Maren
  /// no habla durante una hora. Aitor pone música baja —
  /// instrumental, sin comentar. Cuarenta minutos antes de Iruña,
  /// Maren rompe el silencio: *"¿Tasio era así de directo de
  /// joven?"* / *"Más."* Maren decide no contarle a Isaura todavía
  /// — Aitor confirma con suavidad: *"Isaura no regaña por
  /// silencios necesarios."* Doc 09 §3.2.6.
  static const EscenaCinematica vueltaAlTrabajo = EscenaCinematica(
    id: '3.2.6',
    titulo: 'Vuelta al trabajo',
    flagDeSalida: 'escena_3_2_6_vista',
    flagsRequeridos: {'escena_3_2_5_vista'},
    ambiente: AmbienteArchivo.salaMuseoTudela,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Maren vuelve al trabajo. Tres horas más con las fuentes. '
            'Aitor lee en una silla cercana sin molestarla. Maren '
            'produce una reconstrucción inicial de los Banu Qasi. La '
            'afina. Termina a las seis. Le pide a Aitor volver a '
            'Iruña.',
      ),
      PlanoDialogo(voz: VozPersonaje.aitor, texto: '¿Ya?'),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Sí.'),
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Vuelven en el coche. Maren no habla durante una hora. '
            'Aitor pone música baja — algo instrumental, no comenta.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura:
            'Cuarenta minutos antes de Iruña, Maren habla.',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Aitor.'),
      PlanoDialogo(voz: VozPersonaje.aitor, texto: '¿Sí?'),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: '¿Tasio era así de directo de joven?',
      ),
      PlanoDialogo(
        voz: VozPersonaje.aitor,
        texto: 'Más.',
        pausaPrevia: Duration(milliseconds: 1000),
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'No le voy a contar a Isaura todavía.',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
      PlanoDialogo(voz: VozPersonaje.aitor, texto: 'Vale.'),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'No me va a regañar por no contarlo, ¿no?',
      ),
      PlanoDialogo(
        voz: VozPersonaje.aitor,
        texto: 'Isaura no regaña por silencios necesarios.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Maren asiente. La música sigue. Llegan a Iruña a las '
            'ocho. Aitor la deja en su portal.',
      ),
    ],
  );

  /// 3.2.7 — *Reconstrucción y Concilio* de la Estación 3.2. Una
  /// semana después. Salón del Concilio con Karim, Aitor, Joana y
  /// Maren. Maren presenta su reconstrucción de los Banu Qasi
  /// (~9 afirmaciones distribuidas: dinastía muladí Sólido,
  /// origen documentado en Casio Probable basado en Ibn Hayyán que
  /// cita fuentes anteriores perdidas, alianzas alternantes con
  /// Pamplona-vascones y Córdoba Sólido, rebelión del s. IX de Lubb
  /// ibn Muhammad y descendientes como proyecto de soberanía local
  /// fronteriza Probable, derrota tras 920 con reorganización
  /// administrativa Probable, identidad cultural plenamente
  /// musulmana en s. IX **Sólido como afirmación metodológica** —
  /// la dicotomía moderna *"musulmán vs hispano"* no aplica al
  /// periodo). Karim pregunta sobre conservación selectiva de
  /// fuentes. Concilio cierra. Sellada. Doc 09 §3.2.7.
  static const EscenaCinematica reconstruccionYConcilioBanuQasi =
      EscenaCinematica(
    id: '3.2.7',
    titulo: 'Reconstrucción y Concilio',
    flagDeSalida: 'escena_3_2_7_vista',
    flagsRequeridos: {'escena_3_2_6_vista'},
    ambiente: AmbienteArchivo.salonConcilio,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Una semana después. Salón del Concilio. Karim, Aitor y '
            'Joana a la mesa. Maren presenta su reconstrucción de '
            'los Banu Qasi. La presentación va bien — el material '
            'que ha trabajado es sólido.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 7),
        textoLectura:
            'Las afirmaciones más importantes:\n\n'
            '— Dinastía muladí que gobernó la Ribera del Ebro, '
            'especialmente Tudela, entre los s. VIII y X. Sólido.\n'
            '— Origen documentado en Casio, conde visigodo convertido '
            'al islam tras la invasión. Probable (Ibn Hayyán cita '
            'fuentes anteriores perdidas).',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 7),
        textoLectura:
            '— Alianzas alternantes con Pamplona-vascones y con '
            'Córdoba según conveniencia política. Sólido.\n'
            '— Rebelión contra Córdoba en el s. IX (Lubb ibn '
            'Muhammad y descendientes) como proyecto de soberanía '
            'local fronteriza, no movimiento religioso. Probable.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 7),
        textoLectura:
            '— Derrota tras 920 supuso reabsorción militar y '
            'reorganización administrativa que dejó a Tudela '
            'debilitada hasta la conquista cristiana de 1119. '
            'Probable.\n'
            '— Identidad cultural plenamente musulmana en el s. IX '
            'aunque su origen reciente fuera hispano-cristiano. La '
            'dicotomía moderna "musulmán vs hispano" no aplica al '
            'periodo. Sólido como afirmación metodológica.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Karim hace una pregunta sobre la conservación selectiva '
            'de fuentes — qué se conserva y qué se ha perdido, y por '
            'qué. Maren contesta con cuidado.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura: 'Concilio cierra. Sellada.',
      ),
    ],
  );

  /// 3.2.8 — *El silencio de Maren*. Esa noche. Habitación de
  /// Maren. **Maren no escribe en el cuaderno esta noche.** Lo
  /// abre. Mira la página en blanco. Lo cierra. Se acuesta. La
  /// cámara muestra la habitación oscura. El cuaderno cerrado en
  /// la mesa. Tres segundos. Negro. Doc 09 §3.2.8 — la única
  /// noche del MVP en que la voz del Cuaderno no aparece como
  /// reacción a una Estación cerrada. El silencio es el dato
  /// (eco metodológico de Karim en 2.4.5).
  static const EscenaCinematica elSilencioDeMaren = EscenaCinematica(
    id: '3.2.8',
    titulo: 'El silencio de Maren',
    flagDeSalida: 'escena_3_2_8_vista',
    flagsRequeridos: {'escena_3_2_7_vista'},
    ambiente: AmbienteArchivo.cuartoCasaMaren,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Maren no escribe en el cuaderno esta noche. Lo abre. '
            'Mira la página en blanco. Lo cierra. Se acuesta.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'La cámara muestra la habitación oscura. El cuaderno '
            'cerrado en la mesa. Tres segundos. Negro.',
      ),
    ],
  );

  /// 3.B.1 — *"¿Te trató bien?"*. Latente post-Estación 3.2. Dos
  /// días después. Despacho de Isaura. Maren entra con el pretexto
  /// de devolver un libro. Isaura la mira un segundo de más al
  /// entrar — Maren se da cuenta de que Isaura sabe (Aitor ya le ha
  /// dicho que comieron en la cafetería de Tudela, sin más
  /// detalles). Isaura no insiste; deja que Maren se siente sin
  /// invitarla. Maren confiesa el café con Tasio. La pregunta clave
  /// de Isaura — *"¿Te trató bien?"* — es la que Maren esperaba y
  /// no esperaba. Maren confirma con un Sí simple. Isaura no pide
  /// más. Antes de salir, Maren se gira en la puerta y le hace a
  /// Isaura una pregunta: *"¿Tú lo querías?"* — Isaura tarda mucho
  /// en contestar. *"Lo sigo queriendo."* La cámara se queda con
  /// Isaura mirando hacia la ventana norte. Doc 09 §3.B.1.
  static const EscenaCinematica teTratoBien = EscenaCinematica(
    id: '3.B.1',
    titulo: '¿Te trató bien?',
    flagDeSalida: 'escena_3_b_1_vista',
    flagsRequeridos: {'arco_3_estacion_2_cerrada'},
    ambiente: AmbienteArchivo.despachoIsaura,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Maren entra al despacho con el pretexto de devolver un '
            'libro. Isaura está en su silla, leyendo. Levanta la '
            'vista cuando Maren entra. La mira un segundo de más. '
            'Maren se da cuenta — Isaura sabe.',
      ),
      PlanoDialogo(voz: VozPersonaje.isaura, texto: 'Hola.'),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Tomo. Ya lo terminé.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto:
            'Aitor me dijo que estuvisteis comiendo en la cafetería '
            'de Tudela.',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Maren no contesta. Isaura no insiste. Se queda mirándola. '
            'Maren se sienta en la silla de enfrente sin que la '
            'inviten.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Tasio me invitó un café.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: 'Mm.',
        pausaPrevia: Duration(milliseconds: 1000),
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Hablamos veinte minutos.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: '¿Te trató bien?',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Maren tarda mucho en contestar. La pregunta es la que '
            'esperaba pero también la que no esperaba.',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Sí.'),
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura: 'Pausa muy larga.',
      ),
      PlanoDialogo(voz: VozPersonaje.isaura, texto: 'Bien.'),
      PlanoAmbiente(duracion: Duration(milliseconds: 1500)),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: '¿Quieres contarme algo?',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Todavía no.'),
      PlanoDialogo(voz: VozPersonaje.isaura, texto: 'Vale.'),
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura: 'Maren se levanta. En la puerta:',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Isaura.'),
      PlanoDialogo(voz: VozPersonaje.isaura, texto: '¿Sí?'),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: '¿Tú lo querías?',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura: 'Pausa larguísima. Cinco segundos. Diez.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: 'Lo sigo queriendo.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Maren asiente. Sale. La cámara se queda con Isaura. '
            'Coge el libro que Maren ha devuelto. No lo mira. Lo deja '
            'sobre la mesa con cuidado. Mira hacia la ventana norte.',
      ),
    ],
  );

  /// 3.3.1 — *Camino a Leyre*. Primeras semanas de abril. Esta vez
  /// Maren va con Marina en su Polo viejo: coche más pequeño,
  /// música pop española de fondo a volumen bajo. Marina conduce
  /// con una mano y come una galleta con la otra. Marina anticipa
  /// el monasterio (*"feo en plan que no tiene los lujos góticos.
  /// Pero por dentro la cripta es brutal"*) y le cuenta a Maren la
  /// leyenda del abad Virila — el abad que se preguntaba qué era
  /// la eternidad de Dios, salió a pasear por el bosque del
  /// monasterio, oyó cantar a un pájaro, se sentó a escucharlo y
  /// cuando volvió al monasterio habían pasado trescientos años.
  /// Maren responde *"Eso es bonito"* — Marina deja caer un
  /// *"Pero ya verás"* sin completar la frase. Doc 09 §3.3.1.
  static const EscenaCinematica caminoALeyre = EscenaCinematica(
    id: '3.3.1',
    titulo: 'Camino a Leyre',
    flagDeSalida: 'escena_3_3_1_vista',
    flagsRequeridos: {'escena_3_b_1_vista'},
    ambiente: AmbienteArchivo.cocheMarina,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Esta vez Maren va con Marina. Coche más pequeño, música '
            'pop española de fondo a volumen bajo. Marina conduce con '
            'una mano, comiendo una galleta con la otra.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.marina,
        texto: '¿Has estado en Leyre?',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'No.'),
      PlanoDialogo(
        voz: VozPersonaje.marina,
        texto:
            'Te va a gustar. Es feo en plan que no tiene los lujos '
            'góticos. Pero por dentro la cripta es brutal.',
      ),
      PlanoAmbiente(duracion: Duration(milliseconds: 1500)),
      PlanoDialogo(voz: VozPersonaje.marina, texto: '¿Sabes la leyenda?'),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Algo. El abad y un pájaro.',
      ),
      PlanoDialogo(voz: VozPersonaje.marina, texto: 'El abad Virila.'),
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura: 'Marina cuenta la leyenda mientras conduce.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.marina,
        texto:
            'El abad Virila se preguntaba qué era la eternidad de '
            'Dios. Salió un día a pasear por el bosque del '
            'monasterio. Oyó un pájaro cantar. Se sentó a escucharlo. '
            'Cuando volvió al monasterio, habían pasado trescientos '
            'años. Nadie lo conocía. Se murió poco después.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Eso es bonito.',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
      PlanoDialogo(voz: VozPersonaje.marina, texto: 'Es bonito.'),
      PlanoDialogo(voz: VozPersonaje.maren, texto: '¿Pero...?'),
      PlanoDialogo(voz: VozPersonaje.marina, texto: 'Pero ya verás.'),
    ],
  );

  /// 3.3.2 — *El monasterio*. Llegan a Leyre. El monasterio es
  /// modesto por fuera, sólido, encajado en el paisaje. Detrás la
  /// sierra; delante el embalse de Yesa. Entran. La cripta románica
  /// del s. XI es lo más antiguo conservado: capiteles tallados con
  /// escenas y figuras, columnas robustas. La iglesia superior es
  /// algo posterior. Marina le cuenta a Maren que aquí descansaron
  /// los reyes de Pamplona Sancho I, García Sánchez I, Sancho II y
  /// García Sánchez II — sus restos estuvieron aquí siglos. Maren
  /// mira la cripta dos minutos en silencio. Marina cierra: *"Tu
  /// Brecha es la leyenda. La oirás muchas veces si te quedas en el
  /// oficio. Cada vez con matices distintos."* Doc 09 §3.3.2.
  static const EscenaCinematica elMonasterio = EscenaCinematica(
    id: '3.3.2',
    titulo: 'El monasterio',
    flagDeSalida: 'escena_3_3_2_vista',
    flagsRequeridos: {'escena_3_3_1_vista'},
    ambiente: AmbienteArchivo.monasterioLeyre,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Llegan. El monasterio es modesto por fuera. Sólido. '
            'Encaja en el paisaje. Detrás, la sierra. Delante, el '
            'embalse de Yesa.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 6),
        textoLectura:
            'Entran. La cripta románica — del s. XI — es lo más '
            'antiguo conservado. Capiteles tallados con escenas y '
            'figuras, columnas robustas. La iglesia superior es algo '
            'posterior.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.marina,
        texto: 'Aquí descansaron los reyes de Pamplona.',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: '¿Cuáles?'),
      PlanoDialogo(
        voz: VozPersonaje.marina,
        texto:
            'Sancho I, García Sánchez I, Sancho II, García Sánchez '
            'II. Sus restos estuvieron aquí siglos.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura: 'Maren mira la cripta. Dos minutos en silencio.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.marina,
        texto:
            'Tu Brecha es la leyenda. La oirás muchas veces si te '
            'quedas en el oficio. Cada vez con matices distintos.',
      ),
    ],
  );

  /// 3.3.3 — *La leyenda de Virila*. Scriptorium reconstituido en
  /// una sala del monasterio (los códices originales están en
  /// archivos, pero hay reproducciones). Un monje mayor del
  /// monasterio actual les recibe y les enseña reproducciones de
  /// códices del s. XI-XIII. La revelación clave: la leyenda de
  /// Virila aparece por primera vez documentada en un códice del s.
  /// XIII — al menos cuatro siglos después del Virila histórico que
  /// aparece en listas de abades de Leyre del s. IX o principios
  /// del X. Hay menciones en documentación previa a 1200 de un
  /// abad llamado Virila, pero la leyenda tal como se conoce — los
  /// trescientos años, el pájaro, el regreso — es del XIII. El
  /// monje cierra con la pregunta: *"Entonces, ¿qué nos cuenta esta
  /// leyenda?" / "Esa es la pregunta para vosotras."* Doc 09 §3.3.3.
  static const EscenaCinematica laLeyendaDeVirila = EscenaCinematica(
    id: '3.3.3',
    titulo: 'La leyenda de Virila',
    flagDeSalida: 'escena_3_3_3_vista',
    flagsRequeridos: {'escena_3_3_2_vista'},
    ambiente: AmbienteArchivo.scriptoriumLeyre,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Un monje mayor las recibe. Les enseña reproducciones de '
            'códices del s. XI-XIII. La leyenda de Virila aparece por '
            'primera vez documentada en un códice del s. XIII.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.monjeLeyre,
        texto:
            'La leyenda dice que Virila fue abad aquí en el s. IX o '
            'principios del X. Los códices que la cuentan son del '
            'XIII y posteriores.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: '¿Cuatro siglos después?',
      ),
      PlanoDialogo(voz: VozPersonaje.monjeLeyre, texto: 'Al menos.'),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: '¿No hay menciones anteriores?',
        pausaPrevia: Duration(milliseconds: 1000),
      ),
      PlanoDialogo(
        voz: VozPersonaje.monjeLeyre,
        texto:
            'En documentación previa a 1200, no. Hay listas de abades '
            'de Leyre del s. IX y X, y aparece un Virila en una de '
            'ellas. Pero la leyenda tal como se conoce — los '
            'trescientos años, el pájaro, el regreso — es del XIII.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura: 'Maren mira la reproducción del códice.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Entonces, ¿qué nos cuenta esta leyenda?',
      ),
      PlanoDialogo(
        voz: VozPersonaje.monjeLeyre,
        texto: 'Esa es la pregunta para vosotras.',
      ),
    ],
  );

  /// 3.3.4 — *Cuándo se escribió*. Mesa de Trabajo en una sala del
  /// propio monasterio cedida. PH.10 (la leyenda como fuente
  /// histórica de su propia época, no de la que cuenta). Maren
  /// trabaja comparando versiones de la leyenda — la del s. XIII,
  /// una del s. XV, una del XVII — y estudiando el contexto
  /// monástico de cada momento de redacción. Voz del Cuaderno
  /// articulando la lección clave del PH.10: la leyenda no es
  /// sobre el s. IX, es sobre el s. XIII (Leyre en declive,
  /// reformas cluniacenses, memoria del esplendor pasado
  /// perdiéndose); los trescientos años no son los del milagro
  /// sino los que separan la fundación de Leyre del momento de
  /// redacción de la leyenda. La Cronista produce 6 afirmaciones
  /// (3 Sólido + 3 Probable). Doc 09 §3.3.4.
  static const EscenaCinematica cuandoSeEscribio = EscenaCinematica(
    id: '3.3.4',
    titulo: 'Cuándo se escribió',
    flagDeSalida: 'escena_3_3_4_vista',
    flagsRequeridos: {'escena_3_3_3_vista'},
    ambiente: AmbienteArchivo.monasterioLeyre,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Maren trabaja en una sala cedida del monasterio. Compara '
            'las distintas versiones de la leyenda — la del s. XIII, '
            'una del s. XV, una del XVII. Estudia el contexto '
            'monástico de cada momento de redacción.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto: 'La leyenda se escribe en el s. XIII. ¿Por qué entonces?',
        pausaPrevia: Duration(milliseconds: 1200),
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto:
            'Leyre en el s. XIII estaba en declive. Había perdido su '
            'importancia política. Los reyes ya no se enterraban aquí. '
            'La nueva orden cluniacense había reformado la liturgia. '
            'La memoria del esplendor pasado se estaba perdiendo.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto:
            'La leyenda, vista desde ahí, no es sobre el s. IX. Es '
            'sobre el s. XIII. Es un monasterio que mira hacia atrás '
            '300 años — los años desde su fundación — y cuenta una '
            'historia de un abad que se sentó a escuchar trescientos '
            'años de eternidad.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto:
            'Esos trescientos años no son los del milagro. Son los '
            'que separan la fundación de Leyre del momento de '
            'redacción de la leyenda.',
        pausaPrevia: Duration(milliseconds: 1000),
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto:
            'La leyenda de Virila no cuenta lo que pasó en el s. IX. '
            'Cuenta cómo Leyre del s. XIII se sentía mirando al s. '
            'IX.',
        pausaPrevia: Duration(milliseconds: 1200),
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 8),
        textoLectura:
            'La Cronista produce 6 afirmaciones:\n\n'
            '1. La leyenda aparece documentada por primera vez en '
            'códice del s. XIII de Leyre. Sólido.\n'
            '2. Un abad llamado Virila aparece en listas de abades '
            'del s. IX de Leyre. Sólido.\n'
            '3. La conexión entre el Virila histórico y el legendario '
            'no puede establecerse con certeza. Sólido (la '
            'incertidumbre).',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 8),
        textoLectura:
            '4. La leyenda en su forma plenamente desarrollada es '
            'producto del contexto monástico del s. XIII en un Leyre '
            'en declive relativo. Probable.\n'
            '5. La cifra "trescientos años" coincide aproximadamente '
            'con el tiempo entre la fundación de Leyre y la redacción '
            'de la leyenda — probablemente significativo, no casual. '
            'Probable.\n'
            '6. La leyenda nos informa más sobre la espiritualidad y '
            'la auto-percepción del s. XIII que sobre el s. IX. '
            'Probable.',
      ),
    ],
  );

  /// 3.3.5 — *Concilio* de la Estación 3.3. Una semana después,
  /// vuelta a Iruña. Salón del Concilio. Aitor (revisor) + Joana +
  /// Maren. Joana cuestiona la afirmación 5 (coincidencia de
  /// "trescientos años" entre el milagro y la fundación de Leyre)
  /// — *"es interpretativa"*. Maren la mantiene como Probable.
  /// Joana le pide que busque paralelos en otras leyendas
  /// monásticas con cifras simbólicas vinculadas a fundaciones —
  /// *"Para Aprendiz III, sí"*. Aitor sella pero apunta que Joana
  /// tiene razón: dejar la afirmación 5 abierta para revisión
  /// cuando los paralelos lleguen. Doc 09 §3.3.5.
  static const EscenaCinematica concilioLeyre = EscenaCinematica(
    id: '3.3.5',
    titulo: 'Concilio de Leyre',
    flagDeSalida: 'escena_3_3_5_vista',
    flagsRequeridos: {'escena_3_3_4_vista'},
    ambiente: AmbienteArchivo.salonConcilio,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Una semana después, vuelta a Iruña. Salón del Concilio. '
            'Aitor (revisor) y Joana a la mesa. Maren presenta su '
            'reconstrucción.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.joana,
        texto:
            'Tu afirmación 5 — la coincidencia de "trescientos años" '
            '— es interpretativa.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Sí. La declaro Probable.',
      ),
      PlanoDialogo(voz: VozPersonaje.joana, texto: '¿Qué te haría Sólida?'),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto:
            'Si encontrara explicitada la cifra en el códice como '
            'referencia a la fundación. O si otras leyendas paralelas '
            'usaran cifras simbólicas similares vinculadas a '
            'fundaciones.',
        pausaPrevia: Duration(milliseconds: 1000),
      ),
      PlanoDialogo(
        voz: VozPersonaje.joana,
        texto: '¿Has buscado paralelos?',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'No.'),
      PlanoDialogo(voz: VozPersonaje.joana, texto: 'Para Aprendiz III, sí.'),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Vale.',
        pausaPrevia: Duration(milliseconds: 800),
      ),
      PlanoDialogo(
        voz: VozPersonaje.aitor,
        texto:
            'Sellada. Pero Joana tiene razón — busca paralelos. '
            'Déjate la afirmación 5 abierta para revisión cuando los '
            'tengas.',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Vale.'),
    ],
  );

  /// 3.3.6 — *La leyenda no miente, desplaza*. Esa noche. Voz del
  /// Cuaderno breve cerrando la Estación con la lección PH.10:
  /// *"Las leyendas no mienten. Desplazan. Cuentan otra cosa de la
  /// que parece. Quien las escucha sin entender el desplazamiento
  /// las toma literales. Quien las entiende ve dos historias a la
  /// vez: la que dicen y la que ocultan. El abad Virila escuchó un
  /// pájaro. Pero quien lo cuenta lleva trescientos años escuchando
  /// el silencio de la grandeza pasada."* Doc 09 §3.3.6.
  static const EscenaCinematica laLeyendaNoMienteDesplaza = EscenaCinematica(
    id: '3.3.6',
    titulo: 'La leyenda no miente, desplaza',
    flagDeSalida: 'escena_3_3_6_vista',
    flagsRequeridos: {'escena_3_3_5_vista'},
    ambiente: AmbienteArchivo.cuartoCasaMaren,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura:
            'Es de noche. Maren en su mesa, cuaderno abierto.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto: 'Las leyendas no mienten. Desplazan.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto:
            'Cuentan otra cosa de la que parece. Quien las escucha '
            'sin entender el desplazamiento las toma literales. Quien '
            'las entiende ve dos historias a la vez: la que dicen y '
            'la que ocultan.',
        pausaPrevia: Duration(milliseconds: 800),
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto:
            'El abad Virila escuchó un pájaro. Pero quien lo cuenta '
            'lleva trescientos años escuchando el silencio de la '
            'grandeza pasada.',
        pausaPrevia: Duration(milliseconds: 1000),
      ),
    ],
  );

  /// 3.C.1 — *Naia pregunta otra vez*. Latente post-Estación 3.3.
  /// ~10 días después. Sábado tarde. Habitación de Maren. Naia (8
  /// años, hermana pequeña) entra sin llamar con un papel doblado
  /// — ha escrito una pregunta para Maren porque *"si la digo se
  /// me olvida hacerla bien"*. La pregunta, en letra grande de
  /// niña: *"Si las leyendas son sobre el momento en que se
  /// escriben, ¿qué pasa con las películas?"* Naia oyó por
  /// casualidad la conversación de Maren con Antonio sobre Leyre,
  /// contó lo del pájaro al cole, y cuando su profesora dijo *"qué
  /// historia más bonita"* Naia pensó en lo que había oído a su
  /// hermana. Maren confirma que sí — las películas también son
  /// sobre el momento en que se hacen, no sobre la época que
  /// cuentan, casi siempre. Naia agradece y sale. Maren guarda el
  /// papel dentro del cuaderno. Voz del Cuaderno cierra: *"Mi
  /// hermana de ocho años acaba de hacerme una pregunta de oficio.
  /// Voy a guardar el papel toda mi vida."* Doc 09 §3.C.1.
  static const EscenaCinematica naiaPreguntaOtraVez = EscenaCinematica(
    id: '3.C.1',
    titulo: 'Naia pregunta otra vez',
    flagDeSalida: 'escena_3_c_1_vista',
    flagsRequeridos: {'arco_3_estacion_3_cerrada'},
    ambiente: AmbienteArchivo.cuartoCasaMaren,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Sábado tarde. Maren está en su mesa estudiando para un '
            'examen del instituto. Naia entra sin llamar. Trae un '
            'papel doblado.',
      ),
      PlanoDialogo(voz: VozPersonaje.naia, texto: 'Hola.'),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Hola.'),
      PlanoDialogo(
        voz: VozPersonaje.naia,
        texto: 'Te he escrito una pregunta.',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: '¿Por qué escrita?'),
      PlanoDialogo(
        voz: VozPersonaje.naia,
        texto: 'Porque si la digo se me olvida hacerla bien.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Le pasa el papel. Maren lo abre. Letra grande de niña '
            'de 8 años. La pregunta dice:',
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto:
            'Si las leyendas son sobre el momento en que se escriben, '
            '¿qué pasa con las películas?',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura: 'Maren se queda quieta. Quince segundos.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Naia. ¿De qué te has enterado tú?',
      ),
      PlanoDialogo(
        voz: VozPersonaje.naia,
        texto:
            'Te oí ayer hablando con aita de Leyre. Conté lo del '
            'pájaro al cole. Mi profesora dijo "qué historia más '
            'bonita". Pero yo pensé en lo que te oí decir a ti.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: '¿Qué pensaste?',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
      PlanoDialogo(
        voz: VozPersonaje.naia,
        texto:
            'Que las películas también son sobre el momento en que '
            'se hacen, ¿no? No sobre la época que cuentan.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Sí.',
        pausaPrevia: Duration(milliseconds: 1800),
      ),
      PlanoDialogo(voz: VozPersonaje.naia, texto: '¿Y eso pasa siempre?'),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Casi siempre.',
        pausaPrevia: Duration(milliseconds: 1000),
      ),
      PlanoDialogo(
        voz: VozPersonaje.naia,
        texto: 'Vale. Gracias.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Naia sale. Maren se queda con el papel en la mano. Lo '
            'dobla con cuidado. Lo guarda dentro del cuaderno.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto:
            'Mi hermana de ocho años acaba de hacerme una pregunta '
            'de oficio.',
        pausaPrevia: Duration(milliseconds: 1200),
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto: 'Voy a guardar el papel toda mi vida.',
        pausaPrevia: Duration(milliseconds: 800),
      ),
    ],
  );

  /// 3.4.1 — *Camino a Roncesvalles*. Mediados de abril. Coche de
  /// Aitor subiendo al Pirineo entre bosques de hayas y niebla
  /// baja. Aitor le anticipa a Maren la doble lectura del 778: el
  /// relato de la *Chanson de Roland* (ejército de Carlomagno
  /// derrotado por sarracenos tras una traición) frente a la
  /// realidad documentada — *"la Chanson la escriben unos
  /// doscientos años después del hecho. Y los moros no aparecen
  /// en las fuentes del s. VIII que mencionan el suceso"*. Maren
  /// concluye preliminar: *"Entonces los moros son ficción"*.
  /// Aitor: *"Probablemente. Pero ya verás cómo y por qué"*. Doc
  /// 09 §3.4.1.
  static const EscenaCinematica caminoARoncesvalles = EscenaCinematica(
    id: '3.4.1',
    titulo: 'Camino a Roncesvalles',
    flagDeSalida: 'escena_3_4_1_vista',
    flagsRequeridos: {'escena_3_c_1_vista'},
    ambiente: AmbienteArchivo.cocheAitor,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Coche de Aitor. Sube hacia el Pirineo. Bosques de hayas. '
            'Niebla baja en algunos tramos.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.aitor,
        texto: '¿Sabes la Chanson de Roland?',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Algo. He leído resúmenes.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.aitor,
        texto:
            'El relato dice que un ejército de Carlomagno fue derrotado '
            'en Roncesvalles por sarracenos — moros — tras una '
            'traición de un noble cristiano.',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: '¿Y la realidad?'),
      PlanoDialogo(
        voz: VozPersonaje.aitor,
        texto: 'La realidad es lo que tienes que reconstruir tú.',
      ),
      PlanoAmbiente(duracion: Duration(milliseconds: 1500)),
      PlanoDialogo(
        voz: VozPersonaje.aitor,
        texto:
            'Pero te avanzo: la Chanson la escriben unos doscientos '
            'años después del hecho. Y los moros no aparecen en las '
            'fuentes del s. VIII que mencionan el suceso.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Entonces los moros son ficción.',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
      PlanoDialogo(
        voz: VozPersonaje.aitor,
        texto: 'Probablemente. Pero ya verás cómo y por qué.',
      ),
    ],
  );

  /// 3.4.2 — *El paso*. Llegan a Roncesvalles. Paso pirenaico,
  /// niebla, la colegiata real (hospital histórico de peregrinos),
  /// la carretera por la que se baja a Francia. Maren mira al
  /// norte (Francia) y al sur (Navarra) — el paso es pequeño en
  /// términos geográficos pero importantísimo históricamente.
  /// Aitor le sitúa el episodio del 778: los carolingios habían
  /// cruzado al sur como aliados de Sulayman al-Arabi de Zaragoza,
  /// fracasaron, volvían frustrados al norte y la retaguardia
  /// fue emboscada por vascones. La emboscada sucedió
  /// probablemente algo más al norte, en territorio que hoy es
  /// Francia. Doc 09 §3.4.2.
  static const EscenaCinematica elPaso = EscenaCinematica(
    id: '3.4.2',
    titulo: 'El paso',
    flagDeSalida: 'escena_3_4_2_vista',
    flagsRequeridos: {'escena_3_4_1_vista'},
    ambiente: AmbienteArchivo.pasoRoncesvalles,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 6),
        textoLectura:
            'Roncesvalles. Paso de montaña, niebla. La colegiata real, '
            'hospital de peregrinos histórico. La carretera por la que '
            'se baja a Francia.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Maren mira hacia el norte — Francia. Hacia el sur — '
            'Navarra. El paso es pequeño en términos geográficos pero '
            'importantísimo históricamente.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.aitor,
        texto:
            'Aquí pasaron carolingios en 778. Aquí pasaron peregrinos '
            'del Camino desde el s. XI. Aquí pasó casi todo lo que '
            'entró y salió de la península durante mil años.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: '¿Aquí mismo, este paso concreto?',
      ),
      PlanoDialogo(
        voz: VozPersonaje.aitor,
        texto:
            'Aquí o cerca. La emboscada del 778 sucedió probablemente '
            'algo más al norte, en territorio que hoy es Francia.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: '¿Y los carolingios qué hacían aquí?',
      ),
      PlanoDialogo(
        voz: VozPersonaje.aitor,
        texto:
            'Habían cruzado al sur como aliados de Sulayman al-Arabi '
            'de Zaragoza. Atacaron Zaragoza, fracasaron. Volvían '
            'frustrados al norte. La retaguardia atravesaba este paso '
            'cuando fue emboscada.',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: '¿Por quién?'),
      PlanoDialogo(
        voz: VozPersonaje.aitor,
        texto: 'Vascones.',
        pausaPrevia: Duration(milliseconds: 1000),
      ),
    ],
  );

  /// 3.4.3 — *Las dos versiones*. Sala de trabajo cedida en la
  /// colegiata. Aitor le presenta a Maren las dos lecturas en
  /// paralelo: la histórica documentada por las fuentes
  /// carolingias del s. VIII-IX (*Vita Karoli* de Eginardo,
  /// *Annales Regni Francorum*) — emboscada vascona a la
  /// retaguardia carolingia que volvía de Zaragoza, muerte de
  /// Rolando conde de la Marca de Bretaña — frente a la legendaria
  /// (*Chanson de Roland* h. 1100) — sarracenos en lugar de
  /// vascones, traición de Ganelón como motor narrativo,
  /// estructura de combate cristiano-musulmán. La voz del
  /// Cuaderno articula los tres cambios y apunta a las Cruzadas
  /// como contexto de redacción. Doc 09 §3.4.3.
  static const EscenaCinematica lasDosVersiones = EscenaCinematica(
    id: '3.4.3',
    titulo: 'Las dos versiones',
    flagDeSalida: 'escena_3_4_3_vista',
    flagsRequeridos: {'escena_3_4_2_vista'},
    ambiente: AmbienteArchivo.colegiataRoncesvalles,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Sala de trabajo cedida en la colegiata. Aitor pone sobre '
            'la mesa el material de las dos lecturas en paralelo.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 7),
        textoLectura:
            'Versión histórica (fuentes del s. VIII y IX):\n'
            '• Vita Karoli de Eginardo (s. IX, biografía de Carlomagno).\n'
            '• Annales Regni Francorum (anales del reino franco, s. IX).\n'
            '• Mención breve en otras fuentes carolingias del periodo.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 6),
        textoLectura:
            'Las fuentes contemporáneas dicen: una emboscada vascona '
            'a la retaguardia carolingia que volvía frustrada de '
            'Zaragoza. Murieron varios nobles, entre ellos un tal '
            'Rolando, conde de la Marca de Bretaña. Los vascones se '
            'retiraron sin posibilidad de represalia carolingia '
            'inmediata.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 7),
        textoLectura:
            'Versión legendaria (Chanson de Roland, h. 1100):\n'
            '• Texto épico francés de finales del s. XI / principios '
            'del XII.\n'
            '• Atribuye la emboscada a sarracenos en lugar de a '
            'vascones.\n'
            '• Convierte a Rolando en héroe central, con espada '
            'Durendal y olifante.\n'
            '• Añade traición del cristiano Ganelón como motor '
            'narrativo.\n'
            '• Estructura la batalla como combate religioso '
            'cristiano-musulmán.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto: 'La Chanson cambia tres cosas grandes:',
        pausaPrevia: Duration(milliseconds: 1200),
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto:
            '1. Vascones por moros.\n'
            '2. Emboscada por traición.\n'
            '3. Conflicto político por conflicto religioso.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto:
            'Los tres cambios apuntan en la misma dirección. La '
            'Chanson reescribe Roncesvalles para que encaje con las '
            'Cruzadas — que están empezando precisamente cuando se '
            'escribe.',
        pausaPrevia: Duration(milliseconds: 1000),
      ),
    ],
  );

  /// 3.4.4 — *La Chanson*. Mesa de Trabajo en la colegiata.
  /// PH.10 ampliado a su forma más completa: la leyenda no sólo
  /// desplaza temporalmente — como Virila en la 3.3 — sino que
  /// **reescribe identidades enteras** para servir a una agenda
  /// contemporánea de su redacción. Las primeras Cruzadas se
  /// predican en 1095 y la *Chanson* se escribe en torno a 1100.
  /// Convierte un episodio menor de hace 320 años en epopeya
  /// cristiano-musulmana — exactamente lo que Europa quería oír
  /// en el momento. Voz del Cuaderno articulando: propaganda
  /// cruzada no manipulada deliberadamente, sino respirada por
  /// los redactores en el aire de su tiempo. Doc 09 §3.4.4.
  static const EscenaCinematica laChanson = EscenaCinematica(
    id: '3.4.4',
    titulo: 'La Chanson',
    flagDeSalida: 'escena_3_4_4_vista',
    flagsRequeridos: {'escena_3_4_3_vista'},
    ambiente: AmbienteArchivo.colegiataRoncesvalles,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 6),
        textoLectura:
            'Maren analiza la Chanson en su contexto. Las primeras '
            'Cruzadas se predican en 1095. La Chanson se escribe en '
            'torno a 1100. Su versión de Roncesvalles convierte un '
            'episodio menor de hace 320 años en epopeya de cristianos '
            'contra musulmanes — exactamente lo que Europa quería '
            'oír en el momento.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto:
            'La Chanson es propaganda cruzada. No de manera '
            'consciente, no como manipulación deliberada. Pero el '
            'aire que respiraban los redactores estaba lleno de '
            'cruzadas, y el episodio del 778 lo reescribieron en '
            'ese aire.',
        pausaPrevia: Duration(milliseconds: 1200),
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto:
            'Los vascones no eran enemigo conveniente para los '
            'cruzados — eran cristianos. Los moros sí. Cambia el '
            'enemigo y el episodio sirve de arenga.',
        pausaPrevia: Duration(milliseconds: 1000),
      ),
    ],
  );

  /// 3.4.5 — *Reconstrucción*. Mesa de Trabajo. La Cronista
  /// produce 8 afirmaciones distinguiendo claramente entre los
  /// dos planos — el episodio del 778 documentado y la *Chanson*
  /// como obra literaria del s. XII. La afirmación 8 cierra con
  /// el matiz metodológico clave: *"Roncesvalles como evento es
  /// uno y la Chanson como obra literaria es otra: la honestidad
  /// histórica exige no confundirlos, aunque la cultura popular
  /// los haya fundido"* — Sólido como afirmación metodológica.
  /// Doc 09 §3.4.5.
  static const EscenaCinematica reconstruccionRoncesvalles = EscenaCinematica(
    id: '3.4.5',
    titulo: 'Reconstrucción',
    flagDeSalida: 'escena_3_4_5_vista',
    flagsRequeridos: {'escena_3_4_4_vista'},
    ambiente: AmbienteArchivo.colegiataRoncesvalles,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Mesa de Trabajo. La Cronista produce 8 afirmaciones '
            'distinguiendo claramente entre los dos planos.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 9),
        textoLectura:
            '1. En 778, una emboscada vascona destruyó la retaguardia '
            'del ejército de Carlomagno en el Pirineo. Sólido.\n'
            '2. Las fuentes carolingias contemporáneas identifican a '
            'los atacantes como vascones. Sólido.\n'
            '3. La emboscada respondía probablemente a represalias '
            'por daños del ejército carolingio en su paso por '
            'territorio vascón. Probable.\n'
            '4. La Chanson de Roland (~1100) reescribe el episodio '
            'sustituyendo a los vascones por musulmanes. Sólido.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 9),
        textoLectura:
            '5. Esta sustitución refleja el contexto de las Cruzadas, '
            'no la realidad del 778. Probable.\n'
            '6. La Chanson añade el motor narrativo de la traición '
            'de Ganelón, ausente de las fuentes contemporáneas. '
            'Sólido.\n'
            '7. La popularidad de la Chanson medieval fijó la versión '
            'legendaria como "memoria popular" del episodio durante '
            'siglos. Probable.\n'
            '8. Roncesvalles como evento es uno y la Chanson como '
            'obra literaria es otra: la honestidad histórica exige '
            'no confundirlos, aunque la cultura popular los haya '
            'fundido. Sólido como afirmación metodológica.',
      ),
    ],
  );

  /// 3.4.6 — *Concilio*. Días después en Iruña, salón del
  /// Concilio. Aitor (acompañante), Karim, Joana revisores.
  /// Karim aprueba la afirmación 5 con énfasis — el reconocimiento
  /// explícito del contexto cruzado. Aitor le pregunta sobre la
  /// afirmación 7, si la "memoria popular" tiene también su
  /// propia historia que merece estudio; Maren admite que sí pero
  /// queda fuera de esta Brecha. Joana asiente sin comentar y
  /// cierra: *"Sellada"*. Doc 09 §3.4.6.
  static const EscenaCinematica concilioRoncesvalles = EscenaCinematica(
    id: '3.4.6',
    titulo: 'Concilio de Roncesvalles',
    flagDeSalida: 'escena_3_4_6_vista',
    flagsRequeridos: {'escena_3_4_5_vista'},
    ambiente: AmbienteArchivo.salonConcilio,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Días después en Iruña. Salón del Concilio. Aitor '
            'acompañante; Karim y Joana revisores. Maren presenta su '
            'reconstrucción.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.karim,
        texto:
            'Tu afirmación 5 — el reconocimiento explícito del '
            'contexto cruzado — la apruebo con énfasis. Es el corazón '
            'de la Brecha.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.aitor,
        texto:
            'Tu afirmación 7 dice que la "memoria popular" fijó la '
            'versión legendaria durante siglos. ¿Esa memoria popular '
            'tiene también su propia historia que merece estudio?',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Sí. Pero queda fuera de esta Brecha.',
        pausaPrevia: Duration(milliseconds: 1000),
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 2),
        textoLectura: 'Joana asiente sin comentar.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.joana,
        texto: 'Sellada.',
        pausaPrevia: Duration(milliseconds: 800),
      ),
    ],
  );

  /// 3.4.7 — *Lo bonito miente*. Esa noche, habitación de Maren.
  /// Voz del Cuaderno cierra la Estación 3.4 con la lección
  /// integradora del oficio frente a la épica: *"Lo bonito miente
  /// más que lo aburrido"*. La *Chanson* es bonita — tiene épica,
  /// traición, espadas, olifantes. La realidad es aburrida —
  /// una emboscada en un paso de montaña a un ejército que
  /// volvía frustrado. *"El oficio sirve para defender lo aburrido
  /// cuando es verdad. Eso me cuesta. Lo aburrido no se defiende
  /// solo. Pero si no lo defendemos nosotras, nadie lo va a
  /// defender"*. Doc 09 §3.4.7.
  static const EscenaCinematica loBonitoMiente = EscenaCinematica(
    id: '3.4.7',
    titulo: 'Lo bonito miente',
    flagDeSalida: 'escena_3_4_7_vista',
    flagsRequeridos: {'escena_3_4_6_vista'},
    ambiente: AmbienteArchivo.cuartoCasaMaren,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura:
            'Es de noche. Maren en su mesa, cuaderno abierto.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto: 'Lo bonito miente más que lo aburrido.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto:
            'La Chanson es bonita. Tiene épica, traición, espadas, '
            'olifantes. La realidad — una emboscada en un paso de '
            'montaña a un ejército que volvía frustrado — es '
            'aburrida.',
        pausaPrevia: Duration(milliseconds: 800),
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto:
            'El oficio sirve para defender lo aburrido cuando es '
            'verdad. Eso me cuesta. Lo aburrido no se defiende solo.',
        pausaPrevia: Duration(milliseconds: 1000),
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto:
            'Pero si no lo defendemos nosotras, nadie lo va a '
            'defender.',
        pausaPrevia: Duration(milliseconds: 1200),
      ),
    ],
  );

  /// 3.D.1 — *Eider se va*. Latente, ~5 días después de la
  /// Estación 3.4. Portal del bloque de Eider. Maren ha pasado
  /// sin avisar; Eider baja en chándal, saliendo a entrenar al
  /// baloncesto. Maren pide perdón por no haber ido al partido
  /// importante. Eider responde con la frase clave: *"No estoy
  /// enfadada. Estoy cansada. Estoy cansada de tener una mejor
  /// amiga que tiene una vida que yo no entiendo"*. Maren: *"No
  /// es lo mismo que perderte"*. Eider: *"No"*. Eider se va a
  /// baloncesto sin cerrar nada. Maren camina a casa sin mirar
  /// el móvil, sin llorar — sólo camina. Voz del Cuaderno esa
  /// noche: *"Eider tiene razón. Yo no le he explicado nunca lo
  /// que hago. Y aunque se lo explicara, no es algo que se pueda
  /// explicar en cinco minutos. Hace falta haberlo vivido. No sé
  /// qué hacer"*. Doc 09 §3.D.1. Esta es la cinemática más
  /// emocionalmente cruda del Arco 3 hasta ahora — el coste
  /// personal del oficio articulado por una amiga adolescente
  /// que no entra en el oficio.
  static const EscenaCinematica eiderSeVa = EscenaCinematica(
    id: '3.D.1',
    titulo: 'Eider se va',
    flagDeSalida: 'escena_3_d_1_vista',
    flagsRequeridos: {'arco_3_estacion_4_cerrada'},
    ambiente: AmbienteArchivo.portalCasaEider,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Maren ha pasado por casa de Eider sin avisar. Eider '
            'baja al portal en chándal, saliendo a entrenar.',
      ),
      PlanoDialogo(voz: VozPersonaje.eider, texto: 'Hola.'),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Hola.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'No vine al partido. Ya lo sabes.',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
      PlanoDialogo(voz: VozPersonaje.eider, texto: 'Lo sé.'),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Quería pedir perdón.'),
      PlanoDialogo(
        voz: VozPersonaje.eider,
        texto: 'Vale.',
        pausaPrevia: Duration(milliseconds: 1800),
      ),
      PlanoAmbiente(duracion: Duration(milliseconds: 1500)),
      PlanoDialogo(
        voz: VozPersonaje.eider,
        texto: 'Maren. No estoy enfadada. Estoy cansada.',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: '¿De mí?'),
      PlanoDialogo(
        voz: VozPersonaje.eider,
        texto:
            'No exactamente. Estoy cansada de tener una mejor amiga '
            'que tiene una vida que yo no entiendo.',
        pausaPrevia: Duration(milliseconds: 1200),
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'No es lo mismo que perderte.',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
      PlanoDialogo(voz: VozPersonaje.eider, texto: 'No.'),
      PlanoAmbiente(duracion: Duration(milliseconds: 1500)),
      PlanoDialogo(
        voz: VozPersonaje.eider,
        texto: 'Voy al baloncesto. ¿Hablamos otro día?',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Vale.'),
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Eider se va. Maren se queda en el portal. Camina a casa. '
            'No mira el móvil. No llora. Camina.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto: 'Eider tiene razón.',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto:
            'Yo no le he explicado nunca lo que hago. Y aunque se lo '
            'explicara, no es algo que se pueda explicar en cinco '
            'minutos. Hace falta haberlo vivido.',
        pausaPrevia: Duration(milliseconds: 1000),
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto: 'No sé qué hacer.',
        pausaPrevia: Duration(milliseconds: 1200),
      ),
    ],
  );
}
