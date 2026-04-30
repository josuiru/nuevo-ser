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
    naiaPregunta,
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
    'escena_1_b1_vista': {
      'conversacion_con_padre_compartida',
    },
    'escena_1_c_vista': {
      'naia_humanizo_huesos',
    },
    // Cierre del Arco 1 — Maren asciende a Aprendiz I y se anuncia
    // el Arco 2 (Pompaelo). La 1.4.4 queda latente hasta que entre
    // la Brecha 1.4 al catálogo. Activa el rango oficial.
    'escena_1_4_4_vista': {
      'rango_aprendiz_i',
      'arco_2_anunciado',
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
  /// **Anclada a la Estación 4**: requiere `brecha_1_4_completada`.
  /// Como la Brecha 1.4 (Irulegi) no está en el catálogo todavía,
  /// esta escena queda latente — el orquestador no la dispara.
  /// Mismo patrón que 1.B.1, 1.C.
  ///
  /// **Sustituciones diegéticas activas**:
  /// - El siglo concreto del capitel ("s. XII") se omite (entrada
  ///   EDIFICIO-ARCHIVO de BLOQUEOS-PENDIENTES.md), igual que en 1.0.2.
  /// - "Violencia romana" se sustituye por "lo que pasó cuando los
  ///   romanos llegaron" — la frase original carga políticamente
  ///   sin que el comité asesor la haya validado para 10-14 años.
  ///   Se preserva la pedagogía (Begoña valora la disposición a
  ///   reformular) sin afirmar tesis histórica concreta sobre la
  ///   conquista romana.
  /// - "La Mano" (Mano de Irulegi, **validada** en el header v0.2
  ///   del doc 07 como pieza central de la Estación 1.4) se
  ///   sustituye temporalmente por "una pieza así" porque la
  ///   Brecha 1.4 no está implementada — un jugador que llegue
  ///   a esta cinemática sin haberla jugado no sabría a qué se
  ///   refiere. La sustitución se revierte cuando la 1.4 entre
  ///   al catálogo. Anotado en BLOQUEOS-PENDIENTES.md.
  static const EscenaCinematica aprendizI = EscenaCinematica(
    id: '1.4.4',
    titulo: '"Aprendiz I"',
    flagDeSalida: 'escena_1_4_4_vista',
    flagsRequeridos: {'brecha_1_4_completada'},
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

      // Sustitución: "Cuando dijiste que reformularías sobre la
      // violencia romana" → "Cuando dijiste que ibas a reformular
      // tu posición sobre lo que pasó cuando los romanos llegaron".
      // Preserva el patrón pedagógico —Begoña sonríe cuando el
      // aprendiz reconoce que va a reformular— sin la afirmación
      // política implícita en "violencia romana".
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto:
            'Cuando dijiste "probablemente sí lo estoy haciendo". Y '
            'también cuando dijiste que ibas a reformular tu posición '
            'sobre lo que pasó cuando los romanos llegaron. Eso le '
            'encanta.',
      ),

      PlanoAmbiente(
        duracion: Duration(seconds: 2),
        textoLectura: 'Pausa.',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Karim me pilló dos veces.'),
      // Sustitución: "Otra Brecha sin haber visto la Mano y haber
      // tenido que defenderte sobre ella" → "Otra Brecha sin
      // haber tenido que defender una pieza así". Hasta que la
      // Brecha 1.4 entre al catálogo, una mención específica a
      // "la Mano" sería opaca para el jugador.
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto:
            'Karim te pilla siempre. Es su trabajo. Pero te ha pillado '
            'para ayudarte a crecer. Otra Brecha sin haber tenido que '
            'defender una pieza así, no habrías estado preparada para '
            'lo que viene.',
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
