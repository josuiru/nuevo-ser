/// **Mosaico de fin de Arco 3** — entrega creativa integradora del
/// arco (doc 09 §M3, doc 15 §3). Espacio paralelo no atomizado.
///
/// **Formato ficha de museo** (doc 09 §M3): mientras el M1 fue un
/// cómic mudo de 8 viñetas y el M2 una audio-guía de 8 fragmentos,
/// el M3 cambia de soporte a una **ficha de museo con cartela
/// honestísima**. La Cronista elige una pieza concreta de las que
/// ha trabajado en el arco — Maren elige una piedra grabada del
/// barrio mudéjar de Tudela con caracteres árabes parcialmente
/// borrados, vista en el muro de una casa reutilizada en la 3.6.4
/// — y produce su cartela de museo con seis líneas, cada una con
/// su nivel de confianza explícito en el texto.
///
/// La pieza es **anónima**: nadie la documentó por nombre, no
/// figura en archivo. La Cronista la fotografió en su segunda
/// visita y la elige como tema porque encarna el oficio del Arco 3:
/// reconocer lo que sigue ahí cuando el lugar ha sobrevivido al
/// silencio institucional.
///
/// **Pedagogía clave del M3** (doc 09 §M3): la cartela tiene
/// **todos los niveles de confianza visibles** — no esconde
/// disputado, no esconde probable. Es la lección integradora del
/// arco en formato museográfico: la honestidad histórica exige
/// **no confundir** lo sólido con lo disputado, y exige nombrar
/// los niveles cuando uno los conoce.
///
/// La entrega va a Andrés en el ático (cinemática `M3.entrega`,
/// pendiente de implementar). Andrés la archiva sin decir nada y
/// pregunta sólo *"¿La piedra existe?"* — Maren confirma que está
/// en el muro y la fotografió. Andrés cierra: *"Bien. La gente que
/// pase por allí ya sabe que hay alguien que la mira con respeto."*
///
/// **PENDIENTE DE VALIDACIÓN COMITÉ TUDELA-1378**: la pieza concreta
/// y la cartela completa son material del doc 09 v0.3 que reproduce
/// fielmente el original. La pieza es declarada explícitamente
/// como "anónima, no documentada por nombre en archivo" — pero su
/// pertenencia al barrio mudéjar de Tudela y la asociación a
/// epigrafía andalusí tardía o mudéjar inicial requieren validación
/// histórica. Registrado en `BLOQUEOS-PENDIENTES.md`.
library;

// Re-exportamos `NivelConfianza` desde el path interno del core
// para no colisionar con el barrel del paquete cuando otro juego
// de la Colección usa el mismo nombre con significado distinto.
export 'package:nuevo_ser_core/src/calibration/nivel_confianza.dart'
    show NivelConfianza;

/// Una línea de la cartela del Mosaico del Arco 3 (formato ficha
/// de museo). Cada línea declara una dimensión de la pieza
/// (procedencia, datación, lengua, función original, reutilización,
/// lo que dice) con su nivel de confianza explícito en el texto.
///
/// A diferencia del M1 (viñetas con anclajes opcionales) y del M2
/// (fragmentos con anclajes a fuentes), las líneas de la cartela
/// del M3 NO requieren anclaje a una fuente catalogada — la pieza
/// elegida por Maren es **anónima y no documentada por nombre en
/// archivo**, así que la cartela se sostiene en la observación
/// directa de la piedra (foto + análisis comparativo) y en el
/// marco interpretativo del arco.
class LineaCartelaMuseo {
  /// Identificador estable de la línea — convención `m3_<dimension>`.
  final String id;

  /// Etiqueta breve de la dimensión (procedencia, datación, lengua,
  /// función, reutilización, lo que la piedra dice). La pantalla la
  /// muestra como rótulo en versalita junto al texto descriptivo.
  final String etiqueta;

  /// Texto descriptivo de la línea — la cartela en sí. Incluye la
  /// declaración del nivel de confianza al final de la frase
  /// (Probable, Disputada, Sólido…). Es la voz museográfica de
  /// Maren articulando la pieza.
  final String textoDescriptivo;

  const LineaCartelaMuseo({
    required this.id,
    required this.etiqueta,
    required this.textoDescriptivo,
  });
}

class MosaicoArco3 {
  /// Identificador del arco — convención `arco_<n>` paralela al M1
  /// y M2. Sirve como `arc_id` en el endpoint companion
  /// `/companion/mosaicos`.
  static const String idArco = 'arco_3';

  /// Título visible del Mosaico.
  static const String titulo =
      'Mosaico del Arco 3 — La piedra del muro';

  /// **Pregunta abierta del arco**. El doc 09 §M3 no la fija
  /// literalmente como pregunta única; el eje pedagógico se sintetiza
  /// en torno a la responsabilidad de mirar con respeto lo que la
  /// historia oficial olvidó.
  static const String preguntaAbiertaDelArco =
      '¿Cómo se reconoce lo que sigue ahí cuando el lugar ha sobrevivido '
      'al silencio institucional?';

  /// Glosa breve que la pantalla muestra antes de la cartela.
  /// Articula el formato y el respeto a la pieza.
  static const String glosa =
      'Tu Mosaico es una ficha de museo. La pieza que has elegido — una '
      'piedra grabada con caracteres árabes parcialmente borrados, '
      'reutilizada en el muro de una casa del antiguo barrio mudéjar de '
      'Tudela — es anónima. Nadie la documentó por nombre. La elegiste '
      'tú porque la viste con respeto. La cartela debe declarar todos '
      'los niveles de confianza: Sólido, Probable y Disputado. La '
      'honestidad histórica exige no confundirlos.';

