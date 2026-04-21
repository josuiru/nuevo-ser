import 'escena_cinematica.dart';
import 'plano_escena.dart';
import 'voz_personaje.dart';

/// Catálogo de escenas narrativas implementadas. Las frases provienen
/// del doc 07 (guion Arco 1). Se añaden escenas según la narrativa las
/// requiere.
class CatalogoEscenas {
  /// 1.1 — El tejado. Primer arranque. Sora reconoce al niño, le explica
  /// qué son los Fragmentos, le ofrece entrenar. Doc 07 §1.1.
  static const EscenaCinematica llegada = EscenaCinematica(
    id: '1.1',
    titulo: 'El tejado',
    flagDeSalida: 'escena_1_1_vista',
    planos: [
      PlanoAmbiente(duracion: Duration(milliseconds: 2200)),
      PlanoAmbiente(
        duracion: Duration(milliseconds: 2400),
        textoLectura: 'Una azotea. Noche azul-violeta. Viento.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.sora,
        texto: 'Llegas tarde.',
        pausaPrevia: Duration(milliseconds: 600),
      ),
      PlanoDialogo(
        voz: VozPersonaje.sora,
        texto: 'Siempre llegáis tarde.',
        pausaPrevia: Duration(milliseconds: 900),
      ),
      PlanoAmbiente(
        duracion: Duration(milliseconds: 1600),
        textoLectura: 'Sora se gira despacio.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.sora,
        texto: '{nombre}, ¿verdad?',
        pausaPrevia: Duration(milliseconds: 500),
      ),
      PlanoDialogo(
        voz: VozPersonaje.sora,
        texto: 'Mm.',
        pausaPrevia: Duration(milliseconds: 500),
      ),
      PlanoAmbiente(
        duracion: Duration(milliseconds: 1400),
        textoLectura: 'Señala al horizonte. Una montaña oscura.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.sora,
        texto: 'Eso es la Montaña. Hoy no.',
        pausaPrevia: Duration(milliseconds: 500),
      ),
      PlanoDialogo(
        voz: VozPersonaje.sora,
        texto: 'Vale. Escucha. No te lo voy a decir dos veces.',
        pausaPrevia: Duration(milliseconds: 900),
      ),
      PlanoDialogo(
        voz: VozPersonaje.sora,
        texto:
            'Esta ciudad tiene Fragmentos. Se comen cosas que no se ven. Nosotros los cazamos.',
        pausaPrevia: Duration(milliseconds: 700),
      ),
      PlanoDialogo(
        voz: VozPersonaje.sora,
        texto:
            'Te acabas de alistar. No sabes lo que haces. Tranquilo, nadie lo sabe al principio.',
        pausaPrevia: Duration(milliseconds: 800),
      ),
      PlanoDialogo(
        voz: VozPersonaje.sora,
        texto: 'Yo voy a enseñarte.',
        pausaPrevia: Duration(milliseconds: 600),
      ),
      PlanoEleccion(
        voz: VozPersonaje.sora,
        textoPrompt: '¿Vienes a entrenar, o has venido a mirar?',
        opciones: [
          OpcionEleccion(
            textoJugador: 'Vengo a entrenar.',
            textoRespuesta: 'Bien.',
            flagsAEstablecer: {'intencion_entrenar'},
          ),
          OpcionEleccion(
            textoJugador: 'No sé muy bien qué hacer.',
            textoRespuesta: 'Ya lo verás. Sígueme.',
            flagsAEstablecer: {'intencion_no_sabe'},
          ),
          OpcionEleccion(
            textoJugador: '— quedarte callado —',
            textoRespuesta: 'Vale. Sígueme y miras.',
            flagsAEstablecer: {'intencion_silencio'},
          ),
        ],
      ),
      PlanoAmbiente(
        duracion: Duration(milliseconds: 2200),
        textoLectura: 'AZULA — EDIFICIO DE LOS TEJADOS',
      ),
    ],
  );

  /// 1.2 — La primera ventana. Tutorial: Sora muestra un Pleno y guía al
  /// niño a dividirlo y desfragmentar las mitades. Doc 07 §1.2.
  /// Habilidad introducida: FR.01.
  static const EscenaCinematica primeraVentana = EscenaCinematica(
    id: '1.2',
    titulo: 'La primera ventana',
    flagDeSalida: 'escena_1_2_vista',
    flagsRequeridos: {'escena_1_1_vista'},
    planos: [
      PlanoAmbiente(
        duracion: Duration(milliseconds: 1800),
        textoLectura: 'Una azotea contigua. Algo flota sobre el suelo.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.sora,
        texto: 'Eso.',
        pausaPrevia: Duration(milliseconds: 500),
      ),
      PlanoDialogo(
        voz: VozPersonaje.sora,
        texto: 'Eso es un Fragmento. Pequeño. Inofensivo, casi.',
        pausaPrevia: Duration(milliseconds: 700),
      ),
      PlanoDialogo(
        voz: VozPersonaje.sora,
        texto: 'Es un Pleno. Vale uno. Un entero. ¿Ves?',
        pausaPrevia: Duration(milliseconds: 800),
      ),
      PlanoDialogo(
        voz: VozPersonaje.sora,
        texto: 'Dividirlo es romperlo en partes iguales. Prueba.',
        pausaPrevia: Duration(milliseconds: 800),
      ),
      PlanoInteractivo(
        vozInstruccion: VozPersonaje.sora,
        instruccion: 'Desliza el dedo sobre el Pleno.',
        accion: AccionEsperada.dividirPleno,
        estadoInicial: EstadoFragmentoTutorial.plenoCompleto,
      ),
      PlanoDialogo(
        voz: VozPersonaje.sora,
        texto: 'Bien.',
        pausaPrevia: Duration(milliseconds: 500),
      ),
      PlanoDialogo(
        voz: VozPersonaje.sora,
        texto: 'Un medio. Eso es un medio.',
        pausaPrevia: Duration(milliseconds: 600),
      ),
      PlanoInteractivo(
        vozInstruccion: VozPersonaje.sora,
        instruccion: 'Toca cada mitad para desfragmentarla.',
        accion: AccionEsperada.desfragmentarMitades,
        estadoInicial: EstadoFragmentoTutorial.dosMitades,
      ),
      PlanoDialogo(
        voz: VozPersonaje.sora,
        texto: 'Se llama desfragmentar.',
        pausaPrevia: Duration(milliseconds: 600),
      ),
      PlanoDialogo(
        voz: VozPersonaje.sora,
        texto: 'No los matas. Los vuelves al sitio del que salieron.',
        pausaPrevia: Duration(milliseconds: 800),
      ),
      PlanoDialogo(
        voz: VozPersonaje.sora,
        texto: 'Vamos.',
        pausaPrevia: Duration(milliseconds: 700),
      ),
    ],
  );

