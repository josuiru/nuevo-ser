/// Proveedor de leche — ganadero externo o rebaño propio de la quesería.
class ProveedorLeche {
  final int? id;
  final String nombre;
  final String nif;
  final String direccion;
  final String explotacionGanadera; // código REGA / número explotación
  final String tipoLeche; // oveja / cabra / vaca / mixto
  final String razaId; // FK al catálogo de razas
  final int? numAnimales;
  final bool esPropio; // true = rebaño de la propia quesería
  final double? latitud;
  final double? longitud;
  final String notas;
  final int fechaCreacionMs;

  ProveedorLeche({
    this.id,
    required this.nombre,
    this.nif = '',
    this.direccion = '',
    this.explotacionGanadera = '',
    this.tipoLeche = 'oveja',
    this.razaId = '',
    this.numAnimales,
    this.esPropio = false,
    this.latitud,
    this.longitud,
    this.notas = '',
    required this.fechaCreacionMs,
  });

  Map<String, Object?> toMap() => {
        'id': id,
        'nombre': nombre,
        'nif': nif,
        'direccion': direccion,
        'explotacion_ganadera': explotacionGanadera,
        'tipo_leche': tipoLeche,
        'raza_id': razaId,
        'num_animales': numAnimales,
        'es_propio': esPropio ? 1 : 0,
        'latitud': latitud,
        'longitud': longitud,
        'notas': notas,
        'fecha_creacion_ms': fechaCreacionMs,
      };

  factory ProveedorLeche.fromMap(Map<String, Object?> mapa) => ProveedorLeche(
        id: mapa['id'] as int?,
        nombre: (mapa['nombre'] as String?) ?? '',
        nif: (mapa['nif'] as String?) ?? '',
        direccion: (mapa['direccion'] as String?) ?? '',
        explotacionGanadera: (mapa['explotacion_ganadera'] as String?) ?? '',
        tipoLeche: (mapa['tipo_leche'] as String?) ?? 'oveja',
        razaId: (mapa['raza_id'] as String?) ?? '',
        numAnimales: mapa['num_animales'] as int?,
        esPropio: (mapa['es_propio'] as int?) == 1,
        latitud: (mapa['latitud'] as num?)?.toDouble(),
        longitud: (mapa['longitud'] as num?)?.toDouble(),
        notas: (mapa['notas'] as String?) ?? '',
        fechaCreacionMs: (mapa['fecha_creacion_ms'] as int?) ?? 0,
      );
}
