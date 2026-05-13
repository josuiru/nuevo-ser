// Repositorio de familiaridad del niño con remitentes recurrentes.
//
// Persistencia local con shared_preferences. Por perfil — cada niño
// tiene su propio mapa.
//
// Decisión del monorepo (CLAUDE.md raíz): prefijo nuevoser.<juego>.*
// para juegos nuevos. Aquí: nuevoser.descifrador.perfil.<id>.familiaridad.

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../dominio/familiaridad_remitente.dart';
import '../dominio/voz_remitente.dart';

/// Repositorio persistente de la familiaridad del niño con los ocho
/// remitentes recurrentes.
///
/// El repositorio se construye con el ID del perfil del niño activo.
/// Si se cambia de perfil, se construye otro repositorio.
class RepositorioFamiliaridad {
  RepositorioFamiliaridad({
    required this.idPerfil,
    SharedPreferences? preferenciasInyectadas,
  }) : _preferenciasInyectadas = preferenciasInyectadas;

  /// ID del perfil del niño activo. Forma parte de la clave de
  /// persistencia para aislar perfiles entre sí.
  final String idPerfil;

  /// Inyectable para tests. En producción, null — el repositorio carga
  /// SharedPreferences bajo demanda.
  final SharedPreferences? _preferenciasInyectadas;

  /// Clave de persistencia en SharedPreferences.
  String get _clave => 'nuevoser.descifrador.perfil.$idPerfil.familiaridad';

  Future<SharedPreferences> _preferencias() async {
    return _preferenciasInyectadas ?? await SharedPreferences.getInstance();
  }

  /// Carga el estado actual. Devuelve `FamiliaridadRemitente.inicial()`
  /// si el perfil es nuevo o si los datos están corruptos (la
  /// corrupción se trata como reset — el cuaderno se reconstruye
  /// trabajando piezas, no es información catastrófica).
  Future<FamiliaridadRemitente> cargar() async {
    final preferencias = await _preferencias();
    final json = preferencias.getString(_clave);
    if (json == null || json.isEmpty) {
      return FamiliaridadRemitente.inicial();
    }
    try {
      final mapa = jsonDecode(json) as Map<String, dynamic>;
      return FamiliaridadRemitente.deserializar(mapa);
    } catch (_) {
      return FamiliaridadRemitente.inicial();
    }
  }

  /// Guarda el estado. La llamada típica es:
  ///
  ///   final actual = await repo.cargar();
  ///   final siguiente = actual.conPiezaTrabajadaCon(remitente);
  ///   await repo.guardar(siguiente);
  Future<void> guardar(FamiliaridadRemitente estado) async {
    final preferencias = await _preferencias();
    final mapa = estado.serializar();
    await preferencias.setString(_clave, jsonEncode(mapa));
  }

  /// Conveniencia: registra una pieza trabajada con el remitente dado y
  /// devuelve el nuevo estado. Cero ceremonia para el llamador.
  ///
  /// Si el remitente es null (voz puntual no recurrente), no escribe.
  /// Devuelve el estado actual sin tocar.
  Future<FamiliaridadRemitente> registrarPiezaTrabajada(
    VozRemitente? remitente,
  ) async {
    final actual = await cargar();
    if (remitente == null) return actual;
    final siguiente = actual.conPiezaTrabajadaCon(remitente);
    await guardar(siguiente);
    return siguiente;
  }

  /// Borra todo el estado de familiaridad del perfil. Manifiesto madre
  /// §7 — el cuidador o niño mayor puede borrar todo.
  Future<void> borrar() async {
    final preferencias = await _preferencias();
    await preferencias.remove(_clave);
  }
}
