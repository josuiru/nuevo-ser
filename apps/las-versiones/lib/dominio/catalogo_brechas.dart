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

  /// Lista ordenada de todas las Brechas catalogadas. El orquestador
  /// la consulta para resolver `brechaPendiente()` igual que
  /// `EscenasArco1.todas` resuelve la próxima cinemática.
  static const List<Brecha> todas = [brecha11, brecha12, brecha13];

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
  static const Map<String, Brecha> brechaPorFlagDeDisparo = {
    'aralar_dolmen_alcanzado': brecha11,
    'cromlech_aralar_alcanzado': brecha12,
    'cueva_pirineo_visitada': brecha13,
  };
}
