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
  /// (Pompaelo bajo Iruña, doc 08 §2.1.1–2.1.6) y las dos cinemáticas
  /// latentes post-Estación 2.1 (2.A.1 *El libro de Quintiliano* y
  /// 2.A.2 *Marina y los descansos*); las estaciones 2.2–2.4 +
  /// cinemáticas latentes 2.B/2.C + Mosaico M2 + cierre 2.Z se
  /// añadirán en commits posteriores.
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
}
