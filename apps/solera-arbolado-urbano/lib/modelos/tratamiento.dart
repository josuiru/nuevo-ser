/// Tratamiento fitosanitario o sanitario aplicado a un árbol urbano.
/// Forkeado del modelo de viticultura (campos PAC) y apícola (campos
/// REGA): trazabilidad sanitaria pública — sustancia activa, dosis,
/// motivo, lote, factura y técnico aplicador con su carnet.
///
/// `sustanciaActivaId` casa con el catálogo (compromiso legal de la app:
/// sustancias activas, no marcas comerciales).
///
/// El campo `motivoIdPlaga` referencia al catálogo de plagas urbanas
/// (procesionaria, picudo, anthracnosis…) o queda vacío para
/// tratamientos preventivos no asociados a una plaga concreta.
class Tratamiento {
  final int? id;
  final int arbolId;
  final int? tecnicoId;
  final int fechaMs;
  final String sustanciaActivaId;
  final String dosis;
  final String motivoIdPlaga;
  final String loteProducto;
  final String numeroFactura;
  final int? plazoSeguridadDias;
  final String rutasFotosJson;
  final String notas;

  Tratamiento({
    this.id,
    required this.arbolId,
    this.tecnicoId,
    required this.fechaMs,
    this.sustanciaActivaId = '',
    this.dosis = '',
    this.motivoIdPlaga = '',
    this.loteProducto = '',
    this.numeroFactura = '',
    this.plazoSeguridadDias,
    this.rutasFotosJson = '[]',
    this.notas = '',
  });

  Map<String, Object?> toMap() => {
        'id': id,
        'arbol_id': arbolId,
        'tecnico_id': tecnicoId,
        'fecha_ms': fechaMs,
        'sustancia_activa_id': sustanciaActivaId,
        'dosis': dosis,
        'motivo_id_plaga': motivoIdPlaga,
        'lote_producto': loteProducto,
        'numero_factura': numeroFactura,
        'plazo_seguridad_dias': plazoSeguridadDias,
        'rutas_fotos_json': rutasFotosJson,
        'notas': notas,
      };

  factory Tratamiento.fromMap(Map<String, Object?> mapa) => Tratamiento(
        id: mapa['id'] as int?,
        arbolId: mapa['arbol_id'] as int,
        tecnicoId: mapa['tecnico_id'] as int?,
        fechaMs: mapa['fecha_ms'] as int,
        sustanciaActivaId: (mapa['sustancia_activa_id'] as String?) ?? '',
        dosis: (mapa['dosis'] as String?) ?? '',
        motivoIdPlaga: (mapa['motivo_id_plaga'] as String?) ?? '',
        loteProducto: (mapa['lote_producto'] as String?) ?? '',
        numeroFactura: (mapa['numero_factura'] as String?) ?? '',
        plazoSeguridadDias: mapa['plazo_seguridad_dias'] as int?,
        rutasFotosJson: (mapa['rutas_fotos_json'] as String?) ?? '[]',
        notas: (mapa['notas'] as String?) ?? '',
      );
}
