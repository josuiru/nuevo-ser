// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'modelos_isar.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetObservacionIsarCollection on Isar {
  IsarCollection<ObservacionIsar> get observacionIsars => this.collection();
}

const ObservacionIsarSchema = CollectionSchema(
  name: r'ObservacionIsar',
  id: -2685611179366986368,
  properties: {
    r'climaResumen': PropertySchema(
      id: 0,
      name: r'climaResumen',
      type: IsarType.string,
    ),
    r'confianza': PropertySchema(
      id: 1,
      name: r'confianza',
      type: IsarType.string,
      enumMap: _ObservacionIsarconfianzaEnumValueMap,
    ),
    r'creesQueEs': PropertySchema(
      id: 2,
      name: r'creesQueEs',
      type: IsarType.string,
    ),
    r'cuandoCreada': PropertySchema(
      id: 3,
      name: r'cuandoCreada',
      type: IsarType.dateTime,
    ),
    r'cuandoOcurrio': PropertySchema(
      id: 4,
      name: r'cuandoOcurrio',
      type: IsarType.dateTime,
    ),
    r'dibujoRutaLocal': PropertySchema(
      id: 5,
      name: r'dibujoRutaLocal',
      type: IsarType.string,
    ),
    r'dondeNombre': PropertySchema(
      id: 6,
      name: r'dondeNombre',
      type: IsarType.string,
    ),
    r'fotoRutaLocal': PropertySchema(
      id: 7,
      name: r'fotoRutaLocal',
      type: IsarType.string,
    ),
    r'idDominio': PropertySchema(
      id: 8,
      name: r'idDominio',
      type: IsarType.string,
    ),
    r'lat': PropertySchema(
      id: 9,
      name: r'lat',
      type: IsarType.double,
    ),
    r'lng': PropertySchema(
      id: 10,
      name: r'lng',
      type: IsarType.double,
    ),
    r'misterioId': PropertySchema(
      id: 11,
      name: r'misterioId',
      type: IsarType.string,
    ),
    r'queVio': PropertySchema(
      id: 12,
      name: r'queVio',
      type: IsarType.string,
    ),
    r'sitSpotId': PropertySchema(
      id: 13,
      name: r'sitSpotId',
      type: IsarType.string,
    )
  },
  estimateSize: _observacionIsarEstimateSize,
  serialize: _observacionIsarSerialize,
  deserialize: _observacionIsarDeserialize,
  deserializeProp: _observacionIsarDeserializeProp,
  idName: r'isarId',
  indexes: {
    r'idDominio': IndexSchema(
      id: -3608782195166194351,
      name: r'idDominio',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'idDominio',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'misterioId': IndexSchema(
      id: -8474190193655836613,
      name: r'misterioId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'misterioId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'sitSpotId': IndexSchema(
      id: -407612385685829273,
      name: r'sitSpotId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'sitSpotId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _observacionIsarGetId,
  getLinks: _observacionIsarGetLinks,
  attach: _observacionIsarAttach,
  version: '3.1.0+1',
);

int _observacionIsarEstimateSize(
  ObservacionIsar object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.climaResumen;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.confianza.name.length * 3;
  {
    final value = object.creesQueEs;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.dibujoRutaLocal;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.dondeNombre.length * 3;
  {
    final value = object.fotoRutaLocal;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.idDominio.length * 3;
  {
    final value = object.misterioId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.queVio.length * 3;
  {
    final value = object.sitSpotId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _observacionIsarSerialize(
  ObservacionIsar object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.climaResumen);
  writer.writeString(offsets[1], object.confianza.name);
  writer.writeString(offsets[2], object.creesQueEs);
  writer.writeDateTime(offsets[3], object.cuandoCreada);
  writer.writeDateTime(offsets[4], object.cuandoOcurrio);
  writer.writeString(offsets[5], object.dibujoRutaLocal);
  writer.writeString(offsets[6], object.dondeNombre);
  writer.writeString(offsets[7], object.fotoRutaLocal);
  writer.writeString(offsets[8], object.idDominio);
  writer.writeDouble(offsets[9], object.lat);
  writer.writeDouble(offsets[10], object.lng);
  writer.writeString(offsets[11], object.misterioId);
  writer.writeString(offsets[12], object.queVio);
  writer.writeString(offsets[13], object.sitSpotId);
}

ObservacionIsar _observacionIsarDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ObservacionIsar();
  object.climaResumen = reader.readStringOrNull(offsets[0]);
  object.confianza = _ObservacionIsarconfianzaValueEnumMap[
          reader.readStringOrNull(offsets[1])] ??
      NivelConfianzaIsar.consenso;
  object.creesQueEs = reader.readStringOrNull(offsets[2]);
  object.cuandoCreada = reader.readDateTime(offsets[3]);
  object.cuandoOcurrio = reader.readDateTime(offsets[4]);
  object.dibujoRutaLocal = reader.readStringOrNull(offsets[5]);
  object.dondeNombre = reader.readString(offsets[6]);
  object.fotoRutaLocal = reader.readStringOrNull(offsets[7]);
  object.idDominio = reader.readString(offsets[8]);
  object.isarId = id;
  object.lat = reader.readDoubleOrNull(offsets[9]);
  object.lng = reader.readDoubleOrNull(offsets[10]);
  object.misterioId = reader.readStringOrNull(offsets[11]);
  object.queVio = reader.readString(offsets[12]);
  object.sitSpotId = reader.readStringOrNull(offsets[13]);
  return object;
}

P _observacionIsarDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (_ObservacionIsarconfianzaValueEnumMap[
              reader.readStringOrNull(offset)] ??
          NivelConfianzaIsar.consenso) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readDateTime(offset)) as P;
    case 4:
      return (reader.readDateTime(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readStringOrNull(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readDoubleOrNull(offset)) as P;
    case 10:
      return (reader.readDoubleOrNull(offset)) as P;
    case 11:
      return (reader.readStringOrNull(offset)) as P;
    case 12:
      return (reader.readString(offset)) as P;
    case 13:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _ObservacionIsarconfianzaEnumValueMap = {
  r'consenso': r'consenso',
  r'hipotesisActiva': r'hipotesisActiva',
  r'abandonado': r'abandonado',
  r'noSegura': r'noSegura',
};
const _ObservacionIsarconfianzaValueEnumMap = {
  r'consenso': NivelConfianzaIsar.consenso,
  r'hipotesisActiva': NivelConfianzaIsar.hipotesisActiva,
  r'abandonado': NivelConfianzaIsar.abandonado,
  r'noSegura': NivelConfianzaIsar.noSegura,
};

Id _observacionIsarGetId(ObservacionIsar object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _observacionIsarGetLinks(ObservacionIsar object) {
  return [];
}

void _observacionIsarAttach(
    IsarCollection<dynamic> col, Id id, ObservacionIsar object) {
  object.isarId = id;
}

extension ObservacionIsarByIndex on IsarCollection<ObservacionIsar> {
  Future<ObservacionIsar?> getByIdDominio(String idDominio) {
    return getByIndex(r'idDominio', [idDominio]);
  }

  ObservacionIsar? getByIdDominioSync(String idDominio) {
    return getByIndexSync(r'idDominio', [idDominio]);
  }

  Future<bool> deleteByIdDominio(String idDominio) {
    return deleteByIndex(r'idDominio', [idDominio]);
  }

  bool deleteByIdDominioSync(String idDominio) {
    return deleteByIndexSync(r'idDominio', [idDominio]);
  }

  Future<List<ObservacionIsar?>> getAllByIdDominio(
      List<String> idDominioValues) {
    final values = idDominioValues.map((e) => [e]).toList();
    return getAllByIndex(r'idDominio', values);
  }

  List<ObservacionIsar?> getAllByIdDominioSync(List<String> idDominioValues) {
    final values = idDominioValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'idDominio', values);
  }

  Future<int> deleteAllByIdDominio(List<String> idDominioValues) {
    final values = idDominioValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'idDominio', values);
  }

  int deleteAllByIdDominioSync(List<String> idDominioValues) {
    final values = idDominioValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'idDominio', values);
  }

  Future<Id> putByIdDominio(ObservacionIsar object) {
    return putByIndex(r'idDominio', object);
  }

  Id putByIdDominioSync(ObservacionIsar object, {bool saveLinks = true}) {
    return putByIndexSync(r'idDominio', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByIdDominio(List<ObservacionIsar> objects) {
    return putAllByIndex(r'idDominio', objects);
  }

  List<Id> putAllByIdDominioSync(List<ObservacionIsar> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'idDominio', objects, saveLinks: saveLinks);
  }
}

extension ObservacionIsarQueryWhereSort
    on QueryBuilder<ObservacionIsar, ObservacionIsar, QWhere> {
  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterWhere> anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ObservacionIsarQueryWhere
    on QueryBuilder<ObservacionIsar, ObservacionIsar, QWhereClause> {
  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterWhereClause>
      isarIdEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterWhereClause>
      isarIdNotEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterWhereClause>
      isarIdGreaterThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterWhereClause>
      isarIdLessThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterWhereClause>
      isarIdBetween(
    Id lowerIsarId,
    Id upperIsarId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerIsarId,
        includeLower: includeLower,
        upper: upperIsarId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterWhereClause>
      idDominioEqualTo(String idDominio) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'idDominio',
        value: [idDominio],
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterWhereClause>
      idDominioNotEqualTo(String idDominio) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'idDominio',
              lower: [],
              upper: [idDominio],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'idDominio',
              lower: [idDominio],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'idDominio',
              lower: [idDominio],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'idDominio',
              lower: [],
              upper: [idDominio],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterWhereClause>
      misterioIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'misterioId',
        value: [null],
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterWhereClause>
      misterioIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'misterioId',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterWhereClause>
      misterioIdEqualTo(String? misterioId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'misterioId',
        value: [misterioId],
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterWhereClause>
      misterioIdNotEqualTo(String? misterioId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'misterioId',
              lower: [],
              upper: [misterioId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'misterioId',
              lower: [misterioId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'misterioId',
              lower: [misterioId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'misterioId',
              lower: [],
              upper: [misterioId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterWhereClause>
      sitSpotIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'sitSpotId',
        value: [null],
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterWhereClause>
      sitSpotIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'sitSpotId',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterWhereClause>
      sitSpotIdEqualTo(String? sitSpotId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'sitSpotId',
        value: [sitSpotId],
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterWhereClause>
      sitSpotIdNotEqualTo(String? sitSpotId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sitSpotId',
              lower: [],
              upper: [sitSpotId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sitSpotId',
              lower: [sitSpotId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sitSpotId',
              lower: [sitSpotId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sitSpotId',
              lower: [],
              upper: [sitSpotId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension ObservacionIsarQueryFilter
    on QueryBuilder<ObservacionIsar, ObservacionIsar, QFilterCondition> {
  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      climaResumenIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'climaResumen',
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      climaResumenIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'climaResumen',
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      climaResumenEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'climaResumen',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      climaResumenGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'climaResumen',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      climaResumenLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'climaResumen',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      climaResumenBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'climaResumen',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      climaResumenStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'climaResumen',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      climaResumenEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'climaResumen',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      climaResumenContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'climaResumen',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      climaResumenMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'climaResumen',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      climaResumenIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'climaResumen',
        value: '',
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      climaResumenIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'climaResumen',
        value: '',
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      confianzaEqualTo(
    NivelConfianzaIsar value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'confianza',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      confianzaGreaterThan(
    NivelConfianzaIsar value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'confianza',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      confianzaLessThan(
    NivelConfianzaIsar value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'confianza',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      confianzaBetween(
    NivelConfianzaIsar lower,
    NivelConfianzaIsar upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'confianza',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      confianzaStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'confianza',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      confianzaEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'confianza',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      confianzaContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'confianza',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      confianzaMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'confianza',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      confianzaIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'confianza',
        value: '',
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      confianzaIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'confianza',
        value: '',
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      creesQueEsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'creesQueEs',
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      creesQueEsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'creesQueEs',
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      creesQueEsEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'creesQueEs',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      creesQueEsGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'creesQueEs',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      creesQueEsLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'creesQueEs',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      creesQueEsBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'creesQueEs',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      creesQueEsStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'creesQueEs',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      creesQueEsEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'creesQueEs',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      creesQueEsContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'creesQueEs',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      creesQueEsMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'creesQueEs',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      creesQueEsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'creesQueEs',
        value: '',
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      creesQueEsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'creesQueEs',
        value: '',
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      cuandoCreadaEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cuandoCreada',
        value: value,
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      cuandoCreadaGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'cuandoCreada',
        value: value,
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      cuandoCreadaLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'cuandoCreada',
        value: value,
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      cuandoCreadaBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'cuandoCreada',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      cuandoOcurrioEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cuandoOcurrio',
        value: value,
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      cuandoOcurrioGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'cuandoOcurrio',
        value: value,
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      cuandoOcurrioLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'cuandoOcurrio',
        value: value,
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      cuandoOcurrioBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'cuandoOcurrio',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      dibujoRutaLocalIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'dibujoRutaLocal',
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      dibujoRutaLocalIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'dibujoRutaLocal',
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      dibujoRutaLocalEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dibujoRutaLocal',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      dibujoRutaLocalGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dibujoRutaLocal',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      dibujoRutaLocalLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dibujoRutaLocal',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      dibujoRutaLocalBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dibujoRutaLocal',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      dibujoRutaLocalStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'dibujoRutaLocal',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      dibujoRutaLocalEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'dibujoRutaLocal',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      dibujoRutaLocalContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'dibujoRutaLocal',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      dibujoRutaLocalMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'dibujoRutaLocal',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      dibujoRutaLocalIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dibujoRutaLocal',
        value: '',
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      dibujoRutaLocalIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'dibujoRutaLocal',
        value: '',
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      dondeNombreEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dondeNombre',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      dondeNombreGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dondeNombre',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      dondeNombreLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dondeNombre',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      dondeNombreBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dondeNombre',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      dondeNombreStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'dondeNombre',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      dondeNombreEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'dondeNombre',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      dondeNombreContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'dondeNombre',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      dondeNombreMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'dondeNombre',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      dondeNombreIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dondeNombre',
        value: '',
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      dondeNombreIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'dondeNombre',
        value: '',
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      fotoRutaLocalIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'fotoRutaLocal',
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      fotoRutaLocalIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'fotoRutaLocal',
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      fotoRutaLocalEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fotoRutaLocal',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      fotoRutaLocalGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'fotoRutaLocal',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      fotoRutaLocalLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'fotoRutaLocal',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      fotoRutaLocalBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'fotoRutaLocal',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      fotoRutaLocalStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'fotoRutaLocal',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      fotoRutaLocalEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'fotoRutaLocal',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      fotoRutaLocalContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'fotoRutaLocal',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      fotoRutaLocalMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'fotoRutaLocal',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      fotoRutaLocalIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fotoRutaLocal',
        value: '',
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      fotoRutaLocalIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'fotoRutaLocal',
        value: '',
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      idDominioEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'idDominio',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      idDominioGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'idDominio',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      idDominioLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'idDominio',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      idDominioBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'idDominio',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      idDominioStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'idDominio',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      idDominioEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'idDominio',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      idDominioContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'idDominio',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      idDominioMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'idDominio',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      idDominioIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'idDominio',
        value: '',
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      idDominioIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'idDominio',
        value: '',
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      isarIdEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      isarIdGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      isarIdLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      isarIdBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'isarId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      latIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lat',
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      latIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lat',
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      latEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lat',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      latGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lat',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      latLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lat',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      latBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lat',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      lngIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lng',
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      lngIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lng',
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      lngEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lng',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      lngGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lng',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      lngLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lng',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      lngBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lng',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      misterioIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'misterioId',
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      misterioIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'misterioId',
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      misterioIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'misterioId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      misterioIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'misterioId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      misterioIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'misterioId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      misterioIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'misterioId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      misterioIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'misterioId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      misterioIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'misterioId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      misterioIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'misterioId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      misterioIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'misterioId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      misterioIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'misterioId',
        value: '',
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      misterioIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'misterioId',
        value: '',
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      queVioEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'queVio',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      queVioGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'queVio',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      queVioLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'queVio',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      queVioBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'queVio',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      queVioStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'queVio',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      queVioEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'queVio',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      queVioContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'queVio',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      queVioMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'queVio',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      queVioIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'queVio',
        value: '',
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      queVioIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'queVio',
        value: '',
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      sitSpotIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'sitSpotId',
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      sitSpotIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'sitSpotId',
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      sitSpotIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sitSpotId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      sitSpotIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sitSpotId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      sitSpotIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sitSpotId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      sitSpotIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sitSpotId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      sitSpotIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'sitSpotId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      sitSpotIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'sitSpotId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      sitSpotIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'sitSpotId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      sitSpotIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'sitSpotId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      sitSpotIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sitSpotId',
        value: '',
      ));
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterFilterCondition>
      sitSpotIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'sitSpotId',
        value: '',
      ));
    });
  }
}

extension ObservacionIsarQueryObject
    on QueryBuilder<ObservacionIsar, ObservacionIsar, QFilterCondition> {}

extension ObservacionIsarQueryLinks
    on QueryBuilder<ObservacionIsar, ObservacionIsar, QFilterCondition> {}

extension ObservacionIsarQuerySortBy
    on QueryBuilder<ObservacionIsar, ObservacionIsar, QSortBy> {
  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterSortBy>
      sortByClimaResumen() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'climaResumen', Sort.asc);
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterSortBy>
      sortByClimaResumenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'climaResumen', Sort.desc);
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterSortBy>
      sortByConfianza() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'confianza', Sort.asc);
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterSortBy>
      sortByConfianzaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'confianza', Sort.desc);
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterSortBy>
      sortByCreesQueEs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'creesQueEs', Sort.asc);
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterSortBy>
      sortByCreesQueEsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'creesQueEs', Sort.desc);
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterSortBy>
      sortByCuandoCreada() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cuandoCreada', Sort.asc);
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterSortBy>
      sortByCuandoCreadaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cuandoCreada', Sort.desc);
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterSortBy>
      sortByCuandoOcurrio() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cuandoOcurrio', Sort.asc);
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterSortBy>
      sortByCuandoOcurrioDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cuandoOcurrio', Sort.desc);
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterSortBy>
      sortByDibujoRutaLocal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dibujoRutaLocal', Sort.asc);
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterSortBy>
      sortByDibujoRutaLocalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dibujoRutaLocal', Sort.desc);
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterSortBy>
      sortByDondeNombre() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dondeNombre', Sort.asc);
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterSortBy>
      sortByDondeNombreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dondeNombre', Sort.desc);
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterSortBy>
      sortByFotoRutaLocal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fotoRutaLocal', Sort.asc);
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterSortBy>
      sortByFotoRutaLocalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fotoRutaLocal', Sort.desc);
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterSortBy>
      sortByIdDominio() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idDominio', Sort.asc);
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterSortBy>
      sortByIdDominioDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idDominio', Sort.desc);
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterSortBy> sortByLat() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lat', Sort.asc);
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterSortBy> sortByLatDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lat', Sort.desc);
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterSortBy> sortByLng() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lng', Sort.asc);
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterSortBy> sortByLngDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lng', Sort.desc);
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterSortBy>
      sortByMisterioId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'misterioId', Sort.asc);
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterSortBy>
      sortByMisterioIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'misterioId', Sort.desc);
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterSortBy> sortByQueVio() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'queVio', Sort.asc);
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterSortBy>
      sortByQueVioDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'queVio', Sort.desc);
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterSortBy>
      sortBySitSpotId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sitSpotId', Sort.asc);
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterSortBy>
      sortBySitSpotIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sitSpotId', Sort.desc);
    });
  }
}

extension ObservacionIsarQuerySortThenBy
    on QueryBuilder<ObservacionIsar, ObservacionIsar, QSortThenBy> {
  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterSortBy>
      thenByClimaResumen() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'climaResumen', Sort.asc);
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterSortBy>
      thenByClimaResumenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'climaResumen', Sort.desc);
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterSortBy>
      thenByConfianza() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'confianza', Sort.asc);
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterSortBy>
      thenByConfianzaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'confianza', Sort.desc);
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterSortBy>
      thenByCreesQueEs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'creesQueEs', Sort.asc);
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterSortBy>
      thenByCreesQueEsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'creesQueEs', Sort.desc);
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterSortBy>
      thenByCuandoCreada() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cuandoCreada', Sort.asc);
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterSortBy>
      thenByCuandoCreadaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cuandoCreada', Sort.desc);
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterSortBy>
      thenByCuandoOcurrio() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cuandoOcurrio', Sort.asc);
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterSortBy>
      thenByCuandoOcurrioDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cuandoOcurrio', Sort.desc);
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterSortBy>
      thenByDibujoRutaLocal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dibujoRutaLocal', Sort.asc);
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterSortBy>
      thenByDibujoRutaLocalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dibujoRutaLocal', Sort.desc);
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterSortBy>
      thenByDondeNombre() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dondeNombre', Sort.asc);
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterSortBy>
      thenByDondeNombreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dondeNombre', Sort.desc);
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterSortBy>
      thenByFotoRutaLocal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fotoRutaLocal', Sort.asc);
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterSortBy>
      thenByFotoRutaLocalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fotoRutaLocal', Sort.desc);
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterSortBy>
      thenByIdDominio() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idDominio', Sort.asc);
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterSortBy>
      thenByIdDominioDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idDominio', Sort.desc);
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterSortBy> thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterSortBy>
      thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterSortBy> thenByLat() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lat', Sort.asc);
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterSortBy> thenByLatDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lat', Sort.desc);
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterSortBy> thenByLng() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lng', Sort.asc);
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterSortBy> thenByLngDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lng', Sort.desc);
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterSortBy>
      thenByMisterioId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'misterioId', Sort.asc);
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterSortBy>
      thenByMisterioIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'misterioId', Sort.desc);
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterSortBy> thenByQueVio() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'queVio', Sort.asc);
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterSortBy>
      thenByQueVioDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'queVio', Sort.desc);
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterSortBy>
      thenBySitSpotId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sitSpotId', Sort.asc);
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QAfterSortBy>
      thenBySitSpotIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sitSpotId', Sort.desc);
    });
  }
}

