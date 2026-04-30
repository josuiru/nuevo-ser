/// Modelos abstractos de una **Brecha** — la unidad de investigación
/// del juego. Cada Brecha cubre una de las 14 Estaciones del MVP y
/// recorre las cinco fases pedagógicas del oficio (doc 01 v0.2,
/// doc 14 §3): formulación de preguntas → recolección → evaluación
/// → reconstrucción con niveles de confianza → Concilio.
///
/// Las cinemáticas que enmarcan una Brecha (camino, llegada, primer
/// apunte) viven en el catálogo de escenas; el bloque jugable —las
/// cinco fases— vive aquí.
library;

// Tomamos el tipo del módulo `calibration/` del core por path
// explícito — el barrel no lo expone para evitar colisión con
// otros juegos de la Colección que usen el mismo nombre para
// conceptos no relacionados con calibración Brier.
import 'package:nuevo_ser_core/src/calibration/nivel_confianza.dart'
    show NivelConfianza;

export 'package:nuevo_ser_core/src/calibration/nivel_confianza.dart'
    show NivelConfianza;

/// Las cinco fases pedagógicas de una Brecha. El orden es la
/// secuencia natural; el orquestador no permite saltar fases.
///
/// La correspondencia con el guion canónico de la 1.1 es:
/// - `formulacionPreguntas` → 1.1.3 "Las preguntas".
/// - `recoleccion` → 1.1.4 primera mitad: descubrir las fuentes.
/// - `evaluacion` → 1.1.4 segunda mitad: Mesa de Trabajo.
/// - `reconstruccion` → 1.1.5 con AH.03 y calibración Brier.
/// - `concilio` → 1.1.6 feedback final con la mentora.
enum FaseBrecha {
  formulacionPreguntas,
  recoleccion,
  evaluacion,
  reconstruccion,
  concilio,
}

/// Tipo declarado de una fuente — primaria si fue producida en el
/// momento del hecho que la Cronista investiga, secundaria si lo
/// interpreta. Habilidad HF.02.
enum TipoFuente {
  primaria,
  secundaria,
}

/// `NivelConfianza` se importa de `nuevo_ser_core` (módulo
/// `calibration`) y se re-exporta por compatibilidad con el código
/// existente. Es el corazón pedagógico del juego (AH.03, doc 14 §1):
/// declarar Sólido cuando es Disputado es sobreconfianza; lo
/// contrario, timidez epistémica. La calibración Brier vive en el
/// core para que cualquier juego de la Colección pueda usarla.

/// Categoría de sesgo historiográfico detectable en una fuente.
/// Habilidad HF.09. Cada Brecha define qué sesgos esperar; el
/// catálogo se va ampliando según aparecen fuentes que los ejemplifican.
enum SesgoFuente {
  /// Sin sesgo detectable o irrelevante para el caso.
  ninguno,

  /// Comparaciones forzadas con culturas centroeuropeas, vocabulario
  /// "claramente megalitismo atlántico de origen bretón". Categoría
  /// historiográfica obsoleta del s. XX.
  difusionista,

  /// Reproduce el discurso oficial del momento sin distancia crítica
  /// (típico de fuentes producidas por instituciones).
  oficialista,

  /// Trata un objeto del pasado con criterios del presente (juzgar
  /// el medieval por estándares contemporáneos).
  presentista,

  /// Omite voces (mujeres, clases populares, minorías) que pudieron
  /// estar presentes pero no quedaron en el registro.
  invisibilizador,
}

/// Las propiedades canónicas de una fuente — las respuestas
/// "correctas" a las seis preguntas críticas del oficio (doc 01).
/// Cuando la Cronista evalúa la fuente en la Mesa de Trabajo (Fase
/// 3 de la Brecha), elige entre opciones predefinidas; el sistema
/// compara con estas propiedades para puntuar P1.
///
/// Las respuestas son cadenas castellanas porque el motor adaptativo
/// no las interpreta semánticamente — sólo iguala con la elección
/// del jugador. Cuando se conecte al tutor IA (futuro), las cadenas
/// pueden recibir interpretación más rica.
class PropiedadesFuente {
  /// Habilidad HF.02 — distinción primaria/secundaria.
  final TipoFuente tipo;

  /// Habilidad HF.03 — ¿quién la produjo?
  final String autor;

  /// Habilidad HF.04 — ¿cuándo?
  final String fecha;

  /// Habilidad HF.05 — ¿para qué público?
  final String publico;

  /// Habilidad HF.06 — ¿con qué intereses?
  final String intereses;

  /// Habilidad HF.07 — ¿qué se omite?
  final String omisiones;

  /// Habilidad HF.08 — ¿corrobora o contradice qué?
  final String corroboraOContradice;

  /// Habilidad HF.09 — ¿qué sesgo lleva?
  final SesgoFuente sesgo;

  const PropiedadesFuente({
    required this.tipo,
    required this.autor,
    required this.fecha,
    required this.publico,
    required this.intereses,
    required this.omisiones,
    required this.corroboraOContradice,
    this.sesgo = SesgoFuente.ninguno,
  });
}

/// Una fuente de evidencia que la Cronista puede consultar en la
/// Mesa de Trabajo. Incluye la descripción que ve el jugador y las
/// propiedades canónicas con las que se contrasta su evaluación.
class Fuente {
  /// Identificador estable dentro de la Brecha. Se usa para enganchar
  /// afirmaciones a la fuente que las ancla. Snake_case castellano.
  final String id;

