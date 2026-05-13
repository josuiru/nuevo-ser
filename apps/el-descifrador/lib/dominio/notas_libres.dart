// Notas libres del cuaderno del jugador. Mecánica nuclear §3.3 y
// cuaderno §3.2.
//
// A diferencia de las interpretaciones (que se atan a una pieza), las
// notas libres son del cuaderno entero — son del niño, no del archivo.
// El cuaderno respeta los errores del niño (manifiesto Kids §9 + biblia
// §2.4): no corrige, no subraya, no alerta. Lo que el niño escribe
// queda como lo escribe.
//
// El niño SÍ puede editar o borrar sus propias notas. La diferencia
// con las interpretaciones (que no se borran porque son "estado
// válido") es que una nota es escritura libre, no hipótesis razonada.

/// Una nota libre escrita por el niño en su cuaderno.
class NotaLibre {
  const NotaLibre({
    required this.id,
    required this.texto,
    required this.fechaCreacion,
    this.fechaUltimaEdicion,
  });

  /// Identificador único de la nota, generado al crear.
  final String id;
  final String texto;
  final DateTime fechaCreacion;

  /// Si la nota fue editada después de creada, fecha de la última
  /// edición. Null si nunca se editó.
  final DateTime? fechaUltimaEdicion;

  Map<String, dynamic> serializar() {
    return {
      'id': id,
      'texto': texto,
      'fecha_creacion': fechaCreacion.toIso8601String(),
      if (fechaUltimaEdicion != null)
        'fecha_ultima_edicion': fechaUltimaEdicion!.toIso8601String(),
    };
  }

  factory NotaLibre.deserializar(Map<String, dynamic> mapa) {
    return NotaLibre(
      id: mapa['id'] as String,
      texto: mapa['texto'] as String,
      fechaCreacion: DateTime.parse(mapa['fecha_creacion'] as String),
      fechaUltimaEdicion: mapa['fecha_ultima_edicion'] == null
          ? null
          : DateTime.parse(mapa['fecha_ultima_edicion'] as String),
    );
  }
}

/// Estado inmutable del conjunto de notas libres del jugador.
class NotasLibres {
  NotasLibres._(this._porId);

  factory NotasLibres.inicial() {
    return NotasLibres._(const {});
  }

  factory NotasLibres.desdeMapa(Map<String, NotaLibre> mapa) {
    return NotasLibres._(Map<String, NotaLibre>.unmodifiable(mapa));
  }

  final Map<String, NotaLibre> _porId;

  NotaLibre? notaConId(String id) => _porId[id];

  /// Notas ordenadas de más reciente a más antigua según fecha de
  /// creación (no de edición — la edición no reordena la página).
  List<NotaLibre> ordenadasPorFecha() {
    return _porId.values.toList()
      ..sort((a, b) => b.fechaCreacion.compareTo(a.fechaCreacion));
  }

  bool get vacio => _porId.isEmpty;
  int get cantidad => _porId.length;

  /// Añade una nota nueva. El llamador provee id y fecha (típicamente
  /// el repositorio, que tiene generadores inyectables).
  NotasLibres conNotaNueva({
    required String id,
    required String texto,
    required DateTime ahora,
  }) {
    final textoLimpio = texto.trim();
    if (textoLimpio.isEmpty) return this;
    final nuevoMapa = Map<String, NotaLibre>.from(_porId);
    nuevoMapa[id] = NotaLibre(
      id: id,
      texto: textoLimpio,
      fechaCreacion: ahora,
    );
    return NotasLibres.desdeMapa(nuevoMapa);
  }

  /// Edita el texto de una nota existente. Si la nota no existe o el
  /// texto queda vacío, devuelve la misma instancia (no-op).
  NotasLibres conNotaEditada({
    required String id,
    required String texto,
    required DateTime ahora,
  }) {
    final previa = _porId[id];
    if (previa == null) return this;
    final textoLimpio = texto.trim();
    if (textoLimpio.isEmpty) return this;
    final nuevoMapa = Map<String, NotaLibre>.from(_porId);
    nuevoMapa[id] = NotaLibre(
      id: previa.id,
      texto: textoLimpio,
      fechaCreacion: previa.fechaCreacion,
      fechaUltimaEdicion: ahora,
    );
    return NotasLibres.desdeMapa(nuevoMapa);
  }

  /// Elimina una nota. Si no existe, devuelve la misma instancia.
  NotasLibres sinNota(String id) {
    if (!_porId.containsKey(id)) return this;
    final nuevoMapa = Map<String, NotaLibre>.from(_porId)..remove(id);
    return NotasLibres.desdeMapa(nuevoMapa);
  }

  Map<String, dynamic> serializar() {
    return {
      for (final entrada in _porId.entries)
        entrada.key: entrada.value.serializar(),
    };
  }

  factory NotasLibres.deserializar(Map<String, dynamic> mapa) {
    final resultado = <String, NotaLibre>{};
    for (final entrada in mapa.entries) {
      final valor = entrada.value;
      if (valor is! Map<String, dynamic>) continue;
      try {
        resultado[entrada.key] = NotaLibre.deserializar(valor);
      } on FormatException {
        continue;
      } on TypeError {
        continue;
      }
    }
    return NotasLibres.desdeMapa(resultado);
  }
}