  /// 1.3 — El callejón. Una mujer mayor desorientada delante de una
  /// puerta. Sora explica el efecto residual de los Fragmentos en los
  /// adultos. Doc 07 §1.3.
  static const EscenaCinematica callejon = EscenaCinematica(
    id: '1.3',
    titulo: 'El callejón',
    flagDeSalida: 'escena_1_3_vista',
    flagsRequeridos: {'escena_1_2_vista'},
    planos: [
      PlanoAmbiente(
        duracion: Duration(milliseconds: 2000),
        textoLectura: 'Callejón trasero. Una farola amarilla parpadea.',
      ),
      PlanoAmbiente(
        duracion: Duration(milliseconds: 1800),
        textoLectura:
            'Un gato cruza. Una mujer mayor, parada frente a una puerta.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.sora,
        texto: 'Mira.',
        pausaPrevia: Duration(milliseconds: 500),
      ),
      PlanoDialogo(
        voz: VozPersonaje.sora,
        texto: 'Lleva así un rato. No recuerda por qué ha venido.',
        pausaPrevia: Duration(milliseconds: 700),
      ),
      PlanoDialogo(
        voz: VozPersonaje.sora,
        texto:
            'Eso pasa cuando hay Fragmentos cerca. No muchos. No fuertes. Pero suficientes.',
        pausaPrevia: Duration(milliseconds: 900),
      ),
      PlanoDialogo(
        voz: VozPersonaje.sora,
        texto: 'Por eso los cazamos.',
        pausaPrevia: Duration(milliseconds: 700),
      ),
      PlanoAmbiente(
        duracion: Duration(milliseconds: 1800),
        textoLectura: 'La mujer se va. Se mueve bien. Solo desajustada.',
      ),
      PlanoEleccion(
        voz: VozPersonaje.sora,
        textoPrompt: '¿Preguntas?',
        opciones: [
          OpcionEleccion(
            textoJugador: '¿Se va a poner bien?',
            textoRespuesta:
                'Seguramente. Los Fragmentos de aquí son pequeños. Se le pasa en una hora.',
            flagsAEstablecer: {'pregunta_por_mujer'},
          ),
          OpcionEleccion(
            textoJugador: '¿Cuántos Fragmentos hay?',
            textoRespuesta: 'Muchos. Siempre.',
            flagsAEstablecer: {'pregunta_por_cantidad'},
          ),
          OpcionEleccion(
            textoJugador: '¿Ella sabe?',
            textoRespuesta: 'No. Casi nadie sabe.',
            flagsAEstablecer: {'pregunta_por_saber'},
          ),
          OpcionEleccion(
            textoJugador: '— quedarte callado —',
            textoRespuesta: 'Vamos. Irune te está esperando.',
            flagsAEstablecer: {'callejon_silencio'},
          ),
        ],
      ),
    ],
  );

  /// 1.4 — Irune. Sala interior, luz cálida. Irune presenta las tres
  /// reglas fundamentales. Doc 07 §1.4.
  static const EscenaCinematica presentacionIrune = EscenaCinematica(
    id: '1.4',
    titulo: 'Irune',
    flagDeSalida: 'escena_1_4_vista',
    flagsRequeridos: {'escena_1_3_vista'},
    planos: [
      PlanoAmbiente(
        duracion: Duration(milliseconds: 2200),
        textoLectura:
            'Sala interior. Luz cálida. Libros. Una puerta con la placa ARCHIVO.',
      ),
      PlanoAmbiente(
        duracion: Duration(milliseconds: 1800),
        textoLectura:
            'Irune sentada. Pelo blanco, chaqueta gris, marca de plata al cuello.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.irune,
        texto: 'Llegas. Pasa.',
        pausaPrevia: Duration(milliseconds: 600),
      ),
      PlanoDialogo(
        voz: VozPersonaje.irune,
        texto: 'Bien.',
        pausaPrevia: Duration(milliseconds: 800),
      ),
      PlanoDialogo(
        voz: VozPersonaje.irune,
        texto:
            'Soy Irune. Esta es mi casa, y también la tuya ahora, si te lo tomas en serio.',
        pausaPrevia: Duration(milliseconds: 800),
      ),
      PlanoDialogo(
        voz: VozPersonaje.irune,
        texto:
            'Sora te va a enseñar. Es la mejor que tengo ahora mismo. No se lo digas.',
        pausaPrevia: Duration(milliseconds: 900),
      ),
      PlanoAmbiente(
        duracion: Duration(milliseconds: 1400),
        textoLectura: 'Sora al fondo mira al suelo.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.irune,
        texto: 'Tres cosas, {nombre}. Escucha.',
        pausaPrevia: Duration(milliseconds: 700),
      ),
      PlanoDialogo(
        voz: VozPersonaje.irune,
        texto:
            'Primera. Aquí nadie sabe más de lo que sabe. Si alguien te dice que lo sabe todo, desconfía. Aunque sea yo.',
        pausaPrevia: Duration(milliseconds: 900),
      ),
      PlanoDialogo(
        voz: VozPersonaje.irune,
        texto:
            'Segunda. Los Fragmentos no son enemigos. Son pedazos de algo que se rompió. Los desfragmentamos. Eso es todo.',
        pausaPrevia: Duration(milliseconds: 900),
      ),
      PlanoDialogo(
        voz: VozPersonaje.irune,
        texto:
            'Tercera. Si te cansas, paras. Si necesitas irte, te vas. Esto no es una cárcel.',
        pausaPrevia: Duration(milliseconds: 900),
      ),
      PlanoDialogo(
        voz: VozPersonaje.irune,
        texto: 'Vete con ella ya. Yo tengo cosas que hacer.',
        pausaPrevia: Duration(milliseconds: 900),
      ),
      PlanoAmbiente(
        duracion: Duration(milliseconds: 1600),
        textoLectura: 'Al salir, Sora casi sin girarse:',
      ),
      PlanoDialogo(
        voz: VozPersonaje.sora,
        texto: 'Cae bien, Irune. Cuando quiere.',
        pausaPrevia: Duration(milliseconds: 500),
      ),
    ],
  );

