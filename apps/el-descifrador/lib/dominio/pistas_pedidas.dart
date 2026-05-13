// Registro de las pistas que el niño ha pedido al maestro sobre
// palabras de las piezas. Mecánica nuclear §3.5.
//
// El registro existe para que el cuaderno sepa qué descifró el niño
// solo y qué con ayuda — no para penalizar, sino para que el niño
// se conozca a sí mismo (doc 03 §3.5). Pedir ayuda es parte del
// oficio, no debilidad.
//
// El motor no impide pedir más pistas — el niño puede pedir las tres
// (tono → comparación → traducción) sobre la misma palabra. Pero el
// registro guarda cuáles ya se pidieron para que el maestro no
// repita textualmente la misma pista y el documento marque el margen
// de manera distinta.

import 'vocabulario_jugador.dart' show normalizarPalabra;

/// Niveles de pista que el niño puede pedir al maestro.
enum NivelPista {
  /// "Esa palabra te suena de algo del cuaderno". El maestro empuja al
  /// niño a buscar él en su propio material.
  tono('tono'),

  /// "Mira esta otra carta del mismo remitente". El maestro da un texto
  /// paralelo con más contexto.
  comparacion('comparacion'),

  /// "Esa palabra significa X". El maestro da la equivalencia concreta.
  traduccion('traduccion');

  const NivelPista(this.identificadorTecnico);

  final String identificadorTecnico;

  static NivelPista desdeIdentificador(String identificador) {
    for (final nivel in NivelPista.values) {
      if (nivel.identificadorTecnico == identificador) return nivel;
    }
    throw ArgumentError('Nivel de pista desconocido: "$identificador"');
  }
}

/// Una pista concreta pedida sobre una palabra de una pieza.
class PistaPedida {
  const PistaPedida({
    required this.idPieza,
    required this.palabraNormalizada,
    required this.nivel,
    required this.fecha,
  });

  final String idPieza;
  final String palabraNormalizada;
  final NivelPista nivel;
  final DateTime fecha;

  Map<String, dynamic> serializar() {
    return {
      'id_pieza': idPieza,
      'palabra': palabraNormalizada,
      'nivel': nivel.identificadorTecnico,
      'fecha': fecha.toIso8601String(),
    };
  }

  factory PistaPedida.deserializar(Map<String, dynamic> mapa) {
    return PistaPedida(
      idPieza: mapa['id_pieza'] as String,
      palabraNormalizada: mapa['palabra'] as String,
      nivel: NivelPista.desdeIdentificador(mapa['nivel'] as String),
      fecha: DateTime.parse(mapa['fecha'] as String),
    );
  }
}

/// Estado inmutable del conjunto de pistas pedidas por el niño.
///
/// Indexado por idPieza y, dentro de cada pieza, por palabra y nivel.
class PistasPedidas {
  PistasPedidas._(this._porIdPieza);

  factory PistasPedidas.inicial() {
    return PistasPedidas._(const {});
  }

  /// Mapa pieza → palabraNormalizada → set de niveles ya pedidos.
  final Map<String, Map<String, Map<NivelPista, DateTime>>> _porIdPieza;

  /// Niveles ya pedidos para esta palabra en esta pieza.
  Set<NivelPista> nivelesPedidos({
    required String idPieza,
    required String palabra,
  }) {
    final normalizada = normalizarPalabra(palabra);
    if (normalizada.isEmpty) return const {};
    final mapaPieza = _porIdPieza[idPieza];
    if (mapaPieza == null) return const {};
    final mapaPalabra = mapaPieza[normalizada];
    if (mapaPalabra == null) return const {};
    return mapaPalabra.keys.toSet();
  }

  /// Todas las palabras (normalizadas) con alguna pista pedida en esta pieza.
  Set<String> palabrasConPistaEn(String idPieza) {
    final mapaPieza = _porIdPieza[idPieza];
    if (mapaPieza == null) return const {};
    return mapaPieza.keys.toSet();
  }

  bool get vacio => _porIdPieza.isEmpty;

  /// Devuelve nueva instancia con esta pista registrada. Si ya estaba
  /// registrada, conserva la fecha original (la pista se pidió una vez,
  /// las repeticiones no cuentan).
  PistasPedidas conPista({
    required String idPieza,
    required String palabra,
    required NivelPista nivel,
    required DateTime ahora,
  }) {
    final normalizada = normalizarPalabra(palabra);
    if (normalizada.isEmpty) return this;

    final nuevoMapaPieza = <String, Map<NivelPista, DateTime>>{
      ...?_porIdPieza[idPieza],
    };
    final nuevoMapaPalabra = <NivelPista, DateTime>{
      ...?nuevoMapaPieza[normalizada],
    };
    if (nuevoMapaPalabra.containsKey(nivel)) {
      return this;
    }
    nuevoMapaPalabra[nivel] = ahora;
    nuevoMapaPieza[normalizada] = nuevoMapaPalabra;

    final nuevoMapaGlobal =
        Map<String, Map<String, Map<NivelPista, DateTime>>>.from(_porIdPieza);
    nuevoMapaGlobal[idPieza] = nuevoMapaPieza;
    return PistasPedidas._(Map.unmodifiable(nuevoMapaGlobal));
  }

  /// Serializa a estructura de mapa para persistencia JSON.
  Map<String, dynamic> serializar() {
    return {
      for (final entradaPieza in _porIdPieza.entries)
        entradaPieza.key: {
          for (final entradaPalabra in entradaPieza.value.entries)
            entradaPalabra.key: {
              for (final entradaNivel in entradaPalabra.value.entries)
                entradaNivel.key.identificadorTecnico:
                    entradaNivel.value.toIso8601String(),
            },
        },
    };
  }

  /// Deserializa tolerando entradas mal formadas.
  factory PistasPedidas.deserializar(Map<String, dynamic> mapa) {
    final resultado =
        <String, Map<String, Map<NivelPista, DateTime>>>{};
    for (final entradaPieza in mapa.entries) {
      final valorPieza = entradaPieza.value;
      if (valorPieza is! Map) continue;
      final mapaPalabras = <String, Map<NivelPista, DateTime>>{};
      for (final entradaPalabra in valorPieza.entries) {
        final clavePalabra = entradaPalabra.key;
        final valorPalabra = entradaPalabra.value;
        if (clavePalabra is! String || valorPalabra is! Map) continue;
        final mapaNiveles = <NivelPista, DateTime>{};
        for (final entradaNivel in valorPalabra.entries) {
          final claveNivel = entradaNivel.key;
          final valorFecha = entradaNivel.value;
          if (claveNivel is! String || valorFecha is! String) continue;
          try {
            mapaNiveles[NivelPista.desdeIdentificador(claveNivel)] =
                DateTime.parse(valorFecha);
          } on ArgumentError {
            continue;
          } on FormatException {
            continue;
          }
        }
        if (mapaNiveles.isNotEmpty) {
          mapaPalabras[clavePalabra] = mapaNiveles;
        }
      }
      if (mapaPalabras.isNotEmpty) {
        resultado[entradaPieza.key] = mapaPalabras;
      }
    }
    return PistasPedidas._(Map.unmodifiable(resultado));
  }
}
