import 'dart:convert';

import 'package:nuevo_ser_core/nuevo_ser_core.dart';

import '../dominio/mosaico_arco_1.dart';

/// Persiste las marcas de confianza del Mosaico v2 de un arco. Una
/// clave por arco, blob JSON `{idPieza: "solido"|"probable"|"disputado"}`.
/// El blob es el `content_meta` que sube al endpoint companion
/// `/companion/mosaicos`.
///
/// Namespace: `<prefijoPerfilActivo>mosaico.<idArco>` — por perfil.
///
/// **Migración silenciosa de v1 → v2**: el formato v1 guardaba un
/// mapa `{idPrompt: textoRespuesta}`. Si al cargar encontramos
/// valores que no son una clave de `NivelConfianza` reconocible los
/// descartamos — la Cronista arranca con el Mosaico vacío.
class RepositorioMosaico {
  static const String _sufijo = 'mosaico.';

  final GestorPerfiles _gestor;

  const RepositorioMosaico({required GestorPerfiles gestor})
      : _gestor = gestor;

  Future<String> _clave(String idArco) async {
    final prefijo = await _gestor.prefijoActivo();
    return '$prefijo$_sufijo$idArco';
  }

  /// Mapa idPieza → NivelConfianza. Vacío si no hay nada o si el
  /// blob no se puede deserializar.
  Future<Map<String, NivelConfianza>> cargar(String idArco) async {
    final prefs = await _gestor.prefsInicializadas();
    final crudo = prefs.getString(await _clave(idArco));
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

  /// Sobreescribe el mapa completo del Mosaico. Idempotente.
  Future<void> guardar(
    String idArco,
    Map<String, NivelConfianza> marcas,
  ) async {
    final prefs = await _gestor.prefsInicializadas();
    final serializable = <String, String>{
      for (final entrada in marcas.entries)
        entrada.key: _serializarNivel(entrada.value),
    };
    await prefs.setString(await _clave(idArco), jsonEncode(serializable));
  }

  /// Borra el blob del Mosaico del perfil activo.
  Future<void> borrar(String idArco) async {
    final prefs = await _gestor.prefsInicializadas();
    await prefs.remove(await _clave(idArco));
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
