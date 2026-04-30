import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:nuevo_ser_core/nuevo_ser_core.dart';

import '../dominio/nivel_confianza.dart';
import '../dominio/observacion.dart';
import '../dominio/sit_spot.dart';

/// Cliente HTTP del juego El Cuaderno. Llama a los tres endpoints
/// del backend (`POST /el-cuaderno/observaciones`, `POST /el-cuaderno/
/// sit-spot`, `GET /el-cuaderno/misterios`) bajo el namespace canónico
/// `/wp-json/nuevo-ser/v1/*`.
///
/// **Frontera de privacidad** (doc 03 §3.3, §7.1, biblia §2.1): el
/// cliente nunca envía:
///   - el texto libre [Observacion.queVio] — solo su `sha256` hex.
///   - coordenadas precisas — el campo se omite del payload.
///   - rutas a fotos/dibujos — solo flags `has_photo` / `has_drawing`.
/// Si el operador intenta forzar el envío del texto libre, el cliente
/// lanza `ArgumentError` antes de tocar la red.
///
/// El token JWT del niño se obtiene a través de un callback
/// (`obtenerToken`) para que rote sin tener que reconstruir el
/// cliente. Si el callback devuelve null o cadena vacía, lanzamos
/// [ExcepcionApi] con código 401 sin tocar la red.
class ClienteElCuaderno {
  /// URL base del backend, sin barra final (`https://nuevoser.example.org`).
  /// En desarrollo con Local WP puede ser `http://127.0.0.1:10063` con
  /// [hostOverride] = `nuevo-ser.local`.
  final String urlBase;

  /// Cabecera `Host` opcional (Local WP por IP/puerto en lugar del
  /// dominio virtual).
  final String? hostOverride;

  /// Callback que devuelve el token JWT del niño en cada llamada (la
  /// app puede haberlo renovado entre dos calls). Devolver null o
  /// cadena vacía equivale a "no hay sesión".
  final Future<String?> Function() obtenerToken;

  /// Timeout por petición. 10 s es amplio para móviles.
  final Duration tiempoEspera;

  final http.Client _cliente;

  ClienteElCuaderno({
    required this.urlBase,
    required this.obtenerToken,
    http.Client? cliente,
    this.hostOverride,
    this.tiempoEspera = const Duration(seconds: 10),
  }) : _cliente = cliente ?? http.Client();

  void cerrar() => _cliente.close();

  Uri _uri(String ruta, [Map<String, String>? query]) {
    final base = Uri.parse('$urlBase/wp-json/nuevo-ser/v1$ruta');
    if (query == null || query.isEmpty) return base;
    return base.replace(queryParameters: {
      ...base.queryParameters,
      ...query,
    });
  }

