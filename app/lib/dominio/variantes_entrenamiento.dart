import 'escena_cinematica.dart';
import 'plano_escena.dart';
import 'voz_personaje.dart';

/// Variantes recurrentes de "Entrenar con Sora" (doc 07 §1.8). Entre 4 y
/// 6 variantes durante el Arco 1, intercaladas entre las escenas
/// principales. El orquestador selecciona la siguiente variante no
/// usada recientemente cada vez que el jugador termina una cinemática
/// principal y el Arco 1 está en curso (post-1.7, pre-cierre).
///
/// No comparten el catálogo de escenas principales: esas se disparan
/// una sola vez cuando se cumplen sus prerrequisitos; las variantes se
/// rotan y pueden repetirse tras agotar el pool.
class VariantesEntrenamiento {
  /// 1.8a — Noche despejada. Rítmica, pedagógica.
  static const EscenaCinematica nocheDespejada = EscenaCinematica(
    id: '1.8a',
    titulo: 'Entrenar — noche despejada',
    flagDeSalida: 'variante_1_8_a_usada',
    esCierreAmable: true,
    planos: [
      PlanoAmbiente(
        duracion: Duration(milliseconds: 1800),
        textoLectura:
            'Noche despejada. Las dos lunas bajas, claras.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.sora,
        texto: 'Arriba. Abajo. Arriba. Abajo.',
        pausaPrevia: Duration(milliseconds: 600),
      ),
      PlanoDialogo(
        voz: VozPersonaje.sora,
        texto: 'Céntrate.',
        pausaPrevia: Duration(milliseconds: 700),
      ),
      PlanoDialogo(
        voz: VozPersonaje.sora,
        texto: 'Cuando se parte un Fragmento, no pienses en las partes.',
        pausaPrevia: Duration(milliseconds: 900),
      ),
      PlanoDialogo(
        voz: VozPersonaje.sora,
        texto: 'Piensa en el tamaño de cada parte.',
        pausaPrevia: Duration(milliseconds: 800),
      ),
      PlanoDialogo(
        voz: VozPersonaje.sora,
        texto: 'Las partes pequeñas son más fáciles. Siempre.',
        pausaPrevia: Duration(milliseconds: 900),
      ),
      PlanoDialogo(
        voz: VozPersonaje.sora,
        texto: 'Otra vez.',
        pausaPrevia: Duration(milliseconds: 700),
      ),
    ],
  );

  /// 1.8b — Niebla. Sesión más corta, Sora casi supersticiosa.
  static const EscenaCinematica niebla = EscenaCinematica(
    id: '1.8b',
    titulo: 'Entrenar — niebla',
    flagDeSalida: 'variante_1_8_b_usada',
    esCierreAmable: true,
    planos: [
      PlanoAmbiente(
        duracion: Duration(milliseconds: 2000),
        textoLectura:
            'Niebla baja. No se ven las lunas. La ciudad se oye pero no se ve.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.sora,
        texto: 'Días así, hay más Fragmentos.',
        pausaPrevia: Duration(milliseconds: 700),
      ),
      PlanoDialogo(
        voz: VozPersonaje.sora,
        texto: 'No sé por qué. Irune dice que la niebla les gusta.',
        pausaPrevia: Duration(milliseconds: 900),
      ),
      PlanoDialogo(
        voz: VozPersonaje.sora,
        texto: 'Mantente cerca.',
        pausaPrevia: Duration(milliseconds: 800),
      ),
      PlanoAmbiente(
        duracion: Duration(milliseconds: 1600),
        textoLectura: 'La sesión es más corta esta noche. Sora lo nota.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.sora,
        texto: 'Hoy no más. Mañana.',
        pausaPrevia: Duration(milliseconds: 700),
      ),
    ],
  );

  /// 1.8c — Lluvia ligera. Sora con humor.
  static const EscenaCinematica lluviaLigera = EscenaCinematica(
    id: '1.8c',
    titulo: 'Entrenar — lluvia ligera',
    flagDeSalida: 'variante_1_8_c_usada',
    esCierreAmable: true,
    planos: [
      PlanoAmbiente(
        duracion: Duration(milliseconds: 1800),
        textoLectura:
            'Lluvia ligera. Las tejas mojadas brillan bajo las farolas.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.sora,
        texto: 'Si te caes, te caes. No pasa nada.',
        pausaPrevia: Duration(milliseconds: 700),
      ),
      PlanoDialogo(
        voz: VozPersonaje.sora,
        texto: 'Cae mejor.',
        pausaPrevia: Duration(milliseconds: 800),
      ),
      PlanoAmbiente(
        duracion: Duration(milliseconds: 1400),
        textoLectura:
            'Risa corta. Solo un instante — se la traga enseguida.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.sora,
        texto: 'Vamos.',
        pausaPrevia: Duration(milliseconds: 700),
      ),
    ],
  );

