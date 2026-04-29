// Niveles de confianza explícitos del oficio del Cuaderno (biblia §5.2,
// §5.3). El enum agrupa los cuatro valores posibles del juego pero cada
// entidad usa un subset distinto:
//
// - Una `Observacion` puede tener `consenso`, `hipotesisActiva` o
//   `noSegura`. Nunca `abandonado` — abandonar pertenece a un Misterio,
//   no a una observación puntual.
// - Un `Misterio` puede tener `consenso`, `hipotesisActiva` o
//   `abandonado`. Nunca `noSegura` — el sistema no se declara inseguro
//   sobre el estado de un Misterio; lo declara como hipótesis activa.
//
// Los validadores de cada entidad rechazan los valores que no aplican.

/// Cuatro niveles de confianza del oficio. Inglés del enum es
/// deliberado: el dominio del juego se conjuga en castellano.
enum NivelConfianza {
  /// Identificación o estado confirmado contra una clave o el Tutor.
  consenso,

  /// Identificación o estado propuesto y abierto a más evidencia. Es
  /// el estado natural cuando el niño registra algo nuevo.
  hipotesisActiva,

  /// Estado de un Misterio que el niño cierra honestamente sin haber
  /// llegado a una conclusión coherente con el consenso. No se aplica
  /// a observaciones individuales.
  abandonado,

  /// Identificación dudosa registrada con humildad. La biblia §5.2
  /// honra explícitamente el "no sé" como respuesta válida del oficio.
  /// No se aplica a Misterios.
  noSegura;

  /// Recupera el valor desde su nombre serializado (idéntico al `name`
  /// del enum: `consenso`, `hipotesisActiva`, `abandonado`,
  /// `noSegura`). Lanza [ArgumentError] si el texto no encaja con
  /// ninguno — los datos del cuaderno no toleran corrupciones
  /// silenciosas.
  static NivelConfianza fromString(String texto) {
    for (final valor in NivelConfianza.values) {
      if (valor.name == texto) {
        return valor;
      }
    }
    throw ArgumentError.value(
      texto,
      'texto',
      'no corresponde a ningún NivelConfianza conocido',
    );
  }

  /// Etiqueta localizada para mostrar en pantalla. La voz del Cuaderno
  /// es seca (doc 04 §2): no hay signos de exclamación ni emojis ni
  /// adornos. El idioma es uno de los tres soportados en el MVP
  /// (`es`, `eu`, `ca`); cualquier otro cae a castellano.
  ///
  /// Las etiquetas siguen sentence case (sin Mayúsculas Iniciales) y
  /// usan la formulación canónica del doc 13 §3.2: "consenso",
  /// "hipótesis activa", "no estoy segura". `abandonado` aparece como
  /// "abandonado" en castellano y se localiza igual.
  ///
  /// El UI **nunca** muestra el enum directamente. Llamar siempre a
  /// este helper.
  String toLocaleLabel(String idioma) {
    switch (idioma) {
      case 'eu':
        return _etiquetasEuskera[this]!;
      case 'ca':
        return _etiquetasCatalan[this]!;
      default:
        return _etiquetasCastellano[this]!;
    }
  }
}

const Map<NivelConfianza, String> _etiquetasCastellano = {
  NivelConfianza.consenso: 'consenso',
  NivelConfianza.hipotesisActiva: 'hipótesis activa',
  NivelConfianza.abandonado: 'abandonado',
  NivelConfianza.noSegura: 'no estoy segura',
};

// TODO_EU: revisar con hablante nativo + criterio terminológico
// naturalista (Elhuyar, Aranzadi). Estos provisionales son traducción
// directa, sin validación.
const Map<NivelConfianza, String> _etiquetasEuskera = {
  NivelConfianza.consenso: 'adostasuna',
  NivelConfianza.hipotesisActiva: 'hipotesi aktiboa',
  NivelConfianza.abandonado: 'utzia',
  NivelConfianza.noSegura: 'ez nago ziur',
};

// TODO_CA: revisar con hablante nativo + materiales del IEC. Estos
// provisionales son traducción directa, sin validación.
const Map<NivelConfianza, String> _etiquetasCatalan = {
  NivelConfianza.consenso: 'consens',
  NivelConfianza.hipotesisActiva: 'hipòtesi activa',
  NivelConfianza.abandonado: 'abandonat',
  NivelConfianza.noSegura: 'no n\'estic segura',
};
