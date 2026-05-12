/// Receta — cada tipo de queso que fabrica la quesería.
/// Almacena los parámetros de proceso y los ingredientes para
/// que al crear un lote se herede la configuración.
class Receta {
  final int? id;
  final String nombre; // ej. "Idiazabal semicurado", "Curado de cabra"
  final String tipoQuesoId; // FK al catálogo tipos_queso
  final String? doId; // FK a DO (nullable = sin DO)
  final String tipoLeche; // oveja / cabra / vaca / mezcla
  final String fermento;
  final String tipoCuajo; // animal / vegetal / microbiano
  final double tempCoagulacion;
  final int tiempoCoagMinutos;
  final String tamCuajada; // grano grueso / medio / fino
  final double? tempCocion;
  final double? phSalado;
  final double rendimientoEsperado; // L leche por kg de queso
  final int curacionMinimaDias;
  final String notas;

  Receta({
    this.id,
    required this.nombre,
    this.tipoQuesoId = '',
    this.doId,
    this.tipoLeche = 'oveja',
    this.fermento = '',
    this.tipoCuajo = 'animal',
    this.tempCoagulacion = 30,
    this.tiempoCoagMinutos = 30,
    this.tamCuajada = 'medio',
    this.tempCocion,
    this.phSalado,
    this.rendimientoEsperado = 8,
    this.curacionMinimaDias = 60,
    this.notas = '',
  });

  Map<String, Object?> toMap() => {
        'id': id,
        'nombre': nombre,
        'tipo_queso_id': tipoQuesoId,
        'do_id': doId,
        'tipo_leche': tipoLeche,
        'fermento': fermento,
        'tipo_cuajo': tipoCuajo,
        'temp_coagulacion': tempCoagulacion,
        'tiempo_coag_minutos': tiempoCoagMinutos,
        'tam_cuajada': tamCuajada,
        'temp_cocion': tempCocion,
        'ph_salado': phSalado,
        'rendimiento_esperado': rendimientoEsperado,
        'curacion_minima_dias': curacionMinimaDias,
        'notas': notas,
      };

  factory Receta.fromMap(Map<String, Object?> mapa) => Receta(
        id: mapa['id'] as int?,
        nombre: (mapa['nombre'] as String?) ?? '',
        tipoQuesoId: (mapa['tipo_queso_id'] as String?) ?? '',
        doId: mapa['do_id'] as String?,
        tipoLeche: (mapa['tipo_leche'] as String?) ?? 'oveja',
        fermento: (mapa['fermento'] as String?) ?? '',
        tipoCuajo: (mapa['tipo_cuajo'] as String?) ?? 'animal',
        tempCoagulacion: (mapa['temp_coagulacion'] as num?)?.toDouble() ?? 30,
        tiempoCoagMinutos: (mapa['tiempo_coag_minutos'] as int?) ?? 30,
        tamCuajada: (mapa['tam_cuajada'] as String?) ?? 'medio',
        tempCocion: (mapa['temp_cocion'] as num?)?.toDouble(),
        phSalado: (mapa['ph_salado'] as num?)?.toDouble(),
        rendimientoEsperado: (mapa['rendimiento_esperado'] as num?)?.toDouble() ?? 8,
        curacionMinimaDias: (mapa['curacion_minima_dias'] as int?) ?? 60,
        notas: (mapa['notas'] as String?) ?? '',
      );
}
