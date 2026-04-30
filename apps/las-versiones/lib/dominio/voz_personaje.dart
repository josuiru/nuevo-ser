import 'package:flutter/material.dart';
import 'package:nuevo_ser_core/nuevo_ser_core.dart';

import '../nucleo/paleta_archivo.dart';

/// Voz concreta del worldbuilding de Las Versiones. Implementa el
/// contrato genérico [VozPersonajeContrato] del core para que el
/// sistema de cinemáticas compartido sepa cómo pintarla.
///
/// El elenco fijado en doc 04 (biblia de personajes) e introducido por
/// doc 14 §1 se materializa aquí como instancias `static const`. La
/// API estilo enum (`VozPersonaje.maren`, `voz.nombreVisible`) imita
/// la de Uno Roto para que los call-sites narrativos compartan
/// intuición entre los dos juegos.
///
/// **Provisional**: los colores salen de [PaletaArchivo], que aún está
/// pendiente de cerrar contra el doc 11. Cuando se aborde la fase
/// visual, las atribuciones de color por personaje se revisan junto
/// con la paleta.
///
/// Sobre `esEnfasis`: en Las Versiones la voz con énfasis tipográfico
/// está reservada a las "voces de fuente" — un fragmento en latín, una
/// cita medieval, la lectura de un manuscrito. Hoy no hay ningún
/// personaje del elenco que la lleve; cuando aparezca el primer
/// narrador-fuente se añadirá como instancia con `esEnfasis: true`.
final class VozPersonaje implements VozPersonajeContrato {
  @override
  final String nombreVisible;
  @override
  final Color colorNombre;
  @override
  final bool esEnfasis;

  const VozPersonaje._({
    required this.nombreVisible,
    required this.colorNombre,
    this.esEnfasis = false,
  });

  /// Voz sin atribución — acotación de cuaderno, descripción de
  /// ambiente o lectura genérica del Archivo.
  static const VozPersonaje narrador = VozPersonaje._(
    nombreVisible: '',
    colorNombre: PaletaArchivo.textoTenue,
  );

  /// **Maren Lozano**, 13 años, protagonista. Aspirante a Cronista.
  /// Voz introspectiva del Cuaderno; en escenas habladas es directa
  /// pero todavía aprendiendo el oficio.
  static const VozPersonaje maren = VozPersonaje._(
    nombreVisible: 'Maren',
    colorNombre: PaletaArchivo.textoPrincipal,
  );

  /// **Isaura**, mentora del Archivo. Cuidadora pedagógica de Maren.
  /// El ámbar lacre marca su autoridad como Cronista superior y su
  /// rol como sello del Archivo.
  static const VozPersonaje isaura = VozPersonaje._(
    nombreVisible: 'Isaura',
    colorNombre: PaletaArchivo.ambarLacre,
  );

  /// **Tasio**, otro aspirante de la misma cohorte. Rival sano —
  /// pone tensión sin ser antagonista.
  static const VozPersonaje tasio = VozPersonaje._(
    nombreVisible: 'Tasio',
    colorNombre: PaletaArchivo.textoPrincipal,
  );

  /// **Begoña**, archivera mayor del Archivo. Figura institucional
  /// más distante que Isaura — aparece en ceremonias y evaluaciones
  /// formales (Concilio).
  static const VozPersonaje begona = VozPersonaje._(
    nombreVisible: 'Begoña',
    colorNombre: PaletaArchivo.ambarLacre,
  );

  /// **Karim Belkacem**, 47 años, epigrafista del Archivo (doc 08
  /// §2.1.2). Cronista revisor en los concilios del Arco 1 (1.3, 1.4)
  /// y mentor pedagógico de la Estación 2.1 — enseña a Maren a leer
  /// inscripciones romanas con honestidad sobre lo que falta. Es
  /// Cronista, no aspirante; para alinearlo visualmente con los
  /// otros Cronistas del Archivo (Andrés `tintaTenue`) habría que
  /// cambiar su color, registrado en `BLOQUEOS-PENDIENTES.md`.
  static const VozPersonaje karim = VozPersonaje._(
    nombreVisible: 'Karim',
    colorNombre: PaletaArchivo.textoPrincipal,
  );

