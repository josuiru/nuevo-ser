import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../dominio/habilidad.dart';

/// Persistencia mínima del progreso del jugador: en qué noche va y
/// cuándo abrió la app por última vez. Todo local, sin sincronización,
/// coherente con el principio offline-first de la biblia §2.8.
class RepositorioProgreso {
  static const _claveSiguienteNoche = 'uroto.siguiente_noche';
  static const _claveUltimaAperturaMs = 'uroto.ultima_apertura_ms';
  static const _claveYaVioApertura = 'uroto.ya_vio_apertura';
  static const _claveEsquirlasTotal = 'uroto.esquirlas_total';

  Future<int> cargarSiguienteNoche() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_claveSiguienteNoche) ?? 0;
  }

  Future<void> guardarSiguienteNoche(int indice) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_claveSiguienteNoche, indice);
  }

  Future<bool> yaVioLaApertura() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_claveYaVioApertura) ?? false;
  }

  Future<void> marcarAperturaVista() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_claveYaVioApertura, true);
  }

  Future<DateTime?> cargarUltimaApertura() async {
    final prefs = await SharedPreferences.getInstance();
    final ms = prefs.getInt(_claveUltimaAperturaMs);
    if (ms == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(ms);
  }

  Future<void> guardarAhoraComoUltimaApertura() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(
      _claveUltimaAperturaMs,
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  Future<int> cargarEsquirlas() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_claveEsquirlasTotal) ?? 0;
  }

  Future<void> guardarEsquirlas(int total) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_claveEsquirlasTotal, total);
  }

  String _claveDistritoVisitado(String idDistrito) =>
      'uroto.distrito_visitado.$idDistrito';

  Future<bool> distritoVisitado(String idDistrito) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_claveDistritoVisitado(idDistrito)) ?? false;
  }

  Future<void> marcarDistritoComoVisitado(String idDistrito) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_claveDistritoVisitado(idDistrito), true);
  }

  String _claveFlagNarrativo(String flag) => 'uroto.flag.$flag';

  Future<bool> flagNarrativoActivo(String flag) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_claveFlagNarrativo(flag)) ?? false;
  }

  Future<void> activarFlagNarrativo(String flag) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_claveFlagNarrativo(flag), true);
  }

  static String _claveEstadoHabilidad(String id) =>
      'uroto.habilidad.$id';

  Future<EstadoHabilidad?> cargarEstadoHabilidad(String idHabilidad) async {
    final prefs = await SharedPreferences.getInstance();
    final texto = prefs.getString(_claveEstadoHabilidad(idHabilidad));
    if (texto == null) return null;
    try {
      return EstadoHabilidad.desdeJson(
        jsonDecode(texto) as Map<String, dynamic>,
      );
    } catch (_) {
      // Formato corrupto: borramos para no bloquear al niño.
      await prefs.remove(_claveEstadoHabilidad(idHabilidad));
      return null;
    }
  }

  Future<void> guardarEstadoHabilidad(EstadoHabilidad estado) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _claveEstadoHabilidad(estado.identificadorHabilidad),
      jsonEncode(estado.aJson()),
    );
  }

  /// Útil para reiniciar desde el principio (modo desarrollo o niño que
  /// quiere rejugarlo desde cero).
  Future<void> reiniciar() async {
    final prefs = await SharedPreferences.getInstance();
    final todasLasClaves = prefs.getKeys();
    final clavesUroto =
        todasLasClaves.where((k) => k.startsWith('uroto.')).toList();
    for (final clave in clavesUroto) {
      await prefs.remove(clave);
    }
  }
}
