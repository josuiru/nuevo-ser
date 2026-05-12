/// Estado fitosanitario y estructural global del árbol. Coincide con
/// las clasificaciones simplificadas que usan los pliegos municipales.
enum EstadoArbol {
  /// Sin observaciones — apariencia normal.
  sano,

  /// Hay alguna anomalía que merece seguimiento (síntomas incipientes,
  /// pequeñas roturas, etc.) pero no riesgo inmediato.
  observacion,

  /// Riesgo de caída de ramas grandes o del propio árbol — urgente.
  riesgo,

  /// El árbol ya cayó o se eliminó por riesgo / por decisión municipal.
  caido,

  /// Sustituido por uno nuevo en el mismo alcorque.
  sustituido,
}

/// Árbol urbano. Entidad central. Forkeado de `Cepa` / `Colmena` con los
/// renombrados y campos específicos de arbolado (perímetro de tronco,
/// altura, riesgo VTA — Visual Tree Assessment).
///
/// El **identificador municipal** (`identificadorMunicipal`) es único en
/// la BD del cliente y casa con la chapa física que lleva el árbol en
/// el tronco (QR + texto legible). El **payload del QR** (`qrPayload`)
/// puede incluir prefijo del municipio + el id, p. ej.
/// `IRU:2024-PASEO-042`. Ambos viajan en la BD para que la búsqueda por
/// QR sea O(1) sin parsing.
///
/// El **riesgo VTA** se registra como entero 1-5: 1 = sin riesgo
/// observable, 5 = peligro inminente que requiere actuación urgente.
/// La decisión de actuar la firma siempre el técnico — la app no emite
/// dictámenes (compromiso legal en `CLAUDE.md` § Hard limits).
class Arbol {
  final int? id;
  final int? zonaId;
  final String identificadorMunicipal;
  final String qrPayload;
  final String especieId;
  final int? edadEstimadaAnos;
  final int? fechaPlantacionMs;
  final double? perimetroTroncoCm;
  final double? alturaEstimadaMetros;
  final int? riesgoVta;
  final EstadoArbol estado;
  final String tipoAlcorqueId;
  final double? latitud;
  final double? longitud;
  final String notas;
  final String rutasFotosJson;
  final int fechaCreacionMs;

  Arbol({
    this.id,
    this.zonaId,
    required this.identificadorMunicipal,
    this.qrPayload = '',
    this.especieId = '',
    this.edadEstimadaAnos,
    this.fechaPlantacionMs,
    this.perimetroTroncoCm,
    this.alturaEstimadaMetros,
    this.riesgoVta,
    this.estado = EstadoArbol.sano,
    this.tipoAlcorqueId = '',
    this.latitud,
    this.longitud,
    this.notas = '',
    this.rutasFotosJson = '[]',
    required this.fechaCreacionMs,
  });

  Map<String, Object?> toMap() => {
        'id': id,
        'zona_id': zonaId,
        'identificador_municipal': identificadorMunicipal,
        'qr_payload': qrPayload,
        'especie_id': especieId,
        'edad_estimada_anos': edadEstimadaAnos,
        'fecha_plantacion_ms': fechaPlantacionMs,
        'perimetro_tronco_cm': perimetroTroncoCm,
        'altura_estimada_metros': alturaEstimadaMetros,
        'riesgo_vta': riesgoVta,
        'estado': _estadoString(estado),
        'tipo_alcorque_id': tipoAlcorqueId,
        'latitud': latitud,
        'longitud': longitud,
        'notas': notas,
        'rutas_fotos_json': rutasFotosJson,
        'fecha_creacion_ms': fechaCreacionMs,
      };

  factory Arbol.fromMap(Map<String, Object?> mapa) => Arbol(
        id: mapa['id'] as int?,
        zonaId: mapa['zona_id'] as int?,
        identificadorMunicipal: (mapa['identificador_municipal'] as String?) ?? '',
        qrPayload: (mapa['qr_payload'] as String?) ?? '',
        especieId: (mapa['especie_id'] as String?) ?? '',
        edadEstimadaAnos: mapa['edad_estimada_anos'] as int?,
        fechaPlantacionMs: mapa['fecha_plantacion_ms'] as int?,
        perimetroTroncoCm: (mapa['perimetro_tronco_cm'] as num?)?.toDouble(),
        alturaEstimadaMetros: (mapa['altura_estimada_metros'] as num?)?.toDouble(),
        riesgoVta: mapa['riesgo_vta'] as int?,
        estado: _estadoDesdeString(mapa['estado'] as String?),
        tipoAlcorqueId: (mapa['tipo_alcorque_id'] as String?) ?? '',
        latitud: (mapa['latitud'] as num?)?.toDouble(),
        longitud: (mapa['longitud'] as num?)?.toDouble(),
        notas: (mapa['notas'] as String?) ?? '',
        rutasFotosJson: (mapa['rutas_fotos_json'] as String?) ?? '[]',
        fechaCreacionMs: (mapa['fecha_creacion_ms'] as int?) ?? 0,
      );
}

String _estadoString(EstadoArbol e) {
  switch (e) {
    case EstadoArbol.sano:
      return 'sano';
    case EstadoArbol.observacion:
      return 'observacion';
    case EstadoArbol.riesgo:
      return 'riesgo';
    case EstadoArbol.caido:
      return 'caido';
    case EstadoArbol.sustituido:
      return 'sustituido';
  }
}

EstadoArbol _estadoDesdeString(String? texto) {
  switch (texto) {
    case 'observacion':
      return EstadoArbol.observacion;
    case 'riesgo':
      return EstadoArbol.riesgo;
    case 'caido':
      return EstadoArbol.caido;
    case 'sustituido':
      return EstadoArbol.sustituido;
    case 'sano':
    default:
      return EstadoArbol.sano;
  }
}
