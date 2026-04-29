/// Modelos del **Cuaderno de la Cronista** — el espacio paralelo
/// no atomizado del juego (doc 15). Es del niño: dudas, intuiciones,
/// preguntas que no entran en la rúbrica, voz interna entre Brechas.
/// El sistema NO lo evalúa.
///
/// En esta v0.1 las entradas no se editan a mano — se generan
/// automáticamente al cerrar ciertas escenas (1.0.3 con la primera
/// entrada antes de Aralar; 1.1.7 con el cierre de la Estación 1).
/// Cuando llegue el sistema de escritura libre del niño (futuro),
/// las entradas auto-generadas y las escritas convivirán.
class EntradaCuaderno {
  /// Identificador estable de la entrada. Snake_case castellano.
  /// Las auto-generadas siguen la convención
  /// `cuaderno_<id_escena_subrayado>` (cuaderno_1_0_3,
  /// cuaderno_1_1_7…). Las escritas a mano usarían UUID o timestamp.
  final String id;

  /// Fecha diegética del juego cuando la Cronista escribe la
  /// entrada. Formato libre castellano, ej: "Día 1 — Iruña" o
  /// "Tras Aralar". No es timestamp del dispositivo — es el reloj
  /// del juego según el orden narrativo.
  final String fechaDiegetica;

  /// Texto canónico de la entrada en castellano. Cuando llegue la
  /// localización a euskera/catalán, se mueve a un sistema de
  /// claves narrativas (lo mismo que las cinemáticas hoy).
  final String texto;

  const EntradaCuaderno({
    required this.id,
    required this.fechaDiegetica,
    required this.texto,
  });
}

/// Catálogo de entradas auto-generadas del Cuaderno. Cada entrada
/// se vincula a un flag (típicamente el `flagDeSalida` de la
/// cinemática que la genera). El orquestador, al cerrar una escena,
/// consulta este catálogo y persiste la entrada correspondiente.
///
/// Mantener el catálogo aquí —no inline en cada escena— permite
/// editar el texto del Cuaderno sin tocar el catálogo de escenas, y
/// deja claro qué se persiste como recuerdo de la Cronista.
class CatalogoCuaderno {
  CatalogoCuaderno._();

  /// Mapa flag → entrada. El orquestador consulta este catálogo al
  /// cerrar una unidad narrativa: si el flag activado tiene una
  /// entrada asociada, se persiste.
  static const Map<String, EntradaCuaderno> entradasPorFlag = {
    'escena_1_0_3_vista': EntradaCuaderno(
      id: 'cuaderno_1_0_3',
      fechaDiegetica: 'Día 1 — Casa, antes de Aralar',
      texto: 'Mañana voy a Aralar. No sé qué tengo que hacer. Isaura '
          'tampoco me lo ha dicho. Quizá ese sea el primer ejercicio.',
    ),
    'escena_1_1_7_vista': EntradaCuaderno(
      id: 'cuaderno_1_1_7',
      fechaDiegetica: 'Día 2 — Casa, tras Aralar',
      texto: 'No sabemos cómo se llamaban. Pero sé que enterraron a '
          'alguien que les importaba. Eso es lo que aprendí hoy.',
    ),
  };

  /// Lista ordenada de todas las entradas catalogadas. La pantalla
  /// del Cuaderno usa este orden para renderizar de más antigua a
  /// más reciente — coincide con el orden de las escenas en el
  /// Arco 1.
  static const List<EntradaCuaderno> todas = [
    EntradaCuaderno(
      id: 'cuaderno_1_0_3',
      fechaDiegetica: 'Día 1 — Casa, antes de Aralar',
      texto: 'Mañana voy a Aralar. No sé qué tengo que hacer. Isaura '
          'tampoco me lo ha dicho. Quizá ese sea el primer ejercicio.',
    ),
    EntradaCuaderno(
      id: 'cuaderno_1_1_7',
      fechaDiegetica: 'Día 2 — Casa, tras Aralar',
      texto: 'No sabemos cómo se llamaban. Pero sé que enterraron a '
          'alguien que les importaba. Eso es lo que aprendí hoy.',
    ),
  ];
}