extension ObservacionIsarQueryWhereDistinct
    on QueryBuilder<ObservacionIsar, ObservacionIsar, QDistinct> {
  QueryBuilder<ObservacionIsar, ObservacionIsar, QDistinct>
      distinctByClimaResumen({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'climaResumen', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QDistinct> distinctByConfianza(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'confianza', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QDistinct>
      distinctByCreesQueEs({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'creesQueEs', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QDistinct>
      distinctByCuandoCreada() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cuandoCreada');
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QDistinct>
      distinctByCuandoOcurrio() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cuandoOcurrio');
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QDistinct>
      distinctByDibujoRutaLocal({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dibujoRutaLocal',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QDistinct>
      distinctByDondeNombre({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dondeNombre', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QDistinct>
      distinctByFotoRutaLocal({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fotoRutaLocal',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QDistinct> distinctByIdDominio(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'idDominio', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QDistinct> distinctByLat() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lat');
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QDistinct> distinctByLng() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lng');
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QDistinct>
      distinctByMisterioId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'misterioId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QDistinct> distinctByQueVio(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'queVio', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ObservacionIsar, ObservacionIsar, QDistinct> distinctBySitSpotId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sitSpotId', caseSensitive: caseSensitive);
    });
  }
}

extension ObservacionIsarQueryProperty
    on QueryBuilder<ObservacionIsar, ObservacionIsar, QQueryProperty> {
  QueryBuilder<ObservacionIsar, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<ObservacionIsar, String?, QQueryOperations>
      climaResumenProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'climaResumen');
    });
  }

  QueryBuilder<ObservacionIsar, NivelConfianzaIsar, QQueryOperations>
      confianzaProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'confianza');
    });
  }

  QueryBuilder<ObservacionIsar, String?, QQueryOperations>
      creesQueEsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'creesQueEs');
    });
  }

  QueryBuilder<ObservacionIsar, DateTime, QQueryOperations>
      cuandoCreadaProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cuandoCreada');
    });
  }

  QueryBuilder<ObservacionIsar, DateTime, QQueryOperations>
      cuandoOcurrioProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cuandoOcurrio');
    });
  }

  QueryBuilder<ObservacionIsar, String?, QQueryOperations>
      dibujoRutaLocalProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dibujoRutaLocal');
    });
  }

  QueryBuilder<ObservacionIsar, String, QQueryOperations>
      dondeNombreProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dondeNombre');
    });
  }

  QueryBuilder<ObservacionIsar, String?, QQueryOperations>
      fotoRutaLocalProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fotoRutaLocal');
    });
  }

  QueryBuilder<ObservacionIsar, String, QQueryOperations> idDominioProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'idDominio');
    });
  }

  QueryBuilder<ObservacionIsar, double?, QQueryOperations> latProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lat');
    });
  }

  QueryBuilder<ObservacionIsar, double?, QQueryOperations> lngProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lng');
    });
  }

  QueryBuilder<ObservacionIsar, String?, QQueryOperations>
      misterioIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'misterioId');
    });
  }

  QueryBuilder<ObservacionIsar, String, QQueryOperations> queVioProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'queVio');
    });
  }

  QueryBuilder<ObservacionIsar, String?, QQueryOperations> sitSpotIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sitSpotId');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetSitSpotIsarCollection on Isar {
  IsarCollection<SitSpotIsar> get sitSpotIsars => this.collection();
}

