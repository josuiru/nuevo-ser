import 'package:image_picker/image_picker.dart';

/// Contrato del selector de imagen — la pantalla de Nueva Observación
/// lo usa para que el niño tome una foto con la cámara o elija una de
/// la galería sin acoplarse a `image_picker`. Esto permite tests con
/// un fake (no se puede invocar `image_picker` en widget tests porque
/// requiere capa nativa).
///
/// Los métodos devuelven la **ruta absoluta** del fichero
/// seleccionado, o null si el niño canceló. El consumidor (la
/// pantalla) toma esa ruta y la pasa al `AlmacenadorMedios.guardar`
/// para persistirla en el directorio de la app.
abstract class SelectorImagen {
  /// Abre la cámara nativa y devuelve la ruta del fichero capturado.
  /// Devuelve null si el niño cancela o si el sistema deniega el
  /// permiso de cámara.
  Future<String?> desdeCamara();

  /// Abre el picker de la galería y devuelve la ruta del fichero
  /// seleccionado. Devuelve null si el niño cancela o si el sistema
  /// deniega el permiso de lectura.
  Future<String?> desdeGaleria();
}

/// Implementación real con `image_picker`. La calidad se baja a 85%
/// y la dimensión máxima a 1600 px para que las fotos quepan en el
/// almacenamiento del dispositivo durante un piloto de varias
/// semanas — biblia §3.2 explícitamente prefiere "registrar para
/// recordar" sobre "calidad fotográfica profesional".
class SelectorImagenImagePicker implements SelectorImagen {
  SelectorImagenImagePicker({ImagePicker? picker})
      : _picker = picker ?? ImagePicker();

  final ImagePicker _picker;

  @override
  Future<String?> desdeCamara() async {
    final fichero = await _picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1600,
      maxHeight: 1600,
      imageQuality: 85,
    );
    return fichero?.path;
  }

  @override
  Future<String?> desdeGaleria() async {
    final fichero = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1600,
      maxHeight: 1600,
      imageQuality: 85,
    );
    return fichero?.path;
  }
}
