import 'gestor_perfiles.dart';

/// Persistencia de la ruta a la imagen-avatar del niño asociada al
/// perfil activo.
///
/// Es **por-perfil**: cada hermano del dispositivo tiene su propio
/// personaje, así que la clave vive bajo el prefijo del perfil
/// (`<ns>.perfil.<id>.<sufijoRuta>`). Por eso se monta sobre
/// [GestorPerfiles] (no sobre callbacks crudos al `SharedPreferences`
/// como los repositorios globales).
///
/// La imagen apuntada por la ruta vive típicamente bajo el directorio
/// de documentos de la app — el repositorio sólo guarda el string;
/// quien escribe el archivo es el llamador (típicamente
/// `image_picker` + `path_provider`).
///
/// `null` significa "todavía no ha subido nada" — la vista del juego
/// cae al avatar genérico. Cadenas vacías o sólo-espacios también se
/// tratan como `null` para tolerar bugs en pantallas mal calibradas
/// sin romper el flujo del niño.
class RepositorioAvatarPerfil {
  RepositorioAvatarPerfil({
    required this.gestor,
    this.sufijoRuta = 'avatar.ruta',
  });

  final GestorPerfiles gestor;
  final String sufijoRuta;

  Future<String?> cargarRuta() async {
    final prefs = await gestor.prefsInicializadas();
    final clave = '${await gestor.prefijoActivo()}$sufijoRuta';
    final ruta = prefs.getString(clave);
    if (ruta == null || ruta.trim().isEmpty) return null;
    return ruta;
  }

  Future<void> guardarRuta(String ruta) async {
    final prefs = await gestor.prefsInicializadas();
    final clave = '${await gestor.prefijoActivo()}$sufijoRuta';
    await prefs.setString(clave, ruta);
  }

  Future<void> borrarRuta() async {
    final prefs = await gestor.prefsInicializadas();
    final clave = '${await gestor.prefijoActivo()}$sufijoRuta';
    await prefs.remove(clave);
  }
}
