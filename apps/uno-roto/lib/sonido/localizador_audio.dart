import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';

/// Resuelve un identificador lógico de sonido a la fuente que
/// `audioplayers` necesita reproducir.
///
/// Política de resolución:
///
/// 1. Si existe un archivo en
///    `<ApplicationDocumentsDirectory>/uroto/sonido/<sufijo>`, devuelve
///    [DeviceFileSource] apuntándolo. Esto es lo que llena el
///    descargador de paquete sonoro tras el primer arranque (doc 03 §sonido).
/// 2. Si no, devuelve [AssetSource] con la ruta relativa al bundle de
///    assets. Solo los efectos cortos van empaquetados en el APK; el
///    resto fallará y `ServicioSonoro` lo silenciará.
///
/// El localizador cachea el path absoluto del directorio para no llamar
/// a [getApplicationDocumentsDirectory] en cada reproducción.
class LocalizadorAudio {
  LocalizadorAudio._();
  static final LocalizadorAudio instancia = LocalizadorAudio._();

  String? _rutaCacheBase;

  /// Sufijo relativo a la **cache local** (`<docs>/uroto/sonido/`).
  /// Para `assets/sonido/efectos/acierto.ogg` devuelve
  /// `efectos/acierto.ogg`.
  static String sufijoCacheLocal(String rutaAsset) {
    const prefijo = 'assets/sonido/';
    if (rutaAsset.startsWith(prefijo)) {
      return rutaAsset.substring(prefijo.length);
    }
    return rutaAsset;
  }

  /// Sufijo que necesita [AssetSource]: relativo al directorio
  /// `assets/` del bundle Flutter (NO incluye el `assets/` líder).
  /// Para `assets/sonido/efectos/acierto.ogg` devuelve
  /// `sonido/efectos/acierto.ogg`.
  static String sufijoAssetBundle(String rutaAsset) {
    const prefijo = 'assets/';
    if (rutaAsset.startsWith(prefijo)) {
      return rutaAsset.substring(prefijo.length);
    }
    return rutaAsset;
  }

  /// Path absoluto del directorio donde el descargador deja los OGG.
  /// Crea el directorio si no existe. Memoriza el resultado.
  Future<String> rutaBaseCache() async {
    final cacheada = _rutaCacheBase;
    if (cacheada != null) return cacheada;
    final docs = await getApplicationDocumentsDirectory();
    final dir = Directory('${docs.path}/uroto/sonido');
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    _rutaCacheBase = dir.path;
    return dir.path;
  }

  /// Resuelve un id catalogado a un [Source]. Devuelve `null` si el
  /// archivo no está ni en cache local ni en el bundle de assets — el
  /// motor sonoro interpretará null como "silencio".
  ///
  /// La existencia del asset bundleado no se puede comprobar a priori
  /// sin intentar reproducirlo, así que esta función solo verifica el
  /// cache local; si no está, devuelve [AssetSource] y dejamos que
  /// `audioplayers` falle silenciosamente arriba.
  Future<Source> resolver(String rutaAsset) async {
    try {
      final base = await rutaBaseCache();
      final candidato = File('$base/${sufijoCacheLocal(rutaAsset)}');
      if (await candidato.exists()) {
        return DeviceFileSource(candidato.path);
      }
    } catch (_) {
      // path_provider puede fallar en tests sin platform channel — caemos
      // al asset bundle.
    }
    return AssetSource(sufijoAssetBundle(rutaAsset));
  }

  /// Limpia el cache memorizado. Útil tras borrar el directorio en una
  /// purga de paquete o para tests.
  void invalidar() {
    _rutaCacheBase = null;
  }
}
