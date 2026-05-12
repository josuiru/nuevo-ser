/// Lote de aceite — entidad central del libro de movimientos.
///
/// Cada molturación produce uno o varios lotes, y el lote es la unidad
/// que se mueve por el libro: traslados entre depósitos, mezclas,
/// envasados, ventas a granel. La trazabilidad obligatoria por AICA
/// y RD 760/2021 se ancla en esta tabla.
///
/// Categorías canónicas según el panel test:
///   `virgen_extra` — acidez ≤ 0.8, peróxidos ≤ 20, panel ≥ 6.5 sin
///                    defectos detectables.
///   `virgen`       — acidez ≤ 2.0, peróxidos ≤ 20, panel ≥ 5.5.
///   `lampante`     — acidez > 2.0 o defectos en panel — solo refinería.
class LoteAceite {
  final int? id;
  final int campaniaId; // FK Campania
  /// Autogenerado por convención del operador, p.ej. `2026-001`.
  final String identificadorLote;
  final int fechaCreacionMs;
  final double kgNetos;
  /// Parámetros analíticos del aceite (los típicos en certificación).
  final double? acidez;
  final double? peroxidos;
  final double? k232;
  final double? k270;
  final double? polifenolesMgKg;
  /// Puntuación 0..9 del panel test sensorial. `null` si no se ha
  /// realizado todavía.
  final double? panelTestPuntuacion;
  /// Notas del panel test (mediana de frutado / defectos detectables).
  final String panelTestNotas;
  /// Uno de: `virgen_extra` / `virgen` / `lampante` / `por_clasificar`.
  final String categoria;
  /// FK textual al catálogo `do_aceite`. Cadena vacía si lote no acogido.
  final String dopId;
  /// Texto libre — "depósito acero D-3" / "bodega A estante 12".
  final String ubicacionFisica;
  final String notas;

  LoteAceite({
    this.id,
    required this.campaniaId,
    required this.identificadorLote,
    required this.fechaCreacionMs,
    this.kgNetos = 0,
    this.acidez,
    this.peroxidos,
    this.k232,
    this.k270,
    this.polifenolesMgKg,
    this.panelTestPuntuacion,
    this.panelTestNotas = '',
    this.categoria = 'por_clasificar',
    this.dopId = '',
    this.ubicacionFisica = '',
    this.notas = '',
  });

  Map<String, Object?> toMap() => {
        'id': id,
        'campania_id': campaniaId,
        'identificador_lote': identificadorLote,
        'fecha_creacion_ms': fechaCreacionMs,
        'kg_netos': kgNetos,
        'acidez': acidez,
        'peroxidos': peroxidos,
        'k232': k232,
        'k270': k270,
        'polifenoles_mg_kg': polifenolesMgKg,
        'panel_test_puntuacion': panelTestPuntuacion,
        'panel_test_notas': panelTestNotas,
        'categoria': categoria,
        'dop_id': dopId,
        'ubicacion_fisica': ubicacionFisica,
        'notas': notas,
      };

  factory LoteAceite.fromMap(Map<String, Object?> mapa) => LoteAceite(
        id: mapa['id'] as int?,
        campaniaId: (mapa['campania_id'] as int?) ?? 0,
        identificadorLote: (mapa['identificador_lote'] as String?) ?? '',
        fechaCreacionMs: (mapa['fecha_creacion_ms'] as int?) ?? 0,
        kgNetos: (mapa['kg_netos'] as num?)?.toDouble() ?? 0,
        acidez: (mapa['acidez'] as num?)?.toDouble(),
        peroxidos: (mapa['peroxidos'] as num?)?.toDouble(),
        k232: (mapa['k232'] as num?)?.toDouble(),
        k270: (mapa['k270'] as num?)?.toDouble(),
        polifenolesMgKg: (mapa['polifenoles_mg_kg'] as num?)?.toDouble(),
        panelTestPuntuacion: (mapa['panel_test_puntuacion'] as num?)?.toDouble(),
        panelTestNotas: (mapa['panel_test_notas'] as String?) ?? '',
        categoria: (mapa['categoria'] as String?) ?? 'por_clasificar',
        dopId: (mapa['dop_id'] as String?) ?? '',
        ubicacionFisica: (mapa['ubicacion_fisica'] as String?) ?? '',
        notas: (mapa['notas'] as String?) ?? '',
      );
}
