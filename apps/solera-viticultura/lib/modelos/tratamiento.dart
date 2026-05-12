/// Tratamiento aplicado a la cepa: fitosanitario, abono, riego
/// puntual, poda. `producto` es free-text en v0.1; en F1-7 se valida
/// contra la BBDD de productos fitosanitarios autorizados (publicada
/// por MAPA) y se calcula automáticamente el plazo de seguridad
/// para incluirlo en el libro oficial de tratamientos.
///
/// `tipo` para clasificación gruesa: 'fitosanitario' | 'abono' |
/// 'riego' | 'poda' | 'otro'.
/// `incidenciaId` opcional: si el tratamiento responde a una
/// incidencia concreta (mildiu detectado, oídio, botritis…), se
/// enlaza para poder cerrar la incidencia cuando aplica.
///
/// Campos PAC (Cuaderno oficial, RD 1311/2012):
///  - `numeroRegistroFitosanitario` debe venir de la BBDD oficial
///    cuando el tipo es fitosanitario.
///  - `nifAplicador` permite distinguir cuándo aplica el titular vs
///    un peón/asesor con carnet específico de aplicador.
///  - `superficieTratadaHectareas` porque la inspección lo exige
///    expresamente para calcular dosis reales por hectárea.
class Tratamiento {
  final int? id;
  final int cepaId;
  final int fechaMs;
  final String tipo;
  final String producto;
  final String dosis;
  final String motivo;
  final int? plazoSeguridadDias;
  final int? incidenciaId;
  final String notas;

  // Cuaderno oficial PAC
  final String numeroRegistroFitosanitario;
  final String nifAplicador;
  final double? superficieTratadaHectareas;

  Tratamiento({
    this.id,
    required this.cepaId,
    required this.fechaMs,
    this.tipo = 'otro',
    this.producto = '',
    this.dosis = '',
    this.motivo = '',
    this.plazoSeguridadDias,
    this.incidenciaId,
    this.notas = '',
    this.numeroRegistroFitosanitario = '',
    this.nifAplicador = '',
    this.superficieTratadaHectareas,
  });

  Map<String, Object?> toMap() => {
        'id': id,
        'cepa_id': cepaId,
        'fecha_ms': fechaMs,
        'tipo': tipo,
        'producto': producto,
        'dosis': dosis,
        'motivo': motivo,
        'plazo_seguridad_dias': plazoSeguridadDias,
        'incidencia_id': incidenciaId,
        'notas': notas,
        'numero_registro_fitosanitario': numeroRegistroFitosanitario,
        'nif_aplicador': nifAplicador,
        'superficie_tratada_hectareas': superficieTratadaHectareas,
      };

  factory Tratamiento.fromMap(Map<String, Object?> mapa) => Tratamiento(
        id: mapa['id'] as int?,
        cepaId: mapa['cepa_id'] as int,
        fechaMs: mapa['fecha_ms'] as int,
        tipo: (mapa['tipo'] as String?) ?? 'otro',
        producto: (mapa['producto'] as String?) ?? '',
        dosis: (mapa['dosis'] as String?) ?? '',
        motivo: (mapa['motivo'] as String?) ?? '',
        plazoSeguridadDias: mapa['plazo_seguridad_dias'] as int?,
        incidenciaId: mapa['incidencia_id'] as int?,
        notas: (mapa['notas'] as String?) ?? '',
        numeroRegistroFitosanitario:
            (mapa['numero_registro_fitosanitario'] as String?) ?? '',
        nifAplicador: (mapa['nif_aplicador'] as String?) ?? '',
        superficieTratadaHectareas:
            (mapa['superficie_tratada_hectareas'] as num?)?.toDouble(),
      );
}
