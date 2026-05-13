// Registro de identificaciones de lengua que el niño hace sobre las
// piezas. Mecánica nuclear §3.1.
//
// Cuando llega una pieza nueva no trae etiqueta de lengua. El niño
// hipotetiza qué lengua es. El registro guarda:
//   - todos los intentos en orden (el primero es la hipótesis inicial),
//   - si finalmente acertó (es decir, si alguno de los intentos coincide
//     con la lengua principal de la pieza),
//   - cuándo identificó por primera vez (acertara o no).
//
// El maestro no penaliza el fallo: cuando el niño se equivoca, le ofrece
// una pista y vuelve a preguntar (doc 03 §3.1).

import 'lengua.dart';

/// Identificación que el niño ha hecho sobre una pieza concreta.
class IdentificacionLengua {
  const IdentificacionLengua({
    required this.idPieza,
    required this.intentos,
    required this.acertadaEnPrimerIntento,
    required this.identificadaCorrectamente,
    required this.fechaPrimerIntento,
  });

  final String idPieza;

  /// Lista ordenada de intentos. La primera es la hipótesis inicial.
  final List<Lengua> intentos;

  /// Cierta si el niño identificó bien al primer intento — métrica
  /// para el cuaderno, sin penalización.
  final bool acertadaEnPrimerIntento;

  /// Cierta si en algún momento acertó la lengua de la pieza.
  final bool identificadaCorrectamente;

  final DateTime fechaPrimerIntento;

  Map<String, dynamic> serializar() {
    return {
      'id_pieza': idPieza,
      'intentos': intentos.map((l) => l.codigoIso).toList(),
      'acertada_en_primer_intento': acertadaEnPrimerIntento,
      'identificada_correctamente': identificadaCorrectamente,
      'fecha_primer_intento': fechaPrimerIntento.toIso8601String(),
    };
  }

  factory IdentificacionLengua.deserializar(Map<String, dynamic> mapa) {
    final intentosCrudos = mapa['intentos'] as List;
    final intentos = <Lengua>[];
    for (final codigo in intentosCrudos) {
      if (codigo is! String) continue;
      try {
        intentos.add(Lengua.desdeCodigo(codigo));
      } on ArgumentError {
        // Lengua eliminada entre versiones — ignorar este intento.
        continue;
      }
    }
    return IdentificacionLengua(
      idPieza: mapa['id_pieza'] as String,
      intentos: intentos,
      acertadaEnPrimerIntento:
          mapa['acertada_en_primer_intento'] as bool? ?? false,
      identificadaCorrectamente:
          mapa['identificada_correctamente'] as bool? ?? false,
      fechaPrimerIntento:
          DateTime.parse(mapa['fecha_primer_intento'] as String),
    );
  }
}

/// Estado inmutable del conjunto de identificaciones.
class IdentificacionesPiezas {
  IdentificacionesPiezas._(this._porIdPieza);

  factory IdentificacionesPiezas.inicial() {
    return IdentificacionesPiezas._(const {});
  }

  factory IdentificacionesPiezas.desdeMapa(
    Map<String, IdentificacionLengua> mapa,
  ) {
    return IdentificacionesPiezas._(
      Map<String, IdentificacionLengua>.unmodifiable(mapa),
    );
  }

  final Map<String, IdentificacionLengua> _porIdPieza;

  IdentificacionLengua? identificacionDe(String idPieza) {
    return _porIdPieza[idPieza];
  }

  bool yaIdentificada(String idPieza) {
    return _porIdPieza[idPieza]?.identificadaCorrectamente ?? false;
  }

  Set<String> idsCorrectamenteIdentificadas() {
    return _porIdPieza.entries
        .where((entrada) => entrada.value.identificadaCorrectamente)
        .map((entrada) => entrada.key)
        .toSet();
  }

  bool get vacio => _porIdPieza.isEmpty;

  /// Registra un intento. Si ya hay identificación previa correcta,
  /// no se modifica (el niño no puede "desidentificar" una pieza).
  IdentificacionesPiezas conIntento({
    required String idPieza,
    required Lengua lenguaIntentada,
    required Lengua lenguaCorrecta,
    required DateTime ahora,
  }) {
    final previa = _porIdPieza[idPieza];
    if (previa != null && previa.identificadaCorrectamente) {
      return this;
    }

    final intentosAcumulados = <Lengua>[
      ...?previa?.intentos,
      lenguaIntentada,
    ];
    final acerto = lenguaIntentada == lenguaCorrecta;
    final acertadaEnPrimerIntento =
        previa == null ? acerto : previa.acertadaEnPrimerIntento;
    final identificadaCorrectamente =
        (previa?.identificadaCorrectamente ?? false) || acerto;

    final nuevoMapa = Map<String, IdentificacionLengua>.from(_porIdPieza);
    nuevoMapa[idPieza] = IdentificacionLengua(
      idPieza: idPieza,
      intentos: intentosAcumulados,
      acertadaEnPrimerIntento: acertadaEnPrimerIntento,
      identificadaCorrectamente: identificadaCorrectamente,
      fechaPrimerIntento: previa?.fechaPrimerIntento ?? ahora,
    );
    return IdentificacionesPiezas.desdeMapa(nuevoMapa);
  }

  Map<String, dynamic> serializar() {
    return {
      for (final entrada in _porIdPieza.entries)
        entrada.key: entrada.value.serializar(),
    };
  }

  factory IdentificacionesPiezas.deserializar(Map<String, dynamic> mapa) {
    final resultado = <String, IdentificacionLengua>{};
    for (final entrada in mapa.entries) {
      final valor = entrada.value;
      if (valor is! Map<String, dynamic>) continue;
      try {
        resultado[entrada.key] = IdentificacionLengua.deserializar(valor);
      } on FormatException {
        continue;
      } on TypeError {
        continue;
      }
    }
    return IdentificacionesPiezas.desdeMapa(resultado);
  }
}
