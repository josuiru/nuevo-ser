/// **Mosaico de fin de Arco 1** — entrega creativa integradora del
/// arco (doc 15 §3, doc 07 §M1). Espacio paralelo no atomizado.
///
/// **Formato v2** (doc 07 §M1, implementado en F8.7): la Cronista
/// recibe una serie de **viñetas pre-descritas** que recogen los
/// momentos jugados del arco — un cómic mudo del oficio. Por cada
/// viñeta declara un **código de confianza** (Sólido/Probable/
/// Disputado) según el rigor con el que sostiene esa pieza de la
/// reconstrucción. La pantalla **no evalúa cualidad estética** ni
/// la corrección de los códigos: sólo respeta los anclajes
/// obligatorios y deja que la Cronista entregue cuando considere.
///
/// El doc 07 v0.1 prescribe **8 viñetas** y al menos **3 anclajes
/// obligatorios** (de los 5 listados). Como el v0.2 amplió el arco
/// a cuatro Estaciones (Aralar dolmen + crómlech vecino + cueva del
/// Pirineo + Irulegi), las 8 viñetas se generalizan al arco entero
/// (2 viñetas por Estación, ancladas a fuentes ya jugadas). El
/// criterio de entrega — al menos **6 viñetas marcadas** — preserva
/// el espíritu del original ("3 de 5") aplicado a la nueva serie.
///
/// El Mosaico **no se evalúa con criterio algorítmico**. Es lectura
/// privada para la Cronista y, en el futuro, material que el adulto
/// acompañante puede leer (vía endpoint companion `/mosaicos`). La
/// pantalla no muestra puntuación tras la entrega — sólo encadena
/// con la cinemática de entrega (Andrés + Marina) y, después, el
/// cierre del arco (1.Z).
library;

// Re-exportamos `NivelConfianza` desde el path interno del core
// (igual que hace `brecha.dart`) para no colisionar con el barrel del
// paquete cuando otro juego de la Colección usa el mismo nombre con
// significado distinto.
export 'package:nuevo_ser_core/src/calibration/nivel_confianza.dart'
    show NivelConfianza;

/// Una viñeta del Mosaico v2. Texto descriptivo + identificador
/// estable + lista de IDs de fuentes (de las Brechas) que esta
/// viñeta utiliza como anclaje arqueológico. Las viñetas con
/// `idsFuentesAncladas` no vacío cuentan para el contador de
/// anclajes obligatorios.
class VinetaMosaico {
  final String id;

  /// Texto que la pantalla muestra dentro de la viñeta. El doc 07
  /// describe el Mosaico como "cómic mudo de 8 viñetas" — el texto
  /// hace de pie de viñeta breve, no es diálogo.
  final String pieDescriptivo;

  /// IDs de fuentes catalogadas en `CatalogoBrechas` que esta viñeta
  /// usa como anclaje arqueológico. Vacío si la viñeta es de
  /// integración pura (paisaje, voz interna, etc.) sin anclaje
  /// directo a una fuente.
  final List<String> idsFuentesAncladas;

  /// ID de la Brecha a la que pertenece la viñeta. Permite que la
  /// pantalla la organice por Estación.
  final String idBrechaOrigen;

  const VinetaMosaico({
    required this.id,
    required this.pieDescriptivo,
    required this.idsFuentesAncladas,
    required this.idBrechaOrigen,
  });

  /// `true` si la viñeta cuenta como anclaje obligatorio (lleva al
  /// menos una fuente catalogada).
  bool get esAnclajeObligatorio => idsFuentesAncladas.isNotEmpty;
}

class MosaicoArco1 {
  /// Identificador del arco — convención `arco_<n>` para futuros
  /// arcos. Sirve como `arc_id` cuando llegue el cableado al
  /// endpoint companion `/companion/mosaicos`.
  static const String idArco = 'arco_1';

  /// Título visible del Mosaico.
  static const String titulo = 'Mosaico del Arco 1 — El umbral del oficio';

  /// **Pregunta abierta del arco**. El doc 07 v0.1 §M1 propone
  /// "¿Cómo era de verdad un día cualquiera en Aralar hace 6.000
  /// años?", formulada cuando el arco era sólo Aralar. Con el
  /// v0.2 ampliado a cuatro Estaciones, la pregunta se generaliza.
  /// Anotado como sustitución diegética en BLOQUEOS-PENDIENTES.md.
  static const String preguntaAbiertaDelArco =
      '¿Cómo se hace el oficio del cronista — qué he aprendido en este '
      'primer arco?';

  /// Glosa breve que la pantalla muestra antes de las viñetas.
  /// Articula la pedagogía del código de confianza por viñeta y la
  /// regla mínima de entrega.
  static const String glosa =
      'Tu Mosaico es un cómic mudo de ocho viñetas. Cada viñeta recoge '
      'un momento del arco. Por cada una declaras tu nivel de confianza: '
      'Sólido, Probable o Disputado. No se evalúa la cualidad estética. '
      'Para entregar, marca al menos seis viñetas.';

  /// Mínimo de viñetas marcadas requerido para que la pantalla
  /// permita entregar. El doc 07 v0.1 prescribe "al menos 3 de 5
  /// anclajes obligatorios"; con 8 viñetas (2 por Estación), la
  /// regla equivalente es 6 de 8 — la Cronista puede dejar 2
  /// viñetas sin marcar (típicamente las de Estaciones que sintió
  /// menos suyas) y aún así entregar.
  static const int minimoVinetasMarcadasParaEntregar = 6;