  /// 1.5 — Kurz aparece. Primer Fragmento nombrado con voz propia (en
  /// itálica). Sora lo invoca tras la primera sesión completa. Combate
  /// calibrado a derrota — el cierre emocional es la escena 1.6. Doc 07
  /// §1.5.
  static const EscenaCinematica kurzAparece = EscenaCinematica(
    id: '1.5',
    titulo: 'Kurz aparece',
    flagDeSalida: 'escena_1_5_vista',
    flagsRequeridos: {'escena_1_4_vista'},
    planos: [
      PlanoAmbiente(
        duracion: Duration(milliseconds: 1800),
        textoLectura: 'De vuelta a la azotea. La noche más cerrada.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.sora,
        texto: 'Mejor.',
        pausaPrevia: Duration(milliseconds: 600),
      ),
      PlanoDialogo(
        voz: VozPersonaje.sora,
        texto: 'No tan mal.',
        pausaPrevia: Duration(milliseconds: 700),
      ),
      PlanoDialogo(
        voz: VozPersonaje.sora,
        texto: 'Vale. Hoy tienes un regalo.',
        pausaPrevia: Duration(milliseconds: 900),
      ),
      PlanoAmbiente(
        duracion: Duration(milliseconds: 1600),
        textoLectura: 'Sora silba. Algo grande baja del cielo.',
      ),
      PlanoAmbiente(
        duracion: Duration(milliseconds: 2200),
        textoLectura:
            'Brazos largos. Cabeza redonda. Ojos. Sobre él, el valor 3/4.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.fragmentoKurz,
        texto: 'Otro.',
        pausaPrevia: Duration(milliseconds: 700),
      ),
      PlanoDialogo(
        voz: VozPersonaje.fragmentoKurz,
        texto: 'Pequeño.',
        pausaPrevia: Duration(milliseconds: 800),
      ),
      PlanoDialogo(
        voz: VozPersonaje.sora,
        texto:
            'Es Kurz. Lleva aquí más tiempo que yo. Es un Fragmento nombrado. No se disuelve — se retira y vuelve.',
        pausaPrevia: Duration(milliseconds: 900),
      ),
      PlanoDialogo(
        voz: VozPersonaje.sora,
        texto: 'Sirve para poneros a prueba. No es malo.',
        pausaPrevia: Duration(milliseconds: 700),
      ),
      PlanoDialogo(
        voz: VozPersonaje.sora,
        texto: 'Pero es mejor que tú. Todavía.',
        pausaPrevia: Duration(milliseconds: 800),
      ),
      PlanoDialogo(
        voz: VozPersonaje.fragmentoKurz,
        texto: '¿Empezamos?',
        pausaPrevia: Duration(milliseconds: 900),
      ),
      PlanoAmbiente(
        duracion: Duration(milliseconds: 1800),
        textoLectura: 'El combate llega y se va. No hay forma de ganar hoy.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.fragmentoKurz,
        texto: 'Muy lento.',
        pausaPrevia: Duration(milliseconds: 700),
      ),
      PlanoDialogo(
        voz: VozPersonaje.fragmentoKurz,
        texto: 'Otra vez mal.',
        pausaPrevia: Duration(milliseconds: 700),
      ),
      PlanoDialogo(
        voz: VozPersonaje.fragmentoKurz,
        texto: 'Tenías que haberlo visto venir.',
        pausaPrevia: Duration(milliseconds: 800),
      ),
      PlanoAmbiente(
        duracion: Duration(milliseconds: 1600),
        textoLectura: 'Kurz se acerca. Calmo.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.fragmentoKurz,
        texto: 'Ya está. No pasa nada.',
        pausaPrevia: Duration(milliseconds: 800),
      ),
    ],
  );

  /// 1.6 — La derrota. Cierre emocional tras perder contra Kurz. Primera
  /// media sonrisa de Sora y primera aparición del botón HASTA MAÑANA.
  /// Doc 07 §1.6. Doc 13 storyboard 2.
  static const EscenaCinematica primeraDerrota = EscenaCinematica(
    id: '1.6',
    titulo: 'La derrota',
    flagDeSalida: 'escena_1_6_vista',
    flagsRequeridos: {'combate_kurz_1_completado'},
    esCierreAmable: true,
    planos: [
      PlanoAmbiente(
        duracion: Duration(milliseconds: 1800),
        textoLectura:
            'Negro. La azotea vuelve. Sentado en el suelo. Kurz se aleja.',
      ),
      PlanoAmbiente(
        duracion: Duration(milliseconds: 1400),
        textoLectura: 'Sora se acerca. Tiende la mano.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.sora,
        texto: 'Bien.',
        pausaPrevia: Duration(milliseconds: 500),
      ),
      PlanoDialogo(
        voz: VozPersonaje.sora,
        texto: 'En serio. Bien.',
        pausaPrevia: Duration(milliseconds: 800),
      ),
      PlanoDialogo(
        voz: VozPersonaje.sora,
        texto:
            'La primera vez se pierde. Siempre. Yo también perdí contra Kurz mi primera vez.',
        pausaPrevia: Duration(milliseconds: 900),
      ),
      PlanoDialogo(
        voz: VozPersonaje.sora,
        texto: 'Y la segunda.',
        pausaPrevia: Duration(milliseconds: 700),
      ),
      PlanoDialogo(
        voz: VozPersonaje.sora,
        texto: 'Y la tercera.',
        pausaPrevia: Duration(milliseconds: 700),
      ),
      PlanoAmbiente(
        duracion: Duration(milliseconds: 1400),
        textoLectura:
            'Primera media sonrisa. Apenas un ángulo de la boca.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.sora,
        texto: 'La cuarta gané. Y no se olvida.',
        pausaPrevia: Duration(milliseconds: 700),
      ),
      PlanoDialogo(
        voz: VozPersonaje.sora,
        texto:
            'Kurz va a volver. Cuando estés listo, vuelves tú a él. Y le ganas.',
        pausaPrevia: Duration(milliseconds: 900),
      ),
      PlanoEleccion(
        voz: VozPersonaje.sora,
        textoPrompt: '¿Lo pillas?',
        opciones: [
          OpcionEleccion(
            textoJugador: 'Sí.',
            textoRespuesta: 'Mm.',
            flagsAEstablecer: {'derrota_respuesta_si'},
          ),
          OpcionEleccion(
            textoJugador: '¿Y si no puedo?',
            textoRespuesta: 'Puedes. No hoy. Pero puedes.',
            flagsAEstablecer: {'derrota_respuesta_duda'},
          ),
          OpcionEleccion(
            textoJugador: '— quedarte callado —',
            textoRespuesta: 'Vale. Vamos a descansar.',
            flagsAEstablecer: {'derrota_respuesta_silencio'},
          ),
        ],
      ),
      PlanoCierreAmable(),
    ],
  );

