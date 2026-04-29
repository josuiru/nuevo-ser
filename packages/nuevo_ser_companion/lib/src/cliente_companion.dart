import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nuevo_ser_core/nuevo_ser_core.dart';

import 'cuaderno/entrada_cuaderno.dart';

/// Cliente HTTP de los endpoints de acompañamiento del plugin
/// `nuevo-ser-core` (`/wp-json/nuevo-ser/v1/companion/*`).
///
/// Mismo diseño que [ClienteApi] del core: sin lógica de negocio,
/// cliente HTTP inyectable para tests, errores tipados con
/// [ExcepcionApi].
class ClienteCompanion {
  /// URL base del backend, sin barra final.
  final String urlBase;

  /// Si se define, se envía como cabecera `Host:` en cada petición —
  /// necesario cuando apuntamos a Local WP por IP/puerto en vez del
  /// dominio virtual.
  final String? hostOverride;

  final Duration tiempoEspera;
  final http.Client _cliente;

  ClienteCompanion({
    required this.urlBase,
    http.Client? cliente,
    this.hostOverride,
    this.tiempoEspera = const Duration(seconds: 10),
  }) : _cliente = cliente ?? http.Client();

  void cerrar() => _cliente.close();

  Uri _uri(String ruta) => Uri.parse('$urlBase/wp-json/nuevo-ser/v1$ruta');

  Map<String, String> _cabeceras({required String token}) {
    final base = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'User-Agent': 'NuevoSerCompanion/0.1',
      'Authorization': 'Bearer $token',
    };
    if (hostOverride != null) {
      base['Host'] = hostOverride!;
    }
    return base;
  }

  /// POST /companion/cuaderno/entries
  ///
  /// Crea una entrada del cuaderno para el niño dueño del [token].
  /// Devuelve la entrada con `id` y `createdAt` ya asignados por el
  /// servidor; los campos opcionales (`contentMeta`, `anchoredTo`) se
  /// preservan del original.
  ///
  /// Lanza [ExcepcionApi] con código 400 si el servidor rechaza la
  /// validación (con `data.invalid_fields` accesible vía
  /// `excepcion.detalle`); 401 si el token no es válido; 5xx en otros
  /// fallos.
  Future<EntradaCuaderno> crearEntradaCuaderno({
    required String token,
    required EntradaCuaderno entrada,
  }) async {
    final r = await _cliente
        .post(
          _uri('/companion/cuaderno/entries'),
          headers: _cabeceras(token: token),
          body: jsonEncode(entrada.aJsonParaCrear()),
        )
        .timeout(tiempoEspera);
    final cuerpo = _decodificar(r);
    return EntradaCuaderno.desdeRespuestaCreacion(
      cuerpo,
      contentMetaOriginal: entrada.contentMeta,
      anchoredToOriginal: entrada.anchoredTo,
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
      if (cuerpo is Map) {
        // WordPress serializa WP_Error como {code, message, data: {...}}.
        // El campo `error` es el shape custom de NS_Endpoints; aceptamos ambos.
        if (cuerpo['message'] is String) {
          mensaje = cuerpo['message'] as String;
        } else if (cuerpo['error'] is String) {
          mensaje = cuerpo['error'] as String;
        }
      }
    } catch (_) {
      // Cuerpo no parseable como JSON; usamos mensaje genérico.
    }
    throw ExcepcionApi(
      codigo: respuesta.statusCode,
      mensaje: mensaje,
    );
  }
}
