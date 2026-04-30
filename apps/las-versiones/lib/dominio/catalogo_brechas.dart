import 'brecha.dart';

/// Catálogo de Brechas del MVP. Cada entrada es la unidad jugable
/// que el orquestador abre cuando las cinemáticas previas de la
/// Estación correspondiente la dejan disponible.
///
/// Esta v0.1 contiene sólo el **esqueleto** de la Brecha 1.1 —
/// metadata estable (id, título, ubicación, flag de completado) sin
/// fuentes ni afirmaciones. El contenido pedagógico se rellena en
/// F6.2 (recolección), F6.3 (evaluación) y F6.4 (reconstrucción) a
/// medida que cada fase jugable lo necesita. Mientras tanto, la
/// pantalla de Brecha (F4.3) puede navegar entre fases mostrando
/// placeholders sin que el catálogo bloquee el progreso.
class CatalogoBrechas {
  CatalogoBrechas._();

  /// **Brecha 1.1 — El primer dolmen** (Aralar). La primera Brecha
  /// del MVP, hilo conductor de las cinemáticas 1.1.1 (camino),
  /// 1.1.2 (llegada) y 1.1.7 (primer apunte). El bloque jugable
  /// vive aquí.
  ///
  /// Habilidades ejercitadas según doc 02:
  /// - PR.01, PR.02 — formulación de preguntas (Fase 1).
  /// - HF.01-09 — análisis de fuentes (Fase 3).
  /// - AH.01-03 — argumentación + calibración (Fase 4).
  ///
  /// **Las cinco fuentes son explícitamente ficticias y diegéticas**.
  /// No se afirma autoría real, ni dataciones C14 con desviaciones
  /// específicas, ni publicaciones identificables — el comité asesor
  /// (doc 16) no las ha validado todavía. Lo que sí se preserva es la
  /// pedagogía: contraste primaria/secundaria, sesgo difusionista en
  /// la fuente antigua, fuente lingüística por topónimo, fuente
  /// material in situ. Ver `BLOQUEOS-PENDIENTES.md` para detalle.
  static const Brecha brecha11 = Brecha(
    id: '1.1',
    titulo: 'El primer dolmen',
    ubicacionVisible: 'ARALAR — DOLMEN DE AROZTEGI',
    habilidadesEjercitadas: [
      'PR.01',
      'PR.02',
      'HF.01',
      'HF.02',
      'HF.03',
      'HF.04',
      'HF.05',
      'HF.06',
      'HF.07',
      'HF.08',
      'HF.09',
      'AH.01',
      'AH.02',
      'AH.03',
    ],
    fuentes: _fuentesBrecha11,
    afirmacionesCanonicas: _afirmacionesBrecha11,
    flagDeCompletado: 'brecha_1_1_completada',
  );

  static const List<Fuente> _fuentesBrecha11 = [
    Fuente(
      id: 'restos_oseos_in_situ',
      tipoVisible: 'Restos óseos en el hueco interior',
      descripcion: 'Bajo la losa de cubierta hay fragmentos óseos. La '
          'colocación es ordenada — no parecen restos arrastrados por la '
          'tierra. Hay también un objeto pequeño de piedra pulida junto a '
          'ellos.',
      propiedadesCanonicas: PropiedadesFuente(
        tipo: TipoFuente.primaria,
        autor: 'Las personas que enterraron a quien aquí descansa',
        fecha: 'Probablemente el momento del enterramiento',
        publico: 'Sus propios deudos y descendientes',
        intereses: 'Honrar al difunto — ningún interés historiográfico',
        omisiones: 'Quiénes eran, cómo vivían, qué creían',
        corroboraOContradice: 'Es la evidencia que cualquier informe '
            'posterior intenta interpretar',
      ),
    ),
    Fuente(
      id: 'material_litico_entorno',
      tipoVisible: 'Material lítico del entorno inmediato',
      descripcion: 'A pocos metros del monumento aparecen lascas y '
          'fragmentos pulidos. Algunos parecen herramientas; otros, '
          'desechos del trabajo de tallar piedra.',
      propiedadesCanonicas: PropiedadesFuente(
        tipo: TipoFuente.primaria,
        autor: 'Quien talló y usó las herramientas',
        fecha: 'Cercana al uso del lugar — difícil de precisar sin análisis',
        publico: 'Nadie — son herramientas de uso, no objetos comunicativos',
        intereses: 'Trabajo cotidiano',
        omisiones: 'Función exacta de cada pieza, contexto social',
        corroboraOContradice: 'Pone fecha aproximada a la actividad humana '
            'en el sitio',
      ),
    ),
    Fuente(
      id: 'informe_excavacion_antiguo',
      tipoVisible: 'Informe de una excavación de los años 70',
      descripcion: 'Texto mecanografiado, prosa académica de su época. '
          'Atribuye el monumento a "influencias atlánticas" y compara con '
          'megalitismo bretón. No menciona la fauna local ni el contexto '
          'pirenaico circundante. La autoría firma como un equipo del que '
          'el archivo no conserva más datos.',
      propiedadesCanonicas: PropiedadesFuente(
        tipo: TipoFuente.secundaria,
        autor: 'Un equipo de arqueología de los años 70',
        fecha: 'Años 70 del siglo XX',
        publico: 'Comunidad académica de la época',
        intereses: 'Inscribir el hallazgo en una corriente '
            'historiográfica internacional',
        omisiones: 'Contexto local, posibles paralelismos pirenaicos',
        corroboraOContradice: 'Aporta interpretación, no evidencia nueva',
        sesgo: SesgoFuente.difusionista,
      ),
    ),
    Fuente(
      id: 'informe_revision_moderno',
      tipoVisible: 'Informe de una revisión moderna del sitio',
      descripcion: 'Documento reciente. Recoge mediciones de carbono 14 '
          'sobre dos huesos del enterramiento (datos hacia 4300 a.C. y '
          'hacia 3900 a.C.) y discute la atribución antigua. Reconoce que '
          'no todo está cerrado: hay reinterpretaciones posibles.',
      propiedadesCanonicas: PropiedadesFuente(
        tipo: TipoFuente.secundaria,
        autor: 'Un equipo de revisión arqueológica reciente',
        fecha: 'Década de 2010 (publicación reciente)',
        publico: 'Comunidad académica + público general informado',
        intereses: 'Datar con precisión y revisar atribuciones obsoletas',
        omisiones: 'Análisis genético no incluido — todavía pendiente',
        corroboraOContradice: 'Contradice parcialmente al informe antiguo '
            '— aporta dataciones que el primero no tenía',
      ),
    ),
    Fuente(
      id: 'toponimo_local',
      tipoVisible: 'Nombre del lugar en la lengua de la sierra',
      descripcion: 'Los pastores que aún suben con las ovejas llaman al '
          'sitio con un nombre antiguo cuyo significado describe la '
          'función del monumento, no su forma. El nombre se transmite '
          'oralmente — no aparece en mapas oficiales antiguos.',
      propiedadesCanonicas: PropiedadesFuente(
        tipo: TipoFuente.secundaria,
        autor: 'La tradición oral de quienes han habitado la sierra',
        fecha: 'Indeterminada — el topónimo es muy antiguo, su uso actual '
            'es contemporáneo',
        publico: 'La propia comunidad pastoril',
        intereses: 'Práctico — el nombre sirve para orientarse',
        omisiones: 'Cuándo se acuñó, si tuvo otros nombres antes',
        corroboraOContradice: 'Aporta una pista lingüística sobre la '
            'función del monumento que las fuentes escritas no tienen',
      ),
    ),
  ];

  /// Afirmaciones precanónicas que la Cronista puede considerar
  /// sostenidas en la Fase 4 de Reconstrucción. Cada una declara su
  /// `calibracionCorrecta` —el nivel de confianza que el oficio
  /// pondría hoy— y los IDs de las fuentes que la anclan. P4 Brier
  /// compara la elección de la Cronista con la calibración correcta.
  ///
  /// **Las afirmaciones siguen siendo ficticias y diegéticas**. Lo que
  /// se afirma no es contenido histórico real sobre el dolmen de
  /// Aroztegi (no validado por el comité asesor), sino formulaciones
  /// genéricas y redondeadas que ejemplifican la estructura del
  /// pensamiento histórico —"esto es Sólido, esto es Probable, esto
  /// es Disputado"— sin afirmar identificación, autoría o datación
  /// con precisión que requeriría revisión externa.
  static const List<AfirmacionCanonica> _afirmacionesBrecha11 = [
    AfirmacionCanonica(
      id: 'es_un_enterramiento',
      texto: 'En este lugar se realizaron enterramientos humanos.',
      calibracionCorrecta: NivelConfianza.solido,
      idsFuentesAnclaje: [
        'restos_oseos_in_situ',
        'informe_excavacion_antiguo',
        'informe_revision_moderno',
      ],
    ),
    AfirmacionCanonica(
      id: 'fechado_neolitico',
      texto: 'El uso del lugar se sitúa en un rango temporal '
          'compatible con el Neolítico.',
      calibracionCorrecta: NivelConfianza.solido,
      idsFuentesAnclaje: [
        'informe_revision_moderno',
        'material_litico_entorno',
      ],
    ),
    AfirmacionCanonica(
      id: 'numero_personas_enterradas',
      texto: 'Se puede precisar cuántas personas fueron enterradas '
          'aquí en total a lo largo del uso del monumento.',
      calibracionCorrecta: NivelConfianza.disputado,
      idsFuentesAnclaje: ['restos_oseos_in_situ'],
    ),
    AfirmacionCanonica(
      id: 'origen_atlantico',
      texto: 'El monumento es producto directo de una influencia '
          'cultural llegada desde la fachada atlántica europea.',
      calibracionCorrecta: NivelConfianza.disputado,
      idsFuentesAnclaje: ['informe_excavacion_antiguo'],
    ),
    AfirmacionCanonica(
      id: 'funcion_ritual',
      texto: 'El lugar tuvo función ritual además de funeraria.',
      calibracionCorrecta: NivelConfianza.probable,
      idsFuentesAnclaje: [
        'restos_oseos_in_situ',
        'toponimo_local',
      ],
    ),
    AfirmacionCanonica(
      id: 'comunidad_pastoril',
      texto: 'Quienes lo construyeron eran ya una comunidad con '
          'cierta estabilidad y vínculo con el territorio circundante.',
      calibracionCorrecta: NivelConfianza.probable,
      idsFuentesAnclaje: [
        'material_litico_entorno',
        'toponimo_local',
      ],
    ),
  ];

