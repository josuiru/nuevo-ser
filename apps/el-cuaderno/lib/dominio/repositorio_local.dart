import 'misterio.dart';
import 'observacion.dart';
import 'pregunta_del_nino.dart';
import 'sit_spot.dart';

/// Contrato del almacén local del cuaderno. La implementación viva en
/// S1 es Isar (`lib/infraestructura/isar/`); S2 podrá añadir un wrapper
/// de sincronización por encima sin tocar el contrato. La idea: el
/// dominio no sabe de Isar.
///
/// **Reglas estructurales del almacén** (doc 03 §3.3):
///
/// - Texto libre, fotos, dibujos, conversaciones con el Tutor: solo
///   aquí, nunca en servidor.
/// - Coordenadas precisas del sit spot: solo aquí.
/// - Mosaicos de estación: solo aquí.
///
/// El cliente de sincronización (Sprint 2) leerá de este repositorio
/// solo los **metadatos** que pueden cruzar red (hash de `queVio`,
/// `regionCode` derivado, agregados firmados) — nunca los campos
/// crudos.
abstract class RepositorioLocal {
  /// Persiste una observación. Idempotente por [Observacion.id]: si
  /// ya existe, sobrescribe.
  Future<void> guardarObservacion(Observacion observacion);

  /// Devuelve la observación con [id] o `null` si no existe. Útil para
  /// la cola de sincronización (S2-D), que persiste UUIDs pendientes y
  /// rehidrata cada observación al intentar enviarla.
  Future<Observacion?> obtenerObservacionPorId(String id);

  /// Borra una observación por id. Idempotente: si no existe, no
  /// lanza. Si la observación estaba anclada a un Misterio, la
  /// implementación se encarga de retirarla de la lista
  /// `Misterio.observacionesIds` para que la página del Misterio no
  /// muestre fantasmas. La cola de sync de S2-D no se toca aquí —
  /// si la observación todavía estaba pendiente, esa entrada queda
  /// huérfana y se descarta cuando el reintento la rehidrate vía
  /// [obtenerObservacionPorId] y reciba `null`.
  Future<void> borrarObservacion(String id);

  /// Lista observaciones, ordenadas por `cuandoOcurrio` descendente
  /// (la más reciente primero — coherente con la sección "última
  /// página" del home, biblia §5.4).
  ///
  /// Filtros opcionales:
  /// - [limite]: corta la lista a las primeras N entradas.
  /// - [misterioId]: solo las ancladas a ese Misterio.
  /// - [preguntaDelNinoId]: solo las ancladas a esa pregunta del niño.
  /// - [sitSpotId]: solo las hechas en ese sit spot.
  Future<List<Observacion>> obtenerObservaciones({
    int? limite,
    String? misterioId,
    String? preguntaDelNinoId,
    String? sitSpotId,
  });

  /// El sit spot activo del niño. `null` si todavía no lo ha elegido.
  /// El MVP solo permite uno activo a la vez (biblia §5.1).
  Future<SitSpot?> obtenerSitSpot();

  /// Establece el sit spot activo. Si ya había uno y se llama con
  /// otro id distinto, el anterior **no se borra** — se le asigna
  /// `retiradoEn` y sigue accesible como página de cuaderno (doc 13
  /// §2.6).
  Future<void> establecerSitSpot(SitSpot sitSpot);

  /// Sit spots jubilados (con `retiradoEn != null`). Doc 13 §2.6 dice
  /// que la página sigue guardada en el cuaderno; esta es la API que
  /// la pantalla de "sit spots de antes" consume. Devuelve los más
  /// recientemente jubilados primero.
  Future<List<SitSpot>> obtenerSitSpotsJubilados();

  /// Misterios abiertos del niño (los que tiene activos para anclar
  /// observaciones). El sistema mantiene entre 3 y 5 (biblia §5.3).
  Future<List<Misterio>> obtenerMisteriosAbiertos();

  /// Vincula una observación a un Misterio. Si la observación ya
  /// existía, actualiza su [Observacion.misterioId]; si el Misterio
  /// llevaba la observación en su lista, la mantiene; si no, la añade.
  Future<void> anclarObservacionAMisterio(
    String observacionId,
    String misterioId,
  );

  /// Devuelve un Misterio por id o `null` si no existe en el catálogo
  /// del niño. Útil para la página del Misterio cerrado, que necesita
  /// refrescar el modelo tras cerrar/reabrir.
  Future<Misterio?> obtenerMisterioPorId(String id);

  /// Misterios que el niño ha cerrado declarando *"ya tengo mi
  /// respuesta"*. Estado del niño, no del catálogo — el
  /// [Misterio.estado] (consenso/hipotesisActiva) sigue intacto. Los
  /// más recientemente cerrados primero. No incluye Misterios sin
  /// cerrar.
  Future<List<Misterio>> obtenerMisteriosCerradosPorNino();

