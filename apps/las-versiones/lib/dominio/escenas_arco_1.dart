import 'package:nuevo_ser_core/nuevo_ser_core.dart';

import 'ambiente_archivo.dart';
import 'voz_personaje.dart';

/// Catálogo de escenas cinemáticas del Arco 1 (doc 07). Cada escena
/// corresponde a una entrada del guion canónico, condensada para
/// caber en planos del player. Las afirmaciones históricas concretas
/// que aún no están validadas por el comité asesor (doc 16, tracker
/// doc 17) se sustituyen aquí por formulaciones genéricas
/// equivalentes; el guion canónico permanece intacto en los docs.
class EscenasArco1 {
  EscenasArco1._();

  /// Lista ordenada de escenas del Arco 1 disponibles para el
  /// orquestador. El orden importa: cada escena declara sus
  /// `flagsRequeridos` apuntando al `flagDeSalida` de la anterior,
  /// así que el orquestador las dispara en cadena natural.
  ///
  /// La cadena tiene un hueco diegético entre 1.1.2 y 1.1.7: el
  /// bloque jugable de la primera Brecha (1.1.3 a 1.1.6) ocurre
  /// fuera de este catálogo de cinemáticas, gestionado por el
  /// modelo `Brecha` (F4.2). El orquestador (F4.3) decide entre
  /// cinemática y Brecha según los flags activos.
  static const List<EscenaCinematica> todas = [
    laEvaluacion,
    elRecorrido,
    laPrimeraTardeEnCasa,
    caminoAAralar,
    elCampoDeDolmenes,
    elPrimerApunte,
    laMeriendaConEider,
    elAtico,
    cierreCromlechConSira,
    conversacionConElPadre,
    viajeAlPirineo,
    laBocaDeLaCueva,
    dentroDeLaCueva,
    laPared,
    vueltaYSilencio,
    elPrimerConcilioFormal,
    elApunteLargo,
    naiaPregunta,
    viajeAYacimientoIrulegi,
    materialCongelado,
    granConcilio,
    aprendizI,
  ];

  /// Flags institucionales adicionales que el orquestador activa al
  /// cerrar una escena, además del propio `flagDeSalida` y de los
  /// flags concretos que cada [OpcionEleccion] declara. Sirven para
  /// marcar hitos narrativos compartidos —"Maren conoce a Begoña",
  /// "está aceptada como Aspirante"— que no encajan limpiamente como
  /// elección del jugador.
  ///
  /// Cuando el modelo `EscenaCinematica` crezca para llevar este
  /// dato directamente (campo `flagsDeCierre: Set<String>`), este
  /// mapping desaparece. Hoy es la forma menos intrusiva de
  /// extender la plataforma desde el juego.
  static const Map<String, Set<String>> flagsDeCierrePorEscena = {
    'escena_1_0_1_vista': {
      'met_begona',
      'met_isaura',
      'evaluation_passed',
      'accepted_aspirante',
    },
    'escena_1_0_2_vista': {
      'met_andres',
      'met_marina',
      'seen_archivo_interior',
    },
    'escena_1_0_3_vista': {
      'told_family_archive',
      'naia_first_curiosity',
    },
    'escena_1_1_1_vista': {
      'traveling_aralar_first',
    },
    'escena_1_1_2_vista': {
      'aralar_dolmen_alcanzado',
    },
    'escena_1_1_7_vista': {
      'arco_1_estacion_1_cerrada',
    },
    'escena_1_a_vista': {
      'merienda_con_eider_compartida',
    },
    // Cierre de la 1.B encadena con la siguiente Estación. Hasta
    // F8.4 esto activaba `arco_1_completado` directamente (única
    // Brecha implementada era la 1.1, así que tras 1.B venía
    // directamente el Mosaico). Con la Brecha 1.2 en el catálogo,
    // 1.B activa el flag de disparo de la 1.2 y el orquestador
    // abre esa Brecha. El flag de arco completado se mueve al
    // cierre real del arco (1.4.4) cuando entre la Brecha 1.4.
    'escena_1_b_vista': {
      'visita_atico_andres',
      'cromlech_aralar_alcanzado',
    },
    // Cierre de la 1.2.fin (caminata de regreso con Sira) — sólo
    // marca el cierre narrativo de la Estación 2. La Brecha 1.2
    // como tal ya cerró su flag (`brecha_1_2_completada`); la
    // cinemática añade un flag institucional que registra el
    // primer trabajo en equipo de Maren con un par.
    'escena_1_2_fin_vista': {
      'arco_1_estacion_2_cerrada',
      'primer_trabajo_en_equipo_completado',
    },
    // Cinemáticas internas de la Estación 3 (cueva del Pirineo).
    // Las 1.3.1 a 1.3.4 se encadenan por flagDeSalida (cada una
    // requiere la anterior). La 1.3.5 cierra el bloque cinemático
    // y activa `cueva_pirineo_visitada`, que el catálogo
    // (`brechaPorFlagDeDisparo`) reconoce como disparador de la
    // Brecha 1.3 jugable. La 1.3.6 (Concilio formal) y la 1.3.7
    // (apunte largo del Cuaderno) se reproducen tras cerrar la
    // Brecha jugable.
    'escena_1_3_1_vista': {
      'traveling_pyrenees_first',
    },
    'escena_1_3_5_vista': {
      'cueva_pirineo_visitada',
    },
    'escena_1_3_6_vista': {
      'first_formal_concilio',
    },
    'escena_1_b1_vista': {
      'conversacion_con_padre_compartida',
    },
    'escena_1_c_vista': {
      'naia_humanizo_huesos',
    },
    // Cinemáticas de la Estación 4 (Irulegi + Mano). 1.4.1 abre la
    // Estación con la visita al yacimiento; 1.4.2 (material
    // congelado del sitio + Mano en el Museo) cierra con el flag
    // `material_irulegi_recogido` que el catálogo reconoce como
    // disparador de la fase jugable de la Brecha 1.4. La 1.4.3
    // (gran Concilio) se reproduce tras cerrar la Brecha y precede
    // a la 1.4.4 ("Aprendiz I"), que ahora encadena con
    // `escena_1_4_3_vista` en lugar de `brecha_1_4_completada`
    // directamente — la Brecha cierra antes de la 1.4.3 y la
    // promoción de rango llega tras la 1.4.3.
    'escena_1_4_1_vista': {
      'visitado_yacimiento_irulegi',
      'avisada_concilio_entero',
    },
    'escena_1_4_2_vista': {
      'material_irulegi_recogido',
      'mano_irulegi_observada',
    },
    'escena_1_4_3_vista': {
      'gran_concilio_realizado',
    },
    // Cierre del Arco 1 — Maren asciende a Aprendiz I, se anuncia
    // el Arco 2 (Pompaelo) y se activa `arco_1_completado` que
    // dispara el Mosaico. Tras F8.6 esta cinemática se encadena
    // tras la 1.4.3 (gran Concilio); el Mosaico se reproduce a
    // continuación, conservando el orden narrativo del doc 07
    // (§M1 "Activa: tras 1.4, en los días siguientes").
    'escena_1_4_4_vista': {
      'rango_aprendiz_i',
      'arco_2_anunciado',
      'arco_1_completado',
    },
  };

  /// **1.0.1 — La evaluación** (doc 07 §1.0.1).
  ///
  /// Primer arranque del juego tras crear perfil. Maren entra al
  /// Archivo de Iruña, calle Curia, lunes 8 de septiembre, 10:30.
  /// Begoña Aramburu (Directora) y la Constructora mayor Isaura
  /// Iribarren la evalúan. Tres preguntas. Maren es aceptada como
  /// Aspirante.
  ///
  /// Esta v0.1 es lineal: el jugador pulsa para avanzar y elige una
  /// vez ("¿por qué estás aquí?"). El cuestionario completo (las tres
  /// preguntas con material concreto y la hoja en blanco) se condensa
  /// en una secuencia narrativa breve hasta que el comité valide los
  /// puntos pendientes (entrada PIO-BELTRAN del doc 17, foto de 1958
  /// con identificación de personaje histórico).
  ///
  /// Flags de salida que la cierran:
  /// - `met_begona` — Maren conoce a Begoña.
  /// - `met_isaura` — Maren conoce a Isaura.
  /// - `evaluation_passed` — la evaluación está superada.
  /// - `accepted_aspirante` — Maren es Aspirante (rango oficial).
  ///
  /// El `flagDeSalida` agrupa todo bajo `escena_1_0_1_vista` para que
  /// el orquestador no la reproduzca dos veces; los flags concretos
  /// los activan las opciones y el cierre del player.
  static const EscenaCinematica laEvaluacion = EscenaCinematica(
    id: '1.0.1',
    titulo: 'La evaluación',
    flagDeSalida: 'escena_1_0_1_vista',
    ambiente: AmbienteArchivo.salaEvaluacion,
    planos: [
      // Apertura: lectura discreta del contexto temporal y espacial.
      // Sin diálogo todavía — equivalente a "página que respira" del
      // doc 13 §2.1, antes de que entre la primera voz.
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura:
            'Iruña. Calle Curia. Lunes 8 de septiembre, 10:30. '
            'Sala de evaluación del Archivo.',
      ),

      // Primer contacto. Begoña no levanta la vista del expediente.
      // Maren se queda en el umbral.
      PlanoDialogo(
        voz: VozPersonaje.begona,
        texto: 'Maren Lozano.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Sí.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.begona,
        texto: 'Siéntate.',
      ),

      // Encuadre del tema: Maren tiene 13, no 14. Pausa de cinco
      // segundos (las dos mujeres la miran sin prisa).
      PlanoAmbiente(
        duracion: Duration(seconds: 2),
      ),
      PlanoDialogo(
        voz: VozPersonaje.begona,
        texto:
            'Tienes 13 años recién cumplidos. Lo habitual es que los '
            'Aspirantes tengan 14 mínimo.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Lo sé.',
        pausaPrevia: Duration(milliseconds: 600),
      ),

      // La pregunta nuclear de la escena. Es la primera elección que
      // hace el jugador en todo el juego — encarnando el principio
      // del doc 01 v0.2: "el oficio empieza con preguntas, no con
      // respuestas". Cada opción enciende un flag distinto que se
      // recogerá en arcos posteriores cuando aparezca el motivo.
      PlanoEleccion(
        voz: VozPersonaje.begona,
        textoPrompt: '¿Por qué estás aquí?',
        opciones: [
          // Respuesta canónica del guion (doc 07 §1.0.1).
          OpcionEleccion(
            textoJugador:
                'Porque mi madre me contó lo que hacéis. Y porque hace '
                'cuatro años fui a Aralar y no quise irme.',
            flagsAEstablecer: {'motivo_madre_aralar'},
          ),
          OpcionEleccion(
            textoJugador: 'Quiero saber cómo se sabe lo que pasó.',
            flagsAEstablecer: {'motivo_curiosidad_epistemica'},
          ),
          OpcionEleccion(
            textoJugador: 'Mi padre dijo que era buen sitio para empezar.',
            flagsAEstablecer: {'motivo_recomendacion_familiar'},
          ),
          OpcionEleccion(
            textoJugador: 'No lo sé bien.',
            flagsAEstablecer: {'motivo_indeciso'},
          ),
        ],
      ),

      // Reacción de Isaura — la primera vez que habla. Su entrada
      // marca a Maren más que la respuesta literal.
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: 'Mm.',
        pausaPrevia: Duration(milliseconds: 800),
      ),

      // Begoña encuadra las tres pruebas. Lo importante pedagógico
      // está en esta línea — explicita la regla del juego: lo que
      // se evalúa es el modo de pensar, no la respuesta correcta.
      PlanoDialogo(
        voz: VozPersonaje.begona,
        texto:
            'Vamos a hacerte tres preguntas. No buscamos respuestas '
            'correctas. Buscamos cómo respondes.',
        pausaPrevia: Duration(milliseconds: 600),
      ),

