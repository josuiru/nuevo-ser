import 'package:nuevo_ser_core/nuevo_ser_core.dart';

import 'ambiente_archivo.dart';
import 'voz_personaje.dart';

/// Catálogo de escenas cinemáticas del Arco 2 — *La llegada de las
/// palabras* (doc 08). Estado: esqueleto. Sólo la cinemática de
/// apertura 2.0.1 está implementada para validar que el orquestador
/// puede encadenar el Arco 1 con el Arco 2 cruzando el flag de
/// cierre `arco_1_cerrado_por_la_cronista`. Las restantes 33 escenas
/// del doc 08 se irán añadiendo arco a arco siguiendo el mismo
/// patrón que el Arco 1 (cinemáticas + Brechas + Mosaico de cierre).
///
/// El Arco 2 introduce el manejo de fuentes textuales — Maren ha
/// trabajado el Arco 1 sin texto (sólo objetos, paisaje, restos).
/// Aquí entra la inscripción romana, la crónica visigoda, el dato
/// epigráfico, y con ellos los sesgos del autor que sí firma.
class EscenasArco2 {
  EscenasArco2._();

  /// Lista ordenada de escenas del Arco 2 disponibles para el
  /// orquestador. Cubre 2.0.1 (apertura), la Estación 2.1 completa
  /// (Pompaelo bajo Iruña, doc 08 §2.1.1–2.1.6), las dos cinemáticas
  /// latentes post-Estación 2.1 (2.A.1 *El libro de Quintiliano* y
  /// 2.A.2 *Marina y los descansos*) y la Estación 2.2 completa
  /// (Quintiliano de Calagurris, doc 08 §2.2.1–2.2.6); las
  /// estaciones 2.3–2.4 + cinemáticas latentes 2.B/2.C + Mosaico
  /// M2 + cierre 2.Z se añadirán en commits posteriores.
  ///
  /// Las latentes 2.A.x se ordenan **detrás** de 2.1.6 porque ambas
  /// requieren `arco_2_estacion_1_cerrada` (que la 2.1.6 activa),
  /// pero el orquestador las despachará en cuanto sea su turno —
  /// dependiendo de qué cinemática haya cerrado antes, podrían
  /// dispararse antes de que la Estación 2.2 esté implementada y
  /// disponible.
  static const List<EscenaCinematica> todas = [
    primerDiaDelArco,
    bajarAlSotano,
    laInscripcion,
    karimEnsenaEpigrafia,
    quienPagoEsto,
    reconstruccionYConcilio,
    primerApunteDePompaelo,
    elLibroDeQuintiliano,
    marinaYLosDescansos,
    caminoACalahorra,
    calagurrisBajoCalahorra,
    quintilianoSobreSiMismo,
    loQueOmite,
    elConcilioEnCalahorra,
    loQueFueYDejoDeSer,
  ];

  /// Flags institucionales adicionales que el orquestador activa al
  /// cerrar una escena del Arco 2. Mismo patrón que en Arco 1 — los
  /// flags hito ("arco_2_iniciado") viajan aquí en lugar de inflar
  /// el contrato `EscenaCinematica` de la plataforma.
  static const Map<String, Set<String>> flagsDeCierrePorEscena = {
    'escena_2_0_1_vista': {
      'arco_2_iniciado',
    },
    'escena_2_1_1_vista': {
      'pompaelo_subterranea_alcanzada',
      'met_pompaelo',
    },
    'escena_2_1_2_vista': {
      'inscripcion_romana_vista',
      'met_karim_epigrafista',
    },
    'escena_2_1_3_vista': {
      'epigrafia_basica_aprendida',
    },
    'escena_2_1_4_vista': {
      'inscripcion_romana_estudiada',
    },
    'escena_2_1_5_vista': {
      'concilio_2_1_cerrado',
      'brecha_2_1_completada',
    },
    'escena_2_1_6_vista': {
      'arco_2_estacion_1_cerrada',
    },
    'escena_2_a_1_vista': {
      'libro_quintiliano_recibido',
    },
    'escena_2_a_2_vista': {
      'aviso_marina_calahorra_recibido',
    },
    'escena_2_2_1_vista': {
      'viaje_a_calahorra_iniciado',
    },
    'escena_2_2_2_vista': {
      'calagurris_visitada',
      'met_arqueologa_calahorra',
    },
    'escena_2_2_3_vista': {
      'quintiliano_lectura_critica_hecha',
    },
    'escena_2_2_4_vista': {
      'omisiones_quintiliano_estudiadas',
    },
    'escena_2_2_5_vista': {
      'concilio_2_2_cerrado',
      'brecha_2_2_completada',
    },
    'escena_2_2_6_vista': {
      'arco_2_estacion_2_cerrada',
    },
  };

