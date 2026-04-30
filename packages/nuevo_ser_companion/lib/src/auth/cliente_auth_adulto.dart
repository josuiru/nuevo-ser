import 'dart:convert';

import 'package:http/http.dart' as http;

/// Cliente HTTP fino para el endpoint `POST /auth/login` del plugin
/// `nuevo-ser-core` (autenticación de adultos: profesor o cuidador).
///
/// Aislado del resto del [ClienteCompanion] porque éste consume token
/// y el login lo **produce**. La pareja del cliente del niño
/// (`/login` con shape `{email, password} → {token, nino_id}`) vive
/// en `apps/el-cuaderno/lib/datos/cliente_auth_cuaderno.dart`; el
/// adulto tiene un endpoint distinto (`/auth/login`) con un shape
/// distinto (`{email, password, rol} → {token, user_id, rol}`) porque
/// el JWT lleva `tipo` para diferenciar profesor/cuidador.
///
/// Este cliente NO persiste el token — la responsabilidad es del
/// call site (típicamente `RepositorioCuentaBackend` con un namespace
/// específico para profesor/cuidador).
class ClienteAuthAdulto {
  /// URL base del backend, sin barra final (`https://nuevoser.example.org`).
  final String urlBase;

  /// Cabecera `Host` opcional (Local WP por IP/puerto).
  final String? hostOverride;

  /// Timeout por petición.
  final Duration tiempoEspera;

  final http.Client _cliente;

  ClienteAuthAdulto({
    required this.urlBase,
    http.Client? cliente,
    this.hostOverride,
    this.tiempoEspera = const Duration(seconds: 10),
  }) : _cliente = cliente ?? http.Client();

  void cerrar() => _cliente.close();

  /// Llama al endpoint de login del adulto. [rol] debe ser
  /// `'profesor'` o `'cuidador'` — el servidor rechaza cualquier otro
  /// con 400. Devuelve el resultado tipado:
  ///   - [LoginAdultoExito] con token + userId + rol confirmado.
  ///   - [LoginAdultoRolInvalido] si el body llevaba un rol
  ///     desconocido.
  ///   - [LoginAdultoCredencialesIncorrectas] si la contraseña no
  ///     casa o el email no existe.
  ///   - [LoginAdultoSinRolAsignado] si la cuenta existe y la
  ///     contraseña es correcta, pero el usuario no tiene el rol
  ///     solicitado en WordPress (caso típico: un cuidador
  ///     intentando entrar como profesor).
  ///   - [LoginAdultoErrorRed] para timeout / DNS / 5xx / shape
  ///     inesperado.
  Future<ResultadoLoginAdulto> iniciarSesion({
    required String email,
    required String password,
    required RolAdulto rol,
  }) async {
    final cabeceras = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'User-Agent': 'NuevoSerCompanion/0.1',
    };
    if (hostOverride != null) {
      cabeceras['Host'] = hostOverride!;
    }
    final uri = Uri.parse('$urlBase/wp-json/nuevo-ser/v1/auth/login');
    final http.Response respuesta;
    try {
      respuesta = await _cliente
          .post(
            uri,
            headers: cabeceras,
            body: jsonEncode({
              'email': email,
              'password': password,
              'rol': rol.wire,
            }),
          )
          .timeout(tiempoEspera);
    } catch (excepcion) {
      return LoginAdultoErrorRed(detalle: excepcion.toString());
    }

    if (respuesta.statusCode == 200) {
      try {
        final json = jsonDecode(respuesta.body) as Map<String, dynamic>;
        final token = json['token'] as String?;
        final userId = json['user_id'];
        final rolDevuelto = json['rol'] as String?;
        if (token == null || token.isEmpty || userId is! num || rolDevuelto == null) {
          return LoginAdultoErrorRed(
            detalle: 'Respuesta 200 malformada: $json',
          );
        }
        final rolConfirmado = RolAdulto.desdeWire(rolDevuelto) ?? rol;
        return LoginAdultoExito(
          token: token,
          userId: userId.toInt(),
          rol: rolConfirmado,
        );
      } catch (e) {
        return LoginAdultoErrorRed(detalle: 'JSON 200 inválido: $e');
      }
    }
    if (respuesta.statusCode == 400) {
      return const LoginAdultoRolInvalido();
    }
    if (respuesta.statusCode == 401) {
      return const LoginAdultoCredencialesIncorrectas();
    }
    if (respuesta.statusCode == 403) {
      return const LoginAdultoSinRolAsignado();
    }
    return LoginAdultoErrorRed(
      detalle: 'HTTP ${respuesta.statusCode}: ${respuesta.body}',
    );
  }
}

/// Rol del adulto que se autentica. La cadena del wire es la que el
/// servidor exige (`'profesor'` o `'cuidador'`).
enum RolAdulto {
  profesor('profesor'),
  cuidador('cuidador');

  const RolAdulto(this.wire);
  final String wire;

  static RolAdulto? desdeWire(String wire) {
    for (final rol in values) {
      if (rol.wire == wire) return rol;
    }
    return null;
  }
}

sealed class ResultadoLoginAdulto {
  const ResultadoLoginAdulto();
}

class LoginAdultoExito extends ResultadoLoginAdulto {
  const LoginAdultoExito({
    required this.token,
    required this.userId,
    required this.rol,
  });
  final String token;
  final int userId;
  final RolAdulto rol;
}

class LoginAdultoRolInvalido extends ResultadoLoginAdulto {
  const LoginAdultoRolInvalido();
}

class LoginAdultoCredencialesIncorrectas extends ResultadoLoginAdulto {
  const LoginAdultoCredencialesIncorrectas();
}

class LoginAdultoSinRolAsignado extends ResultadoLoginAdulto {
  const LoginAdultoSinRolAsignado();
}

class LoginAdultoErrorRed extends ResultadoLoginAdulto {
  const LoginAdultoErrorRed({required this.detalle});
  final String detalle;
}
