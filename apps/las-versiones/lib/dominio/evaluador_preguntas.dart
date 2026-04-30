/// Evaluador algorítmico de preguntas formuladas por la Cronista en
/// la Fase 1 de una Brecha. **No usa LLM**: el filtro es 100% local
/// y de superficie sintáctica, alineado con el hard limit del doc 14
/// §4 "Tutor IA con barreras: barrera anti-alucinación histórica".
///
/// El evaluador no juzga si la pregunta es **histórica buena** —
/// para eso hace falta el comité asesor. Sólo juzga si es una
/// pregunta razonablemente formulada: longitud, signo interrogativo,
/// estructura. Y la **categoriza** (factual / causal / perspectiva /
/// metodológica) para que la pantalla pueda dar feedback de
/// diversidad sin afirmar contenido histórico concreto.
///
/// La meta pedagógica de la Fase 1 (PR.01, PR.04 del doc 02) es que
/// la Cronista practique formular variedad de preguntas, no que el
/// sistema le diga "tu pregunta sobre el dolmen es correcta". Esa
/// validación de fondo llega más tarde, cuando se cruzan con las
/// fuentes en la Fase 3.
library;

/// Categorías ortogonales de pregunta — el oficio del historiador
/// distingue al menos estas cuatro, y formular variedad es una
/// habilidad propia (PR.04 "tipos de preguntas"). Las heurísticas
/// son por palabras-disparador en la propia pregunta; bastan para
/// que la Cronista reciba feedback útil sin necesidad de NLP real.
enum TipoPregunta {
  /// "qué", "cuándo", "dónde", "quién", "cuántos" — preguntas que
  /// piden un dato concreto verificable.
  factual,

  /// "por qué", "cómo se explica" — piden causas, conexiones.
  causal,

  /// "para qué público", "qué intereses", "desde qué perspectiva" —
  /// piden situar al productor de la fuente o del hecho.
  perspectiva,

  /// "cómo lo sabemos", "qué evidencia tenemos" — piden reflexionar
  /// sobre el método. Suelen ser las más difíciles de formular.
  metodologica,

  /// No casa con ninguno de los disparadores conocidos. La pantalla
  /// la acepta igualmente — el catálogo de disparadores es por
  /// fuerza incompleto y no queremos rechazar preguntas legítimas
  /// con vocabulario distinto del esperado.
  indeterminada,
}

/// Resultado de evaluar una pregunta. Inmutable.
class EvaluacionPregunta {
  /// El texto tal y como se evaluó (ya recortado, sin espacios
  /// extremos). La pantalla lo usa para mostrar la pregunta una vez
  /// añadida.
  final String textoNormalizado;

  /// `true` si el texto pasa las heurísticas mínimas para
  /// considerarse una pregunta razonable. `false` si era
  /// demasiado corto, sin signo interrogativo y sin partícula
  /// interrogativa, o claramente no es una pregunta.
  final bool esValida;

  /// Categoría detectada (o [TipoPregunta.indeterminada] si los
  /// disparadores conocidos no la clasifican).
  final TipoPregunta tipo;

  /// Mensaje pedagógico para mostrar a la Cronista. Cuando
  /// [esValida] es `true` celebra la pregunta brevemente; cuando
  /// es `false` explica qué le falta sin afear el intento.
  final String mensajePedagogico;

  const EvaluacionPregunta({
    required this.textoNormalizado,
    required this.esValida,
    required this.tipo,
    required this.mensajePedagogico,
  });
}

class EvaluadorPreguntas {
  /// Mínimo de caracteres tras normalizar para considerar una
  /// pregunta no-trivial. Ajustado para que "¿qué?" no pase pero
  /// "¿qué pasó aquí?" sí.
  static const int _longitudMinima = 12;

  /// Máximo razonable. Por encima la Cronista probablemente está
  /// escribiendo un párrafo, no una pregunta. La pantalla puede
  /// elegir cómo lo presenta.
  static const int _longitudMaxima = 200;

  /// Disparadores por categoría. Castellano normalizado (minúsculas,
  /// sin tildes). El orden importa: las categorías más específicas
  /// se evalúan primero, así "por qué" no se clasifica como factual
  /// aunque empiece por "p".
  static const Map<TipoPregunta, List<String>> _disparadores = {
    TipoPregunta.metodologica: [
      'como lo sabemos',
      'como sabemos',
      'que evidencia',
      'que prueba',
      'que pruebas',
      'como se sabe',
      'que fuente',
      'que fuentes',
    ],
    TipoPregunta.perspectiva: [
      'para que publico',
      'que intereses',
      'desde que perspectiva',
      'desde donde',
      'a quien beneficia',
      'que se omite',
      'que falta',
      'que silencia',
    ],
    TipoPregunta.causal: [
      'por que',
      'por como',
      'a que se debe',
      'que provoca',
      'que provoco',
      'que causa',
      'que causo',
    ],
    TipoPregunta.factual: [
      'que ',
      'cuando',
      'donde',
      'quien',
      'quienes',
      'cuanto',
      'cuanta',
      'cuantos',
      'cuantas',
      'cual',
      'cuales',
      'como ',
    ],
  };

  const EvaluadorPreguntas();

