/// Movimiento de aceite — entrada, salida o transformación de un lote.
/// Es la unidad atómica del libro de movimientos del aceite que exige
/// la Agencia de Información y Control Alimentarios (AICA).
///
/// Tipos canónicos:
///   `entrada_molturacion` — el lote nace de una molturación.
///   `traslado_deposito`   — se mueve a otro depósito sin transformación.
///   `mezcla_lotes`        — se fusiona con otro(s) lote(s) para crear uno nuevo.
///   `envasado`            — salida del granel a botellas/garrafas.
///   `venta_granel`        — salida comercial sin envasar (a otro operador).
///   `autoconsumo`         — uso interno (familia, regalos).
///   `merma`               — pérdida documentada (limpieza depósito, evaporación).
class Movimiento {
  final int? id;
  final int loteAceiteId; // FK LoteAceite
  final int fechaMs;
  /// Uno de los tipos canónicos documentados arriba.
  final String tipo;
  /// Kg movidos (positivo). Para `mezcla_lotes` y `envasado`, indica
  /// los kg que SALEN de este lote.
  final double kgMovidos;
  /// Texto libre — "depósito D-7" / "envasado 0,5 L x 240 botellas".
  final String ubicacionDestino;
  /// FK a Venta. `null` salvo en `venta_granel` y `envasado` con venta
  /// directa.
  final int? ventaId;
  /// Para `mezcla_lotes`, ID del lote destino de la mezcla. `null` en
  /// el resto de tipos.
  final int? loteDestinoMezclaId;
  final String notas;

  Movimiento({
    this.id,
    required this.loteAceiteId,
    required this.fechaMs,
    required this.tipo,
    this.kgMovidos = 0,
    this.ubicacionDestino = '',
    this.ventaId,
    this.loteDestinoMezclaId,
    this.notas = '',
  });

  Map<String, Object?> toMap() => {
        'id': id,
        'lote_aceite_id': loteAceiteId,
        'fecha_ms': fechaMs,
        'tipo': tipo,
        'kg_movidos': kgMovidos,
        'ubicacion_destino': ubicacionDestino,
        'venta_id': ventaId,
        'lote_destino_mezcla_id': loteDestinoMezclaId,
        'notas': notas,
      };

  factory Movimiento.fromMap(Map<String, Object?> mapa) => Movimiento(
        id: mapa['id'] as int?,
        loteAceiteId: (mapa['lote_aceite_id'] as int?) ?? 0,
        fechaMs: (mapa['fecha_ms'] as int?) ?? 0,
        tipo: (mapa['tipo'] as String?) ?? 'traslado_deposito',
        kgMovidos: (mapa['kg_movidos'] as num?)?.toDouble() ?? 0,
        ubicacionDestino: (mapa['ubicacion_destino'] as String?) ?? '',
        ventaId: mapa['venta_id'] as int?,
        loteDestinoMezclaId: mapa['lote_destino_mezcla_id'] as int?,
        notas: (mapa['notas'] as String?) ?? '',
      );
}
