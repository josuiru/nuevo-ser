import 'package:isar/isar.dart';

import '../../dominio/misterio.dart';
import '../../dominio/observacion.dart';
import '../../dominio/pregunta_del_nino.dart';
import '../../dominio/repositorio_local.dart';
import '../../dominio/sit_spot.dart';
import 'modelos_isar.dart';

/// Implementación del [RepositorioLocal] sobre Isar Community. La
/// frontera de privacidad del juego (doc 03 §3.3) cae aquí: nada de lo
/// que entra en este repositorio cruza red salvo los metadatos
/// derivados que la capa de sync calculará en Sprint 2.
class RepositorioIsar implements RepositorioLocal {
  RepositorioIsar(this._isar);

  final Isar _isar;

  @override
  Future<void> guardarObservacion(Observacion observacion) async {
    final modelo = ObservacionIsar.desdeDominio(observacion);
    // Si ya existía un registro con el mismo idDominio, el índice
    // único con replace lo sustituye preservando isarId.
    final existente = await _isar.observacionIsars
        .where()
        .idDominioEqualTo(observacion.id)
        .findFirst();
    if (existente != null) {
      modelo.isarId = existente.isarId;
    }
    await _isar.writeTxn(() async {
      await _isar.observacionIsars.put(modelo);
    });
  }

  @override
  Future<Observacion?> obtenerObservacionPorId(String id) async {
    final modelo = await _isar.observacionIsars
        .where()
        .idDominioEqualTo(id)
        .findFirst();
    return modelo?.aDominio();
  }

  @override
  Future<void> borrarObservacion(String id) async {
    await _isar.writeTxn(() async {
      final observacionModelo = await _isar.observacionIsars
          .where()
          .idDominioEqualTo(id)
          .findFirst();
      if (observacionModelo == null) return;
      final misterioId = observacionModelo.misterioId;
      final preguntaId = observacionModelo.preguntaDelNinoId;
      await _isar.observacionIsars.delete(observacionModelo.isarId);
      if (misterioId != null) {
        final misterioModelo = await _isar.misterioIsars
            .where()
            .idDominioEqualTo(misterioId)
            .findFirst();
        if (misterioModelo != null &&
            misterioModelo.observacionesIds.contains(id)) {
          misterioModelo.observacionesIds = [
            for (final ref in misterioModelo.observacionesIds)
              if (ref != id) ref,
          ];
          await _isar.misterioIsars.put(misterioModelo);
        }
      }
      if (preguntaId != null) {
        final preguntaModelo = await _isar.preguntaDelNinoIsars
            .where()
            .idDominioEqualTo(preguntaId)
            .findFirst();
        if (preguntaModelo != null &&
            preguntaModelo.observacionesIds.contains(id)) {
          preguntaModelo.observacionesIds = [
            for (final ref in preguntaModelo.observacionesIds)
              if (ref != id) ref,
          ];
          await _isar.preguntaDelNinoIsars.put(preguntaModelo);
        }
      }
    });
  }

  @override
  Future<List<Observacion>> obtenerObservaciones({
    int? limite,
    String? misterioId,
    String? preguntaDelNinoId,
    String? sitSpotId,
  }) async {
    QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
        filtro = _isar.observacionIsars.filter().idDominioIsNotEmpty();

    if (misterioId != null) {
      filtro = filtro.misterioIdEqualTo(misterioId);
    }
    if (preguntaDelNinoId != null) {
      filtro = filtro.preguntaDelNinoIdEqualTo(preguntaDelNinoId);
    }
    if (sitSpotId != null) {
      filtro = filtro.sitSpotIdEqualTo(sitSpotId);
    }

    final ordenada = filtro.sortByCuandoOcurrioDesc().thenByIdDominio();
    final consulta = limite == null ? ordenada : ordenada.limit(limite);
    final modelos = await consulta.findAll();
    return [for (final modelo in modelos) modelo.aDominio()];
  }

