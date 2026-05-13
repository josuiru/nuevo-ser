// Anotaciones marginales sobre una pieza. Cuaderno §3.3.
//
// Cuando el niño está trabajando un documento puede dejar varias notas
// pequeñas asociadas a esa pieza. Son distintas de:
//
//   - vocabulario: marca por palabra concreta (verde/amarillo/rojo).
//   - interpretación: una única síntesis global de la pieza.
//   - notas libres: van al cuaderno entero, sin pieza asociada.
//
// Una anotación es una micro-nota sobre un detalle ("mirar pimentón de
// Vera, lo había visto en X"). Múltiples por pieza, editables y
// borrables como las notas libres.
//
// En v0.10.0 se muestran como tarjetas debajo del documento. La
// presentación "en margen del texto" del doc 06 §3.3 queda para cuando
// llegue ilustrador y guía visual definitiva.

/// Una anotación marginal sobre una pieza.
class AnotacionPieza {
  const AnotacionPieza({
    required this.id,
    required this.idPieza,
    required this.texto,
    required this.fechaCreacion,
    this.fechaUltimaEdicion,
  });

  final String id;
  final String idPieza;
  final String texto;
  final DateTime fechaCreacion;
  final DateTime? fechaUltimaEdicion;

  Map<String, dynamic> serializar() {
    return {
      'id': id,
      'id_pieza': idPieza,
      'texto': texto,
      'fecha_creacion': fechaCreacion.toIso8601String(),
      if (fechaUltimaEdicion != null)
        'fecha_ultima_edicion': fechaUltimaEdicion!.toIso8601String(),
    };
  }

  factory AnotacionPieza.deserializar(Map<String, dynamic> mapa) {
    return AnotacionPieza(
      id: mapa['id'] as String,
      idPieza: mapa['id_pieza'] as String,
      texto: mapa['texto'] as String,
      fechaCreacion: DateTime.parse(mapa['fecha_creacion'] as String),
      fechaUltimaEdicion: mapa['fecha_ultima_edicion'] == null
          ? null
          : DateTime.parse(mapa['fecha_ultima_edicion'] as String),
    );
  }
}

/// Estado inmutable de las anotaciones por pieza.
class AnotacionesPiezas {
  AnotacionesPiezas._(this._porIdAnotacion);

  factory AnotacionesPiezas.inicial() {
    return AnotacionesPiezas._(const {});
  }

  factory AnotacionesPiezas.desdeMapa(Map<String, AnotacionPieza> mapa) {
    return AnotacionesPiezas._(
      Map<String, AnotacionPieza>.unmodifiable(mapa),
    );
  }

  /// Indexado por id de anotación (no por pieza) para permitir editar
  /// y borrar rápido por id, que es lo que la UI necesita.
  final Map<String, AnotacionPieza> _porIdAnotacion;

  AnotacionPieza? anotacionConId(String id) => _porIdAnotacion[id];

  /// Anotaciones de una pieza concreta, más recientes primero.
  List<AnotacionPieza> anotacionesDe(String idPieza) {
    return _porIdAnotacion.values
        .where((anotacion) => anotacion.idPieza == idPieza)
        .toList()
      ..sort((a, b) => b.fechaCreacion.compareTo(a.fechaCreacion));
  }

  /// Cantidad total de anotaciones registradas (cualquier pieza).
  int get cantidadTotal => _porIdAnotacion.length;

  bool get vacio => _porIdAnotacion.isEmpty;

  AnotacionesPiezas conAnotacionNueva({
    required String id,
    required String idPieza,
    required String texto,
    required DateTime ahora,
  }) {
    final textoLimpio = texto.trim();
    if (textoLimpio.isEmpty) return this;
    final nuevoMapa = Map<String, AnotacionPieza>.from(_porIdAnotacion);
    nuevoMapa[id] = AnotacionPieza(
      id: id,
      idPieza: idPieza,
      texto: textoLimpio,
      fechaCreacion: ahora,
    );
    return AnotacionesPiezas.desdeMapa(nuevoMapa);
  }

  AnotacionesPiezas conAnotacionEditada({
    required String id,
    required String texto,
    required DateTime ahora,
  }) {
    final previa = _porIdAnotacion[id];
    if (previa == null) return this;
    final textoLimpio = texto.trim();
    if (textoLimpio.isEmpty) return this;
    final nuevoMapa = Map<String, AnotacionPieza>.from(_porIdAnotacion);
    nuevoMapa[id] = AnotacionPieza(
      id: previa.id,
      idPieza: previa.idPieza,
      texto: textoLimpio,
      fechaCreacion: previa.fechaCreacion,
      fechaUltimaEdicion: ahora,
    );
    return AnotacionesPiezas.desdeMapa(nuevoMapa);
  }

  AnotacionesPiezas sinAnotacion(String id) {
    if (!_porIdAnotacion.containsKey(id)) return this;
    final nuevoMapa = Map<String, AnotacionPieza>.from(_porIdAnotacion)
      ..remove(id);
    return AnotacionesPiezas.desdeMapa(nuevoMapa);
  }

  Map<String, dynamic> serializar() {
    return {
      for (final entrada in _porIdAnotacion.entries)
        entrada.key: entrada.value.serializar(),
    };
  }

  factory AnotacionesPiezas.deserializar(Map<String, dynamic> mapa) {
    final resultado = <String, AnotacionPieza>{};
    for (final entrada in mapa.entries) {
      final valor = entrada.value;
      if (valor is! Map<String, dynamic>) continue;
      try {
        resultado[entrada.key] = AnotacionPieza.deserializar(valor);
      } on FormatException {
        continue;
      } on TypeError {
        continue;
      }
    }
    return AnotacionesPiezas.desdeMapa(resultado);
  }
}
