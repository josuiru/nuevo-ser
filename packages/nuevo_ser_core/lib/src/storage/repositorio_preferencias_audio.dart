import 'gestor_perfiles.dart';

/// Persistencia de las preferencias de audio del perfil activo:
///   - modo silencio global (bool).
///   - volumen por capa (int 0..100).
///
/// Se monta sobre [GestorPerfiles] con shape de claves
/// `<ns>.perfil.<id>.<sufijoModoSilencio>` y
/// `<ns>.perfil.<id>.<prefijoVolumenCapa><claveCapa>`. El catálogo de
/// "qué capas existen" lo decide cada juego — el repositorio sólo
/// conoce strings.
///
/// El volumen se guarda en 0..100 porque las prefs son enteros y el
/// AudioPlayer espera 0.0..1.0; el servicio sonoro de cada juego se
/// encarga de la traducción.
class RepositorioPreferenciasAudio {
  RepositorioPreferenciasAudio({
    required this.gestor,
    this.sufijoModoSilencio = 'audio.modo_silencio',
    this.prefijoVolumenCapa = 'audio.volumen.',
  });

  final GestorPerfiles gestor;
  final String sufijoModoSilencio;
  final String prefijoVolumenCapa;

  Future<bool> cargarModoSilencio() async {
    final prefs = await gestor.prefsInicializadas();
    final clave = '${await gestor.prefijoActivo()}$sufijoModoSilencio';
    return prefs.getBool(clave) ?? false;
  }

  Future<void> guardarModoSilencio(bool silencio) async {
    final prefs = await gestor.prefsInicializadas();
    final clave = '${await gestor.prefijoActivo()}$sufijoModoSilencio';
    await prefs.setBool(clave, silencio);
  }

  /// Devuelve el volumen guardado para [claveCapa] acotado a 0..100, o
  /// [predeterminado] si nunca se ha tocado el slider de esa capa para
  /// este perfil.
  Future<int> cargarVolumenCapa(
    String claveCapa, {
    required int predeterminado,
  }) async {
    final prefs = await gestor.prefsInicializadas();
    final clave =
        '${await gestor.prefijoActivo()}$prefijoVolumenCapa$claveCapa';
    final guardado = prefs.getInt(clave);
    if (guardado == null) return predeterminado;
    return guardado.clamp(0, 100);
  }

  /// Guarda [valor] para [claveCapa] acotado a 0..100. Valores fuera de
  /// rango se recortan en silencio para tolerar bugs en sliders mal
  /// calibrados sin perder datos del niño.
  Future<void> guardarVolumenCapa(String claveCapa, int valor) async {
    final prefs = await gestor.prefsInicializadas();
    final clave =
        '${await gestor.prefijoActivo()}$prefijoVolumenCapa$claveCapa';
    await prefs.setInt(clave, valor.clamp(0, 100));
  }
}
