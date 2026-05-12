/// **Mosaico de fin de Arco 4** — entrega creativa integradora del
/// arco final del MVP (doc 10 §M4, doc 15 §3). Espacio paralelo no
/// atomizado.
///
/// **Formato doble cartela paralela** (doc 10 §M4): mientras el M1
/// fue cómic mudo de 8 viñetas, el M2 audio-guía de 8 fragmentos y
/// el M3 ficha de museo de una sola pieza con seis líneas, el M4
/// **cambia de soporte** una vez más a una **doble cartela paralela**
/// — dos cartelas de seis líneas cada una, mostradas una al lado de
/// la otra, leyéndose en paralelo. Cada cartela describe una pieza
/// concreta de las que la Cronista ha trabajado a lo largo del MVP:
/// un fragmento cerámico campaniforme del primer dolmen de Aralar
/// (Brecha 1.1, prehistoria muda) y la inscripción honorífica romana
/// de Pompelo (Brecha 2.1, texto que afirma poder).
///
/// La pedagogía clave del M4 es **ver dos objetos uno al lado del
/// otro y leer la conversación que tienen entre ellos**. No son dos
/// piezas equivalentes: una es prehistórica y muda (sólo material,
/// sin texto, sin nombres), la otra es romana y elocuente (texto
/// honorífico que afirma poder, con nombres explícitos en latín). El
/// formato museográfico paralelo obliga a leer la **conversación
/// entre épocas** que el oficio del MVP ha permitido a Maren articular:
/// reconocer la mudez sin presuponer ausencia, leer la elocuencia sin
/// olvidar la propaganda.
///
/// El Mosaico M4 es **proyecto integrador final del MVP**: cierra el
/// recorrido de los cuatro arcos. Desde el primer dolmen de Aralar
/// (cinemática 1.1.2) hasta la víspera de la graduación a Cronista
/// (cinemática 4.H.1) Maren ha pasado por las cuatro Brechas
/// jugables del Arco 1, las cuatro del Arco 2, las cuatro del Arco
/// 3 y las dos del Arco 4 — más todas las cinemáticas narrativas y
/// las dos Brechas latentes (3.2 y 3.6 sin Brecha jugable cerrada
/// por validación pendiente del comité). El M4 condensa ese recorrido
/// en dos piezas que articulan los polos epistémicos del oficio:
/// la observación material muda y la lectura crítica de texto con
/// propaganda.
///
/// La entrega va a Andrés en el ático (cinemática `M4.entrega`,
/// implementada en `escenas_arco_4.dart`). Andrés archiva el Mosaico
/// y reconoce: *"Doble cartela en paralelo. Original."*. Maren
/// pregunta *"¿Funciona?"* y Andrés cierra: *"Maren. La pregunta no
/// me la haces a mí. Ya eres tú la que decide si funciona."* — el
/// reconocimiento implícito del paso de Aprendiz III a Cronista.
///
/// **PENDIENTE DE VALIDACIÓN COMITÉ MOSAICO-M4**: las dos cartelas
/// reproducen fielmente las observaciones de Maren a lo largo del MVP
/// sobre las dos piezas del recorrido. Las datacioness y atribuciones
/// específicas siguen el patrón de sustituciones diegéticas registrado
/// para las Brechas correspondientes (cerámica campaniforme del primer
/// dolmen de Aralar — registrado bajo ARALAR-DATACIONES; inscripción
/// honorífica romana de Pompelo — sustituida por POMPAELO-INSCRIPCION
/// validada en F2-17 con el ara de Aelio Attiano del *Epigraphica* 76
/// (2014) de García-Barberena/Unzu/Velaza). Registro en
/// `BLOQUEOS-PENDIENTES.md`.
library;

// Re-exportamos `NivelConfianza` desde el path interno del core para
// no colisionar con el barrel del paquete cuando otro juego de la
// Colección usa el mismo nombre con significado distinto.
export 'package:nuevo_ser_core/src/calibration/nivel_confianza.dart'
    show NivelConfianza;

/// Una línea de la cartela paralela del Mosaico del Arco 4. Mismo
/// shape que `LineaCartelaMuseo` del M3 — repetido aquí en lugar de
/// importarse para que el archivo M4 sea autosuficiente y los dos
/// Mosaicos puedan evolucionar independientemente sin acoplarse.
class LineaCartelaParalela {
  /// Identificador estable de la línea — convención
  /// `m4_<pieza>_<dimension>` (p. ej. `m4_aralar_procedencia`).
  final String id;