  /// Las 8 viñetas pre-descritas, en el orden cronológico del arco.
  /// Cada par (1+2) corresponde a una Estación; el agrupamiento se
  /// usa para que la pantalla las distribuya en cuadrícula 4x2 con
  /// las dos viñetas de cada Estación adyacentes.
  static const List<VinetaMosaico> vinetas = [
    // Estación 1 — Aralar, primer dolmen.
    VinetaMosaico(
      id: 'aralar_dolmen_visita',
      pieDescriptivo: 'Maren cruza la sierra y llega al primer dolmen. '
          'Los huesos en su sitio, los líticos del entorno y los informes '
          'antiguo y moderno sostienen lo que ve.',
      idsFuentesAncladas: [
        'restos_oseos_in_situ',
        'material_litico_entorno',
        'informe_excavacion_antiguo',
        'informe_revision_moderno',
      ],
      idBrechaOrigen: '1.1',
    ),
    VinetaMosaico(
      id: 'aralar_paisaje_y_toponimo',
      pieDescriptivo: 'El paisaje actual de Aralar en el horizonte. '
          'Sobre él, el topónimo local que llega oral hasta hoy. Lo que '
          'se mantiene, lo que ha cambiado — sólo lo documentado.',
      idsFuentesAncladas: [
        'informe_revision_moderno',
        'toponimo_local',
      ],
      idBrechaOrigen: '1.1',
    ),
    // Estación 2 — Crómlech vecino, banquete.
    VinetaMosaico(
      id: 'cromlech_banquete',
      pieDescriptivo: 'El crómlech vecino. Cerámica fragmentada en su '
          'sitio, lítico escaso. Una sola C14 en el hueco entre piedras. '
          'Un banquete, probablemente — no un enterramiento.',
      idsFuentesAncladas: [
        'ceramica_fragmentada_superficie',
        'datacion_c14_unica',
        'material_litico_escaso',
      ],
      idBrechaOrigen: '1.2',
    ),
    VinetaMosaico(
      id: 'cromlech_dialogo_con_sira',
      pieDescriptivo: 'Maren y Sira en la caminata de regreso. Frenar a '
          'una par sin imponer. Tener razón sin convertirla en bandera.',
      idsFuentesAncladas: [],
      idBrechaOrigen: '1.2',
    ),
    // Estación 3 — Cueva del Pirineo.
    VinetaMosaico(
      id: 'cueva_grabados_parietales',
      pieDescriptivo: 'En la sala profunda, los grabados sólo aparecen '
          'cuando la linterna pega oblicua. Bisonte, ciervo, cabeza de '
          'uro, caballo. Líneas profundas que pidieron luz que se trajo.',
      idsFuentesAncladas: [
        'grabados_parietales_in_situ',
        'comparativa_otras_cuevas_pirenaicas',
      ],
      idBrechaOrigen: '1.3',
    ),
    VinetaMosaico(
      id: 'cueva_covacho_habitacion',
      pieDescriptivo: 'En el covacho contiguo, los carbones, la fauna, los '
          'líticos del Magdaleniense. Vivir en un sitio. Quizás los mismos '
          'que grababan, quizás no.',
      idsFuentesAncladas: [
        'covacho_habitacion_carbones',
        'informe_excavacion_decadas_pasadas',
      ],
      idBrechaOrigen: '1.3',
    ),
    // Estación 4 — Irulegi y la Mano.
    VinetaMosaico(
      id: 'irulegi_casa_y_enlosado',
      pieDescriptivo: 'La casa con las escaleras de siete peldaños. Cerca, '
          'el enlosado del cobertizo derrumbado. Aprender una técnica sin '
          'dominarla. La fotografía congelada de una jornada de hace dos '
          'mil años.',
      idsFuentesAncladas: [
        'casa_con_escaleras_irulegi',
        'enlosado_cobertizo_colapsado',
        'ceramica_mixta_irulegi',
        'armas_ataque_romano',
      ],
      idBrechaOrigen: '1.4',
    ),
    VinetaMosaico(
      id: 'irulegi_la_mano',
      pieDescriptivo: 'La Mano colgada en su dintel. La cartela del museo '
          'con dos lecturas distintas. El monográfico abierto. La '
          'incertidumbre como postura, no como rendición.',
      idsFuentesAncladas: [
        'mano_irulegi_pieza',
        'cartela_museo_dos_lecturas',
        'monografico_flv_136',
      ],
      idBrechaOrigen: '1.4',
    ),
  ];

  /// Flag narrativo que dispara el Mosaico. El orquestador lo
  /// activa al cerrar la cinemática 1.4.4 ("Aprendiz I"), que es el
  /// cierre real del arco según el doc 07 §M1.
  static const String flagDeArcoCompletado = 'arco_1_completado';

  /// Flag narrativo que se activa al entregar el Mosaico. Hace que
  /// la pantalla deje de aparecer y dispara la cinemática de
  /// entrega (Andrés + Marina) en el orquestador.
  static const String flagDeMosaicoEntregado = 'mosaico_arco_1_entregado';
}
