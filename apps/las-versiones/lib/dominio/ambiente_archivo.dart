import 'package:nuevo_ser_core/nuevo_ser_core.dart';

/// Ambiente atmosférico de una escena de Las Versiones. Implementa el
/// contrato genérico [AmbienteEscenaContrato] del core para que el
/// player de cinemáticas lo transporte sin conocer su pintura — el
/// `CustomPainter` específico del juego lo recibe y decide cómo
/// renderizarlo.
///
/// **Provisional**: por ahora cada ambiente lleva sólo una etiqueta
/// estable (`identificador`) que el pintor puede consumir como `switch`.
/// Cuando se aborde la fase visual del juego (doc 11 + 13), esta clase
/// crecerá con campos pictóricos concretos (densidad de polvo, tono de
/// luz, intensidad de viento, ruido de papel…) — el patrón ya está
/// validado por `AmbienteCielo` en Uno Roto.
///
/// Los ambientes catalogados aquí cubren los espacios principales
/// previstos por la worldbuilding (doc 05): la sala de evaluación
/// donde Maren defiende sus reconstrucciones, el Archivo nocturno
/// donde trabaja con manuscritos, una sierra al amanecer (paisaje
/// recurrente del valle), el interior de una cueva (Brecha
/// arqueológica de la capa Cueva-Pirineo). Los juegos pueden añadir
/// más instancias `static const` sin tocar este archivo.
class AmbienteArchivo implements AmbienteEscenaContrato {
  /// Etiqueta estable que el pintor del juego usará como discriminador.
  /// Castellano, snake_case (`sala_evaluacion`, `archivo_nocturno`).
  final String identificador;

  const AmbienteArchivo._(this.identificador);

  /// Sala de evaluación del Archivo — mesa larga, luz cenital,
  /// sillas. El espacio del Concilio y de la primera entrevista de
  /// Maren con Isaura (doc 07 §1.0).
  static const AmbienteArchivo salaEvaluacion =
      AmbienteArchivo._('sala_evaluacion');

  /// Archivo nocturno — estanterías, polvo, velas. Donde Maren pasa
  /// las horas con manuscritos cuando nadie la mira.
  static const AmbienteArchivo archivoNocturno =
      AmbienteArchivo._('archivo_nocturno');

  /// Sierra al amanecer — paisaje exterior del valle, luz horizontal,
  /// niebla de mañana. Recurrente en transiciones entre Brechas.
  static const AmbienteArchivo sierraAmanecer =
      AmbienteArchivo._('sierra_amanecer');

  /// Interior de cueva — primera Brecha del MVP (capa Cueva-Pirineo,
  /// ya validada por el comité asesor histórico). Roca, humedad,
  /// hueco de luz lejano.
  static const AmbienteArchivo cuevaInterior =
      AmbienteArchivo._('cueva_interior');

  /// Patio interior del Archivo — capiteles antiguos, brocal de un
  /// pozo, cielo abierto sobre el claustro. Espacio de transición
  /// entre estancias durante el recorrido del primer día (1.0.2).
  static const AmbienteArchivo patioArchivo =
      AmbienteArchivo._('patio_archivo');

  /// Ático del Archivo — vitrinas con piezas, mesa de trabajo de
  /// Andrés Vidaurre. Donde se guardan los objetos físicos.
  static const AmbienteArchivo aticoArchivo =
      AmbienteArchivo._('atico_archivo');

  /// Salón del Concilio — mesa larga, tres sillones de orejas en
  /// cabecera. Lugar de presentación del trabajo final de cada
  /// arco. Maren se queda en la puerta sin entrar la primera vez.
  static const AmbienteArchivo salonConcilio =
      AmbienteArchivo._('salon_concilio');

  /// Cocina del Archivo — té, café, sillas de madera. Espacio
  /// informal donde Isaura prepara dos tés a Maren al final del
  /// recorrido. Más cálido que las salas formales.
  static const AmbienteArchivo cocinaArchivo =
      AmbienteArchivo._('cocina_archivo');

  /// Cocina-comedor de la casa familiar de Maren, Casco Viejo de
  /// Iruña. Donde Iratxe prepara la comida y Naia hace las
  /// preguntas que abren el oficio para Maren (1.0.3).
  static const AmbienteArchivo cocinaCasaMaren =
      AmbienteArchivo._('cocina_casa_maren');

  /// Habitación de Maren — escritorio, libros, ventana al patio
  /// interior con un castaño. Donde escribe la primera entrada del
  /// Cuaderno la tarde antes de su primera Brecha.
  static const AmbienteArchivo cuartoCasaMaren =
      AmbienteArchivo._('cuarto_casa_maren');

