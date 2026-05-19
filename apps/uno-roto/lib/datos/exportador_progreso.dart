import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'repositorio_progreso.dart';

/// Exporta e importa el progreso del perfil activo como JSON
/// portable. Se introdujo el 2026-05-19 tras el incidente con
/// `flutter install` que dejó al tester sin app y sin progreso —
/// sin sync activa al backend, la única copia de los datos vivía en
/// SharedPreferences locales y se perdió con la desinstalación.
///
/// El JSON contiene:
/// - `version`: versión del formato (por si cambia el shape en el
///   futuro y hay que migrar imports antiguos).
/// - `perfil`: el slug del perfil exportado (informativo, para que el
///   adulto vea de cuál es la copia).
/// - `exportadoEn`: ISO8601 UTC.
/// - `entradas`: lista de `{clave, tipo, valor}`. La clave es el
///   **sufijo** sin el prefijo `uroto.perfil.<id>.` — la importación
///   lo reconstruye con el prefijo del perfil activo en destino, así
///   que la copia de "principal" se puede restaurar sobre "alex" si
///   el adulto quiere.
class ExportadorProgreso {
  ExportadorProgreso(this._repo);

  final RepositorioProgreso _repo;

  /// Versión del shape del JSON. Si en el futuro cambiamos el contrato
  /// (renombrar sufijos, mover de String a List, etc.) la importación
  /// puede detectar y migrar/rechazar.
  static const int versionFormato = 1;

  /// Sufijo (sin prefijo) de la clave que guarda el ID del perfil
  /// activo. Es información GLOBAL (no por-perfil), así que no entra
  /// en el export del perfil — al importar, el destino sigue siendo
  /// el perfil activo actual.
  static const _clavesGlobalesExcluidas = <String>{
    'uroto.token_backend',
    'uroto.email_backend',
    'uroto.audio.version_local',
    'uroto.audio.sugerencia_vista',
    'uroto.idioma_app',
    'uroto.perfil_activo_id',
    'uroto.perfiles_lista',
  };

  /// Serializa el progreso del perfil activo a un JSON string.
  /// Lanza si no hay claves del perfil — caso raro pero posible si se
  /// llama justo tras crear el perfil sin haber jugado nada.
  Future<String> exportarPerfilActivoComoJson() async {
    final prefs = await SharedPreferences.getInstance();
    final idPerfil = await _repo.idPerfilActivo();
    final prefijo = 'uroto.perfil.$idPerfil.';
    final entradas = <Map<String, dynamic>>[];
    for (final clave in prefs.getKeys()) {
      if (!clave.startsWith(prefijo)) continue;
      if (_clavesGlobalesExcluidas.contains(clave)) continue;
      final valor = prefs.get(clave);
      if (valor == null) continue;
      entradas.add({
        'clave': clave.substring(prefijo.length),
        'tipo': _tipoDeValor(valor),
        'valor': _serializarValor(valor),
      });
    }
    // Orden estable para que el diff entre dos exports del mismo
    // perfil sea legible y los tests sean deterministas.
    entradas.sort((a, b) =>
        (a['clave'] as String).compareTo(b['clave'] as String));
    final json = {
      'version': versionFormato,
      'perfil': idPerfil,
      'exportadoEn': DateTime.now().toUtc().toIso8601String(),
      'entradas': entradas,
    };
    return const JsonEncoder.withIndent('  ').convert(json);
  }

  /// Lee un JSON producido por [exportarPerfilActivoComoJson] y
  /// reemplaza el progreso del perfil activo con sus contenidos.
  ///
  /// **Destructivo**: borra primero todas las claves del perfil
  /// activo y luego escribe las del JSON. Las claves globales (token,
  /// idioma, etc.) y los datos de otros perfiles no se tocan.
  ///
  /// Devuelve cuántas entradas se importaron, para que la UI lo
  /// muestre como confirmación.
  ///
  /// Lanza [FormatException] si el JSON está mal formado o el shape
  /// no coincide. La pantalla debe atrapar y mostrar el mensaje sin
  /// dejar al usuario con la duda de si el progreso se restauró.
  Future<int> importarPerfilActivoDesdeJson(String jsonString) async {
    final dynamic decoded;
    try {
      decoded = jsonDecode(jsonString);
    } catch (e) {
      throw const FormatException('JSON inválido: no se pudo decodificar.');
    }
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('JSON inválido: esperaba un objeto.');
    }
    final version = decoded['version'];
    if (version is! int || version > versionFormato) {
      throw FormatException(
          'Versión del backup ($version) no soportada por esta app '
          '(soporta hasta v$versionFormato).');
    }
    final entradas = decoded['entradas'];
    if (entradas is! List) {
      throw const FormatException(
          'JSON inválido: falta la lista de entradas.');
    }

    final prefs = await SharedPreferences.getInstance();
    final idPerfil = await _repo.idPerfilActivo();
    final prefijo = 'uroto.perfil.$idPerfil.';

    // Borra primero el progreso actual del perfil para que el import
    // sea limpio — sin esto, claves que el backup NO tenía se
    // quedarían mezcladas con el progreso restaurado y darían
    // estados inconsistentes (p. ej. flags narrativos viejos
    // sobreviviendo a una restauración de "empezar de cero").
    final clavesAEliminar = prefs
        .getKeys()
        .where((k) => k.startsWith(prefijo))
        .where((k) => !_clavesGlobalesExcluidas.contains(k))
        .toList();
    for (final clave in clavesAEliminar) {
      await prefs.remove(clave);
    }

    var importadas = 0;
    for (final entradaDynamic in entradas) {
      if (entradaDynamic is! Map<String, dynamic>) continue;
      final sufijo = entradaDynamic['clave'];
      final tipo = entradaDynamic['tipo'];
      final valor = entradaDynamic['valor'];
      if (sufijo is! String || tipo is! String) continue;
      final claveCompleta = '$prefijo$sufijo';
      if (_clavesGlobalesExcluidas.contains(claveCompleta)) continue;
      await _escribirValor(prefs, claveCompleta, tipo, valor);
      importadas++;
    }
    return importadas;
  }

  String _tipoDeValor(Object valor) {
    if (valor is String) return 'string';
    if (valor is int) return 'int';
    if (valor is double) return 'double';
    if (valor is bool) return 'bool';
    if (valor is List<String>) return 'stringList';
    return 'string';
  }

  Object? _serializarValor(Object valor) {
    if (valor is List<String>) return valor;
    return valor;
  }

  Future<void> _escribirValor(
    SharedPreferences prefs,
    String clave,
    String tipo,
    Object? valor,
  ) async {
    switch (tipo) {
      case 'string':
        if (valor is String) await prefs.setString(clave, valor);
        break;
      case 'int':
        if (valor is int) await prefs.setInt(clave, valor);
        break;
      case 'double':
        if (valor is num) await prefs.setDouble(clave, valor.toDouble());
        break;
      case 'bool':
        if (valor is bool) await prefs.setBool(clave, valor);
        break;
      case 'stringList':
        if (valor is List) {
          await prefs.setStringList(
            clave,
            valor.whereType<String>().toList(),
          );
        }
        break;
    }
  }
}