  /// **Brecha 1.2 — El crómlech vecino** (Aralar, segunda visita).
  /// La protagonista trabaja con Sira Goizueta (Aprendiz II). La
  /// lección epistémica del doc 07: cronología relativa sin
  /// datación absoluta sólida. **Probable** se vuelve protagonista.
  ///
  /// Habilidades ejercitadas según doc 02:
  /// - PR.01-04 — formulación con un par.
  /// - HF.01-04, HF.06-09 — análisis de fuentes.
  /// - CC.04-05 — cronología relativa, comparación tipológica.
  /// - AH.01-03 — argumentación con incertidumbre.
  ///
  /// **Las cinco fuentes son explícitamente ficticias y diegéticas**
  /// — no afirman C14 reales con cifra concreta, no atribuyen
  /// publicaciones identificables, no nombran arqueólogos
  /// específicos. La pedagogía que se preserva: una sola C14
  /// disponible, comparación con vecinos, tipología cerámica como
  /// herramienta de cronología relativa, ausencia de restos óseos
  /// que limita lo declarable. Ver `BLOQUEOS-PENDIENTES.md`.
  static const Brecha brecha12 = Brecha(
    id: '1.2',
    titulo: 'El crómlech vecino',
    ubicacionVisible: 'ARALAR — CRÓMLECH PRÓXIMO',
    habilidadesEjercitadas: [
      'PR.01',
      'PR.02',
      'PR.03',
      'PR.04',
      'HF.01',
      'HF.02',
      'HF.03',
      'HF.04',
      'HF.06',
      'HF.07',
      'HF.08',
      'HF.09',
      'CC.04',
      'CC.05',
      'AH.01',
      'AH.02',
      'AH.03',
    ],
    fuentes: _fuentesBrecha12,
    afirmacionesCanonicas: _afirmacionesBrecha12,
    flagDeCompletado: 'brecha_1_2_completada',
  );

  static const List<Fuente> _fuentesBrecha12 = [
    Fuente(
      id: 'ceramica_fragmentada_superficie',
      tipoVisible: 'Cerámica fragmentaria en superficie',
      descripcion: 'En el suelo del crómlech aparecen abundantes '
          'fragmentos cerámicos de pequeño tamaño. Las paredes son '
          'finas y la cocción dispar. El conjunto sugiere vasijas '
          'rotas in situ, no traídas ya rotas — algunos fragmentos '
          'remontan entre sí.',
      propiedadesCanonicas: PropiedadesFuente(
        tipo: TipoFuente.primaria,
        autor: 'Quienes celebraron la actividad que dejó estos restos',
        fecha: 'Probablemente el momento del uso del lugar',
        publico: 'Los participantes del propio acto',
        intereses: 'Banquete o ritual — ningún interés historiográfico',
        omisiones: 'Quiénes eran, cuántos, qué celebraban exactamente',
        corroboraOContradice: 'Es la evidencia material principal del '
            'tipo de actividad realizada en el sitio',
      ),
    ),
    Fuente(
      id: 'datacion_c14_unica',
      tipoVisible: 'Una única datación de carbono 14',
      descripcion: 'Documento técnico breve. Recoge una sola medición '
          'C14 sobre un fragmento de carbón vegetal recuperado de un '
          'hueco entre dos piedras del crómlech. La cifra cae en un '
          'rango compatible con el Neolítico tardío. No hay otras '
          'mediciones — el material orgánico recuperable era escaso.',
      propiedadesCanonicas: PropiedadesFuente(
        tipo: TipoFuente.secundaria,
        autor: 'Un laboratorio de datación contemporáneo',
        fecha: 'Reciente — análisis publicado en los últimos años',
        publico: 'Equipo de revisión arqueológica del sitio',
        intereses: 'Acotar la cronología absoluta del crómlech',
        omisiones: 'Una sola muestra; no hay control de coherencia '
            'entre dataciones; el carbón pudo entrar al hueco después '
            'del uso original',
        corroboraOContradice: 'Aporta un único punto temporal; sin '
            'paralelos internos del propio sitio',
      ),
    ),
    Fuente(
      id: 'material_litico_escaso',
      tipoVisible: 'Material lítico escaso del entorno',
      descripcion: 'En los alrededores del círculo aparecen unas pocas '
          'lascas y una herramienta pulida. La cantidad es mucho '
          'menor que en el dolmen vecino — no parece zona de trabajo '
          'continuado. Los pocos restos sugieren actividad puntual.',
      propiedadesCanonicas: PropiedadesFuente(
        tipo: TipoFuente.primaria,
        autor: 'Quien talló o trajo las herramientas usadas en el sitio',
        fecha: 'Cercana al uso del lugar',
        publico: 'Nadie',
        intereses: 'Trabajo asociado al acto que se celebró',
        omisiones: 'Función exacta, intensidad real de la actividad',
        corroboraOContradice: 'Refuerza la lectura de uso puntual y '
            'no de habitación prolongada',
      ),
    ),
    Fuente(
      id: 'informe_comparativo_dolmenes_vecinos',
      tipoVisible: 'Informe comparativo con dólmenes vecinos',
      descripcion: 'Texto académico reciente que cataloga el conjunto '
          'megalítico de la sierra. Compara la tipología cerámica del '
          'crómlech con la de varios dólmenes y crómlechs catalogados '
          'a pocos kilómetros. Concluye que la tipología es coherente '
          'con un horizonte cultural y temporal compartido, aunque la '
          'datación absoluta de cada sitio sigue siendo aproximada.',
      propiedadesCanonicas: PropiedadesFuente(
        tipo: TipoFuente.secundaria,
        autor: 'Un equipo académico actual',
        fecha: 'Publicación reciente',
        publico: 'Comunidad arqueológica especializada',
        intereses: 'Inscribir cada sitio en una secuencia comparativa',
        omisiones: 'Las dataciones absolutas siguen siendo escasas; la '
            'tipología cerámica es herramienta probabilística',
        corroboraOContradice: 'Permite cronología relativa donde la '
            'absoluta no llega — pero no la sustituye',
      ),
    ),
    Fuente(
      id: 'toponimo_del_circulo',
      tipoVisible: 'Topónimo del círculo en la sierra',
      descripcion: 'Los pastores que conocen el lugar le dan un '
          'nombre distinto al del dolmen vecino. Su raíz lingüística '
          'no remite al enterramiento sino a la idea de reunión o '
          'asamblea. La transmisión es oral, sin atestación escrita '
          'antigua.',
      propiedadesCanonicas: PropiedadesFuente(
        tipo: TipoFuente.secundaria,
        autor: 'La tradición oral de la sierra',
        fecha: 'Indeterminada — el topónimo es antiguo, su uso '
            'actual es contemporáneo',
        publico: 'La comunidad pastoril que lo usa',
        intereses: 'Práctico — el nombre orienta',
        omisiones: 'Cuándo se acuñó; si tuvo otros nombres antes',
        corroboraOContradice: 'Aporta una pista lingüística sobre la '
            'función percibida del sitio',
      ),
    ),
  ];

  /// Afirmaciones canónicas de la Brecha 1.2. La distribución de
  /// niveles refleja la lección epistémica de la Estación 2:
  /// **Probable** es protagonista. Sólo dos Sólidas (las que cubre
  /// la cerámica + la datación + la comparación), tres Probables,
  /// una Disputada. Sin restos óseos no se puede afirmar
  /// enterramiento concreto.
  static const List<AfirmacionCanonica> _afirmacionesBrecha12 = [
    AfirmacionCanonica(
      id: 'hubo_actividad_humana_significativa',
      texto: 'Hubo en este lugar actividad humana significativa, no '
          'meramente pastoril ocasional.',
      calibracionCorrecta: NivelConfianza.solido,
      idsFuentesAnclaje: [
        'ceramica_fragmentada_superficie',
        'material_litico_escaso',
        'datacion_c14_unica',
      ],
    ),
    AfirmacionCanonica(
      id: 'horizonte_neolitico_tardio',
      texto: 'El uso del lugar se sitúa en un horizonte temporal '
          'compatible con el Neolítico tardío.',
      calibracionCorrecta: NivelConfianza.solido,
      idsFuentesAnclaje: [
        'datacion_c14_unica',
        'informe_comparativo_dolmenes_vecinos',
      ],
    ),
    AfirmacionCanonica(
      id: 'datacion_absoluta_precisa',
      texto: 'Se puede precisar la datación absoluta del crómlech con '
          'la misma seguridad que la del dolmen vecino.',
      calibracionCorrecta: NivelConfianza.disputado,
      idsFuentesAnclaje: ['datacion_c14_unica'],
    ),
    AfirmacionCanonica(
      id: 'banquete_ritual',
      texto: 'La fragmentación cerámica es consecuencia de un '
          'banquete o acto ritual celebrado in situ.',
      calibracionCorrecta: NivelConfianza.probable,
      idsFuentesAnclaje: [
        'ceramica_fragmentada_superficie',
        'toponimo_del_circulo',
      ],
    ),
    AfirmacionCanonica(
      id: 'coetaneo_dolmen_vecino',
      texto: 'El crómlech es coetáneo del dolmen vecino — ambos '
          'forman parte de un mismo paisaje funerario.',
      calibracionCorrecta: NivelConfianza.probable,
      idsFuentesAnclaje: [
        'informe_comparativo_dolmenes_vecinos',
        'datacion_c14_unica',
      ],
    ),
    AfirmacionCanonica(
      id: 'funcion_asamblearia',
      texto: 'El sitio tuvo función de reunión o asamblea, además '
          'de la posiblemente funeraria.',
      calibracionCorrecta: NivelConfianza.probable,
      idsFuentesAnclaje: [
        'toponimo_del_circulo',
        'ceramica_fragmentada_superficie',
      ],
    ),
  ];

  /// **Brecha 1.3 — La cueva del Pirineo**. Cueva paleolítica con
  /// grabados parietales magdalenienses (bisonte, ciervo, cabeza
  /// de uro, caballo). Lección epistémica del doc 07: cómo declarar
  /// **disputada** una afirmación clave —el significado del arte
  /// parietal— sin caer en relativismo, y cómo distinguir "no se
  /// sabe" de "no se puede determinar con la evidencia disponible".
  /// Primer Concilio formal de Maren con revisores académicos.
  ///
  /// Habilidades ejercitadas según doc 02:
  /// - PR.01-05 — formulación tras la primera lectura del cuerpo.
  /// - HF.01-12 — análisis de fuentes incluyendo testimonios
  ///   especializados, dataciones de laboratorio, paralelismos.
  /// - CC.04-07 — cronología paleolítica, calibrado, marcadores
  ///   culturales.
  /// - PH.01-05 — perspectiva histórica frente a sujetos del
  ///   Paleolítico (antídoto al presentismo).
  /// - AH.01-05 — argumentación, formulación de incertidumbre.
  ///
  /// **Las cinco fuentes son explícitamente ficticias y diegéticas**.
  /// La cueva concreta NO se identifica con ningún yacimiento real
  /// — el doc 07 v0.2 caracteriza el lugar como "Alkerdi I literaria,
  /// modelo verosímil basado en lo real". Las dataciones por C14 se
  /// mantienen en el rango canónico del Magdaleniense Inferior o
  /// Medio (~13.000 años antes del presente, validado en doc 17 para
  /// la capa Cueva-Pirineo) pero sin laboratorio ni publicación
  /// concreta. Ver `BLOQUEOS-PENDIENTES.md`.
  static const Brecha brecha13 = Brecha(
    id: '1.3',
    titulo: 'La cueva del Pirineo',
    ubicacionVisible: 'PIRINEO — CUEVA CON GRABADOS PARIETALES',
    habilidadesEjercitadas: [
      'PR.01',
      'PR.02',
      'PR.03',
      'PR.04',
      'PR.05',
      'HF.01',
      'HF.02',
      'HF.03',
      'HF.04',
      'HF.06',
      'HF.07',
      'HF.08',
      'HF.09',
      'HF.11',
      'HF.12',
      'CC.04',
      'CC.05',
      'CC.06',
      'CC.07',
      'PH.01',
      'PH.02',
      'PH.03',
      'PH.04',
      'PH.05',
      'AH.01',
      'AH.02',
      'AH.03',
      'AH.04',
      'AH.05',
    ],
    fuentes: _fuentesBrecha13,
    afirmacionesCanonicas: _afirmacionesBrecha13,
    flagDeCompletado: 'brecha_1_3_completada',
  );

