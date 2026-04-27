import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// Caché local de respuestas del tutor IA. Doc 03 §9 pide "caché
/// agresivo": cuando el niño vuelve a preguntar lo mismo (literal o
/// muy parecido) servimos la respuesta de la sesión anterior sin
/// llamar a Anthropic.
///
/// Diseño:
/// - Clave: `<idHabilidad>|<preguntaNormalizada>`. La normalización
///   (minúsculas + espacios colapsados) hace que "¿Cómo sumo 1/2 + 1/3?"
///   y "  como sumo 1/2 + 1/3  " caigan en la misma entrada.
/// - Valor: explicación + timestamp. TTL configurable (por defecto 30
///   días — las matemáticas no caducan pero queremos rotar para que
///   no se calcifique una explicación rara).
/// - Tamaño máximo (LRU): cuando se llena, expulsa la entrada con
///   timestamp más viejo. 200 es generoso para el uso real de un niño.
/// - Persistencia: el catálogo se serializa a JSON bajo una clave
///   global (`uroto.tutor.cache.v1`). No por-perfil — la caché es
///   compartible entre niños sin coste de privacidad (no contiene
///   datos personales, solo Q/A de matemáticas).
class CacheTutor {
  static const String _claveAlmacen = 'uroto.tutor.cache.v1';
  static const Duration ttlPorDefecto = Duration(days: 30);
  static const int tamanoMaximoPorDefecto = 200;

  final Duration _ttl;
  final int _tamanoMaximo;
  final Map<String, _EntradaCache> _entradas = {};
  bool _cargado = false;

  CacheTutor({
    Duration? ttl,
    int? tamanoMaximo,
  })  : _ttl = ttl ?? ttlPorDefecto,
        _tamanoMaximo = tamanoMaximo ?? tamanoMaximoPorDefecto;

  /// Tamaño actual de la caché en memoria. Útil para tests y para el
  /// panel debug.
  int get tamano => _entradas.length;

  /// Recupera la explicación cacheada para una pregunta concreta, o
  /// null si no existe o ha caducado. Caducidades se purgan al vuelo.
  Future<String?> recuperar({
    required String idHabilidad,
    required String pregunta,
    DateTime? ahora,
  }) async {
    await _asegurarCargado();
    final clave = _construirClave(idHabilidad, pregunta);
    final entrada = _entradas[clave];
    if (entrada == null) return null;
    final tiempoActual = ahora ?? DateTime.now();
    if (tiempoActual.difference(entrada.creadoEn) > _ttl) {
      _entradas.remove(clave);
      await _persistir();
      return null;
    }
    return entrada.explicacion;
  }

  /// Guarda una respuesta. Si la caché está llena, evita una entrada
  /// (la más vieja). Si la entrada ya existía la sobreescribe (con
  /// nuevo timestamp).
  Future<void> guardar({
    required String idHabilidad,
    required String pregunta,
    required String explicacion,
    DateTime? ahora,
  }) async {
    await _asegurarCargado();
    final clave = _construirClave(idHabilidad, pregunta);
    final tiempoActual = ahora ?? DateTime.now();
    _entradas[clave] = _EntradaCache(
      explicacion: explicacion,
      creadoEn: tiempoActual,
    );
    if (_entradas.length > _tamanoMaximo) {
      _expulsarMasViejo();
    }
    await _persistir();
  }

  /// Borra todas las entradas. Útil para tests o desde un panel debug.
  Future<void> limpiar() async {
    _entradas.clear();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_claveAlmacen);
    _cargado = true;
  }

  String _construirClave(String idHabilidad, String pregunta) {
    final normalizada =
        pregunta.toLowerCase().trim().replaceAll(RegExp(r'\s+'), ' ');
    return '$idHabilidad|$normalizada';
  }

  void _expulsarMasViejo() {
    if (_entradas.isEmpty) return;
    String? claveMasVieja;
    DateTime? fechaMasVieja;
    for (final entry in _entradas.entries) {
      if (fechaMasVieja == null ||
          entry.value.creadoEn.isBefore(fechaMasVieja)) {
        fechaMasVieja = entry.value.creadoEn;
        claveMasVieja = entry.key;
      }
    }
    if (claveMasVieja != null) {
      _entradas.remove(claveMasVieja);
    }
  }

  Future<void> _asegurarCargado() async {
    if (_cargado) return;
    final prefs = await SharedPreferences.getInstance();
    final crudo = prefs.getString(_claveAlmacen);
    if (crudo != null && crudo.isNotEmpty) {
      try {
        final mapa = jsonDecode(crudo) as Map<String, dynamic>;
        for (final entry in mapa.entries) {
          final valor = entry.value as Map<String, dynamic>;
          _entradas[entry.key] = _EntradaCache(
            explicacion: valor['explicacion'] as String,
            creadoEn: DateTime.parse(valor['creadoEn'] as String),
          );
        }
      } catch (_) {
        // JSON corrupto: empezamos limpio sin romper la app.
        _entradas.clear();
      }
    }
    _cargado = true;
  }

  Future<void> _persistir() async {
    final prefs = await SharedPreferences.getInstance();
    final mapa = <String, Map<String, String>>{};
    for (final entry in _entradas.entries) {
      mapa[entry.key] = {
        'explicacion': entry.value.explicacion,
        'creadoEn': entry.value.creadoEn.toIso8601String(),
      };
    }
    await prefs.setString(_claveAlmacen, jsonEncode(mapa));
  }
}

class _EntradaCache {
  final String explicacion;
  final DateTime creadoEn;
  const _EntradaCache({
    required this.explicacion,
    required this.creadoEn,
  });
}
