/// Datos del titular de la explotación / razón social de la almazara.
/// Análogo a `Titular` en viticultura/apícola/agro. Single-row en v0.1
/// (un titular por dispositivo).
///
/// Distinción importante para el cierre fiscal REAGP: `nif` es del
/// titular agrícola (REA) y `numeroAica` solo aplica si la almazara
/// también envasa o vende aceite a otros operadores — está sujeta a
/// la Agencia de Información y Control Alimentarios.
class Titular {
  final int? id;
  final String razonSocial;
  final String nif;
  final String rgseaa; // Registro General Sanitario — solo si envasa
  final String numeroAica; // Registro AICA — solo si comercializa aceite
  final String direccion;
  final String telefono;
  final String email;
  final String ibanReagp; // datos bancarios para REAGP
  final String notas;
  final String rutasFotosJson;

  Titular({
    this.id,
    this.razonSocial = '',
    this.nif = '',
    this.rgseaa = '',
    this.numeroAica = '',
    this.direccion = '',
    this.telefono = '',
    this.email = '',
    this.ibanReagp = '',
    this.notas = '',
    this.rutasFotosJson = '[]',
  });

  Map<String, Object?> toMap() => {
        'id': id,
        'razon_social': razonSocial,
        'nif': nif,
        'rgseaa': rgseaa,
        'numero_aica': numeroAica,
        'direccion': direccion,
        'telefono': telefono,
        'email': email,
        'iban_reagp': ibanReagp,
        'notas': notas,
        'rutas_fotos_json': rutasFotosJson,
      };

  factory Titular.fromMap(Map<String, Object?> mapa) => Titular(
        id: mapa['id'] as int?,
        razonSocial: (mapa['razon_social'] as String?) ?? '',
        nif: (mapa['nif'] as String?) ?? '',
        rgseaa: (mapa['rgseaa'] as String?) ?? '',
        numeroAica: (mapa['numero_aica'] as String?) ?? '',
        direccion: (mapa['direccion'] as String?) ?? '',
        telefono: (mapa['telefono'] as String?) ?? '',
        email: (mapa['email'] as String?) ?? '',
        ibanReagp: (mapa['iban_reagp'] as String?) ?? '',
        notas: (mapa['notas'] as String?) ?? '',
        rutasFotosJson: (mapa['rutas_fotos_json'] as String?) ?? '[]',
      );
}