  static const List<Fuente> _fuentesBrecha13 = [
    Fuente(
      id: 'grabados_parietales_in_situ',
      tipoVisible: 'Los grabados parietales en la pared',
      descripcion: 'En una sala profunda de la cueva, donde no llega '
          'la luz natural, hay líneas grabadas en la roca. Sólo '
          'aparecen cuando la linterna pega oblicua. Se reconoce un '
          'bisonte, una cabeza de uro, un ciervo y la parte trasera '
          'de un caballo. Las líneas están profundizadas con varias '
          'pasadas — no son arañazos.',
      propiedadesCanonicas: PropiedadesFuente(
        tipo: TipoFuente.primaria,
        autor: 'Quien o quienes grabaron las imágenes',
        fecha: 'En el momento de la actividad — Magdaleniense '
            'Inferior o Medio',
        publico: 'Indeterminado — la luz natural no llega aquí, hizo '
            'falta luz que se trajo',
        intereses: 'No determinables con la evidencia disponible',
        omisiones: 'Quiénes eran, por qué eligieron este lugar oculto, '
            'qué representaba para ellos cada figura',
        corroboraOContradice: 'Es la evidencia central — todo lo demás '
            'la contextualiza',
      ),
    ),
    Fuente(
      id: 'covacho_habitacion_carbones',
      tipoVisible: 'Carbones y huesos del covacho de habitación',
      descripcion: 'En el covacho próximo, separado de la sala con '
          'grabados, hay concentraciones de carbón vegetal asociadas '
          'a fragmentos óseos de fauna y herramientas líticas. '
          'Estructura típica de hogar paleolítico: cocina, dormir, '
          'tallar herramientas. La datación C14 sobre los carbones '
          'sitúa el uso del covacho en el Magdaleniense.',
      propiedadesCanonicas: PropiedadesFuente(
        tipo: TipoFuente.primaria,
        autor: 'Las personas que habitaron el covacho',
        fecha: 'Magdaleniense Inferior o Medio (~13.000 años antes '
            'del presente)',
        publico: 'Sus propios habitantes',
        intereses: 'Vivir — comer, calentarse, protegerse',
        omisiones: 'Si las mismas personas hacían los grabados, qué '
            'relación había entre los dos espacios',
        corroboraOContradice: 'Sitúa cronológicamente la actividad '
            'humana en la zona; no demuestra autoría de los grabados',
      ),
    ),
    Fuente(
      id: 'informe_excavacion_decadas_pasadas',
      tipoVisible: 'Informes de excavación de décadas pasadas',
      descripcion: 'Conjunto de informes técnicos de campañas de '
          'excavación realizadas en el covacho durante varias '
          'décadas. Recogen estratigrafía, dataciones C14 sobre '
          'distintos niveles, inventario de fauna y herramientas. '
          'Algunos informes son antiguos y usan terminología hoy '
          'revisada; otros son más recientes y han revisado las '
          'atribuciones tipológicas.',
      propiedadesCanonicas: PropiedadesFuente(
        tipo: TipoFuente.secundaria,
        autor: 'Equipos académicos de varias generaciones',
        fecha: 'Décadas de 1970 a 2000 (publicaciones escalonadas)',
        publico: 'Comunidad académica especializada en Paleolítico '
            'pirenaico',
        intereses: 'Documentar el yacimiento; encajar el sitio en la '
            'secuencia regional',
        omisiones: 'Análisis isotópicos modernos no incluidos en los '
            'informes antiguos; reinterpretaciones posibles a la luz '
            'de campañas más recientes',
        corroboraOContradice: 'Aportan dataciones y contexto; las '
            'interpretaciones del arte no son competencia de estos '
            'informes',
      ),
    ),
    Fuente(
      id: 'comparativa_otras_cuevas_pirenaicas',
      tipoVisible: 'Comparativa con otras cuevas paleolíticas '
          'pirenaicas',
      descripcion: 'Estudio académico que coteja la cueva con otros '
          'sitios paleolíticos del Pirineo con arte parietal. '
          'Identifica continuidades estilísticas en la representación '
          'animal y discontinuidades en otros aspectos. La conclusión '
          'metodológica del estudio es prudente: las semejanzas '
          'estilísticas no autorizan a afirmar identidad cultural '
          'completa entre los grupos.',
      propiedadesCanonicas: PropiedadesFuente(
        tipo: TipoFuente.secundaria,
        autor: 'Un equipo académico de prehistoria',
        fecha: 'Publicación contemporánea',
        publico: 'Comunidad académica de prehistoria europea',
        intereses: 'Inscribir la cueva en una red comparativa',
        omisiones: 'Datos no publicados de cuevas en estudio activo',
        corroboraOContradice: 'Refuerza la datación cultural; mantiene '
            'abierta la cuestión de la función simbólica',
      ),
    ),
    Fuente(
      id: 'losas_selladoras_posteriores',
      tipoVisible: 'Las losas que cierran parcialmente la sala',
      descripcion: 'A la entrada de la sala con grabados, dos '
          'grandes losas están movidas hacia un lado pero claramente '
          'fueron emplazadas en algún momento para sellar el paso. '
          'La técnica de colocación y el desgaste sugieren que se '
          'pusieron mucho tiempo después de los grabados, en una '
          'fase posterior y no determinada.',
      propiedadesCanonicas: PropiedadesFuente(
        tipo: TipoFuente.primaria,
        autor: 'Quien las emplazó — desconocido',
        fecha: 'Posterior a los grabados, fecha indeterminada',
        publico: 'Desconocido',
        intereses: 'Aparentemente sellar la sala — por qué, no se '
            'puede determinar con la evidencia disponible',
        omisiones: 'Cuándo, quién, por qué',
        corroboraOContradice: 'Indica que el lugar siguió siendo '
            'significativo para alguien mucho después de los grabados',
      ),
    ),
  ];

  /// Afirmaciones canónicas de la Brecha 1.3. La distribución
  /// refleja la lección del doc 07: la afirmación clave es
  /// **Disputada** —el significado del arte parietal— y la
  /// formulación importa ("no podemos determinar con la evidencia
  /// disponible" frente a "no se sabe").
  static const List<AfirmacionCanonica> _afirmacionesBrecha13 = [
    AfirmacionCanonica(
      id: 'presencia_humana_magdaleniense',
      texto: 'Hubo presencia humana magdaleniense en el covacho de '
          'habitación contiguo a la cueva con grabados.',
      calibracionCorrecta: NivelConfianza.solido,
      idsFuentesAnclaje: [
        'covacho_habitacion_carbones',
        'informe_excavacion_decadas_pasadas',
      ],
    ),
    AfirmacionCanonica(
      id: 'datacion_magdaleniense',
      texto: 'La datación de la actividad humana asociada se sitúa '
          'en torno al Magdaleniense Inferior o Medio.',
      calibracionCorrecta: NivelConfianza.solido,
      idsFuentesAnclaje: [
        'covacho_habitacion_carbones',
        'informe_excavacion_decadas_pasadas',
        'comparativa_otras_cuevas_pirenaicas',
      ],
    ),
    AfirmacionCanonica(
      id: 'representan_fauna_pleistocena',
      texto: 'Los grabados representan fauna pleistocena (bisonte, '
          'uro, ciervo, caballo).',
      calibracionCorrecta: NivelConfianza.solido,
      idsFuentesAnclaje: ['grabados_parietales_in_situ'],
    ),
    AfirmacionCanonica(
      id: 'luz_artificial',
      texto: 'Los grabados se hicieron con luz artificial — antorcha '
          'o lámpara de grasa — porque la luz natural no llega a la '
          'sala.',
      calibracionCorrecta: NivelConfianza.probable,
      idsFuentesAnclaje: ['grabados_parietales_in_situ'],
    ),
    AfirmacionCanonica(
      id: 'significado_arte_parietal',
      texto: 'Podemos determinar con la evidencia disponible el '
          'significado del arte parietal magdaleniense en general y '
          'de los grabados de esta cueva en particular.',
      calibracionCorrecta: NivelConfianza.disputado,
      idsFuentesAnclaje: [
        'grabados_parietales_in_situ',
        'comparativa_otras_cuevas_pirenaicas',
      ],
    ),
    AfirmacionCanonica(
      id: 'autores_grabados_y_covacho',
      texto: 'Quienes grabaron las paredes son las mismas personas '
          'que habitaron el covacho contiguo.',
      calibracionCorrecta: NivelConfianza.disputado,
      idsFuentesAnclaje: [
        'covacho_habitacion_carbones',
        'grabados_parietales_in_situ',
      ],
    ),
    AfirmacionCanonica(
      id: 'losas_sellaron_posteriormente',
      texto: 'Las losas que cierran parcialmente la sala fueron '
          'emplazadas en un momento posterior a los grabados.',
      calibracionCorrecta: NivelConfianza.probable,
      idsFuentesAnclaje: ['losas_selladoras_posteriores'],
    ),
  ];

  /// **Brecha 1.4 — El yacimiento de Irulegi y la Mano**. Cierre del
  /// Arco 1. Yacimiento celtibérico-vascónico tardío en el monte
  /// Irulegi (Valle de Aranguren). Pieza central: la Mano de Irulegi,
  /// lámina de bronce con inscripción en signario paleohispánico y
  /// lengua vascónica. Lección epistémica del doc 07: cómo sostener
  /// **disputada** la lectura epigráfica, cómo declarar **probable
  /// pero no determinable con la evidencia disponible** la relación
  /// lengua vascónica/euskera contemporáneo, y cómo separar
  /// "contacto" de "romanización" sin caer en falsa simetría ni
  /// minimización de la violencia. Gran Concilio con todos los
  /// revisores (Begoña, Aitor, Joana, Karim) y Marina al fondo —
  /// cierre del rango Aspirante y promoción a Aprendiz I.
  ///
  /// Habilidades ejercitadas según doc 02: ejercicio integrador del
  /// Arco 1 — todos los dominios PR/HF/CC/GH/PH/AH excepto los
  /// específicos del MVP de capas posteriores.
  ///
  /// **Yacimiento concreto validado** (header v0.2 del doc 07,
  /// tracker doc 17): Irulegi (Aranguren) es el sitio. Datación de
  /// abandono ~70 a.C. en el contexto de las guerras sertorianas.
  /// La Mano de Irulegi es objeto histórico real, descubierto en
  /// 2021 y publicado en 2022. La cartela del Museo de Navarra y
  /// el monográfico de Fontes Linguae Vasconum 136 (2023) son
  /// referencias **reales y trazables** — no se diegetizan porque
  /// son información pública verificable. El nombre del arqueólogo
  /// del yacimiento se mantiene oculto en pantalla ("el arqueólogo")
  /// por decisión explícita del guion canónico.
  static const Brecha brecha14 = Brecha(
    id: '1.4',
    titulo: 'El yacimiento de Irulegi y la Mano',
    ubicacionVisible: 'IRULEGI — POBLADO FORTIFICADO + MUSEO DE NAVARRA',
    habilidadesEjercitadas: [
      'PR.01',
      'PR.02',
      'PR.03',
      'PR.04',
      'PR.05',
      'HF.01',
      'HF.02',
      'HF.03',
      'HF.04',
      'HF.06',
      'HF.07',
      'HF.08',
      'HF.09',
      'HF.10',
      'HF.11',
      'HF.12',
      'CC.04',
      'CC.05',
      'CC.06',
      'CC.07',
      'GH.04',
      'PH.01',
      'PH.02',
      'PH.03',
      'PH.04',
      'PH.05',
      'AH.01',
      'AH.02',
      'AH.03',
      'AH.04',
      'AH.05',
      'CF.05',
      'CF.06',
    ],
    fuentes: _fuentesBrecha14,
    afirmacionesCanonicas: _afirmacionesBrecha14,
    flagDeCompletado: 'brecha_1_4_completada',
  );

