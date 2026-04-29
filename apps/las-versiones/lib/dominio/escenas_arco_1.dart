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
  static const List<EscenaCinematica> todas = [
    laEvaluacion,
    elRecorrido,
    laPrimeraTardeEnCasa,
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
}