  @override
  Future<SitSpot?> obtenerSitSpot() async {
    // El MVP solo permite un sit spot activo (biblia §5.1). Filtramos
    // por `retiradoEn == null` y devolvemos el primero — si por alguna
    // razón hubiera más de uno activo (no debería), gana el más
    // reciente.
    final modelo = await _isar.sitSpotIsars
        .filter()
        .retiradoEnIsNull()
        .sortByCreadoEnDesc()
        .findFirst();
    return modelo?.aDominio();
  }

  @override
  Future<void> establecerSitSpot(SitSpot sitSpot) async {
    final actual = await obtenerSitSpot();
    final esCambio = actual != null && actual.id != sitSpot.id;

    await _isar.writeTxn(() async {
      if (esCambio) {
        // Jubilar al anterior — doc 13 §2.6: "El Roble Grande seguirá
        // en tu cuaderno como página".
        final anteriorModelo = await _isar.sitSpotIsars
            .where()
            .idDominioEqualTo(actual.id)
            .findFirst();
        if (anteriorModelo != null) {
          anteriorModelo.retiradoEn = DateTime.now();
          await _isar.sitSpotIsars.put(anteriorModelo);
        }
      }

      final nuevoModelo = SitSpotIsar.desdeDominio(sitSpot);
      final existente = await _isar.sitSpotIsars
          .where()
          .idDominioEqualTo(sitSpot.id)
          .findFirst();
      if (existente != null) {
        nuevoModelo.isarId = existente.isarId;
      }
      await _isar.sitSpotIsars.put(nuevoModelo);
    });
  }

  @override
  Future<List<SitSpot>> obtenerSitSpotsJubilados() async {
    final modelos = await _isar.sitSpotIsars
        .filter()
        .retiradoEnIsNotNull()
        .sortByRetiradoEnDesc()
        .findAll();
    return [for (final modelo in modelos) modelo.aDominio()];
  }

  @override
  Future<List<Misterio>> obtenerMisteriosAbiertos() async {
    final modelos = await _isar.misterioIsars
        .filter()
        .abiertoEqualTo(true)
        .and()
        .retiradoEnIsNull()
        .and()
        .cerradoPorNinoIsNull()
        .sortByPregunta()
        .findAll();
    return [for (final modelo in modelos) modelo.aDominio()];
  }

  @override
  Future<void> anclarObservacionAMisterio(
    String observacionId,
    String misterioId,
  ) async {
    await _isar.writeTxn(() async {
      final observacionModelo = await _isar.observacionIsars
          .where()
          .idDominioEqualTo(observacionId)
          .findFirst();
      if (observacionModelo == null) {
        throw StateError(
          'no hay observación con id $observacionId — '
          'guárdala antes de anclarla',
        );
      }
      observacionModelo.misterioId = misterioId;
      await _isar.observacionIsars.put(observacionModelo);

      final misterioModelo = await _isar.misterioIsars
          .where()
          .idDominioEqualTo(misterioId)
          .findFirst();
      if (misterioModelo == null) {
        throw StateError(
          'no hay misterio con id $misterioId — el catálogo no lo conoce',
        );
      }
      if (!misterioModelo.observacionesIds.contains(observacionId)) {
        misterioModelo.observacionesIds = [
          ...misterioModelo.observacionesIds,
          observacionId,
        ];
        await _isar.misterioIsars.put(misterioModelo);
      }
    });
  }

  @override
  Future<ResultadoBorrado> borrarTodoLoLocal() async {
    final observacionesAntes = await _isar.observacionIsars.count();
    final misteriosAntes = await _isar.misterioIsars.count();
    final sitSpotsAntes = await _isar.sitSpotIsars.count();
    final preguntasAntes = await _isar.preguntaDelNinoIsars.count();
    await _isar.writeTxn(() async {
      await _isar.observacionIsars.clear();
      await _isar.misterioIsars.clear();
      await _isar.sitSpotIsars.clear();
      await _isar.preguntaDelNinoIsars.clear();
    });
    return ResultadoBorrado(
      observacionesBorradas: observacionesAntes,
      misteriosBorrados: misteriosAntes,
      sitSpotsBorrados: sitSpotsAntes,
      preguntasDelNinoBorradas: preguntasAntes,
    );
  }