      // Resumen narrativo de las tres pruebas. La inscripción romana
      // sin texto literal, la foto de excavación con descripción
      // genérica del director del equipo (entrada PIO-BELTRAN
      // pendiente de validar — doc 17), la hoja en blanco con la
      // pregunta epistémica clave del Archivo: ¿qué NO sabes hacer?
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura:
            'Una inscripción romana fragmentaria. '
            'Una foto en blanco y negro de una excavación. '
            'Una hoja en blanco. Y un bolígrafo.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.begona,
        texto:
            'Quiero que escribas lo que NO sabes hacer. Lo que vienes '
            'a aprender. Cinco minutos.',
      ),

      // Cierre de la prueba — Maren escribe, Isaura lee, Begoña lee.
      // El gesto silencioso de Isaura guardándose el papel doblado
      // en el bolsillo del jersey es lo que más le toca. Aquí va
      // como acotación de lectura porque no es habla, es escena.
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura:
            'Maren escribe. Isaura lee, despacio. Le devuelve el '
            'papel a Begoña. Lo deja sobre la mesa boca abajo.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.begona,
        texto: 'Vamos a deliberar. ¿Te puedes esperar fuera quince minutos?',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 2),
        textoLectura:
            'Maren sale. Isaura coge el papel, lo dobla y se lo guarda '
            'en el bolsillo del jersey. No es protocolo.',
      ),

      // Resolución: aceptación. Esta es la línea que activa los
      // flags definitivos del orquestador.
      PlanoDialogo(
        voz: VozPersonaje.begona,
        texto: 'Aspirante. Te aceptamos.',
        pausaPrevia: Duration(milliseconds: 800),
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: 'Bienvenida, Maren.',
        pausaPrevia: Duration(milliseconds: 600),
      ),
      PlanoDialogo(
        voz: VozPersonaje.begona,
        texto: 'Mañana empiezas. A las nueve. No llegues tarde.',
        pausaPrevia: Duration(milliseconds: 800),
      ),

      // Cierre amable — encarna el principio del doc 01: si necesitas
      // irte, te vas. Maren acaba el primer día agradeciendo y
      // saliendo a la calle. El botón cierra la sesión sin presionar
      // a continuar — la 1.0.2 esperará al día siguiente.
      PlanoCierreAmable(
        textoBoton: 'VOLVER MAÑANA',
      ),
    ],
  );

  /// **1.0.2 — El recorrido** (doc 07 §1.0.2).
  ///
  /// Día siguiente. Maren llega al Archivo a las 8:55. Isaura la
  /// espera en la entrada con el bastón y la guía por el edificio:
  /// planta baja, patio interior, sótanos romanos de Pompaelo,
  /// biblioteca con Aitor de fondo, ático de Andrés, salón del
  /// Concilio, encuentro con Marina en el pasillo. Cierra con un té
  /// compartido en silencio en la cocina del Archivo: Isaura le
  /// anuncia que mañana —su segundo día— sube a Aralar a su primera
  /// Brecha.
  ///
  /// El recorrido cambia varias veces de ambiente; la versión v0.1
  /// del player no anima la transición — cada `PlanoAmbiente` con
  /// nuevo ambiente cumple ese papel de fundido.
  static const EscenaCinematica elRecorrido = EscenaCinematica(
    id: '1.0.2',
    titulo: 'El recorrido',
    flagDeSalida: 'escena_1_0_2_vista',
    flagsRequeridos: {'escena_1_0_1_vista'},
    ambiente: AmbienteArchivo.recorridoArchivo,
    planos: [
      // Encuadre temporal y espacial — Maren llega al Archivo el
      // segundo día, en la entrada espera Isaura.
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura:
            'Día siguiente. 8:55 de la mañana. Maren cruza la puerta '
            'del Archivo. Isaura espera en el portón, con el bastón.',
      ),

      // Apertura del recorrido. Isaura no hace ceremonia.
      PlanoDialogo(voz: VozPersonaje.isaura, texto: 'Maren.'),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Buenos días.'),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: 'Te enseño dónde son las cosas. Cinco minutos.',
      ),

      // Planta baja — sala de evaluación, despacho de Begoña, cocina.
      // La línea sobre la cocina del Archivo encarna el tono general
      // del lugar: nada formal, hazlo tuyo.
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto:
            'Esto es la planta baja. Recepción, despacho de Begoña, '
            'sala de evaluación donde estuviste ayer. La cocina del '
            'Archivo — el café siempre está. Hazlo tuyo.',
      ),

      // Patio interior. La afirmación cronológica concreta sobre los
      // capiteles s. XII y el brocal s. XV cae bajo la entrada
      // EDIFICIO-ARCHIVO pendiente de validar (doc 17). Sustituida
      // por una formulación que preserva el sentido —piezas
      // antiguas reaprovechadas— sin afirmar siglos concretos.
      PlanoAmbiente(
        duracion: Duration(seconds: 2),
        textoLectura: 'Pasan al patio interior.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto:
            'El patio. Los capiteles tienen muchos siglos. El brocal '
            'del pozo, también. Aquí no se tira nada que sirva.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 2),
        textoLectura: 'Maren se para a mirar tres segundos.',
      ),
      PlanoDialogo(voz: VozPersonaje.isaura, texto: 'Sigue.'),

      // Sótano: Pompaelo. La ciudad romana de Pompaelo está validada
      // como entrada en el doc 17 — se puede nombrar.
      PlanoAmbiente(
        duracion: Duration(seconds: 2),
        textoLectura: 'Bajan al sótano.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto:
            'Pompaelo. Esto está debajo del Archivo y debajo de la '
            'calle Curia. La domus que estaba aquí en el siglo I.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura:
            'Mosaico parcialmente conservado. Horno romano. La '
            'cisterna.',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: '¿Esto cómo se mantiene?'),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: 'Buena pregunta. Lo verás más adelante.',
        pausaPrevia: Duration(milliseconds: 600),
      ),

      // Biblioteca primera planta. Aitor encorvado sobre un
      // manuscrito — sólo se le menciona, no habla.
      PlanoAmbiente(
        duracion: Duration(seconds: 2),
        textoLectura:
            'Suben a la biblioteca. Mesas iluminadas. Una persona '
            'mayor encorvada sobre un manuscrito.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: 'Aitor Etxeberri. Constructor. Especialista en el Camino. '
            'Lo conocerás.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 2),
        textoLectura:
            'Aitor levanta la vista. Sonríe brevemente. Maren saluda '
            'con la cabeza. Isaura pasa de largo.',
      ),

      // Ático: Andrés Vidaurre, vitrinas, humor seco.
      PlanoAmbiente(
        duracion: Duration(seconds: 2),
        textoLectura: 'Bajan al ático. Vitrinas con piezas.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.andres,
        texto: 'La nueva. ¿Maren, no?',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Sí.'),
      PlanoDialogo(
        voz: VozPersonaje.andres,
        texto:
            'Yo soy Andrés. El de las cosas. Cuando necesites una '
            'pieza, vienes a verme. Cuando rompas algo, también '
            'vienes a verme, pero con cara de pena.',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Vale.'),
      PlanoDialogo(
        voz: VozPersonaje.andres,
        texto: 'Esta no parece de las que rompen.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: 'Mm. Ya veremos.',
      ),

      // Salón del Concilio. Maren se queda en el umbral. La línea
      // de Isaura sembrando "aquí presentarás tu trabajo cuando
      // llegue el momento" es el primer susurro del Concilio, que
      // será fase 5 de cada Brecha.
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura:
            'Salón del Concilio. Mesa larga. Tres sillones de orejas '
            'en cabecera, vacíos. Maren se queda en la puerta sin '
            'entrar.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: 'Aquí presentarás tu trabajo cuando llegue el momento. No hoy.',
      ),

      // Encuentro con Marina en el pasillo, de vuelta.
      PlanoAmbiente(
        duracion: Duration(seconds: 2),
        textoLectura:
            'Vuelven a la primera planta. En el pasillo se cruzan '
            'con Marina Ríos, 17 años, Aprendiz III.',
      ),
      PlanoDialogo(voz: VozPersonaje.marina, texto: 'Buenos días.'),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: 'Marina, ésta es Maren. Aspirante desde hoy.',
      ),
      PlanoDialogo(voz: VozPersonaje.marina, texto: 'Hola. Bienvenida.'),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Hola.'),
      PlanoDialogo(
        voz: VozPersonaje.marina,
        texto: 'La prueba de Cascante la tengo lista para mañana.',
      ),
      PlanoDialogo(voz: VozPersonaje.isaura, texto: 'Bien. Mañana la vemos.'),
      PlanoAmbiente(
        duracion: Duration(seconds: 2),
        textoLectura: 'Marina sigue su camino. Maren la mira irse.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: 'Marina lleva cuatro años. Es Reformista. Os caeréis bien.',
      ),

      // Cierre del recorrido en la cocina. Té compartido. Isaura
      // anuncia que mañana es la primera Brecha — Aralar.
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura: 'Vuelven a la cocina. Isaura prepara dos tés.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto:
            'Hoy no hacemos nada. Te sientas, lees lo que quieras de '
            'la biblioteca, te familiarizas. Mañana subes a Aralar '
            'conmigo.',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: '¿Mañana?'),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto:
            'Sí. Salimos a las siete. Ropa cómoda. Botas si tienes. '
            'Mañana es tu primera Brecha.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Pensaba que tardaba más.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: 'No se aprende esperando.',
        pausaPrevia: Duration(milliseconds: 800),
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Le pone el té delante. Se sienta enfrente. Beben en '
            'silencio durante un minuto entero. No se acaba nada — '
            'sólo dos personas tomando té.',
      ),

      PlanoCierreAmable(textoBoton: 'IR A CASA'),
    ],
  );

  /// **1.0.3 — La primera tarde en casa** (doc 07 §1.0.3).
  ///
  /// Misma tarde que la 1.0.2. Maren llega al piso familiar en el
  /// Casco Viejo de Iruña. Iratxe, su madre, prepara comida. Naia,
  /// la hermana pequeña, hace las preguntas que abren el oficio.
  /// Antonio, el padre, vuelve del instituto y deja sin más
  /// ceremonia un libro sobre la sierra en la mesa de Maren.
  /// Cierra con la primera entrada del Cuaderno — voz interna de
  /// Maren la noche antes de su primera Brecha.
  ///
  /// El "libro de Beltrán" del guion canónico se sustituye por "el
  /// libro de la sierra" — la entrada PIO-BELTRAN del doc 17 cubre
  /// también la mención bibliográfica al apellido Beltrán hasta que
  /// el comité asesor valide qué autor concreto se referencia.
  static const EscenaCinematica laPrimeraTardeEnCasa = EscenaCinematica(
    id: '1.0.3',
    titulo: 'La primera tarde en casa',
    flagDeSalida: 'escena_1_0_3_vista',
    flagsRequeridos: {'escena_1_0_2_vista'},
    ambiente: AmbienteArchivo.casaMaren,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura:
            'Casco Viejo de Iruña. 14:00. Maren entra a casa. Iratxe '
            'termina de preparar comida. Naia ve dibujos en el salón.',
      ),

      // Madre + Maren. La madre ya conoce el Archivo desde dentro
      // (de cuando hizo "lo del puente" — referencia diegética sin
      // afirmación histórica concreta).
      PlanoDialogo(voz: VozPersonaje.iratxe, texto: '¿Qué tal?'),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Empecé.'),
      PlanoAmbiente(
        duracion: Duration(seconds: 1),
        textoLectura: 'Iratxe deja la sartén. Se gira.',
      ),
      PlanoDialogo(voz: VozPersonaje.iratxe, texto: '¿Ya?'),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Mañana voy a Aralar.'),
      PlanoAmbiente(
        duracion: Duration(seconds: 2),
        textoLectura: 'Iratxe se queda quieta. Algo pasa en su cara.',
      ),
      PlanoDialogo(voz: VozPersonaje.iratxe, texto: '¿Con quién?'),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Con Isaura.'),
      PlanoDialogo(
        voz: VozPersonaje.iratxe,
        texto: 'Bien.',
        pausaPrevia: Duration(milliseconds: 600),
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 1),
        textoLectura: 'Maren empieza a poner la mesa.',
      ),
      PlanoDialogo(voz: VozPersonaje.iratxe, texto: '¿Y? ¿Qué tal Begoña?'),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Seca.'),
      PlanoDialogo(
        voz: VozPersonaje.iratxe,
        texto:
            'Sí. Conmigo también. La conozco de cuando hicimos lo '
            'del puente.',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: '¿Qué puente?'),
      PlanoDialogo(
        voz: VozPersonaje.iratxe,
        texto: 'El romano. Hace años.',
      ),

      // Naia entra. Sus preguntas son lo que da forma a la escena.
      PlanoAmbiente(
        duracion: Duration(seconds: 2),
        textoLectura: 'Naia llega del salón.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.naia,
        texto: 'Maren, ¿hoy te han hecho cronista ya?',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'No. Aspirante.'),
      PlanoDialogo(voz: VozPersonaje.naia, texto: '¿Qué es eso?'),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Lo que va antes.'),
      PlanoDialogo(voz: VozPersonaje.naia, texto: '¿Antes de qué?'),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'De saber.',
        pausaPrevia: Duration(milliseconds: 600),
      ),
      PlanoDialogo(voz: VozPersonaje.naia, texto: 'Pero tú ya sabes cosas.'),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'No las que vienen.'),

      PlanoAmbiente(
        duracion: Duration(seconds: 2),
        textoLectura: 'Iratxe sirve la comida.',
      ),
      PlanoDialogo(voz: VozPersonaje.iratxe, texto: 'Vamos a comer.'),

      // Antonio entra del instituto. Gesto silencioso —besarla en
      // la cabeza— y un libro prometido para la mesa de Maren.
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura:
            'Comen. Conversación normal. Antonio entra del instituto. '
            'Le pone una mano en el pelo a Maren, la besa en la '
            'cabeza, se sienta sin decir nada.',
      ),
      PlanoDialogo(voz: VozPersonaje.antonio, texto: 'Bienvenida.'),
      PlanoAmbiente(
        duracion: Duration(seconds: 2),
        textoLectura: 'Antonio come. A los diez minutos pregunta.',
      ),
      PlanoDialogo(voz: VozPersonaje.antonio, texto: '¿Mañana Aralar?'),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Sí.'),
      PlanoDialogo(
        voz: VozPersonaje.antonio,
        texto: 'Te dejo el libro de la sierra en tu mesa esta tarde.',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Vale.'),

      // La pregunta de Naia. Es el corazón pedagógico de toda la
      // escena: "¿y cómo sabes cómo pasaron?" — pregunta que el
      // juego entero responde, lentamente.
      PlanoAmbiente(
        duracion: Duration(seconds: 2),
        textoLectura: 'Pausa larga. Naia rompe el silencio.',
      ),
      PlanoDialogo(voz: VozPersonaje.naia, texto: '¿Yo puedo ir a Aralar?'),
      PlanoDialogo(voz: VozPersonaje.iratxe, texto: 'Algún día.'),
      PlanoDialogo(voz: VozPersonaje.naia, texto: '¿Cuándo?'),
      PlanoDialogo(voz: VozPersonaje.iratxe, texto: 'Cuando seas más mayor.'),
      PlanoDialogo(
        voz: VozPersonaje.naia,
        texto: 'Maren era más mayor que yo cuando fue.',
      ),
      PlanoDialogo(voz: VozPersonaje.iratxe, texto: 'Sí. Por eso.'),
      PlanoDialogo(voz: VozPersonaje.naia, texto: 'Quiero ser arqueóloga.'),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'No es arqueóloga.',
      ),
      PlanoDialogo(voz: VozPersonaje.naia, texto: '¿Qué es?'),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'No sé bien. Cronista.',
        pausaPrevia: Duration(milliseconds: 800),
      ),
      PlanoDialogo(voz: VozPersonaje.naia, texto: '¿Y qué hace?'),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Cuenta las cosas como pasaron.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 2),
        textoLectura:
            'Naia se queda pensando. Iratxe y Antonio se miran un '
            'segundo.',
      ),
      PlanoDialogo(voz: VozPersonaje.naia, texto: '¿Y cómo sabes cómo pasaron?'),
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura: 'Maren mira a su hermana. Largo silencio.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Ese es el trabajo.',
        pausaPrevia: Duration(milliseconds: 1200),
      ),

      // Tarde en su cuarto. Cuaderno abierto, ventana al castaño.
      // La primera entrada del Cuaderno se renderiza como
      // PlanoAmbiente con texto de lectura — el sistema completo
      // del Cuaderno todavía no existe.
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura:
            'Tarde tranquila. Maren sube a su habitación. En la mesa, '
            'ya, está el libro que su padre prometió. Lo abre. Lee '
            'veinte minutos. Cierra el libro. Mira al castaño del '
            'patio interior por la ventana.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Mañana voy a Aralar. No sé qué tengo que hacer. Isaura '
            'tampoco me lo ha dicho. Quizá ese sea el primer '
            'ejercicio.',
      ),

      PlanoCierreAmable(textoBoton: 'HASTA MAÑANA'),
    ],
  );

  /// **1.1.1 — Camino a Aralar** (doc 07 §1.1.1).
  ///
  /// Día 2, 7:00 de la mañana. Isaura conduce el coche viejo de
  /// Iruña a la sierra. Hora y media de viaje. La conversación
  /// abre tres registros: el cuerpo (Maren ha dormido mal), el
  /// oficio (Isaura cuenta su primera Brecha — fastidió la
  /// datación), y la regla del día (no te explico nada antes; tú
  /// miras, tú formulas; quédate, mira; eso ya es trabajo).
  static const EscenaCinematica caminoAAralar = EscenaCinematica(
    id: '1.1.1',
    titulo: 'Camino a Aralar',
    flagDeSalida: 'escena_1_1_1_vista',
    flagsRequeridos: {'escena_1_0_3_vista'},
    ambiente: AmbienteArchivo.cocheIsaura,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Día 2. 7:00 de la mañana. Isaura conduce despacio. El '
            'paisaje cambia de Iruña a la sierra. Niebla baja, sol '
            'pegando bajo.',
      ),

      PlanoDialogo(voz: VozPersonaje.isaura, texto: '¿Has dormido?'),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Mal.'),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: 'La primera vez se duerme mal.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 2),
        textoLectura: 'Treinta segundos.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: '¿Tú la primera vez también?',
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: 'Yo dormí seis horas porque tenía 28 años.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 1),
        textoLectura: 'Maren sonríe pequeñísimo.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: '¿Qué Brecha hiciste tú la primera vez?',
      ),

      // La anécdota de Isaura sobre fastidiar la datación —
      // pedagógicamente clave: la primera Brecha se puede fastidiar
      // y se puede reabrir. La fiabilidad no nace de no equivocarse,
      // nace de cómo se cierra después.
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto:
            'Una capilla en ruinas en la Sakana. Visigoda, posible. '
            'Resultó que era tardorromana. La fastidié con la datación.',
        pausaPrevia: Duration(milliseconds: 800),
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: '¿Cómo lo descubriste?',
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: 'No yo. El Concilio. Me dieron tres meses para reabrir.',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: '¿Y la reabriste?'),
      PlanoDialogo(voz: VozPersonaje.isaura, texto: 'Sí.'),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: '¿Y la cerraste bien?',
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: 'La cerré mejor. Bien no sé si se cierra alguna.',
        pausaPrevia: Duration(milliseconds: 800),
      ),

      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura:
            'Silencio. Maren mira por la ventana. La sierra de '
            'Aralar empieza a verse. Calizas blancas en lo alto, '
            'hayedos abajo.',
      ),

      // Las instrucciones del día — la regla del oficio que el
      // jugador va a vivir en las cinco fases siguientes.
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto:
            'Hoy no vamos a una Brecha grande. Vamos a una pequeña. '
            'Un dolmen. Te voy a dejar sola un rato.',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Vale.'),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto:
            'No te explico nada antes. Tú miras. Tú formulas. Yo '
            'vuelvo a la hora. Hablamos.',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Vale.'),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto:
            'Si no se te ocurre nada, no pasa nada. Quédate. Mira. '
            'Eso ya es trabajo.',
        pausaPrevia: Duration(milliseconds: 600),
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura:
            'Maren asiente. Silencio largo durante el resto del '
            'trayecto.',
      ),

      PlanoCierreAmable(textoBoton: 'BAJAR DEL COCHE'),
    ],
  );

  /// **1.1.2 — El campo de dólmenes** (doc 07 §1.1.2).
  ///
  /// Llegada al campo. Isaura señala el dolmen asignado a Maren
  /// —marcado con poste y código— y le pasa una carpeta con tres
  /// informes de excavaciones anteriores. Le anuncia que vuelve a
  /// las once. Maren se queda sola con el dolmen, el cuaderno y
  /// la carpeta.
  ///
  /// Esta cinemática cierra el primer bloque y cede el turno al
  /// **bloque jugable de la Brecha 1.1** (fases 1.1.3 a 1.1.6 del
  /// guion canónico, que en el código viven como las cinco fases
  /// del modelo `Brecha`, no como cinemáticas).
  static const EscenaCinematica elCampoDeDolmenes = EscenaCinematica(
    id: '1.1.2',
    titulo: 'El campo de dólmenes',
    flagDeSalida: 'escena_1_1_2_vista',
    flagsRequeridos: {'escena_1_1_1_vista'},
    ambiente: AmbienteArchivo.dolmenAralar,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Aparcan en una pista forestal. Bajan del coche. Maren '
            'lleva el cuaderno, una mochila pequeña, y una libreta '
            'de campo aparte que Isaura le ha dado. Caminan diez '
            'minutos por una vereda.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Aparece el primer dolmen entre la hierba alta. Después '
            'otro. Después tres más. Maren se para.',
      ),

      PlanoDialogo(voz: VozPersonaje.maren, texto: '¿Cuántos hay?'),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto:
            'En este campo, quince catalogados. En toda Aralar, más '
            'de cien.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura:
            'Maren mira alrededor. Silencio del paisaje. Viento. '
            'Una oveja muy lejos.',
      ),

      // Isaura señala el dolmen asignado y le explica por qué ése.
      // Las menciones a "una excavación de los años 70" y "una de
      // los años 2010" sustituyen las referencias canónicas a Pío
      // Beltrán 1973 y revisión 2018 (entrada PIO-BELTRAN del doc
      // 17 pendiente de validar; las décadas son plausibles para
      // el período arqueológico real de Aralar).
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: 'El tuyo es ése.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 2),
        textoLectura:
            'Señala un dolmen mediano, parcialmente excavado, '
            'marcado con un poste de madera y un código.',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: '¿Por qué ése?'),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto:
            'Porque tiene fuentes que puedes consultar y porque no '
            'te van a venir colegas a interrumpir. Una excavación de '
            'los años 70 lo sondeó, una más reciente lo revisó. Hay '
            'tres informes en el Archivo. Te los he traído.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 2),
        textoLectura: 'Le pasa una carpeta delgada.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: 'Léelos cuando quieras. No tienes que leerlos antes.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 2),
        textoLectura: 'Maren coge la carpeta. Mira el dolmen.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: 'Te dejo. Vuelvo a las once.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Isaura camina de vuelta hacia el coche. Maren la mira '
            'irse. Después mira el dolmen. Se sienta en una piedra. '
            'Saca el cuaderno. Lo abre.',
      ),

      // El cierre da paso al bloque jugable. El botón "EMPEZAR" no
      // termina la sesión — encadena con la primera fase de la
      // Brecha que el orquestador debe abrir.
      PlanoCierreAmable(textoBoton: 'EMPEZAR'),
    ],
  );

  /// **1.1.7 — El primer apunte** (doc 07 §1.1.7).
  ///
  /// Esa noche. Maren en su habitación con el cuaderno abierto.
  /// Voz interna que cierra la primera Estación: "no sabemos cómo
  /// se llamaban, pero sé que enterraron a alguien que les
  /// importaba".
  ///
  /// Esta escena requiere `brecha_1_1_completada` — el orquestador
  /// no la dispara hasta que el jugador haya terminado las cinco
  /// fases de la Brecha 1.1 (F6).
  static const EscenaCinematica elPrimerApunte = EscenaCinematica(
    id: '1.1.7',
    titulo: 'El primer apunte',
    flagDeSalida: 'escena_1_1_7_vista',
    flagsRequeridos: {'brecha_1_1_completada'},
    ambiente: AmbienteArchivo.cuartoCasaMaren,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Esa noche. Maren en su habitación. El cuaderno abierto '
            'en la mesa. La luz de la mesa encendida. La ventana '
            'muestra el castaño del patio interior, recortado contra '
            'el cielo oscuro.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'No sabemos cómo se llamaban. Pero sé que enterraron a '
            'alguien que les importaba.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura: 'Eso es lo que aprendí hoy.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura:
            'Maren cierra el cuaderno. Apaga la luz. La habitación '
            'queda oscura.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura: 'ESTACIÓN 1 — CERRADA',
      ),

      PlanoCierreAmable(textoBoton: 'HASTA MAÑANA'),
    ],
  );

  /// **1.A — La merienda con Eider** (doc 07 §1.A).
  ///
  /// Día de Archivo, ~3 días después de cerrar la Estación 1.
  /// Cafetería pequeña del Casco Viejo. Maren y Eider, su amiga
  /// del instituto. Naia está en su clase de baloncesto. Eider
  /// pregunta por el dolmen. Maren cuenta poco — pequeñas cosas:
  /// las dos fechas que no terminan de cuadrar, la sensación de
  /// no saber los nombres. Eider escucha. Cierra con un
  /// reconocimiento amable: "tía, eres rara, pero vale".
  ///
  /// Pedagógicamente clave: el oficio histórico no se queda dentro
  /// del Archivo. Maren tiene que poder contarlo a alguien que no
  /// está en él, y reconocerse rara sin avergonzarse. El principio
  /// narrativo 1.11 del doc 06 ("la adolescencia es real") vive
  /// aquí: la conversación cierra cambiando de tema al instituto,
  /// como cualquier merienda.
  ///
  /// **Sustitución diegética activa** (entrada ARALAR-DATACIONES de
  /// BLOQUEOS-PENDIENTES.md): el guion canónico dice "las dos
  /// dataciones" en boca de Maren. Aquí se sustituye por "las dos
  /// fechas" — léxico adolescente más natural que tampoco afirma
  /// laboratorio o autor concreto del C14.
  static const EscenaCinematica laMeriendaConEider = EscenaCinematica(
    id: '1.A',
    titulo: 'La merienda con Eider',
    flagDeSalida: 'escena_1_a_vista',
    flagsRequeridos: {'escena_1_1_7_vista'},
    ambiente: AmbienteArchivo.cafeteriaCascoViejo,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Cafetería pequeña del Casco Viejo. Tarde. Maren y Eider en '
            'una mesa al fondo. Naia está en su clase de baloncesto. '
            'Eider come un cruasán.',
      ),

      // Eider abre — directa, como siempre.
      PlanoDialogo(voz: VozPersonaje.eider, texto: 'Bueno. Cuéntamelo.'),
      PlanoDialogo(voz: VozPersonaje.maren, texto: '¿Qué?'),
      PlanoDialogo(
        voz: VozPersonaje.eider,
        texto: 'Lo del dolmen. Llevas tres días con cara rara.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'No tengo cara rara.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.eider,
        texto:
            'Tienes la cara que pones cuando estás dándole vueltas a '
            'algo. La conozco.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 1),
        textoLectura: 'Maren bebe.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Es difícil.',
        pausaPrevia: Duration(milliseconds: 600),
      ),
      PlanoDialogo(voz: VozPersonaje.eider, texto: '¿Difícil de qué?'),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Difícil de saber qué es difícil.',
        pausaPrevia: Duration(milliseconds: 800),
      ),
      PlanoDialogo(
        voz: VozPersonaje.eider,
        texto: 'Tía. Habla en cristiano.',
      ),

      // Resumen narrativo de lo que Maren cuenta. La frase del
      // guion canónico "las dos dataciones" se sustituye por "las
      // dos fechas" (entrada ARALAR-DATACIONES — no afirmar
      // laboratorio o autor del C14). Eider escucha sin
      // interrumpir, lo que pedagógicamente es lo que importa.
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Pausa. Maren empieza a contar. Pequeñas cosas. Las dos '
            'fechas que no terminan de cuadrar. La sensación de no '
            'saber los nombres. La carpeta con tres informes. La hora '
            'sola con el dolmen. Eider escucha sin interrumpir.',
      ),

      // El reconocimiento — la pregunta clave de la escena.
      PlanoDialogo(voz: VozPersonaje.eider, texto: '¿Y eso te parece guay?'),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Sí.',
        pausaPrevia: Duration(milliseconds: 1200),
      ),
      PlanoDialogo(
        voz: VozPersonaje.eider,
        texto: 'Vale. Eres rara, pero vale.',
        pausaPrevia: Duration(milliseconds: 600),
      ),

      // La adolescencia es real — cierran cambiando de tema al
      // instituto. Esto NO se desarrolla aquí; basta con la
      // acotación.
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Se ríen. Cambian de tema. Hablan del instituto: del de '
            'mates que pone exámenes raros, de quién va al curso de '
            'verano. Una merienda normal de tarde de jueves.',
      ),

      PlanoCierreAmable(textoBoton: 'PAGAR Y SALIR'),
    ],
  );

  /// **1.B — El ático** (doc 07 §1.B).
  ///
  /// Día de Archivo, ~5-7 días después de cerrar la Estación 1.
  /// Maren sube al ático del Archivo buscando un informe antiguo
  /// del dolmen. Andrés está en su mesa, ordenando cerámica
  /// fragmentaria. Le indica dónde está el informe sin levantarse,
  /// y aprovecha para hacerle una pregunta que parece menor pero
  /// no lo es.
  ///
  /// La línea pedagógicamente clave de la escena es la respuesta
  /// de Maren: "tiene cosas raras, pero también tiene cosas que
  /// no las tendríamos sin él". Es la primera vez que la Cronista
  /// articula la postura del oficio frente a fuentes con sesgo —
  /// reconocer las contribuciones sin tragarse los sesgos. Andrés
  /// la valida con un "vas bien" mínimo.
  ///
  /// **Sustitución diegética activa** (entrada PIO-BELTRAN de
  /// BLOQUEOS-PENDIENTES.md): el guion canónico nombra
  /// explícitamente "Beltrán" tanto en el archivador físico ("el
  /// informe de Beltrán de 1973") como en la pregunta de Andrés
  /// ("¿qué te parece Beltrán?"). Aquí se sustituye por "el
  /// informe antiguo del dolmen" y "¿qué te parece el informe?",
  /// preservando la pedagogía sin afirmar autoría hasta que el
  /// comité asesor (doc 16) valide.
  static const EscenaCinematica elAtico = EscenaCinematica(
    id: '1.B',
    titulo: 'El ático',
    flagDeSalida: 'escena_1_b_vista',
    flagsRequeridos: {'escena_1_a_vista'},
    ambiente: AmbienteArchivo.aticoArchivo,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Ático del Archivo. Vitrinas con piezas. Andrés sentado a '
            'su mesa, ordenando una caja con cerámica fragmentaria. '
            'Maren sube las escaleras y aparece en la puerta.',
      ),

      PlanoDialogo(
        voz: VozPersonaje.andres,
        texto: 'Ah, la nueva. ¿Qué buscas?',
      ),

      // Sustitución diegética: el informe canónico es "el de
      // Beltrán de 1973" (entrada PIO-BELTRAN del doc 17). Aquí
      // queda como "el informe antiguo del dolmen" — preserva la
      // función dramática (Maren va a buscar un informe concreto
      // tras el aprendizaje de la 1.1) sin afirmar autoría.
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'El informe antiguo del dolmen.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.andres,
        texto:
            'Estantería tres, cuarta balda, archivador beige. Cuidado '
            'al cogerlo, está pegado al de al lado.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Maren va a buscarlo. Lo coge, despacio, despegándolo del '
            'archivador vecino. Vuelve hacia la salida.',
      ),

      // La pregunta de Andrés. Esta es la línea pedagógica de la
      // escena — el guion canónico dice "¿qué te parece Beltrán?",
      // sustituido aquí por "¿qué te parece el informe?". La
      // respuesta de Maren preserva la postura del oficio.
      PlanoDialogo(
        voz: VozPersonaje.andres,
        texto: '¿Qué te parece el informe?',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 2),
        textoLectura: 'Maren se para.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Tiene cosas raras.',
        pausaPrevia: Duration(milliseconds: 600),
      ),
      PlanoDialogo(
        voz: VozPersonaje.andres,
        texto: 'Mm.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Pero también tiene cosas que no las tendríamos sin él.',
        pausaPrevia: Duration(milliseconds: 1000),
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 2),
        textoLectura: 'Andrés levanta la vista una vez. Sonríe pequeño.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.andres,
        texto: 'Vas bien.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura:
            'Maren se va con el archivador bajo el brazo. Andrés vuelve '
            'a su cerámica.',
      ),

      PlanoCierreAmable(textoBoton: 'BAJAR'),
    ],
  );

  /// **1.2.fin — Cierre del crómlech con Sira** (doc 07 §1.2,
  /// "Cierre escena").
  ///
  /// Maren y Sira terminan el Concilio de la Estación 2 (Aitor como
  /// revisor — aprueba la versión cauta, Sira encaja). Caminan
  /// juntas hacia el coche de regreso por la pista forestal de
  /// Aralar. Sira reconoce que Maren tenía razón al frenarla;
  /// Maren responde que no siempre la tendrá. Sira sonríe y dice
  /// "ya, pero hoy sí". Caminan sin más. La voz del Cuaderno
  /// cierra la escena con la entrada de esa noche: "Sira es buena.
  /// Va más rápida que yo. No sé si eso es bueno o malo. Hoy ha
  /// sido bueno que yo fuera más despacio. Mañana puede ser al
  /// revés."
  ///
  /// Pedagógicamente clave: la primera vez que Maren ejerce
  /// autoridad de oficio aunque sea menor en rango — porque la
  /// cautela está bien fundada. Sira, dos años mayor y un escalón
  /// por encima en jerarquía, lo reconoce. La negociación entre
  /// pares es el corazón pedagógico de la Estación 2 y queda
  /// articulada aquí en una sola línea. La voz del Cuaderno
  /// (segunda parte) explicita la lección sin convertirla en
  /// regla rígida — mañana puede ser al revés.
  ///
  /// **Anclada al cierre de la Brecha 1.2**: requiere
  /// `brecha_1_2_completada`. Como la Brecha 1.2 entra al catálogo
  /// con esta misma F8.4, el orquestador la dispara
  /// inmediatamente tras cerrar el Concilio de la 1.2.
  ///
  /// **Sin sustituciones diegéticas**: el doc 07 no nombra fechas,
  /// laboratorios ni autores en esta cinemática.
  static const EscenaCinematica cierreCromlechConSira = EscenaCinematica(
    id: '1.2.fin',
    titulo: 'Cierre del crómlech con Sira',
    flagDeSalida: 'escena_1_2_fin_vista',
    flagsRequeridos: {'brecha_1_2_completada'},
    ambiente: AmbienteArchivo.cromlechAralar,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Aitor ha cerrado el Concilio. Aprobada la versión '
            'cauta. Sira encaja, sin dramatismo. Las dos salen del '
            'salón y caminan hacia el coche por la pista forestal '
            'de Aralar. Tarde alta, sol horizontal entre los '
            'hayedos.',
      ),

      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura: 'Caminan dos minutos sin hablar.',
      ),

      // El reconocimiento. Sira, mayor y un escalón por encima en
      // jerarquía, valida que Maren tuvo razón al frenarla.
      PlanoDialogo(voz: VozPersonaje.sira, texto: 'Tenías razón.'),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'No siempre la tendré.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.sira,
        texto: 'Ya. Pero hoy sí.',
        pausaPrevia: Duration(milliseconds: 600),
      ),

      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura:
            'Caminan. Sin más. Llegan al coche. Sira conduce de '
            'vuelta — el viaje pasa en silencio cómodo.',
      ),

      // Voz del Cuaderno esa noche. El doc 07 la marca como bloque
      // del cierre de la 1.2. Se renderiza como ambiente de
      // lectura en cursiva (la voz interna se diferencia
      // tipográficamente del diálogo). El sistema actual del
      // Cuaderno se construye con entradas registradas al cerrar
      // cinemáticas — la entrada concreta para esta noche se
      // catalogará en `CatalogoCuaderno` aparte si se decide
      // hacerla persistente.
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Esa noche. Cuaderno abierto en la mesa. La luz de la '
            'lámpara baja. Maren escribe.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 6),
        textoLectura:
            'Sira es buena. Va más rápida que yo. No sé si eso es '
            'bueno o malo. Hoy ha sido bueno que yo fuera más '
            'despacio.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura: 'Mañana puede ser al revés.',
      ),

      PlanoCierreAmable(textoBoton: 'CERRAR EL CUADERNO'),
    ],
  );

  /// **1.B.1 — Conversación con el padre** (doc 07 §1.B.1).
  ///
  /// Día de Archivo, ~10-12 días después de cerrar la Estación 2.
  /// Antonio en la cocina, leyendo. Maren entra a por agua.
  /// Antonio le devuelve a Maren la frase que ella misma había
  /// dicho a Naia ("el oficio cuenta las cosas como pasaron") y
  /// la corrige: no es como pasaron, es como pueden haber pasado,
  /// con la mejor honestidad posible. Maren llega sola a esa
  /// formulación. Antonio asiente y vuelve al libro.
  ///
  /// Pedagógicamente clave: la diferencia entre realismo ingenuo
  /// ("contar cómo pasaron") y oficio histórico ("contar cómo
  /// pueden haber pasado, con la mejor honestidad posible") la
  /// articula la propia Cronista. Es la primera vez que Maren
  /// pone palabras al núcleo epistémico del oficio. Antonio le
  /// hace de espejo, no le da la respuesta.
  ///
  /// **Anclada a la Estación 2**: requiere `brecha_1_2_completada`.
  /// Hoy esa Brecha no está implementada en el catálogo del juego,
  /// así que esta escena queda latente — el orquestador no la
  /// disparará hasta que entre la 1.2 al catálogo. Mismo patrón
  /// que la 1.1.7 mantuvo durante la fase del esqueleto antes de
  /// que existiera la Brecha 1.1 jugable.
  ///
  /// Sin contenido histórico que sustituir — el guion no nombra
  /// fechas, lugares ni autores concretos.
  static const EscenaCinematica conversacionConElPadre = EscenaCinematica(
    id: '1.B.1',
    titulo: 'Conversación con el padre',
    flagDeSalida: 'escena_1_b1_vista',
    flagsRequeridos: {'brecha_1_2_completada'},
    ambiente: AmbienteArchivo.cocinaCasaMaren,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Día de Archivo, dos semanas después de la Estación 2. '
            'Tarde tranquila. Antonio en la cocina, leyendo en la '
            'mesa con un vaso de agua a un lado. Maren entra a por '
            'agua de la nevera.',
      ),

      PlanoDialogo(voz: VozPersonaje.antonio, texto: '¿Cómo va?'),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Bien.'),

      PlanoAmbiente(
        duracion: Duration(seconds: 1),
        textoLectura: 'Antonio no levanta la vista del libro.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.antonio,
        texto: 'He estado pensando en lo que dijiste.',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: '¿Qué dije?'),
      PlanoDialogo(
        voz: VozPersonaje.antonio,
        texto: 'Lo de que el oficio cuenta las cosas como pasaron.',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Sí.'),
      PlanoAmbiente(
        duracion: Duration(seconds: 1),
        textoLectura: 'Antonio cierra el libro.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.antonio,
        texto: 'No es como pasaron.',
      ),

      // El silencio aquí es trabajo. Maren tiene que llegar sola.
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Ya. Ya lo sé.',
        pausaPrevia: Duration(milliseconds: 1000),
      ),
      PlanoDialogo(
        voz: VozPersonaje.antonio,
        texto: '¿Qué es entonces?',
      ),

      // Pausa larga. Maren articula la postura epistémica del oficio.
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Como pueden haber pasado, con la mejor honestidad posible.',
        pausaPrevia: Duration(milliseconds: 1500),
      ),

      PlanoAmbiente(
        duracion: Duration(seconds: 2),
        textoLectura: 'Antonio asiente despacio.',
      ),
      PlanoDialogo(voz: VozPersonaje.antonio, texto: 'Mejor.'),
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura:
            'Vuelve a abrir el libro. Maren bebe el agua. Sale de la '
            'cocina. La conversación cabe en un minuto.',
      ),

      PlanoCierreAmable(textoBoton: 'SALIR DE LA COCINA'),
    ],
  );

  /// **1.3.1 — Viaje al Pirineo** (doc 07 §1.3.1).
  ///
  /// ~3 semanas tras inicio del juego. Coche de Isaura camino de la
  /// cueva en el Pirineo navarro. Niebla baja en los hayedos.
  /// Isaura le anuncia que hoy NO formulan preguntas antes de
  /// entrar — para algunas Brechas la primera lectura es del
  /// cuerpo, no de la cabeza. Cuando salgan, formularán. Le da
  /// permiso a Maren para decirle si se pone nerviosa dentro.
  /// "Los grabados están allí desde hace trece mil años. Pueden
  /// esperar otros diez minutos."
  ///
  /// Pedagógicamente clave: el oficio histórico no siempre
  /// arranca con preguntas explícitas. A veces la primera lectura
  /// es sensorial — entrar, mirar, dejar que el lugar hable, y
  /// formular después. Maren aprende a respetar ese ritmo.
  ///
  /// Sin sustituciones diegéticas — el doc 07 no nombra
  /// laboratorio ni publicación específica para los "trece mil
  /// años"; la datación es coherente con el rango canónico
  /// validado del Magdaleniense para el Pirineo navarro.
  static const EscenaCinematica viajeAlPirineo = EscenaCinematica(
    id: '1.3.1',
    titulo: 'Viaje al Pirineo',
    flagDeSalida: 'escena_1_3_1_vista',
    flagsRequeridos: {'escena_1_b1_vista'},
    ambiente: AmbienteArchivo.cocheIsaura,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Tres semanas dentro del oficio. Coche de Isaura. '
            'Carretera al Pirineo navarro. Niebla baja en los '
            'hayedos, sol que pega de lado. El coche sube despacio.',
      ),

      PlanoDialogo(voz: VozPersonaje.isaura, texto: 'Hoy vamos a una cueva.'),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Lo sé.'),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto:
            'Hay grabados. Hechos en la piedra. Bisontes, un ciervo, '
            'un caballo.',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: '¿Pintura?'),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto:
            'Grabados. Líneas en la piedra hechas con herramienta. '
            'Apenas se ven a primera vista. Tienes que mirar despacio.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Los he visto en libros.',
        pausaPrevia: Duration(milliseconds: 600),
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: 'Hoy los vas a ver con una linterna. Es distinto.',
      ),

      // La regla del día — la primera lectura es del cuerpo.
      PlanoAmbiente(
        duracion: Duration(seconds: 2),
        textoLectura: 'Pausa.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: 'Hoy no formulamos preguntas antes. Hoy entramos primero.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: '¿Por qué?',
        pausaPrevia: Duration(milliseconds: 400),
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto:
            'Porque para algunas Brechas, la primera lectura es del '
            'cuerpo, no de la cabeza. Cuando salgamos, formularemos.',
      ),

      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura:
            'Maren mira por la ventana. No contesta.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: 'Si te pones nerviosa allí dentro, me lo dices.',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Vale.'),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto:
            'No es ningún examen. Es una cueva. Los grabados están '
            'allí desde hace trece mil años. Pueden esperar otros '
            'diez minutos.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura: 'Maren sonríe pequeñísimo. Llegan al aparcamiento.',
      ),

      PlanoCierreAmable(textoBoton: 'BAJAR DEL COCHE'),
    ],
  );

  /// **1.3.2 — La boca de la cueva** (doc 07 §1.3.2).
  ///
  /// Bosque de hayas en la entrada al sistema de cuevas. Joxe, el
  /// custodio del valle vinculado a la administración foral,
  /// saluda con un asentimiento. "Cuarenta minutos máximo aquí.
  /// Después os abro la otra." Isaura le pasa a Maren un casco
  /// con linterna y le advierte: la linterna alcanza tres metros,
  /// no se separe más de eso. Esta primera cueva es donde vivían
  /// (covacho de habitación). La de los grabados está cerca pero
  /// separada — la gente del Magdaleniense las usaba para distintas
  /// cosas.
  static const EscenaCinematica laBocaDeLaCueva = EscenaCinematica(
    id: '1.3.2',
    titulo: 'La boca de la cueva',
    flagDeSalida: 'escena_1_3_2_vista',
    flagsRequeridos: {'escena_1_3_1_vista'},
    ambiente: AmbienteArchivo.bosqueHayas,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Aparcamiento pequeño en un bosque de hayas. Caminata de '
            'quince minutos por sendero hasta una primera entrada en '
            'la ladera, custodiada por una verja oxidada. Un hombre '
            'mayor con cazadora — el custodio del valle — saluda con '
            'un asentimiento.',
      ),

      PlanoDialogo(
        voz: VozPersonaje.joxe,
        texto: 'Cuarenta minutos máximo aquí. Después os abro la otra.',
      ),
      PlanoDialogo(voz: VozPersonaje.isaura, texto: 'Gracias, Joxe.'),

      PlanoAmbiente(
        duracion: Duration(seconds: 2),
        textoLectura:
            'Isaura le pasa un casco con linterna a Maren. Coge otro '
            'para sí.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto:
            'Va a ser oscuro. La linterna alcanza tres metros. No te '
            'separes de mí más de eso.',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Vale.'),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto:
            'Esta primera es donde vivían. Comían, dormían, '
            'encendían fuego. La de los grabados está cerca, '
            'separada. La gente del Magdaleniense las usaba para '
            'distintas cosas.',
      ),
      PlanoDialogo(voz: VozPersonaje.isaura, texto: '¿Lista?'),
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura:
            'Maren asiente. Entran. La luz natural se acaba a los '
            'cuatro metros.',
      ),

      PlanoCierreAmable(textoBoton: 'ENTRAR DESPACIO'),
    ],
  );

  /// **1.3.3 — Dentro** (doc 07 §1.3.3).
  ///
  /// Covacho de habitación: amplio, embocadura grande, luz residual
  /// los primeros metros, después oscuridad. Marcas de hoguera —
  /// concentración de carbón vegetal antiguo, fragmentos óseos.
  /// Isaura explica el inventario arqueológico (arpones,
  /// herramientas líticas, fauna, hace algo más de trece mil años).
  /// Maren pregunta si puede tocar; Isaura dice no. Salen y caminan
  /// a la segunda entrada, más estrecha, que el custodio abre con
  /// llave. Bajan hacia la sala con grabados. Pasan junto a dos
  /// grandes losas que cierran parcialmente el paso, claramente
  /// emplazadas en tiempos antiguos posteriores. "¿Para qué son?"
  /// "No se sabe. Las pusieron mucho después de los grabados."
  static const EscenaCinematica dentroDeLaCueva = EscenaCinematica(
    id: '1.3.3',
    titulo: 'Dentro',
    flagDeSalida: 'escena_1_3_3_vista',
    flagsRequeridos: {'escena_1_3_2_vista'},
    ambiente: AmbienteArchivo.cuevaInterior,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Covacho de habitación. Embocadura amplia, luz que entra '
            'del exterior los primeros metros, después oscuridad. '
            'Sonido amortiguado, propio de cueva. Goteo lejano. '
            'Caminan despacio, Isaura primero, Maren detrás.',
      ),

      PlanoDialogo(voz: VozPersonaje.isaura, texto: 'Mira al suelo aquí.'),
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura:
            'Maren ilumina el suelo. Concentración de carbón vegetal '
            'antiguo, marcas de un fuego. Un fragmento blanco — hueso '
            'o asta.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto:
            'Hoguera. Aquí han excavado durante décadas. Han '
            'encontrado arpones, herramientas líticas, restos de '
            'fauna. La cocina, el dormir, las herramientas — todo '
            'aquí. Hace algo más de trece mil años.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: '¿Puedo tocar?',
        pausaPrevia: Duration(milliseconds: 600),
      ),
      PlanoDialogo(voz: VozPersonaje.isaura, texto: 'No.'),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Vale.'),

      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura:
            'Isaura le hace una seña hacia una pared lateral.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto:
            'Los que vivían aquí no grababan en estas paredes. Aquí '
            'era para vivir. La pared para los grabados es otra.',
      ),

      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Salen del covacho. La luz de fuera duele un segundo. '
            'Joxe ha venido caminando con una llave grande. Caminan '
            'unos doscientos metros por el sendero a una segunda '
            'entrada — más estrecha, oculta entre la hojarasca. Joxe '
            'abre.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.joxe,
        texto: 'Las losas siguen igual.',
      ),
      PlanoDialogo(voz: VozPersonaje.isaura, texto: 'Ya las veré.'),

      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Entran. La cueva es distinta — más estrecha, más '
            'profunda, sin luz natural más allá de los primeros '
            'metros. Bajan despacio durante cinco minutos. Maren '
            'respira más fuerte. Pasan junto a dos grandes losas que '
            'cierran parcialmente el paso. Las losas están movidas '
            'hacia un lado pero claramente fueron emplazadas allí '
            'en tiempos antiguos para sellar.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: '¿Para qué son?',
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto:
            'No se sabe. Las pusieron mucho después de los grabados. '
            'Posiblemente para cerrar la sala. Por qué exactamente — '
            'lo decidirás tú si llegas a esa Brecha algún día.',
        pausaPrevia: Duration(milliseconds: 800),
      ),

      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Pasan las losas. La cueva se ensancha en una sala de '
            'techos altos. El sonido aquí es distinto — más resonante.',
      ),
      PlanoDialogo(voz: VozPersonaje.isaura, texto: 'Aquí.'),

      PlanoCierreAmable(textoBoton: 'ENCENDER LA LINTERNA'),
    ],
  );

  /// **1.3.4 — La pared** (doc 07 §1.3.4).
  ///
  /// Sala con grabados parietales. La luz de la linterna se mueve
  /// despacio. Al principio sólo piedra. Después, donde la luz pega
  /// oblicua, las líneas aparecen: bisonte, ciervo, cabeza de uro,
  /// caballo. Maren pregunta cómo y cuándo se hicieron. La pregunta
  /// nuclear de la escena: "¿por qué grabar algo donde no lo va a
  /// ver nadie a la luz del día?". Isaura responde "esa es la
  /// pregunta". Maren mira la pared cuatro minutos en silencio. En
  /// algún momento pone la mano abierta cerca del bisonte sin
  /// tocarlo — compara su mano con la línea grabada.
  ///
  /// Esta cinemática es deliberadamente lenta. La pedagogía exige
  /// silencios largos: el oficio empieza cuando el aprendiz se
  /// queda con el lugar sin necesidad de explicarlo.
  static const EscenaCinematica laPared = EscenaCinematica(
    id: '1.3.4',
    titulo: 'La pared',
    flagDeSalida: 'escena_1_3_4_vista',
    flagsRequeridos: {'escena_1_3_3_vista'},
    ambiente: AmbienteArchivo.salaGrabadosParietales,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 6),
        textoLectura:
            'Sala con grabados. La luz de la linterna de Maren se '
            'mueve despacio. Al principio no se ve nada — sólo piedra. '
            'Maren mueve la linterna en distintos ángulos.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 6),
        textoLectura:
            'Después, lentamente, las líneas aparecen. Donde la luz '
            'pega oblicua, los grabados se hacen visibles. Un '
            'bisonte — perfilado, perfectamente reconocible. Un '
            'ciervo más arriba. Una cabeza de uro. Y, hacia un lado, '
            'lo que parece la parte trasera de un caballo.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Maren no dice nada durante mucho tiempo. La cara, '
            'iluminada por debajo por la linterna que sostiene. '
            'Ojos abiertos. Una expresión quieta — no asombro '
            'espectacular, algo más recogido.',
      ),

      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: '¿Cómo lo hicieron?',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto:
            'Con una piedra afilada o un trozo de hueso. Marcaron la '
            'línea, la repasaron, la profundizaron. La luz natural '
            'no llega hasta aquí. Lo hicieron con luz de fuego — '
            'antorcha o lámpara de grasa.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: '¿Cuánto tiempo lleva eso allí?',
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: 'Trece mil años, aproximadamente. Magdaleniense '
            'Inferior o Medio.',
      ),

      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura: 'Silencio largo.',
      ),

      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto:
            'No se ven a la luz natural. Hay que entrar hasta aquí. '
            'Con luz que se traen.',
      ),
      PlanoDialogo(voz: VozPersonaje.isaura, texto: 'Sí.'),

      // La pregunta nuclear de la escena.
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto:
            '¿Por qué grabar algo donde no lo va a ver nadie a la luz '
            'del día?',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: 'Esa es la pregunta.',
      ),

      PlanoAmbiente(
        duracion: Duration(seconds: 2),
        textoLectura: 'Pausa.',
      ),

      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: '¿Sabemos la respuesta?',
      ),
      PlanoDialogo(voz: VozPersonaje.isaura, texto: 'No.'),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: '¿Tenemos hipótesis?',
        pausaPrevia: Duration(milliseconds: 600),
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: 'Muchas. Ninguna confirmada.',
      ),

      // Silencio recogido. El haz de luz se mueve sobre la pared.
      PlanoAmbiente(
        duracion: Duration(seconds: 6),
        textoLectura:
            'La luz se queda en la pared. Maren no se mueve durante '
            'un minuto entero. El bisonte aparece y desaparece del '
            'haz de luz. La cabeza del uro. El caballo.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: '¿Estás bien?',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Sí.'),
      PlanoDialogo(voz: VozPersonaje.isaura, texto: '¿Te quedas un poco más?'),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Sí.'),

      // El gesto de comparar la mano. La cámara no enfatiza.
      PlanoAmbiente(
        duracion: Duration(seconds: 7),
        textoLectura:
            'Isaura se aparta dos pasos. Maren mira los grabados '
            'cuatro minutos sin hablar. Sólo el sonido de la cueva. '
            'En algún momento detiene la linterna. Pone la mano '
            'abierta cerca del grabado del bisonte sin tocarlo. '
            'Compara — su mano, la línea que alguien grabó. Un '
            'segundo. Después retira la mano.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Cuando salen, la luz del sol pega fuerte después de la '
            'oscuridad. Maren parpadea. No habla durante diez '
            'minutos.',
      ),

      PlanoCierreAmable(textoBoton: 'VOLVER AL COCHE'),
    ],
  );

  /// **1.3.5 — Vuelta y silencio** (doc 07 §1.3.5).
  ///
  /// Coche de regreso. Cuarenta minutos sin hablar — Isaura
  /// respeta el silencio. Cerca de Iruña, Maren empieza a hablar:
  /// pregunta por la tercera cueva (lo que dijo Joxe sobre "la
  /// otra"), e Isaura le explica que hay una cueva más profunda,
  /// descubierta hace poco, con pinturas mucho más antiguas — pero
  /// requiere espeleología. Isaura entró una vez. Maren pregunta
  /// quién la encontró: "un equipo de espeleólogos y arqueólogos
  /// del valle. Sigue en estudio." Cierra con la línea pedagógica
  /// del oficio: "el oficio no se acaba — todo el tiempo aparecen
  /// cosas". Isaura le ofrece hablar de lo del día; Maren dice
  /// "no ahora". Isaura acepta sin presionar.
  ///
  /// Esta cinemática activa el flag `cueva_pirineo_visitada` que
  /// el catálogo de Brechas reconoce como disparador de la Brecha
  /// 1.3 jugable.
  static const EscenaCinematica vueltaYSilencio = EscenaCinematica(
    id: '1.3.5',
    titulo: 'Vuelta y silencio',
    flagDeSalida: 'escena_1_3_5_vista',
    flagsRequeridos: {'escena_1_3_4_vista'},
    ambiente: AmbienteArchivo.cocheIsaura,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 6),
        textoLectura:
            'Coche. Carretera de vuelta del Pirineo. Maren mira por '
            'la ventana. No habla. Isaura no le pregunta. Cuarenta '
            'minutos en silencio.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura:
            'Cuando empiezan a acercarse a Iruña, Maren habla.',
      ),

      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: '¿Vamos a sellar la Brecha hoy?',
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto:
            'No. Esta noche escribes en el Cuaderno. Mañana o pasado '
            'en el Archivo, formulamos las preguntas. Después '
            'trabajamos.',
      ),

      PlanoAmbiente(
        duracion: Duration(seconds: 1),
        textoLectura: 'Pausa.',
      ),

      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Isaura.'),
      PlanoDialogo(voz: VozPersonaje.isaura, texto: '¿Sí?'),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto:
            'El custodio dijo "después os abro la otra". Pero sólo '
            'me llevaste a dos cuevas.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto:
            'Hay una tercera. Más profunda, descubierta hace poco. '
            'Pinturas más antiguas todavía — más de veinte mil años. '
            'Las primeras pinturas de Navarra. Pero está cerrada al '
            'acceso normal. Tienes que entrar con cuerdas, gateras, '
            'equipo de espeleología.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: '¿Has entrado tú?',
        pausaPrevia: Duration(milliseconds: 800),
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: 'Una vez. Hace cinco años. Casi no salgo.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: '¿Quién la encontró?',
        pausaPrevia: Duration(milliseconds: 1200),
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto:
            'Un equipo de espeleólogos y arqueólogos del valle. Hace '
            'pocos años. Sigue en estudio.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Entonces todavía aparecen cosas.',
        pausaPrevia: Duration(milliseconds: 800),
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: 'Todo el tiempo. El oficio no se acaba.',
      ),

      PlanoAmbiente(
        duracion: Duration(seconds: 2),
        textoLectura: 'Pausa.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: '¿Necesitas hablar de lo de hoy?',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'No ahora.',
        pausaPrevia: Duration(milliseconds: 1200),
      ),
      PlanoDialogo(voz: VozPersonaje.isaura, texto: 'Vale.'),

      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Llegan a Iruña. Isaura la deja en el portal. "Mañana a '
            'las nueve." "Vale." Maren sube. Isaura se queda dos '
            'segundos quieta en el coche. Después arranca.',
      ),

      PlanoCierreAmable(textoBoton: 'SUBIR A CASA'),
    ],
  );

  /// **1.3.6 — El primer Concilio formal** (doc 07 §1.3.6).
  ///
  /// Dos días después del cierre de la Brecha jugable. Salón del
  /// Concilio del Archivo. Aitor (revisor Constructor) pregunta
  /// duro sobre la datación. Joana (revisora Anclada) pregunta
  /// sobre el contexto cultural del Magdaleniense — qué tipo de
  /// comunidad, qué relación con otras cuevas pirenaicas con arte
  /// parietal. Maren admite que sabe lo justo y declara los
  /// límites de su conocimiento. Aitor cierra: "sellada. Disputada
  /// como debe ser." Karim, observador, hace su única intervención
  /// — y es la línea pedagógica clave del arco. Cuando Maren había
  /// dicho "no se puede determinar" sobre el significado del arte
  /// parietal, le pide reformular. Maren reformula: "No podemos
  /// determinarlo con la evidencia disponible." Karim asiente:
  /// "Mejor. La diferencia importa."
  ///
  /// Pedagógicamente: la diferencia entre "no se puede determinar"
  /// (afirmación absoluta sobre los límites del conocimiento) y
  /// "no podemos determinar con la evidencia disponible" (declaración
  /// honesta del oficio que reconoce que la evidencia podría
  /// crecer) es la que distingue al oficio histórico de ambos
  /// extremos: dogmatismo y relativismo. Karim, como Reformista,
  /// es quien la marca.
  ///
  /// Esta cinemática se reproduce DESPUÉS de cerrar la Brecha 1.3
  /// jugable — el Concilio jugable (Fase 5 del modelo Brecha) da
  /// feedback automatizado por scores Brier, esta cinemática añade
  /// la capa narrativa canónica del doc.
  ///
  /// **Sustituciones diegéticas**: el doc 07 nombra "Barandiarán"
  /// como autor de informes que Maren cita; aquí queda como
  /// "informes de varias campañas de excavación" sin autoría
  /// específica. Las cuevas comparativas que Joana cita
  /// ("Isturitz, Lezia, Lexotoa") quedan como "otras cuevas
  /// pirenaicas con arte parietal del Magdaleniense" sin nombrar.
  /// Anotado en BLOQUEOS-PENDIENTES.md.
  static const EscenaCinematica elPrimerConcilioFormal = EscenaCinematica(
    id: '1.3.6',
    titulo: 'El primer Concilio formal',
    flagDeSalida: 'escena_1_3_6_vista',
    flagsRequeridos: {'brecha_1_3_completada'},
    ambiente: AmbienteArchivo.salonConcilio,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Salón del Concilio. Mesa larga. Aitor y Joana en los '
            'lados como revisores. Karim al fondo, observador. '
            'Isaura presente, en silencio. Maren ha presentado su '
            'reconstrucción y está respondiendo a preguntas.',
      ),

      // Aitor — datación.
      PlanoDialogo(
        voz: VozPersonaje.aitor,
        texto:
            '¿Cómo defiendes la datación de los grabados? El '
            'Magdaleniense Inferior o Medio cubre un rango grande.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto:
            'Por el covacho de habitación contiguo. Las dataciones C14 '
            'sobre carbones del hogar sitúan la actividad humana en '
            'torno a los trece mil años antes del presente. Los '
            'informes de varias campañas de excavación coinciden en '
            'el rango.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.aitor,
        texto:
            'El covacho data la habitación. ¿Cómo conectas covacho '
            'con grabados?',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto:
            'No los conecto con seguridad. La declaro Disputada como '
            'afirmación. La datación del covacho es Sólida. La '
            'autoría compartida no.',
        pausaPrevia: Duration(milliseconds: 800),
      ),
      PlanoDialogo(voz: VozPersonaje.aitor, texto: 'Bien.'),

      // Joana — contexto cultural.
      PlanoDialogo(
        voz: VozPersonaje.joana,
        texto:
            'Sobre el contexto cultural. ¿Qué tipo de comunidad? ¿Qué '
            'relación con otras cuevas pirenaicas con arte parietal '
            'del Magdaleniense?',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto:
            'Sé lo justo. La comparativa identifica continuidades '
            'estilísticas y discontinuidades. Las semejanzas no '
            'autorizan a afirmar identidad cultural completa entre '
            'los grupos. Más allá de eso, declaro el límite de mi '
            'conocimiento.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.joana,
        texto: 'Bien que lo declares.',
      ),

      // Cierre.
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura:
            'Tras dos preguntas más sobre las losas selladoras y la '
            'función ritual, Aitor cierra el Concilio.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.aitor,
        texto: 'Bien. Sellada. Disputada como debe ser.',
      ),

      // Karim — intervención clave.
      PlanoDialogo(
        voz: VozPersonaje.karim,
        texto: 'Una observación.',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Sí.'),
      PlanoDialogo(
        voz: VozPersonaje.karim,
        texto:
            'Cuando declaraste Disputado el significado del arte '
            'parietal, dijiste "no se puede determinar". ¿Quieres '
            'reformular?',
      ),

      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura: 'Maren piensa.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'No podemos determinarlo con la evidencia disponible.',
        pausaPrevia: Duration(milliseconds: 1200),
      ),
      PlanoDialogo(
        voz: VozPersonaje.karim,
        texto: 'Mejor. La diferencia importa.',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Vale.'),

      PlanoAmbiente(
        duracion: Duration(seconds: 2),
        textoLectura: 'Karim mira a Isaura.',
      ),
      PlanoDialogo(voz: VozPersonaje.karim, texto: 'Aprende rápido.'),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: 'Mm.',
        pausaPrevia: Duration(milliseconds: 600),
      ),

      PlanoCierreAmable(textoBoton: 'SALIR DEL SALÓN'),
    ],
  );

  /// **1.3.7 — El apunte largo** (doc 07 §1.3.7).
  ///
  /// Esa noche. Maren en su habitación, cuaderno abierto. Voz
  /// interna larga que cierra la Estación 3 — la entrada más
  /// extensa del Cuaderno hasta ahora. Recorre lo visto en la
  /// cueva, el contraste con los libros (en los libros el dibujo
  /// es perfilado, en la cueva los grabados sólo aparecen al mover
  /// la linterna), la corrección de Karim ("la diferencia importa"),
  /// y la única afirmación que Maren se permite NO dejar en
  /// Disputado: "alguien decidió grabar un bisonte donde nadie iba
  /// a verlo. Eso requiere intención. No es accidente. Su mano se
  /// parecía a la mía. Estuvo allí donde yo estuve hoy. Y se fue.
  /// Nosotras lo vimos. Eso no es Disputado."
  ///
  /// Pedagógicamente: la voz íntima del Cuaderno puede sostener una
  /// afirmación humana profunda (la intencionalidad del autor del
  /// arte) sin contradecir la disputa epistémica sobre el
  /// significado. La intención es Sólida; el significado es
  /// Disputado. Distinción que el oficio honesto preserva.
  static const EscenaCinematica elApunteLargo = EscenaCinematica(
    id: '1.3.7',
    titulo: 'El apunte largo',
    flagDeSalida: 'escena_1_3_7_vista',
    flagsRequeridos: {'escena_1_3_6_vista'},
    ambiente: AmbienteArchivo.cuartoCasaMaren,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Esa noche. Maren en su mesa. El cuaderno abierto. Luz '
            'baja. Escribe durante mucho tiempo.',
      ),

      // Bloque 1.
      PlanoAmbiente(
        duracion: Duration(seconds: 6),
        textoLectura:
            'He visto los grabados hoy. No es como en los libros. En '
            'los libros se ven con flash o con dibujo perfilado para '
            'que la línea sea clara. En la cueva no se ven hasta que '
            'mueves la linterna en el ángulo correcto. Después '
            'aparecen. El bisonte. El ciervo. La cabeza del uro. El '
            'caballo.',
      ),

      // Bloque 2.
      PlanoAmbiente(
        duracion: Duration(seconds: 7),
        textoLectura:
            'Las hizo alguien con una herramienta de piedra hace '
            'trece mil años. La luz natural no llega ahí. Tuvieron '
            'que entrar con fuego, instalarse con cuidado, y trabajar '
            'en silencio profundo durante quién sabe cuánto tiempo.',
      ),

      // Bloque 3 — la corrección de Karim.
      PlanoAmbiente(
        duracion: Duration(seconds: 7),
        textoLectura:
            'Aitor me preguntó hoy qué sabemos sobre por qué lo '
            'hicieron. Yo dije que no se sabe. Karim me corrigió: '
            '"no se puede determinar con la evidencia disponible." '
            'Tiene razón. No es lo mismo.',
      ),

      // Bloque 4 — la afirmación humana profunda.
      PlanoAmbiente(
        duracion: Duration(seconds: 7),
        textoLectura:
            'Pero hay una cosa que sí sé. Alguien decidió grabar un '
            'bisonte donde nadie iba a verlo a la luz del día. Eso '
            'requiere intención. No es decoración. No es accidente. '
            'Es algo más.',
      ),

      // Bloque 5 — el cierre.
      PlanoAmbiente(
        duracion: Duration(seconds: 7),
        textoLectura:
            'No sé qué es ese algo. Pero existió. Hace trece mil '
            'años, alguien lo decidió. Su mano se parecía a la mía. '
            'Estuvo allí donde yo estuve hoy. Y se fue.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura: 'Nosotras lo vimos.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura: 'Eso no es Disputado.',
      ),

      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura:
            'Maren cierra el cuaderno. Apaga la luz. La habitación '
            'queda oscura.',
      ),

      PlanoCierreAmable(textoBoton: 'HASTA MAÑANA'),
    ],
  );

  /// **1.C — Naia pregunta** (doc 07 §1.C).
  ///
  /// Días después de cerrar la Estación 3, antes de la 4. Cena
  /// familiar — pochas. Naia, 8 años, le pregunta a Maren si los
  /// huesos viejos le dan miedo. Maren contesta que no. Naia
  /// pregunta por qué. Maren responde, tras una pausa larga,
  /// "porque eran personas". Naia dice que a ella sí le darían
  /// miedo. Maren contesta "está bien".
  ///
  /// Pedagógicamente clave: la humanización del objeto histórico.
  /// Maren no le explica a Naia qué es el oficio — le devuelve la
  /// pregunta a un nivel donde Naia puede entrar (los huesos eran
  /// personas) y luego valida su miedo sin corregirlo. Es la
  /// segunda vez en el arco que Maren ejerce algo parecido a una
  /// pedagogía propia.
  ///
  /// **Anclada a la Estación 3**: requiere `brecha_1_3_completada`.
  /// La Brecha 1.3 (cueva del Pirineo) no está implementada en el
  /// catálogo del juego todavía, así que esta escena queda latente.
  /// Mismo patrón que la 1.B.1.
  ///
  /// Sin contenido histórico concreto que sustituir.
  static const EscenaCinematica naiaPregunta = EscenaCinematica(
    id: '1.C',
    titulo: 'Naia pregunta',
    flagDeSalida: 'escena_1_c_vista',
    flagsRequeridos: {'brecha_1_3_completada'},
    ambiente: AmbienteArchivo.cocinaCasaMaren,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Casa. Cena familiar. Plato de pochas. Maren, Iratxe, '
            'Antonio y Naia alrededor de la mesa. Han pasado unos '
            'días desde la Estación 3 — la cueva.',
      ),

      PlanoDialogo(voz: VozPersonaje.naia, texto: 'Maren.'),
      PlanoDialogo(voz: VozPersonaje.maren, texto: '¿Qué?'),
      PlanoDialogo(
        voz: VozPersonaje.naia,
        texto: '¿Tú has visto huesos viejos?',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Sí.'),
      PlanoDialogo(voz: VozPersonaje.naia, texto: '¿Te dan miedo?'),

      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'No.',
        pausaPrevia: Duration(milliseconds: 1000),
      ),
      PlanoDialogo(voz: VozPersonaje.naia, texto: '¿Por qué?'),

      // Pausa más larga. Maren llega a la respuesta humanizadora.
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Porque eran personas.',
        pausaPrevia: Duration(milliseconds: 1500),
      ),

      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura: 'Naia se queda quieta. Después come. Después:',
      ),
      PlanoDialogo(
        voz: VozPersonaje.naia,
        texto: 'Yo creo que a mí sí me darían miedo.',
      ),

      // Maren valida sin corregir. Pedagogía propia.
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Está bien.',
      ),

      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura:
            'Iratxe y Antonio se miran un segundo. Antonio sonríe '
            'pequeñísimo. Siguen comiendo.',
      ),

      PlanoCierreAmable(textoBoton: 'TERMINAR LA CENA'),
    ],
  );

  /// **1.4.1 — El yacimiento** (doc 07 §1.4.1).
  ///
  /// ~5-6 semanas tras inicio del juego. Maren llega al monte
  /// Irulegi (Valle de Aranguren) con Isaura. Los recibe el
  /// arqueólogo del yacimiento — sin nombre completo en pantalla,
  /// sólo "el arqueólogo", decisión explícita del guion canónico.
  /// Las casas vascónicas tardías parcialmente excavadas, escaleras
  /// de piedra que conservan siete peldaños. Isaura le anuncia que
  /// mañana viene el Concilio entero (Begoña, Aitor, Joana, Karim,
  /// más). Le explicita: hoy haces el trabajo, mañana lo defiendes.
  /// Le menciona la Mano (que verán por la tarde en el Museo de
  /// Navarra) y, con cuidado, la presencia de un perinatal cercano.
  ///
  /// Pedagógicamente clave: la Estación final del arco se anuncia
  /// como expuesta — Aspirante presenta de pie ante Concilio entero
  /// — pero también acompañada (Isaura: "no estás sola, pero estás
  /// expuesta"). El arqueólogo le entrega el sitio con respeto.
  ///
  /// **Yacimiento concreto y datación validados** en el header v0.2
  /// del doc 07 (entrada YACIMIENTO-CELTIBERICO/VASCON del tracker
  /// doc 17). Sin sustituciones diegéticas en el contenido material
  /// del sitio. El arqueólogo se nombra como "el arqueólogo" porque
  /// el guion así lo decide (su nombre completo, "Mattin", queda
  /// fuera de pantalla por decisión del guion canónico).
  static const EscenaCinematica viajeAYacimientoIrulegi = EscenaCinematica(
    id: '1.4.1',
    titulo: 'El yacimiento',
    flagDeSalida: 'escena_1_4_1_vista',
    flagsRequeridos: {'escena_1_3_7_vista'},
    ambiente: AmbienteArchivo.yacimientoIrulegi,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Cinco semanas dentro del oficio. El monte Irulegi se '
            'eleva sobre el valle de Aranguren, a diez kilómetros de '
            'Iruña. La caminata desde Ilundain ha sido de media hora '
            'larga. En la cima, las estructuras de piedra del poblado '
            'fortificado, parcialmente excavadas. Más arriba, los '
            'restos de un castillo medieval — pero ese no es el sitio '
            'de hoy.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Un arqueólogo joven, anorak de campo, las recibe en la '
            'zona excavada. Está cerca de una vivienda con paredes '
            'de piedra visibles, una calle de acceso, peldaños de '
            'piedra conservados.',
      ),

      PlanoDialogo(
        voz: VozPersonaje.arqueologo,
        texto: 'Llegáis bien. Tenéis dos horas.',
      ),
      PlanoDialogo(voz: VozPersonaje.isaura, texto: 'Gracias.'),

      PlanoAmbiente(
        duracion: Duration(seconds: 2),
        textoLectura: 'A Maren:',
      ),
      PlanoDialogo(
        voz: VozPersonaje.arqueologo,
        texto:
            'Tú eres la nueva. Empieza por la casa. Las escaleras '
            'conservan siete peldaños — primera vivienda con '
            'escaleras documentada en toda la Edad del Hierro del '
            'Pirineo Occidental.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura:
            'Maren se acerca. Mira las escaleras de piedra que llevan '
            'hasta el umbral de una casa parcialmente derrumbada.',
      ),

      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: 'Esta es tu última Brecha de Aspirante.',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Lo sé.'),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: 'Mañana viene el Concilio entero.',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: '¿Entero?'),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: 'Begoña. Yo. Aitor. Joana. Karim. Algunos más.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 2),
        textoLectura: 'Maren respira hondo.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: 'No estás sola. Pero estás expuesta.',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Vale.'),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: 'Hoy haces el trabajo. Mañana lo defiendes.',
      ),

      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura: 'Pausa. Maren mira el conjunto del poblado.',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Cuándo se abandonó.'),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto:
            'Primer cuarto del siglo I a.C. Tropas romanas lo '
            'incendiaron. Las paredes de las casas colapsaron y '
            'sepultaron los objetos en su sitio. Lo que tienes hoy '
            'es una fotografía congelada de una jornada de hace dos '
            'mil años.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 2),
        textoLectura: 'Maren mira las escaleras.',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: '¿En qué guerra?'),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto:
            'Las guerras sertorianas. Conflicto civil romano. Nada '
            'que ver con una conquista exterior limpia. Los romanos '
            'peleaban entre ellos y arrastraron a las gentes locales.',
      ),

      PlanoAmbiente(
        duracion: Duration(seconds: 2),
        textoLectura: 'Pausa.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: 'Hay otras dos cosas que debes saber antes de empezar.',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Vale.'),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto:
            'Una. En esta casa de la izquierda — la que excavaron en '
            '2021 — encontraron una pieza extraordinaria. La llaman '
            'la Mano de Irulegi. Está hoy en el Museo de Navarra. '
            'Volvemos por la tarde a verla. Tu Brecha trabajará la '
            'pieza como pieza, y trabajará el sitio donde apareció.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 2),
        textoLectura: 'Maren asiente.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto:
            'Dos. Aquí cerca, cuando excavaron, encontraron también '
            'los restos de un bebé. Un perinatal. Murió poco antes '
            'de nacer. Hace dos mil años.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura: 'Maren se queda quieta.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Vale.',
        pausaPrevia: Duration(milliseconds: 1200),
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto:
            'Lo dejo dicho ahora para que sepas. La Brecha no se '
            'centra en él. Pero conviene que conozcas que existió.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Maren asiente despacio. Se pone los guantes que el '
            'arqueólogo le ha pasado. Comienza el trabajo en la casa '
            'de las escaleras.',
      ),

      PlanoCierreAmable(textoBoton: 'EMPEZAR LA JORNADA'),
    ],
  );

  /// **1.4.2 — Material congelado** (doc 07 §1.4.2).
  ///
  /// Día completo. Maren trabaja por la mañana en el sitio (dos
  /// horas) inventariando el material congelado de la última
  /// jornada del poblado: la casa con escaleras, el enlosado del
  /// cobertizo colapsado por mala preparación de la base, cerámica
  /// indígena mezclada con romana en el mismo nivel, armas del
  /// ataque romano, huesos de la última cena. Por la tarde, viaje
  /// al Museo de Navarra (Sala de Prehistoria) donde está la Mano
  /// de Irulegi. Maren pasa una hora frente a la vitrina, media
  /// hora con la cartela y los paneles. La cartela trae **dos
  /// transcripciones distintas** — la lectura inicial de noviembre
  /// 2022 y la corregida tras limpieza posterior. La voz del
  /// Cuaderno cierra la jornada con una entrada larga sobre la
  /// divergencia académica.
  ///
  /// Pedagógicamente clave: aprender a sostener la incertidumbre
  /// cuando los expertos divergen entre sí. La voz del Cuaderno
  /// articula explícitamente la postura epistémica: "Voy a tener
  /// que sostener la incertidumbre. No me quiero precipitar".
  ///
  /// Al cerrar esta cinemática se activa `material_irulegi_recogido`,
  /// que el catálogo reconoce como disparador de la fase jugable de
  /// la Brecha 1.4.
  ///
  /// **Sin sustituciones diegéticas**: la cartela del Museo de
  /// Navarra y el monográfico de Fontes Linguae Vasconum 136 (2023)
  /// son referencias **reales y trazables** — información pública
  /// verificable. La validación del comité asesor cuando llegue
  /// confirmará el tono de la voz del Cuaderno y la formulación de
  /// la divergencia académica.
  static const EscenaCinematica materialCongelado = EscenaCinematica(
    id: '1.4.2',
    titulo: 'Material congelado',
    flagDeSalida: 'escena_1_4_2_vista',
    flagsRequeridos: {'escena_1_4_1_vista'},
    ambiente: AmbienteArchivo.museoNavarra,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Maren trabaja dos horas en el yacimiento. Inventarío de '
            'la casa con las escaleras: paredes de piedra y adobe, '
            'siete peldaños conservados, fragmentos de cerámica en '
            'el suelo de la última jornada. Después, otra zona: el '
            'cobertizo con su enlosado derrumbado.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.arqueologo,
        texto:
            'Aquí intentaron imitar un opus signinum. Pavimento de '
            'piedra plana romana. Pero la base no estaba bien '
            'preparada. Se les hundió.',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: '¿Antes del incendio?'),
      PlanoDialogo(
        voz: VozPersonaje.arqueologo,
        texto:
            'Antes. Llevaban un tiempo con el cobertizo así, '
            'inservible. La estaban incorporando, no dominando. '
            'Aprendizaje incompleto.',
      ),

      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'En el resto del sitio: cerámica indígena del Hierro '
            'tardío — la mayoría — junto con piezas romanas en el '
            'mismo nivel. Paredes finas, campaniense, fragmentos de '
            'ánfora. Y por todas partes, las armas del ataque: '
            'puntas de flecha, restos de espada, glandes de honda '
            'con marcas de fundidor romano. Las casas colapsaron '
            'sobre todo lo demás. Una fotografía congelada.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura:
            'Pausa para comer. Bocadillo con Isaura en el lateral. '
            'Sin hablar mucho.',
      ),

      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Por la tarde, viaje corto al Museo de Navarra. Iruña, '
            'Sala de Prehistoria. Maren pasa una hora frente a la '
            'vitrina de la Mano. Lámina de bronce, dedos hacia '
            'abajo, decoración en relieve. Inscripción grabada — '
            'signario paleohispánico, variante específica.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Después media hora con la cartela y los paneles de '
            'contexto. Maren detecta algo. La cartela menciona '
            '"lectura inicial 2022" y, debajo, "lectura corregida '
            'tras limpieza posterior". Dos transcripciones distintas.',
      ),

      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura: 'Maren toma notas. Vuelve al Archivo. Esa noche.',
      ),

      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto: 'La Mano de Irulegi. La he visto.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto:
            'La cartela del museo trae dos lecturas. La primera es '
            'de noviembre de 2022, cuando se anunció el hallazgo. '
            'La segunda es posterior, después de que limpiaran la '
            'pieza.',
        pausaPrevia: Duration(milliseconds: 800),
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto: 'Las dos no dicen lo mismo. La diferencia no es trivial.',
        pausaPrevia: Duration(milliseconds: 600),
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto:
            'Los expertos no se han puesto de acuerdo. Hay un número '
            'entero de una revista — Fontes Linguae Vasconum 136, '
            '2023 — con todos pronunciándose, y aún así no hay '
            'consenso.',
        pausaPrevia: Duration(milliseconds: 800),
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto:
            'Algunos quieren leer la pieza como confirmación de que '
            'el euskera ya estaba aquí hace dos mil años. Otros '
            'dicen que es lengua vascónica, parecida pero no igual '
            'al euskera. Otros piden cautela total — un solo texto, '
            'dicen, no permite afirmar mucho.',
        pausaPrevia: Duration(milliseconds: 800),
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto: 'Voy a tener que sostener la incertidumbre. No me '
            'quiero precipitar.',
        pausaPrevia: Duration(milliseconds: 1000),
      ),

      PlanoCierreAmable(textoBoton: 'EMPEZAR LA BRECHA'),
    ],
  );

  /// **1.4.3 — El gran Concilio** (doc 07 §1.4.3).
  ///
  /// Día siguiente, 10:00. Salón del Concilio del Archivo, mesa
  /// larga. Begoña en cabecera. A los lados, Isaura, Aitor, Joana,
  /// Karim. Marina al fondo como observadora. Maren en pie en el
  /// extremo opuesto — los Aspirantes presentan de pie. Maren
  /// despliega su reconstrucción (las 9 afirmaciones que ha
  /// trabajado en la Brecha jugable). Después, las preguntas:
  /// Aitor sobre la afirmación 5 (adopción incompleta), Joana
  /// sobre las afirmaciones 8 y 9 (lectura epigráfica disputada
  /// + relación lengua vascónica/euskera), Begoña sobre la
  /// distinción contacto vs romanización, Karim sobre el sobrepeso
  /// simbólico de la Mano y la formulación de la violencia romana.
  /// Cierre: Begoña dice "Aprendiz I". Marina aplaude sin
  /// protocolo, Begoña la mira. Sonrisas contenidas. Maren sonríe
  /// — la primera sonrisa visible en mucho tiempo.
  ///
  /// Pedagógicamente clave: el Concilio entero como escena
  /// expuesta. Karim **pilla a Maren dos veces** — patrón que el
  /// doc 07 §1.4.4 articula explícitamente como cuidado, no como
  /// trampa. Begoña sólo sonríe cuando el aprendiz reconoce sus
  /// límites ("probablemente sí lo estoy haciendo"). Joana
  /// distingue Disputado ("dos lecturas establecidas que no
  /// concuerdan") de "no establecido" — distinción nuclear del
  /// oficio.
  ///
  /// Anclada a `brecha_1_4_completada`. La cinemática reproduce el
  /// diálogo concreto del Concilio como contenido narrativo extra
  /// — la fase jugable F6.5 (Concilio) ya dio el feedback
  /// algorítmico del juego; esta cinemática añade el contenido
  /// específico que el algoritmo no puede generar.
  ///
  /// **Sin sustituciones diegéticas**: el Concilio reproduce
  /// literalmente el diálogo del doc 07 v0.2. La voz de Joana y la
  /// de Karim se fijan aquí por primera vez con material narrativo
  /// largo. Pendiente de revisión humana — registrado en
  /// BLOQUEOS-PENDIENTES.md.
  static const EscenaCinematica granConcilio = EscenaCinematica(
    id: '1.4.3',
    titulo: 'El gran Concilio',
    flagDeSalida: 'escena_1_4_3_vista',
    flagsRequeridos: {'brecha_1_4_completada'},
    ambiente: AmbienteArchivo.salonConcilio,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Día siguiente, diez de la mañana. Salón del Concilio '
            'del Archivo. Mesa larga. Begoña en cabecera. A los '
            'lados, Isaura, Aitor, Joana, Karim. Marina al fondo '
            'como observadora. Maren entra. Saluda con la cabeza. '
            'No se sienta — los Aspirantes presentan de pie.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.begona,
        texto:
            'Comenzamos. Maren Lozano, Aspirante. Brecha del '
            'yacimiento de Irulegi y la Mano. Cuéntanos.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Maren empieza a presentar. Despliega su reconstrucción. '
            'Pasa cada afirmación con su anclaje y nivel de confianza. '
            'Su voz tiembla los primeros dos minutos. Después se '
            'estabiliza. Termina la presentación inicial. Las '
            'preguntas.',
      ),

      PlanoDialogo(
        voz: VozPersonaje.aitor,
        texto:
            'Tu afirmación cinco — la adopción incompleta de '
            'técnicas romanas. La declaras Probable. ¿Por qué no '
            'Sólido?',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto:
            'Porque el enlosado colapsado puede explicarse por más '
            'de una causa. La hipótesis más simple es mala '
            'preparación de la base por falta de experiencia '
            'técnica. Pero podría también ser sismo, hundimiento del '
            'terreno, sabotaje deliberado durante el incendio, o '
            'factores que no he considerado. La inferencia "proceso '
            'de aprendizaje" es la más económica pero no la única '
            'posible.',
      ),
      PlanoDialogo(voz: VozPersonaje.aitor, texto: '¿Qué te haría Sólido?'),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto:
            'Análisis de otros casos similares en el yacimiento o en '
            'yacimientos contemporáneos. Si hubiera tres o cuatro '
            'intentos de imitación romana documentados como '
            'técnicamente imperfectos, la inferencia se reforzaría. '
            'Con uno solo, queda Probable.',
        pausaPrevia: Duration(milliseconds: 800),
      ),
      PlanoDialogo(voz: VozPersonaje.aitor, texto: 'Bien.'),

      PlanoAmbiente(
        duracion: Duration(seconds: 2),
        textoLectura: 'Joana toma el turno.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.joana,
        texto:
            'Sobre la afirmación ocho. La declaras Disputada. ¿Por '
            'qué no simplemente "lectura no establecida"?',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto:
            'Porque sí hay lecturas establecidas — al menos dos '
            'versiones consensuadas en distintos momentos. La '
            'cuestión no es ausencia de lectura. Es que las lecturas '
            'disponibles no concuerdan entre sí y los expertos no se '
            'ponen de acuerdo cuál prefiere. Eso es Disputado, no '
            '"no establecido".',
      ),
      PlanoDialogo(voz: VozPersonaje.joana, texto: 'Distinción correcta.'),

      PlanoDialogo(
        voz: VozPersonaje.joana,
        texto:
            'Y la nueve. La relación lengua vascónica con el '
            'euskera. La declaras Probable la relación, Disputada '
            'como afirmación metodológica. ¿Puedes explicar?',
        pausaPrevia: Duration(milliseconds: 600),
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto:
            'Sí. Hay buenas razones para pensar que la lengua '
            'vascónica de la Mano y el euskera contemporáneo tienen '
            'alguna relación. La palabra "sorioneku" en la lectura '
            'inicial recordaba al euskera "zorionekoa" — afortunado. '
            'Pero hay otras razones para ser cauto: la lectura '
            'inicial fue corregida, los signarios son distintos, dos '
            'mil años separan los dos momentos, el euskera '
            'reconstruido para el siglo I a.C. quizá no se parecía '
            'mucho al euskera actual.',
        pausaPrevia: Duration(milliseconds: 1200),
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 2),
        textoLectura: 'Pausa.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto:
            'Yo declaro Probable la relación porque es plausible. '
            'Pero declaro Disputada como afirmación metodológica '
            'porque el oficio honesto no me permite afirmarla con '
            'la rotundidad que algunas voces dentro y fuera del '
            'debate quieren. Hay quien la usa para sostener que el '
            'euskera ya estaba aquí hace dos mil años con esa '
            'forma. Hay quien la usa para sostener lo contrario. '
            'Yo no quiero que mi reconstrucción sirva a ninguno de '
            'los dos.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura: 'Pausa larga.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.joana,
        texto:
            'Eso es discusión metodológica importante. ¿La sostienes?',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'La sostengo.',
        pausaPrevia: Duration(milliseconds: 1000),
      ),
      PlanoDialogo(voz: VozPersonaje.joana, texto: 'Bien.'),

      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura:
            'Begoña ha estado en silencio. Habla ahora.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.begona,
        texto: 'Tres preguntas más. Una mía, dos de Karim.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 2),
        textoLectura: 'Begoña hace su pregunta. Es dura.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.begona,
        texto:
            'Pregunta sobre la diferencia entre "contacto romano" y '
            '"romanización". ¿No estás confundiendo categorías '
            'cuando dices que los pobladores adoptaban técnicas pero '
            'no eran "romanizados completos"?',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura: 'Maren tarda en responder. Pausa larga.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto:
            'No lo había pensado así de claro. Probablemente sí lo '
            'estoy haciendo. No sé bien cómo separar las dos '
            'categorías. Quería decir "contacto" en el sentido de '
            'adopción voluntaria de elementos sin pérdida de '
            'identidad propia, "romanización" como proceso más '
            'profundo de transformación cultural. Pero las dos '
            'cosas pueden estar pasando a la vez. Y mi yacimiento '
            'muestra los principios del proceso en marcha — no hay '
            'un punto claro donde "contacto" se convierta en '
            '"romanización".',
      ),
      PlanoDialogo(
        voz: VozPersonaje.begona,
        texto: 'Bien que lo digas.',
      ),

      PlanoAmbiente(
        duracion: Duration(seconds: 2),
        textoLectura: 'Karim toma sus dos preguntas.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.karim,
        texto:
            'Has trabajado la Mano. Pero la Mano ha sido mucho más '
            'que pieza arqueológica desde 2022. Tiene presencia en '
            'actos populares, asociaciones, gente que se la tatúa. '
            '¿Qué hace la Cronista con ese sobrepeso simbólico?',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura: 'Maren piensa. Pausa más larga.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Lo respeta. Pero no lo refleja en la reconstrucción.',
      ),
      PlanoDialogo(voz: VozPersonaje.karim, texto: 'Explícate.'),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto:
            'La Mano es importante para mucha gente del territorio. '
            'Eso es real. Esa importancia es información sobre el '
            'presente, no sobre el siglo I a.C. Yo, como Cronista, '
            'trabajo el siglo I a.C. Si dejo que la importancia '
            'presente influya en mis afirmaciones sobre el pasado, '
            'dejo de hacer el oficio.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 2),
        textoLectura: 'Pausa.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto:
            'Pero también: si dejo que el oficio se convierta en '
            'frialdad académica que ignora la importancia presente, '
            'traiciono otra parte del trabajo. La importancia '
            'presente merece reconocimiento, aunque no en la '
            'reconstrucción.',
      ),
      PlanoDialogo(voz: VozPersonaje.karim, texto: '¿Dónde la reconoces?'),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto:
            'En el Cuaderno. En que sé que mucha gente ve la pieza '
            'con sentimiento. En que cuento con eso cuando explico '
            'la Brecha a quien no ha hecho el oficio.',
        pausaPrevia: Duration(milliseconds: 1200),
      ),
      PlanoDialogo(voz: VozPersonaje.karim, texto: 'Bien.'),

      PlanoDialogo(
        voz: VozPersonaje.karim,
        texto:
            'Segunda. La afirmación tres. Las guerras sertorianas '
            'como conflicto civil romano. ¿No estás minimizando la '
            'violencia ejercida por los romanos al describirla como '
            '"guerra civil de ellos que arrastró a los locales"?',
        pausaPrevia: Duration(milliseconds: 800),
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura: 'Maren se queda. Esto la pilla.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Es posible.',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 2),
        textoLectura: 'Pausa.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto:
            'No quería minimizar. Quería no hacerla una "conquista" '
            'lineal que es lo que las versiones populares hacen. '
            'Pero al separarla del marco de "conquista", quizá he '
            'hecho que la violencia parezca menos brutal. '
            'Probablemente reformularía. La guerra fue civil romana, '
            'sí — y aún así, quien quemó Irulegi y abandonó a la '
            'gente fue ejército. El que las tropas fueran de un '
            'bando u otro no cambia la violencia recibida.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.karim,
        texto: 'Bien que lo reformules.',
        pausaPrevia: Duration(milliseconds: 800),
      ),

      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura: 'El Concilio cierra.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.begona,
        texto: 'Deliberamos. Sal del salón.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Maren sale. Espera en el pasillo. Veinte minutos. '
            'Vuelve. Begoña la mira.',
      ),
      PlanoDialogo(voz: VozPersonaje.begona, texto: 'Aprendiz I.'),
      PlanoAmbiente(
        duracion: Duration(seconds: 2),
        textoLectura: 'Pausa.',
      ),
      PlanoDialogo(voz: VozPersonaje.begona, texto: 'Bienvenida.'),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Isaura asiente desde su sitio. Aitor sonríe brevemente. '
            'Karim hace una inclinación de cabeza. Marina al fondo '
            'aplaude — sin protocolo. Begoña la mira con ceja '
            'levantada. Marina baja las manos. Sonrisas contenidas.',
      ),
      PlanoDialogo(voz: VozPersonaje.begona, texto: 'El protocolo, Marina.'),
      PlanoDialogo(voz: VozPersonaje.marina, texto: 'Perdón.'),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Pero Marina no se arrepiente del todo. Maren sonríe — '
            'la primera sonrisa visible en mucho tiempo.',
      ),

      PlanoCierreAmable(textoBoton: 'SALIR DEL CONCILIO'),
    ],
  );

  /// **1.4.4 — "Aprendiz I"** (doc 07 §1.4.4).
  ///
  /// Cierre del Arco 1. Maren sale al patio del Archivo después
  /// del gran Concilio de la Estación 4 — necesita aire. Se sienta
  /// junto al brocal del pozo. Isaura aparece a los cinco minutos
  /// y se sienta a su lado. Silencio largo. Validación amable de
  /// Isaura, mención de los gestos de Begoña que importaron, y
  /// anuncio del Arco 2: bajan a Pompaelo. Maren da las gracias.
  /// Aparece flotante "APRENDIZ I" — Maren asciende de rango.
  ///
  /// Pedagógicamente clave: el ascenso de rango llega como
  /// reconocimiento institucional silencioso, no como ceremonia.
  /// Isaura le entrega la lección final del arco: "tu peor sigue
  /// siendo bueno", y le explicita el patrón de Begoña — sólo
  /// sonríe cuando el aprendiz reconoce sus propios límites
  /// ("probablemente sí lo estoy haciendo").
  ///
  /// **Anclada a la cinemática 1.4.3** (gran Concilio): requiere
  /// `escena_1_4_3_vista`. La Brecha 1.4 ya cerró antes de la 1.4.3;
  /// la 1.4.3 reproduce el diálogo concreto del Concilio (las
  /// preguntas de Aitor, Joana, Begoña, Karim) y al cerrarla el
  /// orquestador encadena con esta cinemática post-Concilio.
  ///
  /// **Sustituciones diegéticas activas (residuales)**:
  /// - El siglo concreto del capitel ("s. XII") se omite (entrada
  ///   EDIFICIO-ARCHIVO de BLOQUEOS-PENDIENTES.md), igual que en
  ///   1.0.2.
  ///
  /// **Sustituciones revertidas en F8.6**, ahora que la Brecha 1.4
  /// y su Concilio están implementados:
  /// - "Violencia romana" recupera su forma canónica — el doc 07
  ///   §1.4.3 articula explícitamente la matización (guerras
  ///   sertorianas como conflicto civil romano, Maren reformula
  ///   tras la pregunta de Karim), así que la frase de Isaura
  ///   ahora tiene su anclaje narrativo.
  /// - "La Mano" recupera su forma canónica — la Brecha 1.4 ya
  ///   trabajó la pieza, el jugador la ha visto y defendido en el
  ///   Concilio; la mención es ahora legible.
  static const EscenaCinematica aprendizI = EscenaCinematica(
    id: '1.4.4',
    titulo: '"Aprendiz I"',
    flagDeSalida: 'escena_1_4_4_vista',
    flagsRequeridos: {'escena_1_4_3_vista'},
    ambiente: AmbienteArchivo.patioArchivo,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Maren sale del salón del Concilio al patio del Archivo. '
            'Necesita aire. El capitel y el brocal del pozo, callados. '
            'Se sienta en un banco junto al brocal. Respira.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Cinco minutos después aparece Isaura. Se sienta a su lado '
            'sin decir nada. El bastón apoyado contra el banco. Dos '
            'minutos enteros sin hablar.',
      ),

      PlanoDialogo(voz: VozPersonaje.isaura, texto: 'Has estado bien.'),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Pensaba que iba a hacerlo peor.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: 'Tu peor sigue siendo bueno.',
      ),

      PlanoAmbiente(
        duracion: Duration(seconds: 2),
        textoLectura: 'Silencio.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Begoña no sonríe nunca, ¿verdad?',
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: 'A su manera, sí. Hoy ha sonreído.',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: '¿Cuándo?'),

      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto:
            'Cuando dijiste "probablemente sí lo estoy haciendo". Y '
            'también cuando dijiste que reformularías sobre la '
            'violencia romana. Eso le encanta.',
      ),

      PlanoAmbiente(
        duracion: Duration(seconds: 2),
        textoLectura: 'Pausa.',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Karim me pilló dos veces.'),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto:
            'Karim te pilla siempre. Es su trabajo. Pero te ha pillado '
            'para ayudarte a crecer. Otra Brecha sin haber visto la '
            'Mano y haber tenido que defenderte sobre ella, no '
            'habrías estado preparada para lo que viene.',
        pausaPrevia: Duration(milliseconds: 600),
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: '¿Qué viene?'),

      // Pompaelo + transición vascón → romano: ambos elementos
      // están validados en el doc 17 / la propia worldbuilding del
      // juego (sótano romano de Pompaelo ya nombrado en 1.0.2).
      // La frase queda intacta.
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto:
            'Pompaelo. Es el comienzo del Arco 2. Los romanos llegaron '
            'y fundaron una ciudad sobre lo que pudo haber sido un '
            'asentamiento vascón previo. La transición Irulegi → '
            'Pompelo es la transición de tu próximo arco.',
        pausaPrevia: Duration(milliseconds: 800),
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'No lo sabía.',
        pausaPrevia: Duration(milliseconds: 800),
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: 'Ahora lo sabes.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura:
            'Maren no responde. Mira el capitel. Tres segundos.',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Isaura.'),
      PlanoDialogo(voz: VozPersonaje.isaura, texto: '¿Sí?'),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Gracias.'),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: 'Mm.',
        pausaPrevia: Duration(milliseconds: 1000),
      ),

      // Cierre. La cámara se aleja, aparece flotante "APRENDIZ I"
      // — el ascenso de rango entra como reconocimiento silencioso,
      // no como ceremonia. La regla del juego: los gestos pequeños.
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Se quedan en el patio. Tres segundos sin que ninguna '
            'hable.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura: 'APRENDIZ I',
      ),

      PlanoCierreAmable(textoBoton: 'CERRAR EL ARCO'),
    ],
  );
}
