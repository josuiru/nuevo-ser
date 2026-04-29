import 'dart:convert';

import 'package:nuevo_ser_core/nuevo_ser_core.dart';

import 'disparador_tutor.dart';

/// Persistencia de [EstadoTutorHabilidad] por perfil sobre
/// [GestorPerfiles].
///
/// Las claves resultan `<ns>.perfil.<id>.<sufijo><idHabilidad>` —
/// shape histórico de Uno Roto, así que las instalaciones existentes
/// siguen leyendo donde guardaron.
///
/// Auto-curación: si el JSON está corrupto, [cargar] borra la clave y
/// devuelve [EstadoTutorHabilidad] por defecto. La oferta del tutor
/// nunca debe romperse por un fichero malformado — el peor caso
/// aceptable es perder los contadores de fallos consecutivos.
class RepositorioEstadoTutor {
  RepositorioEstadoTutor({
    required this.gestor,
    this.sufijoBase = 'tutor.estado.',
  });

  final GestorPerfiles gestor;
  final String sufijoBase;

  Future<String> _claveDe(String idHabilidad) async {
    return '${await gestor.prefijoActivo()}$sufijoBase$idHabilidad';
  }

  Future<EstadoTutorHabilidad> cargar(String idHabilidad) async {
    final prefs = await gestor.prefsInicializadas();
    final clave = await _claveDe(idHabilidad);
    final texto = prefs.getString(clave);
    if (texto == null) return const EstadoTutorHabilidad();
    try {
      return EstadoTutorHabilidad.desdeJson(
        jsonDecode(texto) as Map<String, dynamic>,
      );
    } catch (_) {
      await prefs.remove(clave);
      return const EstadoTutorHabilidad();
    }
  }

  Future<void> guardar(
    String idHabilidad,
    EstadoTutorHabilidad estado,
  ) async {
    final prefs = await gestor.prefsInicializadas();
    final clave = await _claveDe(idHabilidad);
    await prefs.setString(clave, jsonEncode(estado.aJson()));
  }
}
