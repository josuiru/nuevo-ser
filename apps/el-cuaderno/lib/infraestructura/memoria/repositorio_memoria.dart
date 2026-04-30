import '../../dominio/misterio.dart';
import '../../dominio/observacion.dart';
import '../../dominio/repositorio_local.dart';
import '../../dominio/sit_spot.dart';

/// Implementación en memoria del [RepositorioLocal]. Sirve a dos
/// propósitos: (a) los tests de widget no necesitan abrir Isar; (b) un
/// arranque headless o un dev rápido pueden usarlo como sustituto.
///
/// **No usar en producción**: no hay persistencia. Cierra la app y se
/// pierde todo.
class RepositorioMemoria implements RepositorioLocal {
  final Map<String, Observacion> _observaciones = {};
  final Map<String, Misterio> _misterios = {};
  SitSpot? _sitSpotActivo;
  final List<SitSpot> _sitSpotsRetirados = [];

  @override
  Future<void> guardarObservacion(Observacion observacion) async {
    _observaciones[observacion.id] = observacion;
  }

  @override
  Future<Observacion?> obtenerObservacionPorId(String id) async {
    return _observaciones[id];
  }

  @override
  Future<List<Observacion>> obtenerObservaciones({
    int? limite,
    String? misterioId,
    String? sitSpotId,
  }) async {
    var lista = _observaciones.values.where((observacion) {
      if (misterioId != null && observacion.misterioId != misterioId) {
        return false;
      }
      if (sitSpotId != null && observacion.sitSpotId != sitSpotId) {
        return false;
      }
      return true;
    }).toList();

    lista.sort((a, b) => b.cuandoOcurrio.compareTo(a.cuandoOcurrio));

    if (limite != null && lista.length > limite) {
      lista = lista.sublist(0, limite);
    }
    return lista;
  }

  @override
  Future<SitSpot?> obtenerSitSpot() async {
    // Coherente con `RepositorioIsar.obtenerSitSpot`: sólo el activo
    // (sin `retiradoEn`). Si el sit spot guardado está jubilado,
    // devolvemos null para que el home muestre la tarjeta de
    // invitación.
    final activo = _sitSpotActivo;
    if (activo == null || activo.retiradoEn != null) return null;
    return activo;
  }

  @override
  Future<void> establecerSitSpot(SitSpot sitSpot) async {
    final anterior = _sitSpotActivo;
    // Caso jubilación in-place: llega el activo con `retiradoEn`
    // poblado. Lo movemos a la lista de jubilados y dejamos el
    // activo en null para que la tarjeta del home vuelva a la
    // invitación. Coherente con el flujo de doc 13 §2.6.
    if (sitSpot.retiradoEn != null) {
      _sitSpotsRetirados.add(sitSpot);
      if (anterior != null && anterior.id == sitSpot.id) {
        _sitSpotActivo = null;
      }
      return;
    }
    if (anterior != null &&
        anterior.id != sitSpot.id &&
        anterior.retiradoEn == null) {
      _sitSpotsRetirados
          .add(anterior.copyWith(retiradoEn: DateTime.now()));
    }
    _sitSpotActivo = sitSpot;
  }

  @override
  Future<List<SitSpot>> obtenerSitSpotsJubilados() async {
    final lista = [..._sitSpotsRetirados];
    lista.sort((a, b) => (b.retiradoEn ?? b.creadoEn)
        .compareTo(a.retiradoEn ?? a.creadoEn));
    return lista;
  }

  @override
  Future<List<Misterio>> obtenerMisteriosAbiertos() async {
    return _misterios.values
        .where((misterio) => misterio.abierto && misterio.estaVigente)
        .toList()
      ..sort((a, b) => a.pregunta.compareTo(b.pregunta));
  }

  @override
  Future<void> anclarObservacionAMisterio(
    String observacionId,
    String misterioId,
  ) async {
    final observacion = _observaciones[observacionId];
    if (observacion == null) {
      throw StateError(
        'no hay observación con id $observacionId — '
        'guárdala antes de anclarla',
      );
    }
    final misterio = _misterios[misterioId];
    if (misterio == null) {
      throw StateError(
        'no hay misterio con id $misterioId — el catálogo no lo conoce',
      );
    }
    _observaciones[observacionId] =
        observacion.copyWith(misterioId: misterioId);
    if (!misterio.observacionesIds.contains(observacionId)) {
      _misterios[misterioId] = misterio.copyWith(
        observacionesIds: [...misterio.observacionesIds, observacionId],
      );
    }
  }

  /// Persiste un Misterio del catálogo. Equivalente al
  /// `guardarMisterio` del repositorio Isar.
  Future<void> guardarMisterio(Misterio misterio) async {
    _misterios[misterio.id] = misterio;
  }

  @override
  Future<ResultadoBorrado> borrarTodoLoLocal() async {
    final observacionesAntes = _observaciones.length;
    final misteriosAntes = _misterios.length;
    final sitSpotsAntes = _sitSpotsRetirados.length + (_sitSpotActivo == null ? 0 : 1);
    _observaciones.clear();
    _misterios.clear();
    _sitSpotsRetirados.clear();
    _sitSpotActivo = null;
    return ResultadoBorrado(
      observacionesBorradas: observacionesAntes,
      misteriosBorrados: misteriosAntes,
      sitSpotsBorrados: sitSpotsAntes,
    );
  }
}