  /// **Andrés Vidaurre**, archivero técnico — el del ático con
  /// vitrinas de piezas. Humor seco, cercano. Tinta tenue para
  /// diferenciarlo del ámbar institucional de Isaura/Begoña.
  static const VozPersonaje andres = VozPersonaje._(
    nombreVisible: 'Andrés',
    colorNombre: PaletaArchivo.tintaTenue,
  );

  /// **Marina Ríos**, 17 años, Aprendiz III, Reformista. La compañera
  /// avanzada que Maren cruza en el pasillo el primer día.
  static const VozPersonaje marina = VozPersonaje._(
    nombreVisible: 'Marina',
    colorNombre: PaletaArchivo.textoPrincipal,
  );

  /// **Aitor Etxeberri**, Constructor mayor — especialista en el
  /// Camino. Aparece de refilón en 1.0.2 sentado sobre un manuscrito.
  static const VozPersonaje aitor = VozPersonaje._(
    nombreVisible: 'Aitor',
    colorNombre: PaletaArchivo.ambarLacre,
  );

  /// **Iratxe**, madre de Maren. Voz familiar — la que la presentó al
  /// Archivo desde dentro: ya conocía a Begoña antes de que Maren
  /// llegara. Tinta tenue para marcarla como voz íntima, no oficial.
  static const VozPersonaje iratxe = VozPersonaje._(
    nombreVisible: 'Iratxe',
    colorNombre: PaletaArchivo.tintaTenue,
  );

  /// **Antonio**, padre de Maren. Profesor de instituto. Aparece
  /// poco pero su gesto al volver a casa el primer día —besarla en
  /// la cabeza, dejarle un libro— marca el tono de la familia.
  static const VozPersonaje antonio = VozPersonaje._(
    nombreVisible: 'Antonio',
    colorNombre: PaletaArchivo.tintaTenue,
  );

  /// **Naia**, 8 años, hermana pequeña. Ojos abiertos, preguntas
  /// directas. Es ella quien hace la pregunta que abre el oficio
  /// para Maren ("¿y cómo sabes cómo pasaron?"). Tinta tenue como
  /// el resto de la familia.
  static const VozPersonaje naia = VozPersonaje._(
    nombreVisible: 'Naia',
    colorNombre: PaletaArchivo.tintaTenue,
  );

  /// **Eider**, amiga del instituto de Maren. Voz adolescente
  /// directa — la única persona ajena al Archivo con la que Maren
  /// comparte lo que está aprendiendo. Pedagógicamente importante:
  /// el oficio histórico no se queda dentro del Archivo, también se
  /// mide en cómo se cuenta a alguien que no está en él. Tinta tenue
  /// como el resto del entorno íntimo no-institucional.
  static const VozPersonaje eider = VozPersonaje._(
    nombreVisible: 'Eider',
    colorNombre: PaletaArchivo.tintaTenue,
  );

  /// **Sira Goizueta**, 15 años, Aprendiz II Constructora. Compañera
  /// de Maren en la Brecha 1.2 (crómlech) — primera vez que Maren
  /// trabaja en un equipo pequeño con otra aprendiza. Más rápida que
  /// Maren, propone dataciones con menos cautela. La negociación
  /// entre las dos es el corazón pedagógico de la Estación 2.
  /// Texto principal porque es par de Maren (no autoridad).
  static const VozPersonaje sira = VozPersonaje._(
    nombreVisible: 'Sira',
    colorNombre: PaletaArchivo.textoPrincipal,
  );

