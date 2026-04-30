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
  /// 2.A.2 *Marina y los descansos*), la Estación 2.2 completa
  /// (Quintiliano de Calagurris, doc 08 §2.2.1–2.2.6), la cinemática
  /// latente post-Estación 2.2 (2.B.1 *El cuaderno de Isaura*), la
  /// Estación 2.3 completa (La domus de los mosaicos, doc 08
  /// §2.3.1–2.3.6), la cinemática latente post-Estación 2.3 (2.C.1
  /// *Eider y el cambio*) y la Estación 2.4 completa (Wamba contra
  /// los vascones, doc 08 §2.4.1–2.4.8), la cinemática de entrega
  /// del Mosaico M2 (M2.entrega, doc 08 §M2) y las dos cinemáticas
  /// del cierre del Arco 2 (2.Z.1 *Antonio y Wamba* + 2.Z.2 *La
  /// grabación*, doc 08 §2.Z.1–2.Z.2). La pantalla jugable del
  /// Mosaico M2 (audio-guía de 90s) todavía no está implementada;
  /// el flag `mosaico_arco_2_entregado` se activa provisionalmente
  /// al cerrar la 2.4.8 (registro en BLOQUEOS) para que la
  /// 2.M2.entrega y el cierre 2.Z sean alcanzables hoy.
  ///
  /// Las latentes 2.A.x se ordenan **detrás** de 2.1.6 porque ambas
  /// requieren `arco_2_estacion_1_cerrada` (que la 2.1.6 activa).
  /// La latente 2.B.1 se ordena detrás de 2.2.6 porque requiere
  /// `arco_2_estacion_2_cerrada` (que la 2.2.6 activa). La Estación
  /// 2.3 arranca con 2.3.1 que requiere `escena_2_b_1_vista`. La
  /// latente 2.C.1 se ordena detrás de 2.3.6 porque requiere
  /// `arco_2_estacion_3_cerrada` (que la 2.3.6 activa). La Estación
  /// 2.4 arranca con 2.4.1 que requiere `escena_2_c_1_vista` y
  /// cierra con 2.4.8 que activa el ascenso a Aprendiz II, el hito
  /// `arco_2_estacion_4_cerrada` y (provisional) el flag de
  /// entrega del Mosaico M2. La 2.M2.entrega encadena con la 2.Z.1
  /// (cocina con el padre) y ésta con la 2.Z.2 (grabación, cierre
  /// de arco). La 2.Z.2 activa `arco_2_cerrado_por_la_cronista` —
  /// hito que el Arco 3 requerirá como precondición.
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
    elCuadernoDeIsaura,
    laDomusDeLosMosaicos,
    lasPersonasQueVivieronAqui,
    laCrisis,
    comprenderSinJustificar,
    reconstruccionDeLaDomus,
    concilioDeLaDomus,
    eiderYElCambio,
    unaBrechaDeUnSoloLado,
    lasCronicasVisigodas,
    elSilencioVascon,
    laFrustracion,
    conversacionConKarim,
    reconstruccionHonesta,
    elConcilioDividido,
    aprendizDosLogrado,
    entregaDelMosaicoM2,
    antonioYWamba,
    laGrabacion,
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
    'escena_2_b_1_vista': {
      'cuaderno_de_isaura_visto',
    },
    'escena_2_3_1_vista': {
      'domus_mosaicos_visitada',
    },
    'escena_2_3_2_vista': {
      'fuentes_domus_estudiadas',
    },
    'escena_2_3_3_vista': {
      'crisis_pedagogica_2_3_resuelta',
    },
    'escena_2_3_4_vista': {
      'comprender_sin_justificar_aprendido',
    },
    'escena_2_3_5_vista': {
      'reconstruccion_2_3_hecha',
    },
    'escena_2_3_6_vista': {
      'concilio_2_3_cerrado',
      'brecha_2_3_completada',
      'arco_2_estacion_3_cerrada',
    },
    'escena_2_c_1_vista': {
      'relacion_con_eider_recalibrada',
    },
    'escena_2_4_1_vista': {
      'brecha_2_4_encargada',
    },
    'escena_2_4_2_vista': {
      'cronicas_visigodas_estudiadas',
    },
    'escena_2_4_3_vista': {
      'yacimiento_vascon_visitado',
    },
    'escena_2_4_4_vista': {
      'frustracion_2_4_atravesada',
    },
    'escena_2_4_5_vista': {
      'silencio_es_dato_aprendido',
    },
    'escena_2_4_6_vista': {
      'reconstruccion_2_4_hecha',
    },
    'escena_2_4_7_vista': {
      'concilio_2_4_cerrado',
      'brecha_2_4_completada',
    },
    'escena_2_4_8_vista': {
      'aprendiz_dos_alcanzado',
      'arco_2_estacion_4_cerrada',
      // Provisional (F2-8): hasta que la pantalla jugable del
      // Mosaico M2 (audio-guía de 90s con anclajes obligatorios y
      // declaración verbal de niveles de confianza) esté
      // implementada, cerrar la 2.4.8 activa también el flag de
      // entrega del Mosaico M2 — para que la cinemática
      // 2.M2.entrega y, encadenadas, las dos del cierre del Arco 2
      // (2.Z.1 y 2.Z.2) sean alcanzables hoy. Cuando entre la
      // pantalla M2 jugable, este activador se mueve al
      // `_alEntregarMosaicoArco2` del orquestador y la 2.4.8 deja
      // de activarlo. Cambio trivial registrado en BLOQUEOS.
      'mosaico_arco_2_entregado',
    },
    'escena_m2_entrega_vista': {
      'mosaico_arco_2_archivado_por_andres',
    },
    'escena_2_z_1_vista': {
      'conversacion_padre_silencio_vascon_cerrada',
    },
    'escena_2_z_2_vista': {
      'arco_2_cerrado_por_la_cronista',
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
  ///
  /// **Precondición desde F2-10a**: requiere `brecha_2_1_completada`
  /// (en lugar del previo `escena_2_1_4_vista`). La Brecha 2.1
  /// jugable (`CatalogoBrechas.brecha21`) se interpone entre 2.1.4
  /// y esta 2.1.5: el jugador hace su Concilio interno con Karim en
  /// la Mesa de Trabajo dentro de la Brecha jugable, y dos días
  /// después esta cinemática reproduce el Concilio formal en el
  /// salón con Begoña/Isaura/Karim/Aitor — son dos Concilios
  /// distintos según el doc 08 §2.1.4 / §2.1.5.
  static const EscenaCinematica reconstruccionYConcilio = EscenaCinematica(
    id: '2.1.5',
    titulo: 'Reconstrucción y Concilio',
    flagDeSalida: 'escena_2_1_5_vista',
    flagsRequeridos: {'brecha_2_1_completada'},
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
  /// **Precondición desde F2-10b**: requiere `brecha_2_2_completada`
  /// (en lugar del previo `escena_2_2_4_vista`). La Brecha 2.2
  /// jugable se interpone entre 2.2.4 y esta 2.2.5 — el Concilio
  /// reducido con la arqueóloga local + Aitor por videollamada
  /// llega tras la reconstrucción jugable que Maren produce en
  /// la Mesa de Trabajo.
  static const EscenaCinematica elConcilioEnCalahorra = EscenaCinematica(
    id: '2.2.5',
    titulo: 'El Concilio en Calahorra',
    flagDeSalida: 'escena_2_2_5_vista',
    flagsRequeridos: {'brecha_2_2_completada'},
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

  /// 2.B.1 — *El cuaderno de Isaura*. Latente post-Estación 2.2:
  /// activa ~10 días después del cierre de Calagurris, antes de
  /// que arranque la Estación 2.3. Lugar: despacho de Isaura en la
  /// primera planta del Archivo. Personajes: Isaura, Maren. Doc
  /// 08 §2.B.1.
  ///
  /// La cinemática es deliberadamente breve y elíptica. Maren entra
  /// para una consulta breve sobre la siguiente Brecha; mientras
  /// se va, descubre que Isaura tiene su propio cuaderno de la
  /// Cronista — treinta años, "preguntas, sólo". El plano final
  /// se queda con Isaura tras la salida de Maren: abre el cajón,
  /// mira una página antigua, cierra y guarda. La cámara confirma
  /// al jugador que la mentora también está en el oficio, y que
  /// el oficio no termina con el ascenso.
  ///
  /// Pedagógicamente: el cuaderno de la Cronista no es etapa de
  /// aprendiz, es práctica vitalicia. AH (postura epistémica
  /// continuada) en formato narrativo, no atomizado.
  ///
  /// **Sin sustituciones diegéticas**: la cinemática no nombra
  /// fechas, lugares, autores ni dataciones específicas — el
  /// contenido del guion se preserva tal cual.
  static const EscenaCinematica elCuadernoDeIsaura = EscenaCinematica(
    id: '2.B.1',
    titulo: 'El cuaderno de Isaura',
    flagDeSalida: 'escena_2_b_1_vista',
    flagsRequeridos: {'arco_2_estacion_2_cerrada'},
    ambiente: AmbienteArchivo.despachoIsaura,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Diez días después del Concilio de Calahorra. Despacho de '
            'Isaura, primera planta del Archivo. Mesa de madera oscura, '
            'una lámpara encendida, ventana al patio del claustro. '
            'Maren entra para una consulta breve sobre la siguiente '
            'Brecha.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Isaura está terminando de escribir algo en un cuaderno '
            'marrón viejo, tapas gastadas. Lo cierra cuando ve a '
            'Maren entrar. Lo guarda en un cajón de la mesa, sin '
            'comentar.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: 'Dime.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Maren consulta lo que tiene que consultar. Cinco minutos '
            'de cosas técnicas — fechas, materiales, una pregunta '
            'concreta sobre el calendario. Isaura responde corto. '
            'Al terminar, Maren se va a levantar. Pero se queda '
            'mirando el cajón.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: '¿Qué cuaderno es ése?',
        pausaPrevia: Duration(milliseconds: 700),
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura: 'Isaura la mira. Pausa. No se enfada, no se ríe.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: 'El mío.',
        pausaPrevia: Duration(milliseconds: 500),
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: '¿Como el mío?',
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: 'Más viejo. Más feo.',
        pausaPrevia: Duration(milliseconds: 400),
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: '¿Cuántos años tiene?',
        pausaPrevia: Duration(milliseconds: 500),
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: 'Treinta.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura: 'Pausa. Maren se queda con el dato.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: '¿Qué hay dentro?',
        pausaPrevia: Duration(milliseconds: 500),
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: 'Preguntas.',
        pausaPrevia: Duration(milliseconds: 600),
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: '¿Sólo?',
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: 'Sólo.',
        pausaPrevia: Duration(milliseconds: 500),
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Maren no insiste. Asiente. Sale del despacho con cuidado '
            'al cerrar la puerta. La cámara se queda con Isaura.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 6),
        textoLectura:
            'Después de que Maren salga, Isaura abre el cajón. Saca '
            'el cuaderno marrón. Lo abre por una página cualquiera, '
            'antigua, con tinta desigual. Mira sin leer. Cierra. Lo '
            'vuelve a guardar. Vuelve a su trabajo.',
      ),
      PlanoCierreAmable(textoBoton: 'SALIR DEL DESPACHO'),
    ],
  );

  /// 2.3.1 — *La domus de los mosaicos*. Apertura de la Estación
  /// 2.3 a mediados de enero, ~6 semanas tras el inicio del Arco 2.
  /// Maren e Isaura bajan otra vez al subsuelo de Iruña, esta vez
  /// a una zona distinta — una casa privada, no el foro. La
  /// estructura de la cinemática introduce el dispositivo
  /// pedagógico de la Estación entera con dos preguntas: la que
  /// Isaura propone ("¿cómo era la vida de las personas que
  /// vivieron en esta casa?") y la que Maren formula desde dentro
  /// del oficio ("¿y las personas que no eran propietarios?").
  /// Isaura confirma con un gesto que ésa es la pregunta correcta —
  /// pista pedagógica clave del arco para el jugador.
  ///
  /// Doc 08 §2.3.1.
  static const EscenaCinematica laDomusDeLosMosaicos = EscenaCinematica(
    id: '2.3.1',
    titulo: 'La domus de los mosaicos',
    flagDeSalida: 'escena_2_3_1_vista',
    flagsRequeridos: {'escena_2_b_1_vista'},
    ambiente: AmbienteArchivo.domusMosaicosSubterranea,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Mediados de enero. Bajan otra vez al subsuelo de Iruña, '
            'esta vez por una galería técnica distinta — sale del '
            'sótano del Archivo y se hunde bajo el casco viejo en '
            'dirección norte. La galería desemboca en un espacio '
            'amplio: suelo de mosaico parcial con teselas blancas, '
            'negras, rojas y azules en diseños geométricos; restos '
            'de muros pintados; un horno; una cisterna en la esquina.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: 'Esto es una casa.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: '¿De alguien concreto?',
        pausaPrevia: Duration(milliseconds: 400),
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: 'Sí. Sabemos algo de quién vivía aquí. No mucho.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Maren camina por el suelo de mosaico. Las teselas '
            'gastadas en algunos puntos, intactas en otros. La '
            'sensación de pisar algo doméstico. Una habitación que '
            'fue habitación.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: 'El mosaico es del siglo II.',
        pausaPrevia: Duration(milliseconds: 500),
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: '¿Toda la casa?',
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto:
            'No. La casa fue habitada al menos doscientos años. '
            'Tienes capas dentro de la propia casa.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura: 'Pausa. Maren se queda con la idea de las capas.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto:
            'Tu Brecha aquí es: ¿cómo era la vida de las personas '
            'que vivieron en esta casa?',
        pausaPrevia: Duration(milliseconds: 600),
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Pregunta abierta.',
        pausaPrevia: Duration(milliseconds: 500),
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: 'Sí.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: '¿Hay fuentes?',
        pausaPrevia: Duration(milliseconds: 400),
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto:
            'Tres documentadas. Una inscripción del propietario, '
            'una tablilla con cuentas, restos materiales.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: '¿Y las personas que no eran propietarios?',
        pausaPrevia: Duration(milliseconds: 700),
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura:
            'Isaura la mira un segundo. Asiente despacio, sin '
            'sonrisa. Reconoce la pregunta.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: 'Esa es la pregunta correcta.',
        pausaPrevia: Duration(milliseconds: 500),
      ),
      PlanoCierreAmable(textoBoton: 'EMPEZAR LA BRECHA'),
    ],
  );

  /// 2.3.2 — *Las personas que vivieron aquí*. Mesa de Trabajo
  /// (varias sesiones condensadas). Maren examina las cuatro
  /// fuentes catalogadas: inscripción de Cornelio (magistrado
  /// local, mediados s. II), tablilla con cuentas (compra/venta,
  /// gastos, mención de "siervos" sin nombrar), restos materiales
  /// (cerámica de cocina, herramientas, fragmentos óseos animales,
  /// restos del horno) y comparación con domus análogas
  /// hispanorromanas. Mecánicas: PR.02-04 + HF.07-09 + PH.04
  /// (voces silenciadas). La voz larga del Cuaderno articula la
  /// asimetría de la documentación: el Cornelio aparece, los
  /// siervos aparecen como número (dos) sin nombre — pero alguien
  /// encendía el horno cada mañana, alguien cocinaba, alguien
  /// limpiaba el mosaico durante doscientos años.
  ///
  /// Doc 08 §2.3.2.
  static const EscenaCinematica lasPersonasQueVivieronAqui =
      EscenaCinematica(
    id: '2.3.2',
    titulo: 'Las personas que vivieron aquí',
    flagDeSalida: 'escena_2_3_2_vista',
    flagsRequeridos: {'escena_2_3_1_vista'},
    ambiente: AmbienteArchivo.domusMosaicosSubterranea,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Varias sesiones condensadas en el interfaz. Maren '
            'visita la domus a primera hora, vuelve al Archivo a '
            'la Mesa de Trabajo, repite. Isaura observa desde un '
            'rincón sin intervenir.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 6),
        textoLectura:
            'Cuatro fuentes sobre la mesa.\n'
            '1. Inscripción del propietario — un Cornelio, '
            'magistrado local, mediados del siglo II.\n'
            '2. Tablilla con cuentas — compras y ventas, gastos '
            'domésticos, mención de "siervos" sin nombrar.\n'
            '3. Restos materiales — cerámica de cocina, '
            'herramientas, fragmentos óseos animales, restos en '
            'el horno.\n'
            '4. Comparación con domus análogas documentadas en '
            'otras ciudades hispanorromanas.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Maren identifica al propietario y su estatus en la '
            'primera sesión. La cuestión se complica cuando intenta '
            'reconstruir a las personas esclavizadas que servían '
            'en la casa. Las cuentas las mencionan: dos. Sin '
            'nombre. Su existencia está documentada. Su vida '
            'concreta no.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto:
            'El Cornelio aparece en todas las fuentes. Su esposa '
            'aparece una vez. Sus hijos no aparecen. Los siervos '
            'aparecen como números: dos.',
        pausaPrevia: Duration(milliseconds: 600),
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto:
            'Pero alguien encendió ese horno cada mañana. Alguien '
            'cocinaba en esta cocina. Alguien limpiaba estos '
            'mosaicos. La casa funcionaba todos los días, '
            'doscientos años.',
        pausaPrevia: Duration(milliseconds: 700),
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto:
            'Los nombres de quienes la hacían funcionar no están.',
        pausaPrevia: Duration(milliseconds: 800),
      ),
      PlanoCierreAmable(textoBoton: 'SALIR A RESPIRAR'),
    ],
  );

  /// 2.3.3 — *La crisis*. Patio del Archivo, banco junto al
  /// brocal del pozo. Maren sale después de tres sesiones de
  /// trabajo. Está sentada con el cuaderno cerrado en el regazo,
  /// no escribe. Isaura la encuentra al cabo de quince minutos y
  /// se sienta a su lado en silencio. Maren articula la rabia
  /// epistémica de tener que reconstruir la casa de Cornelio sin
  /// poder nombrar a quienes la sostenían — y el miedo a sonar
  /// como Tasio (caer en presentismo) o a ser cómplice (callarse).
  /// Isaura no resuelve en el sitio: invita a un té. La cinemática
  /// queda abierta para 2.3.4 donde se trabaja la lección.
  ///
  /// Doc 08 §2.3.3.
  ///
  /// **Sustitución diegética activa**: el guion canónico nombra
  /// "el capitel del s. XII" cuando Maren mira al patio. Aquí se
  /// usa "el capitel del patio" sin afirmar siglo, alineado con
  /// la entrada EDIFICIO-ARCHIVO de BLOQUEOS-PENDIENTES.md.
  static const EscenaCinematica laCrisis = EscenaCinematica(
    id: '2.3.3',
    titulo: 'La crisis',
    flagDeSalida: 'escena_2_3_3_vista',
    flagsRequeridos: {'escena_2_3_2_vista'},
    ambiente: AmbienteArchivo.patioArchivo,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Tras tres sesiones de trabajo Maren sale al patio del '
            'Archivo. Se sienta en el banco junto al brocal del '
            'pozo, cuaderno cerrado en el regazo. No escribe. Mira '
            'al capitel del patio sin verlo.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Quince minutos así. Isaura la encuentra. Se sienta a '
            'su lado sin hablar. Dos minutos más en silencio.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: '¿Qué pasa?',
        pausaPrevia: Duration(milliseconds: 600),
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'No quiero seguir esta Brecha.',
        pausaPrevia: Duration(milliseconds: 700),
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: '¿Por qué?',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Me da rabia.',
        pausaPrevia: Duration(milliseconds: 1000),
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: 'Cuéntame.',
        pausaPrevia: Duration(milliseconds: 500),
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura: 'Pausa. Maren respira hondo.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto:
            'Me da rabia que el Cornelio tenga inscripción y los '
            'siervos no tengan nada. Me da rabia que tengo que '
            'reconstruir su casa y hablar de "su" mosaico cuando '
            'el mosaico lo limpiaba alguien que no aparece. Me da '
            'rabia que tengo que tratar al Cornelio como si fuera '
            'el centro de la casa cuando él se sentaba mientras '
            'los demás trabajaban.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura: 'Isaura escucha. No interrumpe.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto:
            'Y si declaro todo eso, suena como Tasio. Y si no lo '
            'declaro, soy cómplice.',
        pausaPrevia: Duration(milliseconds: 700),
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Pausa larga. Isaura no contesta inmediatamente. Mira '
            'al brocal del pozo.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: '¿Quieres una pausa?',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto:
            'No. Quiero que me ayudes a entender cómo se hace esto '
            'sin volverme loca.',
        pausaPrevia: Duration(milliseconds: 600),
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: 'Vamos a la cocina. Te invito un té.',
        pausaPrevia: Duration(milliseconds: 500),
      ),
      PlanoCierreAmable(textoBoton: 'IR A LA COCINA'),
    ],
  );

  /// 2.3.4 — *Comprender sin justificar*. Cocina del Archivo. Té.
  /// Las dos solas. Isaura articula la lección epistémica clave
  /// del Arco 2: la diferencia entre **neutralidad** ("la
  /// esclavitud era una práctica romana, punto") y **comprensión**
  /// ("la esclavitud era estructura de la sociedad romana, esto
  /// es lo que sabemos sobre cómo funcionaba en esta domus
  /// concreta, esto es lo que NO sabemos sobre las personas
  /// esclavizadas, y todo eso ocurrió en un sistema que hoy
  /// reconocemos como atrocidad, aunque la mayoría de los romanos
  /// no lo formularan así"). Habilidades: PH.01 (no presentismo)
  /// + PH.08 (comprender sin justificar). Las dos a la vez —
  /// "lo más difícil del oficio" según Isaura.
  ///
  /// La distinción Tasio/Reformista (Tasio inventaría nombres si
  /// pudiera fundamentarlos a medias, la Cronista declara la
  /// ausencia documentada como información) prepara directamente
  /// la afirmación 6 que Maren producirá en 2.3.5 y defenderá en
  /// el Concilio 2.3.6. Maren cita "las grietas también hablan"
  /// del pasillo de los Reformistas — Isaura confirma con sorpresa
  /// que la frase tiene dos interpretaciones (Tasio vs Karim) y
  /// que la Cronista decide a cuál.
  ///
  /// Doc 08 §2.3.4.
  static const EscenaCinematica comprenderSinJustificar = EscenaCinematica(
    id: '2.3.4',
    titulo: 'Comprender sin justificar',
    flagDeSalida: 'escena_2_3_4_vista',
    flagsRequeridos: {'escena_2_3_3_vista'},
    ambiente: AmbienteArchivo.cocinaArchivo,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Cocina del Archivo. Vacía a esa hora. Té caliente en '
            'dos tazas. Las dos sentadas frente a frente, ventana '
            'al patio del claustro detrás.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto:
            'Lo primero. Lo que sientes es legítimo. La esclavitud '
            'en Pompaelo fue una atrocidad humana. Hoy lo sabemos. '
            'Entonces lo sabían también — no lo decían así, pero '
            'lo sabían algunos.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Entonces ¿por qué tengo que tratarla con neutralidad?',
        pausaPrevia: Duration(milliseconds: 600),
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto:
            'No tienes que tratarla con neutralidad. Tienes que '
            'tratarla con comprensión. Es distinto.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: '¿Cuál es la diferencia?',
        pausaPrevia: Duration(milliseconds: 500),
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto:
            'Neutralidad sería: "la esclavitud era una práctica '
            'romana". Punto. Sin valoración.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Sí.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto:
            'Comprensión es: "la esclavitud era estructura de la '
            'sociedad romana, esto es lo que sabemos sobre cómo '
            'funcionaba en esta domus concreta, esto es lo que NO '
            'sabemos sobre las personas esclavizadas, y todo eso '
            'ocurrió en un sistema que hoy reconocemos como '
            'atrocidad, aunque la mayoría de los romanos no lo '
            'formularan así."',
        pausaPrevia: Duration(milliseconds: 500),
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura: 'Pausa. Maren bebe.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto:
            'La comprensión incluye contexto histórico y dignidad '
            'de las víctimas. Las dos.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Pero entonces sí valoro.',
        pausaPrevia: Duration(milliseconds: 500),
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto:
            'Sí. Pero no proyectas tu valoración sobre la mentalidad '
            'de los romanos. Tu valoración está fuera, como cronista '
            'del siglo XXI mirando. La de ellos está dentro, como '
            'sujetos de su tiempo. Las dos cosas conviven en tu '
            'Brecha.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Eso es difícil.',
        pausaPrevia: Duration(milliseconds: 700),
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto:
            'Es lo más difícil. Por eso PH.01 y PH.08 son '
            'habilidades distintas y por eso las dos importan.',
        pausaPrevia: Duration(milliseconds: 500),
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura: 'Pausa.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: 'Y otra cosa.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: '¿Sí?',
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto:
            'Que los siervos no aparezcan con nombres no significa '
            'que no los reconozcas en la Brecha. Puedes — debes — '
            'declarar lo que se sabe y lo que no se sabe sobre ellos. '
            'Eso no es Tasio. Es Reformista bien entendido.',
        pausaPrevia: Duration(milliseconds: 500),
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: '¿La diferencia con Tasio?',
        pausaPrevia: Duration(milliseconds: 500),
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto:
            'Tasio inventaría sus nombres si pudiera fundamentarlo '
            'a medias. Tú no inventas. Declaras la ausencia. La '
            'ausencia documentada es información.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Las grietas también hablan.',
        pausaPrevia: Duration(milliseconds: 700),
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura: 'Isaura mira a Maren con sorpresa breve.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: '¿Lo has leído?',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Está colgado en el pasillo de los Reformistas. Lo vi.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto:
            'Sí. Las grietas hablan. Tasio lleva esa frase a un '
            'sitio. Karim la lleva a otro. Tú decide a cuál.',
        pausaPrevia: Duration(milliseconds: 500),
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Maren asiente. Bebe el resto del té. Se queda pensando '
            'en la frase. La taza tibia entre las dos manos.',
      ),
      PlanoCierreAmable(textoBoton: 'VOLVER A LA MESA DE TRABAJO'),
    ],
  );

  /// 2.3.5 — *Reconstrucción*. Mesa de Trabajo del Archivo, días
  /// después. Maren produce la reconstrucción reformulada con 8
  /// afirmaciones canónicas — la afirmación 6 ("estas personas
  /// no están nombradas en ninguna fuente que se conserve. Su
  /// número exacto, sus nombres, sus vidas concretas, sus
  /// orígenes culturales se desconocen") va calificada como
  /// **Sólido (la ausencia)**, declaración de oficio que la
  /// Cronista produce conscientemente y que defenderá en el
  /// Concilio. Las otras 7 afirmaciones combinan Sólido (datos
  /// del propietario, número de esclavos, cronología del mosaico),
  /// Probable (esposa con nombre incompleto, vida cotidiana
  /// inferida de domus análogas) y Disputado (existencia de
  /// hijos por edad y posición).
  ///
  /// Doc 08 §2.3.5.
  ///
  /// **Sin sustituciones diegéticas en la reconstrucción**: la
  /// familia Cornelia es ficticia diegética del juego, los
  /// nombres incompletos son explícitamente fragmentarios, la
  /// estructura de afirmaciones reproduce la calibración del doc.
  ///
  /// **Precondición desde F2-10c**: requiere `brecha_2_3_completada`
  /// (en lugar del previo `escena_2_3_4_vista`). La Brecha 2.3
  /// jugable se interpone entre 2.3.4 y esta 2.3.5 — el jugador
  /// produce las 8 afirmaciones con calibración Brier en la mesa
  /// de trabajo, y la 2.3.5 cinemática es la puesta en limpio
  /// narrativa de lo que ya declaró en la Brecha (incluida la
  /// afirmación 6 *"Sólido (la ausencia)"* sobre las personas
  /// esclavizadas no nombradas).
  static const EscenaCinematica reconstruccionDeLaDomus = EscenaCinematica(
    id: '2.3.5',
    titulo: 'Reconstrucción',
    flagDeSalida: 'escena_2_3_5_vista',
    flagsRequeridos: {'brecha_2_3_completada'},
    ambiente: AmbienteArchivo.mesaTrabajoArchivo,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Días después. Mesa de Trabajo del Archivo. Maren ha '
            'releído lo que le dijo Isaura. Tiene el cuaderno '
            'abierto y la lista de fuentes a la izquierda. Empieza '
            'la reconstrucción reformulada.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 8),
        textoLectura:
            '1. La domus fue residencia de la familia Cornelia desde '
            'mediados del siglo II hasta finales del siglo III. '
            'Sólido.\n'
            '2. El propietario principal fue Cornelio (praenomen '
            'perdido), magistrado local. Sólido.\n'
            '3. Su esposa aparece en una sola fuente y se llamaba '
            '(nombre incompleto). Probable.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 7),
        textoLectura:
            '4. Sus hijos no aparecen documentados directamente. '
            'Disputado si los tuvo o no, aunque la edad y posición '
            'social hacen Probable que sí.\n'
            '5. La casa empleaba al menos dos personas esclavizadas, '
            'según las cuentas domésticas. Sólido.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 8),
        textoLectura:
            '6. Estas personas no están nombradas en ninguna fuente '
            'que se conserve. Su número exacto, sus nombres, sus '
            'vidas concretas, sus orígenes culturales se desconocen. '
            'Sólido (la ausencia).',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 6),
        textoLectura:
            '7. La domus tuvo un mosaico geométrico añadido a fines '
            'del siglo II. Sólido.\n'
            '8. La vida cotidiana de la casa incluyó cocina, '
            'comercio, recepción de clientes, vida familiar y '
            'trabajo doméstico esclavizado en proporciones que se '
            'infieren de domus análogas. Probable.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Maren relee. La afirmación 6 es la que más le importa. '
            'La declara con cuidado — el "Sólido (la ausencia)" '
            'lo escribe a mano, sin abreviar.',
      ),
      PlanoCierreAmable(textoBoton: 'PREPARAR EL CONCILIO'),
    ],
  );

  /// 2.3.6 — *Concilio*. Salón del Concilio del Archivo. Karim,
  /// Aitor e Isaura como mesa. Maren presenta. Karim hace la
  /// pregunta que ata todo: la afirmación 6 declara una ausencia,
  /// es inhabitual, ¿por qué la declaras? Maren articula la
  /// reformulación clave del Arco 2 — "no sabemos quiénes eran
  /// porque la sociedad estaba estructurada para que no quedara
  /// registro de quiénes eran". Aitor reconoce que es Reformismo
  /// aplicado pero fundamentado, y la sella. Karim alcanza a
  /// Maren en el pasillo a la salida con una frase corta — "la
  /// afirmación 6 es de las que me hacen tener esperanza con
  /// esta institución" — que cierra la Estación.
  ///
  /// Doc 08 §2.3.6.
  static const EscenaCinematica concilioDeLaDomus = EscenaCinematica(
    id: '2.3.6',
    titulo: 'Concilio de la domus',
    flagDeSalida: 'escena_2_3_6_vista',
    flagsRequeridos: {'escena_2_3_5_vista'},
    ambiente: AmbienteArchivo.salonConcilio,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Salón del Concilio. Mesa larga, tres sillones de orejas '
            'en cabecera. Karim, Aitor e Isaura como revisores. '
            'Maren presenta de pie, con sus 8 afirmaciones impresas '
            'sobre la mesa.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'La presentación dura quince minutos. Maren articula la '
            'estructura, los niveles de confianza, los silencios '
            'documentados. Cuando termina, Karim mira la hoja sobre '
            'la mesa.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.karim,
        texto:
            'Tu afirmación 6 declara una ausencia. Es inhabitual. '
            '¿Por qué la declaras?',
        pausaPrevia: Duration(milliseconds: 600),
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto:
            'Porque la ausencia no es neutralidad de las fuentes. '
            'Es estructura. Las personas esclavizadas no tenían '
            'acceso a producir fuentes propias, y las fuentes '
            'producidas por otros no las nombraron sistemáticamente. '
            'Esa estructura es información sobre cómo funcionaba esa '
            'sociedad.',
        pausaPrevia: Duration(milliseconds: 600),
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura:
            'Pausa. Karim mira a Aitor un segundo. Vuelve a Maren.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.karim,
        texto:
            '¿Estás reformulando "no sabemos quiénes eran" en algo '
            'más fuerte?',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto:
            'Sí. Estoy diciendo "no sabemos quiénes eran porque la '
            'sociedad estaba estructurada para que no quedara '
            'registro de quiénes eran".',
        pausaPrevia: Duration(milliseconds: 600),
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura: 'Aitor interviene desde su sillón.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.aitor,
        texto: 'Eso es Reformismo aplicado.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Lo sé. Pero está fundamentado.',
        pausaPrevia: Duration(milliseconds: 500),
      ),
      PlanoDialogo(
        voz: VozPersonaje.aitor,
        texto: 'Lo está.',
        pausaPrevia: Duration(milliseconds: 700),
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura: 'Karim asiente despacio.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.karim,
        texto: 'Sellada. Bien hecho.',
        pausaPrevia: Duration(milliseconds: 500),
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Concilio cierra. Maren sale del salón con la hoja en '
            'la mano. Karim la alcanza en el pasillo unos pasos '
            'después.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.karim,
        texto: 'Maren.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: '¿Sí?',
      ),
      PlanoDialogo(
        voz: VozPersonaje.karim,
        texto:
            'La afirmación 6 es de las que me hacen tener esperanza '
            'con esta institución.',
        pausaPrevia: Duration(milliseconds: 700),
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Karim sigue caminando. Maren se queda en el pasillo. '
            'No sabe bien qué hacer con lo que acaba de oír. La '
            'hoja con las 8 afirmaciones todavía en la mano.',
      ),
      PlanoCierreAmable(textoBoton: 'CERRAR LA ESTACIÓN'),
    ],
  );

  /// 2.C.1 — *Eider y el cambio*. Latente post-Estación 2.3:
  /// activa cuando `arco_2_estacion_3_cerrada` está alzada.
  /// Lugar: terraza de café en la plaza del Castillo de Iruña,
  /// mediados de febrero, frío. Personajes: Eider, Maren. Doc
  /// 08 §2.C.1.
  ///
  /// La cinemática es deliberadamente breve y emocionalmente
  /// directa. Eider — amiga del instituto, ajena al Archivo, ya
  /// vista en 1.A — hace una pregunta directa que Maren no se
  /// había planteado en pantalla todavía: "¿sigues siendo amiga
  /// mía?". Maren articula un compromiso con la doble pertenencia
  /// ("estoy aprendiendo a estar en muchos sitios a la vez. Pero
  /// contigo estoy") que la obliga a explicitar lo que el oficio
  /// le está haciendo: cambia, pero no abandona. La cinemática
  /// cierra con un plan concreto al cine — la amistad sigue, el
  /// cambio se acepta sin dramatismo.
  ///
  /// Pedagógicamente: el oficio del Cuaderno también modifica al
  /// que lo practica, y la práctica honesta del oficio incluye
  /// reconocerlo ante quien le importa. PH (perspectiva
  /// histórica) en formato relacional, no atomizado.
  ///
  /// **Sin sustituciones diegéticas**: la cinemática no nombra
  /// fechas, lugares, autores ni dataciones específicas — el
  /// contenido del guion se preserva tal cual. La plaza del
  /// Castillo es lugar real de Iruña, ya validable como ambiente
  /// de la ciudad.
  static const EscenaCinematica eiderYElCambio = EscenaCinematica(
    id: '2.C.1',
    titulo: 'Eider y el cambio',
    flagDeSalida: 'escena_2_c_1_vista',
    flagsRequeridos: {'arco_2_estacion_3_cerrada'},
    ambiente: AmbienteArchivo.plazaCastilloIruna,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Mediados de febrero. Plaza del Castillo de Iruña. '
            'Terraza de café al sol, frío seco, dos cafés con '
            'leche en una mesa pequeña. Maren y Eider, las dos '
            'con abrigos abiertos.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.eider,
        texto: 'Llevas dos meses raros.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: '¿Más rara que antes?',
        pausaPrevia: Duration(milliseconds: 600),
      ),
      PlanoDialogo(
        voz: VozPersonaje.eider,
        texto: 'Distinto raro.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura: 'Pausa. Eider mira la taza, la levanta, no bebe.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.eider,
        texto: 'No es malo. Sólo distinto.',
        pausaPrevia: Duration(milliseconds: 500),
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Estoy aprendiendo cosas.',
        pausaPrevia: Duration(milliseconds: 700),
      ),
      PlanoDialogo(
        voz: VozPersonaje.eider,
        texto: 'Eso ya lo sé.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura: 'Pausa. Eider deja la taza otra vez en la mesa.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.eider,
        texto: 'Tía. Pregunta directa.',
        pausaPrevia: Duration(milliseconds: 500),
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Vale.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.eider,
        texto: '¿Sigues siendo amiga mía?',
        pausaPrevia: Duration(milliseconds: 700),
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Maren se queda quieta. La plaza alrededor sigue. '
            'Treinta segundos. Eider espera sin presionar — sólo '
            'la mira.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Eider. Sí.',
        pausaPrevia: Duration(milliseconds: 600),
      ),
      PlanoDialogo(
        voz: VozPersonaje.eider,
        texto:
            'Es que a veces tengo la sensación de que estás en '
            'otro sitio.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto:
            'Estoy aprendiendo a estar en muchos sitios a la vez. '
            'Pero contigo estoy.',
        pausaPrevia: Duration(milliseconds: 700),
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura:
            'Eider mira hacia otro lado. No por incomodidad — '
            'porque está procesando.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.eider,
        texto: 'Vale.',
        pausaPrevia: Duration(milliseconds: 500),
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura: 'Pausa larga. Las dos miran cualquier cosa.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.eider,
        texto: '¿Mañana al cine?',
        pausaPrevia: Duration(milliseconds: 500),
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Mañana al cine.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Beben. La conversación importante ya pasó. Hablan de '
            'cualquier cosa — la peli, lo que decía un profe, una '
            'tontería del grupo. La amistad sigue.',
      ),
      PlanoCierreAmable(textoBoton: 'TERMINAR EL CAFÉ'),
    ],
  );

  /// 2.4.1 — *Una Brecha de un solo lado*. Apertura de la Estación
  /// 2.4 a mediados de febrero. Despacho de Isaura. La mentora
  /// presenta a Maren la Brecha de cierre del arco con la mesa
  /// preparada — tres libros y una carpeta. La cinemática introduce
  /// el dispositivo pedagógico de la Estación entera con una
  /// declaración estructural que Maren tiene que aceptar antes de
  /// empezar: "esta Brecha tiene un problema estructural. Y no se
  /// puede resolver. Sólo se puede declarar." Las fuentes son todas
  /// de un solo lado — Crónica de Wamba escrita por Julián de
  /// Toledo y otras menciones en concilios y crónicas visigodas;
  /// los vascones no se defienden por escrito (no porque no
  /// escribieran nada, porque no se conserva). Maren confirma con
  /// la pregunta de oficio del Arco 2: "¿materia arqueológica?"
  ///
  /// El cierre con "no la vas a fastidiar, Maren / eso no lo sabes /
  /// tienes razón, no lo sé" reproduce la postura epistémica del
  /// oficio aplicada a la propia mentora — Isaura predica con el
  /// ejemplo lo que Maren va a tener que sostener en la Brecha.
  ///
  /// Doc 08 §2.4.1.
  static const EscenaCinematica unaBrechaDeUnSoloLado = EscenaCinematica(
    id: '2.4.1',
    titulo: 'Una Brecha de un solo lado',
    flagDeSalida: 'escena_2_4_1_vista',
    flagsRequeridos: {'escena_2_c_1_vista'},
    ambiente: AmbienteArchivo.despachoIsaura,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Mediados de febrero. Despacho de Isaura. Maren entra. '
            'Isaura la espera con tres libros sobre la mesa y una '
            'carpeta marrón ya abierta — una de las gastadas, no '
            'una nueva.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: 'Tu Brecha de cierre.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: '¿Wamba?',
        pausaPrevia: Duration(milliseconds: 500),
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: 'Wamba.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Año 673.',
        pausaPrevia: Duration(milliseconds: 400),
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: 'Sí. Campaña visigótica contra los vascones del norte.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura:
            'Pausa. Isaura ordena dos de los libros sin urgencia.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: 'Quiero que entiendas algo antes de empezar.',
        pausaPrevia: Duration(milliseconds: 500),
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Sí.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto:
            'Esta Brecha tiene un problema estructural. Y no se puede '
            'resolver. Sólo se puede declarar.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: '¿Cuál?',
        pausaPrevia: Duration(milliseconds: 500),
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto:
            'Que las fuentes son todas de un solo lado. Crónica de '
            'Wamba escrita por Julián de Toledo, otras menciones en '
            'concilios y crónicas visigodas. Visigodos hablando de '
            'vascones derrotados. Los vascones no se defienden por '
            'escrito. No porque no escribieran nada — porque no se '
            'conserva.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: '¿Materia arqueológica?',
        pausaPrevia: Duration(milliseconds: 600),
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: 'Algo. Limitada. Te lo doy.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura:
            'Isaura le pasa la carpeta. Maren la apoya sobre el '
            'regazo sin abrirla todavía.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto:
            'Tu Brecha es: ¿qué pasó realmente en la campaña del '
            '673? Y vas a tener que reconstruir desde fuentes '
            'hostiles, declarar el sesgo, y aceptar que tu '
            'reconstrucción tendrá un techo.',
        pausaPrevia: Duration(milliseconds: 500),
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Esta es la del Concilio entero, ¿verdad?',
        pausaPrevia: Duration(milliseconds: 700),
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: 'Sí.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: '¿Qué pasa si la fastidio?',
        pausaPrevia: Duration(milliseconds: 600),
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto:
            'Te quedas Aprendiz I un tiempo más. Reabres. Trabajas. '
            'Lo intentas otra vez.',
        pausaPrevia: Duration(milliseconds: 600),
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Vale.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: 'No la vas a fastidiar, Maren.',
        pausaPrevia: Duration(milliseconds: 700),
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Eso no lo sabes.',
        pausaPrevia: Duration(milliseconds: 500),
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: 'Tienes razón. No lo sé.',
        pausaPrevia: Duration(milliseconds: 600),
      ),
      PlanoCierreAmable(textoBoton: 'COGER LA CARPETA'),
    ],
  );

  /// 2.4.2 — *Las crónicas visigodas*. Biblioteca del Archivo,
  /// primera planta. Maren con los textos de Julián de Toledo y
  /// otras fuentes visigodas. Voz larga del Cuaderno articulando
  /// la postura crítica frente a la *Historia Wambae regis*: hagiografía
  /// del rey, vascones aparecen tres veces y siempre como objeto
  /// (gente que vive en montañas, derrotados, "pacificados"). La
  /// pregunta clave que Maren formula desde dentro del oficio —
  /// "la palabra rebelde presupone autoridad legítima previa,
  /// ¿era legítima la autoridad visigoda sobre los vascones?" —
  /// la cruza Aitor por la biblioteca con un comentario de pasada
  /// que confirma la intuición de la Cronista sin hacer escena
  /// de ello.
  ///
  /// Doc 08 §2.4.2.
  static const EscenaCinematica lasCronicasVisigodas = EscenaCinematica(
    id: '2.4.2',
    titulo: 'Las crónicas visigodas',
    flagDeSalida: 'escena_2_4_2_vista',
    flagsRequeridos: {'escena_2_4_1_vista'},
    ambiente: AmbienteArchivo.bibliotecaArchivo,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Biblioteca del Archivo, primera planta. Salón largo, '
            'estanterías de roble, mesas con flexos antiguos. Maren '
            'lleva tres días ahí. Tiene la *Historia Wambae regis* '
            'de Julián de Toledo abierta, una edición moderna con '
            'aparato crítico, y un cuaderno con las páginas '
            'marcadas con clips amarillos.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Lectura crítica. La fuente es retórica, narrativa, '
            'hagiográfica del rey Wamba. Los vascones aparecen como '
            'pueblo "rebelde" que el rey "pacifica". Maren toma '
            'notas en columna. A la izquierda lo que dice. A la '
            'derecha lo que esa formulación presupone.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto:
            'Julián de Toledo escribe sesenta años después de los '
            'hechos. Es propaganda dinástica. La campaña de Wamba '
            'aparece como gesta heroica.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto:
            'Los vascones aparecen tres veces. La primera, descritos '
            'como gente que vive en montañas y "no acepta autoridad". '
            'La segunda, derrotados en una batalla. La tercera, '
            '"pacificados" por el rey.',
        pausaPrevia: Duration(milliseconds: 700),
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto:
            'La palabra "rebelde" presupone autoridad legítima previa. '
            '¿Era legítima la autoridad visigoda sobre los vascones? '
            'Julián lo da por hecho. Pero esa es la pregunta.',
        pausaPrevia: Duration(milliseconds: 800),
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Aitor entra a la biblioteca a por un libro de uno de '
            'los estantes altos. Pasa por delante de la mesa de '
            'Maren con el libro ya en la mano, sin pararse del todo.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.aitor,
        texto:
            'Pregunta de oficio: ¿estaban los vascones bajo dominio '
            'visigodo antes del 673?',
        pausaPrevia: Duration(milliseconds: 500),
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura:
            'Maren levanta la vista. Aitor la mira de pasada — no se '
            'queda, no se sienta.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto:
            'Es la pregunta. Las fuentes visigodas dicen que sí. Pero '
            'el hecho de que cada generación tenga que enviar una '
            'campaña significa que no del todo.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.aitor,
        texto: 'Mm.',
        pausaPrevia: Duration(milliseconds: 500),
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Aitor sigue caminando hacia la salida con su libro. '
            'Maren vuelve al texto. La intuición confirmada sin '
            'aspavientos. La biblioteca en silencio.',
      ),
      PlanoCierreAmable(textoBoton: 'CERRAR LA EDICIÓN'),
    ],
  );

  /// 2.4.3 — *El silencio vascón*. Yacimiento al norte de Iruña.
  /// Maren e Isaura visitan los restos de un asentamiento vascón
  /// del periodo. Materia silenciosa: estructuras de habitación
  /// modestas, fragmentos cerámicos hechos a mano (sin torno —
  /// información), herramientas, ninguna inscripción propia.
  /// Isaura formula el principio epistémico que organiza la
  /// Estación entera: para reconstruir el lado vascón hay que
  /// combinar la materia con la lectura crítica de las fuentes
  /// hostiles. Maren conecta con la prehistoria del Arco 1
  /// ("volver a la prehistoria, en cierto sentido"), Isaura
  /// asiente despacio.
  ///
  /// **Sustitución diegética activa**: el yacimiento concreto
  /// queda **sin nombrar** — el doc 08 §2.4.3 explícitamente
  /// dice "a definir con asesoría — candidatos: zona de Aralar,
  /// Pirineo navarro, valle de Baztán". Hasta que el comité
  /// elija entre los tres del doc 5 §3.2, el ambiente se llama
  /// genéricamente `yacimientoVasconNorte` y la cinemática
  /// describe sólo el material visible sin afirmar topónimo.
  /// Registrado en BLOQUEOS-PENDIENTES.md.
  ///
  /// Doc 08 §2.4.3.
  static const EscenaCinematica elSilencioVascon = EscenaCinematica(
    id: '2.4.3',
    titulo: 'El silencio vascón',
    flagDeSalida: 'escena_2_4_3_vista',
    flagsRequeridos: {'escena_2_4_2_vista'},
    ambiente: AmbienteArchivo.yacimientoVasconNorte,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Días después. Yacimiento al norte de Iruña — un '
            'asentamiento vascón documentado del periodo. Mañana '
            'fría. Restos modestos: estructuras de habitación de '
            'piedra seca, una pared baja, fragmentos cerámicos '
            'esparcidos junto al sondeo. Hierba alta, viento. '
            'Maren e Isaura caminan despacio por encima de los '
            'cimientos.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: 'Esto es lo que tenemos del lado vascón.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Maren mira. Hay poco. Una pared baja. Cerámica hecha a '
            'mano — sin torno, lo cual ya es información: técnica '
            'distinta, escala distinta, sociedad distinta de la '
            'romana o la visigótica.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'No hay inscripciones.',
        pausaPrevia: Duration(milliseconds: 600),
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: 'No.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: '¿Eso significa que no escribían?',
        pausaPrevia: Duration(milliseconds: 500),
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto:
            'Significa que no se conservan inscripciones suyas. Que '
            'escribieran o no es otra pregunta.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto:
            'Probablemente no escribían como los romanos o los '
            'visigodos.',
        pausaPrevia: Duration(milliseconds: 600),
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: 'Probablemente. Pero no del todo seguro.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura:
            'Pausa. Isaura se agacha junto a un fragmento cerámico, '
            'lo mira sin tocarlo, se levanta.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto:
            'Lo que tenemos del lado vascón son objetos. Materia '
            'silenciosa. Para reconstruir su lado de la campaña '
            'del 673, tienes que combinar estos objetos con la '
            'lectura crítica de las fuentes hostiles.',
        pausaPrevia: Duration(milliseconds: 600),
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Volver a la prehistoria, en cierto sentido.',
        pausaPrevia: Duration(milliseconds: 700),
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: 'En cierto sentido sí.',
        pausaPrevia: Duration(milliseconds: 500),
      ),
      PlanoCierreAmable(textoBoton: 'BAJAR DEL YACIMIENTO'),
    ],
  );

  /// 2.4.4 — *La frustración*. Mesa de Trabajo del Archivo. Maren
  /// trabaja varias horas durante varios días. La Brecha es difícil:
  /// sabe lo que dicen los visigodos, sabe que su lectura es
  /// sesgada, no sabe qué pasó realmente. Voz larga del Cuaderno
  /// articulando la frustración legítima del oficio cuando el
  /// techo metodológico es estructural — no se puede declarar
  /// Sólido lo que las fuentes no permiten declarar Sólido.
  /// Pedagógicamente: el motor adaptativo detecta la dificultad
  /// y reduce el ritmo de demanda; la cinemática lo registra
  /// narrativamente sin hacer escena del mecanismo del juego.
  ///
  /// Doc 08 §2.4.4.
  static const EscenaCinematica laFrustracion = EscenaCinematica(
    id: '2.4.4',
    titulo: 'La frustración',
    flagDeSalida: 'escena_2_4_4_vista',
    flagsRequeridos: {'escena_2_4_3_vista'},
    ambiente: AmbienteArchivo.mesaTrabajoArchivo,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Mesa de Trabajo del Archivo. Tres días encadenados. '
            'Maren con las fuentes ordenadas por columnas: visigodas '
            'a la izquierda, materiales en el centro, hipótesis a '
            'la derecha. La columna derecha está casi vacía. Lleva '
            'una hora sin escribir.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto:
            'Tres días con esto. No avanza. Sé lo que dicen los '
            'visigodos. Sé que su lectura es sesgada. No sé qué '
            'pasó realmente. Y eso me frustra como nunca antes.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto:
            'Quiero declarar Sólido más cosas. No puedo. Casi todo '
            'es Probable o Disputado.',
        pausaPrevia: Duration(milliseconds: 700),
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto:
            'Es como si la Brecha me dijera "aprende a aceptar el '
            'techo o te quedas aquí encallada."',
        pausaPrevia: Duration(milliseconds: 800),
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Maren cierra la libreta sin terminar la columna. La '
            'deja sobre la mesa. Se levanta. Necesita salir.',
      ),
      PlanoCierreAmable(textoBoton: 'IR A POR UN CAFÉ'),
    ],
  );

  /// 2.4.5 — *Conversación con Karim*. Cocina del Archivo. Maren
  /// se está haciendo un café cuando entra Karim. La cinemática
  /// es la pieza pedagógica clave de la Estación: Karim reformula
  /// la frustración de Maren como **el dato mismo de la Brecha**.
  /// "El silencio vascón es el dato. No es ausencia de dato. Es
  /// dato. Es información sobre cómo funcionaba la dominación."
  /// Maren lo lleva más allá ("o que las había y se perdieron",
  /// que también es información sobre dominación posterior).
  /// Karim cierra con la frase que marca el oficio del juego
  /// frente a la historia que se escribe sin atender a los
  /// silencios — "la gente que escribe la historia normalmente
  /// no escribe sobre los silencios. Tu trabajo va a notarse
  /// precisamente porque tú sí vas a escribir sobre los
  /// silencios". Y la respuesta a "¿eso es Reformismo?" — "eso
  /// es oficio. El reformismo es lo mismo aplicado con otra
  /// urgencia. Pero en la base es el mismo trabajo".
  ///
  /// Doc 08 §2.4.5.
  static const EscenaCinematica conversacionConKarim = EscenaCinematica(
    id: '2.4.5',
    titulo: 'Conversación con Karim',
    flagDeSalida: 'escena_2_4_5_vista',
    flagsRequeridos: {'escena_2_4_4_vista'},
    ambiente: AmbienteArchivo.cocinaArchivo,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Cocina del Archivo. Maren con la cafetera, leche '
            'caliente, taza ancha. Karim entra. Ve a Maren. La mira.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.karim,
        texto: 'Wamba.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Wamba.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.karim,
        texto: 'Cuéntame qué te pasa.',
        pausaPrevia: Duration(milliseconds: 500),
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Karim se sienta en una de las sillas de madera. Maren '
            'cuenta. Diez minutos. La frustración, las fuentes, el '
            'techo que no se mueve. Karim escucha sin interrumpir, '
            'taza vacía entre las dos manos.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.karim,
        texto: 'Vale. Te voy a decir algo que igual te molesta.',
        pausaPrevia: Duration(milliseconds: 600),
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Vale.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.karim,
        texto: 'Lo que te frustra es lo más importante de la Brecha.',
        pausaPrevia: Duration(milliseconds: 600),
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'No te entiendo.',
        pausaPrevia: Duration(milliseconds: 600),
      ),
      PlanoDialogo(
        voz: VozPersonaje.karim,
        texto:
            'El silencio vascón es el dato. No es ausencia de dato. '
            'Es dato. Es información sobre cómo funcionaba la '
            'dominación. Las fuentes son hostiles porque la sociedad '
            'las controlaba la parte hostil. Que no haya fuentes '
            'vasconas significa que no había instituciones vasconas '
            'con capacidad de producir y conservar texto a la altura '
            'de las visigodas.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'O que las había y se perdieron.',
        pausaPrevia: Duration(milliseconds: 700),
      ),
      PlanoDialogo(
        voz: VozPersonaje.karim,
        texto:
            'O eso. Lo segundo también es información — significa '
            'que la dominación posterior eliminó lo que pudo.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Y eso lo declaro.',
        pausaPrevia: Duration(milliseconds: 500),
      ),
      PlanoDialogo(
        voz: VozPersonaje.karim,
        texto: 'Eso lo declaras.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura:
            'Pausa. Karim se levanta a por un café. Vuelve a la '
            'silla.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.karim,
        texto:
            'Maren. La gente que escribe la historia normalmente no '
            'escribe sobre los silencios. Tu trabajo va a notarse '
            'precisamente porque tú sí vas a escribir sobre los '
            'silencios.',
        pausaPrevia: Duration(milliseconds: 600),
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: '¿Eso es Reformismo?',
        pausaPrevia: Duration(milliseconds: 700),
      ),
      PlanoDialogo(
        voz: VozPersonaje.karim,
        texto:
            'Eso es oficio. El reformismo es lo mismo aplicado con '
            'otra urgencia. Pero en la base es el mismo trabajo.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Maren asiente. Lleva el café a la Mesa de Trabajo. La '
            'columna derecha empieza a llenarse de otra manera.',
      ),
      PlanoCierreAmable(textoBoton: 'VOLVER A LA MESA'),
    ],
  );

  /// 2.4.6 — *Reconstrucción honesta*. Mesa de Trabajo. Maren
  /// produce las 9 afirmaciones canónicas de la Brecha. Mezcla
  /// densa de Sólido (campaña en 673, propaganda dinástica de
  /// Julián, narrativa visigoda como "rebelión", afirmación 7
  /// como Sólido (la ausencia)), Probable (enfrentamiento
  /// localizable, asimetría documental como estructura) y
  /// Disputado (estatus previo, alcance real de la pacificación).
  /// La afirmación 9 es **declaración metodológica explícita**
  /// — Sólido como declaración metodológica — que reconoce el
  /// techo estructural de la reconstrucción para que cualquier
  /// cronista futuro sepa qué se puede y qué no se puede pedir
  /// a las fuentes.
  ///
  /// Voz breve del Cuaderno tras terminar: "no he resuelto la
  /// Brecha. La he declarado. Igual eso es lo que tenía que
  /// hacer."
  ///
  /// Doc 08 §2.4.6.
  static const EscenaCinematica reconstruccionHonesta = EscenaCinematica(
    id: '2.4.6',
    titulo: 'Reconstrucción honesta',
    flagDeSalida: 'escena_2_4_6_vista',
    flagsRequeridos: {'escena_2_4_5_vista'},
    ambiente: AmbienteArchivo.mesaTrabajoArchivo,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Días después. Mesa de Trabajo del Archivo. Maren ha '
            'releído lo que le dijo Karim. La frustración no se ha '
            'ido del todo, pero la frustración ya no bloquea. Ahora '
            'la columna derecha del cuaderno tiene texto.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 8),
        textoLectura:
            '1. Wamba dirigió una campaña militar contra los '
            'vascones del norte en 673. Sólido.\n'
            '2. La campaña fue narrada décadas después por Julián '
            'de Toledo en función propagandística. Sólido.\n'
            '3. La narrativa visigoda presenta a los vascones como '
            'pueblo "rebelde", presuponiendo dominio previo. Sólido.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 8),
        textoLectura:
            '4. El estatus real de los vascones antes de la campaña '
            '— sometidos, aliados, independientes, mixto — es '
            'Disputado. Las fuentes visigodas afirman lo primero, '
            'pero las campañas recurrentes lo ponen en duda. '
            'Disputado.\n'
            '5. La campaña incluyó al menos un enfrentamiento '
            'militar con derrota vascona localizable cronológicamente. '
            'Probable.\n'
            '6. El alcance real de la "pacificación" tras la '
            'campaña es Disputado — campañas posteriores sugieren '
            'que no fue duradera. Disputado.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 9),
        textoLectura:
            '7. No se conservan fuentes producidas por los vascones '
            'del periodo. Ni textuales ni epigráficas. Las fuentes '
            'para reconstruir su lado son material arqueológico, '
            'mención indirecta en fuentes hostiles, y comparación '
            'con periodos anteriores y posteriores. Sólido (la '
            'ausencia).\n'
            '8. Esta ausencia documental no es accidente: refleja '
            'una estructura social donde una de las partes tenía '
            'instituciones de producción y conservación textual y '
            'la otra no, en la medida documentada. Probable.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 7),
        textoLectura:
            '9. La reconstrucción del lado vascón tiene un techo '
            'metodológico estructural. Cualquier afirmación sobre '
            'su perspectiva específica del conflicto será Probable '
            'o Disputado por defecto, salvo que aparezcan nuevas '
            'fuentes. Sólido como declaración metodológica.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto: 'No he resuelto la Brecha. La he declarado.',
        pausaPrevia: Duration(milliseconds: 600),
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto: 'Igual eso es lo que tenía que hacer.',
        pausaPrevia: Duration(milliseconds: 800),
      ),
      PlanoCierreAmable(textoBoton: 'PREPARAR EL CONCILIO'),
    ],
  );

  /// 2.4.7 — *El Concilio dividido*. Salón del Concilio del
  /// Archivo. Concilio entero — primera vez en el Arco 2 que
  /// las cinco voces revisoras coinciden en la mesa: Begoña
  /// preside, Isaura, Karim, Aitor y **Joana** (primera aparición
  /// narrativa larga de Joana en el Arco 2). Marina observa.
  /// Maren presenta. La afirmación 8 ("esta ausencia documental
  /// no es accidente") genera el debate: Joana (Anclada) la lee
  /// como interpretativa, Karim (Reformista) la habría declarado
  /// "Sólido tirando a Probable alto", Aitor (Constructor) la
  /// habría declarado "Probable bajo". Las tres escuelas
  /// convergen en Probable desde distintos lados — el doc lo
  /// describe como "exactamente lo que el oficio celebra".
  ///
  /// Begoña pregunta por la afirmación 9 (declaración
  /// metodológica). Maren articula la justificación: el techo
  /// estructural debe declararse para que ningún cronista futuro
  /// confunda "no se sabe" con "se puede saber con más trabajo".
  /// Begoña sella sin sonreír — pero Marina capta la sonrisa
  /// de dos segundos en el pasillo de salida ("Begoña ha sonreído /
  /// no la vi / has sonreído tú. Ella también, dos segundos").
  ///
  /// Doc 08 §2.4.7.
  static const EscenaCinematica elConcilioDividido = EscenaCinematica(
    id: '2.4.7',
    titulo: 'El Concilio dividido',
    flagDeSalida: 'escena_2_4_7_vista',
    flagsRequeridos: {'escena_2_4_6_vista'},
    ambiente: AmbienteArchivo.salonConcilio,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Salón del Concilio. Mesa larga. Begoña preside desde '
            'la cabecera. Isaura, Karim, Aitor y Joana en los lados. '
            'Marina al fondo, en una silla apartada, observa sin '
            'derecho de palabra. Maren entra, saluda con la cabeza, '
            'se queda de pie con la hoja de las nueve afirmaciones.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.begona,
        texto: 'Adelante.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Maren presenta durante quince minutos. Las nueve '
            'afirmaciones, los anclajes en cada fuente, los niveles '
            'de confianza con sus razones. Cuando termina, el '
            'Concilio entra en discusión. La afirmación 8 — "esta '
            'ausencia documental no es accidente" — es la que '
            'genera debate.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.joana,
        texto:
            'La afirmación 8 es interpretativa. ¿No estás declarando '
            'como Probable algo que es más bien hipótesis?',
        pausaPrevia: Duration(milliseconds: 600),
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto:
            'Es interpretativa. Pero la base — ausencia de fuentes '
            'vasconas, presencia de fuentes visigodas en cantidad — '
            'es documentada. La inferencia sobre lo que esa '
            'asimetría significa es interpretativa.',
        pausaPrevia: Duration(milliseconds: 600),
      ),
      PlanoDialogo(
        voz: VozPersonaje.joana,
        texto: 'Y la declaras Probable.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto:
            'Sí. Si la marcara Sólido, estaría afirmando como hecho '
            'lo que es inferencia. Si la marcara Disputado, estaría '
            'exagerando la duda — la asimetría es real.',
        pausaPrevia: Duration(milliseconds: 600),
      ),
      PlanoDialogo(
        voz: VozPersonaje.joana,
        texto: 'Vale. Probable acepto.',
        pausaPrevia: Duration(milliseconds: 700),
      ),
      PlanoDialogo(
        voz: VozPersonaje.karim,
        texto:
            'Yo la habría declarado Sólido tirando a Probable alto. '
            'Pero acepto Probable.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.aitor,
        texto:
            'Yo la habría declarado Probable bajo. Acepto Probable.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Risa breve y respetuosa en la sala. Las tres escuelas '
            'convergiendo en Probable desde distintos lados es '
            'exactamente lo que el oficio celebra.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.begona,
        texto: 'Una pregunta para Maren.',
        pausaPrevia: Duration(milliseconds: 600),
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Sí.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.begona,
        texto:
            'Tu reconstrucción tiene una afirmación que es '
            'declaración metodológica. La 9. ¿Por qué la incluyes?',
        pausaPrevia: Duration(milliseconds: 500),
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto:
            'Porque si no la incluyo, quien lea mi reconstrucción '
            'podría pensar que con más trabajo se podría llegar a '
            'más certeza sobre el lado vascón. Y eso no es verdad. '
            'El techo es estructural. Lo declaro para que cualquier '
            'cronista que retome esta Brecha sepa qué se puede y '
            'qué no se puede pedir a las fuentes.',
        pausaPrevia: Duration(milliseconds: 800),
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Pausa larga. Begoña la mira. Cinco segundos. La sala '
            'en silencio.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.begona,
        texto: 'Bien.',
        pausaPrevia: Duration(milliseconds: 500),
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura: 'Pausa.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.begona,
        texto: 'Sellada.',
        pausaPrevia: Duration(milliseconds: 600),
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Salen del Concilio. Maren con la hoja en la mano. '
            'Marina detrás, alcanzándola en el pasillo, en voz baja.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.marina,
        texto: 'Begoña ha sonreído.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'No la vi.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.marina,
        texto: 'Has sonreído tú. Ella también, dos segundos.',
        pausaPrevia: Duration(milliseconds: 500),
      ),
      PlanoCierreAmable(textoBoton: 'IR AL PATIO'),
    ],
  );

  /// 2.4.8 — *"Aprendiz II"*. Patio del Archivo, banco junto al
  /// brocal del pozo. Cierre formal de la Estación 2.4 y del
  /// Arco 2 entero. Isaura aparece detrás de Maren. Las dos se
  /// sientan. Isaura pronuncia "Aprendiz II". Maren pregunta si
  /// el cuaderno de Isaura tiene una pregunta sobre Wamba —
  /// resonancia con la 2.B.1, primera vez que Maren ata el
  /// dispositivo del cuaderno de la mentora a una Brecha
  /// concreta. Isaura responde con tres preguntas; una resuelta,
  /// dos siguen. Cierre con el flotante "APRENDIZ II".
  ///
  /// Doc 08 §2.4.8.
  static const EscenaCinematica aprendizDosLogrado = EscenaCinematica(
    id: '2.4.8',
    titulo: 'Aprendiz II',
    flagDeSalida: 'escena_2_4_8_vista',
    flagsRequeridos: {'escena_2_4_7_vista'},
    ambiente: AmbienteArchivo.patioArchivo,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Patio del Archivo. Banco junto al brocal del pozo. Tarde '
            'fría de finales de febrero. Maren se sienta sola al '
            'principio. Isaura aparece detrás unos minutos después '
            'y se sienta a su lado.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: 'Aprendiz II.',
        pausaPrevia: Duration(milliseconds: 600),
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'No me lo creo.',
        pausaPrevia: Duration(milliseconds: 500),
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: 'Hazte.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura: 'Pausa larga. Las dos miran el patio.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Isaura.',
        pausaPrevia: Duration(milliseconds: 700),
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: '¿Sí?',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: '¿Tu cuaderno tiene una pregunta sobre Wamba?',
        pausaPrevia: Duration(milliseconds: 600),
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Isaura se queda quieta. Diez segundos. Mira al brocal. '
            'No al banco, no a Maren.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: 'Tres preguntas. De hace mucho.',
        pausaPrevia: Duration(milliseconds: 500),
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: '¿Las has resuelto?',
        pausaPrevia: Duration(milliseconds: 600),
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: 'Una. Las otras dos siguen.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 6),
        textoLectura:
            'Maren asiente. Las dos se quedan sentadas. La cámara '
            'se aleja despacio. Tres segundos. Aparece flotante: '
            'APRENDIZ II.',
      ),
      PlanoCierreAmable(textoBoton: 'CERRAR LA ESTACIÓN'),
    ],
  );

  /// **M2.entrega — La entrega del Mosaico M2** (doc 08 §M2, F2-8).
  ///
  /// Maren sube al ático del Archivo con la audio-guía de Pompaelo
  /// terminada en el móvil. Andrés está donde siempre, entre las
  /// cajas del fondo. Maren le entrega el archivo. Andrés se pone
  /// los auriculares y escucha los noventa segundos en silencio.
  /// Cuando termina, le hace una sola observación sobre la
  /// frecuencia con la que Maren ha dicho "no sabemos" y
  /// "probablemente". Reconocimiento por gesto pequeño, igual que
  /// la 1.M1.entrega del Arco 1: pertenecer al oficio se mide en
  /// los silencios del aprendiz.
  ///
  /// **Anclada provisionalmente al cierre de la Estación 2.4**.
  /// Como la pantalla jugable del Mosaico M2 (audio-guía de 90s
  /// con anclajes obligatorios y declaración verbal de niveles de
  /// confianza) todavía no está implementada, el flag
  /// `mosaico_arco_2_entregado` lo activa hoy la 2.4.8 al cerrar.
  /// Cuando entre la pantalla M2, este disparador se mueve al
  /// `_alEntregarMosaicoArco2` del orquestador y la 2.4.8 deja de
  /// activarlo. Cambio trivial, registrado en BLOQUEOS.
  ///
  /// **Sin sustituciones diegéticas**: el diálogo se reproduce
  /// literalmente del doc 08 §M2.
  static const EscenaCinematica entregaDelMosaicoM2 = EscenaCinematica(
    id: 'M2.entrega',
    titulo: 'La entrega del Mosaico M2',
    flagDeSalida: 'escena_m2_entrega_vista',
    flagsRequeridos: {'mosaico_arco_2_entregado'},
    ambiente: AmbienteArchivo.aticoArchivo,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Maren sube al ático del Archivo con el móvil en la '
            'mano. Andrés está donde siempre, entre las cajas del '
            'fondo. Sin levantar la vista, le tiende la palma. '
            'Maren le pasa el archivo de audio.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.andres,
        texto: '¿Audio-guía?',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Sí.'),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Andrés coge el archivo. Lo carga en su portátil. Se '
            'pone los auriculares. Le da al play.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 6),
        textoLectura:
            'Tres minutos en silencio mientras Andrés escucha los '
            'noventa segundos enteros. Maren espera, incómoda, '
            'mirando una caja de carpetas con etiquetas amarillas. '
            'No le pregunta nada.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura:
            'Andrés se quita los auriculares. La mira un segundo. '
            'Tiene esa expresión suya que no es ni de aprobación '
            'ni de rechazo, sólo de cuenta hecha.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.andres,
        texto:
            'Has dicho "no sabemos" tres veces. Y "probablemente" '
            'cuatro.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: '¿Está mal?',
        pausaPrevia: Duration(milliseconds: 700),
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 2),
        textoLectura: 'Andrés sonríe.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.andres,
        texto: 'Está perfecto.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Andrés guarda el archivo en una carpeta del Archivo '
            'que Maren no ve. Le devuelve el móvil. Se da la '
            'vuelta hacia las cajas del fondo. La conversación se '
            'acabó.',
      ),
      PlanoCierreAmable(textoBoton: 'BAJAR DEL ÁTICO'),
    ],
  );

  /// **2.Z.1 — Antonio y Wamba** (doc 08 §2.Z.1, F2-8).
  ///
  /// La noche tras la entrega del Mosaico M2, una semana después
  /// del Concilio dividido. Cocina de casa. Maren y Antonio cenan
  /// solos — Iratxe ha llevado a Naia a un cumpleaños. Cocinan
  /// juntos pasta sencilla. Antonio pregunta como si tal cosa por
  /// la Brecha de Wamba. Maren articula la asimetría documental
  /// del Arco 2 con palabras propias. Antonio le devuelve un
  /// recuerdo: cuando leyó *El Quijote* de adolescente, notó que
  /// los moriscos no aparecen escribiendo, y supo que algo
  /// faltaba en la novela. La frase pedagógica del padre cierra
  /// la cinemática: "los oficios que tienes claros desde el
  /// principio suelen ser los que se acaban antes". Antonio
  /// empieza a decir algo más después y se calla — "Olvídalo.
  /// Sigamos cocinando".
  ///
  /// **Sin sustituciones diegéticas**: el diálogo se reproduce
  /// literalmente del doc 08 §2.Z.1, incluido el silencio final
  /// de Antonio que la 2.Z.2 va a interrogar como pregunta
  /// abierta.
  static const EscenaCinematica antonioYWamba = EscenaCinematica(
    id: '2.Z.1',
    titulo: 'Antonio y Wamba',
    flagDeSalida: 'escena_2_z_1_vista',
    flagsRequeridos: {'escena_m2_entrega_vista'},
    ambiente: AmbienteArchivo.cocinaCasaMaren,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 6),
        textoLectura:
            'Cocina de casa. Maren y Antonio cocinando juntos. '
            'Pasta sencilla. Iratxe ha llevado a Naia a un '
            'cumpleaños — la casa está más callada de lo normal.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.antonio,
        texto: '¿Te dejaron el Wamba?',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Sí.'),
      PlanoDialogo(voz: VozPersonaje.antonio, texto: '¿Qué tal?'),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Difícil.',
      ),
      PlanoDialogo(voz: VozPersonaje.antonio, texto: '¿Cómo?'),
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura:
            'Pausa. Maren parte una cebolla. Tres golpes secos '
            'sobre la tabla.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto:
            'Las fuentes son todas de un lado. Visigodos hablando '
            'de vascones. Los vascones no escriben.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 2),
        textoLectura: 'Antonio remueve la salsa.',
      ),
      PlanoDialogo(voz: VozPersonaje.antonio, texto: 'Mm.'),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Karim me dijo que el silencio es un dato.',
      ),
      PlanoDialogo(voz: VozPersonaje.antonio, texto: 'Sí.'),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: '¿Tú lo habías pensado así alguna vez?',
        pausaPrevia: Duration(milliseconds: 600),
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Antonio se gira. La mira. Tres segundos enteros sin '
            'decir nada.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.antonio,
        texto: 'Sí. Pero no con esas palabras.',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: '¿Cuándo?'),
      PlanoDialogo(
        voz: VozPersonaje.antonio,
        texto:
            'Cuando leí El Quijote de adolescente. Cervantes habla '
            'mucho de moriscos. Pero los moriscos no aparecen '
            'escribiendo. Pensé entonces que algo faltaba en la '
            'novela. No sabía cómo llamarlo.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Es lo mismo.',
        pausaPrevia: Duration(milliseconds: 800),
      ),
      PlanoDialogo(
        voz: VozPersonaje.antonio,
        texto: 'Es lo mismo.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Maren se queda quieta. La cebolla cortada. El '
            'cuchillo en la mano.',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Aita.'),
      PlanoDialogo(voz: VozPersonaje.antonio, texto: '¿Sí?'),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'No tengo claro qué tipo de oficio he elegido.',
        pausaPrevia: Duration(milliseconds: 1000),
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Pausa muy larga. Antonio termina de remover la '
            'salsa. Apaga el fuego. Se gira hacia Maren.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.antonio,
        texto: 'Eso es buena señal.',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: '¿Por qué?'),
      PlanoDialogo(
        voz: VozPersonaje.antonio,
        texto:
            'Porque los oficios que tienes claros desde el '
            'principio suelen ser los que se acaban antes.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Antonio sigue removiendo. Maren sigue cortando. La '
            'salsa va espesando.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.antonio,
        texto: 'Maren.',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: '¿Sí?'),
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura:
            'Antonio abre la boca. La cierra. La abre otra vez.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.antonio,
        texto: 'Mmm. Olvídalo. Sigamos cocinando.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Maren no insiste. Cenan. Conversación normal después. '
            'Algo de Naia, algo del trabajo de él, nada importante.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Pero antes de que Antonio dijera "olvídalo", Maren ha '
            'hecho algo que él no ha visto.',
      ),
      PlanoCierreAmable(textoBoton: 'SUBIR AL CUARTO'),
    ],
  );

  /// **2.Z.2 — La grabación. Cierre del Arco 2** (doc 08 §2.Z.2,
  /// F2-8).
  ///
  /// Continúa la misma noche. Cuarto de Maren. El móvil enchufado,
  /// auriculares puestos, la interfaz del Cuaderno abierta. Maren
  /// le da al play y se oye su voz y la de su padre con audio
  /// limpio: ha grabado la conversación entera con el móvil en el
  /// bolsillo del delantal de cocina, sin decirle a su padre,
  /// hace una hora y media. Escucha completa la grabación.
  /// Cuando termina, escribe en el Cuaderno tres pensamientos
  /// que la cinemática reproduce literales: que mañana se lo
  /// cuenta, que ha oído su voz hablando con su padre como con un
  /// par por primera vez, que quiere recordar la frase de los
  /// oficios que se acaban antes, y que el "olvídalo" lo apunta
  /// como pregunta abierta — *como Isaura*. Cierra el cuaderno,
  /// apaga la luz. Aparece flotante: ARCO 2 — CERRADO. Música
  /// breve. Una línea de texto: *Continuará en Arco 3 — La forja
  /// del reino*.
  ///
  /// Pedagógicamente clave para cerrar el Arco 2: la Cronista
  /// genera, sin pedirle a nadie, un acto de oficio sobre su
  /// propia vida — graba a su padre como fuente, decide
  /// guardarla con honestidad declarada (mañana se lo cuenta),
  /// y apunta el silencio del padre como pregunta abierta usando
  /// el modelo de Isaura. Tres movimientos del oficio aplicados
  /// por iniciativa propia. Cierre simétrico con la 1.Z donde la
  /// Cronista narraba el arco; aquí la Cronista *practica* el
  /// arco sobre material vivo.
  ///
  /// **Sin sustituciones diegéticas**: el diálogo se reproduce
  /// literalmente del doc 08 §2.Z.2.
  static const EscenaCinematica laGrabacion = EscenaCinematica(
    id: '2.Z.2',
    titulo: 'La grabación',
    flagDeSalida: 'escena_2_z_2_vista',
    flagsRequeridos: {'escena_2_z_1_vista'},
    ambiente: AmbienteArchivo.cuartoCasaMaren,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Cuarto de Maren. El móvil enchufado en la mesa. '
            'Auriculares puestos. La interfaz del Cuaderno abierta '
            'en el portátil.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Maren le da al play. Se oye su voz y la de su padre. '
            'Audio limpio.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Maren grabó la conversación entera con el móvil en '
            'el bolsillo del delantal de cocina, sin decirle a su '
            'padre, hace una hora y media.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 6),
        textoLectura:
            'Escucha completa la conversación. No interrumpe. No '
            'rebobina. Está sentada con las manos en el regazo y '
            'los ojos cerrados.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura:
            'Cuando termina, abre los ojos. Se quita los '
            'auriculares. Empieza a escribir en el Cuaderno.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto:
            'He grabado a mi padre sin decírselo. No es bonito '
            'hacerlo. Mañana se lo cuento. No puedo borrarla — la '
            'quiero para mí.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto:
            'La he escuchado entera. He oído mi voz hablando con '
            'mi padre como con un par. Eso no había pasado antes. '
            'O igual sí, pero no lo había notado.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto:
            'Mi padre dijo "los oficios que tienes claros desde el '
            'principio se acaban antes". No sé si tiene razón. '
            'Pero quiero recordar la frase.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto:
            'Y dijo "Maren" y después "olvídalo". Eso es lo que '
            'más me ha llamado la atención. ¿Qué iba a decirme y '
            'se calló?',
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto: 'Eso lo apunto como pregunta abierta. Como Isaura.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Maren cierra el cuaderno. Apaga la luz. Negro.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Aparece flotante: ARCO 2 — CERRADO.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Música breve. Negro extendido. Sólo una línea de '
            'texto: Continuará en Arco 3 — La forja del reino.',
      ),
      PlanoCierreAmable(textoBoton: 'CERRAR EL ARCO'),
    ],
  );
}
