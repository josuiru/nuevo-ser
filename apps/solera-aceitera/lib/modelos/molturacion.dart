import 'dart:convert';

/// Molturación — proceso de transformación de una o varias partidas de
/// aceituna en un lote de aceite. Es la operación central de la
/// almazara y la que enlaza el cuaderno PAC (recolección y partidas)
/// con el libro de movimientos del aceite (lote_aceite + movimientos).
///
/// `partidasUsadasIds` se serializa a JSON porque sqflite no soporta
/// arrays nativos. Lista de IDs de `PartidaAceituna` que se molturaron
/// juntas en este proceso.
class Molturacion {
  final int? id;
  final int campaniaId; // FK Campania
  final int fechaMs;
  final double kgMolturados;
  /// Rendimiento aceite/aceituna en porcentaje obtenido (típico 18-22).
  final double rendimientoPorcentaje;
  final double aceiteObtenidoKg;
  /// FK al LoteAceite generado por esta molturación. `null` solo si
  /// la molturación se registró pero aún no se asignó lote (caso raro
  /// — se permite por compatibilidad con flujos en borrador).
  final int? loteAceiteId;
  /// Kg de alperujo generado como subproducto (típico 75-80 % del kg
  /// aceituna). Usado en F2 si se cubren subproductos a extractora.
  final double alperujoKg;
  /// Identificadores libres de la batidora y el decanter usados.
  final String batidoraReferencia;
  final String decanterReferencia;
  /// Lista de IDs de PartidaAceituna serializada como JSON `[1, 4, 7]`.
  final String partidasUsadasJson;
  final String notas;

  Molturacion({
    this.id,
    required this.campaniaId,
    required this.fechaMs,
    this.kgMolturados = 0,
    this.rendimientoPorcentaje = 0,
    this.aceiteObtenidoKg = 0,
    this.loteAceiteId,
    this.alperujoKg = 0,
    this.batidoraReferencia = '',
    this.decanterReferencia = '',
    this.partidasUsadasJson = '[]',
    this.notas = '',
  });

  /// Decodifica `partidasUsadasJson` a una lista de IDs enteros.
  /// Devuelve lista vacía si el JSON no es válido — defensivo para
  /// migraciones de cuadernos antiguos.
  List<int> get partidasUsadasIds {
    try {
      final crudo = jsonDecode(partidasUsadasJson);
      if (crudo is! List) return const [];
      return crudo.whereType<num>().map((n) => n.toInt()).toList(growable: false);
    } catch (_) {
      return const [];
    }
  }

  Map<String, Object?> toMap() => {
        'id': id,
        'campania_id': campaniaId,
        'fecha_ms': fechaMs,
        'kg_molturados': kgMolturados,
        'rendimiento_porcentaje': rendimientoPorcentaje,
        'aceite_obtenido_kg': aceiteObtenidoKg,
        'lote_aceite_id': loteAceiteId,
        'alperujo_kg': alperujoKg,
        'batidora_referencia': batidoraReferencia,
        'decanter_referencia': decanterReferencia,
        'partidas_usadas_json': partidasUsadasJson,
        'notas': notas,
      };

  factory Molturacion.fromMap(Map<String, Object?> mapa) => Molturacion(
        id: mapa['id'] as int?,
        campaniaId: (mapa['campania_id'] as int?) ?? 0,
        fechaMs: (mapa['fecha_ms'] as int?) ?? 0,
        kgMolturados: (mapa['kg_molturados'] as num?)?.toDouble() ?? 0,
        rendimientoPorcentaje: (mapa['rendimiento_porcentaje'] as num?)?.toDouble() ?? 0,
        aceiteObtenidoKg: (mapa['aceite_obtenido_kg'] as num?)?.toDouble() ?? 0,
        loteAceiteId: mapa['lote_aceite_id'] as int?,
        alperujoKg: (mapa['alperujo_kg'] as num?)?.toDouble() ?? 0,
        batidoraReferencia: (mapa['batidora_referencia'] as String?) ?? '',
        decanterReferencia: (mapa['decanter_referencia'] as String?) ?? '',
        partidasUsadasJson: (mapa['partidas_usadas_json'] as String?) ?? '[]',
        notas: (mapa['notas'] as String?) ?? '',
      );
}
