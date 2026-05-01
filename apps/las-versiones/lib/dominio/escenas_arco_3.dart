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
  /// `arco_3_estacion_1_cerrada` (que la 3.1.5 activa).
  static const List<EscenaCinematica> todas = [
    aperturaDelArco,
    eiderYLaDistancia,
    sanCernin,
    tresLenguas,
    elBarrioOccitano,
    concilioSanCernin,
    irunaCosmopolita,
    marinaYLosPuentes,
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
}