  /// 1.7 — Kai visto de lejos. Pausa en un punto elevado, Sora señala a
  /// otro aprendiz. Kai asiente sin sonrisa y se va. Doc 07 §1.7.
  /// Cierre amable: al terminar, vuelta al mapa en lugar de encadenar.
  static const EscenaCinematica kaiVistoDeLejos = EscenaCinematica(
    id: '1.7',
    titulo: 'Kai visto de lejos',
    flagDeSalida: 'escena_1_7_vista',
    flagsRequeridos: {'escena_1_6_vista'},
    esCierreAmable: true,
    planos: [
      PlanoAmbiente(
        duracion: Duration(milliseconds: 2000),
        textoLectura:
            'Otra noche. Punto elevado de la azotea. Otro aprendiz entrena a 30 metros.',
      ),
      PlanoAmbiente(
        duracion: Duration(milliseconds: 1600),
        textoLectura: 'Se mueve con soltura. No es el primer día que lo hace.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.sora,
        texto: 'Ese es Kai.',
        pausaPrevia: Duration(milliseconds: 700),
      ),
      PlanoDialogo(
        voz: VozPersonaje.sora,
        texto: 'Lleva cuatro años entrenando.',
        pausaPrevia: Duration(milliseconds: 800),
      ),
      PlanoDialogo(
        voz: VozPersonaje.sora,
        texto: 'Es bueno.',
        pausaPrevia: Duration(milliseconds: 800),
      ),
      PlanoAmbiente(
        duracion: Duration(milliseconds: 2000),
        textoLectura:
            'Kai termina, se echa la mochila al hombro. Pasa cerca.',
      ),
      PlanoAmbiente(
        duracion: Duration(milliseconds: 1800),
        textoLectura:
            'Asiente a Sora — saludo profesional. A ti te mira un segundo. Sin sonrisa. Registrando.',
      ),
      PlanoAmbiente(
        duracion: Duration(milliseconds: 1400),
        textoLectura: 'Sigue bajando.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.sora,
        texto: 'Él va dos rangos por delante.',
        pausaPrevia: Duration(milliseconds: 900),
      ),
      PlanoDialogo(
        voz: VozPersonaje.sora,
        texto: 'Algún día te lo vas a encontrar de verdad.',
        pausaPrevia: Duration(milliseconds: 900),
      ),
      PlanoAmbiente(
        duracion: Duration(milliseconds: 1600),
        textoLectura: 'Sora te ofrece una cantimplora.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.sora,
        texto: 'Bebe. Toca otra ronda.',
        pausaPrevia: Duration(milliseconds: 700),
      ),
    ],
  );

  /// 1.9 — Los Plenos. Sora introduce el concepto de Impropio sumando
  /// tres medios. Doc 07 §1.9. Requiere `fr_05_competente` — activado por
  /// el motor de maestría cuando el niño domina FR.05 (suma de
  /// fracciones con mismo denominador). Hasta entonces la escena queda
  /// latente en el catálogo.
  static const EscenaCinematica losPlenos = EscenaCinematica(
    id: '1.9',
    titulo: 'Los Plenos',
    flagDeSalida: 'escena_1_9_vista',
    flagsRequeridos: {'escena_1_7_vista', 'fr_05_competente'},
    esCierreAmable: true,
    planos: [
      PlanoAmbiente(
        duracion: Duration(milliseconds: 1800),
        textoLectura: 'Azotea nueva al norte. Cinco Fragmentos orbitan.',
      ),
      PlanoAmbiente(
        duracion: Duration(milliseconds: 1600),
        textoLectura: 'Tres medios. Dos tercios. Todos flotando.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.sora,
        texto: 'Mira.',
        pausaPrevia: Duration(milliseconds: 600),
      ),
      PlanoEleccion(
        voz: VozPersonaje.sora,
        textoPrompt: '¿Cuántos medios ves?',
        opciones: [
          OpcionEleccion(
            textoJugador: 'Tres.',
            textoRespuesta: 'Bien.',
            flagsAEstablecer: {'plenos_respuesta_correcta'},
          ),
          OpcionEleccion(
            textoJugador: 'Cinco.',
            textoRespuesta:
                'No. Cinco son todos. Tres son los medios. Otra vez.',
            flagsAEstablecer: {'plenos_respuesta_incorrecta'},
          ),
        ],
      ),
      PlanoDialogo(
        voz: VozPersonaje.sora,
        texto: 'Si sumas los tres medios...',
        pausaPrevia: Duration(milliseconds: 800),
      ),
      PlanoDialogo(
        voz: VozPersonaje.sora,
        texto: '¿Cuánto tienes?',
        pausaPrevia: Duration(milliseconds: 600),
      ),
      PlanoAmbiente(
        duracion: Duration(milliseconds: 2200),
        textoLectura: 'Los tres medios se fusionan. 3/2. Se desborda.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.sora,
        texto: 'Tres medios. Más de uno entero.',
        pausaPrevia: Duration(milliseconds: 700),
      ),
      PlanoDialogo(
        voz: VozPersonaje.sora,
        texto: 'Cuando pasa de uno, se llama impropio.',
        pausaPrevia: Duration(milliseconds: 800),
      ),
      PlanoDialogo(
        voz: VozPersonaje.sora,
        texto: 'Son más grandes. Más trabajo.',
        pausaPrevia: Duration(milliseconds: 700),
      ),
      PlanoDialogo(
        voz: VozPersonaje.sora,
        texto: 'Pero aún no. Hoy, solo practica la suma.',
        pausaPrevia: Duration(milliseconds: 800),
      ),
    ],
  );

  /// 1.11 — La cena que no se ve. Plaza pequeña, mesa fuera de un bar
  /// cerrado pero iluminado. Sora y el jugador comen en silencio. Doc 07
  /// §1.11. Cierre amable: termina en silencio, deja respiración.
  static const EscenaCinematica laCena = EscenaCinematica(
    id: '1.11',
    titulo: 'La cena que no se ve',
    flagDeSalida: 'escena_1_11_vista',
    flagsRequeridos: {'escena_1_7_vista'},
    esCierreAmable: true,
    planos: [
      PlanoAmbiente(
        duracion: Duration(milliseconds: 2200),
        textoLectura:
            'Plaza pequeña. Mesa fuera de un bar cerrado pero iluminado.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.sora,
        texto: 'Come.',
        pausaPrevia: Duration(milliseconds: 700),
      ),
      PlanoAmbiente(
        duracion: Duration(milliseconds: 2400),
        textoLectura:
            'Mastican en silencio. Una pareja pasa riéndose. Sora los mira un instante.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.sora,
        texto: 'No todo es entrenar.',
        pausaPrevia: Duration(milliseconds: 900),
      ),
      PlanoDialogo(
        voz: VozPersonaje.sora,
        texto: 'Aunque lo parezca.',
        pausaPrevia: Duration(milliseconds: 800),
      ),
      PlanoAmbiente(
        duracion: Duration(milliseconds: 2600),
        textoLectura: 'Sora termina antes. Mira al cielo. Dos lunas.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.sora,
        texto: 'Las dos esta noche.',
        pausaPrevia: Duration(milliseconds: 700),
      ),
      PlanoEleccion(
        voz: VozPersonaje.sora,
        opciones: [
          OpcionEleccion(
            textoJugador: '¿Y cuando no están las dos?',
            textoRespuesta: 'Eso es otro tema. Come.',
            flagsAEstablecer: {'cena_pregunta_lunas'},
          ),
          OpcionEleccion(
            textoJugador: '— quedarte callado —',
            textoRespuesta:
                'Vamos. Duermes mucho mejor si entrenas antes.',
            flagsAEstablecer: {'cena_silencio'},
          ),
        ],
      ),
      PlanoAmbiente(
        duracion: Duration(milliseconds: 1800),
        textoLectura: 'Deja unas monedas en la mesa al levantarse.',
      ),
    ],
  );

