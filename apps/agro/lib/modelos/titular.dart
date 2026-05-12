/// Datos del titular de la explotación agraria, requeridos en el
/// Cuaderno de Explotación digital (CUE) por el RD 1311/2012 sobre
/// uso sostenible de fitosanitarios.
///
/// En v1 hay un único titular por dispositivo (single-user). En F4
/// con backend multi-operador, esto se mueve a una tabla con
/// jerarquía (un mismo titular puede compartir explotación con
/// peones, asesores, etc.).
///
/// `nifAsesor` y `nifAplicador` son opcionales. Si vacíos se asume
/// que el titular se aplica a sí mismo y no tiene asesor obligado
/// (sólo lo es si el cultivo está en la lista del Anexo del RD o
/// se trata cerca de viviendas).
class Titular {
  final int? id;
  final String nif;
  final String nombre;
  final String direccion;
  final String numeroRegepa;
  final String telefono;
  final String email;

  // Asesor agronómico (cuando es obligatorio: cooperativa, ATRIA,
  // tratamientos cerca de viviendas, etc.)
  final String nombreAsesor;
  final String nifAsesor;
  final String numeroRegistroAsesor;

  // Aplicador (manipulador). Si es el mismo titular, queda vacío.
  // Si trabaja para él un peón, aquí va su NIF + carnet.
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

  bool get vacio => nif.isEmpty && nombre.isEmpty;
  bool get tieneAsesor => nombreAsesor.isNotEmpty || numeroRegistroAsesor.isNotEmpty;
  bool get tieneAplicadorDistinto => nifAplicador.isNotEmpty && nifAplicador != nif;

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

  Titular copyWith({
    String? nif,
    String? nombre,
    String? direccion,
    String? numeroRegepa,
    String? telefono,
    String? email,
    String? nombreAsesor,
    String? nifAsesor,
    String? numeroRegistroAsesor,
    String? nombreAplicador,
    String? nifAplicador,
    String? carnetAplicador,
    String? nivelCarnetAplicador,
  }) {
    return Titular(
      id: id,
      nif: nif ?? this.nif,
      nombre: nombre ?? this.nombre,
      direccion: direccion ?? this.direccion,
      numeroRegepa: numeroRegepa ?? this.numeroRegepa,
      telefono: telefono ?? this.telefono,
      email: email ?? this.email,
      nombreAsesor: nombreAsesor ?? this.nombreAsesor,
      nifAsesor: nifAsesor ?? this.nifAsesor,
      numeroRegistroAsesor: numeroRegistroAsesor ?? this.numeroRegistroAsesor,
      nombreAplicador: nombreAplicador ?? this.nombreAplicador,
      nifAplicador: nifAplicador ?? this.nifAplicador,
      carnetAplicador: carnetAplicador ?? this.carnetAplicador,
      nivelCarnetAplicador: nivelCarnetAplicador ?? this.nivelCarnetAplicador,
    );
  }
}
