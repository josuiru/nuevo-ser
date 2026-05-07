import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nuevo_ser_core/nuevo_ser_core.dart';

/// Cliente del Tutor IA de El Cuaderno. Envía la pregunta del niño +
/// idioma + contexto opcional al backend (`POST /el-cuaderno/tutor`)
/// y recibe la respuesta filtrada del modelo.
///
/// **Sin historial conversacional** (doc 04 §3.2): cada `preguntar`
/// es independiente. El cliente nunca manda turnos previos al
/// servidor, y el servidor no almacena la conversación.
///
/// **Sin construcción de prompt en cliente** (doc 03 §6.2): el
/// system prompt es server-side y versionado. El cliente solo añade
/// el contexto declarado (no inventa instrucciones para el modelo).
class ClienteTutorCuaderno {
  ClienteTutorCuaderno({
    required this.urlBase,
    required this.obtenerToken,
    http.Client? cliente,
    this.hostOverride,
    this.tiempoEspera = const Duration(seconds: 30),
  }) : _cliente = cliente ?? http.Client();

  final String urlBase;
  final String? hostOverride;
  final Future<String?> Function() obtenerToken;
  final Duration tiempoEspera;
  final http.Client _cliente;

  void cerrar() => _cliente.close();

  /// Envía una pregunta al Tutor. La respuesta puede venir filtrada
  /// (`RespuestaTutor.filtro` ∈ aceptada / regenerada / reemplazada
  /// canónico / fallback filtrado) — la UI puede mostrar metadatos
  /// para depuración pero al niño solo le interesa el campo
  /// `respuesta`.
  ///
  /// Si el servidor devuelve 429 (cuota agotada), lanzamos
  /// [CuotaTutorAgotada] con el mensaje canónico para mostrar al
  /// niño en lugar de error genérico.
  Future<RespuestaTutor> preguntar({
    required String pregunta,
    String idioma = 'es',
    ContextoTutor contexto = const ContextoTutor.vacio(),
  }) async {
    final token = await obtenerToken();
    if (token == null || token.isEmpty) {
      throw const ExcepcionApi(
        codigo: 401,
        mensaje: 'No hay token de sesión para el Tutor',
      );
    }

    final cabeceras = {
      'Content-Type': 'application/json',
      'User-Agent': 'ElCuaderno/0.1 (Android)',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
      if (hostOverride != null) 'Host': hostOverride!,
    };

    final cuerpo = <String, Object?>{
      'pregunta': pregunta,
      'idioma': idioma,
    };
    final ctx = contexto.aJson();
    if (ctx.isNotEmpty) {
      cuerpo['contexto'] = ctx;
    }

    final respuesta = await _cliente
        .post(
          Uri.parse('$urlBase/wp-json/nuevo-ser/v1/el-cuaderno/tutor'),
          headers: cabeceras,
          body: jsonEncode(cuerpo),
        )
        .timeout(tiempoEspera);

    if (respuesta.statusCode == 429) {
      final json = _parsear(respuesta.body);
      throw CuotaTutorAgotada(
        mensaje: (json['mensaje_cuota'] as String?) ??
            'Hoy hemos hablado mucho. Volvemos mañana.',
      );
    }

    if (respuesta.statusCode < 200 || respuesta.statusCode >= 300) {
      String mensaje = 'HTTP ${respuesta.statusCode}';
      try {
        final json = _parsear(respuesta.body);
        if (json['message'] is String) {
          mensaje = json['message'] as String;
        }
      } catch (_) {
        // Mensaje genérico ya colocado.
      }
      throw ExcepcionApi(codigo: respuesta.statusCode, mensaje: mensaje);
    }

    final json = _parsear(respuesta.body);
    return RespuestaTutor(
      respuesta: json['respuesta'] as String,
      promptVersion: json['prompt_version'] as String,
      filtro: FiltroTutor.fromString(json['filtro'] as String),
      tieneNombreCientifico: json['tiene_nombre_cientifico'] == true,
    );
  }

