import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../datos/repositorio_progreso.dart';

/// Mediador entre `image_picker` y el repositorio. Abre la cámara o
/// la galería del aparato, copia la imagen elegida al directorio de
/// documentos de la app (así sobrevive a movimientos en la galería
/// del usuario) y guarda la ruta en el perfil activo.
///
/// Diseño:
/// - **Privacidad**: la imagen NUNCA sale del aparato. No se sube al
///   backend. Sólo se referencia su ruta absoluta local.
/// - **Calidad**: redimensionamos a 800 px máx para no llenar el
///   almacenamiento si el niño hace una foto a 12 MP.
/// - **Tolera fallo**: si el usuario cancela o el plugin no está
///   disponible (tests, headless), devuelve `null` sin lanzar.
class SeleccionadorAvatar {
  final RepositorioProgreso repositorio;

  SeleccionadorAvatar(this.repositorio);

  /// Abre la galería del aparato. Devuelve la nueva ruta o `null` si
  /// el usuario canceló o hubo un fallo.
  Future<String?> elegirDeGaleria() => _elegir(ImageSource.gallery);

  /// Abre la cámara para hacer una foto al dibujo en papel. Devuelve
  /// la nueva ruta o `null`.
  Future<String?> hacerFoto() => _elegir(ImageSource.camera);

  Future<String?> _elegir(ImageSource fuente) async {
    try {
      final picker = ImagePicker();
      final elegido = await picker.pickImage(
        source: fuente,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );
      if (elegido == null) return null;

      // Copiamos al directorio de documentos para no depender de
      // archivos que el usuario pueda borrar de su galería.
      final docs = await getApplicationDocumentsDirectory();
      final destino = File(
        '${docs.path}/avatar_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );
      await File(elegido.path).copy(destino.path);

      // Si ya había un avatar antiguo, lo borramos para no acumular.
      final rutaAnterior = await repositorio.cargarRutaAvatar();
      if (rutaAnterior != null) {
        final viejo = File(rutaAnterior);
        if (await viejo.exists()) {
          await viejo.delete();
        }
      }

      await repositorio.guardarRutaAvatar(destino.path);
      return destino.path;
    } catch (_) {
      // Plugin no disponible (tests/headless), permiso denegado, o
      // fallo de I/O — la app sigue, sin avatar nuevo.
      return null;
    }
  }
}