  /// 1.10pre — Kurz vuelve. Cinemática breve antes del segundo combate.
  /// Doc 07 §1.10. Se dispara cuando el niño ya pasó la cena (proxy de
  /// "tras 2-3 entrenamientos").
  static const EscenaCinematica kurzVuelve = EscenaCinematica(
    id: '1.10pre',
    titulo: 'Kurz vuelve',
    flagDeSalida: 'escena_1_10_pre_vista',
    flagsRequeridos: {'escena_1_11_vista'},
    planos: [
      PlanoAmbiente(
        duracion: Duration(milliseconds: 1800),
        textoLectura: 'La azotea otra vez. Otra noche. Sora silba.',
      ),
      PlanoAmbiente(
        duracion: Duration(milliseconds: 1800),
        textoLectura:
            'Kurz baja del cielo. Más grande. Sobre él, el valor 5/6.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.fragmentoKurz,
        texto: 'Otra vez.',
        pausaPrevia: Duration(milliseconds: 700),
      ),
      PlanoDialogo(
        voz: VozPersonaje.fragmentoKurz,
        texto: 'A ver.',
        pausaPrevia: Duration(milliseconds: 700),
      ),
    ],
  );

  /// 1.10cierre (derrota) — frase corta, mano de Sora un instante.
  /// Doc 07 §1.10 rama "Si pierde".
  static const EscenaCinematica kurzVuelveDerrota = EscenaCinematica(
    id: '1.10derrota',
    titulo: 'Kurz vuelve — cierre derrota',
    flagDeSalida: 'escena_1_10_resuelta',
    flagsRequeridos: {'derrota_kurz_2'},
    esCierreAmable: true,
    planos: [
      PlanoDialogo(
        voz: VozPersonaje.fragmentoKurz,
        texto: 'Casi.',
        pausaPrevia: Duration(milliseconds: 700),
      ),
      PlanoDialogo(
        voz: VozPersonaje.fragmentoKurz,
        texto: 'Otra vez la semana que viene.',
        pausaPrevia: Duration(milliseconds: 800),
      ),
      PlanoDialogo(
        voz: VozPersonaje.sora,
        texto: 'Has durado más.',
        pausaPrevia: Duration(milliseconds: 800),
      ),
      PlanoDialogo(
        voz: VozPersonaje.sora,
        texto: 'Bastante más.',
        pausaPrevia: Duration(milliseconds: 700),
      ),
      PlanoAmbiente(
        duracion: Duration(milliseconds: 1800),
        textoLectura:
            'Sora pone la mano en tu hombro un instante. La aparta rápido.',
      ),
    ],
  );

  /// 1.10cierre (victoria) — raro pero posible. Doc 07 §1.10 rama
  /// "Si gana".
  static const EscenaCinematica kurzVuelveVictoria = EscenaCinematica(
    id: '1.10victoria',
    titulo: 'Kurz vuelve — cierre victoria',
    flagDeSalida: 'escena_1_10_resuelta',
    flagsRequeridos: {'victoria_kurz_2'},
    esCierreAmable: true,
    planos: [
      PlanoDialogo(
        voz: VozPersonaje.fragmentoKurz,
        texto: 'Vaya.',
        pausaPrevia: Duration(milliseconds: 700),
      ),
      PlanoDialogo(
        voz: VozPersonaje.fragmentoKurz,
        texto: 'Tú ya eres otra cosa.',
        pausaPrevia: Duration(milliseconds: 800),
      ),
      PlanoDialogo(
        voz: VozPersonaje.sora,
        texto: 'Mm.',
        pausaPrevia: Duration(milliseconds: 800),
      ),
      PlanoDialogo(
        voz: VozPersonaje.sora,
        texto: 'Has ganado.',
        pausaPrevia: Duration(milliseconds: 800),
      ),
      PlanoDialogo(
        voz: VozPersonaje.sora,
        texto: 'No suelen ganar la segunda.',
        pausaPrevia: Duration(milliseconds: 900),
      ),
      PlanoDialogo(
        voz: VozPersonaje.sora,
        texto: 'Irune querrá verte.',
        pausaPrevia: Duration(milliseconds: 800),
      ),
    ],
  );

  /// 1.12pre — Hoy. Doc 07 §1.12. Sora declara que el niño está listo,
  /// silba, Kurz baja por última vez. La azotea está al atardecer
  /// (única escena con luz distinta). Se dispara tras la 1.10 resuelta.
  static const EscenaCinematica kurzVencidoPre = EscenaCinematica(
    id: '1.12pre',
    titulo: 'Hoy',
    flagDeSalida: 'escena_1_12_pre_vista',
    flagsRequeridos: {'escena_1_10_resuelta'},
    planos: [
      PlanoAmbiente(
        duracion: Duration(milliseconds: 2400),
        textoLectura:
            'La azotea al atardecer. Por primera vez no es de noche.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.sora,
        texto: 'Hoy.',
        pausaPrevia: Duration(milliseconds: 700),
      ),
      PlanoDialogo(
        voz: VozPersonaje.sora,
        texto: 'Hoy estás listo.',
        pausaPrevia: Duration(milliseconds: 800),
      ),
      PlanoAmbiente(
        duracion: Duration(milliseconds: 2000),
        textoLectura:
            'Silba. Kurz baja. La azotea tiembla un poco. 7/8 sobre él.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.fragmentoKurz,
        texto: 'Ah.',
        pausaPrevia: Duration(milliseconds: 800),
      ),
      PlanoDialogo(
        voz: VozPersonaje.fragmentoKurz,
        texto: 'Te noto distinto.',
        pausaPrevia: Duration(milliseconds: 700),
      ),
      PlanoDialogo(
        voz: VozPersonaje.fragmentoKurz,
        texto: 'Vamos.',
        pausaPrevia: Duration(milliseconds: 700),
      ),
    ],
  );

