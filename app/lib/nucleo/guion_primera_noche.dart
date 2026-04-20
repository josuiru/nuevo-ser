import '../dominio/sesion.dart';

/// Guión pre-escrito de la primera noche de Leo/Lía.
///
/// Respeta biblia personajes §3.6: frases cortas de Sora, "bien" como
/// máxima felicitación, sin efusividad. Cada Fragmento tiene un
/// contexto diegético (qué se está comiendo), distinto en cada combate,
/// para que la repetición de la mecánica no se sienta repetitiva
/// narrativamente.
SesionNoche primeraNoche() {
  return const SesionNoche(
    tituloDiegetico: 'Primera noche',
    lineasIntro: [
      LineaSora('Eh. Eres tú, ¿no?'),
      LineaSora('Me han dicho que tienes buen ojo.'),
      LineaSora('Vamos a ver si es verdad.'),
      LineaSora('Mira ahí abajo. El callejón.',
          esperaPulsacion: true),
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
        contextoNarrativo: 'se come las agujas de un reloj',
        invocacion: LineaSora(
          'Otro. Este se come las agujas del reloj del kiosco. En tres.',
        ),
      ),
      ContratoFragmento(
        denominador: 4,
        contextoNarrativo: 'se come las ventanas del segundo piso',
        invocacion: LineaSora(
          'Ese se ha tragado media ventana. En cuatro partes iguales.',
        ),
      ),
      ContratoFragmento(
        denominador: 5,
        contextoNarrativo: 'se come palabras de una conversación',
        invocacion: LineaSora(
          'Este es más rápido. Te vas a comer tus palabras si no lo pillas. En cinco.',
        ),
      ),
    ],
    lineasCierre: [
      LineaSora('Ya está por hoy.'),
      LineaSora('Cuatro Fragmentos no son poca cosa.'),
      LineaSora('Vete a dormir. Mañana los cazamos más gordos.'),
    ],
  );
}
