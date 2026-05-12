import 'package:nuevo_ser_core/nuevo_ser_core.dart';

import 'ambiente_archivo.dart';
import 'voz_personaje.dart';

/// Catálogo de escenas cinemáticas del Arco 4 — *Una corte brillante
/// en su crepúsculo* (doc 10). Cierre del MVP narrativo. ~5-6 semanas
/// de curso escolar (junio). Recorrido: de Aprendiz III a Cronista.
///
/// **Tono del arco** (doc 10 cabecera): melancolía digna. Sin
/// fanfarria. Sin cierre redondo. Apertura hacia el después. La
/// transmisión está hecha en escenas pequeñas a lo largo del juego,
/// no en un momento culminante.
///
/// **Estructura del arco**:
/// - 4.0.1 *Apertura del arco* — Isaura anuncia Olite + las tres
///   comunidades + lectura de cartas de Catalina + graduación.
/// - **Estación 4.1 *Olite y la corte de Carlos III el Noble***
///   (4.1.1–4.1.7): la primera Brecha donde Maren elige ella el
///   sujeto. Joana de Roncal, doncella de cámara entre 1402 y 1412.
///   Brecha jugable `brecha41`.
/// - **4.A *La antesala de 1512*** (4.A.1 + 4.A.2): Día de Archivo
///   grande. Cartas de Catalina de Foix. Isaura: *"Esto es para
///   cuando seas mayor."* — el MVP no entra a 1512 en su versión
///   v0.1.
/// - **Estación 4.B *Las tres comunidades*** (4.B.1–4.B.6): vida
///   cotidiana mixta en Estella tardomedieval. Pleito de 1394 entre
///   Pedro Garaicoa (cristiano) y Yusuf al-Tudelí (mudéjar). Brecha
///   jugable `brecha4B`.
/// - **Días de Archivo individuales** (4.C *Antonio termina la
///   frase* + 4.D *Naia con su cuaderno* + 4.E *Eider en la cancha*
///   + 4.F *El cuaderno de Isaura*): material narrativo personal
///   intercalado entre Estaciones.
/// - **Día de Archivo grande 4.G** (4.G.1 + 4.G.2 + 4.G.3): segundo
///   encuentro con Tasio en Tudela, oferta concreta de Resolutiva,
///   Maren queda en suspenso.
/// - **M4 Proyecto integrador**: Mosaico final, doble cartela —
///   pieza del Arco 1 + pieza del Arco 2.
/// - **4.H Graduación** (4.H.1 + 4.H.2): víspera familiar + ceremonia
///   en el patio del Archivo. Maren obtiene el cuaderno blanco de
///   Cronista y pronuncia el voto del oficio.
/// - **4.Z El patio vacío**: Maren sola en el patio tras la
///   ceremonia. Cierra el cuaderno de Aprendiz I y abre el cuaderno
///   de Cronista. Cierre formal del MVP entero.
///
/// **PENDIENTE DE CONSOLIDACIÓN COMITÉ — REFORMULACIÓN-1512**: el
/// final del Arco 4 según el doc 10 v0.1 (4.A.2 *"esto es para
/// cuando seas mayor"* + 4.H + 4.Z) está sujeto a **reformulación
/// validada por el comité provisional** en sesión del 29 abril 2026
/// (`coleccion-nuevo-ser-paquete-documental-v0.3/cambios-pendientes-v0.3/escenas-1200-y-final-arco-4.md`):
/// el comité propone que el MVP SÍ entre a 1512 con tres Estaciones
/// nuevas (4.4 *La conquista*, 4.5 *La guerra*, 4.6 *Amaiur*) y un
/// Concilio de graduación distinto, además de añadir una Estación
/// 3.X *La frontera que se mueve* (1199-1200) al Arco 3. Hasta que
/// el comité formal ratifique y se consolide al doc 10 v0.2, el
/// código sigue el doc 10 v0.1. Registrado en
/// `BLOQUEOS-PENDIENTES.md`.
class EscenasArco4 {
  EscenasArco4._();

  /// Lista ordenada de escenas del Arco 4. La 4.0.1 requiere
  /// `arco_3_cerrado_por_la_cronista` (que la 3.Z activa). La 4.1.5
  /// y la 4.B.4 cinemáticas (puestas en limpio narrativas) requieren
  /// los flags de cierre de la Brecha jugable correspondiente
  /// (`brecha_4_1_completada` / `brecha_4_b_completada`) — el
  /// orquestador las dispara tras pasar por la pantalla jugable.
  static const List<EscenaCinematica> todas = [
    aperturaDelArco4,
    caminoAOlite,
    elPalacioOlite,
    joanaDeRoncal,
    lasTrazasDeUnaVida,
    reconstruccionJoanaDeRoncal,
    concilioJoanaDeRoncal,
    elNombreVuelve,
    cartasDeCatalina,
    paraCuandoSeasMayor,
    losPactosPequenos,
    karimSobreLosResponsa,
    unaBrechaDeVecinos,
    reconstruccionTresComunidades,
    concilioTresComunidades,
    cierreTresComunidades,
    antonioTerminaLaFrase,
    naiaConSuCuaderno,
    eiderEnLaCancha,
    elCuadernoDeIsaura,
    caminoATudelaUltima,
    elSegundoEncuentroConTasio,
    elSilencioQueVuelve,
    entregaDelMosaicoM4,
    laVispera,
    laCeremonia,
    elPatioVacio,
  ];

  /// Flags institucionales que el orquestador activa al cerrar una
  /// escena del Arco 4. Mismo patrón que en Arcos 1-3.
  static const Map<String, Set<String>> flagsDeCierrePorEscena = {
    'escena_4_0_1_vista': {
      'arco_4_iniciado',
      'final_arc',
      'carta_tasio_recibida',
    },
    'escena_4_1_1_vista': {
      'camino_olite_iniciado',
    },
    'escena_4_1_2_vista': {
      'palacio_olite_visitado',
    },
    'escena_4_1_3_vista': {
      'joana_de_roncal_elegida',
    },
    'escena_4_1_4_vista': {
      'trazas_joana_reconstruidas',
    },
    'escena_4_1_5_vista': {
      'reconstruccion_4_1_producida',
    },
    'escena_4_1_6_vista': {
      'concilio_4_1_cerrado',
    },
    'escena_4_1_7_vista': {
      'arco_4_estacion_1_cerrada',
    },
    'escena_4_a_1_vista': {
      'cartas_catalina_leidas',
    },
    'escena_4_a_2_vista': {
      'antesala_1512_aceptada',
    },
    'escena_4_b_1_vista': {
      'pactos_pequenos_aprendidos',
    },
    'escena_4_b_2_vista': {
      'responsa_rabinicos_estudiados',
    },
    'escena_4_b_3_vista': {
      'pleito_pared_medianera_estudiado',
    },
    'escena_4_b_4_vista': {
      'reconstruccion_4_b_producida',
    },
    'escena_4_b_5_vista': {
      'concilio_4_b_cerrado',
    },
    'escena_4_b_6_vista': {
      'arco_4_estacion_2_cerrada',
    },
    'escena_4_c_vista': {
      'antonio_termino_la_frase',
    },
    'escena_4_d_vista': {
      'naia_cuaderno_propio',
    },
    'escena_4_e_vista': {
      'eider_partido_visto',
    },
    'escena_4_f_vista': {
      'cuaderno_isaura_revelado',
    },
    'escena_4_g_1_vista': {
      'tren_a_tudela_iniciado',
    },
    'escena_4_g_2_vista': {
      'oferta_resolutiva_recibida',
      'met_tasio_segundo',
    },
    'escena_4_g_3_vista': {
      'silencio_de_maren_segundo',
    },
    'escena_m_4_entrega_vista': {
      'mosaico_arco_4_validado_por_andres',
    },
    'escena_4_h_1_vista': {
      'vispera_graduacion_vista',
    },
    'escena_4_h_2_vista': {
      'graduada_cronista',
      'mvp_climax',
    },
    'escena_4_z_vista': {
      'mvp_completo',
      'arco_4_cerrado_por_la_cronista',
    },
  };