  /// Marco visible con datos de identificación de la pieza, paralelo
  /// al cabecero de una cartela de museo real (procedencia, número
  /// de inventario, autor, etc.). Aquí se reduce a lo que Maren
  /// puede declarar honestamente.
  static const String identificacionDeLaPieza =
      'Fragmento de piedra grabada con caracteres árabes parcialmente '
      'borrados. Pieza pequeña, anónima. Sin número de inventario en '
      'archivo público. Procedencia: muro reutilizado en una casa del '
      'antiguo barrio mudéjar de Tudela. Fotografiada por Maren Lozano '
      'durante la Brecha del incendio de la judería de Tudela de 1378.';

  /// La cartela completa, seis líneas. La pantalla las muestra una
  /// debajo de otra como una ficha de museo unificada.
  static const List<LineaCartelaMuseo> cartela = [
    LineaCartelaMuseo(
      id: 'm3_procedencia',
      etiqueta: 'PROCEDENCIA',
      textoDescriptivo:
          'Muro reutilizado en una casa del antiguo barrio mudéjar de '
          'Tudela. La pieza está empotrada en una pared posterior, no '
          'in situ. Probable que provenga de un edificio anterior del '
          'mismo barrio, perdido o desmontado entre los siglos XIV y '
          'XVII.',
    ),
    LineaCartelaMuseo(
      id: 'm3_datacion',
      etiqueta: 'DATACIÓN',
      textoDescriptivo:
          'Siglos XII a XIV. Probable — la grafía y el grosor del '
          'trazo encajan con epigrafía andalusí tardía o mudéjar '
          'inicial. La datación absoluta no se puede cerrar sin '
          'análisis paleográfico especializado y sin contexto '
          'arqueológico in situ.',
    ),
    LineaCartelaMuseo(
      id: 'm3_lengua',
      etiqueta: 'LENGUA',
      textoDescriptivo:
          'Árabe. La inscripción legible parece fragmento de una '
          'fórmula religiosa o invocación piadosa. Probable — los '
          'caracteres conservados encajan con el repertorio epigráfico '
          'andalusí, pero la lectura completa no es posible por la '
          'erosión.',
    ),
    LineaCartelaMuseo(
      id: 'm3_funcion_original',
      etiqueta: 'FUNCIÓN ORIGINAL',
      textoDescriptivo:
          'Desconocida. Disputada. Pudo ser umbral de puerta, fragmento '
          'de lápida funeraria, parte de una inscripción mural mayor de '
          'la mezquita o de un edificio comunitario, o pieza menor de '
          'arquitectura doméstica con texto religioso. Cada hipótesis '
          'tiene apoyo parcial; ninguna se cierra con la pieza aislada.',
    ),
    LineaCartelaMuseo(
      id: 'm3_reutilizacion',
      etiqueta: 'REUTILIZACIÓN',
      textoDescriptivo:
          'Documentada en el muro de la casa actual, datable por su '
          'aparejo en el siglo XVII. Que esta reutilización fuera '
          'deliberada (con conocimiento de su origen y su valor) o '
          'casual (como simple piedra disponible en una pared) es '
          'disputado. La pieza está parcialmente visible — quien la '
          'puso quiso que se viera, o no le importó que se viera.',
    ),
    LineaCartelaMuseo(
      id: 'm3_lo_que_la_piedra_dice',
      etiqueta: 'LO QUE ESTA PIEDRA NOS DICE',
      textoDescriptivo:
          'Que el barrio mudéjar de Tudela existió. Que producía y '
          'conservaba inscripciones religiosas en árabe. Y que la '
          'ciudad posterior la incorporó a sus muros sin destruirla. '
          'Sólido. Lo que sigue siendo nuestra herida abierta — y por '
          'tanto nuestra tarea — es el silencio sobre quién la grabó '
          'y para quién.',
    ),
  ];

  /// Mínimo de líneas de la cartela que la Cronista debe haber
  /// **leído** (esto es, marcado como vista) para entregar. La
  /// pantalla del M3 muestra todas las líneas y permite a la
  /// Cronista marcar cada una como leída — paralelo a "marcar el
  /// nivel de confianza" del M1 y M2 pero más simple porque las
  /// declaraciones de confianza están ya escritas en el texto. La
  /// regla de "al menos 5 de 6" preserva el respeto a la decisión
  /// de la Cronista de leer la cartela completa antes de entregar
  /// sin obligarla a marcar todas mecánicamente.
  static const int minimoLineasLeidasParaEntregar = 5;

  /// Flag narrativo que dispara el Mosaico. El orquestador lo
  /// activa al cerrar la cinemática 3.6.10 ("El silencio segundo")
  /// — cierre real del Arco 3 según el doc 09 §3.6.10.
  static const String flagDeArcoCompletado = 'arco_3_estacion_6_cerrada';

  /// Flag narrativo que se activa al entregar el Mosaico. Hace que
  /// la pantalla deje de aparecer y permite que el orquestador
  /// despache la cinemática 3.Z (`Aprendiz III`, patio del Archivo).
  static const String flagDeMosaicoEntregado = 'mosaico_arco_3_entregado';
}