  /// Evalúa un texto crudo. Recorta espacios extremos antes de
  /// analizar. Nunca lanza — devuelve siempre una [EvaluacionPregunta]
  /// que la pantalla puede mostrar.
  EvaluacionPregunta evaluar(String textoCrudo) {
    final textoNormalizado = textoCrudo.trim();
    if (textoNormalizado.length < _longitudMinima) {
      return EvaluacionPregunta(
        textoNormalizado: textoNormalizado,
        esValida: false,
        tipo: TipoPregunta.indeterminada,
        mensajePedagogico: 'Demasiado corta para ser una pregunta del oficio. '
            'Prueba a añadir más detalle: ¿qué quieres saber?',
      );
    }
    if (textoNormalizado.length > _longitudMaxima) {
      return EvaluacionPregunta(
        textoNormalizado: textoNormalizado,
        esValida: false,
        tipo: TipoPregunta.indeterminada,
        mensajePedagogico: 'Es muy larga — probablemente hay varias preguntas '
            'mezcladas. Sepáralas y formula cada una por separado.',
      );
    }
    final terminaEnInterrogacion = textoNormalizado.endsWith('?');
    final tipo = _detectarTipo(textoNormalizado);
    final tieneParticulaInterrogativa = tipo != TipoPregunta.indeterminada;
    if (!terminaEnInterrogacion && !tieneParticulaInterrogativa) {
      return EvaluacionPregunta(
        textoNormalizado: textoNormalizado,
        esValida: false,
        tipo: TipoPregunta.indeterminada,
        mensajePedagogico: 'Esto parece una afirmación, no una pregunta. '
            'Las preguntas suelen empezar por qué, cómo, por qué, dónde, '
            'cuándo, quién… y terminan en signo de interrogación.',
      );
    }
    return EvaluacionPregunta(
      textoNormalizado: textoNormalizado,
      esValida: true,
      tipo: tipo,
      mensajePedagogico: _glosaPorTipo(tipo),
    );
  }

  TipoPregunta _detectarTipo(String texto) {
    final textoSinTildes = _quitarTildes(texto.toLowerCase());
    for (final entrada in _disparadores.entries) {
      for (final disparador in entrada.value) {
        if (textoSinTildes.contains(disparador)) {
          return entrada.key;
        }
      }
    }
    return TipoPregunta.indeterminada;
  }

  String _glosaPorTipo(TipoPregunta tipo) {
    switch (tipo) {
      case TipoPregunta.factual:
        return 'Pregunta factual: pide un dato concreto. Buen punto de '
            'partida — luego conviene complementarla con preguntas que '
            'pidan causas o perspectiva.';
      case TipoPregunta.causal:
        return 'Pregunta causal: pide explicar por qué. Es de las que '
            'mueven la investigación adelante.';
      case TipoPregunta.perspectiva:
        return 'Pregunta de perspectiva: sitúa al productor o al silencio. '
            'Estas son las que distinguen al oficio del cronista del de '
            'quien sólo cita.';
      case TipoPregunta.metodologica:
        return 'Pregunta metodológica: cuestionas cómo se sabe lo que se '
            'sabe. Difícil y muy valiosa.';
      case TipoPregunta.indeterminada:
        return 'Pregunta aceptada — el sistema no la clasifica en sus '
            'categorías habituales, pero termina con signo de '
            'interrogación. Sigue.';
    }
  }

  /// Normaliza tildes castellanas a ASCII para que la detección por
  /// disparadores no dependa de si la Cronista escribe con o sin
  /// tildes. La eñe se mantiene porque ningún disparador la usa.
  String _quitarTildes(String texto) {
    const reemplazos = {
      'á': 'a',
      'é': 'e',
      'í': 'i',
      'ó': 'o',
      'ú': 'u',
      'ü': 'u',
    };
    var resultado = texto;
    reemplazos.forEach((acentuada, sinAcento) {
      resultado = resultado.replaceAll(acentuada, sinAcento);
    });
    return resultado;
  }
}

/// Política para decidir si la Cronista puede pasar a la Fase 2 de
/// una Brecha. Se aplica sobre la lista de evaluaciones acumuladas:
/// se exige un mínimo de preguntas válidas y, si está activado el
/// criterio de diversidad, al menos dos categorías distintas.
class PoliticaCierreFormulacion {
  static const int minimoPreguntasValidas = 3;

  const PoliticaCierreFormulacion();

  /// Devuelve `null` si la Cronista puede avanzar; si no, devuelve
  /// el mensaje pedagógico que explica qué le falta.
  String? razonParaNoAvanzar(List<EvaluacionPregunta> evaluaciones) {
    final validas = evaluaciones.where((e) => e.esValida).toList();
    if (validas.length < minimoPreguntasValidas) {
      final faltantes = minimoPreguntasValidas - validas.length;
      return 'Necesitas al menos $minimoPreguntasValidas preguntas válidas '
          'para abrir la Brecha. Te faltan $faltantes.';
    }
    final categorias = validas.map((e) => e.tipo).toSet();
    if (categorias.length < 2) {
      return 'Tus preguntas son todas del mismo tipo. El oficio pide '
          'variedad: prueba con una pregunta causal (¿por qué?) o '
          'metodológica (¿cómo lo sabemos?).';
    }
    return null;
  }
}