  /// 4.0.1 — *Apertura del arco*. Primera semana de junio. Despacho
  /// de Isaura, ventana norte. Isaura anuncia el contrato del arco:
  /// Olite con Aitor (Brecha donde Maren elige el sujeto), tres
  /// comunidades en Estella con Karim, lectura de cartas de Catalina
  /// de Foix sobre 1512 — *"para que sepas qué hay; para que entiendas
  /// lo que decides cuando decides no entrar todavía"*. Graduación
  /// última semana de junio en el patio. Le pasa una carta cerrada
  /// de Tasio. *"Cuando lo leas, decides tú qué haces."* Doc 10 §4.0.1.
  static const EscenaCinematica aperturaDelArco4 = EscenaCinematica(
    id: '4.0.1',
    titulo: 'Apertura del arco',
    flagDeSalida: 'escena_4_0_1_vista',
    flagsRequeridos: {'arco_3_cerrado_por_la_cronista'},
    ambiente: AmbienteArchivo.despachoIsaura,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Despacho de Isaura, primera semana de junio. Isaura no '
            'está sentada — está mirando por la ventana norte. Maren '
            'entra.',
      ),
      PlanoDialogo(voz: VozPersonaje.isaura, texto: 'Aprendiz III.'),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Sí.'),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto:
            'Este arco son seis semanas. Es el más corto. Y es el '
            'último antes de la graduación.',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Si me gradúo.'),
      PlanoAmbiente(
        duracion: Duration(seconds: 2),
        textoLectura: 'Isaura se gira. Sonríe pequeñísimo.',
      ),
      PlanoDialogo(voz: VozPersonaje.isaura, texto: 'Si te gradúas.'),
      PlanoAmbiente(duracion: Duration(milliseconds: 1500)),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto:
            'Olite. Vas con Aitor. Carlos III el Noble. Su corte. Una '
            'persona concreta, no el rey. Tú eliges qué persona.',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: '¿Yo elijo?'),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto:
            'Sí. Es tu Brecha de Aprendiz III avanzada. La primera '
            'donde tú determinas el sujeto.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Vale.',
        pausaPrevia: Duration(milliseconds: 1200),
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto:
            'Después una Brecha sobre las tres comunidades en Estella. '
            'Con Karim.',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: '¿Otra de Estella?'),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto:
            'Estella tiene mucho material. La anterior fue ciudad-paso. '
            'Esta es vida cotidiana mixta. Distinta.',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Vale.'),
      PlanoAmbiente(duracion: Duration(milliseconds: 1500)),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto:
            'Y al final del arco hay correspondencia que vas a leer, '
            'pero no como Brecha.',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: '¿Qué correspondencia?'),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto:
            'Cartas conservadas de Catalina de Foix. Algunas a Juan III '
            'de Albret. Una al embajador en Castilla. Tres relacionadas '
            'con Fernando el Católico.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura: 'Maren entiende. Pausa larga.',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'No vamos a tocar 1512.'),
      PlanoDialogo(voz: VozPersonaje.isaura, texto: 'No.'),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: '¿Por qué leemos las cartas entonces?',
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto:
            'Para que sepas qué hay. Para que entiendas lo que decides '
            'cuando decides no entrar todavía.',
      ),
      PlanoAmbiente(duracion: Duration(milliseconds: 1500)),
      PlanoDialogo(voz: VozPersonaje.maren, texto: '¿Y la graduación?'),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: 'Última semana de junio. En el patio. Pequeña.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Vale.',
        pausaPrevia: Duration(milliseconds: 1200),
      ),
      PlanoDialogo(voz: VozPersonaje.isaura, texto: 'Ah. Una cosa más.'),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Sí.'),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto:
            'Tasio te ha escrito. Llegó al Archivo ayer. Te lo paso.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Le pasa un sobre cerrado. Letra de Tasio en el sobre. '
            'Maren lo coge. Lo guarda en la mochila sin abrir. Isaura '
            'no comenta.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: 'Cuando lo leas, decides tú qué haces.',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Vale.'),
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Maren sale. La cámara se queda con Isaura. Se sienta. '
            'Mira por la ventana norte. La sonrisa pequeñísima vuelve '
            'durante un segundo.',
      ),
    ],
  );

  /// 4.1.1 — *Camino a Olite*. Carretera de Iruña a Olite, una hora,
  /// junio temprano. El paisaje cambia: el centro de Nafarroa hacia
  /// la Ribera, campos amarillos de cereal madurando. Aitor le da
  /// la pista de hermano mayor: *"No elijas a alguien famoso. Elige
  /// a alguien que te llame por algún detalle. Una persona concreta
  /// que aparece y no se explica del todo. Esa es tu Brecha."*
  /// Doc 10 §4.1.1.
  static const EscenaCinematica caminoAOlite = EscenaCinematica(
    id: '4.1.1',
    titulo: 'Camino a Olite',
    flagDeSalida: 'escena_4_1_1_vista',
    flagsRequeridos: {'escena_4_0_1_vista'},
    ambiente: AmbienteArchivo.cocheAitor,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Carretera de Iruña a Olite, una hora. Junio temprano. El '
            'paisaje cambia: el centro de Nafarroa hacia la Ribera, '
            'campos amarillos de cereal madurando.',
      ),
      PlanoDialogo(voz: VozPersonaje.aitor, texto: '¿Has elegido a tu persona?'),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'No todavía.'),
      PlanoDialogo(voz: VozPersonaje.aitor, texto: '¿Cómo vas a elegir?'),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto:
            'Voy a mirar los archivos del palacio primero. Cuentas, '
            'registros, cartas. Ver quién aparece y desaparece.',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
      PlanoDialogo(voz: VozPersonaje.aitor, texto: 'Bien.'),
      PlanoAmbiente(duracion: Duration(milliseconds: 1500)),
      PlanoDialogo(
        voz: VozPersonaje.aitor,
        texto: 'Una pista de hermano mayor.',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Vale.'),
      PlanoDialogo(
        voz: VozPersonaje.aitor,
        texto:
            'No elijas a alguien famoso. Elige a alguien que te llame '
            'por algún detalle. Una persona concreta que aparece y no '
            'se explica del todo. Esa es tu Brecha.',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Vale.'),
    ],
  );

  /// 4.1.2 — *El palacio*. Llegan a Olite. La conservadora del palacio
  /// los recibe y abre el acceso a los registros de cuentas entre
  /// 1390 y 1425. Doc 10 §4.1.2.
  static const EscenaCinematica elPalacioOlite = EscenaCinematica(
    id: '4.1.2',
    titulo: 'El palacio',
    flagDeSalida: 'escena_4_1_2_vista',
    flagsRequeridos: {'escena_4_1_1_vista'},
    ambiente: AmbienteArchivo.palacioOlite,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Olite. La villa pequeña. El palacio es enorme — quince '
            'torres asimétricas, almenas, jardines colgantes '
            'restaurados. Junio cálido. Banderines flameando.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura:
            'La conservadora los recibe. Visita técnica al archivo del '
            'palacio.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.conservadoraPalacio,
        texto:
            'Bienvenidos. Aitor ya conoce esto. Tú eres Maren — Karim '
            'me habló.',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Hola.'),
      PlanoDialogo(
        voz: VozPersonaje.conservadoraPalacio,
        texto:
            'Tu mentor pidió que tuvieras acceso libre a los registros '
            'de cuentas del palacio entre 1390 y 1425. Está reservado '
            'para vosotras esta semana.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Caminan por el palacio hasta la sala de cuentas — una '
            'habitación lateral con vitrinas, mesas de trabajo, copias '
            'digitales de los originales (los originales están en el '
            'Archivo Real de Navarra).',
      ),
      PlanoDialogo(
        voz: VozPersonaje.conservadoraPalacio,
        texto:
            'Tengo que dejaros. Si necesitáis algo, pregunten en '
            'recepción. Aitor sabe.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura: 'Sale. Maren y Aitor se quedan solos.',
      ),
      PlanoDialogo(voz: VozPersonaje.aitor, texto: 'A ver quién aparece.'),
    ],
  );

  /// 4.1.3 — *Joana de Roncal*. Sala de cuentas. Maren lee registros
  /// del palacio. Identifica a una doncella de cámara — Joana de
  /// Roncal — que aparece entre 1402 y 1412 al servicio de la reina
  /// Leonor y la infanta Blanca, y desaparece en 1412. Aitor: *"No
  /// la conozco. Eso es buena señal."* Doc 10 §4.1.3.
  static const EscenaCinematica joanaDeRoncal = EscenaCinematica(
    id: '4.1.3',
    titulo: 'Joana de Roncal',
    flagDeSalida: 'escena_4_1_3_vista',
    flagsRequeridos: {'escena_4_1_2_vista'},
    ambiente: AmbienteArchivo.salaCuentasPalacioOlite,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Sala de cuentas, palacio de Olite. Maren empieza a leer. '
            'Cuentas de palacio: pagos a personal, compras de '
            'alimento, gastos en vestidos, intercambios diplomáticos. '
            'Es trabajo lento.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto:
            'Aparece Carlos III en cada página, claro. Aparece Leonor '
            'su esposa, en menor medida. Aparecen las hijas — Juana, '
            'María, Beatriz, Blanca. Cada una con sus damas, sus '
            'cuentas, sus regalos.',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto:
            'Aparece también gente que no conozco: cocineros, '
            'cazadores, escribas, médicos, soldados. La mayoría se '
            'nombran una vez y desaparecen.',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto: 'Hay una que aparece muchas veces.',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Maren se concentra en una persona. Una "doncella de '
            'cámara" que aparece en cuentas durante diez años — desde '
            '1402 hasta 1412 — al servicio primero de Leonor, después '
            'de la infanta Blanca.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Joana de Roncal.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Maren va apuntando todas las menciones. Joana de Roncal '
            'recibe pagos por servicios, recibe regalos en fechas '
            'señaladas, viaja con la corte a Tudela y a Estella, '
            'aparece como testigo en una compra de tela en 1408. '
            'Después, en 1412, deja de aparecer en los registros.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto:
            'Joana de Roncal entra al palacio en 1402 con dieciocho '
            'años aproximados. Sale en 1412, posiblemente alrededor de '
            'los veintiocho.',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto:
            'Diez años de palacio. Después nada. Apellido del valle de '
            'Roncal — un valle del Pirineo navarro. Probablemente '
            'entró por familia hidalga modesta de allí.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto: 'Aitor tenía razón. Esta es mi Brecha.',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
      PlanoAmbiente(duracion: Duration(milliseconds: 1500)),
      PlanoDialogo(voz: VozPersonaje.aitor, texto: '¿La tienes?'),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Sí.'),
      PlanoDialogo(voz: VozPersonaje.aitor, texto: '¿Quién?'),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Joana de Roncal. Doncella de cámara entre 1402 y 1412.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.aitor,
        texto: 'No la conozco. Eso es buena señal.',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
    ],
  );

  /// 4.1.4 — *Las trazas de una vida*. Mesa de Trabajo, varias
  /// jornadas. Maren reconstruye lo que se puede saber de Joana de
  /// Roncal: siete menciones documentadas + una mención posible de
  /// "limosnas a la familia de Roncal por la pérdida de su hija" en
  /// 1412. Doc 10 §4.1.4.
  static const EscenaCinematica lasTrazasDeUnaVida = EscenaCinematica(
    id: '4.1.4',
    titulo: 'Las trazas de una vida',
    flagDeSalida: 'escena_4_1_4_vista',
    flagsRequeridos: {'escena_4_1_3_vista'},
    ambiente: AmbienteArchivo.mesaTrabajoArchivo,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Mesa de Trabajo, varias jornadas. Maren reconstruye lo '
            'que se puede saber de Joana de Roncal con los registros '
            'que ha ido recogiendo en Olite y consultando en el '
            'Archivo de Iruña.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            '1402: pago a "Pedro de Roncal" por gastos de viaje de su '
            'hermana Joana al palacio. 1402-1412: pagos sucesivos a '
            'Joana por servicios de doncella de cámara, primero de la '
            'reina, después de la infanta Blanca. 1405: viaje de la '
            'corte a Tudela, Joana acompañante. 1407: carta breve al '
            'chambelán solicitando autorización para que Joana viaje '
            'a su valle por enfermedad de su madre.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            '1408: pago de telas para un vestido especial de Joana — '
            'interpretación posible: matrimonio inminente. Pero sigue '
            'apareciendo soltera (sin mención de marido) hasta 1412. '
            '1412: deja de aparecer.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Maren busca menciones posteriores. Hay una sola: un pago '
            'de "limosnas a la familia de Roncal por la pérdida de su '
            'hija" en 1412, sin más detalles. Podría ser Joana, '
            'podría ser una hermana.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto:
            'Joana entró al palacio joven y soltera. Permaneció diez '
            'años sin casarse, lo cual es atípico para mujer de su '
            'clase y edad — la mayoría se casaba antes de los '
            'veinticinco.',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto:
            'Hay un vestido especial en 1408 que podría sugerir '
            'compromiso. Pero el matrimonio no aparece. Sigue siendo '
            '"doncella" en los registros.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto:
            'Y desaparece en 1412 — quizá murió, quizá se retiró, '
            'quizá pasó a otro servicio del que no tenemos registro.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto:
            'Hay una mención de "pérdida de hija" en limosnas a su '
            'familia ese mismo año. Podría ser ella.',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto:
            'Diez años en palacio. Una mujer joven que vio crecer a '
            'las infantas. Que viajó con la corte. Que pudo haber '
            'estado a punto de casarse y no se casó. Que probablemente '
            'murió antes de los treinta.',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto: 'Eso es lo que se puede saber.',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
    ],
  );

  /// 4.1.5 — *Reconstrucción* (puesta en limpio narrativa). Tras la
  /// Brecha 4.1 jugable, Maren cierra la fase con la voz del Cuaderno
  /// articulando el sentido de su reconstrucción. Doc 10 §4.1.5.
  static const EscenaCinematica reconstruccionJoanaDeRoncal = EscenaCinematica(
    id: '4.1.5',
    titulo: 'Reconstrucción',
    flagDeSalida: 'escena_4_1_5_vista',
    flagsRequeridos: {'brecha_4_1_completada'},
    ambiente: AmbienteArchivo.mesaTrabajoArchivo,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Mesa de Trabajo. Maren ha producido las ocho afirmaciones '
            'sobre Joana de Roncal. Cierra el cuaderno donde ha '
            'apuntado las menciones.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto:
            'Joana de Roncal vivió en el palacio que sigue en pie hoy. '
            'Probablemente subió las mismas escaleras que yo subí. '
            'Probablemente miró por las mismas ventanas. Probablemente '
            'vio nieve sobre los mismos jardines.',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto:
            'Lo que sabemos de ella es poco. Lo que no sabemos es casi '
            'todo.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto: 'Pero lo poco que sabemos es real.',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
    ],
  );

  /// 4.1.6 — *Concilio*. Salón del Concilio, días después. Aitor
  /// revisor + Karim + Joana Sasiain. Maren defiende la afirmación 7
  /// (Disputado el vestido especial) y la 8 (Probable la
  /// identificación con la "pérdida de hija"). Sellada. Doc 10 §4.1.6.
  static const EscenaCinematica concilioJoanaDeRoncal = EscenaCinematica(
    id: '4.1.6',
    titulo: 'Concilio',
    flagDeSalida: 'escena_4_1_6_vista',
    flagsRequeridos: {'escena_4_1_5_vista'},
    ambiente: AmbienteArchivo.salonConcilio,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Salón del Concilio, días después. Aitor revisor, Karim, '
            'Joana Sasiain, Maren. Maren presenta. La Brecha es '
            'íntima — no hay grandes preguntas metodológicas. Pero '
            'tiene una virtud que el Concilio reconoce: es ejercicio '
            'puro del oficio aplicado a una vida pequeña documentada.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.joana,
        texto:
            'Tu afirmación siete — el gasto de tela de 1408. La '
            'declaras Disputado. ¿Qué te haría declararla Probable '
            'hacia matrimonio?',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto:
            'Una mención posterior de Joana como casada o como dotada. '
            'No la hay.',
        pausaPrevia: Duration(milliseconds: 1200),
      ),
      PlanoDialogo(voz: VozPersonaje.joana, texto: '¿Y hacia ascenso de servicio?'),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto:
            'Una mención de cambio de cargo. Tampoco la hay. Sigue '
            'como doncella.',
      ),
      PlanoDialogo(voz: VozPersonaje.joana, texto: 'Disputado correcto.'),
      PlanoDialogo(
        voz: VozPersonaje.karim,
        texto:
            'Tu afirmación ocho — la "pérdida de hija" en 1412. ¿Por '
            'qué Probable y no Disputado?',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto:
            'Porque la coincidencia temporal y la condición de "hija" '
            'sin más identificación encajan con Joana — única hija de '
            'la familia que sirviera en la corte en ese momento, según '
            'las fuentes que tengo. Pero no es Sólido porque la '
            'mención no es nominativa.',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
      PlanoDialogo(voz: VozPersonaje.karim, texto: 'Probable bien defendido.'),
      PlanoAmbiente(duracion: Duration(milliseconds: 1500)),
      PlanoDialogo(voz: VozPersonaje.aitor, texto: 'Sellada.'),
    ],
  );

  /// 4.1.7 — *El nombre vuelve*. Esa noche, habitación de Maren.
  /// Voz del Cuaderno articulando el cierre íntimo de la Estación:
  /// *"Hoy he escrito su nombre en mi reconstrucción. Es la primera
  /// vez que su nombre aparece junto desde hace muchos años."*
  /// Doc 10 §4.1.7.
  static const EscenaCinematica elNombreVuelve = EscenaCinematica(
    id: '4.1.7',
    titulo: 'El nombre vuelve',
    flagDeSalida: 'escena_4_1_7_vista',
    flagsRequeridos: {'escena_4_1_6_vista'},
    ambiente: AmbienteArchivo.cuartoCasaMaren,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Habitación de Maren, esa noche. La luz de mesilla. El '
            'cuaderno abierto.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto:
            'Joana de Roncal. Hace seiscientos años. Subió las '
            'escaleras del palacio de Olite. Vio crecer a la infanta '
            'Blanca. Probablemente murió joven.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto:
            'Hoy he escrito su nombre en mi reconstrucción. Es la '
            'primera vez que su nombre aparece junto desde hace '
            'muchos años.',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto: 'Eso es algo. No es mucho. Pero es algo.',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
    ],
  );

  /// 4.A.1 — *Cartas de Catalina*. Día de Archivo grande, ~10 días
  /// después de la Estación 4.1. Biblioteca del Archivo. Maren lee
  /// cinco cartas conservadas de Catalina de Foix sobre la antesala
  /// de 1512 (1503-1512). NO produce reconstrucción — esto es
  /// lectura, no Brecha. Voz del Cuaderno: *"Catalina sabía que algo
  /// venía. Lo escribió a su madre con miedo concreto."* Doc 10 §4.A.1.
  static const EscenaCinematica cartasDeCatalina = EscenaCinematica(
    id: '4.A.1',
    titulo: 'Cartas de Catalina',
    flagDeSalida: 'escena_4_a_1_vista',
    flagsRequeridos: {'escena_4_1_7_vista'},
    ambiente: AmbienteArchivo.bibliotecaArchivo,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Biblioteca del Archivo, primera planta. Maren se sienta '
            'a leer la correspondencia que Isaura le ha preparado. '
            'Cinco cartas conservadas de Catalina de Foix.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Catalina a Juan III de Albret, 1503: tono familiar, '
            'asuntos domésticos del reino, mención de cordialidad con '
            'Castilla.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Catalina al embajador en Castilla, 1508: tono más tenso, '
            'instrucciones de prudencia, referencia a "las pretensiones '
            'del rey católico".',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Juan III a Catalina, 1510: noticias de Francia, alianza '
            'con Luis XII francés, preocupación creciente.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Catalina a su madre Madeleine de Francia, 1511: tono '
            'íntimo, miedo expresado.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto:
            'Si Fernando entra en Pamplona, el reino se acaba.',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Despacho del consejo real de Pamplona, marzo de 1512: '
            'discusión de reposicionamiento militar, sin mención '
            'todavía de movimientos castellanos inmediatos. Maren lee. '
            'La interfaz le permite anotar pero no producir '
            'reconstrucción — esto es lectura, no Brecha.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto:
            'Catalina sabía que algo venía. Lo escribió a su madre con '
            'miedo concreto.',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto:
            'Tres meses después de la carta a su madre, Fernando ocupó '
            'Pamplona.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto:
            'Lo que sigue — la conquista, la división con la Baja '
            'Navarra, los cien años de guerra y resistencia — está en '
            'la siguiente capa.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto: 'Una capa que no me toca.',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
    ],
  );

  /// 4.A.2 — *"Esto es para cuando seas mayor"*. Continúa esa tarde,
  /// despacho de Isaura. Maren articula que sabían lo que venía. Le
  /// pregunta a Isaura si esto es Brecha grande. Isaura: *"Es Brecha
  /// enorme. Pero no para hoy."* / *"Para trabajar 1512 con honestidad
  /// hace falta haber trabajado primero todo lo anterior."* Y la
  /// lección clave del oficio: *"El oficio es relevo. No es
  /// protagonismo."* Doc 10 §4.A.2.
  ///
  /// **PENDIENTE REFORMULACIÓN-1512**: el comité provisional propone
  /// que el MVP SÍ entre a 1512 con tres Estaciones nuevas (4.4 La
  /// conquista, 4.5 La guerra, 4.6 Amaiur). Esta cinemática y todo
  /// el final del Arco 4 quedan **provisionalmente** según doc 10
  /// v0.1 hasta consolidación. Registrado en BLOQUEOS-PENDIENTES.md
  /// bajo REFORMULACION-1512.
  static const EscenaCinematica paraCuandoSeasMayor = EscenaCinematica(
    id: '4.A.2',
    titulo: 'Esto es para cuando seas mayor',
    flagDeSalida: 'escena_4_a_2_vista',
    flagsRequeridos: {'escena_4_a_1_vista'},
    ambiente: AmbienteArchivo.despachoIsaura,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Despacho de Isaura, esa tarde. Maren entra. Lleva sus '
            'notas de las cartas. Isaura está revisando otra cosa. '
            'Levanta la vista cuando entra.',
      ),
      PlanoDialogo(voz: VozPersonaje.isaura, texto: '¿Las has leído?'),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Sí.'),
      PlanoDialogo(voz: VozPersonaje.isaura, texto: '¿Qué tienes?'),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto:
            'Que sabían lo que venía. No fueron sorprendidos.',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 2),
        textoLectura: 'Isaura asiente.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto:
            'Y que la carta de Catalina a su madre está cargada de algo '
            'que no es sólo política.',
      ),
      PlanoDialogo(voz: VozPersonaje.isaura, texto: '¿Qué es?'),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto:
            'Miedo personal. Conciencia de que pierden no sólo el '
            'reino — pierden el mundo en el que vivían.',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Esto es Brecha grande, ¿verdad?',
      ),
      PlanoDialogo(voz: VozPersonaje.isaura, texto: 'Es Brecha enorme. Pero no para hoy.'),
      PlanoDialogo(voz: VozPersonaje.maren, texto: '¿Por qué no?'),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto:
            'Porque para trabajar 1512 con honestidad hace falta haber '
            'trabajado primero todo lo anterior. Has trabajado el '
            'reino formándose, el reino pleno, el reino tardío. Lo que '
            'sigue — la pérdida — exige perspectiva que sólo da haber '
            'trabajado los siglos previos.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Esto es para cuando sea mayor, ¿verdad?',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: 'Esto es para cuando seas mayor.',
      ),
      PlanoAmbiente(duracion: Duration(seconds: 3)),
      PlanoDialogo(voz: VozPersonaje.maren, texto: '¿Cuánto?'),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto:
            'Diez años. Quince. No tengo apuro contigo. Lo importante '
            'es que sabes que existe y sabes por qué hoy no la '
            'trabajamos.',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Vale.',
        pausaPrevia: Duration(milliseconds: 1200),
      ),
      PlanoDialogo(voz: VozPersonaje.isaura, texto: 'Y otra cosa.'),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Sí.'),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto:
            'Cuando llegue el momento, no tienes que ser tú quien la '
            'trabaje. Otros vendrán. Algunos pueden hacerla mejor que '
            'tú. Eso no es derrota.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Vale.',
        pausaPrevia: Duration(milliseconds: 2000),
      ),
      PlanoAmbiente(duracion: Duration(milliseconds: 1500)),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: 'El oficio es relevo. No es protagonismo.',
      ),
    ],
  );

  /// 4.B.1 — *Los pactos pequeños*. Estella, casco antiguo, calle
  /// de la Rúa. Karim le explica a Maren que la Brecha no busca
  /// grandes acontecimientos sino pactos pequeños — *"la convivencia
  /// no se mide en grandes hechos. Se mide en lo cotidiano."*
  /// Doc 10 §4.B.1.
  static const EscenaCinematica losPactosPequenos = EscenaCinematica(
    id: '4.B.1',
    titulo: 'Los pactos pequeños',
    flagDeSalida: 'escena_4_b_1_vista',
    flagsRequeridos: {'escena_4_a_2_vista'},
    ambiente: AmbienteArchivo.calleRuaEstella,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Estella, casco antiguo, calle de la Rúa. Maren y Karim '
            'caminan despacio. Mediados de junio.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.karim,
        texto: 'No vamos a buscar grandes acontecimientos hoy.',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Vale.'),
      PlanoDialogo(
        voz: VozPersonaje.karim,
        texto:
            'Vamos a buscar pactos pequeños. Compraventas. Vecindades. '
            'Acuerdos privados.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: '¿Por qué eso?',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
      PlanoDialogo(
        voz: VozPersonaje.karim,
        texto:
            'Porque la convivencia no se mide en grandes hechos. Se '
            'mide en lo cotidiano. Y lo cotidiano deja huella en '
            'archivos notariales.',
      ),
    ],
  );

  /// 4.B.2 — *Karim sobre los responsa*. Mesa de Trabajo cedida en
  /// Estella. Karim le presenta el material: archivos notariales,
  /// responsa rabínicos, documentación mudéjar. Lectura de un
  /// responsum de 1379 sobre el comerciante judío de Estella y el
  /// panadero cristiano que pactaron pan ácimo. Doc 10 §4.B.2.
  static const EscenaCinematica karimSobreLosResponsa = EscenaCinematica(
    id: '4.B.2',
    titulo: 'Karim sobre los responsa',
    flagDeSalida: 'escena_4_b_2_vista',
    flagsRequeridos: {'escena_4_b_1_vista'},
    ambiente: AmbienteArchivo.salaTrabajoEstella,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Sala municipal de Estella cedida como Mesa de Trabajo. '
            'Karim despliega tres montones: archivos notariales '
            'municipales del s. XIV-XV, responsa rabínicos del '
            'periodo, documentación mudéjar preservada.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.karim,
        texto:
            'Los responsa son una fuente excepcional. Imagina: cartas '
            'pidiendo consejo a un rabino sobre cómo manejar una '
            'situación concreta. La respuesta del rabino se conserva. '
            'El problema queda implícito en la respuesta.',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: '¿Como casos prácticos?'),
      PlanoDialogo(
        voz: VozPersonaje.karim,
        texto: 'Exacto. Te dicen lo que pasaba en la calle.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: '¿Hay responsa específicos de Estella?',
      ),
      PlanoDialogo(
        voz: VozPersonaje.karim,
        texto:
            'Algunos. Y otros del entorno cercano — del rabino de '
            'Tudela, de Pamplona — que mencionan situaciones de '
            'Estella.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Maren los lee. La interfaz le permite leer fragmentos en '
            'hebreo con traducción del tutor IA y notas de Karim.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto:
            'Un responsum de 1379. Un comerciante judío de Estella '
            'había pactado con un panadero cristiano que le hiciera '
            'pan ácimo durante Pascua. El cristiano cobró por '
            'adelantado, no entregó el pan. ¿Puede el judío demandarlo '
            'en tribunal cristiano?',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto:
            'El rabino responde que sí, pero recomienda mediación '
            'previa con el alcalde de la villa para no escalar.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto:
            'Eso me dice más que diez páginas de tratado teórico. La '
            'gente vivía mezclada. Pactaba pan ácimo entre comunidades. '
            'A veces el pacto se rompía. Los caminos para resolverlo '
            'eran múltiples.',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
    ],
  );

  /// 4.B.3 — *Una Brecha de vecinos*. Mesa de Trabajo, varias
  /// semanas. Maren elige como núcleo de su Brecha un pleito
  /// documentado de 1394 entre Pedro Garaicoa (cristiano) y Yusuf
  /// al-Tudelí (mudéjar) en Estella, por una pared medianera.
  /// Doc 10 §4.B.3.
  static const EscenaCinematica unaBrechaDeVecinos = EscenaCinematica(
    id: '4.B.3',
    titulo: 'Una Brecha de vecinos',
    flagDeSalida: 'escena_4_b_3_vista',
    flagsRequeridos: {'escena_4_b_2_vista'},
    ambiente: AmbienteArchivo.mesaTrabajoArchivo,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Mesa de Trabajo en Iruña, varias semanas. Maren ha '
            'elegido como núcleo de su Brecha un caso concreto: un '
            'pleito documentado de 1394 entre Pedro Garaicoa '
            '(cristiano) y Yusuf al-Tudelí (mudéjar) por una pared '
            'medianera entre dos casas en Estella.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'El pleito se conserva en los archivos municipales. Hay '
            'testigos cristianos y un testigo mudéjar. La Brecha '
            'pregunta: ¿qué nos dice este pleito sobre las relaciones '
            'cotidianas entre cristianos y mudéjares en Estella '
            'tardomedieval?',
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto:
            'El pleito es sobre una pared. Banal en superficie. Pero '
            'el procedimiento tiene detalles que iluminan más:',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto:
            'Yusuf el mudéjar acude al tribunal cristiano sin '
            'objeciones del juez.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto:
            'Su testigo (otro mudéjar, Mohammed) declara bajo juramento '
            'mudéjar respetado por el tribunal.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto:
            'Los testigos cristianos no descalifican a Yusuf por su '
            'religión — argumentan sobre la pared.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto:
            'El veredicto da parcialmente la razón a Yusuf. La sentencia '
            'se cumple sin apelaciones documentadas.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto:
            'Esto no es la convivencia idílica que algunos quieren ver. '
            'Tampoco es el conflicto permanente que otros prefieren. '
            'Es una vecindad funcional con sus tensiones.',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
    ],
  );

  /// 4.B.4 — *Reconstrucción* (puesta en limpio narrativa). Tras la
  /// Brecha 4.B jugable, Maren cierra con la voz del Cuaderno
  /// articulando el sentido del pleito como ventana a la cotidianidad.
  /// Doc 10 §4.B.4.
  static const EscenaCinematica reconstruccionTresComunidades =
      EscenaCinematica(
    id: '4.B.4',
    titulo: 'Reconstrucción',
    flagDeSalida: 'escena_4_b_4_vista',
    flagsRequeridos: {'brecha_4_b_completada'},
    ambiente: AmbienteArchivo.mesaTrabajoArchivo,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Mesa de Trabajo. Maren ha producido las ocho afirmaciones '
            'sobre el pleito de la pared medianera. Pone en limpio.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto:
            'Una pared. Un pleito. Dos hombres y un testigo. Y a través '
            'de eso, la vida diaria entera de Estella en 1394.',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto: 'Eso es oficio.',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
    ],
  );

  /// 4.B.5 — *Concilio*. Salón del Concilio. Karim revisor + Aitor
  /// + Joana Sasiain. El Concilio aprecia la elección del caso
  /// pequeño como ventana a la cotidianidad. Karim cierra con la
  /// lección del oficio: *"Una Brecha así, de un caso pequeño, vale
  /// más que diez Brechas sobre grandes acontecimientos cuando se
  /// trata de entender cómo vivía la gente."* Doc 10 §4.B.5.
  static const EscenaCinematica concilioTresComunidades = EscenaCinematica(
    id: '4.B.5',
    titulo: 'Concilio',
    flagDeSalida: 'escena_4_b_5_vista',
    flagsRequeridos: {'escena_4_b_4_vista'},
    ambiente: AmbienteArchivo.salonConcilio,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Salón del Concilio, días después. Karim revisor, Aitor, '
            'Joana Sasiain, Maren. Maren presenta. El Concilio aprecia '
            'la elección del caso pequeño como ventana a la '
            'cotidianidad.',
      ),
      PlanoDialogo(voz: VozPersonaje.karim, texto: 'Sellada.'),
      PlanoDialogo(
        voz: VozPersonaje.karim,
        texto:
            'Y déjame añadir: una Brecha así, de un caso pequeño, vale '
            'más que diez Brechas sobre grandes acontecimientos cuando '
            'se trata de entender cómo vivía la gente.',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 2),
        textoLectura: 'Maren asiente.',
      ),
    ],
  );

  /// 4.B.6 — *Cierre 4.B*. Voz del Cuaderno breve. Doc 10 §4.B.6.
  static const EscenaCinematica cierreTresComunidades = EscenaCinematica(
    id: '4.B.6',
    titulo: 'Cierre 4.B',
    flagDeSalida: 'escena_4_b_6_vista',
    flagsRequeridos: {'escena_4_b_5_vista'},
    ambiente: AmbienteArchivo.cuartoCasaMaren,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura:
            'Habitación de Maren. La voz del Cuaderno cierra la '
            'Estación.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto:
            'Una pared. Un pleito. Dos hombres y un testigo. Y a través '
            'de eso, la vida diaria entera de Estella en 1394.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto: 'Eso es oficio.',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
    ],
  );

  /// 4.C — *Antonio termina la frase*. Mediados de junio, casa de
  /// Maren. Cocina, después de cenar, Iratxe se ha llevado a Naia
  /// al baño. Antonio termina la frase truncada del 2.Z.1: lo que
  /// iba a decir es que verla crecer en este oficio le da más miedo
  /// del que esperaba — porque las preguntas tienen precio: soledad
  /// a ratos. Pero no se arrepiente de haberla empujado. *"No te
  /// empujé. Te leí cuentos. Tú decidiste el oficio."* Y *"las dos
  /// a las dos"*. Doc 10 §4.C.
  static const EscenaCinematica antonioTerminaLaFrase = EscenaCinematica(
    id: '4.C',
    titulo: 'Antonio termina la frase',
    flagDeSalida: 'escena_4_c_vista',
    flagsRequeridos: {'escena_4_b_6_vista'},
    ambiente: AmbienteArchivo.cocinaCasaMaren,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Casa de Maren, una noche. Cocina, después de cenar. '
            'Iratxe se ha llevado a Naia al baño. Maren ayuda a '
            'recoger la mesa. Antonio lava platos. Los dos sin hablar '
            'durante varios minutos. Música baja del salón.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 2),
        textoLectura: 'Antonio rompe el silencio.',
      ),
      PlanoDialogo(voz: VozPersonaje.antonio, texto: 'Maren.'),
      PlanoDialogo(voz: VozPersonaje.maren, texto: '¿Sí?'),
      PlanoDialogo(
        voz: VozPersonaje.antonio,
        texto:
            'Hace cuatro meses, en esta cocina, te dije "Maren" y '
            'después dije "olvídalo".',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 2),
        textoLectura: 'Maren se queda quieta con un plato a medio secar.',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Sí.'),
      PlanoDialogo(
        voz: VozPersonaje.antonio,
        texto: 'Te voy a terminar la frase ahora.',
        pausaPrevia: Duration(milliseconds: 2000),
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Vale.',
        pausaPrevia: Duration(milliseconds: 1200),
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura: 'Antonio cierra el grifo. Se gira. La mira.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.antonio,
        texto:
            'Iba a decirte que verte crecer en este oficio me ha dado '
            'más miedo del que esperaba.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: '¿Por qué miedo?',
        pausaPrevia: Duration(milliseconds: 1200),
      ),
      PlanoDialogo(
        voz: VozPersonaje.antonio,
        texto:
            'Porque veo que vas a pasar la vida con preguntas que la '
            'mayoría no se hace. Y las preguntas tienen precio.',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: '¿Cuál?',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
      PlanoDialogo(
        voz: VozPersonaje.antonio,
        texto: 'Soledad. A ratos. No siempre. Pero a ratos.',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
      PlanoAmbiente(duracion: Duration(seconds: 3)),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Ya he sentido alguna.'),
      PlanoDialogo(voz: VozPersonaje.antonio, texto: 'Lo sé.'),
      PlanoAmbiente(duracion: Duration(milliseconds: 1500)),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: '¿Te arrepientes de haberme empujado?',
      ),
      PlanoDialogo(voz: VozPersonaje.antonio, texto: 'No.'),
      PlanoDialogo(voz: VozPersonaje.maren, texto: '¿Aunque tenga precio?'),
      PlanoDialogo(
        voz: VozPersonaje.antonio,
        texto: 'Aunque tenga precio.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.antonio,
        texto: 'No te empujé. Te leí cuentos. Tú decidiste el oficio.',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
      PlanoAmbiente(duracion: Duration(milliseconds: 1500)),
      PlanoDialogo(voz: VozPersonaje.antonio, texto: 'Y otra cosa.'),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Sí.'),
      PlanoDialogo(
        voz: VozPersonaje.antonio,
        texto:
            'Cuando tu hermana sea más mayor y haga preguntas como las '
            'tuyas, voy a saber qué hacer. Antes no lo sabía.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Me has enseñado tú.',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
      PlanoDialogo(
        voz: VozPersonaje.antonio,
        texto: 'Las dos a las dos.',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Maren asiente. Se gira al fregadero. Sigue secando platos. '
            'Antonio vuelve al grifo. Cinco minutos sin hablar. La '
            'cocina queda limpia.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto: 'Aita ha terminado su frase de hace cuatro meses.',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto: 'Soledad a ratos. Lo dijo. Y le creo.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto: 'Pero también dijo otra cosa. Las dos a las dos.',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
    ],
  );

  /// 4.D — *Naia con su cuaderno*. Sábado, dos días después.
  /// Habitación de Maren. Naia entra con un cuaderno pequeño rosa
  /// nuevo. Lleva diez preguntas escritas con letra de niña de
  /// ocho años. Lee dos a Maren — *"¿Por qué se mueren las personas
  /// en orden raro?"* y *"¿Las cosas bonitas son siempre verdad?"*.
  /// La transmisión intergeneracional ha alcanzado a la siguiente
  /// generación sin que nadie lo planificara. Doc 10 §4.D.
  static const EscenaCinematica naiaConSuCuaderno = EscenaCinematica(
    id: '4.D',
    titulo: 'Naia con su cuaderno',
    flagDeSalida: 'escena_4_d_vista',
    flagsRequeridos: {'escena_4_c_vista'},
    ambiente: AmbienteArchivo.cuartoCasaMaren,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Sábado, dos días después. Maren en su mesa estudiando '
            'para el último examen del instituto. Llaman a la puerta.',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: '¿Sí?'),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Naia entra. Lleva un cuaderno pequeño rosa que es nuevo.',
      ),
      PlanoDialogo(voz: VozPersonaje.naia, texto: '¿Tienes un momento?'),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Vale.'),
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura:
            'Naia se sienta en la cama. Abre el cuaderno. Páginas con '
            'preguntas escritas con letra de niña de ocho años. Diez '
            'preguntas. Algunas tachadas y reescritas.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.naia,
        texto:
            'Tú tienes un cuaderno con preguntas. Yo me he hecho uno '
            'también.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Vale.',
        pausaPrevia: Duration(milliseconds: 1200),
      ),
      PlanoDialogo(voz: VozPersonaje.naia, texto: '¿Quieres saber cuáles son?'),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Sí.',
        pausaPrevia: Duration(milliseconds: 2000),
      ),
      PlanoDialogo(
        voz: VozPersonaje.naia,
        texto:
            '"¿Por qué se mueren las personas en orden raro?"',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: '¿Qué quieres decir?'),
      PlanoDialogo(
        voz: VozPersonaje.naia,
        texto:
            'A veces se muere primero el abuelo. A veces el bebé. A '
            'veces el de en medio. ¿Por qué no en orden?',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'No sé.',
        pausaPrevia: Duration(milliseconds: 2000),
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 2),
        textoLectura: 'Naia asiente. Lee la segunda.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.naia,
        texto: '"¿Las cosas bonitas son siempre verdad?"',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 2),
        textoLectura: 'Maren se queda quieta.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'No.',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura:
            'Naia apunta una pequeña marca al lado de la pregunta — no '
            'una respuesta, una nota. Cierra el cuaderno.',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: '¿No me lees las demás?'),
      PlanoDialogo(
        voz: VozPersonaje.naia,
        texto: 'Las otras me las contesto sola.',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura: 'Naia se va. Maren se queda mirando la puerta cerrada.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto: 'Mi hermana de ocho años tiene cuaderno propio.',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto:
            'Una de sus preguntas es "¿las cosas bonitas son siempre '
            'verdad?". La aprendió de mí, sin que yo lo planeara.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto: 'Se va a contestar sola.',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
    ],
  );

  /// 4.E — *Eider en la cancha*. 21 de junio, polideportivo del
  /// barrio. Final de liga juvenil — el partido al que Maren no fue
  /// en marzo (anunciado en 3.0.2). Maren llega tarde, sin avisar,
  /// se queda en las gradas. Eider la ve, hacen un asentimiento
  /// mínimo desde la distancia. Eider gana. Mensaje de Eider: *"gracias
  /// por venir, aunque sea al último"*. Doc 10 §4.E.
  static const EscenaCinematica eiderEnLaCancha = EscenaCinematica(
    id: '4.E',
    titulo: 'Eider en la cancha',
    flagDeSalida: 'escena_4_e_vista',
    flagsRequeridos: {'escena_4_d_vista'},
    ambiente: AmbienteArchivo.polideportivoBarrio,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            '21 de junio. Polideportivo del barrio. Final de liga '
            'juvenil — el partido al que Maren no fue en marzo. Maren '
            'llega tarde, sin avisar. Se queda en las gradas, alta, '
            'lateral.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Eider está en la cancha calentando con su equipo. Es el '
            'último partido del año. Maren mira el partido. Eider '
            'juega bien — no destacando, sólida.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'En un descanso, Eider mira a las gradas. Ve a Maren. Tres '
            'segundos. Se hacen un asentimiento mínimo desde la '
            'distancia. Eider sigue jugando. Su equipo gana.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Cuando termina el partido, Maren no baja al vestuario. Se '
            'va. En el portal de su casa, recibe un mensaje de Eider:',
      ),
      PlanoDialogo(
        voz: VozPersonaje.eider,
        texto: 'gracias por venir',
      ),
      PlanoDialogo(
        voz: VozPersonaje.eider,
        texto: 'aunque sea al último',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 2),
        textoLectura: 'Maren contesta:',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'el siguiente igual también voy',
      ),
      PlanoDialogo(voz: VozPersonaje.eider, texto: 'vale'),
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura: 'Maren guarda el móvil. Sube a casa.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto:
            'Eider y yo seguimos siendo amigas. Distinta forma. Es lo '
            'que hay.',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto: 'Mejor que perderse del todo.',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
    ],
  );

  /// 4.F — *El cuaderno de Isaura*. Tercera semana de junio, pocos
  /// días antes de la graduación. Despacho de Isaura. Isaura le
  /// enseña a Maren dos páginas de su cuaderno marrón viejo: una de
  /// 1991 con tres preguntas (incluido *"Tasio me preguntó hoy si
  /// soy cobarde por preferir Probable a Sólido"* — y la revelación
  /// de que ese Tasio era Tasio Iribarrena, su compañero de
  /// Aprendizaje muerto en 1996; el Tasio actual lleva ese nombre
  /// por coincidencia familiar) y una de 2024 con una sola pregunta
  /// sobre si Isaura podría aceptar la versión de Maren con humildad.
  /// La lección clave del oficio: *"si algún día te ocurre que un
  /// alumno tuyo te enseña algo que tú no habías visto, recuérdate
  /// que no es derrota. Es relevo."* Doc 10 §4.F.
  static const EscenaCinematica elCuadernoDeIsaura = EscenaCinematica(
    id: '4.F',
    titulo: 'El cuaderno de Isaura',
    flagDeSalida: 'escena_4_f_vista',
    flagsRequeridos: {'escena_4_e_vista'},
    ambiente: AmbienteArchivo.despachoIsaura,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Despacho de Isaura, tercera semana de junio. Pocos días '
            'antes de la graduación. Maren entra para una consulta '
            'menor. Isaura termina lo que está haciendo. Cierra una '
            'carpeta. Mira a Maren.',
      ),
      PlanoDialogo(voz: VozPersonaje.isaura, texto: 'Te quiero enseñar dos páginas.'),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Vale.'),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Isaura abre el cajón. Saca el cuaderno marrón viejo. Lo '
            'abre. Pasa páginas hasta llegar a una concreta. Le da la '
            'vuelta hacia Maren.',
      ),
      PlanoDialogo(voz: VozPersonaje.isaura, texto: 'Mira.'),
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Letra de Isaura más joven — todavía formada, pero con '
            'vacilaciones. Fecha: marzo de 1991. Una página entera '
            'con tres preguntas.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto: '¿Cómo distingo lo que sé de lo que quiero saber?',
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto:
            'Cuando una fuente dice algo y otra dice otra cosa, y las '
            'dos son creíbles, ¿cómo decido?',
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto:
            'Tasio me preguntó hoy si soy cobarde por preferir Probable '
            'a Sólido. ¿Lo soy?',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Maren se queda quieta. La fecha — 1991 — es treinta años '
            'antes del Tasio actual. No es el mismo Tasio.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Isaura. ¿Quién era este Tasio de 1991?',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto:
            'Mi compañero de Aprendizaje. Tasio Iribarrena. Murió en '
            '1996.',
        pausaPrevia: Duration(milliseconds: 2000),
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: '¿De qué?',
        pausaPrevia: Duration(milliseconds: 2000),
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: 'Accidente de tráfico. No tiene nada que ver con el oficio.',
      ),
      PlanoAmbiente(duracion: Duration(milliseconds: 2000)),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto:
            'El Tasio de ahora se llama así porque su padre y mi '
            'compañero eran primos lejanos. Coincidencia familiar de '
            'Tafalla y Tudela. Por eso le sorprendió tanto a Tasio el '
            'actual cuando entró al Archivo y descubrió que mi mejor '
            'amigo de Aprendizaje se había llamado igual que él.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Lo sabíais los dos antes de empezar a trabajar juntos.',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
      PlanoDialogo(voz: VozPersonaje.isaura, texto: 'Sí.'),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: '¿Eso afectó?',
        pausaPrevia: Duration(milliseconds: 2000),
      ),
      PlanoDialogo(voz: VozPersonaje.isaura, texto: 'Sí. Lo afectó todo.'),
      PlanoAmbiente(duracion: Duration(milliseconds: 2000)),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto:
            'Yo veía a mi compañero muerto en algunos gestos del Tasio '
            'joven. Le perdoné cosas que probablemente no debía haber '
            'perdonado. Quizá si hubiera sido más exigente, no se '
            'habría ido así.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: 'Quizá sí. No lo sé.',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Maren asiente despacio. Mira la página otra vez. La '
            'pregunta sobre la cobardía.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: '¿Te contestaste alguna?',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: 'La segunda. Sí. Décadas en aprenderlo.',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: '¿La primera?'),
      PlanoDialogo(voz: VozPersonaje.isaura, texto: 'No.'),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: '¿Y la tercera?',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: 'La tercera la sigo trabajando.',
        pausaPrevia: Duration(milliseconds: 2000),
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura:
            'Isaura cierra el cuaderno. Lo guarda en el cajón.',
      ),
      PlanoDialogo(voz: VozPersonaje.isaura, texto: 'Te enseño otra.'),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Vale.'),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Vuelve a abrir el cuaderno, en una página posterior. '
            'Fecha: octubre de 2024. Una sola pregunta.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto:
            'Si Maren llegara a una versión propia de la Brecha del '
            'incendio, ¿podría yo aceptar mi propia versión revisada '
            'con humildad? ¿O me he vuelto demasiado vieja para '
            'revisar?',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura: 'Maren lee. Mira a Isaura.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Isaura.',
        pausaPrevia: Duration(milliseconds: 2000),
      ),
      PlanoDialogo(voz: VozPersonaje.isaura, texto: 'Sí.'),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto:
            'Tu afirmación cinco — la complicidad institucional como '
            'categoría general Sólido. Mi afirmación cinco lo planteó '
            'así. ¿Tú lo aceptaste?',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
      PlanoDialogo(voz: VozPersonaje.isaura, texto: 'Sí.'),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto:
            '¿Y vas a publicar una revisión de tu reconstrucción de '
            '2017?',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: 'Estoy considerándolo.',
        pausaPrevia: Duration(milliseconds: 2000),
      ),
      PlanoAmbiente(duracion: Duration(milliseconds: 1500)),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'No es vejez.'),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: 'Eso lo decido yo.',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura: 'Cierra el cuaderno. Lo guarda.',
      ),
      PlanoDialogo(voz: VozPersonaje.isaura, texto: 'Maren.'),
      PlanoDialogo(voz: VozPersonaje.maren, texto: '¿Sí?'),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto:
            'Si algún día te ocurre que un alumno tuyo te enseña algo '
            'que tú no habías visto, recuérdate que no es derrota. Es '
            'relevo.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Vale.',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura: 'Maren se levanta. En la puerta:',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Isaura.'),
      PlanoDialogo(voz: VozPersonaje.isaura, texto: '¿Sí?'),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Gracias por enseñármelas.'),
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura: 'Isaura asiente sin sonreír.',
      ),
      PlanoDialogo(voz: VozPersonaje.isaura, texto: 'Mm.'),
      PlanoAmbiente(
        duracion: Duration(seconds: 2),
        textoLectura: 'Maren sale.',
      ),
    ],
  );

  /// 4.G.1 — *Camino a Tudela última*. ~24 de junio. Maren ha leído
  /// por fin la carta de Tasio del principio del arco. Le pedía
  /// verla en Tudela un día concreto. Tren a Tudela, sola. Aitor lo
  /// sabe, Karim también, Isaura también. Nadie ha intentado
  /// disuadirla. Nadie la acompaña. Doc 10 §4.G.1.
  static const EscenaCinematica caminoATudelaUltima = EscenaCinematica(
    id: '4.G.1',
    titulo: 'Camino a Tudela última',
    flagDeSalida: 'escena_4_g_1_vista',
    flagsRequeridos: {'escena_4_f_vista'},
    ambiente: AmbienteArchivo.trenIrunaTudela,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            '24 de junio. Maren ha leído por fin la carta de Tasio del '
            'principio del arco. Le pedía verla en Tudela un día '
            'concreto. Tren a Tudela. Maren va sola, sin acompañante '
            'del Archivo.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Aitor lo sabe — Karim también. Isaura también. Nadie ha '
            'intentado disuadirla. Nadie la acompaña.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'El tren atraviesa el paisaje de la Ribera. Maren mira por '
            'la ventana. No abre el cuaderno.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto:
            'Tasio me pidió en una carta que fuera a Tudela una vez '
            'antes de mi graduación. Dijo que no era para convencerme. '
            'Era para decirme algo concreto.',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto: 'Voy. Sola. Decidir qué hago después es mío.',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
    ],
  );

  /// 4.G.2 — *El segundo encuentro con Tasio*. Sede de Resolutiva,
  /// Tudela. Sólo están ellos dos. Tasio formula la oferta concreta:
  /// puesto en Resolutiva como Aprendiz mayor con tareas propias.
  /// Maren queda en suspenso explícito — *"Te voy a pensar." / "Es
  /// probable que no te conteste."*. Tasio respeta el silencio. Voto
  /// implícito de Tasio: *"Sea cual sea tu decisión, no la tomes
  /// para complacer a Isaura. Ni para incomodarla. Ni para
  /// complacerme a mí. Ni para incomodarme."* Doc 10 §4.G.2.
  static const EscenaCinematica elSegundoEncuentroConTasio = EscenaCinematica(
    id: '4.G.2',
    titulo: 'El segundo encuentro con Tasio',
    flagDeSalida: 'escena_4_g_2_vista',
    flagsRequeridos: {'escena_4_g_1_vista'},
    ambiente: AmbienteArchivo.sedeResolutivaTudela,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Sede de Resolutiva, Tudela. Una oficina pequeña en planta '
            'baja, paredes con archivos, una mesa de trabajo, dos '
            'sillas. Maren llega. Tasio le abre. Sólo están ellos dos '
            '— los demás miembros de Resolutiva no están hoy, '
            'deliberadamente.',
      ),
      PlanoDialogo(voz: VozPersonaje.tasio, texto: 'Has venido.'),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Sí.'),
      PlanoDialogo(voz: VozPersonaje.tasio, texto: 'Pasa.'),
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura:
            'Se sientan. Tasio le ofrece agua. Maren acepta. Bebe.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.tasio,
        texto:
            'Te voy a hacer la oferta. Sin adornos. Y después tú te '
            'vas y decides cuando puedas.',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Vale.'),
      PlanoDialogo(
        voz: VozPersonaje.tasio,
        texto:
            'Cuando te gradúes, Resolutiva tiene un puesto para ti. No '
            'de Ejecutora plena — eso requiere experiencia que no '
            'tendrás todavía. Pero sí como Aprendiz mayor con tareas '
            'propias.',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
      PlanoAmbiente(duracion: Duration(milliseconds: 1500)),
      PlanoDialogo(
        voz: VozPersonaje.tasio,
        texto:
            'El sueldo es modesto pero existe. El trabajo es más '
            'rápido que en el Archivo y más político. Tendrías acceso '
            'a casos que el Archivo no toca por prudencia. Y tendrías '
            'margen para desarrollar tu propia metodología — porque '
            'la afirmación cuatro de tu Brecha del incendio es ya tu '
            'metodología.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: '¿Por qué me lo ofreces a mí?',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
      PlanoDialogo(
        voz: VozPersonaje.tasio,
        texto:
            'Porque eres la única persona que ha trabajado esa Brecha '
            'en seis años llegando a algo nuevo.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Hay otras personas en el Archivo capaces.',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
      PlanoDialogo(
        voz: VozPersonaje.tasio,
        texto:
            'Sí. Pero la mayoría no se atreverían a ofrecerme una '
            'afirmación que reformara la mía. Tú lo hiciste sin '
            'pedírmelo.',
      ),
      PlanoAmbiente(duracion: Duration(milliseconds: 1500)),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: '¿No estás contratando una versión más joven de ti?',
      ),
      PlanoDialogo(
        voz: VozPersonaje.tasio,
        texto: 'Buena pregunta.',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura: 'Pausa muy larga. Tasio bebe agua.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.tasio,
        texto: 'Honestamente: no lo sé. Quizá sí. Pero te digo lo que creo.',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Vale.'),
      PlanoDialogo(
        voz: VozPersonaje.tasio,
        texto:
            'Tú no eres como yo. Tú llegaste a tu afirmación cuatro '
            'dentro de la disciplina del oficio. Yo a tu edad ya estaba '
            'pensando en cómo romperlo. Tú estás pensando en cómo '
            'profundizarlo.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.tasio,
        texto:
            'Si vienes a Resolutiva, vas a empujarnos a ser más '
            'rigurosos. Si te quedas en el Archivo, vas a empujarles '
            'a ser más rápidos. Las dos cosas son legítimas.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: '¿Estás dispuesto a ser empujado por mí?',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
      PlanoDialogo(
        voz: VozPersonaje.tasio,
        texto: 'Sí.',
        pausaPrevia: Duration(milliseconds: 2000),
      ),
      PlanoDialogo(
        voz: VozPersonaje.tasio,
        texto:
            'Pero no te ofrezco esto como gancho. Te lo ofrezco como '
            'opción. Si dices que sí, vienes. Si dices que no, te '
            'quedas en el Archivo y nos vemos en Concilios externos '
            'durante años.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: '¿Y si no contesto?',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
      PlanoDialogo(
        voz: VozPersonaje.tasio,
        texto: 'Si no contestas, lo entiendo como no.',
        pausaPrevia: Duration(milliseconds: 2000),
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: '¿Cuándo necesitas saber?'),
      PlanoDialogo(
        voz: VozPersonaje.tasio,
        texto:
            'No tengo prisa. Pero si en un año no me has contestado, '
            'asumiré que no.',
      ),
      PlanoAmbiente(duracion: Duration(milliseconds: 1500)),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Tasio.'),
      PlanoDialogo(voz: VozPersonaje.tasio, texto: '¿Sí?'),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Te voy a pensar.',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
      PlanoDialogo(voz: VozPersonaje.tasio, texto: 'Vale.'),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Es probable que no te conteste.'),
      PlanoDialogo(
        voz: VozPersonaje.tasio,
        texto: 'También vale.',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
      PlanoAmbiente(duracion: Duration(milliseconds: 1500)),
      PlanoDialogo(voz: VozPersonaje.tasio, texto: 'Una cosa más antes de que te vayas.'),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Sí.'),
      PlanoDialogo(
        voz: VozPersonaje.tasio,
        texto:
            'Sea cual sea tu decisión, no la tomes para complacer a '
            'Isaura. Ni para incomodarla. Ni para complacerme a mí. '
            'Ni para incomodarme.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Lo intentaré.',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
      PlanoDialogo(voz: VozPersonaje.tasio, texto: 'Bien.'),
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura:
            'Tasio se levanta. Le tiende la mano. Maren se la da. '
            'Apretón breve.',
      ),
      PlanoDialogo(voz: VozPersonaje.tasio, texto: 'Vas a ser buena.'),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Eso ya me lo dijiste.'),
      PlanoAmbiente(
        duracion: Duration(seconds: 2),
        textoLectura: 'Sonrisa breve, real esta vez.',
      ),
      PlanoDialogo(voz: VozPersonaje.tasio, texto: 'Lo repito.'),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Maren sale. La cámara se queda en la oficina de Resolutiva '
            'con Tasio. Tasio se sienta. Mira sus manos un segundo. '
            'Después abre un archivo de trabajo.',
      ),
    ],
  );

  /// 4.G.3 — *El silencio que vuelve*. Tren de regreso, tarde-noche.
  /// Voz del Cuaderno: *"No sé qué voy a hacer."* / *"Tasio me ha
  /// tratado bien. Su oferta es seria."* / *"Pero no quiero decidir
  /// hoy. Y probablemente no decida en un año. Ese es exactamente el
  /// silencio del que él habla."* Maren llega a Iruña al anochecer.
  /// Pasa por delante del Archivo, no sube. Doc 10 §4.G.3.
  static const EscenaCinematica elSilencioQueVuelve = EscenaCinematica(
    id: '4.G.3',
    titulo: 'El silencio que vuelve',
    flagDeSalida: 'escena_4_g_3_vista',
    flagsRequeridos: {'escena_4_g_2_vista'},
    ambiente: AmbienteArchivo.trenIrunaTudela,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Tren Tudela-Iruña. La tarde cae. El paisaje vuelve hacia '
            'el norte.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto: 'No sé qué voy a hacer.',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto:
            'Tasio me ha tratado bien. Su oferta es seria. Su análisis '
            'de mí es probablemente más exacto que el de Isaura — o al '
            'menos lo es en algunas dimensiones.',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto:
            'Pero no quiero decidir hoy. Y probablemente no decida en '
            'un año.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto: 'Ese es exactamente el silencio del que él habla.',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Maren cierra el cuaderno. Mira el paisaje. Llega a Iruña '
            'al anochecer. Camina a casa por el casco viejo. Pasa por '
            'delante del Archivo. Las luces de la primera planta están '
            'encendidas — alguien trabaja tarde. Maren no sube. Sigue.',
      ),
    ],
  );

  /// M4.entrega — Andrés en el ático archiva el Mosaico. *"Doble
  /// cartela en paralelo. Original."*. Maren pregunta si funciona.
  /// Andrés: *"Maren. La pregunta no me la haces a mí. Ya eres tú la
  /// que decide si funciona."* Felicidades antes de la graduación.
  /// Doc 10 §M4.
  static const EscenaCinematica entregaDelMosaicoM4 = EscenaCinematica(
    id: 'M4.entrega',
    titulo: 'Doble cartela',
    flagDeSalida: 'escena_m_4_entrega_vista',
    flagsRequeridos: {'mosaico_arco_4_entregado'},
    ambiente: AmbienteArchivo.aticoArchivo,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Ático del Archivo. Andrés en su mesa. Maren entra con el '
            'Mosaico — doble cartela en paralelo, dos objetos uno de '
            'cada extremo de su recorrido del MVP. Un fragmento '
            'cerámico campaniforme del primer dolmen de Aralar y la '
            'inscripción honorífica romana de Pompelo.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.andres,
        texto: 'Doble cartela en paralelo. Original.',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: '¿Funciona?'),
      PlanoDialogo(
        voz: VozPersonaje.andres,
        texto:
            'Maren. La pregunta no me la haces a mí. Ya eres tú la que '
            'decide si funciona.',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Andrés archiva el Mosaico. Antes de que Maren se vaya:',
      ),
      PlanoDialogo(voz: VozPersonaje.andres, texto: 'Maren.'),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Sí.'),
      PlanoDialogo(voz: VozPersonaje.andres, texto: 'Felicidades.'),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Es mañana.',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
      PlanoDialogo(
        voz: VozPersonaje.andres,
        texto: 'Lo sé. Te lo digo hoy para que no se me olvide.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura: 'Sonrisa breve. Maren sale.',
      ),
    ],
  );

  /// 4.H.1 — *La víspera*. Noche del 28 de junio, cena familiar.
  /// Cocina/comedor de casa. Pasta. Vino para los padres, agua para
  /// las niñas. Naia ha hecho un dibujo de Maren para mañana — *"MI
  /// HERMANA CRONISTA"*. Cena normal. Maren abraza a Naia más tiempo
  /// del habitual antes de irse a la cama. Voz del Cuaderno: *"Mañana."*.
  /// Doc 10 §4.H.1.
  static const EscenaCinematica laVispera = EscenaCinematica(
    id: '4.H.1',
    titulo: 'La víspera',
    flagDeSalida: 'escena_4_h_1_vista',
    flagsRequeridos: {'escena_m_4_entrega_vista'},
    ambiente: AmbienteArchivo.cocinaCasaMaren,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Noche del 28 de junio. Cena familiar. Cocina/comedor de '
            'casa. Pasta. Vino para los padres, agua para las niñas. '
            'Naia ha hecho un dibujo de Maren para mañana.',
      ),
      PlanoDialogo(voz: VozPersonaje.naia, texto: 'Para mañana.'),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'El dibujo: Maren con un cuaderno en la mano, en un patio, '
            'con un castaño grande detrás. Letras grandes encima: "MI '
            'HERMANA CRONISTA".',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Naia.',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
      PlanoDialogo(voz: VozPersonaje.naia, texto: '¿Qué?'),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Está perfecto.'),
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura: 'Iratxe sirve vino.',
      ),
      PlanoDialogo(voz: VozPersonaje.iratxe, texto: '¿Estás nerviosa?'),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Un poco.'),
      PlanoDialogo(voz: VozPersonaje.antonio, texto: 'Vamos a ir los cuatro.'),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Lo sé.'),
      PlanoDialogo(voz: VozPersonaje.iratxe, texto: 'Y Eider está invitada.'),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Sí.'),
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Cenan. Conversación normal. Antes de que Naia se vaya a '
            'la cama, Maren la abraza más tiempo del habitual. Naia '
            'no comenta.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto: 'Mañana.',
        pausaPrevia: Duration(milliseconds: 2000),
      ),
    ],
  );

  /// 4.H.2 — *La ceremonia*. 29 de junio, 12:00. Patio del Archivo.
  /// Junto al brocal del pozo y el capitel del s. XII. Begoña preside,
  /// los Cronistas en semicírculo, Maren delante. Maren pronuncia el
  /// voto del oficio (texto canónico, doc 10 §4.H.2). Begoña le
  /// entrega el cuaderno blanco. Aplausos discretos. Familia al
  /// fondo. Eider sonríe. Marina: *"Hermana mayor"*. Karim asentimiento
  /// con respeto. Aitor aprieta el brazo. Andrés desde lejos levanta
  /// taza. Isaura no se acerca durante la ceremonia. Cuando los
  /// demás se van, Isaura se acerca despacio con bastón. *"Cronista."*
  /// *"Te dejo sola un rato."* Doc 10 §4.H.2.
  ///
  /// **PENDIENTE REFORMULACIÓN-1512**: el comité provisional propone
  /// un Concilio de graduación a Cronista distinto (cuatro escenas
  /// 4.Z.1-4 con defensa metodológica frente a Karim, presentación
  /// de los siete territorios herederos, pregunta final de Begoña).
  /// Esta cinemática queda según doc 10 v0.1 hasta consolidación.
  static const EscenaCinematica laCeremonia = EscenaCinematica(
    id: '4.H.2',
    titulo: 'La ceremonia',
    flagDeSalida: 'escena_4_h_2_vista',
    flagsRequeridos: {'escena_4_h_1_vista'},
    ambiente: AmbienteArchivo.patioArchivo,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 6),
        textoLectura:
            '29 de junio, 12:00 del mediodía. Patio del Archivo. Junto '
            'al brocal del pozo y el capitel del s. XII. El patio '
            'arreglado modestamente. Una mesa pequeña con un cuaderno '
            'blanco encima — el cuaderno nuevo. Begoña al lado. Los '
            'Cronistas del Archivo en semicírculo. Maren delante.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Familia al fondo: Iratxe, Antonio, Naia. Eider invitada '
            'por Maren, también al fondo. Begoña abre.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.begona,
        texto:
            'Maren Lozano. Aprendiz III. Hoy te graduamos como Cronista '
            'joven del Archivo. Pronuncias el voto del oficio.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Sí.',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
      PlanoDialogo(voz: VozPersonaje.begona, texto: 'Adelante.'),
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura:
            'Maren respira hondo. Habla. La voz tiembla un poco al '
            'principio, después se firma.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Prometo formular preguntas honestas.',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto:
            'Escuchar las fuentes en lo que dicen y en lo que callan.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Anclar mis afirmaciones en evidencia.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Declarar mis niveles de confianza con honestidad.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Defender mis versiones ante el Concilio.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Aceptar las correcciones razonables.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'No inventar lo que no sé.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'No callar lo que sé.',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'No usar a los muertos como ventrílocuos.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto:
            'Y mantener vivo el oficio mientras pueda hacerlo bien.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura: 'Pausa larga. Begoña asiente.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Begoña coge el cuaderno blanco. Se lo entrega a Maren con '
            'las dos manos.',
      ),
      PlanoDialogo(voz: VozPersonaje.begona, texto: 'Bienvenida.'),
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Maren coge el cuaderno. Asiente. No sonríe — tiembla un '
            'poco. Lo controla. Isaura desde su sitio asiente. Karim '
            'aplaude — no protocolario. Marina aplaude también. Andrés '
            'aplaude. Aitor aplaude. Joana aplaude. Begoña no aplaude '
            'pero su cara se relaja un milímetro.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Al fondo, Iratxe llora silenciosamente. Antonio le pasa '
            'un brazo por los hombros. Naia mira con la boca abierta. '
            'Eider sonríe.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.begona,
        texto: 'Cronista. Por hoy ya está. Mañana es el primer día.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Risa baja, contenida, en el patio. La ceremonia termina. '
            'Maren va al fondo. Abraza a Iratxe primero, después a '
            'Naia (que le susurra "no llores, no llores"), después a '
            'Antonio. Eider se acerca. Las dos se abrazan brevemente. '
            'No hablan.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura: 'Marina se acerca después.',
      ),
      PlanoDialogo(voz: VozPersonaje.marina, texto: 'Hermana mayor.'),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Hermana mayor sigues siendo tú.'),
      PlanoDialogo(voz: VozPersonaje.marina, texto: 'Por poco tiempo más.'),
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Karim se acerca. No habla. Le hace un asentimiento con '
            'respeto. Aitor le aprieta el brazo brevemente al pasar. '
            'Andrés desde lejos levanta una taza de café. Isaura no se '
            'acerca durante la ceremonia ni durante los abrazos. Maren '
            'la mira desde lejos. Isaura está al otro lado del patio, '
            'hablando con Begoña en voz baja.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Cuando los demás empiezan a irse, cuando la familia de '
            'Maren se va al coche con Eider, cuando los Cronistas del '
            'Archivo se vuelven a sus tareas, Maren se queda en el '
            'patio. Isaura termina con Begoña. Se acerca a Maren. '
            'Despacio. Bastón.',
      ),
      PlanoDialogo(voz: VozPersonaje.isaura, texto: 'Cronista.'),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Sí.',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Las dos se quedan de pie junto al brocal. Diez segundos '
            'en silencio.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto:
            'Te dejo sola un rato. Cuando salgas, ven a verme al '
            'despacho.',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Vale.'),
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura: 'Isaura se va. La cámara se queda con Maren.',
      ),
    ],
  );

  /// 4.Z — *El patio vacío*. Maren sola en el patio tras la
  /// ceremonia. Saca el cuaderno de Aprendiz I (lleno de cuatro
  /// arcos de trabajo). Lo abre, pasa páginas hacia atrás, lee
  /// fragmentos clave de los cuatro arcos. Escribe la última línea:
  /// *"Cuaderno de Aprendiz I. Cerrado el 29 de junio."* Saca el
  /// cuaderno blanco nuevo de Cronista. Escribe la primera entrada:
  /// *"Hoy empiezo de cero. No es verdad. No empiezo de cero. Empiezo
  /// de aquí."* Anuncio del fin del MVP. Doc 10 §4.Z.
  static const EscenaCinematica elPatioVacio = EscenaCinematica(
    id: '4.Z',
    titulo: 'El patio vacío',
    flagDeSalida: 'escena_4_z_vista',
    flagsRequeridos: {'escena_4_h_2_vista'},
    ambiente: AmbienteArchivo.patioArchivo,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 6),
        textoLectura:
            'El patio del Archivo está vacío. El sol del mediodía. El '
            'capitel del s. XII. El brocal del pozo. Hay un boj viejo '
            'en una maceta grande, podado con cuidado.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Maren se sienta en el banco junto al brocal. Saca de la '
            'mochila el cuaderno de Aprendiz I — el que cerró al final '
            'del Arco 1, el que ha llevado consigo todo el MVP, lleno '
            'de su trabajo de cuatro arcos.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Lo abre. Pasa páginas hacia atrás. La página del primer '
            'apunte: "No sabemos cómo se llamaban. Pero sé que '
            'enterraron a alguien que les importaba." Lee. Asiente.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Sigue pasando. Las manos del Pirineo. La cuenta de '
            'Quintiliano. El silencio de tres semanas en Tudela. Joana '
            'de Roncal. La pared medianera de Estella.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Llega a la última página llena. Antes de cerrarlo, '
            'escribe una sola línea más.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto: 'Cuaderno de Aprendiz I. Cerrado el 29 de junio.',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Cierra el cuaderno. Lo guarda en la mochila. Saca el '
            'cuaderno blanco nuevo — el de Cronista. El que Begoña le '
            'ha entregado hace una hora. Lo abre por la primera '
            'página. La página en blanco. Coge el bolígrafo. Escribe.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto: 'Hoy empiezo de cero.',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto: 'No es verdad. No empiezo de cero.',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto: 'Empiezo de aquí.',
        pausaPrevia: Duration(milliseconds: 2000),
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Cierra el cuaderno. Lo guarda. Se levanta. Camina hacia '
            'el despacho de Isaura. La cámara no la sigue. Se queda en '
            'el patio vacío. El sol entra oblicuo. El brocal del pozo. '
            'El capitel del s. XII. El boj en su maceta.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura: 'Tres segundos sin nadie en el patio.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura: 'Aparece flotante: LAS VERSIONES — ARCO 4 — CERRADO.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura: 'Pausa. Aparece: FIN DEL MVP.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 6),
        textoLectura:
            'Maren tiene catorce años recién cumplidos. Su carrera de '
            'Cronista empieza ahora. Lo que pase después — su decisión '
            'sobre Tasio, su trabajo en 1512 cuando llegue la edad, '
            'los nombres de las víctimas que prometió no olvidar, las '
            'preguntas de Naia que tendrá que escuchar — pertenece a '
            'otra historia.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura: 'Gracias por jugar.',
      ),
    ],
  );
}
