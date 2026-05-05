import 'observacion.dart';

/// Una entrada del atlas del niño: una identificación que ha
/// aparecido en su cuaderno con su conteo y su primera aparición.
///
/// Inmutable. Construido en runtime por [Atlas.calcular]; no se
/// persiste — se recalcula cada vez que se abre la pantalla. El
/// coste es lineal en el número de observaciones del niño y la
/// densidad textual del cuaderno es deliberadamente baja
/// (biblia §2.7), así que esto es seguro hasta varios miles de
/// observaciones por perfil sin pestañear.
class EntradaAtlas {
  const EntradaAtlas({
    required this.creesQueEs,
    required this.conteo,
    required this.primeraVez,
    required this.idObservacionPrimera,
  });

  /// El texto que el niño escribió en `creesQueEs`, en su forma
  /// original (no normalizada). Si el niño escribió "Mariposa
  /// Blanca" la primera vez y "mariposa blanca" la segunda, la
  /// entrada se agrupa por la forma normalizada pero se muestra
  /// con la forma original de la primera observación — la voz del
  /// niño se conserva.
  final String creesQueEs;
  final int conteo;
  final DateTime primeraVez;
  final String idObservacionPrimera;
}

/// Atlas personal del niño — colección de identificaciones que
/// han aparecido en su cuaderno. Dos vistas derivadas:
///
/// - [primerasVeces] — listado cronológico inverso de las
///   observaciones que son "primera vez" de un `creesQueEs`
///   nuevo. Una observación es "primera vez" si ninguna
///   observación anterior comparte su `creesQueEs` normalizado.
///   Las que tienen `creesQueEs` vacío o nulo NO cuentan: declarar
///   *"no sé"* es honesto pero no es una identificación.
///
/// - [loQueHasVisto] — agrupador por identificación normalizada.
///   Ordenado por conteo descendente; en empate, por primera vez
///   más reciente arriba.
///
/// **Pedagogía**: este atlas no premia, no compite, no felicita.
/// Es memoria. La biblia §2.4 ("nunca humillar al niño") tiene un
/// gemelo táctico: nunca celebrar de más al niño. Una observación
/// es una observación.
class Atlas {
  const Atlas._({
    required this.primerasVeces,
    required this.loQueHasVisto,
  });

  final List<EntradaAtlas> primerasVeces;
  final List<EntradaAtlas> loQueHasVisto;

  bool get estaVacio => primerasVeces.isEmpty && loQueHasVisto.isEmpty;

  /// Construye el atlas a partir de la lista completa de
  /// observaciones del niño. La lista NO necesita venir ordenada;
  /// el atlas la ordena internamente por `cuandoOcurrio` ascendente
  /// para detectar "primera vez" de forma estable y luego compone
  /// las dos vistas.
  factory Atlas.calcular(List<Observacion> observaciones) {
    final ordenadas = [...observaciones]
      ..sort((a, b) => a.cuandoOcurrio.compareTo(b.cuandoOcurrio));

    // Por clave normalizada → primera observación + conteo.
    final entradasPorClave = <String, _EntradaEnConstruccion>{};
    final primerasVeces = <EntradaAtlas>[];

    for (final obs in ordenadas) {
      final identificacion = obs.creesQueEs?.trim() ?? '';
      if (identificacion.isEmpty) continue;
      final clave = _normalizar(identificacion);
      if (clave.isEmpty) continue;

      final yaExistia = entradasPorClave.containsKey(clave);
      if (!yaExistia) {
        entradasPorClave[clave] = _EntradaEnConstruccion(
          creesQueEs: identificacion,
          conteo: 1,
          primeraVez: obs.cuandoOcurrio,
          idObservacionPrimera: obs.id,
        );
        primerasVeces.add(EntradaAtlas(
          creesQueEs: identificacion,
          conteo: 1,
          primeraVez: obs.cuandoOcurrio,
          idObservacionPrimera: obs.id,
        ));
      } else {
        entradasPorClave[clave] = entradasPorClave[clave]!.incrementar();
      }
    }

    final loQueHasVisto = entradasPorClave.values
        .map((e) => EntradaAtlas(
              creesQueEs: e.creesQueEs,
              conteo: e.conteo,
              primeraVez: e.primeraVez,
              idObservacionPrimera: e.idObservacionPrimera,
            ))
        .toList()
      ..sort((a, b) {
        final porConteo = b.conteo.compareTo(a.conteo);
        if (porConteo != 0) return porConteo;
        return b.primeraVez.compareTo(a.primeraVez);
      });

    // Las primeras veces se muestran cronológicamente inversas
    // (la más reciente arriba) — el niño quiere ver lo último que
    // ha descubierto. La detección era cronológica ascendente
    // por necesidad algorítmica.
    final primerasVecesInversas = primerasVeces.reversed.toList();

    return Atlas._(
      primerasVeces: primerasVecesInversas,
      loQueHasVisto: loQueHasVisto,
    );
  }

