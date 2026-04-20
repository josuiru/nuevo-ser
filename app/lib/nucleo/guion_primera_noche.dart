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
      LineaDialogo('Eh. Eres tú, ¿no?'),
      LineaDialogo('Me han dicho que tienes buen ojo.'),
      LineaDialogo('Vamos a ver si es verdad.'),
      LineaDialogo('Mira ahí abajo. En el callejón.'),
    ],
    contratos: [
      ContratoFragmento(
        denominador: 2,
        contextoNarrativo: 'se está comiendo el cartel de la esquina',
        invocacion: LineaDialogo(
          'Ese se come el cartel de neón. Pártelo en dos.',
        ),
      ),
      ContratoFragmento(
        denominador: 3,
        contextoNarrativo: 'se come las agujas del reloj del kiosco',
        invocacion: LineaDialogo(
          'Otro. Este va a por el reloj del kiosco. En tres.',
        ),
      ),
      ContratoFragmento(
        denominador: 2,
        contextoNarrativo: 'se come el letrero de la panadería',
        invocacion: LineaDialogo(
          'Fácil. El letrero de la panadería. En dos.',
        ),
      ),
      ContratoFragmento(
        denominador: 4,
        contextoNarrativo: 'se ha tragado media ventana',
        invocacion: LineaDialogo(
          'Ese se ha tragado media ventana. En cuatro iguales.',
        ),
      ),
      ContratoFragmento(
        denominador: 3,
        contextoNarrativo: 'se come los cables del metro',
        invocacion: LineaDialogo(
          'Baja al metro ese. Tres trenes dependen de cómo cortes esto.',
        ),
      ),
      ContratoFragmento(
        denominador: 5,
        contextoNarrativo: 'se come palabras de una conversación',
        invocacion: LineaDialogo(
          'Este es rápido. Se come lo que la gente intenta decir. En cinco.',
        ),
      ),
      ContratoFragmento(
        denominador: 4,
        contextoNarrativo: 'se come los escalones del portal',
        invocacion: LineaDialogo(
          'Cuatro escalones, cuatro cortes. Mira el centro.',
        ),
      ),
      ContratoFragmento(
        denominador: 3,
        contextoNarrativo: 'se come banderines de un balcón',
        invocacion: LineaDialogo(
          'Banderines. Cuélgalo tú otra vez. En tres.',
        ),
      ),
      ContratoFragmento(
        denominador: 5,
        contextoNarrativo: 'se come los segunderos de varios relojes',
        invocacion: LineaDialogo(
          'Quíntuple. Si no lo pillas, toda la calle va a retraso.',
        ),
      ),
      ContratoFragmento(
        denominador: 4,
        contextoNarrativo: 'se come el espejo retrovisor de una moto',
        invocacion: LineaDialogo(
          'Último de esta noche. El espejo de la moto. En cuatro.',
        ),
      ),
    ],
    lineasCierre: [
      LineaDialogo('Ya está por hoy.'),
      LineaDialogo('Diez Fragmentos. No se te da mal.'),
      LineaDialogo('Vete a dormir. Mañana los cazamos más gordos.'),
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
      LineaDialogo('Anda, has vuelto.'),
      LineaDialogo('Pensaba que te habías asustado.'),
      LineaDialogo('Hoy hay más. Venga.'),
    ],
    contratos: [
      ContratoFragmento(
        denominador: 3,
        contextoNarrativo: 'se come los pedales de una bici abandonada',
        invocacion: LineaDialogo(
          'Bici abandonada al fondo. Tres pedales quedan visibles.',
        ),
      ),
      ContratoFragmento(
        denominador: 2,
        contextoNarrativo: 'se come la sombra de un farol',
        invocacion: LineaDialogo(
          'La sombra del farol. En dos. Sin pensarlo mucho.',
        ),
      ),
      ContratoFragmento(
        denominador: 5,
        contextoNarrativo: 'se come las frecuencias de una radio',
        invocacion: LineaDialogo(
          'Radio del vecino del cuarto. Cinco emisoras. No deja oír nada.',
        ),
      ),
      ContratoFragmento(
        denominador: 4,
        contextoNarrativo: 'se come las esquinas de un cartel',
        invocacion: LineaDialogo(
          'Cartel roto. Cuatro esquinas que no cuadran.',
        ),
      ),
      ContratoFragmento(
        denominador: 3,
        contextoNarrativo: 'se come los colores de un semáforo',
        invocacion: LineaDialogo(
          'Semáforo. Tres colores. Se está comiendo el amarillo.',
        ),
      ),
      ContratoFragmento(
        denominador: 5,
        contextoNarrativo: 'se come las aspas de un molinillo',
        invocacion: LineaDialogo(
          'Molinillo en una ventana. Cinco aspas. Se ha parado por su culpa.',
        ),
      ),
      ContratoFragmento(
        denominador: 4,
        contextoNarrativo: 'se come los cuatro lados de una alcantarilla',
        invocacion: LineaDialogo(
          'Alcantarilla cuadrada. Cuatro lados. Uno va a faltar.',
        ),
      ),
      ContratoFragmento(
        denominador: 2,
        contextoNarrativo: 'se come las alas de una paloma',
        invocacion: LineaDialogo(
          'Paloma durmiendo en una cornisa. En dos. Sin hacer ruido.',
        ),
      ),
      ContratoFragmento(
        denominador: 3,
        contextoNarrativo: 'se come las estrofas de una canción',
        invocacion: LineaDialogo(
          'Música de un bar. Tres estrofas. Se comen alternas.',
        ),
      ),
      ContratoFragmento(
        denominador: 5,
        contextoNarrativo: 'se come los segundos antes del amanecer',
        invocacion: LineaDialogo(
          'Último. Este se come el tiempo antes de que salga el sol. Cinco.',
        ),
      ),
    ],
    lineasCierre: [
      LineaDialogo('Mira. Ya es casi de día.'),
      LineaDialogo('Veinte Fragmentos en dos noches.'),
      LineaDialogo('No está mal.'),
      LineaDialogo('Vete a descansar.'),
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
      LineaDialogo('Vaya. Ya eres habitual.'),
      LineaDialogo('Hoy no valen los fáciles.'),
      LineaDialogo('Algunos Fragmentos son a trozos. No los partes de una vez.'),
      LineaDialogo('Uno a uno. Como quien desata un nudo.'),
    ],
    contratos: [
      ContratoFragmento(
        denominador: 3,
        contextoNarrativo: 'se come un zapato solitario',
        invocacion: LineaDialogo(
          'Entramos suaves. Un zapato olvidado. En tres.',
        ),
      ),
      ContratoFragmento(
        numerador: 2,
        denominador: 3,
        contextoNarrativo: 'se ha tragado dos tercios del callejón',
        invocacion: LineaDialogo(
          'Ese ha mordido dos tercios. Son dos trozos de un tercio. Uno, y después otro.',
        ),
      ),
      ContratoFragmento(
        denominador: 4,
        contextoNarrativo: 'se come un grafiti en la pared',
        invocacion: LineaDialogo(
          'Grafiti nuevo. Cuatro colores. Córtalo igual.',
        ),
      ),
      ContratoFragmento(
        numerador: 3,
        denominador: 4,
        contextoNarrativo: 'se come tres cuartos de una ventana',
        invocacion: LineaDialogo(
          'Tres cuartos de la ventana del ático. Tres veces en cuatro.',
        ),
      ),
      ContratoFragmento(
        denominador: 5,
        contextoNarrativo: 'se come las cuerdas de una guitarra',
        invocacion: LineaDialogo(
          'Guitarra en el balcón. Cinco cuerdas. Suave.',
        ),
      ),
      ContratoFragmento(
        numerador: 2,
        denominador: 5,
        contextoNarrativo: 'se come dos quintos de una marquesina',
        invocacion: LineaDialogo(
          'Marquesina rota. Dos quintos. Dos pasadas en cinco.',
        ),
      ),
      ContratoFragmento(
        numerador: 5,
        denominador: 6,
        contextoNarrativo: 'se come cinco sextos de un mosaico',
        invocacion: LineaDialogo(
          'Mosaico de la plaza. Cinco de seis baldosas. Concentra.',
        ),
      ),
      ContratoFragmento(
        denominador: 2,
        contextoNarrativo: 'se come el eco del último tren',
        invocacion: LineaDialogo(
          'El eco del último tren. En dos. Rápido antes de que pare.',
        ),
      ),
      ContratoFragmento(
        numerador: 3,
        denominador: 5,
        contextoNarrativo: 'se come tres quintos de los carteles electorales',
        invocacion: LineaDialogo(
          'Ironía: Fragmento devora tres de cinco carteles. Tres trozos en cinco.',
        ),
      ),
      ContratoFragmento(
        numerador: 7,
        denominador: 8,
        contextoNarrativo: 'se come casi entero un reloj de pared',
        invocacion: LineaDialogo(
          'Este se ha comido casi el reloj entero. Siete de ocho. Paciencia.',
        ),
      ),
    ],
    lineasCierre: [
      LineaDialogo('Bien. Los compuestos no son un muro.'),
      LineaDialogo('Son una cadena. Un eslabón cada vez.'),
      LineaDialogo('Mañana te presento a alguien.'),
      LineaDialogo('Vete a dormir.'),
    ],
  );
}

