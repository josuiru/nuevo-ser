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

  /// 1.3 — El callejón. Una mujer mayor desorientada delante de una
  /// puerta. Sora explica el efecto residual de los Fragmentos en los
  /// adultos. Doc 07 §1.3.
  static const EscenaCinematica callejon = EscenaCinematica(
    id: '1.3',
    titulo: 'El callejón',
    flagDeSalida: 'escena_1_3_vista',
    flagsRequeridos: {'primera_sesion_combate_completa'},
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
        texto: 'Tres cosas. Escucha.',
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

  static const List<EscenaCinematica> todas = [
    llegada,
    callejon,
    presentacionIrune,
  ];

  static EscenaCinematica? porId(String id) {
    for (final escena in todas) {
      if (escena.id == id) return escena;
    }
    return null;
  }
}
