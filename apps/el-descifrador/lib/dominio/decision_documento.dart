// Decisiones que el niño puede tomar sobre un documento al cerrar su
// trabajo con él.
//
// Las cinco decisiones tienen consecuencia narrativa en sesiones
// siguientes. La elección NO es de sabor. Ver biblia §2.8 y
// `el-descifrador-03-mecanica-nuclear.md` §3.6.

enum DecisionDocumento {
  /// El documento queda en el archivo de la oficina con la interpretación
  /// del niño anexa. La ciudad lo conserva. Función patrimonial.
  archivar('archivar'),

  /// Devolver al remitente. Si el documento no debió venir o se entiende
  /// mejor en su origen. La oficina escribe una nota breve.
  devolverAlRemitente('devolver'),

  /// Entregar al destinatario si está claro a quién va dirigido. El
  /// cartero lleva el documento a esa persona, con la interpretación
  /// del niño si es necesaria.
  entregarAlDestinatario('entregar'),

  /// Mandar al Boletín si el contenido merece que la ciudad lo sepa.
  /// El niño compone titular (operación D5 del mapa).
  publicarEnBoletin('publicar'),

  /// No decidir todavía. El documento vuelve a la bandeja en curso.
  /// Más tarde, otra pieza puede aclarar el contexto. La hipótesis
  /// parcial es estado válido (biblia §2.3).
  esperar('esperar');

  const DecisionDocumento(this.identificadorTecnico);

  /// Identificador en snake_case usado en el JSON del corpus
  /// (`decisiones_validas` declara qué decisiones tiene sentido para
  /// esta pieza concreta).
  final String identificadorTecnico;

  /// Construye desde identificador. Lanza ArgumentError si no existe.
  static DecisionDocumento desdeIdentificador(String identificador) {
    for (final decision in DecisionDocumento.values) {
      if (decision.identificadorTecnico == identificador) return decision;
    }
    throw ArgumentError(
      'Decisión desconocida en corpus: "$identificador"',
    );
  }
}
