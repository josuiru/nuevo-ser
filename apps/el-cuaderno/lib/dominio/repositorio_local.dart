import 'misterio.dart';
import 'observacion.dart';
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

  /// Lista observaciones, ordenadas por `cuandoOcurrio` descendente
  /// (la más reciente primero — coherente con la sección "última
  /// página" del home, biblia §5.4).
  ///
  /// Filtros opcionales:
  /// - [limite]: corta la lista a las primeras N entradas.
  /// - [misterioId]: solo las ancladas a ese Misterio.
  /// - [sitSpotId]: solo las hechas en ese sit spot.
  Future<List<Observacion>> obtenerObservaciones({
    int? limite,
    String? misterioId,
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

  /// Borra **todo** el contenido local del cuaderno: observaciones, sit
  /// spot (activo y retirados), misterios. Operación destructiva e
  /// irreversible — la pantalla Ajustes la envuelve en doble
  /// confirmación (doc 13 §6.3).
  ///
  /// "El cuaderno es del niño" (biblia §2.1) — y por tanto debe poder
  /// destruirlo cuando quiera. Devuelve la cuenta total de items
  /// borrados para que la UI pueda mostrar feedback honesto ("borradas
  /// 47 observaciones, 3 misterios y 1 sit spot").
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
  });

  final int observacionesBorradas;
  final int misteriosBorrados;
  final int sitSpotsBorrados;

  int get total =>
      observacionesBorradas + misteriosBorrados + sitSpotsBorrados;
}
