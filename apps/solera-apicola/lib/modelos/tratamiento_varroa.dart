/// Tratamiento aplicado a la colmena. En apicultura el grueso son
/// tratamientos contra varroa (`tipo == 'varroa'`); también se
/// registran tratamientos puntuales contra otras patologías
/// (nosema, ascosferiosis) y manejos sanitarios.
///
/// Campos críticos para el libro oficial REGA:
///  - `sustanciaActivaId` referencia al catálogo curado (F1A-4).
///  - `loteProducto` y `numeroFactura` para trazabilidad sanitaria.
///  - `fechaRetiradaMs` cuando se retira el tratamiento (tiras,
///    placas) — importante para calcular fin del plazo de seguridad.
class TratamientoVarroa {
  final int? id;
  final int colmenaId;
  final int fechaAplicacionMs;
  final int? fechaRetiradaMs;
  final String tipo;

  /// 'varroa' | 'nosema' | 'sanitario_general' | 'otro'
  final String sustanciaActivaId;
  final String dosis;
  final String vehiculo;

  /// 'sublimacion' | 'goteo' | 'sandwich' | 'tira' | 'placa' | 'otro'
  final int? plazoSeguridadDias;
  final String loteProducto;
  final String numeroFactura;
  final String motivo;
  final String notas;

  TratamientoVarroa({
    this.id,
    required this.colmenaId,
    required this.fechaAplicacionMs,
    this.fechaRetiradaMs,
    this.tipo = 'varroa',
    this.sustanciaActivaId = '',
    this.dosis = '',
    this.vehiculo = '',
    this.plazoSeguridadDias,
    this.loteProducto = '',
    this.numeroFactura = '',
    this.motivo = '',
    this.notas = '',
  });

  Map<String, Object?> toMap() => {
        'id': id,
        'colmena_id': colmenaId,
        'fecha_aplicacion_ms': fechaAplicacionMs,
        'fecha_retirada_ms': fechaRetiradaMs,
        'tipo': tipo,
        'sustancia_activa_id': sustanciaActivaId,
        'dosis': dosis,
        'vehiculo': vehiculo,
        'plazo_seguridad_dias': plazoSeguridadDias,
        'lote_producto': loteProducto,
        'numero_factura': numeroFactura,
        'motivo': motivo,
        'notas': notas,
      };

  factory TratamientoVarroa.fromMap(Map<String, Object?> mapa) => TratamientoVarroa(
        id: mapa['id'] as int?,
        colmenaId: mapa['colmena_id'] as int,
        fechaAplicacionMs: mapa['fecha_aplicacion_ms'] as int,
        fechaRetiradaMs: mapa['fecha_retirada_ms'] as int?,
        tipo: (mapa['tipo'] as String?) ?? 'varroa',
        sustanciaActivaId: (mapa['sustancia_activa_id'] as String?) ?? '',
        dosis: (mapa['dosis'] as String?) ?? '',
        vehiculo: (mapa['vehiculo'] as String?) ?? '',
        plazoSeguridadDias: mapa['plazo_seguridad_dias'] as int?,
        loteProducto: (mapa['lote_producto'] as String?) ?? '',
        numeroFactura: (mapa['numero_factura'] as String?) ?? '',
        motivo: (mapa['motivo'] as String?) ?? '',
        notas: (mapa['notas'] as String?) ?? '',
      );
}