  static const List<Fuente> _fuentesBrecha14 = [
    Fuente(
      id: 'casa_con_escaleras_irulegi',
      tipoVisible: 'La casa con las escaleras de piedra',
      descripcion: 'En el sector excavado del poblado, una vivienda '
          'con paredes de piedra y adobe conserva una escalera de '
          'piedra de siete peldaños hasta el umbral. Es la primera '
          'vivienda con escalera de piedra documentada en su entorno '
          'temporal y geográfico — incorporación tardía de una '
          'técnica constructiva no tradicional del Hierro local. La '
          'casa, junto al resto del poblado, fue derrumbada en el '
          'incendio que clausuró el sitio.',
      propiedadesCanonicas: PropiedadesFuente(
        tipo: TipoFuente.primaria,
        autor: 'Quienes la construyeron y la habitaron',
        fecha: 'Última fase de uso del poblado — primer cuarto del '
            's. I a.C., antes del incendio',
        publico: 'Sus habitantes',
        intereses: 'Vivir — comer, dormir, almacenar, recibir',
        omisiones: 'Cuándo exactamente se incorporó la técnica de la '
            'escalera; si la decisión fue cosmética o funcional',
        corroboraOContradice: 'Es evidencia material directa del '
            'proceso de adopción técnica vascónica tardía',
      ),
    ),
    Fuente(
      id: 'enlosado_cobertizo_colapsado',
      tipoVisible: 'El enlosado del cobertizo, colapsado',
      descripcion: 'En otra zona del poblado, el suelo de un '
          'cobertizo conserva los restos derrumbados de un pavimento '
          'de piedra plana imitando opus signinum — técnica '
          'pavimental romana. La base de preparación bajo el '
          'pavimento no estaba bien hecha y el suelo se hundió. Los '
          'restos quedaron in situ tras el colapso.',
      propiedadesCanonicas: PropiedadesFuente(
        tipo: TipoFuente.primaria,
        autor: 'Quienes intentaron construirlo, sin la maestría '
            'técnica completa',
        fecha: 'Última fase de uso del poblado',
        publico: 'Los habitantes del cobertizo',
        intereses: 'Imitar una técnica vista — eficacia o prestigio',
        omisiones: 'Quién intentó hacerlo; si fue el primer intento '
            'o uno de varios; si hubo asesoramiento de algún romano',
        corroboraOContradice: 'La adopción no era completa — el '
            'aprendizaje era parcial, las técnicas se importaban con '
            'lagunas',
      ),
    ),
    Fuente(
      id: 'ceramica_mixta_irulegi',
      tipoVisible: 'Cerámica mezclada (indígena + romana)',
      descripcion: 'En los niveles de uso de las viviendas aparecen '
          'fragmentos de cerámica indígena del Hierro tardío — la '
          'mayoría — junto con piezas de cerámica romana: paredes '
          'finas, campaniense, fragmentos de ánfora. Los dos tipos '
          'están en el mismo contexto deposicional, no en estratos '
          'separados — uso simultáneo en la mesa cotidiana.',
      propiedadesCanonicas: PropiedadesFuente(
        tipo: TipoFuente.primaria,
        autor: 'Talleres locales (la mayoría) e importaciones '
            'romanas (una parte)',
        fecha: 'Última fase de uso',
        publico: 'Los habitantes de las casas',
        intereses: 'Comer, beber, almacenar — práctico, no '
            'identitario',
        omisiones: 'Por qué canal llegaba lo romano (comercio, '
            'regalo, botín)',
        corroboraOContradice: 'Adopción cotidiana voluntaria, no '
            'imposición desde fuera',
      ),
    ),
    Fuente(
      id: 'armas_ataque_romano',
      tipoVisible: 'Armas del ataque romano sobre Irulegi',
      descripcion: 'Por todo el poblado aparecen puntas de flecha '
          'romanas, restos de espada, glandes (proyectiles de honda) '
          'con marcas de fundidor romano. Material distribuido por '
          'el sitio, asociado a los niveles de incendio. Es la '
          'evidencia material directa del episodio bélico que cerró '
          'el poblado.',
      propiedadesCanonicas: PropiedadesFuente(
        tipo: TipoFuente.primaria,
        autor: 'Las tropas atacantes',
        fecha: 'La noche o las jornadas del ataque — primer cuarto '
            'del s. I a.C.',
        publico: 'Nadie — material descartado en combate',
        intereses: 'Tomar el sitio',
        omisiones: 'Identificación específica del bando romano '
            'concreto que atacó (las guerras sertorianas son '
            'conflicto civil romano)',
        corroboraOContradice: 'Demuestra el carácter bélico del '
            'final del poblado y la implicación de tropas romanas',
      ),
    ),
    Fuente(
      id: 'mano_irulegi_pieza',
      tipoVisible: 'La Mano de Irulegi (Museo de Navarra)',
      descripcion: 'Lámina de bronce con forma de mano humana, '
          'dedos apuntando hacia abajo. Decoración en relieve y '
          'una inscripción grabada en signario paleohispánico, '
          'variante específica. Probablemente colgaba en el dintel '
          'de la puerta de la casa donde se encontró. Función '
          'ritual, probablemente apotropaica (de protección).',
      propiedadesCanonicas: PropiedadesFuente(
        tipo: TipoFuente.primaria,
        autor: 'Quienes la fabricaron y quien encargó la '
            'inscripción — sin nombre',
        fecha: 'Anterior al incendio — primera mitad del s. I a.C. '
            'o algo antes',
        publico: 'Quienes pasaban bajo el dintel donde estaba '
            'colgada',
        intereses: 'Proteger el umbral — función ritual',
        omisiones: 'Lectura epigráfica concreta; relación lengua '
            'vascónica/euskera contemporáneo',
        corroboraOContradice: 'Es la pieza que ancla la Brecha — '
            'todo lo demás la contextualiza',
      ),
    ),
    Fuente(
      id: 'cartela_museo_dos_lecturas',
      tipoVisible: 'La cartela del museo, con dos transcripciones',
      descripcion: 'La cartela junto a la vitrina recoge dos '
          'lecturas epigráficas distintas. La primera, de la '
          'publicación inicial de noviembre de 2022, fue la que '
          'circuló por la prensa. La segunda, posterior, se hizo '
          'tras una limpieza más fina de la pieza y propone una '
          'lectura corregida. Las dos no dicen lo mismo. La '
          'cartela las pone en paralelo sin ocultar la divergencia.',
      propiedadesCanonicas: PropiedadesFuente(
        tipo: TipoFuente.secundaria,
        autor: 'El equipo del Museo de Navarra y los epigrafistas '
            'que publicaron las dos lecturas',
        fecha: '2022 (lectura inicial) y posterior (lectura '
            'corregida tras limpieza)',
        publico: 'Visitantes del museo y comunidad académica',
        intereses: 'Transparencia ante el visitante — no esconder '
            'la divergencia académica',
        omisiones: 'Detalle de las objeciones técnicas a cada '
            'lectura; lecturas alternativas posteriores publicadas '
            'fuera del museo',
        corroboraOContradice: 'Hace visible que la lectura está '
            'disputada — no hay consenso establecido',
      ),
    ),
    Fuente(
      id: 'monografico_flv_136',
      tipoVisible: 'Monográfico de Fontes Linguae Vasconum 136 (2023)',
      descripcion: 'Número monográfico de la revista académica '
          'dedicado íntegramente a la Mano de Irulegi. Recoge '
          'propuestas de lectura epigráfica de varios equipos, '
          'discute paralelos en otros signarios paleohispánicos y '
          'plantea cautelas sobre la relación lengua vascónica / '
          'euskera contemporáneo. Las propuestas divergen entre '
          'sí. Publicaciones posteriores (2025) siguen proponiendo '
          'lecturas alternativas. No hay consenso académico '
          'actual.',
      propiedadesCanonicas: PropiedadesFuente(
        tipo: TipoFuente.secundaria,
        autor: 'Equipos académicos especializados en epigrafía '
            'paleohispánica y vascología',
        fecha: '2023, con publicaciones posteriores en 2025',
        publico: 'Comunidad académica',
        intereses: 'Avanzar en la lectura — sin acuerdo previo',
        omisiones: 'Lo que las propuestas no abarcan; aspectos '
            'arqueológicos del contexto de hallazgo',
        corroboraOContradice: 'Confirma que el debate sigue abierto '
            'y desplaza la afirmación clave a Disputada',
      ),
    ),
  ];

