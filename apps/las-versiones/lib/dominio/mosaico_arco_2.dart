/// **Mosaico de fin de Arco 2** — entrega creativa integradora del
/// arco (doc 08 §M2, doc 15 §3). Espacio paralelo no atomizado.
///
/// **Formato audio-guía** (doc 08 §M2): mientras el Mosaico del Arco 1
/// fue un cómic mudo de 8 viñetas, el del Arco 2 cambia de soporte a
/// una **audio-guía de aproximadamente 90 segundos**. La Cronista
/// graba (en el universo del juego) una serie de **fragmentos
/// pre-descritos** — declaraciones cortas leídas en voz alta — y por
/// cada uno declara verbalmente su nivel de confianza: "sólido" /
/// "probable" / "disputado". Los formatos son distintos a propósito:
/// el M1 reconoce el oficio de **mirar**; el M2 reconoce el oficio
/// de **decir** lo que se ha mirado, con la calibración explícita
/// que las Estaciones del Arco 2 piden.
///
/// **8 fragmentos** distribuidos por las 4 Estaciones del arco
/// (2 por Estación, anclados a las afirmaciones canónicas o fuentes
/// de cada Brecha). El criterio de entrega — al menos **6 fragmentos
/// marcados** — preserva el mismo espíritu del M1 ("la Cronista
/// puede dejar fragmentos sin marcar y aún así entregar").
///
/// **Pedagogía clave del M2**: la audio-guía recoge la voz de Maren
/// articulando declaraciones honestas mezcladas. Andrés (en la
/// cinemática `M2.entrega`) escucha y observa: *"has dicho 'no
/// sabemos' tres veces. Y 'probablemente' cuatro" / "está perfecto"*.
/// El reconocimiento del oficio bien hecho NO está en haber afirmado
/// con certeza, sino en haber **declarado la incertidumbre con
/// precisión** — exactamente lo que las cuatro Estaciones del arco
/// (Pompaelo bajo Iruña, Quintiliano de Calagurris, la domus de los
/// mosaicos, Wamba contra los vascones) han enseñado.
///
/// El Mosaico **no se evalúa con criterio algorítmico**. Es lectura
/// privada para la Cronista y, en el futuro, material que el adulto
/// acompañante puede leer (vía endpoint companion `/mosaicos`). La
/// pantalla no muestra puntuación tras la entrega — sólo encadena
/// con la cinemática de entrega (`M2.entrega`, ático del Archivo,
/// Andrés con auriculares) y, después, el cierre del arco (2.Z.1 +
/// 2.Z.2).
library;

// Re-exportamos `NivelConfianza` desde el path interno del core
// (igual que hace `mosaico_arco_1.dart` y `brecha.dart`) para no
// colisionar con el barrel del paquete cuando otro juego de la
// Colección usa el mismo nombre con significado distinto.
export 'package:nuevo_ser_core/src/calibration/nivel_confianza.dart'
    show NivelConfianza;

/// Un fragmento de la audio-guía del Mosaico del Arco 2. Texto
/// pre-escrito + identificador estable + lista de IDs de fuentes
/// (de las Brechas del arco) que esta declaración utiliza como
/// anclaje arqueológico/documental. Los fragmentos con
/// `idsFuentesAncladas` no vacío cuentan para el contador de
/// anclajes obligatorios.
class FragmentoAudioGuia {
  final String id;

  /// Texto que la pantalla muestra dentro del fragmento. Es la
  /// declaración leída en voz alta — pieza de la audio-guía que
  /// el oyente (Andrés en M2.entrega; en el futuro, el adulto
  /// acompañante) escucha. Tono primera persona, sintaxis hablada,
  /// declaración explícita de confianza al final cuando el
  /// fragmento la requiere.
  final String textoLeido;

  /// IDs de fuentes catalogadas en `CatalogoBrechas` (a través de
  /// las Brechas del Arco 2) que este fragmento usa como anclaje
  /// arqueológico/documental. Vacío si el fragmento es de
  /// integración pura (paisaje epistémico, voz interna, transición)
  /// sin anclaje directo a una fuente concreta.
  final List<String> idsFuentesAncladas;