  /// El niño declara que ya tiene su respuesta para [misterioId].
  /// Persiste `cerradoPorNino = ahora` y `respuestaDelNino = respuesta`.
  /// **Lanza** si el Misterio no existe, si ya estaba cerrado, o si
  /// [respuesta] es vacía/sólo-espacios — el contenido pedagógico del
  /// cierre es la respuesta del niño, sin texto el cierre es ruido.
  /// El [Misterio.estado] canónico no se toca.
  Future<void> cerrarMisterioParaNino(String misterioId, String respuesta);

  /// El niño reabre un Misterio que había cerrado. Limpia
  /// `cerradoPorNino` y `respuestaDelNino`. Idempotente sólo si el
  /// Misterio existía y estaba cerrado; lanza si no existe. Reabrir un
  /// Misterio ya abierto no es un error — no hace nada.
  Future<void> reabrirMisterioParaNino(String misterioId);

  /// Persiste o sobrescribe una pregunta formulada por el niño.
  /// Idempotente por [PreguntaDelNino.id]. Las preguntas del niño
  /// **conviven** con el catálogo de Misterios pero no se mezclan: ids
  /// distintos, listados distintos, cierres distintos.
  Future<void> guardarPreguntaDelNino(PreguntaDelNino pregunta);

  /// Vincula una observación a una pregunta del niño. Paralelo a
  /// [anclarObservacionAMisterio]. Si la observación ya tenía
  /// `preguntaDelNinoId`, lo sobrescribe; si la pregunta no tenía la
  /// observación en su lista, la añade al final.
  ///
  /// **Lanza** si la observación o la pregunta no existen.
  Future<void> anclarObservacionAPregunta(
    String observacionId,
    String preguntaId,
  );

  /// Devuelve la pregunta con [id] o `null` si no existe. Útil para
  /// refrescar la página de la pregunta tras cerrar/reabrir.
  Future<PreguntaDelNino?> obtenerPreguntaDelNinoPorId(String id);

  /// Lista de preguntas del niño abiertas (con `cerradaEn == null`).
  /// Más recientes primero por `formuladaEn`.
  Future<List<PreguntaDelNino>> obtenerPreguntasDelNinoAbiertas();

  /// Lista de preguntas del niño cerradas. Más recientemente cerradas
  /// primero por `cerradaEn`.
  Future<List<PreguntaDelNino>> obtenerPreguntasDelNinoCerradas();

  /// Borra una pregunta del niño por id. Idempotente: si no existe, no
  /// lanza. Las observaciones que estaban ancladas a ella **NO** se
  /// borran — sólo pierden el anclaje (la pregunta deja de existir,
  /// pero las páginas del cuaderno siguen siendo del niño). El flujo
  /// "borrar mi cuaderno" sí las purga junto con todo lo demás.
  Future<void> borrarPreguntaDelNino(String id);

  /// El niño declara *"ya tengo mi respuesta"* sobre [preguntaId].
  /// Persiste `cerradaEn = ahora` y `respuestaDelNino = respuesta`.
  /// **Lanza** si la pregunta no existe, si ya estaba cerrada, o si
  /// [respuesta] es vacía/sólo-espacios.
  Future<void> cerrarPreguntaDelNino(String preguntaId, String respuesta);

  /// El niño reabre una pregunta cerrada. Limpia `cerradaEn` y
  /// `respuestaDelNino`. Lanza si no existe; idempotente si ya estaba
  /// abierta.
  Future<void> reabrirPreguntaDelNino(String preguntaId);

  /// Borra **todo** el contenido local del cuaderno: observaciones, sit
  /// spot (activo y retirados), misterios, preguntas del niño.
  /// Operación destructiva e irreversible — la pantalla Ajustes la
  /// envuelve en doble confirmación (doc 13 §6.3).
  ///
  /// "El cuaderno es del niño" (biblia §2.1) — y por tanto debe poder
  /// destruirlo cuando quiera. Devuelve la cuenta total de items
  /// borrados para que la UI pueda mostrar feedback honesto ("borradas
  /// 47 observaciones, 3 misterios, 2 preguntas tuyas y 1 sit spot").
  Future<ResultadoBorrado> borrarTodoLoLocal();
}

/// Resumen del borrado para feedback en la UI. Sin emojis, sin
/// celebración — el tono es informativo (la pérdida de un cuaderno no
/// se celebra).
class ResultadoBorrado {
  const ResultadoBorrado({
    required this.observacionesBorradas,
    required this.misteriosBorrados,
    required this.sitSpotsBorrados,
    this.preguntasDelNinoBorradas = 0,
  });

  final int observacionesBorradas;
  final int misteriosBorrados;
  final int sitSpotsBorrados;

  /// Default 0 para no romper a los callers de tests u otras suites que
  /// instancian un [ResultadoBorrado] sin tocar preguntas del niño. La
  /// implementación real del repo siempre lo rellena.
  final int preguntasDelNinoBorradas;

  int get total =>
      observacionesBorradas +
      misteriosBorrados +
      sitSpotsBorrados +
      preguntasDelNinoBorradas;
}
