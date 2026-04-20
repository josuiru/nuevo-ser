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

/// Tercera sesión: entran los Compuestos (Familia C, biblia §5.2 C).
///
/// Alguno 2/3, 3/4, 5/6: no se corta directo, se va cortando pedazo a
/// pedazo tantas veces como diga el numerador. El niño vive físicamente
/// que una fracción no unitaria es suma de unitarias (habilidad H-B01).
SesionNoche terceraNoche() {
  return const SesionNoche(
    tituloDiegetico: 'Tercera noche',
    lineasIntro: [
      LineaSora('Vaya. Ya eres habitual.'),
      LineaSora('Hoy no valen los fáciles.'),
      LineaSora('Algunos Fragmentos son a trozos. No los partes de una vez.'),
      LineaSora('Uno a uno. Como quien desata un nudo.'),
    ],
    contratos: [
      ContratoFragmento(
        denominador: 3,
        contextoNarrativo: 'se come un zapato solitario',
        invocacion: LineaSora(
          'Entramos suaves. Un zapato olvidado. En tres.',
        ),
      ),
      ContratoFragmento(
        numerador: 2,
        denominador: 3,
        contextoNarrativo: 'se ha tragado dos tercios del callejón',
        invocacion: LineaSora(
          'Ese ha mordido dos tercios. Son dos trozos de un tercio. Uno, y después otro.',
        ),
      ),
      ContratoFragmento(
        denominador: 4,
        contextoNarrativo: 'se come un grafiti en la pared',
        invocacion: LineaSora(
          'Grafiti nuevo. Cuatro colores. Córtalo igual.',
        ),
      ),
      ContratoFragmento(
        numerador: 3,
        denominador: 4,
        contextoNarrativo: 'se come tres cuartos de una ventana',
        invocacion: LineaSora(
          'Tres cuartos de la ventana del ático. Tres veces en cuatro.',
        ),
      ),
      ContratoFragmento(
        denominador: 5,
        contextoNarrativo: 'se come las cuerdas de una guitarra',
        invocacion: LineaSora(
          'Guitarra en el balcón. Cinco cuerdas. Suave.',
        ),
      ),
      ContratoFragmento(
        numerador: 2,
        denominador: 5,
        contextoNarrativo: 'se come dos quintos de una marquesina',
        invocacion: LineaSora(
          'Marquesina rota. Dos quintos. Dos pasadas en cinco.',
        ),
      ),
      ContratoFragmento(
        numerador: 5,
        denominador: 6,
        contextoNarrativo: 'se come cinco sextos de un mosaico',
        invocacion: LineaSora(
          'Mosaico de la plaza. Cinco de seis baldosas. Concentra.',
        ),
      ),
      ContratoFragmento(
        denominador: 2,
        contextoNarrativo: 'se come el eco del último tren',
        invocacion: LineaSora(
          'El eco del último tren. En dos. Rápido antes de que pare.',
        ),
      ),
      ContratoFragmento(
        numerador: 3,
        denominador: 5,
        contextoNarrativo: 'se come tres quintos de los carteles electorales',
        invocacion: LineaSora(
          'Ironía: Fragmento devora tres de cinco carteles. Tres trozos en cinco.',
        ),
      ),
      ContratoFragmento(
        numerador: 7,
        denominador: 8,
        contextoNarrativo: 'se come casi entero un reloj de pared',
        invocacion: LineaSora(
          'Este se ha comido casi el reloj entero. Siete de ocho. Paciencia.',
        ),
      ),
    ],
    lineasCierre: [
      LineaSora('Bien. Los compuestos no son un muro.'),
      LineaSora('Son una cadena. Un eslabón cada vez.'),
      LineaSora('Mañana te presento a alguien.'),
      LineaSora('Vete a dormir.'),
    ],
  );
}