  /// Etiqueta breve de la dimensión (procedencia, datación, lengua,
  /// función original, reutilización, lo que la pieza dice). La
  /// pantalla la muestra como rótulo en versalita junto al texto
  /// descriptivo.
  final String etiqueta;

  /// Texto descriptivo de la línea — la cartela en sí. Incluye la
  /// declaración del nivel de confianza al final de la frase
  /// (Probable, Disputada, Sólido…). Es la voz museográfica de Maren
  /// articulando la pieza.
  final String textoDescriptivo;

  const LineaCartelaParalela({
    required this.id,
    required this.etiqueta,
    required this.textoDescriptivo,
  });
}

/// Una de las dos cartelas paralelas del M4. Cada cartela describe
/// una pieza con seis líneas (mismas dimensiones que el M3).
class CartelaPiezaArco4 {
  /// Identificador estable de la pieza dentro del M4 — `aralar` o
  /// `pompelo`.
  final String idPieza;

  /// Título museográfico de la pieza (rótulo de cabecera de la
  /// cartela).
  final String titulo;

  /// Marco de identificación de la pieza, paralelo al cabecero de
  /// una cartela de museo real.
  final String identificacionDeLaPieza;

  /// Las seis líneas de la cartela.
  final List<LineaCartelaParalela> lineas;

  const CartelaPiezaArco4({
    required this.idPieza,
    required this.titulo,
    required this.identificacionDeLaPieza,
    required this.lineas,
  });
}

class MosaicoArco4 {
  /// Identificador del arco — convención `arco_<n>` paralela a M1, M2
  /// y M3. Sirve como `arc_id` en el endpoint companion
  /// `/companion/mosaicos`.
  static const String idArco = 'arco_4';

  /// Título visible del Mosaico.
  static const String titulo =
      'Mosaico del Arco 4 — Doble cartela paralela';

  /// **Pregunta abierta del arco**. El doc 10 §M4 sintetiza el eje
  /// pedagógico del proyecto integrador final.
  static const String preguntaAbiertaDelArco =
      '¿Qué conversación tienen entre sí estas dos piezas — una '
      'prehistórica y muda, otra romana y elocuente — que el oficio '
      'del MVP me ha permitido leer?';

  /// Glosa breve que la pantalla muestra antes de las dos cartelas.
  /// Articula el formato y la pedagogía del paralelismo.
  static const String glosa =
      'Tu Mosaico es una doble cartela paralela. Has elegido dos '
      'piezas concretas de las que has trabajado a lo largo del MVP: '
      'el fragmento cerámico campaniforme del primer dolmen de Aralar '
      '— prehistórico y mudo — y la inscripción honorífica romana de '
      'Pompelo — texto que afirma poder. Cada cartela tiene seis '
      'líneas. Léelas en paralelo: la conversación entre las dos '
      'piezas es lo que el oficio te ha enseñado a oír.';

