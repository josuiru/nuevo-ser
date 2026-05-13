// Sellos del cuaderno. Doc 06 §4 + manifiesto Kids §3, §7.
//
// El cuaderno guarda hitos sobrios cuando consolida algo: la primera
// vez que el niño identifica una lengua, la primera vez que decide
// sobre una pieza en una lengua nueva, la primera vez que publica un
// texto en el Boletín. Son del niño consigo mismo — no comparativos,
// no se enseñan a otros niños, no dan XP.
//
// Esquema de claves: `<tipo>:<discriminante>`
//   lengua_descubierta:pt → primera identificación correcta de portugués
//   lengua_descifrada:pt  → primera decisión sobre pieza en portugués
//   publicacion_boletin   → primera vez que publica en el Boletín
//
// El cuaderno NO usa "primer falso amigo" ni "primera unión de
// fragmentos" del doc 06 §4 porque la mecánica no está implementada.

import 'decision_documento.dart';
import 'lengua.dart';

/// Texto canónico del sello, listo para mostrarse.
class SelloConcedido {
  const SelloConcedido({
    required this.clave,
    required this.texto,
    required this.fecha,
  });

  final String clave;
  final String texto;
  final DateTime fecha;
}

/// Estado inmutable del conjunto de sellos del cuaderno.
class Sellos {
  Sellos._(this._porClave);

  factory Sellos.inicial() => Sellos._(const {});

  factory Sellos.desdeMapa(Map<String, DateTime> mapa) {
    return Sellos._(Map<String, DateTime>.unmodifiable(mapa));
  }

  final Map<String, DateTime> _porClave;

  bool tieneSello(String clave) => _porClave.containsKey(clave);

  DateTime? fechaDe(String clave) => _porClave[clave];

  bool get vacio => _porClave.isEmpty;
  int get cantidad => _porClave.length;

  /// Devuelve sellos concedidos en orden cronológico (más recientes
  /// primero), con texto canónico.
  List<SelloConcedido> ordenadosPorFecha() {
    final entradas = _porClave.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return [
      for (final entrada in entradas)
        SelloConcedido(
          clave: entrada.key,
          texto: textoCanonicoDeClave(entrada.key),
          fecha: entrada.value,
        ),
    ];
  }

  Sellos conSello({required String clave, required DateTime ahora}) {
    if (_porClave.containsKey(clave)) return this;
    final nuevoMapa = Map<String, DateTime>.from(_porClave);
    nuevoMapa[clave] = ahora;
    return Sellos.desdeMapa(nuevoMapa);
  }

  Map<String, dynamic> serializar() {
    return {
      for (final entrada in _porClave.entries)
        entrada.key: entrada.value.toIso8601String(),
    };
  }

  factory Sellos.deserializar(Map<String, dynamic> mapa) {
    final resultado = <String, DateTime>{};
    for (final entrada in mapa.entries) {
      final valor = entrada.value;
      if (valor is! String) continue;
      try {
        resultado[entrada.key] = DateTime.parse(valor);
      } on FormatException {
        continue;
      }
    }
    return Sellos.desdeMapa(resultado);
  }
}

// === Claves canónicas ===

String claveLenguaDescubierta(Lengua lengua) =>
    'lengua_descubierta:${lengua.codigoIso}';

String claveLenguaDescifrada(Lengua lengua) =>
    'lengua_descifrada:${lengua.codigoIso}';

const String clavePublicacionBoletin = 'publicacion_boletin';

/// Devuelve el texto canónico que el cuaderno muestra al mostrar el
/// sello — voz sobria, una frase, sin aplauso (doc 09 §1 + manifiesto
/// Kids §9).
String textoCanonicoDeClave(String clave) {
  if (clave.startsWith('lengua_descubierta:')) {
    final codigo = clave.substring('lengua_descubierta:'.length);
    final lengua = _lenguaPorCodigoOnula(codigo);
    if (lengua == null) {
      return 'Has identificado una lengua nueva.';
    }
    return 'Hoy ha entrado el ${lengua.nombreCanonico.toLowerCase()} en tu cuaderno.';
  }
  if (clave.startsWith('lengua_descifrada:')) {
    final codigo = clave.substring('lengua_descifrada:'.length);
    final lengua = _lenguaPorCodigoOnula(codigo);
    if (lengua == null) {
      return 'Primera pieza descifrada en una lengua nueva.';
    }
    return 'Primera pieza descifrada en ${lengua.nombreCanonico.toLowerCase()}.';
  }
  if (clave == clavePublicacionBoletin) {
    return 'Tu primer texto en el Boletín.';
  }
  return clave;
}

Lengua? _lenguaPorCodigoOnula(String codigo) {
  try {
    return Lengua.desdeCodigo(codigo);
  } on ArgumentError {
    return null;
  }
}

// Marcador estable: la decisión "publicar en el Boletín" tiene un sello
// asociado. La lista se exporta para que el servicio de evaluación
// la consulte sin acoplarse al enum.
const Set<DecisionDocumento> decisionesQueSellanBoletin = {
  DecisionDocumento.publicarEnBoletin,
};
