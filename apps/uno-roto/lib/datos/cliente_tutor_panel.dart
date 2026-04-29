import 'dart:convert';

import 'package:http/http.dart' as http;

import '../dominio/habilidad.dart';

/// Cliente HTTP del **panel de tutor** (no confundir con el Tutor IA).
///
/// El tutor entra con su email + password desde la pantalla "Mi
/// cuaderno" y obtiene un JWT con `usuario_id` y TTL 15 minutos. Con
/// ese token puede:
///   - listar los niños vinculados a su cuenta;
///   - consultar el progreso detallado de cada uno (read-only).
///
/// Diferenciado del [ClienteApi] del niño porque el JWT y los
/// endpoints son distintos: el ClienteApi usa `nino_id`, este
/// `usuario_id`. El token NO se persiste en disco (vive solo en
/// memoria mientras la app esté abierta o hasta que expire).
class ClienteTutorPanel {
  final String urlBase;
  final String? hostOverride;
  final Duration tiempoEspera;
  final http.Client _cliente;

  ClienteTutorPanel({
    required this.urlBase,
    this.hostOverride,
    http.Client? cliente,
    this.tiempoEspera = const Duration(seconds: 10),
  }) : _cliente = cliente ?? http.Client();

  void cerrar() => _cliente.close();

  Uri _uri(String ruta) => Uri.parse('$urlBase/wp-json/nuevo-ser/v1$ruta');

  Map<String, String> _cabeceras({String? token}) {
    // Fijamos User-Agent para esquivar la regla 920330 de mod_security
    // (Empty User Agent Header → 406). Ver `cliente_api.dart`.
    final base = {
      'Content-Type': 'application/json',
      'User-Agent': 'UnoRoto/0.5 (Android)',
      'Accept': 'application/json',
    };
    if (token != null && token.isNotEmpty) {
      base['Authorization'] = 'Bearer $token';
    }
    if (hostOverride != null && hostOverride!.isNotEmpty) {
      base['Host'] = hostOverride!;
    }
    return base;
  }

  Map<String, dynamic> _decodificar(http.Response r) {
    if (r.statusCode < 200 || r.statusCode >= 300) {
      throw ExcepcionTutorPanel(r.statusCode, r.body);
    }
    return jsonDecode(r.body) as Map<String, dynamic>;
  }

  /// POST /auth/iniciar-sesion-tutor. Devuelve token con `usuario_id`
  /// y TTL de 15 minutos.
  Future<RespuestaAuthTutor> iniciarSesionTutor({
    required String email,
    required String password,
  }) async {
    final r = await _cliente
        .post(
          _uri('/auth/iniciar-sesion-tutor'),
          headers: _cabeceras(),
          body: jsonEncode({'email': email, 'password': password}),
        )
        .timeout(tiempoEspera);
    final cuerpo = _decodificar(r);
    return RespuestaAuthTutor(
      token: cuerpo['token'] as String,
      usuarioId: (cuerpo['usuario_id'] as num).toInt(),
      nombreTutor: (cuerpo['nombre_tutor'] as String?) ?? '',
      expiraEnSegundos:
          (cuerpo['expira_en_segundos'] as num?)?.toInt() ?? 15 * 60,
    );
  }

  /// GET /tutor/ninos. Lista de niños del tutor con resumen breve.
  Future<List<ResumenNino>> listarNinos(String token) async {
    final r = await _cliente
        .get(_uri('/tutor/ninos'), headers: _cabeceras(token: token))
        .timeout(tiempoEspera);
    final cuerpo = _decodificar(r);
    final lista = (cuerpo['ninos'] as List).cast<Map<String, dynamic>>();
    return lista.map(ResumenNino.desdeJson).toList();
  }

  /// GET /tutor/progreso-nino/{ninoId}. Devuelve progreso global +
  /// estado completo de las habilidades del niño.
  Future<ProgresoNino> obtenerProgresoNino({
    required String token,
    required int ninoId,
  }) async {
    final r = await _cliente
        .get(
          _uri('/tutor/progreso-nino/$ninoId'),
          headers: _cabeceras(token: token),
        )
        .timeout(tiempoEspera);
    final cuerpo = _decodificar(r);
    return ProgresoNino.desdeJson(cuerpo);
  }
}

class ExcepcionTutorPanel implements Exception {
  final int codigoHttp;
  final String cuerpo;