  /// ID de la Brecha a la que pertenece el fragmento. Permite que
  /// la pantalla los organice por Estación.
  final String idBrechaOrigen;

  const FragmentoAudioGuia({
    required this.id,
    required this.textoLeido,
    required this.idsFuentesAncladas,
    required this.idBrechaOrigen,
  });

  /// `true` si el fragmento cuenta como anclaje obligatorio (lleva
  /// al menos una fuente catalogada).
  bool get esAnclajeObligatorio => idsFuentesAncladas.isNotEmpty;
}

class MosaicoArco2 {
  /// Identificador del arco — convención `arco_<n>` paralela al M1.
  /// Sirve como `arc_id` cuando llegue el cableado al endpoint
  /// companion `/companion/mosaicos`.
  static const String idArco = 'arco_2';

  /// Título visible del Mosaico.
  static const String titulo =
      'Mosaico del Arco 2 — La asimetría documental';

  /// **Pregunta abierta del arco**. El doc 08 §M2 fija el eje del
  /// Mosaico del Arco 2 en torno a aprender a declarar lo que las
  /// fuentes no permiten cerrar — la voz que sostiene la
  /// incertidumbre con precisión.
  static const String preguntaAbiertaDelArco =
      '¿Cómo se hace el oficio cuando las fuentes hablan sólo desde un '
      'lado — qué he aprendido en este segundo arco?';

  /// Glosa breve que la pantalla muestra antes de los fragmentos.
  /// Articula la pedagogía de la audio-guía y la regla mínima de
  /// entrega.
  static const String glosa =
      'Tu Mosaico es una audio-guía de aproximadamente noventa segundos. '
      'Cada fragmento es una declaración corta leída en voz alta. Por '
      'cada fragmento declaras tu nivel de confianza: Sólido, Probable '
      'o Disputado. No se evalúa la cualidad estética. Para entregar, '
      'marca al menos seis fragmentos.';

  /// Mínimo de fragmentos marcados requerido para que la pantalla
  /// permita entregar. Misma regla que el M1 (6 de 8) por
  /// consistencia y respeto a la decisión de la Cronista de dejar
  /// fragmentos sin marcar si no los siente suyos.
  static const int minimoFragmentosMarcadosParaEntregar = 6;