/// Cuarta sesión: aparece Kai (biblia §4.3) a mitad de la noche para
/// humillar con elegancia al jugador y dejarle un Fragmento difícil
/// "dedicado". Primera presencia del rival.
SesionNoche cuartaNoche() {
  return const SesionNoche(
    tituloDiegetico: 'Cuarta noche — el rival',
    lineasIntro: [
      LineaDialogo('Venga, sin calentar.'),
      LineaDialogo('Hoy vas con los ojos abiertos.'),
      LineaDialogo('Y te aguantas lo que toque.'),
    ],
    contratos: [
      ContratoFragmento(
        denominador: 4,
        contextoNarrativo: 'se come las cuatro farolas de la plaza',
        invocacion: LineaDialogo(
          'Plaza central. Cuatro farolas. Una a una.',
        ),
      ),
      ContratoFragmento(
        numerador: 2,
        denominador: 5,
        contextoNarrativo: 'se come dos quintos del escaparate',
        invocacion: LineaDialogo(
          'Escaparate de la tintorería. Dos trozos en cinco.',
        ),
      ),
      ContratoFragmento(
        denominador: 3,
        contextoNarrativo: 'se come las voces de tres vecinas',
        invocacion: LineaDialogo(
          'Vecinas discutiendo en el patio. En tres. Que vuelvan a oírse.',
        ),
      ),
      // Aquí entra Kai. Ver interrupciones más abajo.
      ContratoFragmento(
        numerador: 5,
        denominador: 7,
        contextoNarrativo: 'es el que Kai te ha "regalado"',
        invocacion: LineaDialogo(
          'Ni me mires. El de Kai. Cinco trozos en siete. Tú solo.',
        ),
      ),
      ContratoFragmento(
        denominador: 5,
        contextoNarrativo: 'se come el ritmo de una batería lejana',
        invocacion: LineaDialogo(
          'Respira. Batería de un bar. En cinco. Coge su compás.',
        ),
      ),
      ContratoFragmento(
        numerador: 3,
        denominador: 4,
        contextoNarrativo: 'se come tres cuartos del mural',
        invocacion: LineaDialogo(
          'Mural pintado hace un mes. Tres cuartos. No dejes que se borre.',
        ),
      ),
      ContratoFragmento(
        denominador: 2,
        contextoNarrativo: 'se come la mitad de una conversación',
        invocacion: LineaDialogo(
          'Conversación a medias. En dos. Que las dos partes se oigan.',
        ),
      ),
      ContratoFragmento(
        numerador: 4,
        denominador: 5,
        contextoNarrativo: 'se come cuatro quintos del tejado',
        invocacion: LineaDialogo(
          'El tejado de este edificio. Casi entero. Cuatro en cinco.',
        ),
      ),
      ContratoFragmento(
        numerador: 3,
        denominador: 7,
        contextoNarrativo: 'se come tres séptimos de una semana',
        invocacion: LineaDialogo(
          'Este se come los días. Tres de siete. Te los devuelves.',
        ),
      ),
      ContratoFragmento(
        numerador: 5,
        denominador: 8,
        contextoNarrativo: 'se come cinco octavos de la calle',
        invocacion: LineaDialogo(
          'Último. Cinco octavos de la calle entera. Con calma.',
        ),
      ),
    ],
    interrupciones: [
      InterrupcionNarrativa(
        antesDelContrato: 3,
        beats: [
          LineaDialogo('Vaya, vaya.',
              personaje: PersonajeDialogo.kai),
          LineaDialogo('Tú eres el que se rumorea.',
              personaje: PersonajeDialogo.kai),
          LineaDialogo('Me han dicho que vas por el tercero en los tejados.',
              personaje: PersonajeDialogo.kai),
          LineaDialogo('Yo iba por el séptimo a tu edad.',
              personaje: PersonajeDialogo.kai),
          LineaDialogo('Toma. Este se me ha cruzado. Todo tuyo.',
              personaje: PersonajeDialogo.kai),
          LineaDialogo('A ver cómo sales.',
              personaje: PersonajeDialogo.kai),
          LineaDialogo('Déjalo. Ya se irá.'),
          LineaDialogo('Y no le contestes. Le pone.'),
        ],
      ),
    ],
    lineasCierre: [
      LineaDialogo('Ha estado bien. El de Kai lo has llevado.'),
      LineaDialogo('No se lo digas. Ya lo sabe.'),
      LineaDialogo('Vete a dormir. Mañana otra vez.'),
    ],
  );
}
