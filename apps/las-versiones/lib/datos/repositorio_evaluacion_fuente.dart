import 'dart:convert';

import 'package:nuevo_ser_core/nuevo_ser_core.dart';

import '../dominio/brecha.dart';
import '../dominio/evaluacion_fuente.dart';

/// Persiste la respuesta que la Cronista dio a cada fuente en la
/// Fase 3. Una clave por par (brecha, fuente) — `RespuestaEvaluacionFuente`
/// codificada como JSON con los nombres de los enums (lo que devuelve
/// `Enum.name`).
///
/// Namespace: `<prefijoPerfilActivo>brecha.<id>.evaluacion.<idFuente>`
/// — el prefijo de perfil viene del [GestorPerfiles] del core.
class RepositorioEvaluacionFuente {
  static const String _sufijoBrecha = 'brecha.';
  static const String _separador = '.evaluacion.';

  final GestorPerfiles _gestor;

  const RepositorioEvaluacionFuente({required GestorPerfiles gestor})
      : _gestor = gestor;

  Future<String> _clave(String idBrecha, String idFuente) async {
    final prefijo = await _gestor.prefijoActivo();
    return '$prefijo$_sufijoBrecha$idBrecha$_separador$idFuente';
  }

  Future<String> _prefijoBrecha(String idBrecha) async {
    final prefijo = await _gestor.prefijoActivo();
    return '$prefijo$_sufijoBrecha$idBrecha$_separador';
  }

  /// Carga la respuesta para esta fuente. `null` si no hay nada
  /// guardado o si el blob no se puede deserializar.
  Future<RespuestaEvaluacionFuente?> cargar(
    String idBrecha,
    String idFuente,
  ) async {
    final prefs = await _gestor.prefsInicializadas();
    final crudo = prefs.getString(await _clave(idBrecha, idFuente));
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
    final prefs = await _gestor.prefsInicializadas();
    final mapa = <String, String>{
      if (respuesta.tipoElegido != null) 'tipo': respuesta.tipoElegido!.name,
      if (respuesta.sesgoElegido != null)
        'sesgo': respuesta.sesgoElegido!.name,
    };
    await prefs.setString(
      await _clave(idBrecha, idFuente),
      jsonEncode(mapa),
    );
  }

  /// Mapa idFuente → respuesta para todas las fuentes evaluadas en
  /// esta Brecha.
  Future<Map<String, RespuestaEvaluacionFuente>> cargarTodasDeBrecha(
    String idBrecha,
  ) async {
    final prefs = await _gestor.prefsInicializadas();
    final prefijoBrecha = await _prefijoBrecha(idBrecha);
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

  /// Borra todas las evaluaciones de una Brecha del perfil actual.
  Future<void> borrar(String idBrecha) async {
    final prefs = await _gestor.prefsInicializadas();
    final prefijoBrecha = await _prefijoBrecha(idBrecha);
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