  /// Afirmaciones canónicas de la Brecha 1.4 — las 9 que Maren
  /// presenta en el gran Concilio del doc 07 §1.4.3, calibradas
  /// según el guion canónico:
  /// - 4 Sólidas (1, 2, 3, 4 + 7 → 5 Sólidas en total).
  /// - 2 Probables (5, 6).
  /// - 2 Disputadas (8, 9).
  ///
  /// Distribución diseñada para que la calibración Brier penalice
  /// tanto al que afirma de más (declarar Sólido lo que es Disputado)
  /// como al que afirma de menos (declarar Disputado lo que es
  /// Sólido). Las dos Disputadas concentran la lección epistémica
  /// del Arco 1: sostener la incertidumbre sin caer en relativismo.
  static const List<AfirmacionCanonica> _afirmacionesBrecha14 = [
    AfirmacionCanonica(
      id: 'irulegi_habitado_bronce_a_hierro_tardio',
      texto: 'El poblado de Irulegi fue habitado desde el Bronce '
          'Medio-Tardío hasta el primer tercio del siglo I a.C.',
      calibracionCorrecta: NivelConfianza.solido,
      idsFuentesAnclaje: [
        'casa_con_escaleras_irulegi',
        'ceramica_mixta_irulegi',
      ],
    ),
    AfirmacionCanonica(
      id: 'irulegi_final_belico_sertorianas',
      texto: 'El final del poblado es producto de un episodio '
          'bélico — incendio y abandono — en el contexto de las '
          'guerras sertorianas (años 70 del siglo I a.C.).',
      calibracionCorrecta: NivelConfianza.solido,
      idsFuentesAnclaje: [
        'armas_ataque_romano',
        'casa_con_escaleras_irulegi',
      ],
    ),
    AfirmacionCanonica(
      id: 'sertorianas_conflicto_civil_romano',
      texto: 'Las guerras sertorianas son conflicto civil romano. '
          'La destrucción de Irulegi no es consecuencia de una '
          'conquista exterior limpia sino de una guerra civil que '
          'arrastró a los pobladores locales.',
      calibracionCorrecta: NivelConfianza.solido,
      idsFuentesAnclaje: ['armas_ataque_romano'],
    ),
    AfirmacionCanonica(
      id: 'adopcion_tecnicas_romanas',
      texto: 'Los pobladores de Irulegi en su última fase '
          'adoptaban técnicas constructivas romanas (escaleras de '
          'piedra, intentos de enlosado) e incorporaban cerámica '
          'romana al uso cotidiano.',
      calibracionCorrecta: NivelConfianza.solido,
      idsFuentesAnclaje: [
        'casa_con_escaleras_irulegi',
        'enlosado_cobertizo_colapsado',
        'ceramica_mixta_irulegi',
      ],
    ),
    AfirmacionCanonica(
      id: 'adopcion_no_completa_aprendizaje',
      texto: 'La adopción no era completa ni perfecta. El enlosado '
          'del cobertizo colapsó por mala preparación de la base. '
          'Esto sugiere proceso de aprendizaje, no imposición.',
      calibracionCorrecta: NivelConfianza.probable,
      idsFuentesAnclaje: ['enlosado_cobertizo_colapsado'],
    ),
    AfirmacionCanonica(
      id: 'mano_funcion_apotropaica',
      texto: 'La Mano de Irulegi es objeto ritual y apotropaico, '
          'probablemente colgado en el dintel de una puerta. La '
          'función protectora se infiere por el contexto de '
          'hallazgo y por paralelos en otras culturas '
          'mediterráneas.',
      calibracionCorrecta: NivelConfianza.probable,
      idsFuentesAnclaje: ['mano_irulegi_pieza'],
    ),
    AfirmacionCanonica(
      id: 'inscripcion_en_signario_paleohispanico_lengua_vasconica',
      texto: 'La inscripción de la Mano está escrita en signario '
          'paleohispánico (variante específica) y la lengua es '
          'vascónica.',
      calibracionCorrecta: NivelConfianza.solido,
      idsFuentesAnclaje: [
        'mano_irulegi_pieza',
        'cartela_museo_dos_lecturas',
        'monografico_flv_136',
      ],
    ),
    AfirmacionCanonica(
      id: 'lectura_epigrafica_disputada',
      texto: 'La lectura epigráfica concreta del texto de la Mano '
          'es un hecho establecido del que existe consenso '
          'académico.',
      calibracionCorrecta: NivelConfianza.disputado,
      idsFuentesAnclaje: [
        'cartela_museo_dos_lecturas',
        'monografico_flv_136',
      ],
    ),
    AfirmacionCanonica(
      id: 'relacion_vasconica_euskera_determinable',
      texto: 'La relación entre la lengua vascónica documentada '
          'en la Mano y el euskera contemporáneo se puede '
          'determinar con la evidencia disponible.',
      calibracionCorrecta: NivelConfianza.disputado,
      idsFuentesAnclaje: [
        'mano_irulegi_pieza',
        'monografico_flv_136',
      ],
    ),
  ];

  /// Lista ordenada de todas las Brechas catalogadas. El orquestador
  /// la consulta para resolver `brechaPendiente()` igual que
  /// `EscenasArco1.todas` resuelve la próxima cinemática.
  /// **Brecha 2.1 — Pompaelo bajo Iruña** (Arco 2, primera Estación).
  /// Maren investiga una inscripción honorífica romana mutilada
  /// hallada en una galería técnica bajo la calle Curia. La pedagogía
  /// del oficio cambia respecto al Arco 1: ya no se trata de leer
  /// objetos arqueológicos sin texto, sino de leer una fuente
  /// **textual con propaganda**. Karim Belkacem (epigrafista del
  /// Archivo) le enseña convenciones epigráficas (mayúsculas
  /// latinas, abreviaturas IMP/CAES/AVG, fórmulas honoríficas,
  /// dedicantes) y la postura epistémica clave del arco: una
  /// inscripción NO es un documento neutral — es propaganda. El
  /// productor pagó para que se viera lo que se ve. Lo que no le
  /// interesaba al dedicante no aparece; lo que sí, aparece exagerado.
  ///
  /// Habilidades ejercitadas según doc 02:
  /// - PR.01, PR.02 — formulación de preguntas críticas.
  /// - HF.01-07 + HF.09 — análisis de fuente textual con sesgo del
  ///   productor. (HF.08 corroboración cruzada no aplica: es una
  ///   sola inscripción mutilada, no se cruza con otra del mismo
  ///   evento — los paralelos son comparativos, no corroboradores
  ///   directos.)
  /// - CC.04 — cronología relativa por convenciones epigráficas
  ///   (datación por nomenclatura imperial y formulario).
  /// - AH.01-03 — argumentación + calibración Brier (P4 en AH.03).
  ///
  /// **Catálogo amplio**: 5 fuentes y **6 afirmaciones canónicas**
  /// (vs. las 4 de las Brechas del Arco 1). Mínimo de afirmaciones
  /// para ir al Concilio: 4 (parametrizable desde F2-9 con
  /// `minimoAfirmacionesParaConcilio`). Las afirmaciones se
  /// distribuyen 2 Sólidas + 2 Probables + 2 Disputadas — la
  /// pedagogía de la Estación es justamente que en una fuente
  /// textual con propaganda **el oficio honesto declara muchas
  /// Disputado y Probable, no muchas Sólido**. Sostener tres
  /// declaraciones de Sólido aquí sería sobreconfianza.
  ///
  /// **Las cinco fuentes son explícitamente ficticias y diegéticas**:
  /// - La inscripción en sí es modelo literario verosímil basado en
  ///   formularios honoríficos romanos genéricos, sin reproducir
  ///   ninguna inscripción real catalogada en CIL II o Hispania
  ///   Epigraphica.
  /// - El "Licinio cónsul" honrado es figura ficticia diegética; la
  ///   *gens Licinia* sí es real y produjo cónsules a lo largo del
  ///   Imperio (la pedagogía sostiene la verosimilitud).
  /// - La PIR (*Prosopographia Imperii Romani*) sí es herramienta
  ///   real y trazable — se cita por su nombre canónico sin afirmar
  ///   entradas concretas.
  ///
  /// Ver `BLOQUEOS-PENDIENTES.md` para el detalle de sustituciones.
  static const Brecha brecha21 = Brecha(
    id: '2.1',
    titulo: 'La inscripción de Licinio',
    ubicacionVisible: 'IRUÑA — POMPAELO SUBTERRÁNEA',
    habilidadesEjercitadas: [
      'PR.01',
      'PR.02',
      'HF.01',
      'HF.02',
      'HF.03',
      'HF.04',
      'HF.05',
      'HF.06',
      'HF.07',
      'HF.09',
      'CC.04',
      'AH.01',
      'AH.02',
      'AH.03',
    ],
    fuentes: _fuentesBrecha21,
    afirmacionesCanonicas: _afirmacionesBrecha21,
    flagDeCompletado: 'brecha_2_1_completada',
    minimoAfirmacionesParaConcilio: 4,
  );

  static const List<Fuente> _fuentesBrecha21 = [
    Fuente(
      id: 'inscripcion_in_situ',
      tipoVisible: 'La inscripción honorífica completa, in situ',
      descripcion:
          'Bloque calizo rectangular reutilizado como pavimento en una '
          'galería técnica bajo la calle Curia. Inscripción en cuatro '
          'líneas en mayúsculas romanas. La superficie está pulida, '
          'el grabado profundo, las letras de buena factura. La cuarta '
          'línea está mutilada: queda DEDICAVIT EX V[...] y el resto '
          'se perdió cuando el bloque fue cortado para cubrir el '
          'acueducto.',
      propiedadesCanonicas: PropiedadesFuente(
        tipo: TipoFuente.primaria,
        autor: 'El dedicante anónimo (cuya identidad la línea perdida '
            'borró)',
        fecha: 'Probablemente s. I-III d.C. por convenciones '
            'epigráficas; con detalle posible época trajanea por '
            'nomenclatura imperial',
        publico: 'Las personas que circulaban por el lugar público '
            'de Pompaelo donde la inscripción estaba originalmente '
            'expuesta',
        intereses: 'Que el honrado quedara registrado en piedra ante '
            'la comunidad',
        omisiones: 'No dice quién pagó, no dice por qué se honra '
            'aquí en Pompaelo, no dice qué relación tenía el '
            'dedicante con el honrado',
        corroboraOContradice: 'Es la fuente principal — todo lo demás '
            'la interpreta',
        sesgo: SesgoFuente.oficialista,
      ),
    ),
    Fuente(
      id: 'linea_dedicacion_perdida',
      tipoVisible: 'La línea perdida: DEDICAVIT EX V[...]',
      descripcion:
          'La cuarta línea de la inscripción quedó cortada cuando el '
          'bloque se reutilizó. Sólo se conservan las primeras '
          'letras: DEDICAVIT EX V (luego se rompe). La fórmula '
          'DEDICAVIT EX seguida de un sustantivo (VOTO, VIRIBUS, '
          'VOLVNTATE) es estándar; el dedicante venía después, en '
          'la línea perdida.',
      propiedadesCanonicas: PropiedadesFuente(
        tipo: TipoFuente.primaria,
        autor: 'El propio dedicante (la línea era suya por convención)',
        fecha: 'Misma que la inscripción completa',
        publico: 'Mismo',
        intereses: 'El dedicante quería identificarse — la pérdida '
            'es accidental, no intencional',
        omisiones: 'Por la mutilación, la identidad del dedicante '
            'queda borrada — no por silencio del productor sino por '
            'azar histórico',
        corroboraOContradice: 'No corrobora ni contradice por sí sola '
            '— fija sólo que hubo dedicación voluntaria',
      ),
    ),
    Fuente(
      id: 'paralelos_epigraficos_pompaelo',
      tipoVisible: 'Repertorio de inscripciones de Pompaelo del '
          'mismo periodo',
      descripcion:
          'Karim ha compilado para esta Brecha un dossier con cinco '
          'inscripciones honoríficas y funerarias halladas en el '
          'área de Pompaelo, fechadas en el rango s. I-III d.C. Sirve '
          'para comparar formularios, calidad del grabado y patrones '
          'de uso del espacio público. Ninguna nombra al "Licinio '
          'cónsul" ni al dedicante perdido.',
      propiedadesCanonicas: PropiedadesFuente(
        tipo: TipoFuente.secundaria,
        autor: 'Compilado por Karim Belkacem para la Brecha',
        fecha: 'Compilación reciente; las inscripciones son del s. '
            'I-III d.C.',
        publico: 'Aprendices del Archivo trabajando en epigrafía',
        intereses: 'Pedagógicos — proveer paralelos para que la '
            'aprendiz contextualice',
        omisiones: 'No incluye paralelos fuera de Pompaelo (lo cual '
            'limita comparaciones de redes provinciales)',
        corroboraOContradice: 'Corrobora que el formulario y la '
            'calidad de la inscripción de Licinio encajan con la '
            'práctica epigráfica local del periodo',
      ),
    ),
    Fuente(
      id: 'pir_repertorio',
      tipoVisible: 'PIR — Prosopographia Imperii Romani',
      descripcion:
          'Repertorio canónico de personas conocidas del Imperio '
          'Romano. Incluye todos los cónsules con su nomen, cognomen, '
          'datación y referencias bibliográficas. Karim instruye a '
          'Maren para buscar Licinios cónsules de época trajanea. '
          'El repertorio devuelve dos candidatos posibles, uno más '
          'compatible que otro con la mutilación de la inscripción.',
      propiedadesCanonicas: PropiedadesFuente(
        tipo: TipoFuente.secundaria,
        autor: 'Académicos de la prosopografía romana, varias '
            'generaciones',
        fecha: 'Compilación con actualizaciones desde el s. XIX',
        publico: 'Especialistas en historia romana',
        intereses: 'Construir un repertorio exhaustivo y trazable',
        omisiones: 'No nombra personas que no llegaron al rango '
            'consular ni dedicantes anónimos — herramienta para una '
            'élite',
        corroboraOContradice: 'Permite afinar la datación trajanea '
            'de la inscripción al cruzar con candidatos consulares '
            'documentados',
      ),
    ),
    Fuente(
      id: 'paralelos_inscripciones_capital',
      tipoVisible: 'Inscripciones honoríficas similares conservadas '
          'en Roma',
      descripcion:
          'Selección comparativa de tres inscripciones honoríficas '
          'romanas dedicadas a senadores y cónsules en Roma misma. '
          'Permite contrastar el formulario de Pompaelo con el del '
          'centro del Imperio: en general las urbanas son más largas '
          'y elaboradas; las provinciales como la de Pompaelo son '
          'más concisas y reciclan fórmulas estándar.',
      propiedadesCanonicas: PropiedadesFuente(
        tipo: TipoFuente.secundaria,
        autor: 'Compilación académica',
        fecha: 'Inscripciones del s. I-III d.C.',
        publico: 'Investigadores de epigrafía romana',
        intereses: 'Análisis comparativo del lenguaje honorífico',
        omisiones: 'Por sesgo tradicional, los dedicantes no '
            'élites están infrarepresentados (lo cual también '
            'afecta a esta comparación con Pompaelo)',
        corroboraOContradice: 'Sugiere que la inscripción de Pompaelo '
            'sigue convención provincial pero no permite afirmar el '
            'vínculo del honrado con la ciudad',
        sesgo: SesgoFuente.invisibilizador,
      ),
    ),
  ];

