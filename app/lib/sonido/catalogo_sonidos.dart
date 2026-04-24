import 'capa_audio.dart';

/// Mapeo de identificadores lógicos a rutas de asset. Si un archivo no
/// existe todavía (placeholder), el motor sonoro tolera la ausencia y
/// la llamada es silenciosa.
///
/// Ids estables: código de juego invoca por id ("efecto_acierto",
/// "ambient_tejados") y el catálogo decide qué archivo suena. Esto
/// permite cambiar o sustituir assets sin tocar puntos de llamada.
class SonidoCatalogado {
  final String identificador;
  final CapaAudio capa;
  final String rutaAsset;
  final bool enBucle;

  const SonidoCatalogado({
    required this.identificador,
    required this.capa,
    required this.rutaAsset,
    this.enBucle = false,
  });
}

class CatalogoSonidos {
  static const Map<String, SonidoCatalogado> _porIdentificador = {
    // ═══ CAPA 3 · Efectos de interacción ═══
    'efecto_acierto': SonidoCatalogado(
      identificador: 'efecto_acierto',
      capa: CapaAudio.efectos,
      rutaAsset: 'assets/sonido/efectos/acierto.wav',
    ),
    'efecto_error': SonidoCatalogado(
      identificador: 'efecto_error',
      capa: CapaAudio.efectos,
      rutaAsset: 'assets/sonido/efectos/error.wav',
    ),
    'efecto_tap': SonidoCatalogado(
      identificador: 'efecto_tap',
      capa: CapaAudio.efectos,
      rutaAsset: 'assets/sonido/efectos/tap.wav',
    ),
    'efecto_fusion': SonidoCatalogado(
      identificador: 'efecto_fusion',
      capa: CapaAudio.efectos,
      rutaAsset: 'assets/sonido/efectos/fusion.wav',
    ),
    'efecto_ki_subiendo': SonidoCatalogado(
      identificador: 'efecto_ki_subiendo',
      capa: CapaAudio.efectos,
      rutaAsset: 'assets/sonido/efectos/ki_subiendo.wav',
    ),
    'efecto_fragmento_disuelto': SonidoCatalogado(
      identificador: 'efecto_fragmento_disuelto',
      capa: CapaAudio.efectos,
      rutaAsset: 'assets/sonido/efectos/fragmento_disuelto.wav',
    ),
    'efecto_whoosh': SonidoCatalogado(
      identificador: 'efecto_whoosh',
      capa: CapaAudio.efectos,
      rutaAsset: 'assets/sonido/efectos/whoosh.wav',
    ),

    // ═══ CAPA 1 · Ambient por distrito ═══
    'ambient_tejados': SonidoCatalogado(
      identificador: 'ambient_tejados',
      capa: CapaAudio.ambient,
      rutaAsset: 'assets/sonido/ambient/tejados.wav',
      enBucle: true,
    ),
    'ambient_canales': SonidoCatalogado(
      identificador: 'ambient_canales',
      capa: CapaAudio.ambient,
      rutaAsset: 'assets/sonido/ambient/canales.wav',
      enBucle: true,
    ),
    'ambient_mercado': SonidoCatalogado(
      identificador: 'ambient_mercado',
      capa: CapaAudio.ambient,
      rutaAsset: 'assets/sonido/ambient/mercado.wav',
      enBucle: true,
    ),
    'ambient_industria': SonidoCatalogado(
      identificador: 'ambient_industria',
      capa: CapaAudio.ambient,
      rutaAsset: 'assets/sonido/ambient/industria.wav',
      enBucle: true,
    ),
    'ambient_puerto': SonidoCatalogado(
      identificador: 'ambient_puerto',
      capa: CapaAudio.ambient,
      rutaAsset: 'assets/sonido/ambient/puerto.wav',
      enBucle: true,
    ),
    'ambient_afueras': SonidoCatalogado(
      identificador: 'ambient_afueras',
      capa: CapaAudio.ambient,
      rutaAsset: 'assets/sonido/ambient/afueras.wav',
      enBucle: true,
    ),

    // ═══ CAPA 2 · Música por distrito y combate ═══
    'musica_tejados': SonidoCatalogado(
      identificador: 'musica_tejados',
      capa: CapaAudio.musica,
      rutaAsset: 'assets/sonido/musica/tejados.wav',
      enBucle: true,
    ),
    'musica_canales': SonidoCatalogado(
      identificador: 'musica_canales',
      capa: CapaAudio.musica,
      rutaAsset: 'assets/sonido/musica/canales.wav',
      enBucle: true,
    ),
    'musica_mercado': SonidoCatalogado(
      identificador: 'musica_mercado',
      capa: CapaAudio.musica,
      rutaAsset: 'assets/sonido/musica/mercado.wav',
      enBucle: true,
    ),
    'musica_industria': SonidoCatalogado(
      identificador: 'musica_industria',
      capa: CapaAudio.musica,
      rutaAsset: 'assets/sonido/musica/industria.wav',
      enBucle: true,
    ),
    'musica_puerto': SonidoCatalogado(
      identificador: 'musica_puerto',
      capa: CapaAudio.musica,
      rutaAsset: 'assets/sonido/musica/puerto.wav',
      enBucle: true,
    ),
    'musica_afueras': SonidoCatalogado(
      identificador: 'musica_afueras',
      capa: CapaAudio.musica,
      rutaAsset: 'assets/sonido/musica/afueras.wav',
      enBucle: true,
    ),
    'musica_combate_cotidiano': SonidoCatalogado(
      identificador: 'musica_combate_cotidiano',
      capa: CapaAudio.musica,
      rutaAsset: 'assets/sonido/musica/combate_cotidiano.wav',
      enBucle: true,
    ),
    'musica_combate_kurz': SonidoCatalogado(
      identificador: 'musica_combate_kurz',
      capa: CapaAudio.musica,
      rutaAsset: 'assets/sonido/musica/combate_kurz.wav',
      enBucle: true,
    ),
    'musica_combate_zafran': SonidoCatalogado(
      identificador: 'musica_combate_zafran',
      capa: CapaAudio.musica,
      rutaAsset: 'assets/sonido/musica/combate_zafran.wav',
      enBucle: true,
    ),
    'musica_combate_vorax': SonidoCatalogado(
      identificador: 'musica_combate_vorax',
      capa: CapaAudio.musica,
      rutaAsset: 'assets/sonido/musica/combate_vorax.wav',
      enBucle: true,
    ),
    'musica_ceremonia': SonidoCatalogado(
      identificador: 'musica_ceremonia',
      capa: CapaAudio.musica,
      rutaAsset: 'assets/sonido/musica/ceremonia.wav',
      enBucle: false,
    ),
    'musica_amanecer_final': SonidoCatalogado(
      identificador: 'musica_amanecer_final',
      capa: CapaAudio.musica,
      rutaAsset: 'assets/sonido/musica/amanecer_final.wav',
      enBucle: false,
    ),

    // ═══ CAPA 2 / Narrativos · Motivos recurrentes ═══
    'motivo_sora': SonidoCatalogado(
      identificador: 'motivo_sora',
      capa: CapaAudio.narrativos,
      rutaAsset: 'assets/sonido/narrativos/motivo_sora.wav',
    ),
    'motivo_kai': SonidoCatalogado(
      identificador: 'motivo_kai',
      capa: CapaAudio.narrativos,
      rutaAsset: 'assets/sonido/narrativos/motivo_kai.wav',
    ),
    'motivo_montana': SonidoCatalogado(
      identificador: 'motivo_montana',
      capa: CapaAudio.narrativos,
      rutaAsset: 'assets/sonido/narrativos/motivo_montana.wav',
    ),

    // ═══ CAPA 4 · Efectos narrativos únicos ═══
    'narrativo_silbido_zafran': SonidoCatalogado(
      identificador: 'narrativo_silbido_zafran',
      capa: CapaAudio.narrativos,
      rutaAsset: 'assets/sonido/narrativos/silbido_zafran.wav',
    ),
    'narrativo_voz_eco': SonidoCatalogado(
      identificador: 'narrativo_voz_eco',
      capa: CapaAudio.narrativos,
      rutaAsset: 'assets/sonido/narrativos/voz_eco.wav',
    ),
    'narrativo_mundo_baja': SonidoCatalogado(
      identificador: 'narrativo_mundo_baja',
      capa: CapaAudio.narrativos,
      rutaAsset: 'assets/sonido/narrativos/mundo_baja.wav',
    ),
  };