const SitSpotIsarSchema = CollectionSchema(
  name: r'SitSpotIsar',
  id: -4363002219226187702,
  properties: {
    r'creadoEn': PropertySchema(
      id: 0,
      name: r'creadoEn',
      type: IsarType.dateTime,
    ),
    r'dondeNombre': PropertySchema(
      id: 1,
      name: r'dondeNombre',
      type: IsarType.string,
    ),
    r'idDominio': PropertySchema(
      id: 2,
      name: r'idDominio',
      type: IsarType.string,
    ),
    r'lat': PropertySchema(
      id: 3,
      name: r'lat',
      type: IsarType.double,
    ),
    r'lng': PropertySchema(
      id: 4,
      name: r'lng',
      type: IsarType.double,
    ),
    r'nombre': PropertySchema(
      id: 5,
      name: r'nombre',
      type: IsarType.string,
    ),
    r'retiradoEn': PropertySchema(
      id: 6,
      name: r'retiradoEn',
      type: IsarType.dateTime,
    ),
    r'ultimaVisita': PropertySchema(
      id: 7,
      name: r'ultimaVisita',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _sitSpotIsarEstimateSize,
  serialize: _sitSpotIsarSerialize,
  deserialize: _sitSpotIsarDeserialize,
  deserializeProp: _sitSpotIsarDeserializeProp,
  idName: r'isarId',
  indexes: {
    r'idDominio': IndexSchema(
      id: -3608782195166194351,
      name: r'idDominio',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'idDominio',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _sitSpotIsarGetId,
  getLinks: _sitSpotIsarGetLinks,
  attach: _sitSpotIsarAttach,
  version: '3.1.0+1',
);

int _sitSpotIsarEstimateSize(
  SitSpotIsar object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.dondeNombre.length * 3;
  bytesCount += 3 + object.idDominio.length * 3;
  bytesCount += 3 + object.nombre.length * 3;
  return bytesCount;
}

void _sitSpotIsarSerialize(
  SitSpotIsar object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.creadoEn);
  writer.writeString(offsets[1], object.dondeNombre);
  writer.writeString(offsets[2], object.idDominio);
  writer.writeDouble(offsets[3], object.lat);
  writer.writeDouble(offsets[4], object.lng);
  writer.writeString(offsets[5], object.nombre);
  writer.writeDateTime(offsets[6], object.retiradoEn);
  writer.writeDateTime(offsets[7], object.ultimaVisita);
}

SitSpotIsar _sitSpotIsarDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SitSpotIsar();
  object.creadoEn = reader.readDateTime(offsets[0]);
  object.dondeNombre = reader.readString(offsets[1]);
  object.idDominio = reader.readString(offsets[2]);
  object.isarId = id;
  object.lat = reader.readDoubleOrNull(offsets[3]);
  object.lng = reader.readDoubleOrNull(offsets[4]);
  object.nombre = reader.readString(offsets[5]);
  object.retiradoEn = reader.readDateTimeOrNull(offsets[6]);
  object.ultimaVisita = reader.readDateTimeOrNull(offsets[7]);
  return object;
}

P _sitSpotIsarDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readDoubleOrNull(offset)) as P;
    case 4:
      return (reader.readDoubleOrNull(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 7:
      return (reader.readDateTimeOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _sitSpotIsarGetId(SitSpotIsar object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _sitSpotIsarGetLinks(SitSpotIsar object) {
  return [];
}

void _sitSpotIsarAttach(
    IsarCollection<dynamic> col, Id id, SitSpotIsar object) {
  object.isarId = id;
}

extension SitSpotIsarByIndex on IsarCollection<SitSpotIsar> {
  Future<SitSpotIsar?> getByIdDominio(String idDominio) {
    return getByIndex(r'idDominio', [idDominio]);
  }

  SitSpotIsar? getByIdDominioSync(String idDominio) {
    return getByIndexSync(r'idDominio', [idDominio]);
  }

  Future<bool> deleteByIdDominio(String idDominio) {
    return deleteByIndex(r'idDominio', [idDominio]);
  }

  bool deleteByIdDominioSync(String idDominio) {
    return deleteByIndexSync(r'idDominio', [idDominio]);
  }

  Future<List<SitSpotIsar?>> getAllByIdDominio(List<String> idDominioValues) {
    final values = idDominioValues.map((e) => [e]).toList();
    return getAllByIndex(r'idDominio', values);
  }

  List<SitSpotIsar?> getAllByIdDominioSync(List<String> idDominioValues) {
    final values = idDominioValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'idDominio', values);
  }

  Future<int> deleteAllByIdDominio(List<String> idDominioValues) {
    final values = idDominioValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'idDominio', values);
  }

  int deleteAllByIdDominioSync(List<String> idDominioValues) {
    final values = idDominioValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'idDominio', values);
  }

  Future<Id> putByIdDominio(SitSpotIsar object) {
    return putByIndex(r'idDominio', object);
  }

  Id putByIdDominioSync(SitSpotIsar object, {bool saveLinks = true}) {
    return putByIndexSync(r'idDominio', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByIdDominio(List<SitSpotIsar> objects) {
    return putAllByIndex(r'idDominio', objects);
  }

  List<Id> putAllByIdDominioSync(List<SitSpotIsar> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'idDominio', objects, saveLinks: saveLinks);
  }
}

extension SitSpotIsarQueryWhereSort
    on QueryBuilder<SitSpotIsar, SitSpotIsar, QWhere> {
  QueryBuilder<SitSpotIsar, SitSpotIsar, QAfterWhere> anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension SitSpotIsarQueryWhere
    on QueryBuilder<SitSpotIsar, SitSpotIsar, QWhereClause> {
  QueryBuilder<SitSpotIsar, SitSpotIsar, QAfterWhereClause> isarIdEqualTo(
      Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<SitSpotIsar, SitSpotIsar, QAfterWhereClause> isarIdNotEqualTo(
      Id isarId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<SitSpotIsar, SitSpotIsar, QAfterWhereClause> isarIdGreaterThan(
      Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<SitSpotIsar, SitSpotIsar, QAfterWhereClause> isarIdLessThan(
      Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<SitSpotIsar, SitSpotIsar, QAfterWhereClause> isarIdBetween(
    Id lowerIsarId,
    Id upperIsarId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerIsarId,
        includeLower: includeLower,
        upper: upperIsarId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SitSpotIsar, SitSpotIsar, QAfterWhereClause> idDominioEqualTo(
      String idDominio) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'idDominio',
        value: [idDominio],
      ));
    });
  }

  QueryBuilder<SitSpotIsar, SitSpotIsar, QAfterWhereClause> idDominioNotEqualTo(
      String idDominio) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'idDominio',
              lower: [],
              upper: [idDominio],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'idDominio',
              lower: [idDominio],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'idDominio',
              lower: [idDominio],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'idDominio',
              lower: [],
              upper: [idDominio],
              includeUpper: false,
            ));
      }
    });
  }
}

