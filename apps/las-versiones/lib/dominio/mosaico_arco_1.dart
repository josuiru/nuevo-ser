/// **Mosaico de fin de Arco 1** — entrega creativa integradora del
/// arco (doc 15 §3). Espacio paralelo no atomizado: la Cronista
/// produce algo que junta lo que ha aprendido en el arco entero.
///
/// El Mosaico **no se evalúa con criterio algorítmico**. Es lectura
/// privada para la Cronista y, en el futuro, material que el adulto
/// acompañante puede leer (vía endpoint companion `/mosaicos`). Aquí
/// sólo se le pide a la Cronista que escriba en respuesta a tres
/// preguntas — sin mínimos, sin máximos, sin corrección.
///
/// El Mosaico v0.1 del Arco 1 cubre **una sola Brecha** (la 1.1)
/// porque es lo único implementado del arco hasta ahora. Cuando
/// entren las 1.2-1.4 al catálogo, los prompts del Mosaico se
/// reescribirán para integrar las cuatro Brechas. Apuntado en
/// `BLOQUEOS-PENDIENTES.md`.
library;

/// Una pregunta del Mosaico — texto que se le presenta a la Cronista
/// y un identificador estable para persistir su respuesta.
class PromptMosaico {
  final String id;
  final String texto;

  const PromptMosaico({required this.id, required this.texto});
}

class MosaicoArco1 {
  /// Identificador del arco — convención `arco_<n>` para futuros
  /// arcos. Sirve como `arc_id` cuando llegue el cableado al
  /// endpoint companion `/companion/mosaicos`.
  static const String idArco = 'arco_1';

  /// Título visible del Mosaico.
  static const String titulo = 'Mosaico del Arco 1 — El umbral del oficio';

  /// Glosa breve que la pantalla muestra antes de los prompts.
  static const String glosa =
      'Escribe lo que quieras en respuesta a cada pregunta. Esto no se '
      'evalúa: es tuyo. Lo que escribas se guarda en el Cuaderno y '
      'sigue siendo tuyo siempre.';

  /// Tres prompts. Mantengo el conjunto pequeño y abierto:
  /// integrador (qué te llevas), reflexivo (qué te queda) y de
  /// método (qué cambiarías). Esta tríada se repetirá en los
  /// Mosaicos posteriores con palabras distintas.
  static const List<PromptMosaico> prompts = [
    PromptMosaico(
      id: 'que_te_llevas',
      texto: '¿Qué te llevas de este arco?',
    ),
    PromptMosaico(
      id: 'que_te_queda',
      texto: '¿Qué pregunta te queda abierta?',
    ),
    PromptMosaico(
      id: 'que_cambiarias',
      texto: 'Si volvieras a empezar la Brecha del dolmen, ¿qué harías '
          'distinto?',
    ),
  ];

  /// Flag narrativo que dispara el Mosaico. El orquestador lo
  /// activa al cerrar la última Brecha del arco. Mientras el arco
  /// sólo tenga la 1.1, se activa al completarla; cuando entren
  /// 1.2-1.4 esto se ata al cierre de la 1.4.
  static const String flagDeArcoCompletado = 'arco_1_completado';

  /// Flag narrativo que se activa al guardar el Mosaico — la
  /// pantalla deja de aparecer y la Cronista vuelve al esqueleto
  /// (o al siguiente arco cuando exista).
  static const String flagDeMosaicoEntregado = 'mosaico_arco_1_entregado';
}
