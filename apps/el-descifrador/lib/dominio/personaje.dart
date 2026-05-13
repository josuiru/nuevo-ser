import 'localizacion.dart';

// Personajes del puerto. Doc 02 (mundo) + doc 09 (voces y figuras).
//
// El maestro de oficina es coral: Antón + Aitziber, ambos en la oficina.
// El resto son habitantes recurrentes que dan vida a cada escenario.
//
// Posición en escena: coordenadas normalizadas [0..1] respecto al área
// pintada del fondo. (0, 0) es la esquina superior izquierda, (1, 1) la
// inferior derecha. La posición referencia el pie del personaje (la
// silueta se ancla por su base), no el centro de masa.

enum SiluetaPersonaje {
  hombreAdulto,
  mujerAdulta,
  marinero,
  impresor,
}

class Personaje {
  const Personaje({
    required this.identificadorTecnico,
    required this.nombreCanonico,
    required this.localizacion,
    required this.posicionXEnEscena,
    required this.posicionYEnEscena,
    required this.alturaEnEscena,
    required this.silueta,
    this.frasePresentacion,
  });

  final String identificadorTecnico;
  final String nombreCanonico;
  final Localizacion localizacion;

  /// Posición horizontal del pie del personaje, normalizada [0..1].
  final double posicionXEnEscena;

  /// Posición vertical del pie del personaje, normalizada [0..1].
  final double posicionYEnEscena;

  /// Altura del personaje como fracción del alto de pantalla [0..1].
  /// Da control sobre la perspectiva (alguien al fondo es más bajo).
  final double alturaEnEscena;

  final SiluetaPersonaje silueta;

  /// Frase sobria que aparece al tocarlo. Cumple doc 09 §4 (voz sobria).
  final String? frasePresentacion;
}

/// Catálogo inicial de personajes recurrentes del puerto.
///
/// Antón y Aitziber forman el maestro coral en la oficina (doc 09 §1).
/// Los demás son habitantes que dan vida al puerto sin ser remitentes
/// del corpus.
const List<Personaje> catalogoPersonajesPuerto = [
  Personaje(
    identificadorTecnico: 'aitziber',
    nombreCanonico: 'Aitziber',
    localizacion: Localizacion.oficina,
    posicionXEnEscena: 0.72,
    posicionYEnEscena: 0.78,
    alturaEnEscena: 0.42,
    silueta: SiluetaPersonaje.mujerAdulta,
    frasePresentacion: 'Llegan papeles. Hay que ponerse.',
  ),
  Personaje(
    identificadorTecnico: 'anton',
    nombreCanonico: 'Antón',
    localizacion: Localizacion.despachoMaestro,
    posicionXEnEscena: 0.50,
    posicionYEnEscena: 0.82,
    alturaEnEscena: 0.48,
    silueta: SiluetaPersonaje.hombreAdulto,
    frasePresentacion: 'Pasa. Siéntate. Mira lo que tenemos.',
  ),
  Personaje(
    identificadorTecnico: 'marinero_muelle',
    nombreCanonico: 'Marinero',
    localizacion: Localizacion.muelle,
    posicionXEnEscena: 0.32,
    posicionYEnEscena: 0.84,
    alturaEnEscena: 0.40,
    silueta: SiluetaPersonaje.marinero,
    frasePresentacion: 'Acabamos de descargar. Hay correo entre las sacas.',
  ),
  Personaje(
    identificadorTecnico: 'impresor_boletin',
    nombreCanonico: 'El impresor',
    localizacion: Localizacion.boletin,
    posicionXEnEscena: 0.58,
    posicionYEnEscena: 0.80,
    alturaEnEscena: 0.45,
    silueta: SiluetaPersonaje.impresor,
    frasePresentacion: 'La prensa no espera. ¿Vienes a por algo?',
  ),
];

List<Personaje> personajesEn(Localizacion localizacion) {
  return [
    for (final personaje in catalogoPersonajesPuerto)
      if (personaje.localizacion == localizacion) personaje,
  ];
}