extension SitSpotIsarQueryFilter
    on QueryBuilder<SitSpotIsar, SitSpotIsar, QFilterCondition> {
  QueryBuilder<SitSpotIsar, SitSpotIsar, QAfterFilterCondition> creadoEnEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'creadoEn',
        value: value,
      ));
    });
  }

  QueryBuilder<SitSpotIsar, SitSpotIsar, QAfterFilterCondition>
      creadoEnGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'creadoEn',
        value: value,
      ));
    });
  }

  QueryBuilder<SitSpotIsar, SitSpotIsar, QAfterFilterCondition>
      creadoEnLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'creadoEn',
        value: value,
      ));
    });
  }

  QueryBuilder<SitSpotIsar, SitSpotIsar, QAfterFilterCondition> creadoEnBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'creadoEn',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SitSpotIsar, SitSpotIsar, QAfterFilterCondition>
      dondeNombreEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dondeNombre',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SitSpotIsar, SitSpotIsar, QAfterFilterCondition>
      dondeNombreGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dondeNombre',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SitSpotIsar, SitSpotIsar, QAfterFilterCondition>
      dondeNombreLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dondeNombre',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SitSpotIsar, SitSpotIsar, QAfterFilterCondition>
      dondeNombreBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dondeNombre',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SitSpotIsar, SitSpotIsar, QAfterFilterCondition>
      dondeNombreStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'dondeNombre',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SitSpotIsar, SitSpotIsar, QAfterFilterCondition>
      dondeNombreEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'dondeNombre',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SitSpotIsar, SitSpotIsar, QAfterFilterCondition>
      dondeNombreContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'dondeNombre',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SitSpotIsar, SitSpotIsar, QAfterFilterCondition>
      dondeNombreMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'dondeNombre',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SitSpotIsar, SitSpotIsar, QAfterFilterCondition>
      dondeNombreIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dondeNombre',
        value: '',
      ));
    });
  }

  QueryBuilder<SitSpotIsar, SitSpotIsar, QAfterFilterCondition>
      dondeNombreIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'dondeNombre',
        value: '',
      ));
    });
  }

  QueryBuilder<SitSpotIsar, SitSpotIsar, QAfterFilterCondition>
      idDominioEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'idDominio',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SitSpotIsar, SitSpotIsar, QAfterFilterCondition>
      idDominioGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'idDominio',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SitSpotIsar, SitSpotIsar, QAfterFilterCondition>
      idDominioLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'idDominio',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SitSpotIsar, SitSpotIsar, QAfterFilterCondition>
      idDominioBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'idDominio',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SitSpotIsar, SitSpotIsar, QAfterFilterCondition>
      idDominioStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'idDominio',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SitSpotIsar, SitSpotIsar, QAfterFilterCondition>
      idDominioEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'idDominio',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SitSpotIsar, SitSpotIsar, QAfterFilterCondition>
      idDominioContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'idDominio',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SitSpotIsar, SitSpotIsar, QAfterFilterCondition>
      idDominioMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'idDominio',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SitSpotIsar, SitSpotIsar, QAfterFilterCondition>
      idDominioIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'idDominio',
        value: '',
      ));
    });
  }

  QueryBuilder<SitSpotIsar, SitSpotIsar, QAfterFilterCondition>
      idDominioIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'idDominio',
        value: '',
      ));
    });
  }

  QueryBuilder<SitSpotIsar, SitSpotIsar, QAfterFilterCondition> isarIdEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<SitSpotIsar, SitSpotIsar, QAfterFilterCondition>
      isarIdGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<SitSpotIsar, SitSpotIsar, QAfterFilterCondition> isarIdLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<SitSpotIsar, SitSpotIsar, QAfterFilterCondition> isarIdBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'isarId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SitSpotIsar, SitSpotIsar, QAfterFilterCondition> latIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lat',
      ));
    });
  }

  QueryBuilder<SitSpotIsar, SitSpotIsar, QAfterFilterCondition> latIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lat',
      ));
    });
  }

  QueryBuilder<SitSpotIsar, SitSpotIsar, QAfterFilterCondition> latEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lat',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SitSpotIsar, SitSpotIsar, QAfterFilterCondition> latGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lat',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SitSpotIsar, SitSpotIsar, QAfterFilterCondition> latLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lat',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SitSpotIsar, SitSpotIsar, QAfterFilterCondition> latBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lat',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SitSpotIsar, SitSpotIsar, QAfterFilterCondition> lngIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lng',
      ));
    });
  }

  QueryBuilder<SitSpotIsar, SitSpotIsar, QAfterFilterCondition> lngIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lng',
      ));
    });
  }

  QueryBuilder<SitSpotIsar, SitSpotIsar, QAfterFilterCondition> lngEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lng',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SitSpotIsar, SitSpotIsar, QAfterFilterCondition> lngGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lng',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SitSpotIsar, SitSpotIsar, QAfterFilterCondition> lngLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lng',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SitSpotIsar, SitSpotIsar, QAfterFilterCondition> lngBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lng',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SitSpotIsar, SitSpotIsar, QAfterFilterCondition> nombreEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nombre',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SitSpotIsar, SitSpotIsar, QAfterFilterCondition>
      nombreGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'nombre',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SitSpotIsar, SitSpotIsar, QAfterFilterCondition> nombreLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'nombre',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SitSpotIsar, SitSpotIsar, QAfterFilterCondition> nombreBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'nombre',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SitSpotIsar, SitSpotIsar, QAfterFilterCondition>
      nombreStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'nombre',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SitSpotIsar, SitSpotIsar, QAfterFilterCondition> nombreEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'nombre',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SitSpotIsar, SitSpotIsar, QAfterFilterCondition> nombreContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'nombre',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SitSpotIsar, SitSpotIsar, QAfterFilterCondition> nombreMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'nombre',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SitSpotIsar, SitSpotIsar, QAfterFilterCondition>
      nombreIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nombre',
        value: '',
      ));
    });
  }

  QueryBuilder<SitSpotIsar, SitSpotIsar, QAfterFilterCondition>
      nombreIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'nombre',
        value: '',
      ));
    });
  }

  QueryBuilder<SitSpotIsar, SitSpotIsar, QAfterFilterCondition>
      retiradoEnIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'retiradoEn',
      ));
    });
  }

  QueryBuilder<SitSpotIsar, SitSpotIsar, QAfterFilterCondition>
      retiradoEnIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'retiradoEn',
      ));
    });
  }

  QueryBuilder<SitSpotIsar, SitSpotIsar, QAfterFilterCondition>
      retiradoEnEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'retiradoEn',
        value: value,
      ));
    });
  }

  QueryBuilder<SitSpotIsar, SitSpotIsar, QAfterFilterCondition>
      retiradoEnGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'retiradoEn',
        value: value,
      ));
    });
  }

  QueryBuilder<SitSpotIsar, SitSpotIsar, QAfterFilterCondition>
      retiradoEnLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'retiradoEn',
        value: value,
      ));
    });
  }

  QueryBuilder<SitSpotIsar, SitSpotIsar, QAfterFilterCondition>
      retiradoEnBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'retiradoEn',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SitSpotIsar, SitSpotIsar, QAfterFilterCondition>
      ultimaVisitaIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'ultimaVisita',
      ));
    });
  }

  QueryBuilder<SitSpotIsar, SitSpotIsar, QAfterFilterCondition>
      ultimaVisitaIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'ultimaVisita',
      ));
    });
  }

  QueryBuilder<SitSpotIsar, SitSpotIsar, QAfterFilterCondition>
      ultimaVisitaEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ultimaVisita',
        value: value,
      ));
    });
  }

  QueryBuilder<SitSpotIsar, SitSpotIsar, QAfterFilterCondition>
      ultimaVisitaGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'ultimaVisita',
        value: value,
      ));
    });
  }

  QueryBuilder<SitSpotIsar, SitSpotIsar, QAfterFilterCondition>
      ultimaVisitaLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'ultimaVisita',
        value: value,
      ));
    });
  }

  QueryBuilder<SitSpotIsar, SitSpotIsar, QAfterFilterCondition>
      ultimaVisitaBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'ultimaVisita',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension SitSpotIsarQueryObject
    on QueryBuilder<SitSpotIsar, SitSpotIsar, QFilterCondition> {}

extension SitSpotIsarQueryLinks
    on QueryBuilder<SitSpotIsar, SitSpotIsar, QFilterCondition> {}

extension SitSpotIsarQuerySortBy
    on QueryBuilder<SitSpotIsar, SitSpotIsar, QSortBy> {
  QueryBuilder<SitSpotIsar, SitSpotIsar, QAfterSortBy> sortByCreadoEn() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'creadoEn', Sort.asc);
    });
  }

  QueryBuilder<SitSpotIsar, SitSpotIsar, QAfterSortBy> sortByCreadoEnDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'creadoEn', Sort.desc);
    });
  }

  QueryBuilder<SitSpotIsar, SitSpotIsar, QAfterSortBy> sortByDondeNombre() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dondeNombre', Sort.asc);
    });
  }

  QueryBuilder<SitSpotIsar, SitSpotIsar, QAfterSortBy> sortByDondeNombreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dondeNombre', Sort.desc);
    });
  }

  QueryBuilder<SitSpotIsar, SitSpotIsar, QAfterSortBy> sortByIdDominio() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idDominio', Sort.asc);
    });
  }

  QueryBuilder<SitSpotIsar, SitSpotIsar, QAfterSortBy> sortByIdDominioDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idDominio', Sort.desc);
    });
  }

  QueryBuilder<SitSpotIsar, SitSpotIsar, QAfterSortBy> sortByLat() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lat', Sort.asc);
    });
  }

  QueryBuilder<SitSpotIsar, SitSpotIsar, QAfterSortBy> sortByLatDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lat', Sort.desc);
    });
  }

  QueryBuilder<SitSpotIsar, SitSpotIsar, QAfterSortBy> sortByLng() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lng', Sort.asc);
    });
  }

  QueryBuilder<SitSpotIsar, SitSpotIsar, QAfterSortBy> sortByLngDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lng', Sort.desc);
    });
  }

  QueryBuilder<SitSpotIsar, SitSpotIsar, QAfterSortBy> sortByNombre() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nombre', Sort.asc);
    });
  }

  QueryBuilder<SitSpotIsar, SitSpotIsar, QAfterSortBy> sortByNombreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nombre', Sort.desc);
    });
  }

  QueryBuilder<SitSpotIsar, SitSpotIsar, QAfterSortBy> sortByRetiradoEn() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'retiradoEn', Sort.asc);
    });
  }

  QueryBuilder<SitSpotIsar, SitSpotIsar, QAfterSortBy> sortByRetiradoEnDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'retiradoEn', Sort.desc);
    });
  }

  QueryBuilder<SitSpotIsar, SitSpotIsar, QAfterSortBy> sortByUltimaVisita() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ultimaVisita', Sort.asc);
    });
  }

  QueryBuilder<SitSpotIsar, SitSpotIsar, QAfterSortBy>
      sortByUltimaVisitaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ultimaVisita', Sort.desc);
    });
  }
}

