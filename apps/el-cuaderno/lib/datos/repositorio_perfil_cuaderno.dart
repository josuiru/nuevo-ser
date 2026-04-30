import 'package:nuevo_ser_core/nuevo_ser_core.dart';

/// Repositorio de perfiles del Cuaderno. Envuelve [GestorPerfiles] del
/// core con la convención del juego:
///
/// - **Namespace**: `nuevoser.elcuaderno`. Bajo este prefijo viven todas
///   las claves del juego, separadas en globales (`<ns>.<sufijo>`) y
///   por-perfil (`<ns>.perfil.<id>.<sufijo>`).
/// - **Sufijo del nombre del niño**: `nombre_jugador`. Mismo nombre que
///   uno-roto/las-versiones para reutilizar el patrón.
/// - **Claves globales protegidas**: las cuatro del juego (idioma,
///   token JWT, email del backend, cola de sync de observaciones) +
///   las claves administrativas del propio gestor (`perfil_activo_id`,
///   `perfiles_lista`). Sin esta whitelist, el migrador moveria
///   `nuevoser.elcuaderno.idioma_app` al prefijo del perfil y rompería
///   la lectura del idioma global.
///
/// Diseñado para que `main.dart` pase un único objeto a la pantalla de
/// bienvenida en lugar de mil callbacks; toda la lógica de persistir
/// nombres y elegir el perfil activo vive aquí.
class RepositorioPerfilCuaderno {
  RepositorioPerfilCuaderno() : _gestor = _crearGestor();

  final GestorPerfiles _gestor;

  static GestorPerfiles _crearGestor() {
    return GestorPerfiles(
      namespace: 'nuevoser.elcuaderno',
      sufijoNombreVisible: 'nombre_jugador',
      clavesGlobalesNoMigrables: const {
        'nuevoser.elcuaderno.idioma_app',
        'nuevoser.elcuaderno.token_backend',
        'nuevoser.elcuaderno.email_backend',
        'nuevoser.elcuaderno.cola_sync.observaciones',
      },
    );
  }

  GestorPerfiles get gestor => _gestor;

  /// `true` si ya hay al menos un perfil con nombre. El primer arranque
  /// (sin perfiles ni nombre) devuelve `false` y el orquestador muestra
  /// la pantalla de bienvenida.
  Future<bool> tieneAlgunPerfilConNombre() async {
    final lista = await _gestor.listarPerfilesConInfo();
    if (lista.isEmpty) return false;
    return lista.any((p) => p.nombreVisible.trim().isNotEmpty &&
        p.nombreVisible.trim() != p.id);
  }

  /// Crea el primer perfil con [nombre] y lo deja como activo. Llama
  /// internamente al gestor; el id se deriva del nombre (slug).
  Future<void> crearYActivarPerfil(String nombre) async {
    final id = await _gestor.crearPerfil(nombre);
    await _gestor.cambiarAPerfil(id);
  }

  /// Nombre humano del perfil activo, o null si no hay perfil con
  /// nombre real (caso primer arranque tras elegir idioma).
  Future<String?> nombrePerfilActivo() async {
    final lista = await _gestor.listarPerfilesConInfo();
    final activo = lista.where((p) => p.esActivo).cast<PerfilInfo?>().firstWhere(
          (_) => true,
          orElse: () => null,
        );
    if (activo == null) return null;
    final nombre = activo.nombreVisible.trim();
    if (nombre.isEmpty || nombre == activo.id) return null;
    return nombre;
  }
}
