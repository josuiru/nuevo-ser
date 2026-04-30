import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../dominio/mosaico_arco_1.dart';

/// Persiste las marcas de confianza del Mosaico v2 de un arco. Una
/// clave por arco, blob JSON `{idVineta: "solido"|"probable"|"disputado"}`.
/// Cuando el cliente companion (`POST /companion/mosaicos`) se cablee,
/// este blob será el `content_meta` que sube al backend; mientras
/// tanto vive sólo en local.
///
/// Namespace: `nuevoser.lasversiones.mosaico.<idArco>`.
///
/// **Migración silenciosa de v1 → v2**: el formato v1 (anterior a
/// F8.7) guardaba un mapa `{idPrompt: textoRespuesta}` con los tres
/// prompts de texto del Mosaico antiguo. Si al cargar encontramos
/// valores que no son una clave de `NivelConfianza` reconocible
/// (porque eran texto libre), descartamos la entrada — la Cronista
/// arranca con el Mosaico vacío y elige cuántas viñetas marca.
/// La interfaz no presiona, así que la pérdida no es destructiva.
class RepositorioMosaico {
  static const String _prefijo = 'nuevoser.lasversiones.mosaico.';

  final Future<SharedPreferences> Function() _prefs;

  const RepositorioMosaico({
    Future<SharedPreferences> Function() prefs = SharedPreferences.getInstance,
  }) : _prefs = prefs;

  String _clave(String idArco) => '$_prefijo$idArco';

  /// Mapa idVineta → NivelConfianza. Vacío si no hay nada o si el
  /// blob no se puede deserializar. Las entradas con valor que no
  /// coincide con una clave de `NivelConfianza` se descartan.
  Future<Map<String, NivelConfianza>> cargar(String idArco) async {
    final prefs = await _prefs();
    final crudo = prefs.getString(_clave(idArco));
    if (crudo == null || crudo.isEmpty) return const {};
    try {
      final mapa = jsonDecode(crudo);
      if (mapa is! Map) return const {};
      final resultado = <String, NivelConfianza>{};
      mapa.forEach((clave, valor) {
        if (clave is! String || valor is! String) return;
        final nivel = _parsearNivel(valor);
        if (nivel != null) resultado[clave] = nivel;
      });
      return resultado;
    } catch (_) {
      return const {};
    }
  }

  /// Sobreescribe el mapa completo. Idempotente.
  Future<void> guardar(
    String idArco,
    Map<String, NivelConfianza> marcas,
  ) async {
    final prefs = await _prefs();
    final serializable = <String, String>{
      for (final entrada in marcas.entries)
        entrada.key: _serializarNivel(entrada.value),
    };
    await prefs.setString(_clave(idArco), jsonEncode(serializable));
  }

  /// Borra el blob del Mosaico. Tests + futuro "rehacer este
  /// Mosaico" desde Ajustes.
  Future<void> borrar(String idArco) async {
    final prefs = await _prefs();
    await prefs.remove(_clave(idArco));
  }

  static NivelConfianza? _parsearNivel(String crudo) {
    switch (crudo) {
      case 'solido':
        return NivelConfianza.solido;
      case 'probable':
        return NivelConfianza.probable;
      case 'disputado':
        return NivelConfianza.disputado;
    }
    return null;
  }

  static String _serializarNivel(NivelConfianza nivel) {
    switch (nivel) {
      case NivelConfianza.solido:
        return 'solido';
      case NivelConfianza.probable:
        return 'probable';
      case NivelConfianza.disputado:
        return 'disputado';
    }
  }
}