  /// Los 8 fragmentos pre-escritos, en el orden cronológico del
  /// arco. Cada par (1+2) corresponde a una Estación; el
  /// agrupamiento se usa para que la pantalla los distribuya con
  /// los dos fragmentos de cada Estación adyacentes.
  static const List<FragmentoAudioGuia> fragmentos = [
    // Estación 2.1 — Pompaelo bajo Iruña, La inscripción de Licinio.
    FragmentoAudioGuia(
      id: 'pompaelo_la_inscripcion_in_situ',
      textoLeido:
          'Bajo la calle Curia de Iruña hay un bloque calizo que honra '
          'a un cónsul Licinio. La inscripción es honorífica — eso lo '
          'sabemos por su forma. Y la datamos en algún momento entre '
          'el siglo I y el III. Hasta ahí podemos afirmar.',
      idsFuentesAncladas: [
        'inscripcion_in_situ',
        'paralelos_inscripciones_pompaelo',
      ],
      idBrechaOrigen: '2.1',
    ),
    FragmentoAudioGuia(
      id: 'pompaelo_lo_que_la_inscripcion_no_dice',
      textoLeido:
          'La cuarta línea está mutilada. Quién pagó este homenaje y '
          'qué relación tenía Licinio con Pompaelo no podemos cerrarlo '
          'desde la inscripción. Lo dejamos abierto. La pregunta es '
          'parte del registro.',
      idsFuentesAncladas: [
        'inscripcion_in_situ',
        'linea_dedicacion_perdida',
      ],
      idBrechaOrigen: '2.1',
    ),
    // Estación 2.2 — Quintiliano de Calagurris.
    FragmentoAudioGuia(
      id: 'calagurris_lo_que_quintiliano_dice',
      textoLeido:
          'Quintiliano nació en Calagurris y fue maestro profesional '
          'de retórica en Roma durante varias décadas. Dedicó la '
          'Institutio Oratoria a su patrón Vitorio Marcelo. Esto está '
          'en el libro mismo — sólido como afirmación textual.',
      idsFuentesAncladas: [
        'institutio_oratoria_pasajes',
        'yacimiento_calagurris',
      ],
      idBrechaOrigen: '2.2',
    ),
    FragmentoAudioGuia(
      id: 'calagurris_lo_que_quintiliano_omite',
      textoLeido:
          'Lo que la Institutio no dice también es información. '
          'Quintiliano escribe cuarenta años después de salir de '
          'Calagurris y no la describe. Probablemente, cuando escribe, '
          'su identidad cultural predominante ya es la romana. Pero esto '
          'es inferencia por omisión, no afirmación textual.',
      idsFuentesAncladas: [
        'institutio_oratoria_pasajes',
        'testimonio_arqueologa_local',
      ],
      idBrechaOrigen: '2.2',
    ),
    // Estación 2.3 — La domus de los mosaicos.
    FragmentoAudioGuia(
      id: 'domus_la_familia_que_aparece',
      textoLeido:
          'En la domus subterránea bajo Iruña vivió un Cornelio '
          'magistrado, mediados del siglo II. La inscripción del atrio '
          'lo dice. Las cuentas domésticas registran al menos dos '
          'personas esclavizadas — sin nombre, como número: servis II.',
      idsFuentesAncladas: [
        'inscripcion_propietario_cornelio',
        'tablilla_cuentas_domesticas',
      ],
      idBrechaOrigen: '2.3',
    ),
    FragmentoAudioGuia(
      id: 'domus_la_familia_que_no_aparece',
      textoLeido:
          'Las personas esclavizadas que sostenían la casa no están '
          'nombradas en ninguna fuente que se conserve. Y este silencio '
          'no es accidente del registro: es estructura de la sociedad '
          'romana esclavista que producía las fuentes. Lo declaro '
          'sólido — sólido como ausencia.',
      idsFuentesAncladas: [
        'tablilla_cuentas_domesticas',
        'inscripcion_propietario_cornelio',
        'restos_materiales_domus',
      ],
      idBrechaOrigen: '2.3',
    ),
    // Estación 2.4 — Wamba contra los vascones.
    FragmentoAudioGuia(
      id: 'wamba_la_cronica_visigoda',
      textoLeido:
          'En 673, el rey Wamba dirigió una campaña militar contra los '
          'vascones del norte. Lo sabemos por la Historia Wambae regis '
          'de Julián de Toledo, escrita seis décadas después. Es '
          'propaganda dinástica — relato hagiográfico, no neutro.',
      idsFuentesAncladas: [
        'historia_wambae_regis',
        'menciones_otras_fuentes_visigodas',
      ],
      idBrechaOrigen: '2.4',
    ),
    FragmentoAudioGuia(
      id: 'wamba_el_silencio_y_el_techo',
      textoLeido:
          'Del lado vascón no se conservan fuentes propias. Ni '
          'textuales ni epigráficas. Para reconstruir su perspectiva '
          'tenemos materia muda y mención indirecta en fuentes '
          'hostiles. La reconstrucción del lado vascón tiene un techo '
          'metodológico estructural — y eso lo declaro sólido. Como '
          'declaración metodológica.',
      idsFuentesAncladas: [
        'yacimiento_vascon_norte',
        'historia_wambae_regis',
        'comparacion_campanas_anteriores_posteriores',
      ],
      idBrechaOrigen: '2.4',
    ),
  ];

  /// Flag narrativo que dispara el Mosaico. El orquestador lo
  /// activa al cerrar la cinemática 2.4.8 ("Aprendiz II"), que es
  /// el cierre real del Arco 2 según el doc 08.
  static const String flagDeArcoCompletado = 'arco_2_estacion_4_cerrada';

  /// Flag narrativo que se activa al entregar el Mosaico. Hace que
  /// la pantalla deje de aparecer y dispara la cinemática de
  /// entrega (`M2.entrega`, Andrés con auriculares en el ático del
  /// Archivo) en el orquestador.
  static const String flagDeMosaicoEntregado = 'mosaico_arco_2_entregado';
}
