/// Tercero económico: cliente o proveedor de la almazara. Una sola
/// tabla con campo `tipo` que admite 'cliente' | 'proveedor' | 'ambos'.
///
/// El NIF identifica al tercero a efectos del modelo 347 (operaciones
/// >3.005,06 €/año con un mismo NIF). En v1 permitimos NIF vacío
/// (venta directa a particular en almazara) — esos apuntes el resumen
/// anual los lista aparte porque NO entran al 347.
///
/// Pareja natural en olivar:
///   - cliente típico: cooperativa receptora de aceituna, almazara
///     compradora (si el titular vende sólo aceituna), envasador
///     comprador a granel, consumidor final en envasado propio.
///   - proveedor típico: suministro de abonos/fertilizantes, taller
///     de maquinaria, laboratorio de analíticas, consejo regulador
///     DOP, asegurador agrario, transportista a almazara externa.
class Tercero {
  final int? id;
  final String nif;
  final String nombre;
  final String direccion;
  final String telefono;
  final String email;

  /// 'cliente' | 'proveedor' | 'ambos'
  final String tipo;
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
