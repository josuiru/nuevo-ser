/// Movimiento de colmenas — el evento más característico de la
/// apicultura profesional ibérica. La trashumancia es la práctica
/// de mover colmenas a la mielada (norte en verano, brezo en otoño,
/// montaña a primavera tardía…) y a la invernada.
///
/// Cada movimiento es un evento que afecta a UNA o varias colmenas
/// concretas (por matrícula). Si `colmenaId == null`, el movimiento
/// es a nivel de apiario completo y la app expandirá automáticamente
/// para registrar todas las colmenas del apiario origen al destino.
///
/// `apiarioOrigenId` y `apiarioDestinoId` pueden ser null:
///  - origen null = colmena que se incorpora desde fuera (compra,
///    captura de enjambre fuera de los apiarios).
///  - destino null = colmena que se da de baja (muerte, venta).
///
/// La declaración previa SITRAN-AP se cumple anotando aquí el
/// movimiento; el libro oficial REGA lista todos los movimientos del
/// período como tabla de trazabilidad.
class Movimiento {
  final int? id;
  final int? colmenaId;
  final int? apiarioOrigenId;
  final int? apiarioDestinoId;
  final int fechaMovimientoMs;

  /// 'mielada' | 'invernada' | 'sanitario' | 'baja' | 'alta' |
  /// 'recogida_enjambre' | 'venta' | 'compra' | 'otro'
  final String motivo;

  final int numeroColmenas;

  /// Si `colmenaId == null` y `apiarioOrigenId/apiarioDestinoId` no
  /// son apiarios fijos sino ubicaciones puntuales (mielada
  /// temporal), guardamos coordenadas explícitas.
  final double? latitudOrigen;
  final double? longitudOrigen;
  final double? latitudDestino;
  final double? longitudDestino;

  final String notas;

  Movimiento({
    this.id,
    this.colmenaId,
    this.apiarioOrigenId,
    this.apiarioDestinoId,
    required this.fechaMovimientoMs,
    this.motivo = 'otro',
    this.numeroColmenas = 1,
    this.latitudOrigen,
    this.longitudOrigen,
    this.latitudDestino,
    this.longitudDestino,
    this.notas = '',
  });

  Map<String, Object?> toMap() => {
        'id': id,
        'colmena_id': colmenaId,
        'apiario_origen_id': apiarioOrigenId,
        'apiario_destino_id': apiarioDestinoId,
        'fecha_movimiento_ms': fechaMovimientoMs,
        'motivo': motivo,
        'numero_colmenas': numeroColmenas,
        'latitud_origen': latitudOrigen,
        'longitud_origen': longitudOrigen,
        'latitud_destino': latitudDestino,
        'longitud_destino': longitudDestino,
        'notas': notas,
      };

  factory Movimiento.fromMap(Map<String, Object?> mapa) => Movimiento(
        id: mapa['id'] as int?,
        colmenaId: mapa['colmena_id'] as int?,
        apiarioOrigenId: mapa['apiario_origen_id'] as int?,
        apiarioDestinoId: mapa['apiario_destino_id'] as int?,
        fechaMovimientoMs: mapa['fecha_movimiento_ms'] as int,
        motivo: (mapa['motivo'] as String?) ?? 'otro',
        numeroColmenas: (mapa['numero_colmenas'] as int?) ?? 1,
        latitudOrigen: (mapa['latitud_origen'] as num?)?.toDouble(),
        longitudOrigen: (mapa['longitud_origen'] as num?)?.toDouble(),
        latitudDestino: (mapa['latitud_destino'] as num?)?.toDouble(),
        longitudDestino: (mapa['longitud_destino'] as num?)?.toDouble(),
        notas: (mapa['notas'] as String?) ?? '',
      );
}