  ExcepcionTutorPanel(this.codigoHttp, this.cuerpo);

  @override
  String toString() => 'ExcepcionTutorPanel($codigoHttp): $cuerpo';
}

class RespuestaAuthTutor {
  final String token;
  final int usuarioId;
  final String nombreTutor;
  final int expiraEnSegundos;

  const RespuestaAuthTutor({
    required this.token,
    required this.usuarioId,
    required this.nombreTutor,
    required this.expiraEnSegundos,
  });
}

class ResumenNino {
  final int ninoId;
  final String nombreMostrar;
  final String locale;
  final int esquirlasTotal;
  final int rango;
  final int arcoActual;
  final int habilidadesVistas;

  const ResumenNino({
    required this.ninoId,
    required this.nombreMostrar,
    required this.locale,
    required this.esquirlasTotal,
    required this.rango,
    required this.arcoActual,
    required this.habilidadesVistas,
  });

  factory ResumenNino.desdeJson(Map<String, dynamic> json) {
    return ResumenNino(
      ninoId: (json['nino_id'] as num).toInt(),
      nombreMostrar: (json['nombre_mostrar'] as String?) ?? '',
      locale: (json['locale'] as String?) ?? 'es',
      esquirlasTotal: (json['esquirlas_total'] as num?)?.toInt() ?? 0,
      rango: (json['rango'] as num?)?.toInt() ?? 0,
      arcoActual: (json['arco_actual'] as num?)?.toInt() ?? 1,
      habilidadesVistas:
          (json['habilidades_vistas'] as num?)?.toInt() ?? 0,
    );
  }
}

class ProgresoNino {
  final int ninoId;
  final String nombreMostrar;
  final Map<String, dynamic>? progresoGeneral;
  final List<EstadoHabilidad> habilidades;

  const ProgresoNino({
    required this.ninoId,
    required this.nombreMostrar,
    required this.progresoGeneral,
    required this.habilidades,
  });

  factory ProgresoNino.desdeJson(Map<String, dynamic> json) {
    final habilidades = <EstadoHabilidad>[];
    final lista = (json['habilidades'] as List?) ?? const [];
    for (final entrada in lista) {
      if (entrada is Map<String, dynamic>) {
        habilidades.add(_parsearEstadoHabilidadServidor(entrada));
      }
    }
    return ProgresoNino(
      ninoId: (json['nino_id'] as num).toInt(),
      nombreMostrar: (json['nombre_mostrar'] as String?) ?? '',
      progresoGeneral: json['progreso'] is Map<String, dynamic>
          ? json['progreso'] as Map<String, dynamic>
          : null,
      habilidades: habilidades,
    );
  }
}

/// El servidor (PHP) usa snake_case y nombres distintos a la
/// representación local Dart. Adaptamos al vuelo para reusar
/// [EstadoHabilidad] como modelo único en cliente.
EstadoHabilidad _parsearEstadoHabilidadServidor(Map<String, dynamic> json) {
  final intentos = <IntentoHabilidad>[];
  final raw = json['intentos_recientes_json'];
  if (raw is String && raw.isNotEmpty) {
    try {
      final decod = jsonDecode(raw);
      if (decod is List) {
        for (final entrada in decod) {
          if (entrada is Map<String, dynamic>) {
            intentos.add(IntentoHabilidad.desdeJson(entrada));
          }
        }
      }
    } catch (_) {
      // Si el JSON está corrupto en BD, ignoramos los intentos —
      // el estado agregado sigue siendo válido.
    }
  }

  return EstadoHabilidad(
    identificadorHabilidad: (json['id_habilidad'] as String?) ?? '',
    nivel: NivelMaestriaEntero.desdeValor(
      (json['nivel'] as num?)?.toInt() ?? 0,
    ),
    precision: (json['precision_ponderada'] as num?)?.toDouble() ?? 0,
    tiempoMedianoSeg:
        (json['tiempo_mediano_seg'] as num?)?.toDouble() ?? 0,
    ultimaPractica: DateTime.tryParse(
          (json['ultima_practica'] as String?) ?? '',
        ) ??
        DateTime.fromMillisecondsSinceEpoch(0),
    sesionesConsecutivasBuenas:
        (json['sesiones_consecutivas_buenas'] as num?)?.toInt() ?? 0,
    totalExposiciones: (json['total_exposiciones'] as num?)?.toInt() ?? 0,
    intentosRecientes: intentos,
  );
}
