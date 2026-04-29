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
  /// orquestador. Hoy sólo está la 1.0.1; según se vayan
  /// implementando 1.0.2, 1.0.3, etc. se añaden aquí en orden.
  static const List<EscenaCinematica> todas = [
    laEvaluacion,
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
}