extension SitSpotIsarQuerySortThenBy
    on QueryBuilder<SitSpotIsar, SitSpotIsar, QSortThenBy> {
  QueryBuilder<SitSpotIsar, SitSpotIsar, QAfterSortBy> thenByCreadoEn() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'creadoEn', Sort.asc);
    });
  }

  QueryBuilder<SitSpotIsar, SitSpotIsar, QAfterSortBy> thenByCreadoEnDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'creadoEn', Sort.desc);
    });
  }

  QueryBuilder<SitSpotIsar, SitSpotIsar, QAfterSortBy> thenByDondeNombre() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dondeNombre', Sort.asc);
    });
  }

  QueryBuilder<SitSpotIsar, SitSpotIsar, QAfterSortBy> thenByDondeNombreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dondeNombre', Sort.desc);
    });
  }

  QueryBuilder<SitSpotIsar, SitSpotIsar, QAfterSortBy> thenByIdDominio() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idDominio', Sort.asc);
    });
  }

  QueryBuilder<SitSpotIsar, SitSpotIsar, QAfterSortBy> thenByIdDominioDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idDominio', Sort.desc);
    });
  }

  QueryBuilder<SitSpotIsar, SitSpotIsar, QAfterSortBy> thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<SitSpotIsar, SitSpotIsar, QAfterSortBy> thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<SitSpotIsar, SitSpotIsar, QAfterSortBy> thenByLat() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lat', Sort.asc);
    });
  }

  QueryBuilder<SitSpotIsar, SitSpotIsar, QAfterSortBy> thenByLatDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lat', Sort.desc);
    });
  }

  QueryBuilder<SitSpotIsar, SitSpotIsar, QAfterSortBy> thenByLng() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lng', Sort.asc);
    });
  }

  QueryBuilder<SitSpotIsar, SitSpotIsar, QAfterSortBy> thenByLngDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lng', Sort.desc);
    });
  }

  QueryBuilder<SitSpotIsar, SitSpotIsar, QAfterSortBy> thenByNombre() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nombre', Sort.asc);
    });
  }

  QueryBuilder<SitSpotIsar, SitSpotIsar, QAfterSortBy> thenByNombreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nombre', Sort.desc);
    });
  }

  QueryBuilder<SitSpotIsar, SitSpotIsar, QAfterSortBy> thenByRetiradoEn() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'retiradoEn', Sort.asc);
    });
  }

  QueryBuilder<SitSpotIsar, SitSpotIsar, QAfterSortBy> thenByRetiradoEnDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'retiradoEn', Sort.desc);
    });
  }

  QueryBuilder<SitSpotIsar, SitSpotIsar, QAfterSortBy> thenByUltimaVisita() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ultimaVisita', Sort.asc);
    });
  }

  QueryBuilder<SitSpotIsar, SitSpotIsar, QAfterSortBy>
      thenByUltimaVisitaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ultimaVisita', Sort.desc);
    });
  }
}

extension SitSpotIsarQueryWhereDistinct
    on QueryBuilder<SitSpotIsar, SitSpotIsar, QDistinct> {
  QueryBuilder<SitSpotIsar, SitSpotIsar, QDistinct> distinctByCreadoEn() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'creadoEn');
    });
  }

  QueryBuilder<SitSpotIsar, SitSpotIsar, QDistinct> distinctByDondeNombre(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dondeNombre', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SitSpotIsar, SitSpotIsar, QDistinct> distinctByIdDominio(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'idDominio', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SitSpotIsar, SitSpotIsar, QDistinct> distinctByLat() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lat');
    });
  }

  QueryBuilder<SitSpotIsar, SitSpotIsar, QDistinct> distinctByLng() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lng');
    });
  }

  QueryBuilder<SitSpotIsar, SitSpotIsar, QDistinct> distinctByNombre(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'nombre', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SitSpotIsar, SitSpotIsar, QDistinct> distinctByRetiradoEn() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'retiradoEn');
    });
  }

  QueryBuilder<SitSpotIsar, SitSpotIsar, QDistinct> distinctByUltimaVisita() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'ultimaVisita');
    });
  }
}

extension SitSpotIsarQueryProperty
    on QueryBuilder<SitSpotIsar, SitSpotIsar, QQueryProperty> {
  QueryBuilder<SitSpotIsar, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<SitSpotIsar, DateTime, QQueryOperations> creadoEnProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'creadoEn');
    });
  }

  QueryBuilder<SitSpotIsar, String, QQueryOperations> dondeNombreProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dondeNombre');
    });
  }

  QueryBuilder<SitSpotIsar, String, QQueryOperations> idDominioProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'idDominio');
    });
  }

  QueryBuilder<SitSpotIsar, double?, QQueryOperations> latProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lat');
    });
  }

  QueryBuilder<SitSpotIsar, double?, QQueryOperations> lngProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lng');
    });
  }

  QueryBuilder<SitSpotIsar, String, QQueryOperations> nombreProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'nombre');
    });
  }

  QueryBuilder<SitSpotIsar, DateTime?, QQueryOperations> retiradoEnProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'retiradoEn');
    });
  }

  QueryBuilder<SitSpotIsar, DateTime?, QQueryOperations>
      ultimaVisitaProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ultimaVisita');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetMisterioIsarCollection on Isar {
  IsarCollection<MisterioIsar> get misterioIsars => this.collection();
}

const MisterioIsarSchema = CollectionSchema(
  name: r'MisterioIsar',
  id: -1475601342922996858,
  properties: {
    r'abierto': PropertySchema(
      id: 0,
      name: r'abierto',
      type: IsarType.bool,
    ),
    r'descripcionCorta': PropertySchema(
      id: 1,
      name: r'descripcionCorta',
      type: IsarType.string,
    ),
    r'estado': PropertySchema(
      id: 2,
      name: r'estado',
      type: IsarType.string,
      enumMap: _MisterioIsarestadoEnumValueMap,
    ),
    r'idDominio': PropertySchema(
      id: 3,
      name: r'idDominio',
      type: IsarType.string,
    ),
    r'observacionesIds': PropertySchema(
      id: 4,
      name: r'observacionesIds',
      type: IsarType.stringList,
    ),
    r'pregunta': PropertySchema(
      id: 5,
      name: r'pregunta',
      type: IsarType.string,
    ),
    r'regions': PropertySchema(
      id: 6,
      name: r'regions',
      type: IsarType.stringList,
    ),
    r'retiradoEn': PropertySchema(
      id: 7,
      name: r'retiradoEn',
      type: IsarType.dateTime,
    ),
    r'seasons': PropertySchema(
      id: 8,
      name: r'seasons',
      type: IsarType.stringList,
    )
  },
  estimateSize: _misterioIsarEstimateSize,
  serialize: _misterioIsarSerialize,
  deserialize: _misterioIsarDeserialize,
  deserializeProp: _misterioIsarDeserializeProp,
  idName: r'isarId',
  indexes: {
    r'idDominio': IndexSchema(
      id: -3608782195166194351,
      name: r'idDominio',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'idDominio',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'abierto': IndexSchema(
      id: 3920643479831546466,
      name: r'abierto',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'abierto',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _misterioIsarGetId,
  getLinks: _misterioIsarGetLinks,
  attach: _misterioIsarAttach,
  version: '3.1.0+1',
);

int _misterioIsarEstimateSize(
  MisterioIsar object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.descripcionCorta.length * 3;
  bytesCount += 3 + object.estado.name.length * 3;
  bytesCount += 3 + object.idDominio.length * 3;
  bytesCount += 3 + object.observacionesIds.length * 3;
  {
    for (var i = 0; i < object.observacionesIds.length; i++) {
      final value = object.observacionesIds[i];
      bytesCount += value.length * 3;
    }
  }
  bytesCount += 3 + object.pregunta.length * 3;
  bytesCount += 3 + object.regions.length * 3;
  {
    for (var i = 0; i < object.regions.length; i++) {
      final value = object.regions[i];
      bytesCount += value.length * 3;
    }
  }
  bytesCount += 3 + object.seasons.length * 3;
  {
    for (var i = 0; i < object.seasons.length; i++) {
      final value = object.seasons[i];
      bytesCount += value.length * 3;
    }
  }
  return bytesCount;
}

void _misterioIsarSerialize(
  MisterioIsar object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.abierto);
  writer.writeString(offsets[1], object.descripcionCorta);
  writer.writeString(offsets[2], object.estado.name);
  writer.writeString(offsets[3], object.idDominio);
  writer.writeStringList(offsets[4], object.observacionesIds);
  writer.writeString(offsets[5], object.pregunta);
  writer.writeStringList(offsets[6], object.regions);
  writer.writeDateTime(offsets[7], object.retiradoEn);
  writer.writeStringList(offsets[8], object.seasons);
}

MisterioIsar _misterioIsarDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = MisterioIsar();
  object.abierto = reader.readBool(offsets[0]);
  object.descripcionCorta = reader.readString(offsets[1]);
  object.estado =
      _MisterioIsarestadoValueEnumMap[reader.readStringOrNull(offsets[2])] ??
          NivelConfianzaIsar.consenso;
  object.idDominio = reader.readString(offsets[3]);
  object.isarId = id;
  object.observacionesIds = reader.readStringList(offsets[4]) ?? [];
  object.pregunta = reader.readString(offsets[5]);
  object.regions = reader.readStringList(offsets[6]) ?? [];
  object.retiradoEn = reader.readDateTimeOrNull(offsets[7]);
  object.seasons = reader.readStringList(offsets[8]) ?? [];
  return object;
}

P _misterioIsarDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBool(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (_MisterioIsarestadoValueEnumMap[
              reader.readStringOrNull(offset)] ??
          NivelConfianzaIsar.consenso) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readStringList(offset) ?? []) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readStringList(offset) ?? []) as P;
    case 7:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 8:
      return (reader.readStringList(offset) ?? []) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _MisterioIsarestadoEnumValueMap = {
  r'consenso': r'consenso',
  r'hipotesisActiva': r'hipotesisActiva',
  r'abandonado': r'abandonado',
  r'noSegura': r'noSegura',
};
const _MisterioIsarestadoValueEnumMap = {
  r'consenso': NivelConfianzaIsar.consenso,
  r'hipotesisActiva': NivelConfianzaIsar.hipotesisActiva,
  r'abandonado': NivelConfianzaIsar.abandonado,
  r'noSegura': NivelConfianzaIsar.noSegura,
};

Id _misterioIsarGetId(MisterioIsar object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _misterioIsarGetLinks(MisterioIsar object) {
  return [];
}

void _misterioIsarAttach(
    IsarCollection<dynamic> col, Id id, MisterioIsar object) {
  object.isarId = id;
}

extension MisterioIsarByIndex on IsarCollection<MisterioIsar> {
  Future<MisterioIsar?> getByIdDominio(String idDominio) {
    return getByIndex(r'idDominio', [idDominio]);
  }

  MisterioIsar? getByIdDominioSync(String idDominio) {
    return getByIndexSync(r'idDominio', [idDominio]);
  }

  Future<bool> deleteByIdDominio(String idDominio) {
    return deleteByIndex(r'idDominio', [idDominio]);
  }

  bool deleteByIdDominioSync(String idDominio) {
    return deleteByIndexSync(r'idDominio', [idDominio]);
  }

  Future<List<MisterioIsar?>> getAllByIdDominio(List<String> idDominioValues) {
    final values = idDominioValues.map((e) => [e]).toList();
    return getAllByIndex(r'idDominio', values);
  }

  List<MisterioIsar?> getAllByIdDominioSync(List<String> idDominioValues) {
    final values = idDominioValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'idDominio', values);
  }

  Future<int> deleteAllByIdDominio(List<String> idDominioValues) {
    final values = idDominioValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'idDominio', values);
  }

  int deleteAllByIdDominioSync(List<String> idDominioValues) {
    final values = idDominioValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'idDominio', values);
  }

  Future<Id> putByIdDominio(MisterioIsar object) {
    return putByIndex(r'idDominio', object);
  }

  Id putByIdDominioSync(MisterioIsar object, {bool saveLinks = true}) {
    return putByIndexSync(r'idDominio', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByIdDominio(List<MisterioIsar> objects) {
    return putAllByIndex(r'idDominio', objects);
  }

  List<Id> putAllByIdDominioSync(List<MisterioIsar> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'idDominio', objects, saveLinks: saveLinks);
  }
}

