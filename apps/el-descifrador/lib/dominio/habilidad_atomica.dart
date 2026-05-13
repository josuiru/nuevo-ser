// Habilidades atómicas del mapa pedagógico de El Descifrador.
//
// Cuatro dominios (A lengua, B idiomas, C pensamiento crítico,
// D redacción) con 8-10 habilidades cada uno, más cinco transversales.
// Ver `el-descifrador-04-mapa-habilidades.md`.
//
// El motor de maestría granular (perfil P6, ver doc 16) mide cada una
// por inferencia silenciosa cuando el niño identifica lengua, marca
// palabras, propone interpretación, pide pistas o decide. El niño
// NUNCA ve estos identificadores ni el nivel de dominio — el progreso
// visible es el cuaderno (biblia §2.7).
//
// El mapa actual es v0.1 declarado provisional el 2026-05-13. Asesor
// de didáctica de lengua ESO 1-2 firma antes de v1.0. Si el mapa
// cambia tras esa validación, las piezas del corpus se reetiquetan.

enum HabilidadAtomica {
  // Dominio A — Lengua (L1 y cooficiales como L1)
  a1ReconocimientoMarcadoresOrtograficos('A1'),
  a2VocabularioFamiliasLexicas('A2'),
  a3OrtografiaContextual('A3'),
  a4SintaxisBasicaFuncional('A4'),
  a5Registro('A5'),
  a6LecturaGrafiasAntiguas('A6'),
  a7ComprensionGlobal('A7'),
  a8ComprensionEspecifica('A8'),
  a9Inferencia('A9'),
  a10LexicoTecnicoPorDominio('A10'),

  // Dominio B — Idiomas (L2 lectura)
  b1ReconocimientoLenguaL2('B1'),
  b2CognadosVerdaderos('B2'),
  b3FalsosAmigos('B3'),
  b4FamiliasLinguisticas('B4'),
  b5ConvencionesEpistolares('B5'),
  b6LecturaAsistidaPortugues('B6'),
  b7LecturaAsistidaItaliano('B7'),
  b8LecturaAsistidaFrances('B8'),
  b9LecturaAsistidaIngles('B9'),
  b10ReconocimientoNoLatinas('B10'),

  // Dominio C — Pensamiento crítico
  c1CoherenciaInterna('C1'),
  c2AnalisisRemitente('C2'),
  c3AnalisisDestinatario('C3'),
  c4AfirmacionVsOpinion('C4'),
  c5DecisionCivil('C5'),
  c6ResponsabilidadDecision('C6'),
  c7FechadoDatacion('C7'),
  c8DeteccionOmisiones('C8'),
  c9CruceFuentes('C9'),
  c10ConfianzaGraduada('C10'),

  // Dominio D — Redacción
  d1EscrituraLibreCuaderno('D1'),
  d2NotasMarginales('D2'),
  d3Sintesis('D3'),
  d4NotasOficina('D4'),
  d5TitularBoletin('D5'),
  d6TraduccionAsistidaContexto('D6'),

  // Transversales
  t1Metaconocimiento('T1'),
  t2Persistencia('T2'),
  t3CuriosidadLateral('T3'),
  t4CuidadoCuaderno('T4'),
  t5ToleranciaAmbiguedad('T5');

  const HabilidadAtomica(this.identificadorTecnico);

  /// Identificador corto usado en el JSON del corpus
  /// (`habilidades_atomicas: [B6, B3, A10, A5, A9, C5]`).
  final String identificadorTecnico;

  /// El dominio al que pertenece esta habilidad (primera letra).
  String get dominio => identificadorTecnico.substring(0, 1);

  /// Construye desde identificador. Lanza ArgumentError si no existe.
  static HabilidadAtomica desdeIdentificador(String identificador) {
    for (final habilidad in HabilidadAtomica.values) {
      if (habilidad.identificadorTecnico == identificador) return habilidad;
    }
    throw ArgumentError(
      'Habilidad atómica desconocida en corpus: "$identificador"',
    );
  }
}
