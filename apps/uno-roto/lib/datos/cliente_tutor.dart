import 'dart:convert';

import 'package:http/http.dart' as http;

import 'cliente_api.dart' show ExcepcionApi;

/// Cliente HTTP del endpoint de tutor. El servidor (plugin WP) hace
/// el proxy a Anthropic con su propio filtro PHP y caché en BD.
///
/// Diseño paralelo a `ClienteApi`:
/// - Sin lógica de negocio: serializa, envía, devuelve respuesta.
/// - Cliente HTTP inyectable para tests.
/// - El backend recibe `idHabilidad` + `pregunta` + `contextoFragmento`
///   y devuelve `{explicacion, fuente: 'cache'|'llm'}`.
/// - Si el servidor rechaza por su propio filtro devuelve 422 con
///   un motivo en castellano que la UI muestra tal cual.
class ClienteTutor {
  final String urlBase;
  final String? hostOverride;
  final Duration tiempoEspera;
  final http.Client _cliente;

  ClienteTutor({
    required this.urlBase,
    http.Client? cliente,
    this.hostOverride,
    this.tiempoEspera = const Duration(seconds: 20),
  }) : _cliente = cliente ?? http.Client();

  void cerrar() => _cliente.close();

  Uri _uri(String ruta) => Uri.parse('$urlBase/wp-json/nuevo-ser/v1$ruta');

  Map<String, String> _cabeceras(String token) {
    // Necesario para esquivar la regla 920330 de mod_security
    // (Empty User Agent Header → 406). Ver `cliente_api.dart`.
    final base = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
      'User-Agent': 'UnoRoto/0.5 (Android)',
      'Accept': 'application/json',
    };
    if (hostOverride != null) {
      base['Host'] = hostOverride!;
    }
    return base;
  }

  /// POST /tutor/explicar. Pide una explicación al tutor para una
  /// habilidad concreta. El backend decide si tira de caché o llama
  /// a Anthropic.
  Future<RespuestaTutor> explicar({
    required String token,
    required String idHabilidad,
    required String pregunta,
    String? contextoFragmento,
  }) async {
    final r = await _cliente
        .post(
          _uri('/tutor/explicar'),
          headers: _cabeceras(token),
          body: jsonEncode({
            'id_habilidad': idHabilidad,
            'pregunta': pregunta,
            if (contextoFragmento != null)
              'contexto_fragmento': contextoFragmento,
          }),
        )
        .timeout(tiempoEspera);
    final cuerpo = _decodificar(r);
    return RespuestaTutor(
      explicacion: cuerpo['explicacion'] as String,
      desdeCache: (cuerpo['fuente'] as String?) == 'cache',
    );
  }

  Map<String, dynamic> _decodificar(http.Response respuesta) {
    if (respuesta.statusCode >= 200 && respuesta.statusCode < 300) {
      if (respuesta.body.isEmpty) return {};
      return jsonDecode(respuesta.body) as Map<String, dynamic>;
    }
    String mensaje = 'HTTP ${respuesta.statusCode}';
    try {
      final cuerpo = jsonDecode(respuesta.body);
      if (cuerpo is Map && cuerpo['error'] is String) {
        mensaje = cuerpo['error'] as String;
      } else if (cuerpo is Map && cuerpo['message'] is String) {
        mensaje = cuerpo['message'] as String;
      }
    } catch (_) {
      // Cuerpo no parseable como JSON.
    }
    throw ExcepcionApi(codigo: respuesta.statusCode, mensaje: mensaje);
  }
}

class RespuestaTutor {
  final String explicacion;
  final bool desdeCache;

  const RespuestaTutor({
    required this.explicacion,
    required this.desdeCache,
  });
}