extension MisterioIsarQueryWhereSort
    on QueryBuilder<MisterioIsar, MisterioIsar, QWhere> {
  QueryBuilder<MisterioIsar, MisterioIsar, QAfterWhere> anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterWhere> anyAbierto() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'abierto'),
      );
    });
  }
}

extension MisterioIsarQueryWhere
    on QueryBuilder<MisterioIsar, MisterioIsar, QWhereClause> {
  QueryBuilder<MisterioIsar, MisterioIsar, QAfterWhereClause> isarIdEqualTo(
      Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterWhereClause> isarIdNotEqualTo(
      Id isarId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterWhereClause> isarIdGreaterThan(
      Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterWhereClause> isarIdLessThan(
      Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterWhereClause> isarIdBetween(
    Id lowerIsarId,
    Id upperIsarId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerIsarId,
        includeLower: includeLower,
        upper: upperIsarId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterWhereClause> idDominioEqualTo(
      String idDominio) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'idDominio',
        value: [idDominio],
      ));
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterWhereClause>
      idDominioNotEqualTo(String idDominio) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'idDominio',
              lower: [],
              upper: [idDominio],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'idDominio',
              lower: [idDominio],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'idDominio',
              lower: [idDominio],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'idDominio',
              lower: [],
              upper: [idDominio],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterWhereClause> abiertoEqualTo(
      bool abierto) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'abierto',
        value: [abierto],
      ));
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterWhereClause> abiertoNotEqualTo(
      bool abierto) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'abierto',
              lower: [],
              upper: [abierto],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'abierto',
              lower: [abierto],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'abierto',
              lower: [abierto],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'abierto',
              lower: [],
              upper: [abierto],
              includeUpper: false,
            ));
      }
    });
  }
}

extension MisterioIsarQueryFilter
    on QueryBuilder<MisterioIsar, MisterioIsar, QFilterCondition> {
  QueryBuilder<MisterioIsar, MisterioIsar, QAfterFilterCondition>
      abiertoEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'abierto',
        value: value,
      ));
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterFilterCondition>
      descripcionCortaEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'descripcionCorta',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterFilterCondition>
      descripcionCortaGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'descripcionCorta',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterFilterCondition>
      descripcionCortaLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'descripcionCorta',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterFilterCondition>
      descripcionCortaBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'descripcionCorta',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterFilterCondition>
      descripcionCortaStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'descripcionCorta',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterFilterCondition>
      descripcionCortaEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'descripcionCorta',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterFilterCondition>
      descripcionCortaContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'descripcionCorta',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterFilterCondition>
      descripcionCortaMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'descripcionCorta',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterFilterCondition>
      descripcionCortaIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'descripcionCorta',
        value: '',
      ));
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterFilterCondition>
      descripcionCortaIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'descripcionCorta',
        value: '',
      ));
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterFilterCondition> estadoEqualTo(
    NivelConfianzaIsar value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'estado',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterFilterCondition>
      estadoGreaterThan(
    NivelConfianzaIsar value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'estado',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterFilterCondition>
      estadoLessThan(
    NivelConfianzaIsar value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'estado',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterFilterCondition> estadoBetween(
    NivelConfianzaIsar lower,
    NivelConfianzaIsar upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'estado',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterFilterCondition>
      estadoStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'estado',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterFilterCondition>
      estadoEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'estado',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterFilterCondition>
      estadoContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'estado',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterFilterCondition> estadoMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'estado',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterFilterCondition>
      estadoIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'estado',
        value: '',
      ));
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterFilterCondition>
      estadoIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'estado',
        value: '',
      ));
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterFilterCondition>
      idDominioEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'idDominio',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterFilterCondition>
      idDominioGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'idDominio',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterFilterCondition>
      idDominioLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'idDominio',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterFilterCondition>
      idDominioBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'idDominio',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterFilterCondition>
      idDominioStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'idDominio',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterFilterCondition>
      idDominioEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'idDominio',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterFilterCondition>
      idDominioContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'idDominio',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterFilterCondition>
      idDominioMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'idDominio',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterFilterCondition>
      idDominioIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'idDominio',
        value: '',
      ));
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterFilterCondition>
      idDominioIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'idDominio',
        value: '',
      ));
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterFilterCondition> isarIdEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterFilterCondition>
      isarIdGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterFilterCondition>
      isarIdLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterFilterCondition> isarIdBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'isarId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterFilterCondition>
      observacionesIdsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'observacionesIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterFilterCondition>
      observacionesIdsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'observacionesIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterFilterCondition>
      observacionesIdsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'observacionesIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterFilterCondition>
      observacionesIdsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'observacionesIds',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterFilterCondition>
      observacionesIdsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'observacionesIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterFilterCondition>
      observacionesIdsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'observacionesIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterFilterCondition>
      observacionesIdsElementContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'observacionesIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterFilterCondition>
      observacionesIdsElementMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'observacionesIds',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterFilterCondition>
      observacionesIdsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'observacionesIds',
        value: '',
      ));
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterFilterCondition>
      observacionesIdsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'observacionesIds',
        value: '',
      ));
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterFilterCondition>
      observacionesIdsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'observacionesIds',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterFilterCondition>
      observacionesIdsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'observacionesIds',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterFilterCondition>
      observacionesIdsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'observacionesIds',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterFilterCondition>
      observacionesIdsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'observacionesIds',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterFilterCondition>
      observacionesIdsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'observacionesIds',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterFilterCondition>
      observacionesIdsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'observacionesIds',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterFilterCondition>
      preguntaEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pregunta',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterFilterCondition>
      preguntaGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'pregunta',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterFilterCondition>
      preguntaLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'pregunta',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterFilterCondition>
      preguntaBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'pregunta',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterFilterCondition>
      preguntaStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'pregunta',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterFilterCondition>
      preguntaEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'pregunta',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterFilterCondition>
      preguntaContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'pregunta',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterFilterCondition>
      preguntaMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'pregunta',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterFilterCondition>
      preguntaIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pregunta',
        value: '',
      ));
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterFilterCondition>
      preguntaIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'pregunta',
        value: '',
      ));
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterFilterCondition>
      regionsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'regions',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterFilterCondition>
      regionsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'regions',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterFilterCondition>
      regionsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'regions',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterFilterCondition>
      regionsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'regions',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterFilterCondition>
      regionsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'regions',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterFilterCondition>
      regionsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'regions',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterFilterCondition>
      regionsElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'regions',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterFilterCondition>
      regionsElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'regions',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterFilterCondition>
      regionsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'regions',
        value: '',
      ));
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterFilterCondition>
      regionsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'regions',
        value: '',
      ));
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterFilterCondition>
      regionsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'regions',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterFilterCondition>
      regionsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'regions',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterFilterCondition>
      regionsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'regions',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterFilterCondition>
      regionsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'regions',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterFilterCondition>
      regionsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'regions',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterFilterCondition>
      regionsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'regions',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterFilterCondition>
      retiradoEnIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'retiradoEn',
      ));
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterFilterCondition>
      retiradoEnIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'retiradoEn',
      ));
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterFilterCondition>
      retiradoEnEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'retiradoEn',
        value: value,
      ));
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterFilterCondition>
      retiradoEnGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'retiradoEn',
        value: value,
      ));
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterFilterCondition>
      retiradoEnLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'retiradoEn',
        value: value,
      ));
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterFilterCondition>
      retiradoEnBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'retiradoEn',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterFilterCondition>
      seasonsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'seasons',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterFilterCondition>
      seasonsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'seasons',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterFilterCondition>
      seasonsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'seasons',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterFilterCondition>
      seasonsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'seasons',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterFilterCondition>
      seasonsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'seasons',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterFilterCondition>
      seasonsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'seasons',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterFilterCondition>
      seasonsElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'seasons',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterFilterCondition>
      seasonsElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'seasons',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterFilterCondition>
      seasonsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'seasons',
        value: '',
      ));
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterFilterCondition>
      seasonsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'seasons',
        value: '',
      ));
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterFilterCondition>
      seasonsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'seasons',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterFilterCondition>
      seasonsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'seasons',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterFilterCondition>
      seasonsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'seasons',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterFilterCondition>
      seasonsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'seasons',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterFilterCondition>
      seasonsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'seasons',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterFilterCondition>
      seasonsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'seasons',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }
}

extension MisterioIsarQueryObject
    on QueryBuilder<MisterioIsar, MisterioIsar, QFilterCondition> {}

extension MisterioIsarQueryLinks
    on QueryBuilder<MisterioIsar, MisterioIsar, QFilterCondition> {}

extension MisterioIsarQuerySortBy
    on QueryBuilder<MisterioIsar, MisterioIsar, QSortBy> {
  QueryBuilder<MisterioIsar, MisterioIsar, QAfterSortBy> sortByAbierto() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'abierto', Sort.asc);
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterSortBy> sortByAbiertoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'abierto', Sort.desc);
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterSortBy>
      sortByDescripcionCorta() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'descripcionCorta', Sort.asc);
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterSortBy>
      sortByDescripcionCortaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'descripcionCorta', Sort.desc);
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterSortBy> sortByEstado() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'estado', Sort.asc);
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterSortBy> sortByEstadoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'estado', Sort.desc);
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterSortBy> sortByIdDominio() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idDominio', Sort.asc);
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterSortBy> sortByIdDominioDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idDominio', Sort.desc);
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterSortBy> sortByPregunta() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pregunta', Sort.asc);
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterSortBy> sortByPreguntaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pregunta', Sort.desc);
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterSortBy> sortByRetiradoEn() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'retiradoEn', Sort.asc);
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterSortBy>
      sortByRetiradoEnDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'retiradoEn', Sort.desc);
    });
  }
}

extension MisterioIsarQuerySortThenBy
    on QueryBuilder<MisterioIsar, MisterioIsar, QSortThenBy> {
  QueryBuilder<MisterioIsar, MisterioIsar, QAfterSortBy> thenByAbierto() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'abierto', Sort.asc);
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterSortBy> thenByAbiertoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'abierto', Sort.desc);
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterSortBy>
      thenByDescripcionCorta() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'descripcionCorta', Sort.asc);
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterSortBy>
      thenByDescripcionCortaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'descripcionCorta', Sort.desc);
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterSortBy> thenByEstado() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'estado', Sort.asc);
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterSortBy> thenByEstadoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'estado', Sort.desc);
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterSortBy> thenByIdDominio() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idDominio', Sort.asc);
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterSortBy> thenByIdDominioDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idDominio', Sort.desc);
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterSortBy> thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterSortBy> thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterSortBy> thenByPregunta() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pregunta', Sort.asc);
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterSortBy> thenByPreguntaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pregunta', Sort.desc);
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterSortBy> thenByRetiradoEn() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'retiradoEn', Sort.asc);
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QAfterSortBy>
      thenByRetiradoEnDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'retiradoEn', Sort.desc);
    });
  }
}

