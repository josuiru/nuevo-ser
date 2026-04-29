import 'package:isar/isar.dart';

import '../../dominio/misterio.dart';
import '../../dominio/observacion.dart';
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
  Future<List<Observacion>> obtenerObservaciones({
    int? limite,
    String? misterioId,
    String? sitSpotId,
  }) async {
    QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
        filtro = _isar.observacionIsars.filter().idDominioIsNotEmpty();

    if (misterioId != null) {
      filtro = filtro.misterioIdEqualTo(misterioId);
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
  Future<List<Misterio>> obtenerMisteriosAbiertos() async {
    final modelos = await _isar.misterioIsars
        .filter()
        .abiertoEqualTo(true)
        .and()
        .retiradoEnIsNull()
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
}
