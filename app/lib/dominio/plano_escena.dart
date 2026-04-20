import 'voz_personaje.dart';

/// Un plano es la unidad atómica de una escena cinematográfica —
/// doc 13 principios §2.1 (planos duran, no se cortan cada segundo).
///
/// Tipos implementados en v0.1:
/// - [PlanoAmbiente]: silencio visual, auto-avanza tras [duracion].
/// - [PlanoDialogo]: frase de un personaje, el niño pulsa para avanzar
///   después del reveal letra-a-letra.
///
/// Planos pendientes: PlanoEleccion (opciones con flags), PlanoCambioFondo,
/// PlanoTransmisionObjeto (brújula, concha) — se añaden al aparecer escenas
/// que los requieran.
sealed class PlanoEscena {
  const PlanoEscena();
}

class PlanoAmbiente extends PlanoEscena {
  final Duration duracion;
  final String? textoLectura;

  const PlanoAmbiente({
    required this.duracion,
    this.textoLectura,
  });
}

class PlanoDialogo extends PlanoEscena {
  final VozPersonaje voz;
  final String texto;

  /// Pausa antes de empezar el reveal. Útil para respirar entre frases
  /// del mismo personaje — guía visual §2.4 (silencios visuales).
  final Duration pausaPrevia;

  const PlanoDialogo({
    required this.voz,
    required this.texto,
    this.pausaPrevia = Duration.zero,
  });
}

class PlanoEleccion extends PlanoEscena {
  /// Quién está preguntando (para el nombre encima del prompt si existe).
  final VozPersonaje voz;

  /// Pregunta opcional mostrada antes de las opciones.
  final String? textoPrompt;

  /// Entre 2 y 4 opciones. El niño toca una.
  final List<OpcionEleccion> opciones;

  const PlanoEleccion({
    required this.voz,
    required this.opciones,
    this.textoPrompt,
  });
}

/// Acción del niño que desbloquea el avance en un PlanoInteractivo.
/// - [dividirPleno]: swipe horizontal parte el Pleno (valor 1) en dos
///   mitades de 1/2.
/// - [desfragmentarMitades]: tap sobre cada mitad la disuelve. Avanza
///   cuando las dos están disueltas.
enum AccionEsperada { dividirPleno, desfragmentarMitades }

/// Un plano donde el niño hace una acción concreta con un Fragmento en
/// pantalla para avanzar — el tutorial de la escena 1.2 §1.2 del doc 07.
/// Durante el plano se muestra una instrucción corta y un Pleno real.
class PlanoInteractivo extends PlanoEscena {
  final VozPersonaje vozInstruccion;
  final String instruccion;
  final AccionEsperada accion;

  /// Estado inicial del Fragmento. Para [AccionEsperada.dividirPleno]
  /// debe ser `plenoCompleto`; para [AccionEsperada.desfragmentarMitades]
  /// debe ser `dosMitades` (el plano anterior ya lo dividió).
  final EstadoFragmentoTutorial estadoInicial;

  const PlanoInteractivo({
    required this.vozInstruccion,
    required this.instruccion,
    required this.accion,
    required this.estadoInicial,
  });
}

enum EstadoFragmentoTutorial {
  plenoCompleto,
  dosMitades,
  unaMitad,
  vacio,
}

class OpcionEleccion {
  /// Texto de la opción tal como la ve el niño, entre comillas cuando es
  /// habla ("Vengo a entrenar."), o descriptivo cuando es actitud
  /// ("— quedarte callado —").
  final String textoJugador;

  /// Respuesta opcional del personaje tras la elección.
  final String? textoRespuesta;

  /// Voz de la respuesta. Si es null, se usa la voz del PlanoEleccion.
  final VozPersonaje? vozRespuesta;

  /// Flags narrativos que se activan al elegir esta opción. Se persisten
  /// en el repositorio como `uroto.flag.<nombre>`.
  final Set<String> flagsAEstablecer;

  const OpcionEleccion({
    required this.textoJugador,
    this.textoRespuesta,
    this.vozRespuesta,
    this.flagsAEstablecer = const {},
  });
}