extension MisterioIsarQueryWhereDistinct
    on QueryBuilder<MisterioIsar, MisterioIsar, QDistinct> {
  QueryBuilder<MisterioIsar, MisterioIsar, QDistinct> distinctByAbierto() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'abierto');
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QDistinct>
      distinctByDescripcionCorta({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'descripcionCorta',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QDistinct> distinctByEstado(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'estado', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QDistinct> distinctByIdDominio(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'idDominio', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QDistinct>
      distinctByObservacionesIds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'observacionesIds');
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QDistinct> distinctByPregunta(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pregunta', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QDistinct> distinctByRegions() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'regions');
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QDistinct> distinctByRetiradoEn() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'retiradoEn');
    });
  }

  QueryBuilder<MisterioIsar, MisterioIsar, QDistinct> distinctBySeasons() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'seasons');
    });
  }
}

extension MisterioIsarQueryProperty
    on QueryBuilder<MisterioIsar, MisterioIsar, QQueryProperty> {
  QueryBuilder<MisterioIsar, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<MisterioIsar, bool, QQueryOperations> abiertoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'abierto');
    });
  }

  QueryBuilder<MisterioIsar, String, QQueryOperations>
      descripcionCortaProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'descripcionCorta');
    });
  }

  QueryBuilder<MisterioIsar, NivelConfianzaIsar, QQueryOperations>
      estadoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'estado');
    });
  }

  QueryBuilder<MisterioIsar, String, QQueryOperations> idDominioProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'idDominio');
    });
  }

  QueryBuilder<MisterioIsar, List<String>, QQueryOperations>
      observacionesIdsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'observacionesIds');
    });
  }

  QueryBuilder<MisterioIsar, String, QQueryOperations> preguntaProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pregunta');
    });
  }

  QueryBuilder<MisterioIsar, List<String>, QQueryOperations> regionsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'regions');
    });
  }

  QueryBuilder<MisterioIsar, DateTime?, QQueryOperations> retiradoEnProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'retiradoEn');
    });
  }

  QueryBuilder<MisterioIsar, List<String>, QQueryOperations> seasonsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'seasons');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetPaginaCuadernoIsarCollection on Isar {
  IsarCollection<PaginaCuadernoIsar> get paginaCuadernoIsars =>
      this.collection();
}

const PaginaCuadernoIsarSchema = CollectionSchema(
  name: r'PaginaCuadernoIsar',
  id: -3682651146279234394,
  properties: {
    r'ano': PropertySchema(
      id: 0,
      name: r'ano',
      type: IsarType.long,
    ),
    r'cargaJson': PropertySchema(
      id: 1,
      name: r'cargaJson',
      type: IsarType.string,
    ),
    r'creadaEn': PropertySchema(
      id: 2,
      name: r'creadaEn',
      type: IsarType.dateTime,
    ),
    r'estacion': PropertySchema(
      id: 3,
      name: r'estacion',
      type: IsarType.string,
      enumMap: _PaginaCuadernoIsarestacionEnumValueMap,
    ),
    r'idDominio': PropertySchema(
      id: 4,
      name: r'idDominio',
      type: IsarType.string,
    ),
    r'misterioId': PropertySchema(
      id: 5,
      name: r'misterioId',
      type: IsarType.string,
    ),
    r'observacionId': PropertySchema(
      id: 6,
      name: r'observacionId',
      type: IsarType.string,
    ),
    r'sitSpotId': PropertySchema(
      id: 7,
      name: r'sitSpotId',
      type: IsarType.string,
    ),
    r'tipo': PropertySchema(
      id: 8,
      name: r'tipo',
      type: IsarType.string,
      enumMap: _PaginaCuadernoIsartipoEnumValueMap,
    )
  },
  estimateSize: _paginaCuadernoIsarEstimateSize,
  serialize: _paginaCuadernoIsarSerialize,
  deserialize: _paginaCuadernoIsarDeserialize,
  deserializeProp: _paginaCuadernoIsarDeserializeProp,
  idName: r'isarId',
  indexes: {
    r'idDominio': IndexSchema(
      id: -3608782195166194351,
      name: r'idDominio',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'idDominio',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _paginaCuadernoIsarGetId,
  getLinks: _paginaCuadernoIsarGetLinks,
  attach: _paginaCuadernoIsarAttach,
  version: '3.1.0+1',
);

int _paginaCuadernoIsarEstimateSize(
  PaginaCuadernoIsar object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.cargaJson;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.estacion;
    if (value != null) {
      bytesCount += 3 + value.name.length * 3;
    }
  }
  bytesCount += 3 + object.idDominio.length * 3;
  {
    final value = object.misterioId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.observacionId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.sitSpotId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.tipo.name.length * 3;
  return bytesCount;
}

void _paginaCuadernoIsarSerialize(
  PaginaCuadernoIsar object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.ano);
  writer.writeString(offsets[1], object.cargaJson);
  writer.writeDateTime(offsets[2], object.creadaEn);
  writer.writeString(offsets[3], object.estacion?.name);
  writer.writeString(offsets[4], object.idDominio);
  writer.writeString(offsets[5], object.misterioId);
  writer.writeString(offsets[6], object.observacionId);
  writer.writeString(offsets[7], object.sitSpotId);
  writer.writeString(offsets[8], object.tipo.name);
}

PaginaCuadernoIsar _paginaCuadernoIsarDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PaginaCuadernoIsar();
  object.ano = reader.readLongOrNull(offsets[0]);
  object.cargaJson = reader.readStringOrNull(offsets[1]);
  object.creadaEn = reader.readDateTime(offsets[2]);
  object.estacion = _PaginaCuadernoIsarestacionValueEnumMap[
      reader.readStringOrNull(offsets[3])];
  object.idDominio = reader.readString(offsets[4]);
  object.isarId = id;
  object.misterioId = reader.readStringOrNull(offsets[5]);
  object.observacionId = reader.readStringOrNull(offsets[6]);
  object.sitSpotId = reader.readStringOrNull(offsets[7]);
  object.tipo = _PaginaCuadernoIsartipoValueEnumMap[
          reader.readStringOrNull(offsets[8])] ??
      TipoPaginaIsar.observacion;
  return object;
}

P _paginaCuadernoIsarDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (_PaginaCuadernoIsarestacionValueEnumMap[
          reader.readStringOrNull(offset)]) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readStringOrNull(offset)) as P;
    case 8:
      return (_PaginaCuadernoIsartipoValueEnumMap[
              reader.readStringOrNull(offset)] ??
          TipoPaginaIsar.observacion) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _PaginaCuadernoIsarestacionEnumValueMap = {
  r'otono': r'otono',
  r'invierno': r'invierno',
  r'primavera': r'primavera',
  r'verano': r'verano',
};
const _PaginaCuadernoIsarestacionValueEnumMap = {
  r'otono': EstacionIsar.otono,
  r'invierno': EstacionIsar.invierno,
  r'primavera': EstacionIsar.primavera,
  r'verano': EstacionIsar.verano,
};
const _PaginaCuadernoIsartipoEnumValueMap = {
  r'observacion': r'observacion',
  r'sitSpot': r'sitSpot',
  r'misterio': r'misterio',
  r'estacion': r'estacion',
};
const _PaginaCuadernoIsartipoValueEnumMap = {
  r'observacion': TipoPaginaIsar.observacion,
  r'sitSpot': TipoPaginaIsar.sitSpot,
  r'misterio': TipoPaginaIsar.misterio,
  r'estacion': TipoPaginaIsar.estacion,
};

Id _paginaCuadernoIsarGetId(PaginaCuadernoIsar object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _paginaCuadernoIsarGetLinks(
    PaginaCuadernoIsar object) {
  return [];
}

void _paginaCuadernoIsarAttach(
    IsarCollection<dynamic> col, Id id, PaginaCuadernoIsar object) {
  object.isarId = id;
}

extension PaginaCuadernoIsarByIndex on IsarCollection<PaginaCuadernoIsar> {
  Future<PaginaCuadernoIsar?> getByIdDominio(String idDominio) {
    return getByIndex(r'idDominio', [idDominio]);
  }

  PaginaCuadernoIsar? getByIdDominioSync(String idDominio) {
    return getByIndexSync(r'idDominio', [idDominio]);
  }

  Future<bool> deleteByIdDominio(String idDominio) {
    return deleteByIndex(r'idDominio', [idDominio]);
  }

  bool deleteByIdDominioSync(String idDominio) {
    return deleteByIndexSync(r'idDominio', [idDominio]);
  }

  Future<List<PaginaCuadernoIsar?>> getAllByIdDominio(
      List<String> idDominioValues) {
    final values = idDominioValues.map((e) => [e]).toList();
    return getAllByIndex(r'idDominio', values);
  }

  List<PaginaCuadernoIsar?> getAllByIdDominioSync(
      List<String> idDominioValues) {
    final values = idDominioValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'idDominio', values);
  }

  Future<int> deleteAllByIdDominio(List<String> idDominioValues) {
    final values = idDominioValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'idDominio', values);
  }

  int deleteAllByIdDominioSync(List<String> idDominioValues) {
    final values = idDominioValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'idDominio', values);
  }

  Future<Id> putByIdDominio(PaginaCuadernoIsar object) {
    return putByIndex(r'idDominio', object);
  }

  Id putByIdDominioSync(PaginaCuadernoIsar object, {bool saveLinks = true}) {
    return putByIndexSync(r'idDominio', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByIdDominio(List<PaginaCuadernoIsar> objects) {
    return putAllByIndex(r'idDominio', objects);
  }

  List<Id> putAllByIdDominioSync(List<PaginaCuadernoIsar> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'idDominio', objects, saveLinks: saveLinks);
  }
}

extension PaginaCuadernoIsarQueryWhereSort
    on QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QWhere> {
  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterWhere>
      anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension PaginaCuadernoIsarQueryWhere
    on QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QWhereClause> {
  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterWhereClause>
      isarIdEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterWhereClause>
      isarIdNotEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterWhereClause>
      isarIdGreaterThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterWhereClause>
      isarIdLessThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterWhereClause>
      isarIdBetween(
    Id lowerIsarId,
    Id upperIsarId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerIsarId,
        includeLower: includeLower,
        upper: upperIsarId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterWhereClause>
      idDominioEqualTo(String idDominio) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'idDominio',
        value: [idDominio],
      ));
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterWhereClause>
      idDominioNotEqualTo(String idDominio) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'idDominio',
              lower: [],
              upper: [idDominio],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'idDominio',
              lower: [idDominio],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'idDominio',
              lower: [idDominio],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'idDominio',
              lower: [],
              upper: [idDominio],
              includeUpper: false,
            ));
      }
    });
  }
}