  /// Ambiente-paraguas para escenas que recorren varios espacios del
  /// Archivo en una sola pieza narrativa (típico de 1.0.2 "El
  /// recorrido"). El `CustomPainter` lo usará como base sobre la que
  /// el texto de lectura de cada plano matiza ("bajan al sótano",
  /// "suben al ático") sin necesidad de un ambiente por subespacio.
  static const AmbienteArchivo recorridoArchivo =
      AmbienteArchivo._('recorrido_archivo');

  /// Ambiente-paraguas para escenas que ocurren en la casa familiar
  /// de Maren cubriendo varios espacios (cocina, salón, cuarto) sin
  /// transición clara entre ellos. El texto de lectura matiza cada
  /// subespacio cuando hace falta. Caso típico: 1.0.3 "La primera
  /// tarde en casa".
  static const AmbienteArchivo casaMaren =
      AmbienteArchivo._('casa_maren');

  /// Interior del coche viejo de Isaura — Citroën C3, asientos de
  /// tela gastados, ventanas con paisaje en movimiento. Lugar
  /// recurrente para conversaciones largas de viaje a las Brechas.
  static const AmbienteArchivo cocheIsaura =
      AmbienteArchivo._('coche_isaura');

  /// Campo de dólmenes de Aralar — calizas blancas en lo alto,
  /// hayedos abajo, hierba alta, viento, alguna oveja muy lejos.
  /// Lugar de la primera Brecha: el dolmen mediano marcado con
  /// poste y código de catálogo. Aralar y sus megalitos están
  /// validados como entrada en el doc 17.
  static const AmbienteArchivo dolmenAralar =
      AmbienteArchivo._('dolmen_aralar');

  /// Cafetería pequeña del Casco Viejo de Iruña — barra de
  /// formica, taburetes altos, cruasanes en una vitrina, voces de
  /// fondo, máquina de café que silba a ratos. Lugar de la
  /// merienda con Eider (1.A). Es el primer espacio neutro fuera
  /// de la órbita Archivo + casa familiar — Maren puede contar lo
  /// que quiera, sin protocolos.
  static const AmbienteArchivo cafeteriaCascoViejo =
      AmbienteArchivo._('cafeteria_casco_viejo');

  /// Crómlech vecino del campo de dólmenes de Aralar — círculo de
  /// pequeñas piedras hincadas, restos cerámicos en superficie,
  /// hierba tupida alrededor. Lugar de la Brecha 1.2 (segunda
  /// visita a Aralar, esta vez con Sira). Atmosférica simétrica al
  /// dolmen pero con una densidad arqueológica más fragmentaria —
  /// sin enterramiento óseo claro.
  static const AmbienteArchivo cromlechAralar =
      AmbienteArchivo._('cromlech_aralar');

  /// Bosque de hayas en la entrada al sistema de cuevas del
  /// Pirineo navarro — hojarasca, niebla baja, sendero de tierra
  /// húmeda, una verja oxidada en la ladera. Lugar de la 1.3.2 (la
  /// boca de la cueva).
  static const AmbienteArchivo bosqueHayas =
      AmbienteArchivo._('bosque_hayas');

  /// Sala con grabados parietales — cueva profunda, sala de techos
  /// altos, sin luz natural, sonido resonante, pared con bisonte,
  /// ciervo y caballo grabados que sólo aparecen cuando la luz da
  /// oblicua. Lugar de la 1.3.4 (la pared). El nombre interno se
  /// mantiene `sala_grabados_parietales` (no `alkerdi_*`) porque
  /// el contenido es modelo literario verosímil basado en lo real,
  /// no afirmación arqueológica directa de Alkerdi I.
  static const AmbienteArchivo salaGrabadosParietales =
      AmbienteArchivo._('sala_grabados_parietales');

  /// Yacimiento de Irulegi — monte sobre el valle de Aranguren,
  /// estructuras de piedra del poblado fortificado parcialmente
  /// excavadas, viviendas con paredes y peldaños conservados,
  /// material de la última jornada congelado en su sitio. Lugar
  /// de la 1.4.1 y parte de la 1.4.2.
  static const AmbienteArchivo yacimientoIrulegi =
      AmbienteArchivo._('yacimiento_irulegi');

  /// Sala de Prehistoria del Museo de Navarra — vitrinas, cartelas
  /// con transcripciones epigráficas, paneles de contexto. Lugar
  /// de la segunda parte de la 1.4.2 (la Mano de Irulegi vista en
  /// vitrina, lectura inicial vs lectura corregida).
  static const AmbienteArchivo museoNavarra =
      AmbienteArchivo._('museo_navarra');
}