  @override
  Future<void> guardarPreguntaDelNino(PreguntaDelNino pregunta) async {
    final modelo = PreguntaDelNinoIsar.desdeDominio(pregunta);
    final existente = await _isar.preguntaDelNinoIsars
        .where()
        .idDominioEqualTo(pregunta.id)
        .findFirst();
    if (existente != null) {
      modelo.isarId = existente.isarId;
    }
    await _isar.writeTxn(() async {
      await _isar.preguntaDelNinoIsars.put(modelo);
    });
  }

  @override
  Future<void> anclarObservacionAPregunta(
    String observacionId,
    String preguntaId,
  ) async {
    await _isar.writeTxn(() async {
      final observacionModelo = await _isar.observacionIsars
          .where()
          .idDominioEqualTo(observacionId)
          .findFirst();
      if (observacionModelo == null) {
        throw StateError(
          'no hay observación con id $observacionId — '
          'guárdala antes de anclarla',
        );
      }
      final preguntaModelo = await _isar.preguntaDelNinoIsars
          .where()
          .idDominioEqualTo(preguntaId)
          .findFirst();
      if (preguntaModelo == null) {
        throw StateError(
          'no hay pregunta del niño con id $preguntaId',
        );
      }
      observacionModelo.preguntaDelNinoId = preguntaId;
      await _isar.observacionIsars.put(observacionModelo);
      if (!preguntaModelo.observacionesIds.contains(observacionId)) {
        preguntaModelo.observacionesIds = [
          ...preguntaModelo.observacionesIds,
          observacionId,
        ];
        await _isar.preguntaDelNinoIsars.put(preguntaModelo);
      }
    });
  }

  @override
  Future<PreguntaDelNino?> obtenerPreguntaDelNinoPorId(String id) async {
    final modelo = await _isar.preguntaDelNinoIsars
        .where()
        .idDominioEqualTo(id)
        .findFirst();
    return modelo?.aDominio();
  }

  @override
  Future<List<PreguntaDelNino>> obtenerPreguntasDelNinoAbiertas() async {
    final modelos = await _isar.preguntaDelNinoIsars
        .filter()
        .cerradaEnIsNull()
        .sortByFormuladaEnDesc()
        .findAll();
    return [for (final modelo in modelos) modelo.aDominio()];
  }

  @override
  Future<List<PreguntaDelNino>> obtenerPreguntasDelNinoCerradas() async {
    final modelos = await _isar.preguntaDelNinoIsars
        .filter()
        .cerradaEnIsNotNull()
        .sortByCerradaEnDesc()
        .findAll();
    return [for (final modelo in modelos) modelo.aDominio()];
  }

  @override
  Future<void> borrarPreguntaDelNino(String id) async {
    await _isar.writeTxn(() async {
      final modelo = await _isar.preguntaDelNinoIsars
          .where()
          .idDominioEqualTo(id)
          .findFirst();
      if (modelo == null) return;
      await _isar.preguntaDelNinoIsars.delete(modelo.isarId);
    });
  }

  @override
  Future<void> cerrarPreguntaDelNino(
    String preguntaId,
    String respuesta,
  ) async {
    if (respuesta.trim().isEmpty) {
      throw ArgumentError.value(
        respuesta,
        'respuesta',
        'cerrar una pregunta exige una respuesta no vacía',
      );
    }
    await _isar.writeTxn(() async {
      final modelo = await _isar.preguntaDelNinoIsars
          .where()
          .idDominioEqualTo(preguntaId)
          .findFirst();
      if (modelo == null) {
        throw StateError('no hay pregunta del niño con id $preguntaId');
      }
      if (modelo.cerradaEn != null) {
        throw StateError(
          'la pregunta $preguntaId ya está cerrada — reábrela antes',
        );
      }
      modelo
        ..cerradaEn = DateTime.now()
        ..respuestaDelNino = respuesta;
      await _isar.preguntaDelNinoIsars.put(modelo);
    });
  }