  /// **Joana Sasiain**, Anclada del Archivo. Revisora en el primer
  /// Concilio formal de Maren (Brecha 1.3, cueva). Voz académica
  /// rigurosa — pregunta por categorías, exige distinciones. Ámbar
  /// lacre porque es autoridad institucional, igual que Begoña,
  /// Isaura y Aitor.
  static const VozPersonaje joana = VozPersonaje._(
    nombreVisible: 'Joana',
    colorNombre: PaletaArchivo.ambarLacre,
  );

  /// **Joxe**, custodio de la cueva del Pirineo (Brecha 1.3).
  /// Hombre mayor del valle vinculado a la administración foral —
  /// abre las verjas, controla el tiempo de visita. Voz funcional,
  /// pocas líneas. Tinta tenue (figura del territorio, no del
  /// Archivo).
  static const VozPersonaje joxe = VozPersonaje._(
    nombreVisible: 'Joxe',
    colorNombre: PaletaArchivo.tintaTenue,
  );

  /// **El arqueólogo de Irulegi** — voz del yacimiento (Brecha 1.4).
  /// El doc 07 no le da nombre completo en pantalla; aparece como
  /// "el arqueólogo". Aquí se resuelve con una etiqueta funcional
  /// `Arqueólogo` que respeta la decisión del guion canónico.
  /// Tinta tenue — no pertenece al Archivo.
  static const VozPersonaje arqueologo = VozPersonaje._(
    nombreVisible: 'Arqueólogo',
    colorNombre: PaletaArchivo.tintaTenue,
  );

  /// **La arqueóloga de Calahorra** — voz del yacimiento de Calagurris
  /// (Brecha 2.2). El doc 08 §2.2.2 la presenta como "una arqueóloga
  /// del museo, mujer mayor con anorak rojo" y deliberadamente no le
  /// asigna nombre en pantalla. Aquí se resuelve con una etiqueta
  /// funcional `Arqueóloga` simétrica al `Arqueólogo` de Irulegi —
  /// ambas voces locales del territorio, cada una con género
  /// distinto, ninguna del Archivo. Tinta tenue.
  static const VozPersonaje arqueologa = VozPersonaje._(
    nombreVisible: 'Arqueóloga',
    colorNombre: PaletaArchivo.tintaTenue,
  );

  /// Voz sin atribución personal, reservada a **fragmentos de fuente
  /// histórica** que el player levanta del manuscrito sin ponerlos en
  /// boca de un personaje del elenco: una cita en latín, una línea
  /// de un fuero medieval, la lectura literal de un colofón. Lleva
  /// `esEnfasis: true` para que el player las renderice con el estilo
  /// distinguido del habla humana (itálica) — equivalente epistémico
  /// de los Fragmentos nombrados de Uno Roto.
  static const VozPersonaje vozDeFuente = VozPersonaje._(
    nombreVisible: '',
    colorNombre: PaletaArchivo.tintaTenue,
    esEnfasis: true,
  );

  /// Estilo del cuerpo del diálogo — sans del tema con tracking
  /// abierto y peso ligero, coherente con la legibilidad de
  /// manuscrito que persigue la paleta. Cuando el doc 11 cierre la
  /// tipografía del Archivo (probable serif con eje humanista) este
  /// método devolverá el estilo definitivo, y las voces de fuente
  /// (`esEnfasis: true`) se diferenciarán con itálica + serif.
  @override
  TextStyle estiloTextoCuerpo() {
    if (esEnfasis) {
      return const TextStyle(
        fontSize: 21,
        height: 1.45,
        color: PaletaArchivo.textoPrincipal,
        fontStyle: FontStyle.italic,
        letterSpacing: 0.4,
        fontWeight: FontWeight.w400,
      );
    }
    return const TextStyle(
      fontSize: 19,
      height: 1.55,
      color: PaletaArchivo.textoPrincipal,
      letterSpacing: 0.3,
      fontWeight: FontWeight.w300,
    );
  }
}
