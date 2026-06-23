import 'constantes.dart';

/// Un punto de infraestructura marcado sobre el mapa de una finca:
/// abrevadero, manga de manejo, cierre, refugio, balsa, almacén… Cada uno
/// con su tipo, ubicación GPS, estado de conservación y fotos.
class PuntoInfraestructura {
  PuntoInfraestructura({
    this.id,
    required this.fincaId,
    this.tipo = tipoPuntoPorDefecto,
    this.nombre = '',
    this.latitud,
    this.longitud,
    this.estado = estadoPuntoPorDefecto,
    this.notas = '',
    this.rutasFotosJson = '[]',
    this.fechaCreacionMs = 0,
  });

  final int? id;
  final int fincaId;

  /// Código de `tiposPunto` (abrevadero, manga, cierre…).
  final String tipo;

  final String nombre;
  final double? latitud;
  final double? longitud;

  /// Código de `estadosPunto` (operativo / revisar / averiado).
  final String estado;

  final String notas;
  final String rutasFotosJson;
  final int fechaCreacionMs;

  Map<String, Object?> toMap() => {
        'id': id,
        'finca_id': fincaId,
        'tipo': tipo,
        'nombre': nombre,
        'latitud': latitud,
        'longitud': longitud,
        'estado': estado,
        'notas': notas,
        'rutas_fotos_json': rutasFotosJson,
        'fecha_creacion_ms': fechaCreacionMs,
      };

  factory PuntoInfraestructura.fromMap(Map<String, Object?> mapa) =>
      PuntoInfraestructura(
        id: mapa['id'] as int?,
        fincaId: (mapa['finca_id'] as int?) ?? 0,
        tipo: (mapa['tipo'] as String?) ?? tipoPuntoPorDefecto,
        nombre: (mapa['nombre'] as String?) ?? '',
        latitud: (mapa['latitud'] as num?)?.toDouble(),
        longitud: (mapa['longitud'] as num?)?.toDouble(),
        estado: (mapa['estado'] as String?) ?? estadoPuntoPorDefecto,
        notas: (mapa['notas'] as String?) ?? '',
        rutasFotosJson: (mapa['rutas_fotos_json'] as String?) ?? '[]',
        fechaCreacionMs: (mapa['fecha_creacion_ms'] as int?) ?? 0,
      );

  PuntoInfraestructura copiarCon({
    int? id,
    int? fincaId,
    String? tipo,
    String? nombre,
    double? latitud,
    double? longitud,
    String? estado,
    String? notas,
    String? rutasFotosJson,
    int? fechaCreacionMs,
  }) =>
      PuntoInfraestructura(
        id: id ?? this.id,
        fincaId: fincaId ?? this.fincaId,
        tipo: tipo ?? this.tipo,
        nombre: nombre ?? this.nombre,
        latitud: latitud ?? this.latitud,
        longitud: longitud ?? this.longitud,
        estado: estado ?? this.estado,
        notas: notas ?? this.notas,
        rutasFotosJson: rutasFotosJson ?? this.rutasFotosJson,
        fechaCreacionMs: fechaCreacionMs ?? this.fechaCreacionMs,
      );
}