  Future<Map<String, String>> _cabeceras() async {
    final token = await obtenerToken();
    if (token == null || token.isEmpty) {
      throw const ExcepcionApi(
        codigo: 401,
        mensaje: 'No hay token de sesión para el cuaderno',
      );
    }
    final cabeceras = <String, String>{
      'Content-Type': 'application/json',
      'User-Agent': 'ElCuaderno/0.1 (Android)',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
    if (hostOverride != null) {
      cabeceras['Host'] = hostOverride!;
    }
    return cabeceras;
  }

  /// Calcula el `sha256` hex (lowercase) del texto libre del niño.
  /// Lo expone público para que la cola de sync pueda guardar el hash
  /// junto a la observación pendiente sin tener que reabrir la regla
  /// de cálculo.
  static String hashearWhatSeen(String queVio) {
    final bytes = utf8.encode(queVio);
    return sha256.convert(bytes).toString();
  }

  /// POST `/el-cuaderno/observaciones`. Sube los **metadatos** de la
  /// observación junto al `what_seen_hash`. El servidor responde 201
  /// con id si era nueva, o 200 con id si el UUID ya existía
  /// (idempotente — la cola puede reintentar sin duplicar).
  Future<RespuestaObservacion> crearObservacion(
    Observacion observacion, {
    required String regionCode,
  }) async {
    final cuerpo = <String, Object?>{
      'uuid': observacion.id,
      'occurred_at': observacion.cuandoOcurrio.toUtc().toIso8601String(),
      'place_name': observacion.dondeNombre,
      'region_code': regionCode,
      'what_seen_hash': hashearWhatSeen(observacion.queVio),
      'proposed_id': observacion.creesQueEs ?? '',
      'confidence': _confianzaServidor(observacion.confianza),
      'has_photo': observacion.fotoRutaLocal != null,
      'has_drawing': observacion.dibujoRutaLocal != null,
      'misterio_id': observacion.misterioId ?? '',
      'sit_spot_id': observacion.sitSpotId ?? '',
    };
    if (observacion.climaResumen != null && observacion.climaResumen!.isNotEmpty) {
      cuerpo['weather'] = {'resumen': observacion.climaResumen};
    }
    // Refuerzo de la frontera de privacidad: el campo `what_seen` en
    // claro está prohibido. El servidor también lo rechaza con 400,
    // pero fallar aquí es menos costoso (no llega a hacerse la
    // petición) y deja un mensaje útil para quien construye el cuerpo
    // a mano por error.
    if (cuerpo.containsKey('what_seen')) {
      throw ArgumentError(
        'No envíes what_seen al servidor — solo what_seen_hash. '
        'El texto libre del niño nunca cruza red.',
      );
    }
    final respuesta = await _cliente
        .post(
          _uri('/el-cuaderno/observaciones'),
          headers: await _cabeceras(),
          body: jsonEncode(cuerpo),
        )
        .timeout(tiempoEspera);
    final json = _decodificar(respuesta);
    return RespuestaObservacion(
      id: (json['id'] as num).toInt(),
      uuid: json['uuid'] as String,
      idempotente: json['idempotent'] == true,
    );
  }

  /// POST `/el-cuaderno/sit-spot`. Idempotente por UUID. El servidor
  /// jubila automáticamente el sit spot anterior del niño cuando llega
  /// uno nuevo (doc 13 §2.6).
  Future<RespuestaSitSpot> establecerSitSpot(
    SitSpot sitSpot, {
    required String regionCode,
  }) async {
    final respuesta = await _cliente
        .post(
          _uri('/el-cuaderno/sit-spot'),
          headers: await _cabeceras(),
          body: jsonEncode({
            'uuid': sitSpot.id,
            'name': sitSpot.nombre,
            'region_code': regionCode,
          }),
        )
        .timeout(tiempoEspera);
    final json = _decodificar(respuesta);
    return RespuestaSitSpot(
      id: (json['id'] as num).toInt(),
      uuid: json['uuid'] as String,
      idempotente: json['idempotent'] == true,
    );
  }

  /// GET `/el-cuaderno/misterios`. Devuelve el catálogo filtrado por
  /// región y estación. Ambos parámetros son opcionales — si se omiten,
  /// el servidor devuelve el catálogo completo.
  Future<RespuestaCatalogoMisterios> listarMisterios({
    String? region,
    String? season,
  }) async {
    final query = <String, String>{};
    if (region != null && region.isNotEmpty) query['region'] = region;
    if (season != null && season.isNotEmpty) query['season'] = season;

    final respuesta = await _cliente
        .get(
          _uri('/el-cuaderno/misterios', query),
          headers: await _cabeceras(),
        )
        .timeout(tiempoEspera);
    final json = _decodificar(respuesta);

    final crudos = (json['misterios'] as List<dynamic>? ?? const [])
        .cast<Map<String, dynamic>>();
    return RespuestaCatalogoMisterios(
      misterios: crudos.map(MisterioCatalogo.fromJson).toList(),
      catalogoTotal: (json['catalogo_total'] as num?)?.toInt() ?? crudos.length,
      aplicanFiltros:
          (json['aplican_filtros'] as num?)?.toInt() ?? crudos.length,
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
      if (cuerpo is Map && cuerpo['message'] is String) {
        mensaje = cuerpo['message'] as String;
      } else if (cuerpo is Map && cuerpo['error'] is String) {
        mensaje = cuerpo['error'] as String;
      }
    } catch (_) {
      // Cuerpo no parseable; mensaje genérico ya colocado.
    }
    throw ExcepcionApi(codigo: respuesta.statusCode, mensaje: mensaje);
  }

  static String _confianzaServidor(NivelConfianza confianza) {
    switch (confianza) {
      case NivelConfianza.consenso:
        return 'consenso';
      case NivelConfianza.hipotesisActiva:
        return 'hipotesis_activa';
      case NivelConfianza.noSegura:
        return 'no_segura';
      case NivelConfianza.abandonado:
        // El validator del backend lo rechaza igualmente — pero en
        // observaciones nunca debería llegar aquí porque el constructor
        // de Observacion ya prohíbe `abandonado`.
        throw ArgumentError(
          'NivelConfianza.abandonado pertenece a Misterios, no a observaciones',
        );
    }
  }
}

/// Respuesta del POST `/el-cuaderno/observaciones`.
class RespuestaObservacion {
  const RespuestaObservacion({
    required this.id,
    required this.uuid,
    required this.idempotente,
  });

