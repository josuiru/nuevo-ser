/// Datos del titular de la explotación apícola, requeridos por el
/// libro oficial REGA (RD 209/2002 + posibles desarrollos
/// autonómicos). Single-row en la tabla `apicultores` (la BD nunca
/// debe tener más de uno en v0.1).
///
/// `numeroRega` y `numeroExplotacionApicola` pueden ser distintos
/// según la CCAA: REGA es el código nacional unificado;
/// `numeroExplotacionApicola` es el código apícola específico que
/// algunas CCAA mantienen aparte.
///
/// El veterinario asesor con su número de colegiado es obligatorio
/// para tratamientos sanitarios — sin colegiado no hay receta válida.
class Apicultor {
  final int? id;
  final String nif;
  final String nombre;
  final String direccion;
  final String numeroRega;
  final String numeroExplotacionApicola;
  final String telefono;
  final String email;

  // Veterinario asesor
  final String nombreVeterinario;
  final String nifVeterinario;
  final String numeroColegiadoVeterinario;
  final String telefonoVeterinario;

  Apicultor({
    this.id,
    this.nif = '',
    this.nombre = '',
    this.direccion = '',
    this.numeroRega = '',
    this.numeroExplotacionApicola = '',
    this.telefono = '',
    this.email = '',
    this.nombreVeterinario = '',
    this.nifVeterinario = '',
    this.numeroColegiadoVeterinario = '',
    this.telefonoVeterinario = '',
  });

  bool get estaConfigurado =>
      nif.isNotEmpty && nombre.isNotEmpty && numeroRega.isNotEmpty;

  Map<String, Object?> toMap() => {
        'id': id,
        'nif': nif,
        'nombre': nombre,
        'direccion': direccion,
        'numero_rega': numeroRega,
        'numero_explotacion_apicola': numeroExplotacionApicola,
        'telefono': telefono,
        'email': email,
        'nombre_veterinario': nombreVeterinario,
        'nif_veterinario': nifVeterinario,
        'numero_colegiado_veterinario': numeroColegiadoVeterinario,
        'telefono_veterinario': telefonoVeterinario,
      };

  factory Apicultor.fromMap(Map<String, Object?> mapa) => Apicultor(
        id: mapa['id'] as int?,
        nif: (mapa['nif'] as String?) ?? '',
        nombre: (mapa['nombre'] as String?) ?? '',
        direccion: (mapa['direccion'] as String?) ?? '',
        numeroRega: (mapa['numero_rega'] as String?) ?? '',
        numeroExplotacionApicola: (mapa['numero_explotacion_apicola'] as String?) ?? '',
        telefono: (mapa['telefono'] as String?) ?? '',
        email: (mapa['email'] as String?) ?? '',
        nombreVeterinario: (mapa['nombre_veterinario'] as String?) ?? '',
        nifVeterinario: (mapa['nif_veterinario'] as String?) ?? '',
        numeroColegiadoVeterinario: (mapa['numero_colegiado_veterinario'] as String?) ?? '',
        telefonoVeterinario: (mapa['telefono_veterinario'] as String?) ?? '',
      );
}