  /// 1.12cierre (victoria) — esperado. Doc 07 §1.12. Activa
  /// `escena_1_12_vista` para que la 1.13 ceremonia se dispare.
  static const EscenaCinematica kurzVencidoVictoria = EscenaCinematica(
    id: '1.12victoria',
    titulo: 'Kurz vencido',
    flagDeSalida: 'escena_1_12_vista',
    flagsRequeridos: {'victoria_kurz_3'},
    esCierreAmable: true,
    planos: [
      PlanoAmbiente(
        duracion: Duration(milliseconds: 2200),
        textoLectura: 'Kurz se hace pequeño. Sube despacio.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.fragmentoKurz,
        texto: 'Nos veremos cuando seas Iniciado.',
        pausaPrevia: Duration(milliseconds: 800),
      ),
      PlanoAmbiente(
        duracion: Duration(milliseconds: 1800),
        textoLectura: 'Sora asiente una vez, muy despacio.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.sora,
        texto: 'Ya está.',
        pausaPrevia: Duration(milliseconds: 700),
      ),
      PlanoDialogo(
        voz: VozPersonaje.sora,
        texto: 'Ya eres algo más que un aprendiz.',
        pausaPrevia: Duration(milliseconds: 900),
      ),
      PlanoAmbiente(
        duracion: Duration(milliseconds: 2200),
        textoLectura:
            'Mira hacia la puerta. Irune está ahí. Asiente de lejos. Entra.',
      ),
    ],
  );

  /// 1.12cierre (derrota) — el niño aún no estaba listo. Vuelve a casa
  /// sin avance. Tendrá que rejugarlo otra vez (en el prototipo basta
  /// con activar el mismo flag combate_kurz_3_completado para volver a
  /// disparar el combate la próxima sesión... no implementado todavía).
  static const EscenaCinematica kurzVencidoDerrota = EscenaCinematica(
    id: '1.12derrota',
    titulo: 'Hoy aún no',
    flagDeSalida: 'escena_1_12_derrota_vista',
    flagsRequeridos: {'derrota_kurz_3'},
    esCierreAmable: true,
    planos: [
      PlanoDialogo(
        voz: VozPersonaje.fragmentoKurz,
        texto: 'Otra vez. La semana que viene.',
        pausaPrevia: Duration(milliseconds: 700),
      ),
      PlanoDialogo(
        voz: VozPersonaje.sora,
        texto: 'Mañana.',
        pausaPrevia: Duration(milliseconds: 900),
      ),
      PlanoDialogo(
        voz: VozPersonaje.sora,
        texto: 'Estabas cerca.',
        pausaPrevia: Duration(milliseconds: 800),
      ),
    ],
  );

  /// 1.13 — Las palabras de Irune. Ceremonia de Aprendiz II. Doc 07
  /// §1.13. Latente hasta que el jugador derrote a Kurz por segunda vez
  /// (`escena_1_12_vista`) y haya alcanzado el rango Aprendiz II.
  static const EscenaCinematica palabrasDeIrune = EscenaCinematica(
    id: '1.13',
    titulo: 'Las palabras de Irune',
    flagDeSalida: 'escena_1_13_vista',
    flagsRequeridos: {
      'escena_1_12_vista',
      'rango_aprendiz_ii_alcanzado',
    },
    esCierreAmable: true,
    planos: [
      PlanoAmbiente(
        duracion: Duration(milliseconds: 2400),
        textoLectura:
            'La sala de Irune. La luz más cálida que la primera vez.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.irune,
        texto: 'Siéntate.',
        pausaPrevia: Duration(milliseconds: 600),
      ),
      PlanoDialogo(
        voz: VozPersonaje.irune,
        texto:
            'No te voy a felicitar. Sora tampoco. No es nuestro estilo.',
        pausaPrevia: Duration(milliseconds: 900),
      ),
      PlanoDialogo(
        voz: VozPersonaje.irune,
        texto: 'Pero lo que has hecho es real.',
        pausaPrevia: Duration(milliseconds: 800),
      ),
      PlanoDialogo(
        voz: VozPersonaje.irune,
        texto:
            'La gente habla de rangos como si fueran diplomas. No lo son. Son responsabilidades.',
        pausaPrevia: Duration(milliseconds: 1000),
      ),
      PlanoDialogo(
        voz: VozPersonaje.irune,
        texto:
            'Ahora eres Aprendiz II. Eso quiere decir que puedes salir del Edificio de los Tejados sin que Sora vaya detrás.',
        pausaPrevia: Duration(milliseconds: 900),
      ),
      PlanoDialogo(
        voz: VozPersonaje.irune,
        texto:
            'Vas a hacerte amigos, enemigos, dudas. Sobre todo dudas.',
        pausaPrevia: Duration(milliseconds: 900),
      ),
      PlanoDialogo(
        voz: VozPersonaje.irune,
        texto:
            'Mañana puedes bajar a los Canales. Si quieres. O no. Tú decides.',
        pausaPrevia: Duration(milliseconds: 900),
      ),
      PlanoDialogo(
        voz: VozPersonaje.irune,
        texto: 'Y una cosa más.',
        pausaPrevia: Duration(milliseconds: 800),
      ),
      PlanoDialogo(
        voz: VozPersonaje.irune,
        texto: 'Hace mucho que no ponía una marca de Aprendiz II.',
        pausaPrevia: Duration(milliseconds: 1000),
      ),
      PlanoAmbiente(
        duracion: Duration(milliseconds: 2200),
        textoLectura:
            'Silencio. Irune deja respirar la frase un momento largo.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.irune,
        texto:
            'Me alegro de que vuelva a haber alguien que la merezca.',
        pausaPrevia: Duration(milliseconds: 700),
      ),
      PlanoAmbiente(
        duracion: Duration(milliseconds: 2200),
        textoLectura:
            'Te pone una marca plateada al cuello. Una cuerda fina. Frío al principio, luego templada.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.irune,
        texto: 'Bienvenido, Aprendiz II.',
        pausaPrevia: Duration(milliseconds: 700),
      ),
      PlanoDialogo(
        voz: VozPersonaje.irune,
        texto: 'Ya puedes irte. Duerme.',
        pausaPrevia: Duration(milliseconds: 900),
      ),
      PlanoCierreAmable(),
    ],
  );