  final int id;
  final String uuid;
  final bool idempotente;
}

/// Respuesta del POST `/el-cuaderno/sit-spot`.
class RespuestaSitSpot {
  const RespuestaSitSpot({
    required this.id,
    required this.uuid,
    required this.idempotente,
  });

  final int id;
  final String uuid;
  final bool idempotente;
}

/// Una entrada del catálogo de Misterios — proyección DTO de lo que
/// devuelve el backend, mantenida separada del dominio `Misterio` para
/// que los datos del catálogo (textos en castellano, descripciones,
/// filtros de región/estación) no se confundan con el estado local
/// del niño en torno a un Misterio (qué observaciones lleva, si lo
/// abandonó, etc.).
class MisterioCatalogo {
  const MisterioCatalogo({
    required this.code,
    required this.preguntaEs,
    required this.descripcionEs,
    required this.estado,
    required this.season,
    this.regionFilter,
  });

  /// Código único como `MIST.AVES.GOLONDRINAS_OTONO` (doc 14 §3).
  final String code;

  /// Pregunta del Misterio en castellano. Las traducciones eu/ca son
  /// trabajo humano todavía pendiente.
  final String preguntaEs;

  /// Descripción / contexto del Misterio.
  final String descripcionEs;

  /// Estado pedagógico del Misterio en el catálogo (`hipotesis_activa`,
  /// `consenso`, `abandonado`). El estado local del niño puede diferir.
  final String estado;

  /// Estaciones a las que aplica (`primavera`, `verano`, `otono`,
  /// `invierno`, `todo_el_anio`). Si contiene `todo_el_anio`, aplica
  /// siempre.
  final List<String> season;

  /// Prefijos NUTS a los que aplica el Misterio. `null` o lista vacía
  /// significa "global, no filtra por región".
  final List<String>? regionFilter;

  static MisterioCatalogo fromJson(Map<String, dynamic> json) {
    final filterRaw = json['region_filter'];
    return MisterioCatalogo(
      code: json['code'] as String,
      preguntaEs: json['pregunta_es'] as String,
      descripcionEs: json['descripcion_es'] as String,
      estado: json['estado'] as String,
      season: (json['season'] as List<dynamic>? ?? const [])
          .map((e) => e as String)
          .toList(),
      regionFilter: filterRaw is List
          ? filterRaw.map((e) => e as String).toList()
          : null,
    );
  }
}

class RespuestaCatalogoMisterios {
  const RespuestaCatalogoMisterios({
    required this.misterios,
    required this.catalogoTotal,
    required this.aplicanFiltros,
  });

  final List<MisterioCatalogo> misterios;
  final int catalogoTotal;
  final int aplicanFiltros;
}
