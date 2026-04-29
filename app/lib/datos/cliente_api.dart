import 'dart:convert';

import 'package:http/http.dart' as http;

/// Cliente HTTP del plugin WordPress `uno-roto-core`. Encapsula los
/// cinco endpoints del doc 03 §5:
///
///   POST /register
///   POST /login
///   GET  /progress              (JWT)
///   POST /sync/progress         (JWT)
///   DELETE /account             (JWT)
///
/// Diseño:
/// - Sin lógica de negocio: serializa entradas, envía, devuelve
///   respuestas ya decodificadas.
/// - Cliente HTTP inyectable — tests usan `http.MockClient`.
/// - Errores tipados vía `ExcepcionApi`.
class ClienteApi {
  /// URL base del backend, sin barra final. Ej: `https://unoroto.example.org`.
  /// En desarrollo con Local WP puede ser `http://127.0.0.1:10063` + el
  /// parámetro [hostOverride] a `uno-roto.local`.
  final String urlBase;

  /// Si se define, se envía como cabecera `Host:` en cada petición.
  /// Necesario cuando apuntamos a un nginx de Local WP por IP/puerto en
  /// vez del dominio virtual (`http://127.0.0.1:10063` con Host
  /// `uno-roto.local`).
  final String? hostOverride;

  /// Timeout para cada petición. 10s es amplio para conexiones móviles.
  final Duration tiempoEspera;

  /// Cliente HTTP. Se inyecta para tests; en producción usa el default.
  final http.Client _cliente;

  ClienteApi({
    required this.urlBase,
    http.Client? cliente,
    this.hostOverride,
    this.tiempoEspera = const Duration(seconds: 10),
  }) : _cliente = cliente ?? http.Client();

  void cerrar() => _cliente.close();

  Uri _uri(String ruta) => Uri.parse('$urlBase/wp-json/uno-roto/v1$ruta');

  Map<String, String> _cabeceras({String? token}) {
    // Importante: el WAF de Apache (mod_security CRS) rechaza con 406
    // las peticiones sin User-Agent — el package:http de Dart en
    // Android no lo añade por defecto. Lo fijamos siempre.
    final base = {
      'Content-Type': 'application/json',
      'User-Agent': 'UnoRoto/0.5 (Android)',
      'Accept': 'application/json',
    };
    if (token != null && token.isNotEmpty) {
      base['Authorization'] = 'Bearer $token';
    }
    if (hostOverride != null) {
      base['Host'] = hostOverride!;
    }
    return base;
  }

  /// POST /register. Crea tutor + niño y devuelve `{token, nino_id,
  /// usuario_id}`.
  Future<RespuestaAuth> registrar({
    required String email,
    required String password,
    required String nombreTutor,
    required String nombreNino,
    String locale = 'es',
  }) async {
    final r = await _cliente
        .post(
          _uri('/register'),
          headers: _cabeceras(),
          body: jsonEncode({
            'email': email,
            'password': password,
            'nombre_tutor': nombreTutor,
            'nombre_nino': nombreNino,
            'locale': locale,
          }),
        )
        .timeout(tiempoEspera);
    final cuerpo = _decodificar(r);
    return RespuestaAuth(
      token: cuerpo['token'] as String,
      ninoId: (cuerpo['nino_id'] as num).toInt(),
      usuarioId: (cuerpo['usuario_id'] as num?)?.toInt(),
    );
  }

  /// POST /login. Devuelve token válido ~30 días.
  Future<RespuestaAuth> iniciarSesion({
    required String email,
    required String password,
  }) async {
    final r = await _cliente
        .post(
          _uri('/login'),
          headers: _cabeceras(),
          body: jsonEncode({'email': email, 'password': password}),
        )
        .timeout(tiempoEspera);
    final cuerpo = _decodificar(r);
    return RespuestaAuth(
      token: cuerpo['token'] as String,
      ninoId: (cuerpo['nino_id'] as num).toInt(),
    );
  }

  /// GET /progress. Devuelve el estado completo del niño tal como
  /// está en el servidor.
  Future<Map<String, dynamic>> obtenerProgreso(String token) async {
    final r = await _cliente
        .get(_uri('/progress'), headers: _cabeceras(token: token))
        .timeout(tiempoEspera);
    return _decodificar(r);
  }

  /// POST /sync/progress. Envía el estado local del cliente y
  /// recibe el resultado del merge LWW del servidor.
  Future<Map<String, dynamic>> sincronizar({
    required String token,
    required Map<String, dynamic> progreso,
    required List<Map<String, dynamic>> habilidades,
  }) async {
    final r = await _cliente
        .post(
          _uri('/sync/progress'),
          headers: _cabeceras(token: token),
          body: jsonEncode({
            'progreso': progreso,
            'habilidades': habilidades,
          }),
        )
        .timeout(tiempoEspera);
    return _decodificar(r);
  }

  /// DELETE /account. Borrado GDPR cascade. Tras esto el token queda
  /// invalidado porque el niño ya no existe.
  Future<void> borrarCuenta(String token) async {
    final r = await _cliente
        .delete(_uri('/account'), headers: _cabeceras(token: token))
        .timeout(tiempoEspera);
    _decodificar(r);
  }

  /// POST /auth/solicitar-reset. Pide al backend que envíe un email
  /// con enlace para crear nueva contraseña. **Anti-enumeración**: el
  /// servidor responde 200 igualmente aunque el email no exista, así
  /// que un cliente no puede usar este endpoint para descubrir si una
  /// dirección está registrada o no.
  Future<void> solicitarResetPassword({required String email}) async {
    final r = await _cliente
        .post(
          _uri('/auth/solicitar-reset'),
          headers: _cabeceras(),
          body: jsonEncode({'email': email}),
        )
        .timeout(tiempoEspera);
    _decodificar(r);
  }

  /// Decodifica JSON o lanza ExcepcionApi con el código HTTP y el
  /// mensaje de error si el servidor devolvió algo que no es 2xx.
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
      // Cuerpo no parseable como JSON; usamos mensaje genérico.
    }
    throw ExcepcionApi(
      codigo: respuesta.statusCode,
      mensaje: mensaje,
    );
  }
}

class RespuestaAuth {
  final String token;
  final int ninoId;
  final int? usuarioId;

  const RespuestaAuth({
    required this.token,
    required this.ninoId,
    this.usuarioId,
  });
}

/// Error del cliente API. El orquestador decide si reintentar, mostrar
/// mensaje al usuario o ignorar según el código.
class ExcepcionApi implements Exception {
  final int codigo;
  final String mensaje;

  const ExcepcionApi({required this.codigo, required this.mensaje});

  @override
  String toString() => 'ExcepcionApi($codigo): $mensaje';
}
