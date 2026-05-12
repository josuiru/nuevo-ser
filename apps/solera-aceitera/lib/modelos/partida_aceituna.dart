/// Partida de aceituna — recepción en la almazara. La almazara recibe
/// la aceituna en báscula (kg netos), la cata para determinar
/// porcentaje de defectos, y le asigna un número de albarán que
/// trazará todo el proceso hasta el lote de aceite.
///
/// Si la almazara es cooperativista, la aceituna puede venir de un
/// socio externo — `origenEsSocio = true` y la `recoleccionId` queda
/// `null` (la cooperativa no controla los partes de recolección de
/// sus socios). Si es finca propia, la `recoleccionId` referencia la
/// recolección concreta.
class PartidaAceituna {
  final int? id;
  final int campaniaId; // FK Campania
  /// FK a Recoleccion. `null` si la aceituna viene de socio externo.
  final int? recoleccionId;
  final int fechaMs;
  final double kgNetosBascula;
  /// Porcentaje 0..100 de aceituna defectuosa según cata.
  final double porcentajeAceitunaDefectuosa;
  final String catador;
  final String numeroAlbaran;
  final bool origenEsSocio;
  /// Nombre del socio cooperativista externo si `origenEsSocio = true`.
  /// Vacío en finca propia.
  final String socioExterno;
  final String notas;
  final String rutasFotosJson;

  PartidaAceituna({
    this.id,
    required this.campaniaId,
    this.recoleccionId,
    required this.fechaMs,
    this.kgNetosBascula = 0,
    this.porcentajeAceitunaDefectuosa = 0,
    this.catador = '',
    this.numeroAlbaran = '',
    this.origenEsSocio = false,
    this.socioExterno = '',
    this.notas = '',
    this.rutasFotosJson = '[]',
  });

  Map<String, Object?> toMap() => {
        'id': id,
        'campania_id': campaniaId,
        'recoleccion_id': recoleccionId,
        'fecha_ms': fechaMs,
        'kg_netos_bascula': kgNetosBascula,
        'porcentaje_aceituna_defectuosa': porcentajeAceitunaDefectuosa,
        'catador': catador,
        'numero_albaran': numeroAlbaran,
        'origen_es_socio': origenEsSocio ? 1 : 0,
        'socio_externo': socioExterno,
        'notas': notas,
        'rutas_fotos_json': rutasFotosJson,
      };

  factory PartidaAceituna.fromMap(Map<String, Object?> mapa) => PartidaAceituna(
        id: mapa['id'] as int?,
        campaniaId: (mapa['campania_id'] as int?) ?? 0,
        recoleccionId: mapa['recoleccion_id'] as int?,
        fechaMs: (mapa['fecha_ms'] as int?) ?? 0,
        kgNetosBascula: (mapa['kg_netos_bascula'] as num?)?.toDouble() ?? 0,
        porcentajeAceitunaDefectuosa:
            (mapa['porcentaje_aceituna_defectuosa'] as num?)?.toDouble() ?? 0,
        catador: (mapa['catador'] as String?) ?? '',
        numeroAlbaran: (mapa['numero_albaran'] as String?) ?? '',
        origenEsSocio: (mapa['origen_es_socio'] as int? ?? 0) == 1,
        socioExterno: (mapa['socio_externo'] as String?) ?? '',
        notas: (mapa['notas'] as String?) ?? '',
        rutasFotosJson: (mapa['rutas_fotos_json'] as String?) ?? '[]',
      );
}