  /// 1.14 — Los Canales desde arriba. Cierre del Arco I. Doc 07 §1.14.
  /// Sora regala su brújula vieja al jugador (objeto narrativo que
  /// reaparecerá en el Arco IV).
  static const EscenaCinematica canalesDesdeArriba = EscenaCinematica(
    id: '1.14',
    titulo: 'Los Canales desde arriba',
    flagDeSalida: 'escena_1_14_vista',
    flagsRequeridos: {'escena_1_13_vista'},
    esCierreAmable: true,
    planos: [
      PlanoAmbiente(
        duracion: Duration(milliseconds: 2600),
        textoLectura:
            'Borde de la azotea. Sora sentada con las piernas colgando, sin miedo. Mira al norte.',
      ),
      PlanoAmbiente(
        duracion: Duration(milliseconds: 2200),
        textoLectura:
            'Abajo, los Canales: puentes pequeños iluminados, reflejos amarillos en el agua. Una ciudad dentro de la ciudad.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.sora,
        texto: 'Siéntate.',
        pausaPrevia: Duration(milliseconds: 700),
      ),
      PlanoDialogo(
        voz: VozPersonaje.sora,
        texto: 'Allí vas a ir mañana.',
        pausaPrevia: Duration(milliseconds: 900),
      ),
      PlanoDialogo(
        voz: VozPersonaje.sora,
        texto: 'Los Canales.',
        pausaPrevia: Duration(milliseconds: 700),
      ),
      PlanoDialogo(
        voz: VozPersonaje.sora,
        texto: 'Maestro Rexán.',
        pausaPrevia: Duration(milliseconds: 800),
      ),
      PlanoDialogo(
        voz: VozPersonaje.sora,
        texto:
            'Va a caerte bien. Es el tipo más simpático de la orden. No te fíes del todo — lo usa.',
        pausaPrevia: Duration(milliseconds: 1000),
      ),
      PlanoDialogo(
        voz: VozPersonaje.sora,
        texto: 'Tiene una cojera. No preguntes por ella.',
        pausaPrevia: Duration(milliseconds: 900),
      ),
      PlanoDialogo(
        voz: VozPersonaje.sora,
        texto: 'Algún día te lo contará. O no. Ya verás.',
        pausaPrevia: Duration(milliseconds: 900),
      ),
      PlanoDialogo(
        voz: VozPersonaje.sora,
        texto: 'Tienes que ir solo. Yo te esperaré aquí.',
        pausaPrevia: Duration(milliseconds: 900),
      ),
      PlanoDialogo(
        voz: VozPersonaje.sora,
        texto: 'Sí. Solo.',
        pausaPrevia: Duration(milliseconds: 800),
      ),
      PlanoDialogo(
        voz: VozPersonaje.sora,
        texto: 'No te asustes. Rexán es buena gente. Y tú ya no eres tan nuevo.',
        pausaPrevia: Duration(milliseconds: 900),
      ),
      PlanoAmbiente(
        duracion: Duration(milliseconds: 2400),
        textoLectura:
            'Sora saca una pequeña brújula de bolsillo. No mágica. Solo una brújula.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.sora,
        texto: 'Toma. Era mía cuando empecé aquí.',
        pausaPrevia: Duration(milliseconds: 700),
      ),
      PlanoDialogo(
        voz: VozPersonaje.sora,
        texto: 'Devuélvemela cuando vuelvas.',
        pausaPrevia: Duration(milliseconds: 900),
      ),
      PlanoAmbiente(
        duracion: Duration(milliseconds: 2400),
        textoLectura:
            'Mira otra vez hacia los Canales. Viento. Fundido lento.',
      ),
      PlanoCierreAmable(textoBoton: 'HASTA MAÑANA'),
    ],
  );

  // ============================================================
  // Arco 2 — Canales y Zafrán. Doc 08.
  // ============================================================

  /// 2.1 — Bajar solo. Sora despide al jugador en la escalera del
  /// Edificio de los Tejados. Primera vez que va por la ciudad sin ella.
  /// Doc 08 §2.1.
  static const EscenaCinematica bajarSolo = EscenaCinematica(
    id: '2.1',
    titulo: 'Bajar solo',
    flagDeSalida: 'escena_2_1_vista',
    flagsRequeridos: {'escena_1_14_vista'},
    planos: [
      PlanoAmbiente(
        duracion: Duration(milliseconds: 2000),
        textoLectura:
            'Escalera que baja del Edificio de los Tejados. Niebla baja en las calles.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.sora,
        texto: 'Ya.',
        pausaPrevia: Duration(milliseconds: 600),
      ),
      PlanoDialogo(
        voz: VozPersonaje.sora,
        texto: 'Vete.',
        pausaPrevia: Duration(milliseconds: 800),
      ),
      PlanoDialogo(
        voz: VozPersonaje.sora,
        texto:
            'Si te pasa algo, vuelves corriendo. No te hagas el valiente.',
        pausaPrevia: Duration(milliseconds: 900),
      ),
      PlanoDialogo(
        voz: VozPersonaje.sora,
        texto: 'Y si tardas mucho, voy yo.',
        pausaPrevia: Duration(milliseconds: 900),
      ),
      PlanoAmbiente(
        duracion: Duration(milliseconds: 2400),
        textoLectura:
            'Calles estrechas. Una pareja en un portal. Un gato dormido. Un Fragmento tonto se disuelve solo.',
      ),
      PlanoAmbiente(
        duracion: Duration(milliseconds: 2000),
        textoLectura:
            'La luz cambia — más amarilla. El agua aparece entre las piedras.',
      ),
      PlanoAmbiente(
        duracion: Duration(milliseconds: 2200),
        textoLectura: 'BARRIO DE LOS CANALES',
      ),
      PlanoAmbiente(
        duracion: Duration(milliseconds: 2400),
        textoLectura:
            'Al otro lado de un puente, un hombre mayor sentado en un saliente. Lee. Levanta la vista. Sonríe.',
      ),
    ],
  );

