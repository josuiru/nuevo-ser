// Interpretaciones que el niño propone para piezas del corpus.
//
// Mecánica nuclear §3.4. El niño escribe en su lengua de juego "lo que yo
// creo que dice este documento". Síntesis libre, no traducción palabra
// por palabra. La hipótesis es estado válido (biblia §2.3) — no hace
// falta estar seguro.
//
// La interpretación queda en el cuaderno con fecha. El niño puede
// revisarla más tarde si descubre algo nuevo: en ese caso se actualiza
// el texto y se anota la fecha de la última revisión, sin borrar la
// fecha original.
//
// No hay "borrar interpretación" deliberadamente: una hipótesis ya
// pensada es huella del proceso del niño, no se descarta.

/// Interpretación que el niño ha propuesto para una pieza concreta.
class InterpretacionPieza {
  const InterpretacionPieza({
    required this.idPieza,
    required this.texto,
    required this.fechaPropuesta,
    this.fechaUltimaRevision,
  });

  final String idPieza;
  final String texto;
  final DateTime fechaPropuesta;

  /// Si el niño ha vuelto sobre el documento y ha reescrito su hipótesis,
  /// esta fecha refleja la última vez. Nula si nunca se revisó.
  final DateTime? fechaUltimaRevision;

  Map<String, dynamic> serializar() {
    return {
      'id_pieza': idPieza,
      'texto': texto,
      'fecha_propuesta': fechaPropuesta.toIso8601String(),
      if (fechaUltimaRevision != null)
        'fecha_ultima_revision': fechaUltimaRevision!.toIso8601String(),
    };
  }

  factory InterpretacionPieza.deserializar(Map<String, dynamic> mapa) {
    return InterpretacionPieza(
      idPieza: mapa['id_pieza'] as String,
      texto: mapa['texto'] as String,
      fechaPropuesta: DateTime.parse(mapa['fecha_propuesta'] as String),
      fechaUltimaRevision: mapa['fecha_ultima_revision'] == null
          ? null
          : DateTime.parse(mapa['fecha_ultima_revision'] as String),
    );
  }
}

/// Estado inmutable del conjunto de interpretaciones del jugador.
class InterpretacionesPropuestas {
  InterpretacionesPropuestas._(this._porIdPieza);

  factory InterpretacionesPropuestas.inicial() {
    return InterpretacionesPropuestas._(const {});
  }

  factory InterpretacionesPropuestas.desdeMapa(
    Map<String, InterpretacionPieza> mapa,
  ) {
    return InterpretacionesPropuestas._(
      Map<String, InterpretacionPieza>.unmodifiable(mapa),
    );
  }

  final Map<String, InterpretacionPieza> _porIdPieza;

  /// Interpretación de esta pieza, o null si el niño aún no propuso nada.
  InterpretacionPieza? interpretacionDe(String idPieza) {
    return _porIdPieza[idPieza];
  }

  /// Lista ordenada por fecha de propuesta (más reciente primero).
  List<InterpretacionPieza> ordenadasPorFecha() {
    return _porIdPieza.values.toList()
      ..sort((a, b) => b.fechaPropuesta.compareTo(a.fechaPropuesta));
  }

  bool get vacio => _porIdPieza.isEmpty;

  /// Devuelve nueva instancia con esta interpretación registrada.
  ///
  /// Si ya existía una interpretación para esta pieza, se preserva la
  /// fecha original como `fechaPropuesta` y se actualiza el texto +
  /// `fechaUltimaRevision`. Si es la primera vez, `fechaPropuesta` toma
  /// el valor del parámetro.
  InterpretacionesPropuestas conInterpretacion({
    required String idPieza,
    required String texto,
    required DateTime ahora,
  }) {
    final textoLimpio = texto.trim();
    if (textoLimpio.isEmpty) return this;

    final previa = _porIdPieza[idPieza];
    final nuevoMapa = Map<String, InterpretacionPieza>.from(_porIdPieza);
    if (previa == null) {
      nuevoMapa[idPieza] = InterpretacionPieza(
        idPieza: idPieza,
        texto: textoLimpio,
        fechaPropuesta: ahora,
      );
    } else {
      nuevoMapa[idPieza] = InterpretacionPieza(
        idPieza: idPieza,
        texto: textoLimpio,
        fechaPropuesta: previa.fechaPropuesta,
        fechaUltimaRevision: ahora,
      );
    }
    return InterpretacionesPropuestas.desdeMapa(nuevoMapa);
  }

  Map<String, dynamic> serializar() {
    return {
      for (final entrada in _porIdPieza.entries)
        entrada.key: entrada.value.serializar(),
    };
  }

  /// Deserializa tolerando entradas mal formadas (las ignora).
  factory InterpretacionesPropuestas.deserializar(Map<String, dynamic> mapa) {
    final resultado = <String, InterpretacionPieza>{};
    for (final entrada in mapa.entries) {
      final valor = entrada.value;
      if (valor is! Map<String, dynamic>) continue;
      try {
        resultado[entrada.key] = InterpretacionPieza.deserializar(valor);
      } on FormatException {
        continue;
      } on TypeError {
        continue;
      }
    }
    return InterpretacionesPropuestas.desdeMapa(resultado);
  }
}