  /// La cartela del fragmento cerámico campaniforme del primer
  /// dolmen de Aralar (Brecha 1.1).
  static const CartelaPiezaArco4 cartelaAralar = CartelaPiezaArco4(
    idPieza: 'aralar',
    titulo: 'PIEZA I — Fragmento cerámico campaniforme',
    identificacionDeLaPieza:
        'Fragmento cerámico de tipología campaniforme. Pieza pequeña '
        'recogida en la cámara funeraria del primer dolmen visitado en '
        'Aralar durante la Brecha 1.1. Custodiada en el laboratorio de '
        'datación del Archivo. Procedencia: Aralar, sierra prepirenaica '
        'de Navarra. Fotografiada y descrita por Maren Lozano durante '
        'la Brecha del primer dolmen.',
    lineas: [
      LineaCartelaParalela(
        id: 'm4_aralar_procedencia',
        etiqueta: 'PROCEDENCIA',
        textoDescriptivo:
            'Cámara funeraria del primer dolmen de Aralar — pieza '
            'recogida in situ durante la excavación documentada del '
            'enterramiento colectivo. Sólido — el contexto arqueológico '
            'está documentado por la datación de campo y las '
            'observaciones del informe de excavación.',
      ),
      LineaCartelaParalela(
        id: 'm4_aralar_datacion',
        etiqueta: 'DATACIÓN',
        textoDescriptivo:
            'Aproximadamente entre 4500 y 3500 años antes del presente '
            '— rango habitual para cerámica campaniforme peninsular. '
            'Probable — la datación absoluta del enterramiento no es '
            'directamente trasladable al fragmento concreto, y el '
            'rango específico depende de análisis comparativo con la '
            'tipología regional. La datación cerrada al año queda fuera '
            'del alcance de la pieza aislada.',
      ),
      LineaCartelaParalela(
        id: 'm4_aralar_lengua',
        etiqueta: 'LENGUA',
        textoDescriptivo:
            'Sin texto. La pieza es muda. La cerámica campaniforme '
            'pertenece a una cultura material sin escritura conservada. '
            'Sólido — la ausencia de inscripciones es estructural a la '
            'tipología, no accidental por erosión.',
      ),
      LineaCartelaParalela(
        id: 'm4_aralar_funcion_original',
        etiqueta: 'FUNCIÓN ORIGINAL',
        textoDescriptivo:
            'Pieza de ajuar funerario — fragmento de un recipiente '
            'depositado con el difunto, probablemente con contenido '
            'ritual o alimentario. Disputada la función específica '
            'concreta: las cerámicas campaniformes admiten múltiples '
            'lecturas (vaso ceremonial, recipiente para ofrenda '
            'líquida, contenedor de provisiones, marcador de estatus '
            'social del difunto). Cada hipótesis tiene apoyo parcial; '
            'ninguna se cierra con el fragmento aislado.',
      ),
      LineaCartelaParalela(
        id: 'm4_aralar_reutilizacion',
        etiqueta: 'REUTILIZACIÓN',
        textoDescriptivo:
            'No documentada. La pieza permaneció en su contexto '
            'original hasta su recuperación por la excavación. Sólido — '
            'el dolmen de Aralar es un enterramiento prehistórico '
            'preservado, no un edificio reutilizado en épocas '
            'posteriores. La pieza no fue desplazada de su contexto '
            'funerario.',
      ),
      LineaCartelaParalela(
        id: 'm4_aralar_lo_que_la_pieza_dice',
        etiqueta: 'LO QUE ESTA PIEZA NOS DICE',
        textoDescriptivo:
            'Que las personas que enterraron a sus muertos en Aralar '
            'hace miles de años los acompañaron con cerámica producida '
            'con cuidado. Que el cuidado por los muertos no necesita '
            'palabras para ser visible. Sólido. Lo que sigue siendo '
            'incertidumbre — y por tanto disputa abierta — es el '
            'sentido específico que ellos dieron al gesto de depositar '
            'esta pieza con esa persona en ese momento.',
      ),
    ],
  );