  /// Devuelve `true` si esta observación es la primera del
  /// cuaderno con su `creesQueEs` normalizado. Útil para
  /// `PantallaDetalleObservacion` que muestra la microcopia
  /// "primera vez que anotas algo así en el cuaderno" cuando es
  /// el caso. La normalización es la misma que la del atlas, así
  /// que el badge y el listado están siempre coherentes.
  ///
  /// Si [observacion] no está en [observaciones], devuelve `false`.
  static bool esPrimeraVezDeIdentificacion(
    Observacion observacion,
    List<Observacion> observaciones,
  ) {
    final identificacion = observacion.creesQueEs?.trim() ?? '';
    if (identificacion.isEmpty) return false;
    final clave = _normalizar(identificacion);
    if (clave.isEmpty) return false;

    DateTime? primeraFecha;
    String? idPrimera;
    for (final obs in observaciones) {
      final otra = obs.creesQueEs?.trim() ?? '';
      if (otra.isEmpty) continue;
      if (_normalizar(otra) != clave) continue;
      if (primeraFecha == null ||
          obs.cuandoOcurrio.isBefore(primeraFecha)) {
        primeraFecha = obs.cuandoOcurrio;
        idPrimera = obs.id;
      }
    }
    return idPrimera == observacion.id;
  }

  /// Normalización para agrupar identificaciones. Lowercase +
  /// recorte + plegado de tildes y ñ → n / ç → c. El mismo plegado
  /// que [PantallaListaObservaciones] usa para la búsqueda.
  /// "Mariposa blanca" y "mariposa  Blanca  " se agrupan.
  static String _normalizar(String texto) {
    final lower = texto.toLowerCase().trim();
    final colapso = lower.replaceAll(RegExp(r'\s+'), ' ');
    final buf = StringBuffer();
    for (final code in colapso.runes) {
      buf.writeCharCode(_plegar(code));
    }
    return buf.toString();
  }

  static int _plegar(int code) {
    const mapa = <int, int>{
      0xE1: 0x61, 0xE9: 0x65, 0xED: 0x69, 0xF3: 0x6F, 0xFA: 0x75, // áéíóú
      0xE0: 0x61, 0xE8: 0x65, 0xEC: 0x69, 0xF2: 0x6F, 0xF9: 0x75, // àèìòù
      0xE4: 0x61, 0xEB: 0x65, 0xEF: 0x69, 0xF6: 0x6F, 0xFC: 0x75, // äëïöü
      0xF1: 0x6E, // ñ
      0xE7: 0x63, // ç
    };
    return mapa[code] ?? code;
  }
}

/// Helper interno para acumular conteos sin mutar instancias
/// inmutables.
class _EntradaEnConstruccion {
  const _EntradaEnConstruccion({
    required this.creesQueEs,
    required this.conteo,
    required this.primeraVez,
    required this.idObservacionPrimera,
  });

  final String creesQueEs;
  final int conteo;
  final DateTime primeraVez;
  final String idObservacionPrimera;

  _EntradaEnConstruccion incrementar() => _EntradaEnConstruccion(
        creesQueEs: creesQueEs,
        conteo: conteo + 1,
        primeraVez: primeraVez,
        idObservacionPrimera: idObservacionPrimera,
      );
}