  Map<String, dynamic> _parsear(String body) {
    if (body.isEmpty) return const {};
    return jsonDecode(body) as Map<String, dynamic>;
  }
}

/// Resultado de una pregunta al Tutor. La UI muestra `respuesta`; el
/// resto son metadatos útiles para registrar en el historial local
/// (cuándo fue regenerada, qué versión del prompt, si hubo nombre
/// científico — para mostrar el aviso "consulta una clave local").
class RespuestaTutor {
  const RespuestaTutor({
    required this.respuesta,
    required this.promptVersion,
    required this.filtro,
    required this.tieneNombreCientifico,
  });

  final String respuesta;
  final String promptVersion;
  final FiltroTutor filtro;
  final bool tieneNombreCientifico;
}

/// Etiqueta del resultado del filtro server-side. Útil para que la UI
/// pueda decidir si mostrar la respuesta al niño con normalidad o si
/// indicar al desarrollador que el filtro intervino. Al niño NUNCA
/// se le muestra esta etiqueta — la UI la usa para logging y para
/// telemetría privada (sin compartir).
enum FiltroTutor {
  aceptada,
  regenerada,
  reemplazadaCanonico,
  fallbackFiltrado;

  static FiltroTutor fromString(String valor) {
    switch (valor) {
      case 'aceptada':
        return FiltroTutor.aceptada;
      case 'regenerada':
        return FiltroTutor.regenerada;
      case 'reemplazada_canonico':
        return FiltroTutor.reemplazadaCanonico;
      case 'fallback_filtrado':
        return FiltroTutor.fallbackFiltrado;
      default:
        throw ArgumentError('FiltroTutor desconocido: $valor');
    }
  }
}

/// Contexto opcional que se envía al Tutor con cada pregunta. Se
/// inyecta en el system prompt del modelo para personalizar la
/// respuesta. Todos los campos son opcionales; el envío es solo de
/// los rellenados.
///
/// **Frontera de privacidad estructural** (biblia §2.1, doc 03 §3.3):
/// los campos sólo cubren metadatos no-PII (edad de tramo, region
/// code agregada, estación, skill_id, nivel). NO incluye texto libre
/// del niño. Una versión anterior tenía `observacionAdjunta` (string
/// libre) que viajaba al servidor — eliminado en fix de auditoría:
/// aunque truncar server-side limitaba el daño, exponía la API a una
/// violación futura de la frontera. Si en algún momento hace falta
/// dar contexto textual al modelo, debe hacerse vía hash sha256
/// (mismo patrón que `what_seen_hash` de observaciones), no con el
/// texto crudo.
class ContextoTutor {
  const ContextoTutor({
    this.edad,
    this.regionCode,
    this.season,
    this.skillId,
    this.nivelSkill,
  });

  const ContextoTutor.vacio()
      : edad = null,
        regionCode = null,
        season = null,
        skillId = null,
        nivelSkill = null;

  final int? edad;
  final String? regionCode;
  final String? season;
  final String? skillId;
  final int? nivelSkill;

  Map<String, Object?> aJson() {
    final json = <String, Object?>{};
    if (edad != null) json['edad'] = edad;
    if (regionCode != null && regionCode!.isNotEmpty) {
      json['region_code'] = regionCode;
    }
    if (season != null && season!.isNotEmpty) json['season'] = season;
    if (skillId != null && skillId!.isNotEmpty) json['skill_id'] = skillId;
    if (nivelSkill != null) json['nivel_skill'] = nivelSkill;
    return json;
  }
}

/// Excepción tipada para el caso de cuota agotada del niño. La UI la
/// captura específicamente para mostrar el mensaje canónico ("Hoy
/// hemos hablado mucho. Volvemos mañana.") en lugar de un error
/// genérico de red.
class CuotaTutorAgotada implements Exception {
  const CuotaTutorAgotada({required this.mensaje});

  final String mensaje;

  @override
  String toString() => 'CuotaTutorAgotada: $mensaje';
}