  static const List<AfirmacionCanonica> _afirmacionesBrecha21 = [
    AfirmacionCanonica(
      id: 'tipo_honorifica',
      texto: 'La inscripción es honorífica — no funeraria, no votiva. '
          'Honra a una persona viva (o recién fallecida sin contexto '
          'funerario) en un lugar público.',
      calibracionCorrecta: NivelConfianza.solido,
      idsFuentesAnclaje: [
        'inscripcion_in_situ',
        'paralelos_epigraficos_pompaelo',
      ],
    ),
    AfirmacionCanonica(
      id: 'siglo_inscripcion_amplio',
      texto: 'La inscripción es datable, por sus características '
          'epigráficas (forma de las letras, formulario, '
          'abreviaturas), entre los siglos I y III d.C.',
      calibracionCorrecta: NivelConfianza.solido,
      idsFuentesAnclaje: [
        'inscripcion_in_situ',
        'paralelos_epigraficos_pompaelo',
      ],
    ),
    AfirmacionCanonica(
      id: 'datacion_trajanea',
      texto: 'La inscripción puede datarse, con mayor precisión, en '
          'época trajanea (98-117 d.C.) por la nomenclatura imperial '
          'y el cruce con candidatos en la PIR.',
      calibracionCorrecta: NivelConfianza.probable,
      idsFuentesAnclaje: [
        'inscripcion_in_situ',
        'pir_repertorio',
      ],
    ),
    AfirmacionCanonica(
      id: 'licinio_consul',
      texto: 'El honrado fue un cónsul perteneciente a la gens '
          'Licinia, identificable con uno o dos candidatos '
          'compatibles en la PIR.',
      calibracionCorrecta: NivelConfianza.probable,
      idsFuentesAnclaje: [
        'inscripcion_in_situ',
        'pir_repertorio',
      ],
    ),
    AfirmacionCanonica(
      id: 'identidad_dedicante',
      texto: 'Se puede determinar quién pagó la inscripción '
          '— si fue la propia ciudad de Pompaelo a través de su '
          'senado local, un cliente, un liberto, un colega, un '
          'familiar.',
      calibracionCorrecta: NivelConfianza.disputado,
      idsFuentesAnclaje: ['linea_dedicacion_perdida'],
    ),
    AfirmacionCanonica(
      id: 'vinculo_pompaelo_honrado',
      texto: 'Se puede determinar por qué esta inscripción está aquí '
          'en Pompaelo y no en Roma — qué vínculo concreto tenía el '
          'honrado con la ciudad.',
      calibracionCorrecta: NivelConfianza.disputado,
      idsFuentesAnclaje: [
        'inscripcion_in_situ',
        'paralelos_inscripciones_capital',
      ],
    ),
  ];

  /// **Brecha 2.2 — Quintiliano de Calagurris** (Arco 2, segunda
  /// Estación). Maren viaja a Calahorra con Isaura y trabaja en el
  /// museo local con una arqueóloga que avisó Karim. La Brecha gira
  /// alrededor de la *Institutio Oratoria* y de lo que Quintiliano
  /// **omite** sobre Calagurris, sus padres, su infancia y su
  /// trayectoria pre-romana. La pedagogía clave del arco se
  /// inaugura aquí: la habilidad **HF.10 detección de omisiones**
  /// (que más tarde se eleva a corazón epistémico del arco con la
  /// Estación 2.4 sobre Wamba). Maren sale con la lección de
  /// Isaura sobre identidades sucesivas: *"Calagurris fue
  /// Calagurris. Después fue navarra. Después dejó de serlo.
  /// Quintiliano fue de aquí. Después no."*
  ///
  /// Habilidades ejercitadas según doc 02:
  /// - PR.01-04 — formulación de preguntas de profundidad sobre
  ///   omisiones.
  /// - HF.05 — lectura crítica de fuentes textuales.
  /// - HF.07 — qué se omite (núcleo de la Brecha).
  /// - HF.09 — detección de sesgos.
  /// - HF.10 — detección de omisiones (debut jugable).
  /// - PH.01 — no presentismo (al leer la identidad cultural de
  ///   Quintiliano sin proyectar la nuestra).
  /// - AH.01-03 — argumentación + calibración Brier.
  ///
  /// **Catálogo amplio**: 4 fuentes y **7 afirmaciones canónicas**.
  /// Distribución pedagógica 4 Sólido + 1 Probable + 2 Disputado:
  /// la *Institutio* es texto rico en datos directos sobre
  /// Quintiliano cuando habla, así que las afirmaciones positivas
  /// son sólidas. Lo que la Brecha enseña es declarar **Probable**
  /// la inferencia de identidad cultural basada en omisiones
  /// (las omisiones son evidencia más débil que las afirmaciones,
  /// como dice Aitor por videollamada en 2.2.5) y **Disputado** lo
  /// que las omisiones permiten múltiples explicaciones.
  ///
  /// `minimoAfirmacionesParaConcilio: 5` — declarar al menos 5 de
  /// 7 marca un mínimo significativo (no se puede ir al Concilio
  /// sin tocar al menos una de las inferencias sobre omisiones).
  ///
  /// **Material trazable preservado**:
  /// - Quintiliano de Calagurris, la *Institutio Oratoria* y los
  ///   prefacios de los libros I/II/IV/VI son referencias reales y
  ///   trazables en bibliografía estándar (edición Cousin / Les
  ///   Belles Lettres).
  /// - Vitorio Marcelo (patrono de Quintiliano según el prefacio
  ///   del libro IV de la *Institutio*) es real.
  /// - 1076 (frontera de Calagurris/Calahorra entre Navarra y
  ///   Castilla/Rioja) es fecha trazable.
  ///
  /// **Sustituciones diegéticas**: el yacimiento romano de
  /// Calahorra, el museo local y la arqueóloga (sin nombre en
  /// pantalla) son dispositivos narrativos. La sala dedicada a
  /// Quintiliano en el museo y los fragmentos cerámicos del barrio
  /// donde se cree que vivió son verosímiles para Calahorra pero
  /// no se afirman piezas concretas catalogadas. Ver
  /// `BLOQUEOS-PENDIENTES.md`.
  static const Brecha brecha22 = Brecha(
    id: '2.2',
    titulo: 'Quintiliano de Calagurris',
    ubicacionVisible: 'CALAHORRA — MUSEO ROMANO',
    habilidadesEjercitadas: [
      'PR.01',
      'PR.02',
      'PR.03',
      'PR.04',
      'HF.05',
      'HF.07',
      'HF.09',
      'HF.10',
      'PH.01',
      'AH.01',
      'AH.02',
      'AH.03',
    ],
    fuentes: _fuentesBrecha22,
    afirmacionesCanonicas: _afirmacionesBrecha22,
    flagDeCompletado: 'brecha_2_2_completada',
    minimoAfirmacionesParaConcilio: 5,
  );

  static const List<Fuente> _fuentesBrecha22 = [
    Fuente(
      id: 'institutio_oratoria_pasajes',
      tipoVisible: 'Pasajes seleccionados de la Institutio Oratoria',
      descripcion:
          'Cuatro pasajes traducidos al castellano, fotocopiados por '
          'la arqueóloga local y aportados por Maren con los dos '
          'volúmenes que su padre le prestó. Pasaje A: prooemium del '
          'libro I, Quintiliano habla de su retirada tras años de '
          'enseñanza. Pasaje B: libro II, mención breve a su llegada '
          'a Roma. Pasaje C: prefacio del libro IV, dedicatoria a su '
          'patrón Vitorio Marcelo. Pasaje D: prefacio del libro VI, '
          'lamento por la muerte de su hijo.',
      propiedadesCanonicas: PropiedadesFuente(
        tipo: TipoFuente.primaria,
        autor: 'Marco Fabio Quintiliano',
        fecha: 'En torno a 95 d.C., cuarenta años después de salir '
            'de Calagurris',
        publico: 'Élite intelectual romana — maestros de retórica, '
            'oradores, jóvenes en formación',
        intereses: 'Sistematizar la formación retórica para uso '
            'profesional; honrar al patrón',
        omisiones: 'No describe Calagurris, no nombra a sus padres, '
            'no habla de su infancia ni de las razones de su salida '
            'de Hispania',
        corroboraOContradice: 'Es la fuente principal — el resto del '
            'catálogo la contextualiza',
        sesgo: SesgoFuente.invisibilizador,
      ),
    ),
    Fuente(
      id: 'yacimiento_calagurris',
      tipoVisible: 'Yacimiento romano de Calahorra y sala del museo',
      descripcion:
          'Foro romano parcialmente conservado, restos de termas, '
          'cimientos. Calahorra moderna construida encima de manera '
          'paralela a Iruña sobre Pompaelo. En el museo local hay '
          'una sala dedicada a Quintiliano: una estatua moderna, '
          'una placa, fragmentos cerámicos del barrio donde se cree '
          'que vivió.',
      propiedadesCanonicas: PropiedadesFuente(
        tipo: TipoFuente.primaria,
        autor: 'Las personas que vivieron y construyeron Calagurris '
            'romana',
        fecha: 'Romano altoimperial (s. I-II d.C.)',
        publico: 'En su origen: la propia comunidad de Calagurris. '
            'Hoy: visitantes del museo',
        intereses: 'Útiles cotidianos, infraestructura urbana, '
            'representación cívica',
        omisiones: 'No hay restos directamente atribuibles a la '
            'familia de Quintiliano; "el barrio donde se cree que '
            'vivió" es atribución académica, no certeza',
        corroboraOContradice: 'Corrobora que Calagurris era ciudad '
            'romana de cierta entidad en la época formativa de '
            'Quintiliano',
      ),
    ),
    Fuente(
      id: 'comparacion_calagurris_pompaelo',
      tipoVisible: 'Comparación con Pompaelo',
      descripcion:
          'Maren ya conoce Pompaelo bajo Iruña por la Brecha 2.1. La '
          'arqueóloga señala el paralelo: Calahorra moderna sobre '
          'Calagurris romana funciona como Iruña sobre Pompaelo — '
          'misma lógica de superposición urbana, ambas en la red '
          'de ciudades romanas del valle del Ebro y el Pirineo '
          'occidental.',
      propiedadesCanonicas: PropiedadesFuente(
        tipo: TipoFuente.secundaria,
        autor: 'Tradición arqueológica académica',
        fecha: 'Conocimiento construido a lo largo del s. XX',
        publico: 'Investigadores y aprendices del oficio',
        intereses: 'Establecer marcos comparativos para entender '
            'la red urbana romana provincial',
        omisiones: 'La comparación urbana no dice nada sobre '
            'identidades culturales individuales como la de '
            'Quintiliano',
        corroboraOContradice: 'Sostiene que Calagurris era ciudad '
            'romana plenamente integrada — coherente con que un '
            'hijo suyo educado pudiera marcharse a Roma',
      ),
    ),
    Fuente(
      id: 'testimonio_arqueologa_local',
      tipoVisible: 'Testimonio oral de la arqueóloga local',
      descripcion:
          'La arqueóloga del museo de Calahorra (sin nombre en '
          'pantalla, doc 08 §2.2.2) aporta a Maren una observación '
          'clave durante el trabajo de mesa: "Cuando escribe la '
          'Institutio, ya no estaba aquí. Llevaba cuarenta años en '
          'Roma. Es probable que cuando escribe ya no se sintiera '
          'de aquí." Voz de territorio cercana, técnica pero '
          'accesible, sin protocolo del Archivo.',
      propiedadesCanonicas: PropiedadesFuente(
        tipo: TipoFuente.secundaria,
        autor: 'Arqueóloga del museo de Calahorra',
        fecha: 'Comentario contemporáneo, fundado en bibliografía '
            'académica de la última década',
        publico: 'Aprendiz del Archivo de Iruña en visita',
        intereses: 'Pedagógicos — facilitar la lectura de la fuente '
            'textual con contexto biográfico y cultural',
        omisiones: 'No cita bibliografía concreta en el momento; el '
            'apoyo académico de la observación queda implícito',
        corroboraOContradice: 'Aporta un marco interpretativo para '
            'declarar Probable la identidad romana predominante de '
            'Quintiliano cuando escribe',
      ),
    ),
  ];