  @override
  Future<void> reabrirPreguntaDelNino(String preguntaId) async {
    await _isar.writeTxn(() async {
      final modelo = await _isar.preguntaDelNinoIsars
          .where()
          .idDominioEqualTo(preguntaId)
          .findFirst();
      if (modelo == null) {
        throw StateError('no hay pregunta del niño con id $preguntaId');
      }
      if (modelo.cerradaEn == null) return;
      modelo
        ..cerradaEn = null
        ..respuestaDelNino = null;
      await _isar.preguntaDelNinoIsars.put(modelo);
    });
  }

  /// Persiste un Misterio del catálogo. No es parte de la interfaz del
  /// dominio porque el niño no debería poder crear Misterios — los
  /// trae el seed o, eventualmente, el catálogo del backend (Sprint
  /// 2). Lo exponemos aquí para que el seed lo use.
  Future<void> guardarMisterio(Misterio misterio) async {
    final modelo = MisterioIsar.desdeDominio(misterio);
    final existente = await _isar.misterioIsars
        .where()
        .idDominioEqualTo(misterio.id)
        .findFirst();
    if (existente != null) {
      modelo.isarId = existente.isarId;
    }
    await _isar.writeTxn(() async {
      await _isar.misterioIsars.put(modelo);
    });
  }

  @override
  Future<Misterio?> obtenerMisterioPorId(String id) async {
    final modelo = await _isar.misterioIsars
        .where()
        .idDominioEqualTo(id)
        .findFirst();
    return modelo?.aDominio();
  }

  @override
  Future<List<Misterio>> obtenerMisteriosCerradosPorNino() async {
    final modelos = await _isar.misterioIsars
        .filter()
        .cerradoPorNinoIsNotNull()
        .and()
        .retiradoEnIsNull()
        .sortByCerradoPorNinoDesc()
        .findAll();
    return [for (final modelo in modelos) modelo.aDominio()];
  }

  @override
  Future<void> cerrarMisterioParaNino(
    String misterioId,
    String respuesta,
  ) async {
    if (respuesta.trim().isEmpty) {
      throw ArgumentError.value(
        respuesta,
        'respuesta',
        'cerrar un Misterio exige una respuesta no vacía',
      );
    }
    await _isar.writeTxn(() async {
      final modelo = await _isar.misterioIsars
          .where()
          .idDominioEqualTo(misterioId)
          .findFirst();
      if (modelo == null) {
        throw StateError(
          'no hay misterio con id $misterioId — el catálogo no lo conoce',
        );
      }
      if (modelo.cerradoPorNino != null) {
        throw StateError(
          'el misterio $misterioId ya está cerrado — reábrelo antes',
        );
      }
      modelo
        ..cerradoPorNino = DateTime.now()
        ..respuestaDelNino = respuesta;
      await _isar.misterioIsars.put(modelo);
    });
  }

  @override
  Future<void> reabrirMisterioParaNino(String misterioId) async {
    await _isar.writeTxn(() async {
      final modelo = await _isar.misterioIsars
          .where()
          .idDominioEqualTo(misterioId)
          .findFirst();
      if (modelo == null) {
        throw StateError(
          'no hay misterio con id $misterioId — el catálogo no lo conoce',
        );
      }
      if (modelo.cerradoPorNino == null) return;
      modelo
        ..cerradoPorNino = null
        ..respuestaDelNino = null;
      await _isar.misterioIsars.put(modelo);
    });
  }
}
