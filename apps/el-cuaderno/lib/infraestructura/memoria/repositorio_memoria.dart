import '../../dominio/misterio.dart';
import '../../dominio/observacion.dart';
import '../../dominio/pregunta_del_nino.dart';
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
  final Map<String, PreguntaDelNino> _preguntasDelNino = {};
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
  Future<void> borrarObservacion(String id) async {
    final observacion = _observaciones.remove(id);
    if (observacion == null) return;
    final misterioId = observacion.misterioId;
    if (misterioId != null) {
      final misterio = _misterios[misterioId];
      if (misterio != null && misterio.observacionesIds.contains(id)) {
        final actualizadas = [
          for (final ref in misterio.observacionesIds)
            if (ref != id) ref,
        ];
        _misterios[misterioId] =
            misterio.copyWith(observacionesIds: actualizadas);
      }
    }
    final preguntaId = observacion.preguntaDelNinoId;
    if (preguntaId != null) {
      final pregunta = _preguntasDelNino[preguntaId];
      if (pregunta != null && pregunta.observacionesIds.contains(id)) {
        final actualizadas = [
          for (final ref in pregunta.observacionesIds)
            if (ref != id) ref,
        ];
        _preguntasDelNino[preguntaId] =
            pregunta.copyWith(observacionesIds: actualizadas);
      }
    }
  }

  @override
  Future<List<Observacion>> obtenerObservaciones({
    int? limite,
    String? misterioId,
    String? preguntaDelNinoId,
    String? sitSpotId,
  }) async {
    var lista = _observaciones.values.where((observacion) {
      if (misterioId != null && observacion.misterioId != misterioId) {
        return false;
      }
      if (preguntaDelNinoId != null &&
          observacion.preguntaDelNinoId != preguntaDelNinoId) {
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
    // Cerrados por el niño se excluyen — pasan al getter dedicado
    // [obtenerMisteriosCerradosPorNino]. La página del Misterio cerrado
    // sigue accesible por id desde anclajes históricos del cuaderno.
    return _misterios.values
        .where((misterio) =>
            misterio.abierto &&
            misterio.estaVigente &&
            !misterio.estaCerradoPorNino)
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
  Future<Misterio?> obtenerMisterioPorId(String id) async {
    return _misterios[id];
  }

  @override
  Future<List<Misterio>> obtenerMisteriosCerradosPorNino() async {
    final cerrados = _misterios.values
        .where((misterio) =>
            misterio.estaCerradoPorNino && misterio.estaVigente)
        .toList()
      ..sort((a, b) => b.cerradoPorNino!.compareTo(a.cerradoPorNino!));
    return cerrados;
  }

  @override
  Future<void> cerrarMisterioParaNino(
    String misterioId,
    String respuesta,
  ) async {
    final misterio = _misterios[misterioId];
    if (misterio == null) {
      throw StateError(
        'no hay misterio con id $misterioId — el catálogo no lo conoce',
      );
    }
    if (misterio.estaCerradoPorNino) {
      throw StateError(
        'el misterio $misterioId ya está cerrado — reábrelo antes',
      );
    }
    if (respuesta.trim().isEmpty) {
      throw ArgumentError.value(
        respuesta,
        'respuesta',
        'cerrar un Misterio exige una respuesta no vacía',
      );
    }
    _misterios[misterioId] = misterio.copyWith(
      cerradoPorNino: DateTime.now(),
      respuestaDelNino: respuesta,
    );
  }

  @override
  Future<void> reabrirMisterioParaNino(String misterioId) async {
    final misterio = _misterios[misterioId];
    if (misterio == null) {
      throw StateError(
        'no hay misterio con id $misterioId — el catálogo no lo conoce',
      );
    }
    if (!misterio.estaCerradoPorNino) return;
    _misterios[misterioId] = misterio.reabiertoPorNino();
  }

  @override
  Future<void> guardarPreguntaDelNino(PreguntaDelNino pregunta) async {
    _preguntasDelNino[pregunta.id] = pregunta;
  }

  @override
  Future<void> anclarObservacionAPregunta(
    String observacionId,
    String preguntaId,
  ) async {
    final observacion = _observaciones[observacionId];
    if (observacion == null) {
      throw StateError(
        'no hay observación con id $observacionId — guárdala antes de anclarla',
      );
    }
    final pregunta = _preguntasDelNino[preguntaId];
    if (pregunta == null) {
      throw StateError(
        'no hay pregunta del niño con id $preguntaId',
      );
    }
    _observaciones[observacionId] =
        observacion.copyWith(preguntaDelNinoId: preguntaId);
    if (!pregunta.observacionesIds.contains(observacionId)) {
      _preguntasDelNino[preguntaId] = pregunta.copyWith(
        observacionesIds: [...pregunta.observacionesIds, observacionId],
      );
    }
  }

  @override
  Future<PreguntaDelNino?> obtenerPreguntaDelNinoPorId(String id) async {
    return _preguntasDelNino[id];
  }

  @override
  Future<List<PreguntaDelNino>> obtenerPreguntasDelNinoAbiertas() async {
    return _preguntasDelNino.values
        .where((pregunta) => !pregunta.estaCerrada)
        .toList()
      ..sort((a, b) => b.formuladaEn.compareTo(a.formuladaEn));
  }

  @override
  Future<List<PreguntaDelNino>> obtenerPreguntasDelNinoCerradas() async {
    return _preguntasDelNino.values
        .where((pregunta) => pregunta.estaCerrada)
        .toList()
      ..sort((a, b) => b.cerradaEn!.compareTo(a.cerradaEn!));
  }

  @override
  Future<void> borrarPreguntaDelNino(String id) async {
    _preguntasDelNino.remove(id);
  }

  @override
  Future<void> cerrarPreguntaDelNino(
    String preguntaId,
    String respuesta,
  ) async {
    final pregunta = _preguntasDelNino[preguntaId];
    if (pregunta == null) {
      throw StateError(
        'no hay pregunta del niño con id $preguntaId',
      );
    }
    if (pregunta.estaCerrada) {
      throw StateError(
        'la pregunta $preguntaId ya está cerrada — reábrela antes',
      );
    }
    if (respuesta.trim().isEmpty) {
      throw ArgumentError.value(
        respuesta,
        'respuesta',
        'cerrar una pregunta exige una respuesta no vacía',
      );
    }
    _preguntasDelNino[preguntaId] = pregunta.copyWith(
      cerradaEn: DateTime.now(),
      respuestaDelNino: respuesta,
    );
  }

  @override
  Future<void> reabrirPreguntaDelNino(String preguntaId) async {
    final pregunta = _preguntasDelNino[preguntaId];
    if (pregunta == null) {
      throw StateError(
        'no hay pregunta del niño con id $preguntaId',
      );
    }
    if (!pregunta.estaCerrada) return;
    _preguntasDelNino[preguntaId] = pregunta.reabiertaPorNino();
  }

  @override
  Future<ResultadoBorrado> borrarTodoLoLocal() async {
    final observacionesAntes = _observaciones.length;
    final misteriosAntes = _misterios.length;
    final preguntasAntes = _preguntasDelNino.length;
    final sitSpotsAntes = _sitSpotsRetirados.length + (_sitSpotActivo == null ? 0 : 1);
    _observaciones.clear();
    _misterios.clear();
    _preguntasDelNino.clear();
    _sitSpotsRetirados.clear();
    _sitSpotActivo = null;
    return ResultadoBorrado(
      observacionesBorradas: observacionesAntes,
      misteriosBorrados: misteriosAntes,
      sitSpotsBorrados: sitSpotsAntes,
      preguntasDelNinoBorradas: preguntasAntes,
    );
  }
}