  static const List<AfirmacionCanonica> _afirmacionesBrecha22 = [
    AfirmacionCanonica(
      id: 'origen_calagurris',
      texto: 'Quintiliano fue originario de Calagurris (Calahorra '
          'romana), una ciudad romana plenamente integrada del valle '
          'del Ebro.',
      calibracionCorrecta: NivelConfianza.solido,
      idsFuentesAnclaje: [
        'institutio_oratoria_pasajes',
        'yacimiento_calagurris',
      ],
    ),
    AfirmacionCanonica(
      id: 'maestro_retorica_roma',
      texto: 'Quintiliano fue maestro profesional de retórica en '
          'Roma durante varias décadas hasta retirarse para '
          'escribir la Institutio Oratoria.',
      calibracionCorrecta: NivelConfianza.solido,
      idsFuentesAnclaje: ['institutio_oratoria_pasajes'],
    ),
    AfirmacionCanonica(
      id: 'patron_vitorio_marcelo',
      texto: 'Quintiliano dedicó parte de la Institutio a su patrón '
          'Vitorio Marcelo (mencionado nominalmente en el prefacio '
          'del libro IV).',
      calibracionCorrecta: NivelConfianza.solido,
      idsFuentesAnclaje: ['institutio_oratoria_pasajes'],
    ),
    AfirmacionCanonica(
      id: 'autoridad_pedagogica_io',
      texto: 'La Institutio Oratoria es fuente fiable sobre las '
          'prácticas pedagógicas retóricas de la élite romana de '
          'fines del s. I d.C.',
      calibracionCorrecta: NivelConfianza.solido,
      idsFuentesAnclaje: [
        'institutio_oratoria_pasajes',
        'comparacion_calagurris_pompaelo',
      ],
    ),
    AfirmacionCanonica(
      id: 'identidad_romana_predominante',
      texto: 'Cuando Quintiliano escribe la Institutio (cuarenta '
          'años después de salir de Calagurris), su identidad '
          'cultural predominante es la romana, no la hispana '
          'provincial.',
      calibracionCorrecta: NivelConfianza.probable,
      idsFuentesAnclaje: [
        'institutio_oratoria_pasajes',
        'testimonio_arqueologa_local',
      ],
    ),
    AfirmacionCanonica(
      id: 'razones_omision_calagurris',
      texto: 'Se pueden determinar las razones específicas por las '
          'que Quintiliano omite información sobre Calagurris en '
          'la Institutio (público romano sin interés, preferencia '
          'identitaria personal, convención del género).',
      calibracionCorrecta: NivelConfianza.disputado,
      idsFuentesAnclaje: ['institutio_oratoria_pasajes'],
    ),
    AfirmacionCanonica(
      id: 'peso_calagurris_formacion',
      texto: 'Se puede determinar el peso real que Calagurris '
          '(lugar e infancia) tuvo en la formación intelectual y '
          'pedagógica de Quintiliano.',
      calibracionCorrecta: NivelConfianza.disputado,
      idsFuentesAnclaje: [
        'institutio_oratoria_pasajes',
        'yacimiento_calagurris',
      ],
    ),
  ];

  /// **Brecha 2.3 — La domus de los mosaicos** (Iruña, domus
  /// subterránea). Tercera Brecha jugable del Arco 2. Se interpone
  /// entre la cinemática 2.3.4 *Comprender sin justificar* (que cierra
  /// la lección epistémica de Isaura sobre la diferencia entre
  /// neutralidad y comprensión) y la 2.3.5 *Reconstrucción* (que
  /// reproduce narrativamente las 8 afirmaciones que Maren produce en
  /// la mesa). La Brecha es donde Maren declara con calibración Brier;
  /// la 2.3.5 cinemática es la puesta en limpio narrativa.
  ///
  /// Habilidades ejercitadas según doc 02:
  /// - PR.01-04 — formulación crítica de preguntas.
  /// - HF.05/07/09/10 — análisis de fuentes oficialista/silencios
  ///   y detección de omisiones (la afirmación 6 *"Sólido (la
  ///   ausencia)"* es **HF.10 declarada explícitamente como
  ///   conocimiento positivo**).
  /// - PH.01 — no presentismo. PH.08 — comprender sin justificar
  ///   (la lección clave de Isaura en 2.3.4 que la Brecha pone en
  ///   ejercicio jugable).
  /// - AH.01-03 — argumentación + calibración (incluida la AH.03
  ///   particular de declarar Sólido (la ausencia) como afirmación
  ///   positiva sobre el silencio documental).
  ///
  /// **Catálogo amplio (8 afirmaciones canónicas + 4 fuentes diegéticas)
  /// con `minimoAfirmacionesParaConcilio: 6`**: la pedagogía pide al
  /// menos 6 de 8 declaradas para que el jugador no pueda escapar
  /// declarando sólo las 5 Sólido del catálogo (sin tocar la 6 *Sólido
  /// (la ausencia)* — que es Sólido pero pedagógicamente la afirmación
  /// central — ni las 2 Probable, ni la 1 Disputado).
  ///
  /// **Distribución pedagógica 5 Sólido + 2 Probable + 1 Disputado**:
  /// la pedagogía de la Estación 2.3 es que cuando la fuente es rica
  /// para la élite que la produce y silenciosa para las personas que
  /// sostienen su mundo material, **la ausencia es información** —
  /// declararla como Sólido (la ausencia) es la operación clave del
  /// oficio. Las 5 Sólido cubren propiedad, propietario, número de
  /// esclavizados, **el silencio sobre sus identidades**, y mosaico
  /// fechado. Las 2 Probable cubren el nombre incompleto de la esposa
  /// y la vida cotidiana inferida de domus análogas. La 1 Disputado
  /// cubre la existencia de hijos no documentados directamente.
  ///
  /// **El matiz "Sólido (la ausencia)"**: vive en el `texto` de la
  /// `AfirmacionCanonica` correspondiente, NO como nivel nuevo del
  /// enum `NivelConfianza`. El jugador declara `NivelConfianza.solido`
  /// que es la calibración correcta (la ausencia documentada **es**
  /// Sólido); el matiz pedagógico ("la ausencia es información, no
  /// olvido neutro") es contenido textual de la afirmación que la
  /// pantalla muestra y el Concilio comenta — sin que el motor Brier
  /// lo interprete. Preserva la paridad Dart/PHP del core.
  ///
  /// **Las 4 fuentes son explícitamente ficticias diegéticas**: la
  /// familia Cornelia y el "Cornelio magistrado" son figuras
  /// ficticias del juego (la *gens Cornelia* es real pero el
  /// magistrado concreto no se identifica con un Cornelio histórico).
  /// La domus subterránea bajo Iruña es modelo literario verosímil
  /// basado en domus romanas conocidas en yacimientos hispanorromanos
  /// (Mérida, Itálica, Empúries) — no una domus catalogada real.
  /// Registro completo en BLOQUEOS-PENDIENTES.md.
  static const Brecha brecha23 = Brecha(
    id: '2.3',
    titulo: 'La domus de los mosaicos',
    ubicacionVisible: 'IRUÑA — DOMUS SUBTERRÁNEA',
    habilidadesEjercitadas: [
      'PR.01',
      'PR.02',
      'PR.03',
      'PR.04',
      'HF.05',
      'HF.07',
      'HF.09',
      'HF.10',
      'PH.01',
      'PH.08',
      'AH.01',
      'AH.02',
      'AH.03',
    ],
    fuentes: _fuentesBrecha23,
    afirmacionesCanonicas: _afirmacionesBrecha23,
    flagDeCompletado: 'brecha_2_3_completada',
    minimoAfirmacionesParaConcilio: 6,
  );

