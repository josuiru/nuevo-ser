import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../dominio/brecha.dart';

/// Persiste qué afirmaciones canónicas ha declarado la Cronista en
/// la Fase 4 de Reconstrucción y con qué nivel de confianza. Una
/// afirmación se considera **incluida en su versión** si tiene una
/// entrada con un `NivelConfianza` asignado; ausente significa "no
/// la sostengo".
///
/// Namespace: `nuevoser.lasversiones.brecha.<id>.reconstruccion` con
/// un único blob JSON `{idAfirmacion: nombreNivel, …}`. Un blob por
/// brecha en lugar de uno por afirmación porque la Fase 4 carga
/// siempre todas a la vez y el conjunto es pequeño.
class RepositorioReconstruccion {
  static const String _prefijo = 'nuevoser.lasversiones.brecha.';
  static const String _sufijo = '.reconstruccion';

  final Future<SharedPreferences> Function() _prefs;

  const RepositorioReconstruccion({
    Future<SharedPreferences> Function() prefs = SharedPreferences.getInstance,
  }) : _prefs = prefs;

  String _clave(String idBrecha) => '$_prefijo$idBrecha$_sufijo';

  /// Carga el mapa `idAfirmacion → nivel` para esta Brecha. Mapa
  /// vacío si no hay nada o si el blob está corrupto.
  Future<Map<String, NivelConfianza>> cargar(String idBrecha) async {
    final prefs = await _prefs();
    final crudo = prefs.getString(_clave(idBrecha));
    if (crudo == null || crudo.isEmpty) return const {};
    try {
      final mapa = jsonDecode(crudo);
      if (mapa is! Map) return const {};
      final resultado = <String, NivelConfianza>{};
      mapa.forEach((clave, valor) {
        if (clave is! String || valor is! String) return;
        final nivel = _nivelDesdeNombre(valor);
        if (nivel != null) {
          resultado[clave] = nivel;
        }
      });
      return resultado;
    } catch (_) {
      return const {};
    }
  }

  /// Sobreescribe el mapa completo. Idempotente.
  Future<void> guardar(
    String idBrecha,
    Map<String, NivelConfianza> declaraciones,
  ) async {
    final prefs = await _prefs();
    final mapaSerializable = <String, String>{
      for (final entrada in declaraciones.entries)
        entrada.key: entrada.value.name,
    };
    await prefs.setString(_clave(idBrecha), jsonEncode(mapaSerializable));
  }

  /// Borra la reconstrucción de la Brecha. Tests + futuro "rehacer
  /// la Brecha" desde Ajustes.
  Future<void> borrar(String idBrecha) async {
    final prefs = await _prefs();
    await prefs.remove(_clave(idBrecha));
  }

  NivelConfianza? _nivelDesdeNombre(String nombre) {
    for (final valor in NivelConfianza.values) {
      if (valor.name == nombre) return valor;
    }
    return null;
  }
}