  /// Categoría visible — "Restos óseos", "Material lítico", "Informe
  /// arqueológico", etc. La interfaz lo usa como título de la tarjeta.
  final String tipoVisible;

  /// Descripción narrativa que la Cronista lee en la Mesa de Trabajo.
  /// Texto canónico en castellano; cuando llegue la traducción a
  /// euskera/catalán, se moverá a un sistema de claves narrativas.
  final String descripcion;

  /// Las respuestas correctas a las seis preguntas críticas del
  /// oficio. La Cronista no las ve directamente; el sistema las usa
  /// para puntuar su evaluación (Fase 3).
  final PropiedadesFuente propiedadesCanonicas;

  const Fuente({
    required this.id,
    required this.tipoVisible,
    required this.descripcion,
    required this.propiedadesCanonicas,
  });
}

/// Una afirmación reconstruida — algo que la Cronista podría poner
/// en el dossier final. Cada afirmación tiene un nivel de confianza
/// canónico (lo que el consenso historiográfico actual sostiene)
/// que P4 Brier compara con el nivel que el jugador declara.
class AfirmacionCanonica {
  /// Identificador estable. Snake_case castellano.
  final String id;

  /// Texto canónico que verá la Cronista cuando elija las
  /// afirmaciones que considera sostenidas en la Fase 4.
  final String texto;

  /// Nivel de confianza correcto según consenso historiográfico
  /// actual. Si el jugador declara Sólido cuando es Disputado, el
  /// motor P4 lo registra como sobreconfianza.
  final NivelConfianza calibracionCorrecta;

  /// IDs de las [Fuente]s que sostienen (o contradicen) la
  /// afirmación. Sirve para que el motor P3 (anclaje a evidencia)
  /// pueda valorar en qué medida la Cronista cita las fuentes
  /// adecuadas. Vacío si la afirmación no tiene anclaje claro
  /// (caso típico de las Disputadas).
  final List<String> idsFuentesAnclaje;

  const AfirmacionCanonica({
    required this.id,
    required this.texto,
    required this.calibracionCorrecta,
    this.idsFuentesAnclaje = const [],
  });
}

/// Una Brecha completa: la unidad de investigación que recorre las
/// cinco fases del oficio. Cada Estación del MVP corresponde a una
/// Brecha catalogada (1.1, 1.2, 2.1…); los Mosaicos de fin de arco
/// son entregas integradoras y viven aparte (doc 15).
class Brecha {
  /// Identificador alineado con el guion (doc 07): "1.1", "1.2",
  /// "2.1"… Estable, lo usa el orquestador para flags y persistencia.
  final String id;

  /// Nombre legible para debug y para el header de pantalla.
  /// Ej: "El primer dolmen", "El campo de Cascante".
  final String titulo;

  /// Lugar donde transcurre la Brecha — el rótulo flotante que
  /// aparece al llegar (estilo "ARALAR — DOLMEN DE AROZTEGI").
  final String ubicacionVisible;

  /// Habilidades atómicas que la Brecha ejercita. Sirve para que el
  /// motor adaptativo registre intentos en cada habilidad cuando el
  /// jugador completa la fase correspondiente. Códigos del doc 02:
  /// PR.01, HF.02, AH.03, etc.
  final List<String> habilidadesEjercitadas;

  /// Fuentes disponibles en la Mesa de Trabajo. El número típico es
  /// 5-8 según la complejidad de la Estación.
  final List<Fuente> fuentes;

  /// Afirmaciones precanónicas entre las que la Cronista elige las
  /// que considera sostenidas. Mientras la versión MVP usa elección
  /// múltiple, esta lista es la fuente de verdad; cuando se permita
  /// escritura libre (futuro con tutor IA) seguirá usándose como
  /// anclaje de calibración.
  final List<AfirmacionCanonica> afirmacionesCanonicas;

  /// Flag que el orquestador marca al cerrar la Brecha. Sigue la
  /// convención `brecha_<id_snake>_completada`. Para 1.1 →
  /// `brecha_1_1_completada`, que es justamente la precondición de
  /// la cinemática 1.1.7 "El primer apunte".
  final String flagDeCompletado;

  /// Mínimo de afirmaciones declaradas que la Cronista debe sostener
  /// para poder ir al Concilio (Fase 4 → Fase 5). Por defecto **3** —
  /// el oficio pide "una versión": una sola afirmación no es una
  /// versión; tres es lo mínimo razonable para ejercitar la
  /// calibración con variedad. Las Brechas del Arco 1 (1.1, 1.2, 1.3,
  /// 1.4) usan el default porque cada una tiene 4 afirmaciones
  /// canónicas y declarar 3 marca un mínimo significativo. Las
  /// Brechas del Arco 2 con catálogos más amplios (2.1 con 6, 2.2
  /// con 7, 2.3 con 8, 2.4 con 9) suben el mínimo: declarar sólo
  /// 3 de 9 sería trivializar la mecánica.
  final int minimoAfirmacionesParaConcilio;

  const Brecha({
    required this.id,
    required this.titulo,
    required this.ubicacionVisible,
    required this.habilidadesEjercitadas,
    required this.fuentes,
    required this.afirmacionesCanonicas,
    required this.flagDeCompletado,
    this.minimoAfirmacionesParaConcilio = 3,
  });
}