  static SonidoCatalogado? obtener(String identificador) =>
      _porIdentificador[identificador];

  /// Ambient asociado al id de distrito. Devuelve null si no hay
  /// mapeo — el motor lo interpreta como "no cambiar ambient".
  static String? ambientDeDistrito(String idDistrito) {
    const mapa = {
      'tejados': 'ambient_tejados',
      'canales': 'ambient_canales',
      'mercado': 'ambient_mercado',
      'industria': 'ambient_industria',
      'puerto': 'ambient_puerto',
      'afueras': 'ambient_afueras',
    };
    return mapa[idDistrito];
  }

  /// Loop musical del distrito.
  static String? musicaDeDistrito(String idDistrito) {
    const mapa = {
      'tejados': 'musica_tejados',
      'canales': 'musica_canales',
      'mercado': 'musica_mercado',
      'industria': 'musica_industria',
      'puerto': 'musica_puerto',
      'afueras': 'musica_afueras',
    };
    return mapa[idDistrito];
  }

  /// Loop musical del combate, según identificador de desafío nombrado
  /// o null para combate cotidiano.
  static String musicaDeCombate(String? idDesafio) {
    switch (idDesafio) {
      case 'kurz_1':
      case 'kurz_2':
      case 'kurz_3':
        return 'musica_combate_kurz';
      case 'zafran':
        return 'musica_combate_zafran';
      case 'vorax':
        return 'musica_combate_vorax';
      default:
        return 'musica_combate_cotidiano';
    }
  }
}
