/// Datos del titular de la explotación vitícola, requeridos por el
/// Cuaderno de Explotación oficial (RD 1311/2012). Single-row en la
/// tabla `titulares` (la BD nunca debe tener más de uno en v0.1).
///
/// `nivelCarnetAplicador`: 'basico' | 'cualificado' | 'fumigador' |
/// 'piloto' (libre por si MAPA añade niveles). El catálogo lo gestiona
/// la pantalla de configuración.
class Titular {
  final int? id;
  final String nif;
  final String nombre;
  final String direccion;
  final String numeroRegepa;
  final String telefono;
  final String email;

  final String nombreAsesor;
  final String nifAsesor;
  final String numeroRegistroAsesor;

  final String nombreAplicador;
  final String nifAplicador;
  final String carnetAplicador;
  final String nivelCarnetAplicador;

  Titular({
    this.id,
    this.nif = '',
    this.nombre = '',
    this.direccion = '',
    this.numeroRegepa = '',
    this.telefono = '',
    this.email = '',
    this.nombreAsesor = '',
    this.nifAsesor = '',
    this.numeroRegistroAsesor = '',
    this.nombreAplicador = '',
    this.nifAplicador = '',
    this.carnetAplicador = '',
    this.nivelCarnetAplicador = '',
  });

  bool get estaConfigurado => nif.isNotEmpty && nombre.isNotEmpty;

  Map<String, Object?> toMap() => {
        'id': id,
        'nif': nif,
        'nombre': nombre,
        'direccion': direccion,
        'numero_regepa': numeroRegepa,
        'telefono': telefono,
        'email': email,
        'nombre_asesor': nombreAsesor,
        'nif_asesor': nifAsesor,
        'numero_registro_asesor': numeroRegistroAsesor,
        'nombre_aplicador': nombreAplicador,
        'nif_aplicador': nifAplicador,
        'carnet_aplicador': carnetAplicador,
        'nivel_carnet_aplicador': nivelCarnetAplicador,
      };

  factory Titular.fromMap(Map<String, Object?> mapa) => Titular(
        id: mapa['id'] as int?,
        nif: (mapa['nif'] as String?) ?? '',
        nombre: (mapa['nombre'] as String?) ?? '',
        direccion: (mapa['direccion'] as String?) ?? '',
        numeroRegepa: (mapa['numero_regepa'] as String?) ?? '',
        telefono: (mapa['telefono'] as String?) ?? '',
        email: (mapa['email'] as String?) ?? '',
        nombreAsesor: (mapa['nombre_asesor'] as String?) ?? '',
        nifAsesor: (mapa['nif_asesor'] as String?) ?? '',
        numeroRegistroAsesor: (mapa['numero_registro_asesor'] as String?) ?? '',
        nombreAplicador: (mapa['nombre_aplicador'] as String?) ?? '',
        nifAplicador: (mapa['nif_aplicador'] as String?) ?? '',
        carnetAplicador: (mapa['carnet_aplicador'] as String?) ?? '',
        nivelCarnetAplicador: (mapa['nivel_carnet_aplicador'] as String?) ?? '',
      );
}