  /// 1.8d — Pregunta del jugador mirando la Montaña. Tres opciones, cada
  /// una revela algo distinto sobre Sora. Doc 07 §1.8 rama D.
  static const EscenaCinematica preguntaMontana = EscenaCinematica(
    id: '1.8d',
    titulo: 'Entrenar — con la Montaña visible',
    flagDeSalida: 'variante_1_8_d_usada',
    esCierreAmable: true,
    planos: [
      PlanoAmbiente(
        duracion: Duration(milliseconds: 2200),
        textoLectura:
            'Cielo muy limpio. La Montaña se ve entera al horizonte.',
      ),
      PlanoAmbiente(
        duracion: Duration(milliseconds: 1600),
        textoLectura: 'Sora la mira sin decir nada un rato largo.',
      ),
      PlanoEleccion(
        voz: VozPersonaje.sora,
        opciones: [
          OpcionEleccion(
            textoJugador: '¿Qué hay allí?',
            textoRespuesta: 'Un Algebrista. O eso dicen. Fragmentos. Vamos.',
            flagsAEstablecer: {'sora_pregunta_montana_que'},
          ),
          OpcionEleccion(
            textoJugador: '¿Por qué entrenas tanto?',
            textoRespuesta: 'Porque no quiero llegar tarde.',
            flagsAEstablecer: {'sora_pregunta_montana_porque'},
          ),
          OpcionEleccion(
            textoJugador: '¿Tú de dónde eres?',
            textoRespuesta: 'Otro día.',
            flagsAEstablecer: {'sora_pregunta_montana_origen'},
          ),
          OpcionEleccion(
            textoJugador: '— seguir mirando en silencio —',
            textoRespuesta: 'Hablas poco. Me gusta.',
            flagsAEstablecer: {'sora_pregunta_montana_silencio'},
          ),
        ],
      ),
    ],
  );

  /// 1.8e — Tras buen entrenamiento. Sora casi amable.
  static const EscenaCinematica buenEntrenamiento = EscenaCinematica(
    id: '1.8e',
    titulo: 'Entrenar — buen entrenamiento',
    flagDeSalida: 'variante_1_8_e_usada',
    esCierreAmable: true,
    planos: [
      PlanoAmbiente(
        duracion: Duration(milliseconds: 1800),
        textoLectura:
            'La sesión termina antes de lo previsto. Sora asiente una vez.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.sora,
        texto: 'Oye.',
        pausaPrevia: Duration(milliseconds: 700),
      ),
      PlanoDialogo(
        voz: VozPersonaje.sora,
        texto: 'Aprendes rápido.',
        pausaPrevia: Duration(milliseconds: 900),
      ),
      PlanoDialogo(
        voz: VozPersonaje.sora,
        texto: 'No te lo creas mucho.',
        pausaPrevia: Duration(milliseconds: 800),
      ),
      PlanoAmbiente(
        duracion: Duration(milliseconds: 1600),
        textoLectura: 'Baja por la escalera sin girarse.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.sora,
        texto: 'Hasta mañana.',
        pausaPrevia: Duration(milliseconds: 700),
      ),
    ],
  );

  static const List<EscenaCinematica> todas = [
    nocheDespejada,
    niebla,
    lluviaLigera,
    preguntaMontana,
    buenEntrenamiento,
  ];

  /// Elige la siguiente variante: la primera no usada recientemente. Si
  /// todas están en [usadasRecientemente], devuelve `null` (señal de que
  /// el pool se ha agotado y el caller debe resetearlo).
  static EscenaCinematica? elegirSiguiente(
    Set<String> usadasRecientemente,
  ) {
    for (final variante in todas) {
      if (!usadasRecientemente.contains(variante.id)) {
        return variante;
      }
    }
    return null;
  }
}
