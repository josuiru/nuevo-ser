import 'ambiente_cielo.dart';
import 'escena_cinematica.dart';
import 'plano_escena.dart';
import 'voz_personaje.dart';

/// Variantes recurrentes de **Era 2**, posteriores al cierre del Arco 4
/// (escena 4.14 — "La Montaña", HASTA ENTONCES). Análogas en forma a
/// las variantes de los arcos 1/2/3 (entrenamiento, puentes, máquinas)
/// pero sin un horizonte de cierre: Era 2 sigue activa indefinidamente
/// mientras el niño vuelve a jugar tras el MVP narrativo.
///
/// El propósito es **dar razón diegética para volver al juego** cuando
/// la línea principal del MVP ya ha terminado. Sin nuevas mecánicas,
/// sin combates, sin gameplay extra: solo cinemáticas pequeñas que
/// repescan personajes conocidos (Sora desde donde sea, Kai, Irune,
/// Maren del Faro, Eco) y momentos cotidianos del niño ya como
/// Iniciado I.
///
/// Pool de 6 variantes que rotan en orden estable; cuando se agotan,
/// el orquestador resetea el set y vuelve a empezar — el niño puede
/// volver a vivirlas semanas después sin que parezca un parche.
class VariantesEraDos {
  /// E2.a — Despertar. Primera mañana después del HASTA ENTONCES de
  /// Sora. Ambiente despejado, sin diálogos: solo el niño y el cuarto.
  static const EscenaCinematica primerDespertar = EscenaCinematica(
    id: 'E2.a',
    titulo: 'Era 2 — El primer despertar',
    flagDeSalida: 'variante_e2_a_usada',
    esCierreAmable: true,
    ambiente: AmbienteCielo.nocheDespejada,
    planos: [
      PlanoAmbiente(
        duracion: Duration(milliseconds: 2200),
        textoLectura:
            'La luz entra por la ventana y se apoya en la marca de Iniciado, sobre la mesa.',
      ),
      PlanoAmbiente(
        duracion: Duration(milliseconds: 1800),
        textoLectura:
            'Sora no está. La taza que dejó anoche sigue donde la dejó. Vacía.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.narrador,
        texto: 'Es de día. Hay que salir.',
        pausaPrevia: Duration(milliseconds: 900),
      ),
    ],
  );

  /// E2.b — Una nota de Sora. La encuentra el niño en el cajón. Tres
  /// frases. Voz narrador transcribiendo. La nota va sin firma porque
  /// Sora no firma — un detalle que el niño ya conoce desde 4.13.
  static const EscenaCinematica notaDeSora = EscenaCinematica(
    id: 'E2.b',
    titulo: 'Era 2 — Una nota',
    flagDeSalida: 'variante_e2_b_usada',
    esCierreAmable: true,
    ambiente: AmbienteCielo.neutro,
    planos: [
      PlanoAmbiente(
        duracion: Duration(milliseconds: 1800),
        textoLectura:
            'En el cajón superior, debajo de un trapo doblado, hay una nota. La letra es pequeña.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.narrador,
        texto: '«No te creas que sé más que tú.»',
        pausaPrevia: Duration(milliseconds: 1000),
      ),
      PlanoDialogo(
        voz: VozPersonaje.narrador,
        texto: '«Sé otras cosas. Vas aprendiendo las tuyas.»',
        pausaPrevia: Duration(milliseconds: 900),
      ),
      PlanoDialogo(
        voz: VozPersonaje.narrador,
        texto: '«Si te cae lluvia ligera, te acuerdas de mí.»',
        pausaPrevia: Duration(milliseconds: 900),
      ),
      PlanoAmbiente(
        duracion: Duration(milliseconds: 1600),
        textoLectura: 'No hay firma. El niño dobla la nota despacio.',
      ),
    ],
  );

  /// E2.c — Encuentro con Kai. Kai pasa por el barrio en una calle
  /// estrecha. Saluda corto, va deprisa. Sigue dos rangos por delante.
  static const EscenaCinematica saludoDeKai = EscenaCinematica(
    id: 'E2.c',
    titulo: 'Era 2 — Kai pasa',
    flagDeSalida: 'variante_e2_c_usada',
    esCierreAmable: true,
    ambiente: AmbienteCielo.nocheDespejada,
    planos: [
      PlanoAmbiente(
        duracion: Duration(milliseconds: 1800),
        textoLectura:
            'Calle estrecha entre los Tejados y los Canales. Alguien viene de frente, deprisa.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.kai,
        texto: 'Eh.',
        pausaPrevia: Duration(milliseconds: 700),
      ),
      PlanoDialogo(
        voz: VozPersonaje.kai,
        texto: 'Te queda bien la marca.',
        pausaPrevia: Duration(milliseconds: 800),
      ),
      PlanoAmbiente(
        duracion: Duration(milliseconds: 1400),
        textoLectura:
            'Kai sigue de largo. Dos rangos por delante. No espera respuesta.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.kai,
        texto: 'Nos vemos.',
        pausaPrevia: Duration(milliseconds: 800),
      ),
    ],
  );