  /// 2.0.1 — *El primer día del arco*. Activa: tras el cierre del
  /// Arco 1 (flag `arco_1_cerrado_por_la_cronista` que la 1.Z
  /// activó al final). Lugar: patio del Archivo. Personajes: Isaura,
  /// Maren. La escena establece la nueva regla del oficio: a partir
  /// de aquí Maren tiene texto. Isaura le advierte que tener texto
  /// no hace el oficio más fácil — anticipo del Arco 2 entero, donde
  /// la pedagogía es aprender a leer fuentes textuales con la misma
  /// honestidad con la que leyó objetos en el Arco 1.
  ///
  /// Tono: corto, deliberadamente parco. El doc 08 §2.0.1 lo escribe
  /// con líneas mínimas (tres-cuatro palabras por turno) para marcar
  /// el inicio del trimestre — el peso narrativo viene en 2.1.1
  /// cuando bajan al sótano.
  static const EscenaCinematica primerDiaDelArco = EscenaCinematica(
    id: '2.0.1',
    titulo: 'El primer día del arco',
    flagDeSalida: 'escena_2_0_1_vista',
    flagsRequeridos: {'arco_1_cerrado_por_la_cronista'},
    ambiente: AmbienteArchivo.patioArchivo,
    planos: [
      // Encuadre temporal — primer lunes del trimestre nuevo.
      // Diciembre, semanas después del cierre del Arco 1.
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Iruña. Lunes de diciembre, nueve de la mañana. Patio del '
            'Archivo. Isaura espera con el bastón apoyado, mirando al '
            'capitel del claustro. Maren entra con un cuaderno nuevo '
            'en la mochila — el blanco de Aprendiz I.',
      ),

      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: 'Bienvenida.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Hola.',
      ),

      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: '¿Has descansado?',
        pausaPrevia: Duration(milliseconds: 600),
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Sí.',
      ),

      PlanoAmbiente(
        duracion: Duration(seconds: 2),
        textoLectura: 'Isaura asiente.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: 'Hoy bajamos.',
      ),

      // Maren mira hacia la escalera del sótano — primer indicio del
      // espacio nuevo del arco. Pompaelo está literalmente debajo de
      // la calle Curia: el Archivo lo conecta por una galería técnica.
      PlanoAmbiente(
        duracion: Duration(seconds: 2),
        textoLectura: 'Maren mira hacia la escalera del sótano.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: '¿A Pompaelo?',
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: 'A Pompaelo.',
      ),

      PlanoAmbiente(
        duracion: Duration(seconds: 2),
      ),

      // Línea pedagógica clave — encuadra todo el arco. El Arco 1 fue
      // sin texto (objetos, paisaje, huesos). Ahora entra la palabra
      // escrita y con ella autorías, fechas, sesgos, omisiones.
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto:
            'Hasta ahora has trabajado sin texto. A partir de hoy, '
            'tienes texto. No te creas que eso lo hace más fácil.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Ya me lo imagino.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: 'No te lo imaginas.',
        pausaPrevia: Duration(milliseconds: 800),
      ),

      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura:
            'Isaura empieza a caminar hacia las escaleras. Maren la '
            'sigue.',
      ),
    ],
  );

  /// 2.1.1 — *Bajar al sótano*. Continúa de 2.0.1. Galería técnica
  /// bajo la calle Curia, plataforma con luces dirigidas, restos de
  /// pavimento romano. Maren entra por primera vez en la Pompaelo
  /// subterránea. Doc 08 §2.1.1.
  static const EscenaCinematica bajarAlSotano = EscenaCinematica(
    id: '2.1.1',
    titulo: 'Bajar al sótano',
    flagDeSalida: 'escena_2_1_1_vista',
    flagsRequeridos: {'escena_2_0_1_vista'},
    ambiente: AmbienteArchivo.pompaeloSubterranea,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Bajan al sótano romano del Archivo. Isaura abre una '
            'puerta lateral pequeña que Maren no había notado.',
      ),
      PlanoDialogo(voz: VozPersonaje.isaura, texto: 'Por aquí.'),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Una galería estrecha, baja, con un techo de bóveda romana '
            'en parte. Bombillas tenues. Olor a piedra húmeda. Bajan '
            'cuarenta metros.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: 'Estamos por debajo de la calle Curia.',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: '¿Esto comunica con qué?'),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: 'Con el foro municipal. Lo que queda.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'La galería se abre a un espacio más amplio. Plataforma '
            'técnica con luces dirigidas. Restos de pavimento, basa de '
            'columna, fragmentos de muro. Una zona acotada con cinta '
            'amarilla.',
      ),
      PlanoDialogo(voz: VozPersonaje.isaura, texto: 'Bienvenida a Pompaelo.'),
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura: 'Maren se queda quieta. Mira. Tres segundos.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: '¿Esto está debajo de la calle?',
        pausaPrevia: Duration(milliseconds: 600),
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto:
            'Esto es la calle. Lo que tú caminas arriba está sobre lo '
            'que ves aquí.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 2),
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto:
            'El Archivo tiene acceso técnico desde hace dos siglos. La '
            'gente que vive arriba la mayoría no sabe que existe.',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: '¿Por qué no es museo?'),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: 'Pregunta administrativa. No la respondo.',
        pausaPrevia: Duration(milliseconds: 800),
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 2),
        textoLectura: 'Maren sonríe pequeñísimo.',
      ),
      PlanoDialogo(voz: VozPersonaje.isaura, texto: 'Mira esto.'),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Le señala un fragmento de mármol contra la pared. Una '
            'inscripción. Letras grabadas, fragmento de unos cuarenta '
            'centímetros, líneas incompletas.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: 'Esa es tu Brecha de hoy.',
      ),
    ],
  );

  /// 2.1.2 — *La inscripción*. Maren se acerca al fragmento. Karim
  /// (epigrafista del Archivo, 47 años) se presenta como mentor de la
  /// estación. Doc 08 §2.1.2.
  ///
  /// La inscripción literal es **ficticia y diegética** — el doc 08
  /// inventa el fragmento como pieza didáctica del juego, no es
  /// epígrafe arqueológico real. El texto preserva la estructura
  /// canónica de las honoríficas romanas (HF.07 enseña por
  /// reconocimiento de patrón) sin afirmar nada concreto.
  static const EscenaCinematica laInscripcion = EscenaCinematica(
    id: '2.1.2',
    titulo: 'La inscripción',
    flagDeSalida: 'escena_2_1_2_vista',
    flagsRequeridos: {'escena_2_1_1_vista'},
    ambiente: AmbienteArchivo.pompaeloSubterranea,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Maren se acerca. La inscripción se ve ahora con detalle. '
            'Letras capitales romanas. Tres líneas conservadas, parte '
            'de una cuarta.',
      ),
      // El texto literal de la inscripción se muestra como bloque
      // de lectura — sin atribución. Aprende a leer "lo que está y
      // lo que no" (HF.07 + capítulo de Karim en 2.1.3).
      PlanoAmbiente(
        duracion: Duration(seconds: 6),
        textoLectura:
            '...VS · LICINIO · CO[ ]\n'
            'PRINCIPI · OPTIMO · DE[ ]\n'
            '...VR · DEDICAVIT · EX · V[ ]\n'
            '[ ] · BENE · MERENT[ ]',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 2),
        textoLectura: 'Maren la mira en silencio.',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'No la entiendo.'),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: 'No tienes que entenderla todavía.',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: '¿Qué tengo que hacer?'),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto:
            'Lo mismo que en Aralar. Formula tus preguntas. Pero esta '
            'vez tienes texto. Eso te da más herramientas y más trampas.',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: '¿Estás conmigo?'),
      PlanoDialogo(voz: VozPersonaje.isaura, texto: 'No. Karim.'),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Detrás de ellas se oye un paso. Karim aparece en la '
            'galería. Chaqueta gris, libreta en una mano, una linterna '
            'en la otra.',
      ),
      PlanoDialogo(voz: VozPersonaje.karim, texto: 'Buenos días.'),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Hola.'),
      PlanoDialogo(
        voz: VozPersonaje.karim,
        texto:
            'Isaura me dijo que tu primera Brecha romana iba a ser una '
            'inscripción. Yo soy lo más cercano a un epigrafista que '
            'tenemos. Voy a estar contigo hoy.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: 'Si hace falta.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.karim,
        texto: 'Si hace falta. Si no, miro.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura:
            'Isaura asiente y se va. Maren y Karim se quedan solos '
            'delante de la inscripción.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.karim,
        texto: '¿Sabes algo de epigrafía romana?',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Casi nada.'),
      PlanoDialogo(
        voz: VozPersonaje.karim,
        texto: 'Vale. Empezamos por el principio.',
      ),
    ],
  );

  /// 2.1.3 — *Karim enseña epigrafía*. Convenciones epigráficas
  /// como subhabilidad de HF.07. Karim explica que el texto está
  /// abreviado, codificado y roto, y que las inscripciones
  /// honoríficas tienen estructura previsible. Doc 08 §2.1.3.
  ///
  /// Las afirmaciones histórico-epigráficas concretas (princeps
  /// optimus → asociado a Trajano → s. II) se conservan tal como
  /// las plantea el doc — el propio texto incluye que **Probable,
  /// no Sólido**, lo cual encarna la pedagogía del juego. Anotado
  /// en `BLOQUEOS-PENDIENTES.md` para validación del comité.
  static const EscenaCinematica karimEnsenaEpigrafia = EscenaCinematica(
    id: '2.1.3',
    titulo: 'Karim enseña epigrafía',
    flagDeSalida: 'escena_2_1_3_vista',
    flagsRequeridos: {'escena_2_1_2_vista'},
    ambiente: AmbienteArchivo.mesaTrabajoArchivo,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Karim despliega su libreta. Saca un esquema impreso con '
            'las convenciones epigráficas básicas.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.karim,
        texto:
            'Esto que ves no es texto. Es texto abreviado, codificado, '
            'y roto. Cada una de esas tres cosas te complica la vida y '
            'te ayuda.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: '¿Cómo me ayuda que esté roto?',
      ),
      PlanoDialogo(
        voz: VozPersonaje.karim,
        texto:
            'Buena pregunta. Te ayuda porque lo que falta te dice qué '
            'tipo de inscripción es. Las inscripciones de un cierto '
            'tipo tienen estructura previsible. Si conoces la '
            'estructura, puedes inferir qué falta.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 2),
        textoLectura: 'Karim le señala las líneas.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.karim,
        texto:
            'Ésta es una inscripción honorífica. Lo sé porque tiene '
            'estructura de honorífica: nombre del honrado, su cargo y '
            'rango, identidad del dedicante, motivo de la dedicación.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.karim,
        texto:
            'VS LICINIO. Algo Licinio. Un romano de la familia de los '
            'Licinios. CO[...]. Probablemente consul — cónsul.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.karim,
        texto:
            'PRINCIPI OPTIMO — al óptimo príncipe. DE[...] — algo más '
            'que falta. DEDICAVIT EX V[...] — dedicó ex... '
            'probablemente ex voto. BENE MERENT[...] — al que bien lo '
            'merece, frase de fin.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: '¿Princeps optimus es un emperador?',
      ),
      PlanoDialogo(
        voz: VozPersonaje.karim,
        texto:
            'Lo es. Es un epíteto que empezó a usarse para Trajano. Si '
            'el "princeps optimus" es Trajano, esto es del s. II.',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: '¿Lo sabemos seguro?'),
      PlanoDialogo(
        voz: VozPersonaje.karim,
        texto:
            'No. Sabemos que el epíteto se usó después también. Pero '
            '"princeps optimus" sin más adornos en una honorífica es '
            'altamente compatible con época trajanea.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'O sea Probable, no Sólido.',
        pausaPrevia: Duration(milliseconds: 700),
      ),
      PlanoDialogo(
        voz: VozPersonaje.karim,
        texto: 'Bien.',
      ),
      // Voz del Cuaderno durante el trabajo. Sin atribución de
      // personaje — viene de la propia Cronista.
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto:
            'Las inscripciones tienen plantilla. Como un certificado '
            'moderno. Si conoces la plantilla, lees lo que no está '
            'escrito.',
        pausaPrevia: Duration(milliseconds: 1200),
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto:
            'Eso me parece extraño. Estoy leyendo lo que no está. '
            '¿Cómo distingo lo que falta de lo que invento?',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 2),
        textoLectura: 'Karim cambia de tono.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.karim,
        texto:
            'Vale. Ya sabes lo que dice. Ahora la pregunta más '
            'importante.',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: '¿Cuál?'),
      PlanoDialogo(voz: VozPersonaje.karim, texto: 'Quién pagó esto.'),
    ],
  );

  /// 2.1.4 — *Quién pagó esto*. HF.07 + HF.09 (detección de sesgo
  /// del productor) + PR.02 (formulación de preguntas de profundidad).
  /// Karim guía a Maren a la pregunta clave de la fuente romana:
  /// no qué dice, sino quién pagó por que se diga. Doc 08 §2.1.4.
  static const EscenaCinematica quienPagoEsto = EscenaCinematica(
    id: '2.1.4',
    titulo: 'Quién pagó esto',
    flagDeSalida: 'escena_2_1_4_vista',
    flagsRequeridos: {'escena_2_1_3_vista'},
    ambiente: AmbienteArchivo.mesaTrabajoArchivo,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura:
            'Karim se sienta en una caja vieja de fragmentos. Maren se '
            'sienta enfrente.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.karim,
        texto:
            'Las inscripciones honoríficas no se pagaban solas. Alguien '
            'las encargaba. Alguien quería que esto estuviera escrito '
            'en piedra. Y alguien — quizá el mismo, quizá otro — pagaba '
            'el coste material.',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: '¿Cómo lo sé?'),
      PlanoDialogo(
        voz: VozPersonaje.karim,
        texto:
            'Por la línea perdida. DEDICAVIT EX V[...]. Dedicó por... '
            'es la fórmula. Lo que falta es el nombre del dedicante. '
            'Sin el nombre del dedicante, no sabes quién pagó.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: '¿Y sabemos algo del dedicante por otra vía?',
        pausaPrevia: Duration(milliseconds: 700),
      ),
      PlanoDialogo(
        voz: VozPersonaje.karim,
        texto:
            'Sólo que respetaba mucho a Licinio el cónsul para hacerle '
            'una honorífica en piedra. Pudo ser un cliente, un liberto, '
            'un colega, un familiar. Pudo ser la propia ciudad de '
            'Pompaelo a través de su senado local. Cada hipótesis '
            'cambia lo que la inscripción significa.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Si la pagó la ciudad, es propaganda institucional.',
      ),
      PlanoDialogo(voz: VozPersonaje.karim, texto: 'Sí.'),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Si la pagó un cliente o un liberto, es propaganda personal.',
      ),
      PlanoDialogo(voz: VozPersonaje.karim, texto: 'Sí.'),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: '¿Y cómo se distingue?',
        pausaPrevia: Duration(milliseconds: 600),
      ),
      PlanoDialogo(
        voz: VozPersonaje.karim,
        texto:
            'A veces no se puede. Te quedas con varias hipótesis y '
            'declaras tu nivel de confianza con honestidad.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 2),
        textoLectura: 'Maren coge la libreta. Empieza a tomar notas.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.karim,
        texto: 'Una cosa más. Y es importante.',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Sí.'),
      // Línea pedagógica nuclear de la Estación 2.1.
      PlanoDialogo(
        voz: VozPersonaje.karim,
        texto:
            'Una inscripción no es un documento neutral. Es propaganda. '
            'Lo que está escrito en piedra está escrito porque alguien '
            'quería que durara y que la gente lo viera. Eso no significa '
            'que mienta — pero significa que selecciona. Lo que no le '
            'interesaba al dedicante no aparece. Lo que sí le interesaba '
            'aparece exagerado.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Como una valla publicitaria moderna.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.karim,
        texto: 'Más caro y más duradero. Pero sí.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura:
            'Karim se levanta. "Te dejo trabajar. Vuelvo en una hora a '
            'ver tu reconstrucción. Si te atascas, sube y me preguntas."',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Vale.'),
      // La fase jugable de Reconstrucción de la Estación 2.1
      // (declarar 6 afirmaciones con niveles de confianza sobre la
      // inscripción) está pendiente — requiere refactor del modelo
      // FaseBrecha o pantalla específica nueva. Anotado en
      // BLOQUEOS-PENDIENTES.md.
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Maren se queda con la inscripción y la Mesa de Trabajo. '
            'Trabaja una hora. Su reconstrucción produce 6 afirmaciones: '
            '1 Sólida, 3 Probables, 2 Disputadas. Karim vuelve.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.karim,
        texto: 'A ver.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura:
            'Maren le pasa la reconstrucción. Karim la lee. Asiente '
            'despacio.',
      ),
      PlanoDialogo(voz: VozPersonaje.karim, texto: 'Una pregunta.'),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Sí.'),
      PlanoDialogo(
        voz: VozPersonaje.karim,
        texto:
            'Has marcado Probable la datación trajanea. ¿Qué te haría '
            'declararla Sólido?',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto:
            'Una corroboración independiente. Si supiéramos que ese '
            'Licinio cónsul fue contemporáneo de Trajano, tendría '
            'datación cruzada.',
        pausaPrevia: Duration(milliseconds: 700),
      ),
      PlanoDialogo(
        voz: VozPersonaje.karim,
        texto: '¿Has buscado los Licinios cónsules?',
        pausaPrevia: Duration(milliseconds: 600),
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'No. No se me ocurrió.',
        pausaPrevia: Duration(milliseconds: 700),
      ),
      PlanoDialogo(voz: VozPersonaje.karim, texto: 'La PIR.'),
      PlanoDialogo(voz: VozPersonaje.maren, texto: '¿La qué?'),
      PlanoDialogo(
        voz: VozPersonaje.karim,
        texto:
            'Prosopographia Imperii Romani. Es un repertorio de '
            'personas conocidas del Imperio. Los cónsules están todos. '
            'Si el cognomen perdido lo identifica, puedes buscarlo.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 2),
        textoLectura: 'Maren lo apunta.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.karim,
        texto:
            'Mañana tienes deberes. Buscas los Licinios cónsules de '
            'época trajanea. Si encuentras uno que encaje, vuelves con '
            'tu reconstrucción mejorada. Si no encuentras ninguno '
            'claro, vuelves con tu reconstrucción tal cual y declarando '
            'los límites.',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Vale.'),
      PlanoDialogo(
        voz: VozPersonaje.karim,
        texto: 'Bienvenida a la epigrafía.',
        pausaPrevia: Duration(milliseconds: 800),
      ),
    ],
  );

  /// 2.1.5 — *Reconstrucción y Concilio*. Dos días después. Maren
  /// presenta su reconstrucción mejorada con la búsqueda en la PIR.
  /// Aitor revisa técnico, Begoña hace la pregunta de fondo
  /// ("¿por qué Pompaelo y no Roma?"). Doc 08 §2.1.5.
  static const EscenaCinematica reconstruccionYConcilio = EscenaCinematica(
    id: '2.1.5',
    titulo: 'Reconstrucción y Concilio',
    flagDeSalida: 'escena_2_1_5_vista',
    flagsRequeridos: {'escena_2_1_4_vista'},
    ambiente: AmbienteArchivo.salonConcilio,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Dos días después. Salón del Concilio. Begoña, Isaura, '
            'Karim y Aitor sentados a la mesa larga. Maren entra con '
            'su reconstrucción mejorada — encontró candidatos para el '
            '"Licinio cónsul" en la PIR; dos posibilidades, una más '
            'probable que otra. Su confianza en la datación trajanea '
            'sube de Probable a Probable-alto. Mantiene Disputado lo '
            'que no se puede determinar.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura:
            'Aitor le hace preguntas técnicas sobre las dos '
            'candidaturas. Maren las defiende con cautela.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.begona,
        texto:
            '¿Por qué crees que esta inscripción está aquí en Pompaelo '
            'y no en Roma?',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura: 'Maren tarda en responder.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto:
            'No lo sé bien. Pompaelo era ciudad importante de la zona '
            'pero no era de las grandes. Que un cónsul tuviera '
            'honorífica aquí significa que tenía algún vínculo con la '
            'ciudad. O que su familia tenía vínculos con élites '
            'locales.',
        pausaPrevia: Duration(milliseconds: 800),
      ),
      PlanoDialogo(
        voz: VozPersonaje.begona,
        texto: '¿Lo declaras?',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto:
            'Lo declaro Disputado. No tengo evidencia para ninguna de '
            'las dos hipótesis.',
        pausaPrevia: Duration(milliseconds: 700),
      ),
      PlanoDialogo(
        voz: VozPersonaje.begona,
        texto: 'Bien.',
        pausaPrevia: Duration(milliseconds: 600),
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Concilio cierra. Sellada con dos Probable revisables. '
            'Karim asiente con respeto.',
      ),
    ],
  );

  /// 2.1.6 — *El primer apunte de Pompaelo*. Esa noche, voz del
  /// Cuaderno. Cierre de la Estación 2.1 con la lección que más
  /// le ha tocado: "una inscripción no es un documento neutral".
  /// Doc 08 §2.1.6.
  static const EscenaCinematica primerApunteDePompaelo = EscenaCinematica(
    id: '2.1.6',
    titulo: 'El primer apunte de Pompaelo',
    flagDeSalida: 'escena_2_1_6_vista',
    flagsRequeridos: {'escena_2_1_5_vista'},
    ambiente: AmbienteArchivo.cuartoCasaMaren,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Es de noche. Maren en su mesa, cuaderno abierto. Por la '
            'ventana, las luces del Casco Viejo recortan la silueta de '
            'la calle Curia. Lo que vio hoy está debajo.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto:
            'La diferencia entre Aralar y Pompaelo es que en Aralar yo '
            'no entendía el silencio y en Pompaelo no entiendo lo que '
            'se ha dicho.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto:
            'Karim me dijo: "Una inscripción no es un documento '
            'neutral. Es propaganda."',
        pausaPrevia: Duration(milliseconds: 800),
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto: 'Eso lo voy a apuntar en grande.',
        pausaPrevia: Duration(milliseconds: 700),
      ),
      PlanoCierreAmable(textoBoton: 'CERRAR EL CUADERNO'),
    ],
  );

  /// 2.A.1 — *El libro de Quintiliano*. Latente post-Estación 2.1:
  /// activa cuando `arco_2_estacion_1_cerrada` está alzada. Lugar:
  /// estudio de Antonio en la casa familiar. Personajes: Antonio,
  /// Maren. Doc 08 §2.A.1 — pasan ~5-7 días tras el cierre de
  /// Pompaelo y Maren va a buscar bibliografía a su padre antes de
  /// la Estación 2.2 (Calagurris). Antonio le da la *Institutio
  /// Oratoria* en la edición Cousin (latín/francés) y suelta un
  /// comentario clave que Maren guardará: "Quintiliano habla menos
  /// de sí mismo de lo que parece" — anticipo de la pedagogía
  /// pendiente sobre fuentes textuales con autoría individual y
  /// silencios significativos.
  ///
  /// **Sin sustituciones diegéticas**: Quintiliano de Calagurris es
  /// histórico real bien establecido y la edición de Cousin existe
  /// (Jean Cousin, *Quintilien — Institution oratoire*, Les Belles
  /// Lettres, latín y francés enfrentados). Ambos pasan el filtro
  /// del comité asesor sin necesidad de revisión.
  static const EscenaCinematica elLibroDeQuintiliano = EscenaCinematica(
    id: '2.A.1',
    titulo: 'El libro de Quintiliano',
    flagDeSalida: 'escena_2_a_1_vista',
    flagsRequeridos: {'arco_2_estacion_1_cerrada'},
    ambiente: AmbienteArchivo.estudioAntonio,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Casa familiar. Cinco o siete días después del Concilio de '
            'Pompaelo. Maren llama a la puerta del estudio de su padre. '
            'Antonio está leyendo en un sillón, una lámpara baja sobre '
            'el reposabrazos, dos estanterías hasta el techo a su '
            'espalda.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Aita.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.antonio,
        texto: 'Dime.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: '¿Tienes algo de Quintiliano?',
        pausaPrevia: Duration(milliseconds: 500),
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura:
            'Antonio levanta la vista. La mira un segundo. Sin hablar, '
            'se levanta, va a la estantería de la izquierda, saca dos '
            'volúmenes pequeños de tapas verdes y se los pasa.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.antonio,
        texto:
            'Institutio Oratoria. Edición de Cousin, en latín y francés '
            'enfrentados.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: '¿En francés?',
        pausaPrevia: Duration(milliseconds: 400),
      ),
      PlanoDialogo(
        voz: VozPersonaje.antonio,
        texto:
            'El castellano que tengo es peor. El francés se entiende.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Vale. Gracias.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura:
            'Antonio vuelve al sillón. Antes de que Maren se vaya, '
            'levanta la vista de nuevo.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.antonio,
        texto: '¿Vas a ir a Calahorra?',
        pausaPrevia: Duration(milliseconds: 500),
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Sí.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.antonio,
        texto:
            'Quintiliano es interesante. Habla mucho de educación. '
            'Habla menos de sí mismo de lo que parece.',
        pausaPrevia: Duration(milliseconds: 700),
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Ya. Eso es lo que quiero ver.',
        pausaPrevia: Duration(milliseconds: 500),
      ),
      PlanoDialogo(
        voz: VozPersonaje.antonio,
        texto: 'Bien.',
        pausaPrevia: Duration(milliseconds: 400),
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura:
            'Maren se va con los dos tomos pequeños bajo el brazo. '
            'Antonio vuelve a su libro.',
      ),
      PlanoCierreAmable(textoBoton: 'GUARDAR EL LIBRO'),
    ],
  );

  /// 2.A.2 — *Marina y los descansos*. Latente post-Estación 2.1:
  /// requiere `escena_2_a_1_vista` para que las dos latentes se
  /// reproduzcan en el orden del doc 08 (primero la conversación
  /// con el padre, luego el café con Marina). Lugar: cocina del
  /// Archivo. Personajes: Marina, Maren. Doc 08 §2.A.2 — Marina
  /// (Aprendiz III Reformista, ya cerrada visualmente desde 1.0.2)
  /// pone una semilla pedagógica para Calahorra: "te va a tocar".
  /// El "no sé explicarte hasta que la sientas" prepara al jugador
  /// para una Estación 2.2 con peso emocional distinto al de
  /// Pompaelo (técnica) — Calagurris incluirá la cuestión del
  /// silencio del autor sobre sí mismo.
  ///
  /// **Sin sustituciones diegéticas**: Marina sólo menciona "una
  /// inscripción", "huesos y polen", "Aralar", "Calahorra" — todos
  /// términos ya validados. Calahorra/Calagurris está validada en
  /// doc 17.
  static const EscenaCinematica marinaYLosDescansos = EscenaCinematica(
    id: '2.A.2',
    titulo: 'Marina y los descansos',
    flagDeSalida: 'escena_2_a_2_vista',
    flagsRequeridos: {'escena_2_a_1_vista'},
    ambiente: AmbienteArchivo.cocinaArchivo,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Cocina del Archivo. Días después. Maren está preparándose '
            'un café — la cafetera vieja, taza ancha, leche caliente. '
            'Marina entra con su propia taza vacía.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.marina,
        texto: 'Eh, Aprendiz I.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Hola.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.marina,
        texto: '¿Cómo va Pompaelo?',
        pausaPrevia: Duration(milliseconds: 400),
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Cerrada.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.marina,
        texto:
            'Bien. ¿Sabes lo que más me gustó cuando hice mi primera '
            'romana?',
        pausaPrevia: Duration(milliseconds: 600),
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: '¿Qué?',
      ),
      PlanoDialogo(
        voz: VozPersonaje.marina,
        texto:
            'Que se podía leer. Después de un año leyendo huesos y '
            'polen, una inscripción es un descanso.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'No sé si yo lo viviría como descanso.',
        pausaPrevia: Duration(milliseconds: 500),
      ),
      PlanoDialogo(
        voz: VozPersonaje.marina,
        texto: 'Eres rara.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Me lo dicen.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.marina,
        texto: 'Aralar te ha gustado más, ¿verdad?',
        pausaPrevia: Duration(milliseconds: 600),
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'No sé. Aralar fue más limpio.',
        pausaPrevia: Duration(milliseconds: 500),
      ),
      PlanoDialogo(
        voz: VozPersonaje.marina,
        texto:
            'Eso es real. La prehistoria te exige menos cosas distintas '
            'a la vez.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura: 'Pausa. Beben café. La cocina huele a tostada.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.marina,
        texto: 'Calahorra. ¿Vas pronto?',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'La semana que viene.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.marina,
        texto: 'Calahorra te va a tocar.',
        pausaPrevia: Duration(milliseconds: 500),
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: '¿Por qué?',
      ),
      PlanoDialogo(
        voz: VozPersonaje.marina,
        texto:
            'Porque ahí pasa una cosa que no sé explicarte hasta que '
            'la sientas.',
        pausaPrevia: Duration(milliseconds: 800),
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Marina termina su café, deja la taza en el fregadero y '
            'sale. Maren se queda con la frase en la cabeza, mirando '
            'el café que aún tiene caliente.',
      ),
      PlanoCierreAmable(textoBoton: 'TERMINAR EL CAFÉ'),
    ],
  );

  /// 2.2.1 — *Camino a Calahorra*. Apertura de la Estación 2.2:
  /// hora y media de coche con Isaura, ribera del Ebro, paisaje que
  /// se abre hacia el sur. La escena introduce el primer dispositivo
  /// pedagógico de la Estación: la diferencia entre saber un dato
  /// histórico **con la cabeza** y **sentirlo** como vivido. Isaura
  /// le suelta a Maren la fecha que va a articular el arco entero
  /// de la Estación: Calagurris fue navarra hasta 1076. El cartel
  /// de la frontera autonómica que Maren mira en silencio prepara
  /// la conversación que volverá literal en la 2.2.6.
  ///
  /// Doc 08 §2.2.1.
  static const EscenaCinematica caminoACalahorra = EscenaCinematica(
    id: '2.2.1',
    titulo: 'Camino a Calahorra',
    flagDeSalida: 'escena_2_2_1_vista',
    flagsRequeridos: {'escena_2_a_2_vista'},
    ambiente: AmbienteArchivo.cocheIsaura,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Tres semanas tras el inicio del Arco 2. Coche de Isaura, '
            'mañana clara. Carretera de Iruña a Calahorra, hora y '
            'media. El paisaje cambia: del centro de Nafarroa al sur, '
            'la ribera del Ebro. Se abre, se vuelve más seco, más '
            'mediterráneo.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: '¿Has leído a Quintiliano?',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Algo. Mi padre me prestó dos volúmenes.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: '¿Qué te pareció?',
        pausaPrevia: Duration(milliseconds: 400),
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Habla de educación. Mucho. Le importa.',
        pausaPrevia: Duration(milliseconds: 500),
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: '¿Y de él mismo?',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Menos. Pero deja caer cosas.',
        pausaPrevia: Duration(milliseconds: 400),
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: 'Bien.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Pausa larga. Cruzan la frontera autonómica. Cartel: '
            'COMUNIDAD AUTÓNOMA DE LA RIOJA. Maren lo mira. No '
            'comenta. Quince minutos después.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: 'Calagurris fue navarra hasta 1076.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Ya lo sé.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: '¿Lo sabes con la cabeza o lo sientes?',
        pausaPrevia: Duration(milliseconds: 600),
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura:
            'Maren no contesta inmediatamente. Mira por la ventana. '
            'El paisaje del Ebro.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Con la cabeza.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: 'Hoy igual lo sientes.',
        pausaPrevia: Duration(milliseconds: 500),
      ),
      PlanoCierreAmable(textoBoton: 'LLEGAR A CALAHORRA'),
    ],
  );

  /// 2.2.2 — *Calagurris bajo Calahorra*. Llegan a media mañana al
  /// yacimiento. Una arqueóloga local del museo (mujer mayor,
  /// anorak rojo, sin nombre en pantalla — decisión simétrica al
  /// arqueólogo de Irulegi) recibe a las dos. Karim ya la había
  /// avisado desde Iruña — primer cruce de redes profesionales
  /// del Archivo con investigación local de territorio. La visita
  /// guiada articula la lectura clave de la Estación: Calahorra
  /// moderna sobre Calagurris romana en la misma estratigrafía
  /// urbana que Iruña sobre Pompaelo. Maren responde a la pregunta
  /// pivotal con la formulación pedagógica del oficio del Arco 2:
  /// "qué dice de sí mismo y qué no dice."
  ///
  /// Doc 08 §2.2.2.
  static const EscenaCinematica calagurrisBajoCalahorra = EscenaCinematica(
    id: '2.2.2',
    titulo: 'Calagurris bajo Calahorra',
    flagDeSalida: 'escena_2_2_2_vista',
    flagsRequeridos: {'escena_2_2_1_vista'},
    ambiente: AmbienteArchivo.yacimientoCalahorra,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Aparcan cerca del centro. Caminan por calles modernas '
            'hasta el yacimiento. Una arqueóloga del museo, mujer '
            'mayor con anorak rojo, las espera con un mapa enrollado '
            'bajo el brazo.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.arqueologa,
        texto: 'Vosotras sois del Archivo de Iruña.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto:
            'Sí. Esta es Maren, Aprendiz I. Hace su Brecha sobre '
            'Quintiliano.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.arqueologa,
        texto:
            'Bienvenida a Calagurris. Mi colega allí en Iruña — '
            'Karim — ya me adelantó.',
        pausaPrevia: Duration(milliseconds: 400),
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Maren saluda con un gesto. La arqueóloga las lleva por '
            'el yacimiento. Foro romano parcialmente conservado, '
            'restos de termas, cimientos. Calahorra moderna construida '
            'encima en una estratigrafía que recuerda a Iruña sobre '
            'Pompaelo: el presente apoyado en el pasado sin tapar '
            'del todo.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.arqueologa,
        texto: '¿Qué quieres saber de Quintiliano?',
        pausaPrevia: Duration(milliseconds: 500),
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto:
            'Quiero entender qué dice de sí mismo y qué no dice.',
        pausaPrevia: Duration(milliseconds: 500),
      ),
      PlanoDialogo(
        voz: VozPersonaje.arqueologa,
        texto: 'Vamos por buen camino.',
        pausaPrevia: Duration(milliseconds: 500),
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'La arqueóloga las lleva al museo. En una sala dedicada '
            'a Quintiliano hay una estatua moderna, una placa con '
            'datos básicos y unos fragmentos cerámicos del barrio '
            'donde se cree que vivió. Maren los mira con la atención '
            'que ya conoce de Pompaelo.',
      ),
      PlanoCierreAmable(textoBoton: 'PASAR A LA SALA DE TRABAJO'),
    ],
  );

  /// 2.2.3 — *Quintiliano sobre sí mismo*. Mesa de Trabajo en el
  /// museo. La Cronista lee cuatro pasajes seleccionados de la
  /// *Institutio Oratoria* donde Quintiliano habla (poco) de sí
  /// mismo: I prooemium 6, II llegada a Roma, IV dedicatoria a
  /// Vitorio Marcelo, VI lamento por la muerte del hijo. Habilidades
  /// trabajadas: HF.05 (lectura crítica), HF.09 (sesgos del autor)
  /// y especialmente **HF.10 — detección de omisiones** (nueva en
  /// la Estación 2.2). La voz larga del Cuaderno articula la
  /// pedagogía clave: separar lo que la fuente dice de lo que no
  /// dice, sin tratar la omisión como evidencia de igual peso que
  /// la afirmación.
  ///
  /// Doc 08 §2.2.3.
  static const EscenaCinematica quintilianoSobreSiMismo = EscenaCinematica(
    id: '2.2.3',
    titulo: 'Quintiliano sobre sí mismo',
    flagDeSalida: 'escena_2_2_3_vista',
    flagsRequeridos: {'escena_2_2_2_vista'},
    ambiente: AmbienteArchivo.salaTrabajoMuseoCalahorra,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Sala de trabajo del museo. Mesa amplia con luz cenital. '
            'Maren se sienta. Lleva los dos volúmenes verdes que su '
            'padre le prestó. La arqueóloga le ha dado además unas '
            'fotocopias con pasajes traducidos al castellano. Isaura '
            'se queda en un banco lateral, callada, atenta.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Maren empieza por los cuatro pasajes que la arqueóloga '
            'ha marcado con clip. La interfaz activa la Mesa de '
            'Trabajo sobre la mesa real — cada pasaje aparece como '
            'objeto manipulable, con espacio para subrayar y anotar '
            'al margen.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 7),
        textoLectura:
            'Pasaje A — Institutio Oratoria, libro I, prooemium 6: '
            '"tras los años transcurridos en la enseñanza, después '
            'de haberme retirado…" Quintiliano sitúa el momento '
            'en que escribe.\n'
            'Pasaje B — IO II: mención breve a su llegada a Roma.\n'
            'Pasaje C — IO IV, prefacio: dedicatoria a su patrón '
            'Vitorio Marcelo.\n'
            'Pasaje D — IO VI, prefacio: lamento por la muerte de '
            'su hijo.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Maren lee. Toma notas. Subraya. La sala está en silencio. '
            'Isaura no interrumpe. La arqueóloga ha salido a otra '
            'sala. Una hora aproximadamente.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto:
            'Quintiliano habla de su retirada. Habla de su llegada a '
            'Roma. Habla de su patrón. Habla de su hijo muerto.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto:
            'No habla casi nada de Calagurris. No habla casi nada '
            'de sus padres. No habla de cómo fue su infancia. No '
            'habla de por qué se fue.',
        pausaPrevia: Duration(milliseconds: 700),
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto:
            '¿Eso significa que Calagurris no le importaba? ¿O '
            'significa que estaba escribiendo para una élite romana '
            'que no tenía interés en su origen provincial?',
        pausaPrevia: Duration(milliseconds: 800),
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Maren detecta varias omisiones llamativas. Las anota '
            'una por una en el margen, separadas con guiones. La '
            'lección clave del oficio del Arco 2 — separar lo dicho '
            'de lo no dicho — toma forma en el papel.',
      ),
      PlanoCierreAmable(textoBoton: 'LLAMAR A LA ARQUEÓLOGA'),
    ],
  );

  /// 2.2.4 — *Lo que omite*. Diálogo con la arqueóloga sobre lo
  /// que Maren ha visto. La Cronista articula tres hipótesis sobre
  /// las omisiones (público romano que no quiere oír de provinciano,
  /// auto-presentación romana frente a hispana, género literario
  /// que no pide biografía). La arqueóloga aporta el cuarto factor
  /// que Maren no podía ver desde dentro de la fuente: cuarenta
  /// años después de irse, Quintiliano probablemente ya no se
  /// sentía de Calagurris. Maren cierra con 7 afirmaciones para el
  /// Concilio, marcando como **Probable** la identidad romana
  /// adulta y como **Disputado** el peso real de Calagurris en su
  /// formación.
  ///
  /// Doc 08 §2.2.4.
  static const EscenaCinematica loQueOmite = EscenaCinematica(
    id: '2.2.4',
    titulo: 'Lo que omite',
    flagDeSalida: 'escena_2_2_4_vista',
    flagsRequeridos: {'escena_2_2_3_vista'},
    ambiente: AmbienteArchivo.salaTrabajoMuseoCalahorra,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura:
            'Maren ha terminado la lectura. Se queda con sus notas. '
            'La arqueóloga vuelve, con un café de máquina en la mano.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.arqueologa,
        texto: '¿Qué tienes?',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Tengo dos cosas. Lo que dice y lo que no dice.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.arqueologa,
        texto: 'Empieza por lo segundo.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto:
            'No habla casi nada de Calagurris. Menciona que es de '
            'aquí pero no describe el lugar. No habla de sus padres '
            'por nombre. No habla de su infancia. No habla del '
            'momento en que se fue ni de por qué.',
        pausaPrevia: Duration(milliseconds: 600),
      ),
      PlanoDialogo(
        voz: VozPersonaje.arqueologa,
        texto:
            'Eso lo notas tú. La mayoría de la gente no lo nota. '
            '¿Por qué crees que omite tanto?',
        pausaPrevia: Duration(milliseconds: 500),
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Tres hipótesis.',
        pausaPrevia: Duration(milliseconds: 700),
      ),
      PlanoDialogo(
        voz: VozPersonaje.arqueologa,
        texto: 'Vale.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto:
            'Una: que escribe para un público romano que no quiere '
            'oír de provinciano. Dos: que él mismo prefiere ser '
            'visto como romano y no como hispano de provincia. Tres: '
            'que la Institutio no es un género que pida ese tipo '
            'de información biográfica.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.arqueologa,
        texto: '¿Cuál te convence más?',
        pausaPrevia: Duration(milliseconds: 500),
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto:
            'La mezcla de las tres. Pero la dos me llama mucho.',
        pausaPrevia: Duration(milliseconds: 500),
      ),
      PlanoDialogo(
        voz: VozPersonaje.arqueologa,
        texto: '¿Por qué?',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto:
            'Porque lo poco que dice de Calagurris suena como si '
            'estuviera escribiendo desde fuera. No como alguien que '
            'habla de su casa.',
        pausaPrevia: Duration(milliseconds: 500),
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura:
            'La arqueóloga asiente despacio. Mira a Isaura. Isaura '
            'asiente desde su banco.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.arqueologa,
        texto: 'Hay algo más.',
        pausaPrevia: Duration(milliseconds: 600),
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: '¿Qué?',
      ),
      PlanoDialogo(
        voz: VozPersonaje.arqueologa,
        texto:
            'Cuando escribe la Institutio, ya no estaba aquí. '
            'Llevaba cuarenta años en Roma. Es probable que cuando '
            'escribe ya no se sintiera de aquí.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto:
            'Eso le pasa a la gente. Mi madre dice que su prima de '
            'Cuba vuelve a Cuba y ya no le encaja del todo.',
        pausaPrevia: Duration(milliseconds: 600),
      ),
      PlanoDialogo(
        voz: VozPersonaje.arqueologa,
        texto: 'Exacto. Eso pasa.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: 'Tu reconstrucción.',
        pausaPrevia: Duration(milliseconds: 700),
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Maren se gira. Trabaja media hora más. Produce siete '
            'afirmaciones. Las más sutiles tocan la identidad '
            'cultural de Quintiliano. Marca como Probable que se '
            'sentía romano más que hispano cuando escribió, y como '
            'Disputado el peso real que Calagurris tuvo en su '
            'formación temprana — la evidencia es indirecta, vía '
            'omisiones, y las omisiones pesan menos que las '
            'afirmaciones explícitas.',
      ),
      PlanoCierreAmable(textoBoton: 'PREPARAR EL CONCILIO'),
    ],
  );

  /// 2.2.5 — *El Concilio en Calahorra*. Concilio especial — el
  /// primero fuera del Archivo. La arqueóloga local actúa como
  /// revisora externa y Aitor aparece por videollamada desde Iruña
  /// (primera vez que un Concilio cruza el dispositivo de pantalla
  /// + presencia, novedad pedagógica del Arco 2). Las preguntas se
  /// centran en el peso interpretativo de las omisiones — Maren
  /// articula que la evidencia indirecta requiere niveles de
  /// confianza más bajos. Aitor sella la calificación Probable de
  /// la identidad cultural con una observación clave: las
  /// omisiones son evidencia más débil que las afirmaciones.
  ///
  /// Doc 08 §2.2.5.
  static const EscenaCinematica elConcilioEnCalahorra = EscenaCinematica(
    id: '2.2.5',
    titulo: 'El Concilio en Calahorra',
    flagDeSalida: 'escena_2_2_5_vista',
    flagsRequeridos: {'escena_2_2_4_vista'},
    ambiente: AmbienteArchivo.salaTrabajoMuseoCalahorra,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Tarde. Misma sala. La arqueóloga ha colocado una pantalla '
            'pequeña sobre la mesa, conectada al Archivo. Aitor '
            'aparece en plano corto, despacho de Iruña, una taza al '
            'lado del teclado. Concilio reducido — la primera vez '
            'que la Cronista presenta fuera del Archivo.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.aitor,
        texto: 'Buenas. ¿Maren? ¿Me oyes?',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Sí.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.aitor,
        texto: 'Adelante.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Maren presenta. La presentación es más breve que las '
            'anteriores — la Brecha es de fuente textual con material '
            'arqueológico secundario. Las preguntas se centran en el '
            'peso interpretativo de las omisiones.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.arqueologa,
        texto:
            'Has marcado Probable que Quintiliano se sentía romano '
            'más que hispano. ¿Qué te haría cambiarlo?',
        pausaPrevia: Duration(milliseconds: 500),
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto:
            'Si apareciera correspondencia personal o algún texto '
            'donde se refiriera a Calagurris con afecto íntimo o '
            'nostalgia explícita.',
        pausaPrevia: Duration(milliseconds: 600),
      ),
      PlanoDialogo(
        voz: VozPersonaje.arqueologa,
        texto: '¿Y qué te haría declararlo Sólido?',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto:
            'Algún testimonio explícito de él mismo o de sus '
            'contemporáneos sobre su identidad.',
        pausaPrevia: Duration(milliseconds: 700),
      ),
      PlanoDialogo(
        voz: VozPersonaje.aitor,
        texto:
            'La declaras Probable porque te basas en omisiones. Las '
            'omisiones son evidencia más débil que las afirmaciones.',
        pausaPrevia: Duration(milliseconds: 600),
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Sí.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.aitor,
        texto: 'Bien. Sellada.',
        pausaPrevia: Duration(milliseconds: 500),
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Concilio cierra. La arqueóloga felicita a Maren brevemente '
            '— un gesto con la mano sobre el hombro y una sonrisa '
            'de oficio. Aitor se despide por la pantalla y la imagen '
            'se apaga.',
      ),
      PlanoCierreAmable(textoBoton: 'CERRAR EL CONCILIO'),
    ],
  );

  /// 2.2.6 — *Lo que fue y dejó de ser*. Vuelta en coche. Maren
  /// callada. La conversación con Isaura cierra la Estación con la
  /// lección epistémica clave del oficio histórico aplicado a
  /// territorios y a personas: las cosas son y dejan de ser, las
  /// pertenencias sucesivas pueden ser todas verdaderas a su tiempo
  /// sin contradicción. La frase final de Isaura ("a Quintiliano le
  /// pasó parecido") une el tema territorial con el tema biográfico
  /// que Maren ha estado leyendo durante el día. Voz breve del
  /// Cuaderno esa noche redondeando la Estación.
  ///
  /// Doc 08 §2.2.6.
  static const EscenaCinematica loQueFueYDejoDeSer = EscenaCinematica(
    id: '2.2.6',
    titulo: 'Lo que fue y dejó de ser',
    flagDeSalida: 'escena_2_2_6_vista',
    flagsRequeridos: {'escena_2_2_5_vista'},
    ambiente: AmbienteArchivo.cocheIsaura,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Anocheciendo. Vuelven hacia Iruña. La carretera de '
            'regreso se va llenando de luz naranja en el horizonte. '
            'Maren está más callada de lo habitual.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: 'Hablas poco hoy.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Estoy pensando.',
        pausaPrevia: Duration(milliseconds: 400),
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: '¿En qué?',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Calahorra fue navarra. Hasta 1076.',
        pausaPrevia: Duration(milliseconds: 700),
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: 'Sí.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Y ahora es Rioja.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: 'Sí.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto:
            'La gente que vive ahí no se siente navarra. La '
            'arqueóloga no se sentía navarra.',
        pausaPrevia: Duration(milliseconds: 600),
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: 'No.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: '¿Y eso qué es?',
        pausaPrevia: Duration(milliseconds: 500),
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura: 'Pausa larga. Isaura conduce sin mirar a Maren.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto:
            'Eso es la historia. Las cosas son y dejan de ser. Lo '
            'que fue navarro fue navarro de verdad. Lo que es '
            'riojano hoy es riojano de verdad. Las dos cosas son '
            'ciertas.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: '¿No son contradictorias?',
        pausaPrevia: Duration(milliseconds: 500),
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: 'No. Son sucesivas.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura: 'Pausa.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto:
            'A Quintiliano le pasó parecido. Fue de Calagurris. Y '
            'dejó de serlo. Las dos cosas eran verdad para él.',
        pausaPrevia: Duration(milliseconds: 600),
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Maren asiente. Mira por la ventana. Cruzan otra vez la '
            'frontera autonómica. Cartel: COMUNIDAD FORAL DE NAVARRA. '
            'Maren lo mira pero esta vez sí lo nota.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Marina me dijo que Calahorra me iba a tocar.',
        pausaPrevia: Duration(milliseconds: 600),
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: 'Marina sabe.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Esa noche, en su mesa. Cuaderno abierto. La voz interna '
            'cierra la Estación 2.2 con una entrada breve.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto:
            'Calagurris era Calagurris. Después fue navarra. Después '
            'dejó de serlo. Quintiliano fue de aquí. Después no.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto: 'Las cosas son y dejan de ser.',
        pausaPrevia: Duration(milliseconds: 800),
      ),
      PlanoCierreAmable(textoBoton: 'CERRAR EL CUADERNO'),
    ],
  );
}
