import '../dominio/sesion.dart';

/// Guión pre-escrito de la primera noche de Leo/Lía.
///
/// Respeta biblia personajes §3.6: frases cortas de Sora, "bien" como
/// máxima felicitación, sin efusividad. Cada Fragmento tiene un
/// contexto diegético propio: el niño no repite "un circulito", caza
/// cada vez algo distinto que estaba devorando una pieza del mundo.
SesionNoche primeraNoche() {
  return const SesionNoche(
    tituloDiegetico: 'Primera noche',
    lineasIntro: [
      LineaSora('Eh. Eres tú, ¿no?'),
      LineaSora('Me han dicho que tienes buen ojo.'),
      LineaSora('Vamos a ver si es verdad.'),
      LineaSora('Mira ahí abajo. En el callejón.'),
    ],
    contratos: [
      ContratoFragmento(
        denominador: 2,
        contextoNarrativo: 'se está comiendo el cartel de la esquina',
        invocacion: LineaSora(
          'Ese se come el cartel de neón. Pártelo en dos.',
        ),
      ),
      ContratoFragmento(
        denominador: 3,
        contextoNarrativo: 'se come las agujas del reloj del kiosco',
        invocacion: LineaSora(
          'Otro. Este va a por el reloj del kiosco. En tres.',
        ),
      ),
      ContratoFragmento(
        denominador: 2,
        contextoNarrativo: 'se come el letrero de la panadería',
        invocacion: LineaSora(
          'Fácil. El letrero de la panadería. En dos.',
        ),
      ),
      ContratoFragmento(
        denominador: 4,
        contextoNarrativo: 'se ha tragado media ventana',
        invocacion: LineaSora(
          'Ese se ha tragado media ventana. En cuatro iguales.',
        ),
      ),
      ContratoFragmento(
        denominador: 3,
        contextoNarrativo: 'se come los cables del metro',
        invocacion: LineaSora(
          'Baja al metro ese. Tres trenes dependen de cómo cortes esto.',
        ),
      ),
      ContratoFragmento(
        denominador: 5,
        contextoNarrativo: 'se come palabras de una conversación',
        invocacion: LineaSora(
          'Este es rápido. Se come lo que la gente intenta decir. En cinco.',
        ),
      ),
      ContratoFragmento(
        denominador: 4,
        contextoNarrativo: 'se come los escalones del portal',
        invocacion: LineaSora(
          'Cuatro escalones, cuatro cortes. Mira el centro.',
        ),
      ),
      ContratoFragmento(
        denominador: 3,
        contextoNarrativo: 'se come banderines de un balcón',
        invocacion: LineaSora(
          'Banderines. Cuélgalo tú otra vez. En tres.',
        ),
      ),
      ContratoFragmento(
        denominador: 5,
        contextoNarrativo: 'se come los segunderos de varios relojes',
        invocacion: LineaSora(
          'Quíntuple. Si no lo pillas, toda la calle va a retraso.',
        ),
      ),
      ContratoFragmento(
        denominador: 4,
        contextoNarrativo: 'se come el espejo retrovisor de una moto',
        invocacion: LineaSora(
          'Último de esta noche. El espejo de la moto. En cuatro.',
        ),
      ),
    ],
    lineasCierre: [
      LineaSora('Ya está por hoy.'),
      LineaSora('Diez Fragmentos. No se te da mal.'),
      LineaSora('Vete a dormir. Mañana los cazamos más gordos.'),
    ],
  );
}

/// Segunda sesión: el jugador vuelve. Sora lo reconoce y sube un punto
/// la exigencia narrativa. Misma mecánica matemática; contextos todos
/// nuevos para que no se sienta repetición.
SesionNoche segundaNoche() {
  return const SesionNoche(
    tituloDiegetico: 'Segunda noche',
    lineasIntro: [
      LineaSora('Anda, has vuelto.'),
      LineaSora('Pensaba que te habías asustado.'),
      LineaSora('Hoy hay más. Venga.'),
    ],
    contratos: [
      ContratoFragmento(
        denominador: 3,
        contextoNarrativo: 'se come los pedales de una bici abandonada',
        invocacion: LineaSora(
          'Bici abandonada al fondo. Tres pedales quedan visibles.',
        ),
      ),
      ContratoFragmento(
        denominador: 2,
        contextoNarrativo: 'se come la sombra de un farol',
        invocacion: LineaSora(
          'La sombra del farol. En dos. Sin pensarlo mucho.',
        ),
      ),
      ContratoFragmento(
        denominador: 5,
        contextoNarrativo: 'se come las frecuencias de una radio',
        invocacion: LineaSora(
          'Radio del vecino del cuarto. Cinco emisoras. No deja oír nada.',
        ),
      ),
      ContratoFragmento(
        denominador: 4,
        contextoNarrativo: 'se come las esquinas de un cartel',
        invocacion: LineaSora(
          'Cartel roto. Cuatro esquinas que no cuadran.',
        ),
      ),
      ContratoFragmento(
        denominador: 3,
        contextoNarrativo: 'se come los colores de un semáforo',
        invocacion: LineaSora(
          'Semáforo. Tres colores. Se está comiendo el amarillo.',
        ),
      ),
      ContratoFragmento(
        denominador: 5,
        contextoNarrativo: 'se come las aspas de un molinillo',
        invocacion: LineaSora(
          'Molinillo en una ventana. Cinco aspas. Se ha parado por su culpa.',
        ),
      ),
      ContratoFragmento(
        denominador: 4,
        contextoNarrativo: 'se come los cuatro lados de una alcantarilla',
        invocacion: LineaSora(
          'Alcantarilla cuadrada. Cuatro lados. Uno va a faltar.',
        ),
      ),
      ContratoFragmento(
        denominador: 2,
        contextoNarrativo: 'se come las alas de una paloma',
        invocacion: LineaSora(
          'Paloma durmiendo en una cornisa. En dos. Sin hacer ruido.',
        ),
      ),
      ContratoFragmento(
        denominador: 3,
        contextoNarrativo: 'se come las estrofas de una canción',
        invocacion: LineaSora(
          'Música de un bar. Tres estrofas. Se comen alternas.',
        ),
      ),
      ContratoFragmento(
        denominador: 5,
        contextoNarrativo: 'se come los segundos antes del amanecer',
        invocacion: LineaSora(
          'Último. Este se come el tiempo antes de que salga el sol. Cinco.',
        ),
      ),
    ],
    lineasCierre: [
      LineaSora('Mira. Ya es casi de día.'),
      LineaSora('Veinte Fragmentos en dos noches.'),
      LineaSora('No está mal.'),
      LineaSora('Vete a descansar.'),
    ],
  );
}
