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
    afirmacionesCanonicas: [],
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

  /// Lista ordenada de todas las Brechas catalogadas. El orquestador
  /// la consulta para resolver `brechaPendiente()` igual que
  /// `EscenasArco1.todas` resuelve la próxima cinemática.
  static const List<Brecha> todas = [brecha11];

  /// Mapping inverso: dado el flag que dispara una Brecha, devolver
  /// la Brecha. La 1.1 se dispara cuando `aralar_dolmen_alcanzado`
  /// está activo y `brecha_1_1_completada` aún no.
  ///
  /// Cuando llegue la 1.2, esta tabla crece con su flag de
  /// disparo. Versión inicial: una sola entrada.
  static const Map<String, Brecha> brechaPorFlagDeDisparo = {
    'aralar_dolmen_alcanzado': brecha11,
  };
}
