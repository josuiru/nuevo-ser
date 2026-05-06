import 'dart:convert';

import 'package:nuevo_ser_core/nuevo_ser_core.dart';

import '../dominio/brecha.dart';

/// Persiste qué afirmaciones canónicas ha declarado la Cronista en
/// la Fase 4 de Reconstrucción y con qué nivel de confianza. Por
/// perfil.
///
/// Namespace: `<prefijoPerfilActivo>brecha.<id>.reconstruccion` con
/// un único blob JSON `{idAfirmacion: nombreNivel, …}`.
class RepositorioReconstruccion {
  static const String _sufijoBase = 'brecha.';
  static const String _sufijoFinal = '.reconstruccion';

  final GestorPerfiles _gestor;

  const RepositorioReconstruccion({required GestorPerfiles gestor})
      : _gestor = gestor;

  Future<String> _clave(String idBrecha) async {
    final prefijo = await _gestor.prefijoActivo();
    return '$prefijo$_sufijoBase$idBrecha$_sufijoFinal';
  }

  /// Carga el mapa `idAfirmacion → nivel` para esta Brecha del
  /// perfil activo.
  Future<Map<String, NivelConfianza>> cargar(String idBrecha) async {
    final prefs = await _gestor.prefsInicializadas();
    final crudo = prefs.getString(await _clave(idBrecha));
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
    final prefs = await _gestor.prefsInicializadas();
    final mapaSerializable = <String, String>{
      for (final entrada in declaraciones.entries)
        entrada.key: entrada.value.name,
    };
    await prefs.setString(
      await _clave(idBrecha),
      jsonEncode(mapaSerializable),
    );
  }

  /// Borra la reconstrucción de la Brecha del perfil activo.
  Future<void> borrar(String idBrecha) async {
    final prefs = await _gestor.prefsInicializadas();
    await prefs.remove(await _clave(idBrecha));
  }

  NivelConfianza? _nivelDesdeNombre(String nombre) {
    for (final valor in NivelConfianza.values) {
      if (valor.name == nombre) return valor;
    }
    return null;
  }
}
