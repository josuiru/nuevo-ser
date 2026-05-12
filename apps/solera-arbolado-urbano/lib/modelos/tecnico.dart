/// Operario o técnico autorizado para firmar partes de actuación. La
/// app es B2B: distintos operarios firman distintas inspecciones, podas
/// o tratamientos en la misma BD. Cada actuación lleva el `tecnicoId`
/// de quien la firmó para auditoría municipal.
///
/// El campo `empresaContratista` es necesario cuando el ayuntamiento
/// subcontrata el mantenimiento — el parte municipal debe identificar
/// la empresa, no sólo a la persona. Si no hay subcontrata se deja
/// vacío.
///
/// `carnetAplicador` y `nivelCarnetAplicador` son obligatorios para
/// firmar `Tratamiento` (por compliance fitosanitaria — RD 1311/2012
/// aplica también al uso público de fitosanitarios). El nivel valida
/// para qué productos puede aplicar.
///
/// Hay un único `Ayuntamiento` por instalación de la app (single-row,
/// patrón heredado de `Apicultor`/`Titular`).
class Tecnico {
  final int? id;
  final String nif;
  final String nombre;
  final String empresaContratista;
  final String cifEmpresa;
  final String telefono;
  final String email;
  final String carnetAplicador;
  final String nivelCarnetAplicador;
  final bool activo;

  Tecnico({
    this.id,
    this.nif = '',
    this.nombre = '',
    this.empresaContratista = '',
    this.cifEmpresa = '',
    this.telefono = '',
    this.email = '',
    this.carnetAplicador = '',
    this.nivelCarnetAplicador = '',
    this.activo = true,
  });

  bool get puedeAplicarFitosanitarios =>
      carnetAplicador.isNotEmpty && nivelCarnetAplicador.isNotEmpty;

  Map<String, Object?> toMap() => {
        'id': id,
        'nif': nif,
        'nombre': nombre,
        'empresa_contratista': empresaContratista,
        'cif_empresa': cifEmpresa,
        'telefono': telefono,
        'email': email,
        'carnet_aplicador': carnetAplicador,
        'nivel_carnet_aplicador': nivelCarnetAplicador,
        'activo': activo ? 1 : 0,
      };

  factory Tecnico.fromMap(Map<String, Object?> mapa) => Tecnico(
        id: mapa['id'] as int?,
        nif: (mapa['nif'] as String?) ?? '',
        nombre: (mapa['nombre'] as String?) ?? '',
        empresaContratista: (mapa['empresa_contratista'] as String?) ?? '',
        cifEmpresa: (mapa['cif_empresa'] as String?) ?? '',
        telefono: (mapa['telefono'] as String?) ?? '',
        email: (mapa['email'] as String?) ?? '',
        carnetAplicador: (mapa['carnet_aplicador'] as String?) ?? '',
        nivelCarnetAplicador: (mapa['nivel_carnet_aplicador'] as String?) ?? '',
        activo: (mapa['activo'] as int?) == 1,
      );
}

/// Datos del ayuntamiento titular de la instancia de la app. Single-row.
/// Aparece en la cabecera del informe municipal.
class Ayuntamiento {
  final int? id;
  final String nombre;
  final String cif;
  final String direccion;
  final String municipio;
  final String provincia;
  final String codigoPostal;
  final String nombreConcejal;
  final String concejalia;
  final String email;
  final String telefono;

  Ayuntamiento({
    this.id,
    this.nombre = '',
    this.cif = '',
    this.direccion = '',
    this.municipio = '',
    this.provincia = '',
    this.codigoPostal = '',
    this.nombreConcejal = '',
    this.concejalia = '',
    this.email = '',
    this.telefono = '',
  });

  bool get estaConfigurado =>
      nombre.isNotEmpty && cif.isNotEmpty && municipio.isNotEmpty;

  Map<String, Object?> toMap() => {
        'id': id,
        'nombre': nombre,
        'cif': cif,
        'direccion': direccion,
        'municipio': municipio,
        'provincia': provincia,
        'codigo_postal': codigoPostal,
        'nombre_concejal': nombreConcejal,
        'concejalia': concejalia,
        'email': email,
        'telefono': telefono,
      };

  factory Ayuntamiento.fromMap(Map<String, Object?> mapa) => Ayuntamiento(
        id: mapa['id'] as int?,
        nombre: (mapa['nombre'] as String?) ?? '',
        cif: (mapa['cif'] as String?) ?? '',
        direccion: (mapa['direccion'] as String?) ?? '',
        municipio: (mapa['municipio'] as String?) ?? '',
        provincia: (mapa['provincia'] as String?) ?? '',
        codigoPostal: (mapa['codigo_postal'] as String?) ?? '',
        nombreConcejal: (mapa['nombre_concejal'] as String?) ?? '',
        concejalia: (mapa['concejalia'] as String?) ?? '',
        email: (mapa['email'] as String?) ?? '',
        telefono: (mapa['telefono'] as String?) ?? '',
      );
}