  /// E2.d — Cruce con Irune en el Edificio. Mira la Montaña por la
  /// ventana del archivo. Pocas palabras. Hereda el tono solemne de
  /// la 1.13 sin repetir su contenido.
  static const EscenaCinematica iruneMiraLaMontana = EscenaCinematica(
    id: 'E2.d',
    titulo: 'Era 2 — Irune mira la Montaña',
    flagDeSalida: 'variante_e2_d_usada',
    esCierreAmable: true,
    ambiente: AmbienteCielo.cieloLimpioMontana,
    planos: [
      PlanoAmbiente(
        duracion: Duration(milliseconds: 2000),
        textoLectura:
            'Pasillo del Edificio. La Maestra Irune está parada delante de una ventana del archivo.',
      ),
      PlanoAmbiente(
        duracion: Duration(milliseconds: 1600),
        textoLectura: 'Mira la Montaña sin decir nada un rato largo.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.irune,
        texto: 'Algunos días la veo grande.',
        pausaPrevia: Duration(milliseconds: 900),
      ),
      PlanoDialogo(
        voz: VozPersonaje.irune,
        texto: 'Otros días no la veo.',
        pausaPrevia: Duration(milliseconds: 900),
      ),
      PlanoDialogo(
        voz: VozPersonaje.irune,
        texto: 'Las dos cosas son verdad.',
        pausaPrevia: Duration(milliseconds: 1000),
      ),
      PlanoAmbiente(
        duracion: Duration(milliseconds: 1600),
        textoLectura: 'Asiente una vez sin girarse. Sigue mirando.',
      ),
    ],
  );

  /// E2.e — En el Faro aparece tu nombre. Diegética: enlaza la
  /// sub-mecánica del Faro con el progreso del niño. Sora del nombre
  /// del jugador queda implícita — se respeta `{nombre}` aplicado por
  /// el sistema de tokens existente.
  static const EscenaCinematica elFaroTeMenciona = EscenaCinematica(
    id: 'E2.e',
    titulo: 'Era 2 — El Faro te menciona',
    flagDeSalida: 'variante_e2_e_usada',
    esCierreAmable: true,
    ambiente: AmbienteCielo.neutro,
    planos: [
      PlanoAmbiente(
        duracion: Duration(milliseconds: 1800),
        textoLectura:
            'En el Faro de esta semana, una columna corta menciona a un Iniciado de los Tejados que ha cerrado dominios.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.narrador,
        texto: 'No da el nombre completo. Solo las iniciales.',
        pausaPrevia: Duration(milliseconds: 900),
      ),
      PlanoDialogo(
        voz: VozPersonaje.narrador,
        texto: 'Pero las iniciales son las tuyas, {nombre}.',
        pausaPrevia: Duration(milliseconds: 1000),
      ),
      PlanoAmbiente(
        duracion: Duration(milliseconds: 1500),
        textoLectura:
            'Maren no escribe mal — eso ya lo dijo Sora una vez. Cierras el periódico.',
      ),
    ],
  );

  /// E2.f — Un Fragmento curioso. Aparece un Fragmento pequeño que no
  /// escapa, no embiste, no hace nada — solo se queda. Es la primera
  /// vez que el niño ve uno así. Es el tipo de cosa que Brina de las
  /// Afueras ha mencionado en el Faro: pequeños que conviven con la
  /// gente sin causar problema.
  static const EscenaCinematica fragmentoCurioso = EscenaCinematica(
    id: 'E2.f',
    titulo: 'Era 2 — El Fragmento que se queda',
    flagDeSalida: 'variante_e2_f_usada',
    esCierreAmable: true,
    ambiente: AmbienteCielo.niebla,
    planos: [
      PlanoAmbiente(
        duracion: Duration(milliseconds: 2000),
        textoLectura:
            'Niebla baja en el patio. Un Fragmento pequeño, casi del tamaño de una manzana, flota a media altura.',
      ),
      PlanoAmbiente(
        duracion: Duration(milliseconds: 1800),
        textoLectura:
            'No huye. No se acerca. Pulsa despacio, como si respirara.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.narrador,
        texto: 'Brina escribió en el Faro que los hay así. Pequeños, tranquilos.',
        pausaPrevia: Duration(milliseconds: 900),
      ),
      PlanoDialogo(
        voz: VozPersonaje.narrador,
        texto: 'No lo tocas. Pasas de largo. El Fragmento sigue donde estaba.',
        pausaPrevia: Duration(milliseconds: 900),
      ),
      PlanoAmbiente(
        duracion: Duration(milliseconds: 1500),
        textoLectura: 'Cuando te giras desde el final del patio, ya no está.',
      ),
    ],
  );

  static const List<EscenaCinematica> todas = [
    primerDespertar,
    notaDeSora,
    saludoDeKai,
    iruneMiraLaMontana,
    elFaroTeMenciona,
    fragmentoCurioso,
  ];

  /// Elige la siguiente variante: la primera no usada recientemente.
  /// Si todas están en [usadasRecientemente], devuelve `null` (señal
  /// de que el pool se ha agotado y el caller debe resetearlo).
  static EscenaCinematica? elegirSiguiente(
    Set<String> usadasRecientemente,
  ) {
    for (final variante in todas) {
      if (!usadasRecientemente.contains(variante.id)) {
        return variante;
      }
    }
    return null;
  }
}
