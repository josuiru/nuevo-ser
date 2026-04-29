import 'dart:convert';

import '../mastery/habilidad.dart';
import '../sync/fecha_mysql.dart';
import 'gestor_perfiles.dart';

/// Persistencia de [EstadoHabilidad] por perfil sobre [GestorPerfiles].
///
/// Cada juego instancia este repositorio con el gestor de su namespace
/// y, opcionalmente, su propio sufijo. Las claves resultan
/// `<ns>.perfil.<id>.<sufijo><idHabilidad>` — exactamente el shape
/// histórico de Uno Roto, así que las instalaciones existentes siguen
/// leyendo donde guardaron.
///
/// Auto-curación: si el JSON está corrupto, [cargar] borra la clave y
/// devuelve null en lugar de propagar la excepción. La pedagogía
/// recupera con un nuevo intento; la persistencia no debe bloquear al
/// niño por un fichero malformado.
class RepositorioHabilidades {
  RepositorioHabilidades({
    required this.gestor,
    this.sufijoBase = 'habilidad.',
  });

  final GestorPerfiles gestor;

  /// Sufijo (sin prefijo de perfil) que precede al id de cada
  /// habilidad. Por convención: `'habilidad.'`.
  final String sufijoBase;

  Future<String> _claveDe(String idHabilidad) async {
    return '${await gestor.prefijoActivo()}$sufijoBase$idHabilidad';
  }

  Future<String> _prefijoEnPerfilActivo() async {
    return '${await gestor.prefijoActivo()}$sufijoBase';
  }

  Future<EstadoHabilidad?> cargar(String idHabilidad) async {
    final prefs = await gestor.prefsInicializadas();
    final clave = await _claveDe(idHabilidad);
    final texto = prefs.getString(clave);
    if (texto == null) return null;
    try {
      return EstadoHabilidad.desdeJson(
        jsonDecode(texto) as Map<String, dynamic>,
      );
    } catch (_) {
      await prefs.remove(clave);
      return null;
    }
  }

  Future<void> guardar(EstadoHabilidad estado) async {
    final prefs = await gestor.prefsInicializadas();
    final clave = await _claveDe(estado.identificadorHabilidad);
    await prefs.setString(clave, jsonEncode(estado.aJson()));
  }

  /// Devuelve todos los estados guardados para el perfil activo.
  /// Las entradas con JSON corrupto se ignoran silenciosamente — la
  /// idea es que un único fichero malformado no rompa el sync ni la
  /// vista del cuaderno.
  Future<List<EstadoHabilidad>> exportarTodos() async {
    final prefs = await gestor.prefsInicializadas();
    final prefijo = await _prefijoEnPerfilActivo();
    final estados = <EstadoHabilidad>[];
    for (final clave in prefs.getKeys()) {
      if (!clave.startsWith(prefijo)) continue;
      final crudo = prefs.getString(clave);
      if (crudo == null) continue;
      try {
        estados.add(EstadoHabilidad.desdeJson(
          jsonDecode(crudo) as Map<String, dynamic>,
        ));
      } catch (_) {
        // Estado corrupto: lo saltamos sin romper el sync.
      }
    }
    return estados;
  }

  /// Forma serializada que espera el backend WordPress
  /// (`POST /sync/progress`). Convierte las claves cortas internas a
  /// las largas del esquema BD y aplica `aFechaMysql` a las fechas.
  Future<List<Map<String, dynamic>>> exportarParaSync() async {
    final estados = await exportarTodos();
    final ahora = aFechaMysql(DateTime.now());
    return [
      for (final estado in estados)
        {
          'id_habilidad': estado.identificadorHabilidad,
          'nivel': estado.nivel.valor,
          'precision_ponderada': estado.precision,
          'tiempo_mediano_seg': estado.tiempoMedianoSeg,
          'total_exposiciones': estado.totalExposiciones,
          'sesiones_consecutivas_buenas': estado.sesionesConsecutivasBuenas,
          'ultima_practica': aFechaMysql(estado.ultimaPractica),
          'intentos_recientes':
              estado.intentosRecientes.map((i) => i.aJson()).toList(),
          'actualizado_en': ahora,
        },
    ];
  }
}
