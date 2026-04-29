import 'opcion_eleccion.dart';
import 'voz_personaje.dart';

/// Un plano es la unidad atómica de una [EscenaCinematica] — el player
/// los recorre uno a uno. Cada plano tiene su propia condición de
/// avance (auto-temporizado, tap del jugador, elección, acción
/// concreta…).
///
/// Es **clase abstracta** (no sealed): cada juego puede añadir planos
/// específicos sin tocar la plataforma. Uno Roto añade `PlanoInteractivo`
/// para tutorial de Fragmentos; Las Versiones podría añadir
/// `PlanoMesaTrabajo`, `PlanoConcilio`, etc. cuando llegue el momento.
///
/// Los planos genéricos que cubren el grueso del lenguaje cinemático
/// viven aquí: [PlanoAmbiente], [PlanoDialogo], [PlanoEleccion],
/// [PlanoCierreAmable].
abstract class PlanoEscena {
  const PlanoEscena();
}

/// Plano de "pausa visual": silencio en pantalla durante [duracion]. El
/// player auto-avanza al terminar el tiempo. Si [textoLectura] está
/// presente, se muestra como acotación tenue (la sensación buscada es
/// una página que respira, no una pantalla muerta).
class PlanoAmbiente extends PlanoEscena {
  final Duration duracion;
  final String? textoLectura;

  const PlanoAmbiente({
    required this.duracion,
    this.textoLectura,
  });
}

/// Plano de diálogo: una frase de un personaje que se revela
/// letra-a-letra. El jugador toca para acelerar/saltar. Tras revelar
/// completo, el siguiente toque avanza al plano siguiente.
class PlanoDialogo extends PlanoEscena {
  final VozPersonaje voz;
  final String texto;

  /// Pausa antes de empezar el reveal — útil para respirar entre
  /// frases del mismo personaje sin romper el ritmo.
  final Duration pausaPrevia;

  const PlanoDialogo({
    required this.voz,
    required this.texto,
    this.pausaPrevia = Duration.zero,
  });
}

/// Plano de elección: un personaje pregunta y el jugador elige entre
/// 2-4 opciones. La opción elegida puede activar flags narrativos
/// persistentes y opcionalmente disparar una respuesta hablada.
class PlanoEleccion extends PlanoEscena {
  /// Quién pregunta — el nombre puede mostrarse encima del prompt si
  /// el juego lo decide así.
  final VozPersonaje voz;

  /// Pregunta opcional mostrada antes de las opciones.
  final String? textoPrompt;

  /// Entre 2 y 4 opciones. La plataforma no fuerza el rango — cada
  /// juego decide si poner más, pero la convención de diseño es 2-4
  /// para no saturar.
  final List<OpcionEleccion> opciones;

  const PlanoEleccion({
    required this.voz,
    required this.opciones,
    this.textoPrompt,
  });
}

/// Cierre ritual de una sesión. Un botón grande centrado con texto
/// tipo "HASTA MAÑANA" o "HASTA ENTONCES". Al pulsarlo se completa la
/// escena y la app termina la sesión amablemente — sin presionar a
/// seguir jugando.
///
/// Es el plano que encarna el principio del "cierre amable" compartido
/// por toda la Colección: si necesitas irte, te vas; esto no es una
/// cárcel.
class PlanoCierreAmable extends PlanoEscena {
  final String textoBoton;
  final Duration pausaPrevia;

  const PlanoCierreAmable({
    this.textoBoton = 'HASTA MAÑANA',
    this.pausaPrevia = const Duration(milliseconds: 500),
  });
}
