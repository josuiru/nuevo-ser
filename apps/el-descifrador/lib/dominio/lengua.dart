// Lenguas que aparecen en el corpus de El Descifrador.
//
// Cuatro peninsulares cooficiales como L1 desde día uno (decisión cerrada
// 2026-05-13), seis L2 europeas como lectura asistida, latín fragmentario,
// y árabe como caso especial (identificar, no descifrar pleno —
// biblia §2.10).
//
// Las lenguas raras del repertorio (occitano, asturleonés, papiamento,
// ladino, catalán antiguo) se difieren a v1.1+ según cierre provisional
// del 2026-05-13.

enum Lengua {
  /// Castellano contemporáneo.
  castellano('es', 'Castellano', familiaRomance),

  /// Euskara batua / euskara local.
  euskara('eu', 'Euskara', familiaAislada),

  /// Catalán contemporáneo.
  catalan('ca', 'Catalán', familiaRomance),

  /// Gallego contemporáneo.
  gallego('gl', 'Gallego', familiaRomance),

  /// Portugués europeo.
  portugues('pt', 'Portugués', familiaRomance),

  /// Francés contemporáneo.
  frances('fr', 'Francés', familiaRomance),

  /// Italiano.
  italiano('it', 'Italiano', familiaRomance),

  /// Inglés.
  ingles('en', 'Inglés', familiaGermanica),

  /// Alemán.
  aleman('de', 'Alemán', familiaGermanica),

  /// Latín fragmentario (textos académicos, listas administrativas del XIX).
  latin('la', 'Latín', familiaRomance),

  /// Castellano arcaico del XIX peninsular (grafías ſ larga, abreviaturas).
  castellanoArcaico('es_arcaico', 'Castellano arcaico', familiaRomance),

  /// Castellano americano (cartas de emigrantes en Cuba, México, Argentina).
  castellanoAmericano('es_americano', 'Castellano americano', familiaRomance),

  /// Árabe magrebí. Caso especial — el aprendiz identifica, no descifra
  /// pleno (biblia §2.10).
  arabe('ar', 'Árabe', familiaSemitica);

  const Lengua(this.codigoIso, this.nombreCanonico, this.familia);

  /// Código ISO de la lengua (o variante interna del juego para arcaico/
  /// americano que no son ISO estándar pero sí distinciones operativas
  /// del corpus).
  final String codigoIso;

  /// Nombre canónico en castellano. Para UI usar AppLocalizations.
  final String nombreCanonico;

  /// Familia lingüística — habilitará pistas de comparación por familia
  /// cuando entre el motor de selección.
  final FamiliaLinguistica familia;

  /// Las cuatro lenguas peninsulares cooficiales tratadas como L1 desde
  /// el día uno (manifiesto madre §5.4, biblia §2.5).
  static const Set<Lengua> cooficialesPeninsulares = {
    castellano,
    euskara,
    catalan,
    gallego,
  };

  /// Construye desde código ISO. Lanza ArgumentError si no existe.
  /// El cargador del corpus lo usa para parsear el campo `lengua_principal`.
  static Lengua desdeCodigo(String codigo) {
    for (final lengua in Lengua.values) {
      if (lengua.codigoIso == codigo) return lengua;
    }
    throw ArgumentError('Lengua desconocida en corpus: "$codigo"');
  }

  /// True si el aprendiz puede descifrar pleno esta lengua con ayuda
  /// del contexto. False para árabe y futuras escrituras no-latinas.
  bool get descifrablePlenamente => this != arabe;
}

/// Familias lingüísticas presentes en el corpus.
///
/// Cuando entre el motor de pistas progresivas, una pista de "comparación"
/// puede sugerir buscar cognados en lenguas de la misma familia que la
/// del jugador. Ver `el-descifrador-03-mecanica-nuclear.md` §3.5.
enum FamiliaLinguistica {
  familiaRomance,
  familiaGermanica,
  familiaSemitica,
  familiaAislada,
}

const familiaRomance = FamiliaLinguistica.familiaRomance;
const familiaGermanica = FamiliaLinguistica.familiaGermanica;
const familiaSemitica = FamiliaLinguistica.familiaSemitica;
const familiaAislada = FamiliaLinguistica.familiaAislada;
