// Servicio que genera la respuesta del maestro cuando el niño pide
// una pista sobre una palabra del documento. Mecánica nuclear §3.5.
//
// Voz del maestro (doc 09 §1): tres frases, sobria, sin aplauso,
// sin emoticonos. Información, pista, decisión propuesta. Cuando no
// puede ayudar, lo dice claro y devuelve la decisión al niño.

import 'pieza_corpus.dart';
import 'pistas_pedidas.dart';
import 'vocabulario_jugador.dart';

/// Lo que el servicio devuelve al niño cuando pide una pista.
class RespuestaPista {
  const RespuestaPista({
    required this.nivel,
    required this.texto,
    this.piezaParalela,
  });

  final NivelPista nivel;

  /// Texto en voz del maestro, sobrio.
  final String texto;

  /// Si la pista es de comparación y hubo coincidencia, la pieza
  /// paralela referenciada. Null en los demás casos.
  final PiezaCorpus? piezaParalela;
}

class ServicioPistas {
  const ServicioPistas();

  RespuestaPista responder({
    required NivelPista nivel,
    required PiezaCorpus piezaActual,
    required String palabraOriginal,
    required VocabularioJugador vocabulario,
    required List<PiezaCorpus> piezasResueltas,
  }) {
    final palabraNormalizada = normalizarPalabra(palabraOriginal);
    switch (nivel) {
      case NivelPista.tono:
        return _respuestaTono(
          piezaActual: piezaActual,
          palabraNormalizada: palabraNormalizada,
          vocabulario: vocabulario,
        );
      case NivelPista.comparacion:
        return _respuestaComparacion(
          piezaActual: piezaActual,
          palabraNormalizada: palabraNormalizada,
          piezasResueltas: piezasResueltas,
        );
      case NivelPista.traduccion:
        return _respuestaTraduccion(
          piezaActual: piezaActual,
          palabraNormalizada: palabraNormalizada,
        );
    }
  }

  RespuestaPista _respuestaTono({
    required PiezaCorpus piezaActual,
    required String palabraNormalizada,
    required VocabularioJugador vocabulario,
  }) {
    if (palabraNormalizada.isEmpty) {
      return const RespuestaPista(
        nivel: NivelPista.tono,
        texto: 'Mira otra vez la palabra. Vuélvemela a señalar.',
      );
    }

    final lenguasDondeYaLaTocaste = <String>[];
    for (final lengua in vocabulario.lenguasConPalabrasMarcadas()) {
      final marca = vocabulario.marcaDe(lengua, palabraNormalizada);
      if (marca != null) {
        lenguasDondeYaLaTocaste.add(lengua.nombreCanonico);
      }
    }

    if (lenguasDondeYaLaTocaste.isEmpty) {
      return const RespuestaPista(
        nivel: NivelPista.tono,
        texto: 'Esa no la has tocado antes. La hipótesis es tuya, '
            'aprendiz. Mírala en su contexto, no en seco.',
      );
    }

    final lengua = lenguasDondeYaLaTocaste.first;
    return RespuestaPista(
      nivel: NivelPista.tono,
      texto: 'Te suena. Mira tu cuaderno, en $lengua. Allí la dejaste '
          'apuntada. Lo que escribiste entonces, ¿pega aquí?',
    );
  }

  RespuestaPista _respuestaComparacion({
    required PiezaCorpus piezaActual,
    required String palabraNormalizada,
    required List<PiezaCorpus> piezasResueltas,
  }) {
    if (palabraNormalizada.isEmpty) {
      return const RespuestaPista(
        nivel: NivelPista.comparacion,
        texto: 'Mira otra vez la palabra. Vuélvemela a señalar.',
      );
    }

    final remitenteActual = piezaActual.remitenteRecurrente;
    for (final candidata in piezasResueltas) {
      if (candidata.id == piezaActual.id) continue;
      final mismoRemitente = remitenteActual != null &&
          candidata.remitenteRecurrente == remitenteActual;
      if (!mismoRemitente) continue;
      if (_textoContiene(candidata.textoDocumento, palabraNormalizada)) {
        final quien = remitenteActual.nombreCanonico;
        return RespuestaPista(
          nivel: NivelPista.comparacion,
          texto: 'Tienes otra carta de $quien en el archivo donde sale '
              'la misma palabra. Cógela y mírala al lado.',
          piezaParalela: candidata,
        );
      }
    }

    // Sin remitente recurrente o sin coincidencia: probar cualquier pieza
    // resuelta como red de seguridad débil.
    for (final candidata in piezasResueltas) {
      if (candidata.id == piezaActual.id) continue;
      if (_textoContiene(candidata.textoDocumento, palabraNormalizada)) {
        return RespuestaPista(
          nivel: NivelPista.comparacion,
          texto: 'No tengo carta del mismo remitente, pero esa palabra '
              'aparece en otra pieza tuya. Compara contextos.',
          piezaParalela: candidata,
        );
      }
    }

    return const RespuestaPista(
      nivel: NivelPista.comparacion,
      texto: 'No tengo otro documento tuyo con esa palabra. Vuelve a '
          'leer el párrafo entero — el contexto manda.',
    );
  }

  RespuestaPista _respuestaTraduccion({
    required PiezaCorpus piezaActual,
    required String palabraNormalizada,
  }) {
    if (palabraNormalizada.isEmpty) {
      return const RespuestaPista(
        nivel: NivelPista.traduccion,
        texto: 'Mira otra vez la palabra. Vuélvemela a señalar.',
      );
    }
    final traduccion = piezaActual.glosario[palabraNormalizada];
    if (traduccion == null) {
      return const RespuestaPista(
        nivel: NivelPista.traduccion,
        texto: 'Esa no la tengo clavada. Descífrala tú con lo que hay '
            'alrededor — para algo está el contexto.',
      );
    }
    return RespuestaPista(
      nivel: NivelPista.traduccion,
      texto: '"$palabraNormalizada" — $traduccion. Anótalo en tu cuaderno '
          'antes de que se te olvide.',
    );
  }

  bool _textoContiene(String texto, String palabraNormalizada) {
    final lowercase = texto.toLowerCase();
    final regex = RegExp(
      r'(?:^|[^\p{L}])' +
          RegExp.escape(palabraNormalizada) +
          r'(?:[^\p{L}]|$)',
      unicode: true,
    );
    return regex.hasMatch(lowercase);
  }
}