  static const List<Fuente> _fuentesBrecha23 = [
    Fuente(
      id: 'inscripcion_propietario_cornelio',
      tipoVisible: 'Inscripción honorífica del propietario',
      descripcion:
          'Bloque tallado hallado en el atrio de la domus, parcialmente '
          'reutilizado como peldaño. Honra a un Cornelio (praenomen '
          'perdido en la mutilación), magistrado local, mediados del '
          'siglo II d.C. Identifica al propietario y su estatus cívico, '
          'pero no nombra a la familia entera ni a las personas que '
          'sostenían la casa.',
      propiedadesCanonicas: PropiedadesFuente(
        tipo: TipoFuente.primaria,
        autor: 'Cliente o asociación cívica que costeó el homenaje',
        fecha: 'Mediados del siglo II d.C.',
        publico: 'La élite cívica local — quienes leían inscripciones '
            'honoríficas en el atrio de una domus visitable',
        intereses: 'Reforzar el prestigio público del propietario y su '
            'pertenencia a la red de magistrados locales',
        omisiones: 'Familia, esposa, hijos y especialmente las personas '
            'esclavizadas que sostenían la casa quedan fuera del registro '
            'epigráfico — sólo aparece el cabeza de familia varón con '
            'cargo público',
        corroboraOContradice: 'Es la fuente más sólida sobre el '
            'propietario y la datación de su residencia; nada dice de '
            'quienes la hacían funcionar',
        sesgo: SesgoFuente.oficialista,
      ),
    ),
    Fuente(
      id: 'tablilla_cuentas_domesticas',
      tipoVisible: 'Tablilla con cuentas domésticas',
      descripcion:
          'Fragmento de tablilla recuperado en el archivo doméstico de '
          'la domus. Compras y ventas, gastos de despensa, encargos al '
          'mercado, asignaciones para el horno y el pozo. Las personas '
          'esclavizadas aparecen como número en la columna de raciones: '
          '"servis II" — dos siervos, sin nombre. Su existencia está '
          'documentada de forma seca y administrativa; su vida concreta '
          'no.',
      propiedadesCanonicas: PropiedadesFuente(
        tipo: TipoFuente.primaria,
        autor: 'El administrador doméstico de la familia Cornelia '
            '(probablemente liberto)',
        fecha: 'A lo largo de los siglos II-III d.C., posiblemente '
            'varias manos sucesivas',
        publico: 'Uso interno de la casa — registro económico para '
            'el cabeza de familia',
        intereses: 'Llevar las cuentas con eficiencia administrativa, '
            'no preservar identidades',
        omisiones: 'Los nombres de las personas esclavizadas. Las '
            'cuentas las reducen a categoría laboral y unidad de '
            'consumo. Esa omisión no es accidente: es la lógica del '
            'documento',
        corroboraOContradice: 'Documenta la existencia de al menos dos '
            'personas esclavizadas y la rutina material de la casa; '
            'silencia toda subjetividad de quienes la sostenían',
        sesgo: SesgoFuente.invisibilizador,
      ),
    ),
    Fuente(
      id: 'restos_materiales_domus',
      tipoVisible: 'Restos materiales del yacimiento',
      descripcion:
          'Cerámica de cocina, herramientas de hierro, fragmentos óseos '
          'animales (residuos de comidas), pavimentos, restos de '
          'combustión en el horno, mosaico geométrico añadido a fines '
          'del siglo II. Evidencia material directa de cómo funcionaba '
          'la casa — sin nombres asociados.',
      propiedadesCanonicas: PropiedadesFuente(
        tipo: TipoFuente.primaria,
        autor: 'Las personas que vivieron, trabajaron y sostuvieron '
            'la domus a lo largo de doscientos años',
        fecha: 'Siglos II-III d.C.',
        publico: 'En su origen: uso doméstico cotidiano. Hoy: la '
            'arqueología contemporánea',
        intereses: 'Cocinar, comer, calentar, decorar, vivir — sin '
            'intención historiográfica',
        omisiones: 'La materialidad no nombra a nadie. El horno '
            'funcionó cada día, alguien lo encendió cada mañana; la '
            'evidencia material es muda sobre identidades',
        corroboraOContradice: 'Sólida para fechar el mosaico, '
            'caracterizar la dieta y el equipamiento; muda sobre '
            'identidades de quienes hacían funcionar la casa',
      ),
    ),
    Fuente(
      id: 'comparacion_domus_analogas',
      tipoVisible: 'Comparación con domus análogas',
      descripcion:
          'Repertorio académico de domus hispanorromanas mejor '
          'documentadas (paralelos en yacimientos peninsulares con '
          'archivos domésticos más completos). Permite inferir '
          'proporciones razonables de personal doméstico, distribución '
          'de tareas, ritmo de la casa — siempre como referencia '
          'comparativa, nunca como afirmación directa sobre la domus '
          'concreta.',
      propiedadesCanonicas: PropiedadesFuente(
        tipo: TipoFuente.secundaria,
        autor: 'Tradición arqueológica académica de la segunda mitad '
            'del s. XX',
        fecha: 'Conocimiento construido en publicaciones de las '
            'últimas décadas',
        publico: 'Investigadores y aprendices del oficio',
        intereses: 'Establecer marcos comparativos para reconstruir '
            'lo que las fuentes locales no documentan',
        omisiones: 'La comparación promedia patrones; las '
            'particularidades de cada domus quedan diluidas. No '
            'devuelve nombres a las personas no nombradas',
        corroboraOContradice: 'Sostiene como Probable la vida '
            'cotidiana inferida de patrones análogos, pero no permite '
            'afirmaciones Sólido sobre la domus concreta',
      ),
    ),
  ];

  static const List<AfirmacionCanonica> _afirmacionesBrecha23 = [
    AfirmacionCanonica(
      id: 'residencia_familia_cornelia',
      texto: 'La domus fue residencia de la familia Cornelia desde '
          'mediados del siglo II hasta finales del siglo III d.C.',
      calibracionCorrecta: NivelConfianza.solido,
      idsFuentesAnclaje: [
        'inscripcion_propietario_cornelio',
        'restos_materiales_domus',
      ],
    ),
    AfirmacionCanonica(
      id: 'propietario_cornelio_magistrado',
      texto: 'El propietario principal fue un Cornelio (praenomen '
          'perdido en la mutilación de la inscripción), magistrado '
          'local con cargo cívico documentado.',
      calibracionCorrecta: NivelConfianza.solido,
      idsFuentesAnclaje: ['inscripcion_propietario_cornelio'],
    ),
    AfirmacionCanonica(
      id: 'esposa_nombre_incompleto',
      texto: 'Su esposa aparece mencionada en una sola fuente con un '
          'nombre del que sólo se conserva un fragmento (lectura '
          'incompleta).',
      calibracionCorrecta: NivelConfianza.probable,
      idsFuentesAnclaje: ['inscripcion_propietario_cornelio'],
    ),
    AfirmacionCanonica(
      id: 'existencia_hijos',
      texto: 'Los hijos del propietario no aparecen documentados '
          'directamente en las fuentes conservadas. Disputado si los '
          'tuvo o no, aunque la edad y posición social hacen Probable '
          'que sí.',
      calibracionCorrecta: NivelConfianza.disputado,
      idsFuentesAnclaje: [
        'inscripcion_propietario_cornelio',
        'comparacion_domus_analogas',
      ],
    ),
    AfirmacionCanonica(
      id: 'al_menos_dos_personas_esclavizadas',
      texto: 'La casa empleaba al menos dos personas esclavizadas, '
          'documentadas como "servis II" en las cuentas domésticas '
          'durante el período de la familia Cornelia.',
      calibracionCorrecta: NivelConfianza.solido,
      idsFuentesAnclaje: ['tablilla_cuentas_domesticas'],
    ),
    AfirmacionCanonica(
      id: 'ausencia_nombrar_esclavizadas',
      texto: 'Estas personas no están nombradas en ninguna fuente que '
          'se conserve. Su número exacto, sus nombres, sus vidas '
          'concretas, sus orígenes culturales se desconocen — y este '
          'silencio no es accidente del registro: es estructura de la '
          'sociedad romana esclavista que producía las fuentes. '
          'Sólido (la ausencia).',
      calibracionCorrecta: NivelConfianza.solido,
      idsFuentesAnclaje: [
        'tablilla_cuentas_domesticas',
        'inscripcion_propietario_cornelio',
        'restos_materiales_domus',
      ],
    ),
    AfirmacionCanonica(
      id: 'mosaico_geometrico_finales_s_ii',
      texto: 'La domus tuvo un mosaico geométrico añadido a fines del '
          'siglo II d.C., fechado por estilo y por contexto '
          'estratigráfico.',
      calibracionCorrecta: NivelConfianza.solido,
      idsFuentesAnclaje: ['restos_materiales_domus'],
    ),
    AfirmacionCanonica(
      id: 'vida_cotidiana_inferida_domus_analogas',
      texto: 'La vida cotidiana de la casa incluyó cocina, comercio, '
          'recepción de clientes, vida familiar y trabajo doméstico '
          'esclavizado en proporciones que se infieren de domus '
          'análogas mejor documentadas.',
      calibracionCorrecta: NivelConfianza.probable,
      idsFuentesAnclaje: [
        'restos_materiales_domus',
        'comparacion_domus_analogas',
      ],
    ),
  ];

  static const List<Brecha> todas = [
    brecha11,
    brecha12,
    brecha13,
    brecha14,
    brecha21,
    brecha22,
    brecha23,
  ];

  /// Mapping inverso: dado el flag que dispara una Brecha, devolver
  /// la Brecha:
  /// - 1.1 se dispara con `aralar_dolmen_alcanzado` (cierre de 1.1.2).
  /// - 1.2 se dispara con `cromlech_aralar_alcanzado` (cierre de 1.B,
  ///   reordenado en F8.4 — antes 1.B activaba directamente
  ///   `arco_1_completado` para llegar al Mosaico, ahora encadena
  ///   con la siguiente Brecha del arco).
  /// - 1.3 se dispara con `cueva_pirineo_visitada` (cierre de la
  ///   cinemática 1.3.5, "vuelta y silencio") — la cueva se visita
  ///   en cinco cinemáticas concatenadas antes de abrir la fase
  ///   jugable de la Brecha.
  /// - 1.4 se dispara con `material_irulegi_recogido` (cierre de la
  ///   cinemática 1.4.2, "material congelado") — el yacimiento se
  ///   visita en 1.4.1, el material del sitio + Mano se observa en
  ///   1.4.2, y entonces se abre la fase jugable de la Brecha 1.4.
  static const Map<String, Brecha> brechaPorFlagDeDisparo = {
    'aralar_dolmen_alcanzado': brecha11,
    'cromlech_aralar_alcanzado': brecha12,
    'cueva_pirineo_visitada': brecha13,
    'material_irulegi_recogido': brecha14,
    // 2.1 se dispara con `inscripcion_romana_estudiada` (cierre de
    // la cinemática 2.1.4 "Quién pagó esto", que activa el flag
    // tras la lectura crítica con Karim). La Brecha jugable se
    // interpone entre 2.1.4 y la 2.1.5 "Reconstrucción y Concilio"
    // narrativa (formal, dos días después en el salón del Concilio
    // con Begoña) — F2-10a cambia la precondición de la 2.1.5 de
    // `escena_2_1_4_vista` a `brecha_2_1_completada` para mantener
    // la separación de los dos Concilios distintos del doc 08.
    'inscripcion_romana_estudiada': brecha21,
    // 2.2 se dispara con `omisiones_quintiliano_estudiadas` (cierre
    // de la cinemática 2.2.4 "Lo que omite") — el doc 08 fija que
    // tras detectar las tres hipótesis sobre las omisiones, Maren
    // produce la reconstrucción jugable. La 2.2.5 "El Concilio en
    // Calahorra" (formal, con Aitor por videollamada) requiere
    // ahora `brecha_2_2_completada` en lugar del previo
    // `escena_2_2_4_vista`.
    'omisiones_quintiliano_estudiadas': brecha22,
    // 2.3 se dispara con `comprender_sin_justificar_aprendido`
    // (cierre de la cinemática 2.3.4 *Comprender sin justificar*) —
    // la lección epistémica de Isaura sobre la diferencia entre
    // neutralidad y comprensión queda aprendida en 2.3.4, y la Brecha
    // jugable es donde Maren la aplica produciendo las 8 afirmaciones
    // con calibración Brier (incluida la afirmación 6 *"Sólido (la
    // ausencia)"* sobre las personas esclavizadas no nombradas). La
    // 2.3.5 cinemática *Reconstrucción* (puesta en limpio narrativa)
    // requiere ahora `brecha_2_3_completada` en lugar del previo
    // `escena_2_3_4_vista`.
    'comprender_sin_justificar_aprendido': brecha23,
  };
}
