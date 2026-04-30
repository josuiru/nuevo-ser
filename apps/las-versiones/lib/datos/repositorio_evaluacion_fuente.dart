import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../dominio/brecha.dart';
import '../dominio/evaluacion_fuente.dart';

/// Persiste la respuesta que la Cronista dio a cada fuente en la
/// Fase 3. Una clave por par (brecha, fuente) — `RespuestaEvaluacionFuente`
/// codificada como JSON con los nombres de los enums (lo que devuelve
/// `Enum.name`).
///
/// Namespace: `nuevoser.lasversiones.brecha.<id>.evaluacion.<idFuente>`
/// con string. El blob es pequeño (dos campos) — JSON por extensibilidad
/// futura cuando la rúbrica crezca.
class RepositorioEvaluacionFuente {
  static const String _prefijo = 'nuevoser.lasversiones.brecha.';
  static const String _separador = '.evaluacion.';

  final Future<SharedPreferences> Function() _prefs;

  const RepositorioEvaluacionFuente({
    Future<SharedPreferences> Function() prefs = SharedPreferences.getInstance,
  }) : _prefs = prefs;

  String _clave(String idBrecha, String idFuente) =>
      '$_prefijo$idBrecha$_separador$idFuente';

  String _prefijoBrecha(String idBrecha) =>
      '$_prefijo$idBrecha$_separador';

  /// Carga la respuesta para esta fuente. `null` si no hay nada
  /// guardado o si el blob no se puede deserializar.
  Future<RespuestaEvaluacionFuente?> cargar(
    String idBrecha,
    String idFuente,
  ) async {
    final prefs = await _prefs();
    final crudo = prefs.getString(_clave(idBrecha, idFuente));
    if (crudo == null || crudo.isEmpty) return null;
    try {
      final mapa = jsonDecode(crudo);
      if (mapa is! Map) return null;
      return RespuestaEvaluacionFuente(
        tipoElegido: _tipoDesdeNombre(mapa['tipo'] as String?),
        sesgoElegido: _sesgoDesdeNombre(mapa['sesgo'] as String?),
      );
    } catch (_) {
      return null;
    }
  }

  /// Guarda la respuesta. Sobrescribe si ya había una.
  Future<void> guardar(
    String idBrecha,
    String idFuente,
    RespuestaEvaluacionFuente respuesta,
  ) async {
    final prefs = await _prefs();
    final mapa = <String, String>{
      if (respuesta.tipoElegido != null) 'tipo': respuesta.tipoElegido!.name,
      if (respuesta.sesgoElegido != null)
        'sesgo': respuesta.sesgoElegido!.name,
    };
    await prefs.setString(_clave(idBrecha, idFuente), jsonEncode(mapa));
  }

  /// Mapa idFuente → respuesta para todas las fuentes evaluadas en
  /// esta Brecha. La pantalla la usa para pintar de inicio el estado
  /// de cada tarjeta. Las fuentes sin evaluación no aparecen en el
  /// mapa.
  Future<Map<String, RespuestaEvaluacionFuente>> cargarTodasDeBrecha(
    String idBrecha,
  ) async {
    final prefs = await _prefs();
    final prefijoBrecha = _prefijoBrecha(idBrecha);
    final claves = prefs.getKeys();
    final resultado = <String, RespuestaEvaluacionFuente>{};
    for (final clave in claves) {
      if (!clave.startsWith(prefijoBrecha)) continue;
      final idFuente = clave.substring(prefijoBrecha.length);
      final respuesta = await cargar(idBrecha, idFuente);
      if (respuesta != null) {
        resultado[idFuente] = respuesta;
      }
    }
    return resultado;
  }

  /// Borra todas las evaluaciones de una Brecha. Tests + futuro
  /// "rehacer la Brecha" desde Ajustes.
  Future<void> borrar(String idBrecha) async {
    final prefs = await _prefs();
    final prefijoBrecha = _prefijoBrecha(idBrecha);
    final claves =
        prefs.getKeys().where((k) => k.startsWith(prefijoBrecha)).toList();
    for (final clave in claves) {
      await prefs.remove(clave);
    }
  }

  TipoFuente? _tipoDesdeNombre(String? nombre) {
    if (nombre == null) return null;
    for (final valor in TipoFuente.values) {
      if (valor.name == nombre) return valor;
    }
    return null;
  }

  SesgoFuente? _sesgoDesdeNombre(String? nombre) {
    if (nombre == null) return null;
    for (final valor in SesgoFuente.values) {
      if (valor.name == nombre) return valor;
    }
    return null;
  }
}
