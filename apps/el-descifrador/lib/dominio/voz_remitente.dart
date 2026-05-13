// Voces de remitentes recurrentes del corpus.
//
// Ocho personajes con voz textual declarada en `el-descifrador-09-voces-
// y-figuras.md`. Cada remitente recurrente tiene tics, vocabulario,
// fórmulas y errores característicos que el niño aprende a reconocer
// antes incluso de leer la firma.
//
// Los personajes que escriben puntualmente al corpus pero no son
// recurrentes (un vecino anónimo, un cartelero callejero, un músico
// que manda una sola pieza) NO entran aquí — sus piezas tienen
// `remitente` como string libre en el JSON.

enum VozRemitente {
  /// Cocinera de Lisboa, cincuentona, viuda, dueña de tasca. Escribe en
  /// portugués con palabras castellanas infiltradas. Tics: paréntesis
  /// encadenados, "embaraçada" como falso amigo, beijinhos al despedirse.
  inesCocineraLisboa('ines_cocinera_lisboa', 'Inês'),

  /// Cirujano naval inglés, cuarentón, profesional. Inglés formal con
  /// latinajos médicos. Tics: "Dear sir", "Yours faithfully", citas del
  /// Lancet, paranoia sobre los "port channels".
  mansfieldMedicoBristol('edmund_mansfield_medico_bristol', 'Dr. Mansfield'),

  /// Capitana del Estrella de la Tarde, treintañera gallega, nieta de
  /// marinos. Escribe en gallego o castellano según destinatario. Tics:
  /// frases rítmicas con cadencia marina, coordenadas al pie, mezcla
  /// observación práctica con apunte poético.
  iriaCapitana('iria_capitana_estrella_tarde', 'Iria'),

  /// Boticario de La Estafeta, sesentón viudo, castellano con catalán
  /// infiltrado (mujer catalana). Tics: saludo seco "Aprendiz:",
  /// frase exacta con números, siempre pregunta concreta al final.
  joanBoticarioPuerto('joan_boticario_puerto', 'Joan'),

  /// Maestra de escuela del puerto, treintañera castellanohablante con
  /// euskara aprendido. Tics: saludo cordial cálido, registro pedagógico
  /// honesto, agradecimiento concreto al despedirse.
  beaMaestraEscuela('bea_maestra_escuela_puerto', 'Bea'),

  /// Editor del Boletín, cuarentón sarcástico. Tics: sin saludo, va al
  /// grano con guión "Aprendiz —", crítica mordaz al titular flojo,
  /// cierre con prisa.
  manuelEditorBoletin('manuel_editor_boletin', 'Manuel'),

  /// Maestro de oficina de La Estafeta, sesentón cabal castellano +
  /// catalán materno. Forma parte de la pareja coral del maestro.
  /// Tics: frase corta, humor seco, asiente no aplaude.
  antonMaestroOficina('anton_maestro_oficina', 'Antón'),

  /// Maestra de oficina de La Estafeta, cincuentona euskara nativa con
  /// gallego aprendido por matrimonio. Pareja coral con Antón. Tics:
  /// directa, ríe poco pero ríe bien, plantas en el despacho.
  aitziberMaestraOficina('aitziber_maestra_oficina', 'Aitziber');

  const VozRemitente(this.identificadorTecnico, this.nombreCanonico);

  /// Identificador en snake_case usado en el JSON del corpus.
  final String identificadorTecnico;

  /// Nombre del personaje para mostrar al niño en UI (firma del documento,
  /// página del cuaderno).
  final String nombreCanonico;

  /// Construye desde identificador. Devuelve null si el remitente no es
  /// uno de los ocho recurrentes — el cargador del corpus lo usa para
  /// distinguir voces recurrentes (enum) de voces puntuales (string libre).
  static VozRemitente? desdeIdentificador(String identificador) {
    for (final voz in VozRemitente.values) {
      if (voz.identificadorTecnico == identificador) return voz;
    }
    return null;
  }
}
