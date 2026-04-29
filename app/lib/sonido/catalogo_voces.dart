import '../dominio/voz_personaje.dart';

/// Catálogo de voces TTS para frases canónicas del castellano. La
/// fuente de verdad humana es `scripts/sonido/voces/lote_inicial.tsv`
/// y los demás `.tsv` que se vayan añadiendo. Este archivo Dart es la
/// proyección de ese contenido al runtime: su contenido se mantiene
/// sincronizado a mano con los TSV (mientras el lote sea pequeño).
///
/// Búsqueda: la pantalla cinemática consulta `rutaVozPara(voz, texto)`
/// con el texto **canónico en castellano** (antes de aplicar tokens y
/// antes de traducir a eu/ca). Si hay match devuelve la ruta del
/// asset; si no, null y la cinemática sigue muda como hoy.
///
/// Mientras no se hayan generado los OGG, todas las consultas
/// devuelven null sin error: la app no peta. El asset descargado
/// solo se reproduce si el archivo está realmente en disco — el
/// `ServicioSonoro` ya tolera ausencia.
class CatalogoVoces {
  static const Map<VozPersonaje, Map<String, String>> _porPersonaje = {
    VozPersonaje.sora: {
      'Llegas tarde.': 'assets/sonido/voces/sora/1_1_llegas_tarde.ogg',
      'Siempre llegáis tarde.':
          'assets/sonido/voces/sora/1_1_siempre_llegais.ogg',
      'Mm.': 'assets/sonido/voces/sora/1_1_mm.ogg',
      'Eso es la Montaña. Hoy no.':
          'assets/sonido/voces/sora/1_1_eso_es_la_montana.ogg',
      'Yo voy a enseñarte.':
          'assets/sonido/voces/sora/1_1_yo_voy_a_ensenarte.ogg',
    },
    VozPersonaje.fragmentoKurz: {
      'Otro.': 'assets/sonido/voces/fragmentoKurz/1_5_otro.ogg',
      'Pequeño.': 'assets/sonido/voces/fragmentoKurz/1_5_pequeno.ogg',
      '¿Empezamos?': 'assets/sonido/voces/fragmentoKurz/1_5_empezamos.ogg',
    },
    VozPersonaje.fragmentoEco: {
      'Hola.': 'assets/sonido/voces/fragmentoEco/primera_hola.ogg',
      'Otro nuevo.':
          'assets/sonido/voces/fragmentoEco/primera_otro_nuevo.ogg',
    },
  };

  /// Devuelve la ruta de asset de la voz para `(personaje, texto)`,
  /// o null si esa frase aún no tiene voz generada.
  static String? rutaVozPara(VozPersonaje voz, String textoCanonicoEs) {
    return _porPersonaje[voz]?[textoCanonicoEs];
  }
}