  /// La cartela de la inscripción honorífica romana de Pompelo
  /// (Brecha 2.1). Tras la sustitución POMPAELO-INSCRIPCION validada
  /// en F2-17, la pieza concreta es el ara funeraria de Aelio
  /// Attiano publicada en *Epigraphica* 76 (2014) por
  /// García-Barberena/Unzu/Velaza.
  static const CartelaPiezaArco4 cartelaPompelo = CartelaPiezaArco4(
    idPieza: 'pompelo',
    titulo: 'PIEZA II — Ara funeraria romana de Pompelo',
    identificacionDeLaPieza:
        'Ara funeraria romana con corona moldurada. Doble inscripción: '
        'cara A del s. I dedicada por el padre del difunto, cara B del '
        's. III reutilizando el mismo bloque. Procedencia: muralla '
        'bajoimperial de Pompelo (la actual Iruña/Pamplona), donde el '
        'bloque fue reutilizado. Pieza publicada por '
        'García-Barberena/Unzu/Velaza en *Epigraphica* 76 (2014). '
        'Fotografiada y trabajada por Maren Lozano durante la Brecha '
        'del ara de Aelio Attiano (Brecha 2.1).',
    lineas: [
      LineaCartelaParalela(
        id: 'm4_pompelo_procedencia',
        etiqueta: 'PROCEDENCIA',
        textoDescriptivo:
            'Reutilizada en la muralla bajoimperial de Pompelo (s. III '
            'tardío - s. IV). El contexto primario de la pieza es '
            'desconocido por el desplazamiento — el ara fue movida de '
            'su lugar original a la muralla como material constructivo. '
            'Sólido la reutilización; Probable el contexto primario '
            'como necrópolis suburbana de Pompelo.',
      ),
      LineaCartelaParalela(
        id: 'm4_pompelo_datacion',
        etiqueta: 'DATACIÓN',
        textoDescriptivo:
            'Cara A: s. I d.C. (paleografía y fórmula consular). Cara '
            'B: s. III d.C. (paleografía tardía). Sólido — la '
            'paleografía y las fórmulas dedicatorias permiten datar '
            'cada cara al siglo correspondiente con seguridad. La '
            'reutilización en muralla añade un tercer momento (s. III '
            'tardío - s. IV) en la biografía del bloque.',
      ),
      LineaCartelaParalela(
        id: 'm4_pompelo_lengua',
        etiqueta: 'LENGUA',
        textoDescriptivo:
            'Latín. Cara A con la fórmula `· D · M · S ·` (Diis Manibus '
            'Sacrum) del s. I; cara B con seis líneas dedicatorias del '
            's. III, incluido un error gramatical del lapicida en la '
            'línea 5. Sólido el texto literal en ambas caras; Sólido '
            'el error gramatical como rasgo de la pieza concreta '
            '(Maren lo articuló como "información que escapa a la '
            'propaganda" en la 2.1.4).',
      ),
      LineaCartelaParalela(
        id: 'm4_pompelo_funcion_original',
        etiqueta: 'FUNCIÓN ORIGINAL',
        textoDescriptivo:
            'Pieza honorífica funeraria. Cara A: dedicación de un '
            'padre al hijo difunto. Cara B: reutilización de la pieza '
            'para una segunda dedicación funeraria del s. III. Sólido '
            'la función honorífica funeraria en ambas inscripciones; '
            'Probable la identidad concreta de los dedicantes y '
            'honrados de cada cara (la cara A está en parte borrada y '
            'la cara B preserva nombres pero no el vínculo familiar '
            'completo).',
      ),
      LineaCartelaParalela(
        id: 'm4_pompelo_reutilizacion',
        etiqueta: 'REUTILIZACIÓN',
        textoDescriptivo:
            'Tres momentos documentados en la biografía de la pieza: '
            'inscripción original del s. I, reinscripción del s. III '
            'sobre el mismo bloque, y reutilización como material de '
            'la muralla bajoimperial. Sólido la triple biografía. '
            'Probable la lectura del último desplazamiento como signo '
            'de la inestabilidad del Imperio del s. III — la decisión '
            'de incorporar un ara funeraria a una muralla defensiva '
            'admite varias lecturas (urgencia constructiva, '
            'desacralización progresiva, simple disponibilidad de '
            'material), no cerrada con la pieza aislada.',
      ),
      LineaCartelaParalela(
        id: 'm4_pompelo_lo_que_la_pieza_dice',
        etiqueta: 'LO QUE ESTA PIEZA NOS DICE',
        textoDescriptivo:
            'Que en Pompelo, durante tres siglos al menos, hubo gente '
            'que dedicaba inscripciones a sus muertos con un cuidado '
            'que requirió encargar piedras grabadas a un lapicida. Que '
            'el lapicida del s. III cometió un error gramatical que el '
            'dedicante no corrigió — la propaganda funeraria romana es '
            'real, pero la imperfección humana del oficio escapa a su '
            'pulido. Y que la ciudad bajoimperial reutilizó la pieza en '
            'sus muros sin destruirla. Sólido. Lo que sigue siendo '
            'disputa abierta es por qué el dedicante del s. III aceptó '
            'el error y por qué la muralla bajoimperial integró un ara '
            'funeraria en su trazado.',
      ),
    ],
  );

  /// Las dos cartelas en orden de lectura paralela.
  static const List<CartelaPiezaArco4> dobleCartela = [
    cartelaAralar,
    cartelaPompelo,
  ];

  /// Mínimo de líneas (sumando las dos cartelas) que la Cronista debe
  /// haber **leído** (marcado como vista) para entregar. La pantalla
  /// del M4 muestra las dos cartelas en paralelo con cada línea
  /// marcable como leída. La regla de "al menos 10 de 12" preserva el
  /// respeto a la decisión de la Cronista de leer ambas cartelas
  /// antes de entregar sin obligarla a marcar todas mecánicamente.
  static const int minimoLineasLeidasParaEntregar = 10;

  /// Flag narrativo que dispara el Mosaico. El orquestador lo activa
  /// al cerrar la cinemática 4.G.3 (*"El silencio que vuelve"*) —
  /// cierre del último día de Archivo grande del MVP, cuando Maren
  /// vuelve a Iruña tras el segundo encuentro con Tasio en Tudela y
  /// está lista para producir el Mosaico final.
  static const String flagDeArcoCompletado = 'silencio_de_maren_segundo';

  /// Flag narrativo que se activa al entregar el Mosaico. Hace que la
  /// pantalla deje de aparecer y permite que el orquestador despache
  /// la cinemática `M4.entrega` (Andrés en el ático del Archivo).
  static const String flagDeMosaicoEntregado = 'mosaico_arco_4_entregado';
}
