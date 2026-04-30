import 'dart:convert';

import 'package:http/http.dart' as http;

/// Cliente HTTP fino para el endpoint público `POST /login` del
/// plugin `nuevo-ser-core`. Aislado del resto del cliente del juego
/// (`ClienteElCuaderno`) porque éste consume autenticación; el login
/// la **produce** y por tanto no puede pedirla.
///
/// Shape del endpoint (referencia
/// `wp-plugin/nuevo-ser-core/includes/class-ns-endpoints.php::iniciar_sesion`):
///   - body: `{email, password}`
///   - 200: `{token, nino_id}`
///   - 401: `{error: "Credenciales incorrectas."}`
///   - 404: `{error: "La cuenta no tiene ningún perfil de niño."}`
///
/// El cliente NO persiste el token. Esa responsabilidad es del call
/// site (`RepositorioCuentaBackend.guardarToken`/`guardarEmail`)
/// porque la persistencia es global, no por cliente, y el cliente
/// debe poder caer y reconstruirse sin perder sesión.
class ClienteAuthCuaderno {
  /// URL base sin barra final (`https://nuevoser.example.org`).
  final String urlBase;

  /// Cabecera `Host` opcional (Local WP por IP/puerto en lugar del
  /// dominio virtual).
  final String? hostOverride;

  /// Timeout por petición. 10 s es amplio para móviles.
  final Duration tiempoEspera;

  final http.Client _cliente;

  ClienteAuthCuaderno({
    required this.urlBase,
    http.Client? cliente,
    this.hostOverride,
    this.tiempoEspera = const Duration(seconds: 10),
  }) : _cliente = cliente ?? http.Client();

  void cerrar() => _cliente.close();

  /// Llama al endpoint de login. Devuelve el resultado tipado:
  ///   - [LoginExito] con token + nino_id.
  ///   - [LoginCredencialesIncorrectas] si el servidor responde 401.
  ///   - [LoginSinPerfilDeNino] si la cuenta del adulto existe pero
  ///     no hay ningún niño asociado (404 con mensaje específico).
  ///   - [LoginErrorRed] si la petición no llega al servidor o falla
  ///     de manera inesperada (timeout, DNS, 5xx, JSON corrupto…).
  Future<ResultadoLogin> iniciarSesion({
    required String email,
    required String password,
  }) async {
    final cabeceras = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'User-Agent': 'ElCuaderno/0.1 (Android)',
    };
    if (hostOverride != null) {
      cabeceras['Host'] = hostOverride!;
    }
    final uri = Uri.parse('$urlBase/wp-json/nuevo-ser/v1/login');
    final http.Response respuesta;
    try {
      respuesta = await _cliente
          .post(
            uri,
            headers: cabeceras,
            body: jsonEncode({'email': email, 'password': password}),
          )
          .timeout(tiempoEspera);
    } catch (excepcion) {
      return LoginErrorRed(detalle: excepcion.toString());
    }

    if (respuesta.statusCode == 200) {
      try {
        final json = jsonDecode(respuesta.body) as Map<String, dynamic>;
        final token = json['token'] as String?;
        final ninoId = json['nino_id'];
        if (token == null || token.isEmpty || ninoId is! num) {
          return LoginErrorRed(
            detalle: 'Respuesta 200 malformada: $json',
          );
        }
        return LoginExito(token: token, ninoId: ninoId.toInt());
      } catch (e) {
        return LoginErrorRed(detalle: 'JSON 200 inválido: $e');
      }
    }
    if (respuesta.statusCode == 401) {
      return const LoginCredencialesIncorrectas();
    }
    if (respuesta.statusCode == 404) {
      return const LoginSinPerfilDeNino();
    }
    return LoginErrorRed(
      detalle: 'HTTP ${respuesta.statusCode}: ${respuesta.body}',
    );
  }
}

/// Resultado del intento de login. Sealed — la UI debe distinguir las
/// cuatro ramas.
sealed class ResultadoLogin {
  const ResultadoLogin();
}

class LoginExito extends ResultadoLogin {
  const LoginExito({required this.token, required this.ninoId});
  final String token;
  final int ninoId;
}

class LoginCredencialesIncorrectas extends ResultadoLogin {
  const LoginCredencialesIncorrectas();
}

class LoginSinPerfilDeNino extends ResultadoLogin {
  const LoginSinPerfilDeNino();
}

class LoginErrorRed extends ResultadoLogin {
  const LoginErrorRed({required this.detalle});
  final String detalle;
}
