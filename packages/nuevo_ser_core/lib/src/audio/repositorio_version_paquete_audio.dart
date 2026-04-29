import 'package:shared_preferences/shared_preferences.dart';

/// Persistencia de la versión del paquete sonoro descargable instalado
/// localmente.
///
/// Pareja directa de [DescargadorAudio]: los tres callbacks
/// `leerVersion`/`escribirVersion`/`borrarVersion` que el descargador
/// recibe en su constructor delegan típicamente en este repositorio.
/// Mantenerlos separados deja al descargador 100% portable (no
/// importa el almacén concreto) y al repositorio 100% atómico (no
/// conoce el ciclo de descarga).
///
/// Es **global** (no por-perfil): los OGG del paquete son los mismos
/// para todos los niños del dispositivo — no tendría sentido obligar
/// al hermano a re-descargarlos.
///
/// `null` significa "nunca se descargó nada" (primer arranque, o tras
/// un borrado de cache).
///
/// Mismo patrón de callbacks invertidos que el resto de pequeños
/// repositorios del core: recibe `prefs` y la `clave` explícita, así
/// cada juego decide su namespace (`uroto.audio.version_local`,
/// `nuevoser.lasversiones.audio.version_local`…).
class RepositorioVersionPaqueteAudio {
  RepositorioVersionPaqueteAudio({
    required this.prefs,
    required this.clave,
  });

  final Future<SharedPreferences> Function() prefs;
  final String clave;

  Future<int?> cargar() async {
    final almacen = await prefs();
    return almacen.getInt(clave);
  }

  Future<void> guardar(int version) async {
    final almacen = await prefs();
    await almacen.setInt(clave, version);
  }

  Future<void> borrar() async {
    final almacen = await prefs();
    await almacen.remove(clave);
  }
}
