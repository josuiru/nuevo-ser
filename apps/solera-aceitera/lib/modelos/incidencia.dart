/// Incidencia — anomalía registrada en el olivar (sequía, helada, plaga
/// grave) o en la almazara (avería, sobrefermentación, lote defectuoso).
///
/// `ambito` distingue entre las dos partes del proceso. `parcelaId` y
/// `loteAceiteId` son mutuamente excluyentes en la práctica pero el
/// modelo permite ambos null para incidencias generales del olivar.
class Incidencia {
  final int? id;
  final int fechaMs;
  /// Uno de: `olivar` / `almazara`.
  final String ambito;
  final int? parcelaId; // FK Parcela (si ambito == 'olivar')
  final int? loteAceiteId; // FK LoteAceite (si ambito == 'almazara')
  /// Uno de: `sequia` / `helada` / `viento_levante` / `plaga_grave` /
  /// `enfermedad_olivar` / `averia_almazara` / `sobrefermentacion` /
  /// `lote_defectuoso` / `otro`.
  final String tipo;
  final String descripcion;
  /// Uno de: `leve` / `moderada` / `grave`.
  final String severidad;
  final String accionCorrectiva;
  final String notas;
  final String rutasFotosJson;

  Incidencia({
    this.id,
    required this.fechaMs,
    required this.ambito,
    this.parcelaId,
    this.loteAceiteId,
    required this.tipo,
    this.descripcion = '',
    this.severidad = 'leve',
    this.accionCorrectiva = '',
    this.notas = '',
    this.rutasFotosJson = '[]',
  });

  Map<String, Object?> toMap() => {
        'id': id,
        'fecha_ms': fechaMs,
        'ambito': ambito,
        'parcela_id': parcelaId,
        'lote_aceite_id': loteAceiteId,
        'tipo': tipo,
        'descripcion': descripcion,
        'severidad': severidad,
        'accion_correctiva': accionCorrectiva,
        'notas': notas,
        'rutas_fotos_json': rutasFotosJson,
      };

  factory Incidencia.fromMap(Map<String, Object?> mapa) => Incidencia(
        id: mapa['id'] as int?,
        fechaMs: (mapa['fecha_ms'] as int?) ?? 0,
        ambito: (mapa['ambito'] as String?) ?? 'olivar',
        parcelaId: mapa['parcela_id'] as int?,
        loteAceiteId: mapa['lote_aceite_id'] as int?,
        tipo: (mapa['tipo'] as String?) ?? 'otro',
        descripcion: (mapa['descripcion'] as String?) ?? '',
        severidad: (mapa['severidad'] as String?) ?? 'leve',
        accionCorrectiva: (mapa['accion_correctiva'] as String?) ?? '',
        notas: (mapa['notas'] as String?) ?? '',
        rutasFotosJson: (mapa['rutas_fotos_json'] as String?) ?? '[]',
      );
}