extension PaginaCuadernoIsarQueryFilter
    on QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QFilterCondition> {
  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterFilterCondition>
      anoIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'ano',
      ));
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterFilterCondition>
      anoIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'ano',
      ));
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterFilterCondition>
      anoEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ano',
        value: value,
      ));
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterFilterCondition>
      anoGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'ano',
        value: value,
      ));
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterFilterCondition>
      anoLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'ano',
        value: value,
      ));
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterFilterCondition>
      anoBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'ano',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterFilterCondition>
      cargaJsonIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'cargaJson',
      ));
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterFilterCondition>
      cargaJsonIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'cargaJson',
      ));
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterFilterCondition>
      cargaJsonEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cargaJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterFilterCondition>
      cargaJsonGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'cargaJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterFilterCondition>
      cargaJsonLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'cargaJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterFilterCondition>
      cargaJsonBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'cargaJson',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterFilterCondition>
      cargaJsonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'cargaJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterFilterCondition>
      cargaJsonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'cargaJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterFilterCondition>
      cargaJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'cargaJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterFilterCondition>
      cargaJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'cargaJson',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterFilterCondition>
      cargaJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cargaJson',
        value: '',
      ));
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterFilterCondition>
      cargaJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'cargaJson',
        value: '',
      ));
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterFilterCondition>
      creadaEnEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'creadaEn',
        value: value,
      ));
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterFilterCondition>
      creadaEnGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'creadaEn',
        value: value,
      ));
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterFilterCondition>
      creadaEnLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'creadaEn',
        value: value,
      ));
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterFilterCondition>
      creadaEnBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'creadaEn',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterFilterCondition>
      estacionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'estacion',
      ));
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterFilterCondition>
      estacionIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'estacion',
      ));
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterFilterCondition>
      estacionEqualTo(
    EstacionIsar? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'estacion',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterFilterCondition>
      estacionGreaterThan(
    EstacionIsar? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'estacion',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterFilterCondition>
      estacionLessThan(
    EstacionIsar? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'estacion',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterFilterCondition>
      estacionBetween(
    EstacionIsar? lower,
    EstacionIsar? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'estacion',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterFilterCondition>
      estacionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'estacion',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterFilterCondition>
      estacionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'estacion',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterFilterCondition>
      estacionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'estacion',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterFilterCondition>
      estacionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'estacion',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterFilterCondition>
      estacionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'estacion',
        value: '',
      ));
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterFilterCondition>
      estacionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'estacion',
        value: '',
      ));
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterFilterCondition>
      idDominioEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'idDominio',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterFilterCondition>
      idDominioGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'idDominio',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterFilterCondition>
      idDominioLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'idDominio',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterFilterCondition>
      idDominioBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'idDominio',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterFilterCondition>
      idDominioStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'idDominio',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterFilterCondition>
      idDominioEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'idDominio',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterFilterCondition>
      idDominioContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'idDominio',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterFilterCondition>
      idDominioMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'idDominio',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterFilterCondition>
      idDominioIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'idDominio',
        value: '',
      ));
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterFilterCondition>
      idDominioIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'idDominio',
        value: '',
      ));
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterFilterCondition>
      isarIdEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterFilterCondition>
      isarIdGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterFilterCondition>
      isarIdLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterFilterCondition>
      isarIdBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'isarId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterFilterCondition>
      misterioIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'misterioId',
      ));
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterFilterCondition>
      misterioIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'misterioId',
      ));
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterFilterCondition>
      misterioIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'misterioId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterFilterCondition>
      misterioIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'misterioId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterFilterCondition>
      misterioIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'misterioId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterFilterCondition>
      misterioIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'misterioId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterFilterCondition>
      misterioIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'misterioId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterFilterCondition>
      misterioIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'misterioId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterFilterCondition>
      misterioIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'misterioId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterFilterCondition>
      misterioIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'misterioId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterFilterCondition>
      misterioIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'misterioId',
        value: '',
      ));
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterFilterCondition>
      misterioIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'misterioId',
        value: '',
      ));
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterFilterCondition>
      observacionIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'observacionId',
      ));
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterFilterCondition>
      observacionIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'observacionId',
      ));
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterFilterCondition>
      observacionIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'observacionId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterFilterCondition>
      observacionIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'observacionId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterFilterCondition>
      observacionIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'observacionId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterFilterCondition>
      observacionIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'observacionId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterFilterCondition>
      observacionIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'observacionId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterFilterCondition>
      observacionIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'observacionId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterFilterCondition>
      observacionIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'observacionId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterFilterCondition>
      observacionIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'observacionId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterFilterCondition>
      observacionIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'observacionId',
        value: '',
      ));
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterFilterCondition>
      observacionIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'observacionId',
        value: '',
      ));
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterFilterCondition>
      sitSpotIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'sitSpotId',
      ));
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterFilterCondition>
      sitSpotIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'sitSpotId',
      ));
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterFilterCondition>
      sitSpotIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sitSpotId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterFilterCondition>
      sitSpotIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sitSpotId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterFilterCondition>
      sitSpotIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sitSpotId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterFilterCondition>
      sitSpotIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sitSpotId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterFilterCondition>
      sitSpotIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'sitSpotId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterFilterCondition>
      sitSpotIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'sitSpotId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterFilterCondition>
      sitSpotIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'sitSpotId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterFilterCondition>
      sitSpotIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'sitSpotId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterFilterCondition>
      sitSpotIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sitSpotId',
        value: '',
      ));
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterFilterCondition>
      sitSpotIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'sitSpotId',
        value: '',
      ));
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterFilterCondition>
      tipoEqualTo(
    TipoPaginaIsar value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tipo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterFilterCondition>
      tipoGreaterThan(
    TipoPaginaIsar value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'tipo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterFilterCondition>
      tipoLessThan(
    TipoPaginaIsar value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'tipo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterFilterCondition>
      tipoBetween(
    TipoPaginaIsar lower,
    TipoPaginaIsar upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'tipo',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterFilterCondition>
      tipoStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'tipo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterFilterCondition>
      tipoEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'tipo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterFilterCondition>
      tipoContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'tipo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterFilterCondition>
      tipoMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'tipo',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterFilterCondition>
      tipoIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tipo',
        value: '',
      ));
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterFilterCondition>
      tipoIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'tipo',
        value: '',
      ));
    });
  }
}

extension PaginaCuadernoIsarQueryObject
    on QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QFilterCondition> {}

extension PaginaCuadernoIsarQueryLinks
    on QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QFilterCondition> {}

extension PaginaCuadernoIsarQuerySortBy
    on QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QSortBy> {
  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterSortBy>
      sortByAno() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ano', Sort.asc);
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterSortBy>
      sortByAnoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ano', Sort.desc);
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterSortBy>
      sortByCargaJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cargaJson', Sort.asc);
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterSortBy>
      sortByCargaJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cargaJson', Sort.desc);
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterSortBy>
      sortByCreadaEn() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'creadaEn', Sort.asc);
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterSortBy>
      sortByCreadaEnDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'creadaEn', Sort.desc);
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterSortBy>
      sortByEstacion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'estacion', Sort.asc);
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterSortBy>
      sortByEstacionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'estacion', Sort.desc);
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterSortBy>
      sortByIdDominio() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idDominio', Sort.asc);
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterSortBy>
      sortByIdDominioDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idDominio', Sort.desc);
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterSortBy>
      sortByMisterioId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'misterioId', Sort.asc);
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterSortBy>
      sortByMisterioIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'misterioId', Sort.desc);
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterSortBy>
      sortByObservacionId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'observacionId', Sort.asc);
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterSortBy>
      sortByObservacionIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'observacionId', Sort.desc);
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterSortBy>
      sortBySitSpotId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sitSpotId', Sort.asc);
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterSortBy>
      sortBySitSpotIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sitSpotId', Sort.desc);
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterSortBy>
      sortByTipo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tipo', Sort.asc);
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterSortBy>
      sortByTipoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tipo', Sort.desc);
    });
  }
}

extension PaginaCuadernoIsarQuerySortThenBy
    on QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QSortThenBy> {
  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterSortBy>
      thenByAno() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ano', Sort.asc);
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterSortBy>
      thenByAnoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ano', Sort.desc);
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterSortBy>
      thenByCargaJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cargaJson', Sort.asc);
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterSortBy>
      thenByCargaJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cargaJson', Sort.desc);
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterSortBy>
      thenByCreadaEn() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'creadaEn', Sort.asc);
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterSortBy>
      thenByCreadaEnDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'creadaEn', Sort.desc);
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterSortBy>
      thenByEstacion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'estacion', Sort.asc);
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterSortBy>
      thenByEstacionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'estacion', Sort.desc);
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterSortBy>
      thenByIdDominio() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idDominio', Sort.asc);
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterSortBy>
      thenByIdDominioDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idDominio', Sort.desc);
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterSortBy>
      thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterSortBy>
      thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterSortBy>
      thenByMisterioId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'misterioId', Sort.asc);
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterSortBy>
      thenByMisterioIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'misterioId', Sort.desc);
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterSortBy>
      thenByObservacionId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'observacionId', Sort.asc);
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterSortBy>
      thenByObservacionIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'observacionId', Sort.desc);
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterSortBy>
      thenBySitSpotId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sitSpotId', Sort.asc);
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterSortBy>
      thenBySitSpotIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sitSpotId', Sort.desc);
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterSortBy>
      thenByTipo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tipo', Sort.asc);
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QAfterSortBy>
      thenByTipoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tipo', Sort.desc);
    });
  }
}

extension PaginaCuadernoIsarQueryWhereDistinct
    on QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QDistinct> {
  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QDistinct>
      distinctByAno() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'ano');
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QDistinct>
      distinctByCargaJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cargaJson', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QDistinct>
      distinctByCreadaEn() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'creadaEn');
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QDistinct>
      distinctByEstacion({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'estacion', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QDistinct>
      distinctByIdDominio({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'idDominio', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QDistinct>
      distinctByMisterioId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'misterioId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QDistinct>
      distinctByObservacionId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'observacionId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QDistinct>
      distinctBySitSpotId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sitSpotId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QDistinct>
      distinctByTipo({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tipo', caseSensitive: caseSensitive);
    });
  }
}

extension PaginaCuadernoIsarQueryProperty
    on QueryBuilder<PaginaCuadernoIsar, PaginaCuadernoIsar, QQueryProperty> {
  QueryBuilder<PaginaCuadernoIsar, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<PaginaCuadernoIsar, int?, QQueryOperations> anoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ano');
    });
  }

  QueryBuilder<PaginaCuadernoIsar, String?, QQueryOperations>
      cargaJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cargaJson');
    });
  }

  QueryBuilder<PaginaCuadernoIsar, DateTime, QQueryOperations>
      creadaEnProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'creadaEn');
    });
  }

  QueryBuilder<PaginaCuadernoIsar, EstacionIsar?, QQueryOperations>
      estacionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'estacion');
    });
  }

  QueryBuilder<PaginaCuadernoIsar, String, QQueryOperations>
      idDominioProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'idDominio');
    });
  }

  QueryBuilder<PaginaCuadernoIsar, String?, QQueryOperations>
      misterioIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'misterioId');
    });
  }

  QueryBuilder<PaginaCuadernoIsar, String?, QQueryOperations>
      observacionIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'observacionId');
    });
  }

  QueryBuilder<PaginaCuadernoIsar, String?, QQueryOperations>
      sitSpotIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sitSpotId');
    });
  }

  QueryBuilder<PaginaCuadernoIsar, TipoPaginaIsar, QQueryOperations>
      tipoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tipo');
    });
  }
}
