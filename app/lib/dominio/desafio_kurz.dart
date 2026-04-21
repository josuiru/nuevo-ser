/// Configuración de un combate contra Kurz. Cada combate (1.5, 1.10,
/// 1.12) tiene su propio set de preguntas, valor inicial y tiempo
/// límite. La primera vez (1.5) está calibrada a derrota — el guion
/// del doc 07 lo dice explícitamente.
class DesafioKurz {
  /// Identificador estable para flags y persistencia: "kurz_1", "kurz_2",
  /// "kurz_3".
  final String identificador;

  /// Valor inicial del Fragmento Kurz que el jugador ve. Decrece con
  /// cada acierto.
  final List<String> secuenciaValores;

  /// Preguntas en orden. El niño responde una por una.
  final List<PreguntaKurz> preguntas;

  /// Vidas del jugador. Cuando llega a 0, derrota.
  final int kiInicial;

  /// Tiempo en segundos que el jugador tiene para responder cada
  /// pregunta. Cortísimo en kurz_1 (calibrado a derrota), más generoso
  /// después.
  final int segundosPorPregunta;

  /// Frase de Kurz cuando el jugador acierta. Rara: la primera vez ni
  /// debería oírse.
  final String fraseAcierto;

  /// Frase mostrada al perder (ki = 0). Para kurz_1: "Ya está. No pasa
  /// nada."
  final String fraseDerrota;

  /// Frase mostrada al ganar.
  final String fraseVictoria;

  const DesafioKurz({
    required this.identificador,
    required this.secuenciaValores,
    required this.preguntas,
    required this.kiInicial,
    required this.segundosPorPregunta,
    required this.fraseAcierto,
    required this.fraseDerrota,
    required this.fraseVictoria,
  });

  /// Total de aciertos necesarios para victoria — coincide con el
  /// número de preguntas. Útil para tests y para mostrar progreso.
  int get aciertosNecesarios => preguntas.length;

  /// Combate 1: el primero. Calibrado a derrota. Doc 07 §1.5.
  static const DesafioKurz primero = DesafioKurz(
    identificador: 'kurz_1',
    secuenciaValores: ['3/4', '2/4', '1/4', '—'],
    kiInicial: 2,
    segundosPorPregunta: 4,
    preguntas: [
      PreguntaKurz(
        enunciado: '¿Cuántos cuartos hay en un entero?',
        opciones: ['2', '3', '4', '6'],
        indiceCorrecto: 2,
        fraseFalloKurz: 'Muy lento.',
      ),
      PreguntaKurz(
        enunciado: 'Si tengo 3/4 y quito 1/4, ¿cuánto queda?',
        opciones: ['1/4', '2/4', '3/4', '4/4'],
        indiceCorrecto: 1,
        fraseFalloKurz: 'Otra vez mal.',
      ),
      PreguntaKurz(
        enunciado: '¿Qué es más: 1/2 o 1/4?',
        opciones: ['1/2', '1/4', 'Iguales'],
        indiceCorrecto: 0,
        fraseFalloKurz: 'Tenías que haberlo visto venir.',
      ),
    ],
    fraseAcierto: 'Mm.',
    fraseDerrota: 'Ya está. No pasa nada.',
    fraseVictoria: 'Vaya. Otra vez la semana que viene.',
  );

