class Tercero {
  final int? id;
  final String nif;
  final String nombre;
  final String direccion;
  final String telefono;
  final String email;
  final String tipo; // cliente / proveedor / ambos
  final String notas;

  Tercero({
    this.id,
    this.nif = '',
    this.nombre = '',
    this.direccion = '',
    this.telefono = '',
    this.email = '',
    this.tipo = 'ambos',
    this.notas = '',
  });

  bool get esCliente => tipo == 'cliente' || tipo == 'ambos';
  bool get esProveedor => tipo == 'proveedor' || tipo == 'ambos';
  bool get tieneNif => nif.trim().isNotEmpty;

  Map<String, Object?> toMap() => {
        'id': id,
        'nif': nif,
        'nombre': nombre,
        'direccion': direccion,
        'telefono': telefono,
        'email': email,
        'tipo': tipo,
        'notas': notas,
      };

  factory Tercero.fromMap(Map<String, Object?> mapa) => Tercero(
        id: mapa['id'] as int?,
        nif: (mapa['nif'] as String?) ?? '',
        nombre: (mapa['nombre'] as String?) ?? '',
        direccion: (mapa['direccion'] as String?) ?? '',
        telefono: (mapa['telefono'] as String?) ?? '',
        email: (mapa['email'] as String?) ?? '',
        tipo: (mapa['tipo'] as String?) ?? 'ambos',
        notas: (mapa['notas'] as String?) ?? '',
      );
}
