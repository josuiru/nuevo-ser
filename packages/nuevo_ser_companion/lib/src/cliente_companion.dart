import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nuevo_ser_core/nuevo_ser_core.dart';

import 'agregados/agregado_semanal.dart';
import 'aulas/agregados_aula.dart';
import 'aulas/aula_creada.dart';
import 'aulas/membresia_aula.dart';
import 'cuaderno/entrada_cuaderno.dart';
import 'cuaderno/listado_entradas_cuaderno.dart';
import 'mosaicos/listado_mosaicos.dart';
import 'mosaicos/mosaico.dart';

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

  /// GET /companion/cuaderno/entries
  ///
  /// Lista las entradas del cuaderno del niño dueño del [token],
  /// ordenadas de más reciente a más antigua.
  ///
  /// - [gameId]: si se pasa, filtra por juego (debe existir en
  ///   `ns_games`; el servidor responde 400 con `invalid_fields.game_id`
  ///   si no).
  /// - [limit]: 1..100 (el servidor recorta a 100).
  /// - [offset]: 0 o más.
  ///
  /// Lanza [ExcepcionApi] con código 400 si la query es inválida; 401 si
  /// el token no es válido; 5xx en otros fallos.
  Future<ListadoEntradasCuaderno> listarEntradasCuaderno({
    required String token,
    String? gameId,
    int limit = 20,
    int offset = 0,
  }) async {
    final parametros = <String, String>{
      'limit': '$limit',
      'offset': '$offset',
      if (gameId != null && gameId.isNotEmpty) 'game_id': gameId,
    };
    final url =
        _uri('/companion/cuaderno/entries').replace(queryParameters: parametros);
    final r = await _cliente
        .get(url, headers: _cabeceras(token: token))
        .timeout(tiempoEspera);
    final cuerpo = _decodificar(r);
    return ListadoEntradasCuaderno.desdeJson(cuerpo);
  }

  /// POST /companion/mosaicos
  ///
  /// Crea un mosaico recién terminado para el niño dueño del [token].
  /// Devuelve el mosaico con `id` y `completedAt` ya asignados; los
  /// campos opcionales (`contentMeta`, `requiredAnchors`,
  /// `fulfilledAnchors`, `qualitativeFeedback`) se preservan del
  /// original.
  ///
  /// Lanza [ExcepcionApi] con código 400 si la validación falla; 401 si
  /// el token no es válido; 5xx en otros fallos.
  Future<Mosaico> crearMosaico({
    required String token,
    required Mosaico mosaico,
  }) async {
    final r = await _cliente
        .post(
          _uri('/companion/mosaicos'),
          headers: _cabeceras(token: token),
          body: jsonEncode(mosaico.aJsonParaCrear()),
        )
        .timeout(tiempoEspera);
    final cuerpo = _decodificar(r);
    return Mosaico.desdeRespuestaCreacion(
      cuerpo,
      contentMetaOriginal: mosaico.contentMeta,
      requiredAnchorsOriginal: mosaico.requiredAnchors,
      fulfilledAnchorsOriginal: mosaico.fulfilledAnchors,
      qualitativeFeedbackOriginal: mosaico.qualitativeFeedback,
    );
  }

  /// GET /companion/mosaicos
  ///
  /// Lista los mosaicos del niño dueño del [token], ordenados de más
  /// reciente a más antiguo por `completedAt`.
  ///
  /// - [gameId]: filtra por juego (debe existir en `ns_games`).
  /// - [arcId]: filtra por arco (max 64 chars).
  /// - [limit]: 1..100.
  /// - [offset]: 0 o más.
  ///
  /// Lanza [ExcepcionApi] con código 400 si la query es inválida; 401 si
  /// el token no es válido; 5xx en otros fallos.
  Future<ListadoMosaicos> listarMosaicos({
    required String token,
    String? gameId,
    String? arcId,
    int limit = 20,
    int offset = 0,
  }) async {
    final parametros = <String, String>{
      'limit': '$limit',
      'offset': '$offset',
      if (gameId != null && gameId.isNotEmpty) 'game_id': gameId,
      if (arcId != null && arcId.isNotEmpty) 'arc_id': arcId,
    };
    final url =
        _uri('/companion/mosaicos').replace(queryParameters: parametros);
    final r = await _cliente
        .get(url, headers: _cabeceras(token: token))
        .timeout(tiempoEspera);
    final cuerpo = _decodificar(r);
    return ListadoMosaicos.desdeJson(cuerpo);
  }

  /// POST /companion/aggregates/weekly
  ///
  /// Sube los agregados anonimizados de la semana [isoWeek] (formato
  /// ISO-8601, p. ej. `'2026-W18'`) para [gameId]. El servidor calcula un
  /// hash determinista del [aggregates] y hace upsert por
  /// `(nino, juego, semana)`:
  /// - Misma combinación + mismo hash + summary cached → 200, devuelve
  ///   el summary cached sin llamar al LLM.
  /// - Misma combinación + hash distinto → 200, llama al tutor IA y
  ///   devuelve summary nuevo. Si el LLM falla, summary vacío.
  /// - Combinación nueva → 201, llama al tutor IA. Si el LLM falla,
  ///   summary vacío y el cliente reintenta más tarde.
  ///
  /// Lanza [ExcepcionApi] con código 400 si el shape es inválido; 401 si
  /// el token no es válido; 5xx en otros fallos.
  Future<AgregadoSemanal> archivarAgregadosSemanales({
    required String token,
    required String gameId,
    required String isoWeek,
    required Map<String, dynamic> aggregates,
  }) async {
    final r = await _cliente
        .post(
          _uri('/companion/aggregates/weekly'),
          headers: _cabeceras(token: token),
          body: jsonEncode({
            'game_id': gameId,
            'iso_week': isoWeek,
            'aggregates': aggregates,
          }),
        )
        .timeout(tiempoEspera);
    final cuerpo = _decodificar(r);
    return AgregadoSemanal.desdeJson(cuerpo);
  }

  /// POST /classrooms/{code}/join
  ///
  /// El niño dueño del [token] se une al aula con [code]. Devuelve la
  /// membresía resultante (idempotente: misma respuesta si ya era
  /// miembro).
  ///
  /// Lanza [ExcepcionApi] con código 400 si el código tiene formato
  /// inválido; 401 si el token no es válido; 404 si el aula no existe;
  /// 409 si está inactiva; 5xx en otros fallos.
  Future<MembresiaAula> unirseAula({
    required String token,
    required String code,
  }) async {
    final codeNormalizado = Uri.encodeComponent(code.toUpperCase().trim());
    final r = await _cliente
        .post(
          _uri('/classrooms/$codeNormalizado/join'),
          headers: _cabeceras(token: token),
        )
        .timeout(tiempoEspera);
    final cuerpo = _decodificar(r);
    return MembresiaAula.desdeJson(cuerpo);
  }

  /// POST /classrooms (con JWT del profesor)
  ///
  /// El profesor crea un aula nueva. El servidor genera el [code] de
  /// invitación y lo devuelve en la respuesta — el profesor lo reparte
  /// a su clase.
  ///
  /// - [name]: 1..120 caracteres, no vacío.
  /// - [gameIds]: lista no vacía de juegos catalogados en `ns_games`
  ///   (`'el-cuaderno'`, `'uno-roto'`, `'las-versiones'`). El servidor
  ///   responde 422 con `invalid_fields.game_ids` si alguno no existe.
  /// - [language]: ISO 639-1 minúsculas; default `'es'`.
  ///
  /// Lanza [ExcepcionApi] con código 401 si el token no es válido o
  /// no es de tipo `profesor`; 422 si el body no pasa validación;
  /// 503 si tras varios intentos el servidor no consigue un `code`
  /// único; 5xx en otros fallos.
  Future<AulaCreada> crearAula({
    required String token,
    required String name,
    required List<String> gameIds,
    String language = 'es',
  }) async {
    final r = await _cliente
        .post(
          _uri('/classrooms'),
          headers: _cabeceras(token: token),
          body: jsonEncode({
            'name': name,
            'language': language,
            'game_ids': gameIds,
          }),
        )
        .timeout(tiempoEspera);
    final cuerpo = _decodificar(r);
    return AulaCreada.desdeJson(cuerpo);
  }

  /// GET /classrooms/{id}/aggregates (con JWT del profesor)
  ///
  /// Devuelve los counts agregados del aula. **k mínimo = 5**: si el
  /// aula tiene menos de 5 miembros activos (o menos de 5 con datos
  /// para la semana solicitada), el servidor responde 403 con
  /// `k_minimo_no_alcanzado`.
  ///
  /// - [classroomId]: identificador devuelto por [crearAula].
  /// - [gameId]: opcional. Si se pasa, filtra por juego.
  /// - [isoWeek]: opcional. Si se pasa, filtra por semana
  ///   (formato `YYYY-Www`); si no, el servidor usa la última con
  ///   datos.
  ///
  /// Lanza [ExcepcionApi] con código 401 si el token no es válido o
  /// no es de tipo `profesor`; 403 si el aula no es del profesor o si
  /// no se alcanza el k mínimo; 404 si el aula no existe; 5xx en
  /// otros fallos.
  Future<AgregadosAula> obtenerAgregadosAula({
    required String token,
    required int classroomId,
    String? gameId,
    String? isoWeek,
  }) async {
    final parametros = <String, String>{
      if (gameId != null && gameId.isNotEmpty) 'game_id': gameId,
      if (isoWeek != null && isoWeek.isNotEmpty) 'iso_week': isoWeek,
    };
    final url = _uri('/classrooms/$classroomId/aggregates')
        .replace(queryParameters: parametros.isEmpty ? null : parametros);
    final r = await _cliente
        .get(url, headers: _cabeceras(token: token))
        .timeout(tiempoEspera);
    final cuerpo = _decodificar(r);
    return AgregadosAula.desdeJson(cuerpo);
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