  /// Combate 2: tras 2-3 entrenamientos. Doc 07 §1.10. Valor 5/6, ki más
  /// generoso, tiempo algo mayor. Probabilidad real de victoria si el
  /// niño está en forma — pero la derrota sigue siendo lo esperado.
  static const DesafioKurz segundo = DesafioKurz(
    identificador: 'kurz_2',
    secuenciaValores: ['5/6', '4/6', '3/6', '2/6', '1/6', '—'],
    kiInicial: 3,
    segundosPorPregunta: 6,
    preguntas: [
      PreguntaKurz(
        enunciado: '¿Cuánto es 5/6 - 1/6?',
        opciones: ['3/6', '4/6', '5/6', '6/6'],
        indiceCorrecto: 1,
        fraseFalloKurz: 'Lento.',
      ),
      PreguntaKurz(
        enunciado: '¿Cuánto es 4/6 - 1/6?',
        opciones: ['2/6', '3/6', '4/6', '5/6'],
        indiceCorrecto: 1,
        fraseFalloKurz: 'No lo veas — calcúlalo.',
      ),
      PreguntaKurz(
        enunciado: 'Simplifica 3/6.',
        opciones: ['1/2', '1/3', '2/3', '3/4'],
        indiceCorrecto: 0,
        fraseFalloKurz: 'Vamos.',
      ),
      PreguntaKurz(
        enunciado: '¿Cuánto es 2/6 + 1/6?',
        opciones: ['1/6', '2/6', '3/6', '4/6'],
        indiceCorrecto: 2,
        fraseFalloKurz: 'Mm.',
      ),
      PreguntaKurz(
        enunciado: 'Simplifica 2/6.',
        opciones: ['1/2', '1/3', '2/3', '3/6'],
        indiceCorrecto: 1,
        fraseFalloKurz: 'Otra.',
      ),
    ],
    fraseAcierto: 'Mm.',
    fraseDerrota: 'Casi. Otra vez la semana que viene.',
    fraseVictoria: 'Vaya. Tú ya eres otra cosa.',
  );

  /// Combate 3: el definitivo. Doc 07 §1.12. Valor 7/8, ki generoso,
  /// tiempo cómodo. Calibrado a VICTORIA. Si el niño llega aquí, está
  /// listo para Aprendiz II.
  static const DesafioKurz tercero = DesafioKurz(
    identificador: 'kurz_3',
    secuenciaValores: ['7/8', '5/8', '3/8', '1/8', '—'],
    kiInicial: 4,
    segundosPorPregunta: 8,
    preguntas: [
      PreguntaKurz(
        enunciado: '¿Cuánto es 7/8 - 2/8?',
        opciones: ['3/8', '5/8', '6/8', '9/8'],
        indiceCorrecto: 1,
        fraseFalloKurz: 'Te noto distinto. No basta.',
      ),
      PreguntaKurz(
        enunciado: 'Simplifica 4/8.',
        opciones: ['1/2', '1/4', '2/4', '3/4'],
        indiceCorrecto: 0,
        fraseFalloKurz: 'Vamos.',
      ),
      PreguntaKurz(
        enunciado: '¿Cuánto es 5/8 - 2/8?',
        opciones: ['1/8', '2/8', '3/8', '4/8'],
        indiceCorrecto: 2,
        fraseFalloKurz: 'Mm.',
      ),
      PreguntaKurz(
        enunciado: 'Simplifica 6/8.',
        opciones: ['2/4', '3/4', '4/8', '5/8'],
        indiceCorrecto: 1,
        fraseFalloKurz: 'Otra.',
      ),
    ],
    fraseAcierto: 'Mm.',
    fraseDerrota: 'Otra vez. La semana que viene.',
    fraseVictoria: 'Nos veremos cuando seas Iniciado.',
  );
}

class PreguntaKurz {
  final String enunciado;
  final List<String> opciones;
  final int indiceCorrecto;
  final String fraseFalloKurz;

  const PreguntaKurz({
    required this.enunciado,
    required this.opciones,
    required this.indiceCorrecto,
    required this.fraseFalloKurz,
  });
}

/// Resultado de un combate contra Kurz. El orquestador lo usa para
/// activar los flags narrativos correspondientes.
class ResultadoCombateKurz {
  final bool victoria;
  final int kiFinal;
  final int aciertos;

  const ResultadoCombateKurz({
    required this.victoria,
    required this.kiFinal,
    required this.aciertos,
  });
}