  /// 2.2 — Rexán. Primer encuentro con el Maestro de los Canales.
  /// Introduce la equivalencia de fracciones (FR.09). Doc 08 §2.2.
  static const EscenaCinematica conocerARexan = EscenaCinematica(
    id: '2.2',
    titulo: 'Rexán',
    flagDeSalida: 'escena_2_2_vista',
    flagsRequeridos: {'escena_2_1_vista'},
    planos: [
      PlanoAmbiente(
        duracion: Duration(milliseconds: 2000),
        textoLectura: 'Se levanta. Cojea. No lo esconde ni lo señala.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.rexan,
        texto: 'A ver, a ver.',
        pausaPrevia: Duration(milliseconds: 700),
      ),
      PlanoAmbiente(
        duracion: Duration(milliseconds: 1600),
        textoLectura: 'Primera sonrisa abierta de un adulto en el juego.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.rexan,
        texto: 'Tú eres el que Sora manda.',
        pausaPrevia: Duration(milliseconds: 700),
      ),
      PlanoAmbiente(
        duracion: Duration(milliseconds: 1400),
        textoLectura: 'Tiende la mano.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.rexan,
        texto: 'Rexán. Maestro de los Canales, dicen. Yo me llamo Rexán. Sin más.',
        pausaPrevia: Duration(milliseconds: 900),
      ),
      PlanoDialogo(
        voz: VozPersonaje.rexan,
        texto:
            'Tú ya sabes lo que es un Fragmento. Sabes sumar trozos cuando son iguales. Ya eres Aprendiz II. No está mal.',
        pausaPrevia: Duration(milliseconds: 1000),
      ),
      PlanoDialogo(
        voz: VozPersonaje.rexan,
        texto: 'Aquí vas a aprender algo distinto.',
        pausaPrevia: Duration(milliseconds: 900),
      ),
      PlanoAmbiente(
        duracion: Duration(milliseconds: 2200),
        textoLectura:
            'Señala el canal. Dos Fragmentos flotan sobre el agua: 1/2 y 2/4.',
      ),
      PlanoEleccion(
        voz: VozPersonaje.rexan,
        textoPrompt: '¿Cuál es más grande?',
        opciones: [
          OpcionEleccion(
            textoJugador: 'El segundo.',
            textoRespuesta:
                'Mm. ¿Seguro? Míralos otra vez. Mira el agua.',
            flagsAEstablecer: {'rexan_equivalencia_error'},
          ),
          OpcionEleccion(
            textoJugador: 'El primero.',
            textoRespuesta:
                'Mm. ¿Seguro? Míralos otra vez. Mira el agua.',
            flagsAEstablecer: {'rexan_equivalencia_error'},
          ),
          OpcionEleccion(
            textoJugador: 'Son iguales.',
            textoRespuesta: 'Bien, {nombre}. Bien.',
            flagsAEstablecer: {'rexan_equivalencia_acierto'},
          ),
        ],
      ),
      PlanoAmbiente(
        duracion: Duration(milliseconds: 1800),
        textoLectura:
            'Los dos Fragmentos orbitan despacio y se fusionan en uno.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.rexan,
        texto: 'Son la misma cosa. Con nombres distintos.',
        pausaPrevia: Duration(milliseconds: 800),
      ),
      PlanoDialogo(
        voz: VozPersonaje.rexan,
        texto: 'Un medio. Dos cuartos. Mismo trozo de mundo.',
        pausaPrevia: Duration(milliseconds: 900),
      ),
      PlanoDialogo(
        voz: VozPersonaje.rexan,
        texto: 'Eso se llama equivaler.',
        pausaPrevia: Duration(milliseconds: 900),
      ),
      PlanoDialogo(
        voz: VozPersonaje.rexan,
        texto: 'Toda verdad tiene otra forma igualmente verdadera.',
        pausaPrevia: Duration(milliseconds: 1000),
      ),
      PlanoDialogo(
        voz: VozPersonaje.rexan,
        texto: 'Es lo que aprendes aquí. Lo demás viene después.',
        pausaPrevia: Duration(milliseconds: 900),
      ),
      PlanoDialogo(
        voz: VozPersonaje.rexan,
        texto: 'Vamos. Te enseño el barrio.',
        pausaPrevia: Duration(milliseconds: 900),
      ),
    ],
  );

  /// 2.3 — El primer Fragmento Espejo. Tutorial narrativo de familia D
  /// (Espejo) + mecánica de emparejar por equivalencia. La mecánica
  /// real se experimenta en el cazadero libre. Doc 08 §2.3.
  static const EscenaCinematica primerEspejo = EscenaCinematica(
    id: '2.3',
    titulo: 'El primer Fragmento Espejo',
    flagDeSalida: 'escena_2_3_vista',
    flagsRequeridos: {'escena_2_2_vista'},
    esCierreAmable: true,
    planos: [
      PlanoAmbiente(
        duracion: Duration(milliseconds: 2200),
        textoLectura:
            'Callejón junto al canal. Dos Fragmentos emergen a la vez, con el mismo halo: 3/4 y 6/8.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.rexan,
        texto: 'Fragmentos Espejo.',
        pausaPrevia: Duration(milliseconds: 700),
      ),
      PlanoDialogo(
        voz: VozPersonaje.rexan,
        texto:
            'Se llaman así porque van en pareja. Uno parece el reflejo del otro.',
        pausaPrevia: Duration(milliseconds: 900),
      ),
      PlanoDialogo(
        voz: VozPersonaje.rexan,
        texto: 'Y casi siempre lo es.',
        pausaPrevia: Duration(milliseconds: 900),
      ),
      PlanoDialogo(
        voz: VozPersonaje.rexan,
        texto: 'Míralos bien, {nombre}. ¿Son equivalentes?',
        pausaPrevia: Duration(milliseconds: 1000),
      ),
      PlanoAmbiente(
        duracion: Duration(milliseconds: 2000),
        textoLectura:
            'Tres de cuatro. Seis de ocho. Simplifica seis de ocho y tienes tres de cuatro.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.rexan,
        texto:
            'Cuando encuentres dos así, los emparejas y se disuelven juntos. Es el gesto más limpio que puedes hacer.',
        pausaPrevia: Duration(milliseconds: 1100),
      ),
      PlanoDialogo(
        voz: VozPersonaje.rexan,
        texto:
            'A veces no son equivalentes. Entonces tienes que reconocerlo y atacar por separado. No pasa nada.',
        pausaPrevia: Duration(milliseconds: 1100),
      ),
      PlanoDialogo(
        voz: VozPersonaje.rexan,
        texto: 'Si los emparejas mal, hacen ruido. Los oyes.',
        pausaPrevia: Duration(milliseconds: 1000),
      ),
      PlanoAmbiente(
        duracion: Duration(milliseconds: 1400),
        textoLectura: 'Te guiña un ojo.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.rexan,
        texto: 'Vas a aprender a oírlos.',
        pausaPrevia: Duration(milliseconds: 800),
      ),
    ],
  );

  static const List<EscenaCinematica> todas = [
    llegada,
    primeraVentana,
    callejon,
    presentacionIrune,
    kurzAparece,
    primeraDerrota,
    kaiVistoDeLejos,
    losPlenos,
    laCena,
    kurzVuelve,
    kurzVuelveDerrota,
    kurzVuelveVictoria,
    kurzVencidoPre,
    kurzVencidoVictoria,
    kurzVencidoDerrota,
    palabrasDeIrune,
    canalesDesdeArriba,
    // Arco 2.
    bajarSolo,
    conocerARexan,
    primerEspejo,
  ];

  static EscenaCinematica? porId(String id) {
    for (final escena in todas) {
      if (escena.id == id) return escena;
    }
    return null;
  }
}
