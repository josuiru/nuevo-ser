import 'escena_cinematica.dart';
import 'plano_escena.dart';
import 'voz_personaje.dart';

/// Variantes recurrentes de "Los puentes" (doc 08 §2.4). Análogas a las
/// variantes de entrenamiento del Arco 1 pero ambientadas con Rexán en
/// los Canales. 4 mini-cinemáticas que se rotan durante el Arco 2.
class VariantesPuentes {
  /// 2.4a — Puente pequeño de piedra. Reflejo mal iluminado.
  static const EscenaCinematica puentePequeno = EscenaCinematica(
    id: '2.4a',
    titulo: 'Puentes — puente pequeño',
    flagDeSalida: 'variante_2_4_a_usada',
    esCierreAmable: true,
    planos: [
      PlanoAmbiente(
        duracion: Duration(milliseconds: 1800),
        textoLectura:
            'Puente pequeño de piedra. El agua baja muy despacio. Faroles lejanos.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.rexan,
        texto: 'Mira el agua un momento.',
        pausaPrevia: Duration(milliseconds: 700),
      ),
      PlanoDialogo(
        voz: VozPersonaje.rexan,
        texto:
            'Cuando un Fragmento se simplifica, es como reconocer tu cara en un reflejo mal iluminado.',
        pausaPrevia: Duration(milliseconds: 1000),
      ),
      PlanoDialogo(
        voz: VozPersonaje.rexan,
        texto: 'Parece otra cosa. No lo es.',
        pausaPrevia: Duration(milliseconds: 900),
      ),
      PlanoDialogo(
        voz: VozPersonaje.rexan,
        texto: 'Venga. Otra ronda.',
        pausaPrevia: Duration(milliseconds: 700),
      ),
    ],
  );

  /// 2.4b — Mercadillo nocturno. Rexán compra con monedas antiguas.
  static const EscenaCinematica mercadilloNocturno = EscenaCinematica(
    id: '2.4b',
    titulo: 'Puentes — mercadillo nocturno',
    flagDeSalida: 'variante_2_4_b_usada',
    esCierreAmable: true,
    planos: [
      PlanoAmbiente(
        duracion: Duration(milliseconds: 2000),
        textoLectura:
            'Puente largo con mercadillo nocturno. Voces bajas, un olor a pan viejo.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.rexan,
        texto: 'Lleva vendiendo aquí desde que yo era joven.',
        pausaPrevia: Duration(milliseconds: 700),
      ),
      PlanoDialogo(
        voz: VozPersonaje.rexan,
        texto: 'Nunca ha cambiado los precios.',
        pausaPrevia: Duration(milliseconds: 800),
      ),
      PlanoAmbiente(
        duracion: Duration(milliseconds: 2000),
        textoLectura:
            'Compra dos bebidas. Paga con monedas antiguas que el vendedor acepta sin comentar.',
      ),
    ],
  );

  /// 2.4c — Puente con vista a la Montaña. Rexán menciona a Irune.
  /// El guion tiene dos ramas según si el niño preguntó a Sora por la
  /// Montaña en el Arco 1. Usamos una PlanoEleccion para recoger la
  /// respuesta aquí sin depender de flags previos — queda canónico
  /// dentro de la escena.
  static const EscenaCinematica vistaMontana = EscenaCinematica(
    id: '2.4c',
    titulo: 'Puentes — vista a la Montaña',
    flagDeSalida: 'variante_2_4_c_usada',
    esCierreAmable: true,
    planos: [
      PlanoAmbiente(
        duracion: Duration(milliseconds: 2200),
        textoLectura:
            'Puente alto. La Montaña al fondo, recortada sobre un cielo limpio.',
      ),
      PlanoEleccion(
        voz: VozPersonaje.rexan,
        textoPrompt: '¿Le has preguntado a Irune por eso alguna vez?',
        opciones: [
          OpcionEleccion(
            textoJugador: 'No.',
            textoRespuesta: 'Mejor. No es momento.',
            flagsAEstablecer: {'rexan_montana_no_preguntado'},
          ),
          OpcionEleccion(
            textoJugador: 'Sí. Dijo que hoy no.',
            textoRespuesta: 'Así es Irune.',
            flagsAEstablecer: {'rexan_montana_preguntado'},
          ),
        ],
      ),
    ],
  );

  /// 2.4d — Tras un fallo. Metáfora del pan partido. Pedagógica.
  static const EscenaCinematica panPartido = EscenaCinematica(
    id: '2.4d',
    titulo: 'Puentes — el pan partido',
    flagDeSalida: 'variante_2_4_d_usada',
    esCierreAmable: true,
    planos: [
      PlanoAmbiente(
        duracion: Duration(milliseconds: 1800),
        textoLectura:
            'Rexán se agacha despacio. Saca un pedacito de pan y lo parte en dos.',
      ),
      PlanoEleccion(
        voz: VozPersonaje.rexan,
        textoPrompt: '¿Esto es un medio?',
        opciones: [
          OpcionEleccion(
            textoJugador: 'Sí.',
            textoRespuesta: 'Bien.',
          ),
        ],
      ),
      PlanoAmbiente(
        duracion: Duration(milliseconds: 1600),
        textoLectura: 'Parte una de las mitades otra vez.',
      ),
      PlanoEleccion(
        voz: VozPersonaje.rexan,
        textoPrompt: '¿Y esto es...?',
        opciones: [
          OpcionEleccion(
            textoJugador: 'Un cuarto.',
            textoRespuesta: 'Bien.',
          ),
        ],
      ),
      PlanoDialogo(
        voz: VozPersonaje.rexan,
        texto: 'Si junto dos cuartos, tengo un medio.',
        pausaPrevia: Duration(milliseconds: 900),
      ),
      PlanoDialogo(
        voz: VozPersonaje.rexan,
        texto: 'El camino es al revés, pero el pan sigue siendo el mismo pan.',
        pausaPrevia: Duration(milliseconds: 1100),
      ),
    ],
  );

  static const List<EscenaCinematica> todas = [
    puentePequeno,
    mercadilloNocturno,
    vistaMontana,
    panPartido,
  ];

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
