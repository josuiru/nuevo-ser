// Modelos Isar — la capa de persistencia local. Doc 03 §3.3 los hace
// la frontera privada del cuaderno: lo que vive aquí (texto, fotos,
// dibujos, conversaciones, coordenadas) **nunca cruza red**, y la capa
// de sincronización del Sprint 2 leerá únicamente metadatos derivados.
//
// Las clases del dominio (`lib/dominio/`) son las verdaderas — éstas
// son su forma persistible. Los mappers `desdeDominio` /
// `aDominio` viven aquí.
//
// La generación se dispara con
//   dart run build_runner build --delete-conflicting-outputs
// y produce `modelos_isar.g.dart`.

import 'dart:convert';

import 'package:isar/isar.dart';

import '../../dominio/misterio.dart';
import '../../dominio/nivel_confianza.dart';
import '../../dominio/observacion.dart';
import '../../dominio/pagina_cuaderno.dart';
import '../../dominio/sit_spot.dart';

part 'modelos_isar.g.dart';

/// Espejo Isar de [NivelConfianza]. Replicarlo aquí evita que la clase
/// del dominio dependa del runtime Isar (que arrastra plataforma).
enum NivelConfianzaIsar {
  consenso,
  hipotesisActiva,
  abandonado,
  noSegura;

  static NivelConfianzaIsar desdeDominio(NivelConfianza valor) =>
      NivelConfianzaIsar.values[valor.index];

  NivelConfianza aDominio() => NivelConfianza.values[index];
}

/// Espejo Isar de [Estacion].
enum EstacionIsar {
  otono,
  invierno,
  primavera,
  verano;

  static EstacionIsar desdeDominio(Estacion valor) =>
      EstacionIsar.values[valor.index];

  Estacion aDominio() => Estacion.values[index];
}

/// Tipo de [PaginaCuaderno] persistido. Isar 3 no soporta sealed
/// classes; codificamos la variante con este enum + campos opcionales
/// en [PaginaCuadernoIsar].
enum TipoPaginaIsar { observacion, sitSpot, misterio, estacion }

@collection
class ObservacionIsar {
  ObservacionIsar();

  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String idDominio;

  late DateTime cuandoCreada;
  late DateTime cuandoOcurrio;
  late String dondeNombre;

  /// Coordenadas almacenadas planas (no embebidas) para simplificar
  /// queries y migraciones. **Solo en local** (doc 03 §7.1).
  double? lat;
  double? lng;

  String? climaResumen;

  /// Texto libre del niño. Doc 03 §3.3 lo prohíbe en servidor — al
  /// sincronizar (Sprint 2) la capa de sync envía solo el hash.
  late String queVio;

  String? creesQueEs;

  @Enumerated(EnumType.name)
  late NivelConfianzaIsar confianza;

  String? fotoRutaLocal;
  String? dibujoRutaLocal;

  @Index()
  String? misterioId;

  @Index()
  String? sitSpotId;

  static ObservacionIsar desdeDominio(Observacion observacion) {
    return ObservacionIsar()
      ..idDominio = observacion.id
      ..cuandoCreada = observacion.cuandoCreada
      ..cuandoOcurrio = observacion.cuandoOcurrio
      ..dondeNombre = observacion.dondeNombre
      ..lat = observacion.dondeCoordenadas?.lat
      ..lng = observacion.dondeCoordenadas?.lng
      ..climaResumen = observacion.climaResumen
      ..queVio = observacion.queVio
      ..creesQueEs = observacion.creesQueEs
      ..confianza = NivelConfianzaIsar.desdeDominio(observacion.confianza)
      ..fotoRutaLocal = observacion.fotoRutaLocal
      ..dibujoRutaLocal = observacion.dibujoRutaLocal
      ..misterioId = observacion.misterioId
      ..sitSpotId = observacion.sitSpotId;
  }

  Observacion aDominio() {
    final coordenadas = (lat != null && lng != null)
        ? Coordenadas(lat: lat!, lng: lng!)
        : null;
    return Observacion(
      id: idDominio,
      cuandoCreada: cuandoCreada,
      cuandoOcurrio: cuandoOcurrio,
      dondeNombre: dondeNombre,
      dondeCoordenadas: coordenadas,
      climaResumen: climaResumen,
      queVio: queVio,
      creesQueEs: creesQueEs,
      confianza: confianza.aDominio(),
      fotoRutaLocal: fotoRutaLocal,
      dibujoRutaLocal: dibujoRutaLocal,
      misterioId: misterioId,
      sitSpotId: sitSpotId,
    );
  }
}

@collection
class SitSpotIsar {
  SitSpotIsar();

  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String idDominio;

  late String nombre;
  late String dondeNombre;
  double? lat;
  double? lng;
  late DateTime creadoEn;
  DateTime? ultimaVisita;

  /// Si está activo o jubilado. Estructuralmente conservamos el sit
  /// spot retirado (doc 13 §2.6) — sus observaciones siguen ancladas.
  DateTime? retiradoEn;

  static SitSpotIsar desdeDominio(SitSpot sitSpot) {
    return SitSpotIsar()
      ..idDominio = sitSpot.id
      ..nombre = sitSpot.nombre
      ..dondeNombre = sitSpot.dondeNombre
      ..lat = sitSpot.coordenadas?.lat
      ..lng = sitSpot.coordenadas?.lng
      ..creadoEn = sitSpot.creadoEn
      ..ultimaVisita = sitSpot.ultimaVisita
      ..retiradoEn = sitSpot.retiradoEn;
  }

  SitSpot aDominio() {
    final coordenadas = (lat != null && lng != null)
        ? Coordenadas(lat: lat!, lng: lng!)
        : null;
    return SitSpot(
      id: idDominio,
      nombre: nombre,
      dondeNombre: dondeNombre,
      coordenadas: coordenadas,
      creadoEn: creadoEn,
      ultimaVisita: ultimaVisita,
      retiradoEn: retiradoEn,
    );
  }
}

@collection
class MisterioIsar {
  MisterioIsar();

  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String idDominio;

  late String pregunta;
  late String descripcionCorta;

  @Enumerated(EnumType.name)
  late NivelConfianzaIsar estado;

  @Index()
  late bool abierto;

  /// IDs de observaciones del niño ancladas a este Misterio. Lista
  /// homogénea de strings — Isar la persiste nativa.
  List<String> observacionesIds = const <String>[];

  DateTime? retiradoEn;

  /// Estaciones aplicables — strings del wire. Lista vacía = todo el
  /// año.
  List<String> seasons = const <String>[];

  /// Prefijos NUTS aplicables — null en Isar se mapea a lista vacía;
  /// para distinguir "global" (regions=null) de "lista vacía no
  /// significativa", el dominio interpreta lista vacía como null.
  /// El catálogo seminal nunca usa lista no-vacía vacía; la
  /// equivalencia es segura.
  List<String> regions = const <String>[];

  static MisterioIsar desdeDominio(Misterio misterio) {
    return MisterioIsar()
      ..idDominio = misterio.id
      ..pregunta = misterio.pregunta
      ..descripcionCorta = misterio.descripcionCorta
      ..estado = NivelConfianzaIsar.desdeDominio(misterio.estado)
      ..abierto = misterio.abierto
      ..observacionesIds = List.of(misterio.observacionesIds)
      ..retiradoEn = misterio.retiradoEn
      ..seasons = List.of(misterio.seasons)
      ..regions = List.of(misterio.regions ?? const <String>[]);
  }

  Misterio aDominio() {
    return Misterio(
      id: idDominio,
      pregunta: pregunta,
      descripcionCorta: descripcionCorta,
      estado: estado.aDominio(),
      abierto: abierto,
      observacionesIds: List.of(observacionesIds),
      retiradoEn: retiradoEn,
      seasons: List.of(seasons),
      regions: regions.isEmpty ? null : List.of(regions),
    );
  }
}

@collection
class PaginaCuadernoIsar {
  PaginaCuadernoIsar();

  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String idDominio;

  late DateTime creadaEn;

  @Enumerated(EnumType.name)
  late TipoPaginaIsar tipo;

  /// Apunta al ObservacionIsar.idDominio cuando [tipo] es observacion.
  String? observacionId;

  /// Apunta al SitSpotIsar.idDominio cuando [tipo] es sitSpot.
  String? sitSpotId;

  /// Apunta al MisterioIsar.idDominio cuando [tipo] es misterio.
  String? misterioId;

  @Enumerated(EnumType.name)
  EstacionIsar? estacion;

  int? ano;

  /// JSON serializado del resumen del sit spot (`datosResumen`) o del
  /// mosaico de la estación (`contenidoMosaico`). El SDK Isar 3 no
  /// soporta `Map<String, dynamic>` directamente, así que viaja como
  /// texto.
  String? cargaJson;

  static PaginaCuadernoIsar desdeDominio(PaginaCuaderno pagina) {
    final modelo = PaginaCuadernoIsar()
      ..idDominio = pagina.id
      ..creadaEn = pagina.creadaEn;
    switch (pagina) {
      case PaginaObservacion(observacionId: final observacionIdValor):
        modelo
          ..tipo = TipoPaginaIsar.observacion
          ..observacionId = observacionIdValor;
      case PaginaSitSpot(
          sitSpotId: final sitSpotIdValor,
          datosResumen: final datosResumenValor,
        ):
        modelo
          ..tipo = TipoPaginaIsar.sitSpot
          ..sitSpotId = sitSpotIdValor
          ..cargaJson = jsonEncode(datosResumenValor);
      case PaginaMisterio(misterioId: final misterioIdValor):
        modelo
          ..tipo = TipoPaginaIsar.misterio
          ..misterioId = misterioIdValor;
      case PaginaEstacion(
          estacion: final estacionValor,
          ano: final anoValor,
          contenidoMosaico: final contenidoMosaicoValor,
        ):
        modelo
          ..tipo = TipoPaginaIsar.estacion
          ..estacion = EstacionIsar.desdeDominio(estacionValor)
          ..ano = anoValor
          ..cargaJson = jsonEncode(contenidoMosaicoValor);
    }
    return modelo;
  }

  PaginaCuaderno aDominio() {
    switch (tipo) {
      case TipoPaginaIsar.observacion:
        return PaginaObservacion(
          id: idDominio,
          creadaEn: creadaEn,
          observacionId: observacionId!,
        );
      case TipoPaginaIsar.sitSpot:
        final datos = jsonDecode(cargaJson ?? '{}') as Map<String, dynamic>;
        return PaginaSitSpot(
          id: idDominio,
          creadaEn: creadaEn,
          sitSpotId: sitSpotId!,
          datosResumen: datos,
        );
      case TipoPaginaIsar.misterio:
        return PaginaMisterio(
          id: idDominio,
          creadaEn: creadaEn,
          misterioId: misterioId!,
        );
      case TipoPaginaIsar.estacion:
        final contenido = jsonDecode(cargaJson ?? '{}') as Map<String, dynamic>;
        return PaginaEstacion(
          id: idDominio,
          creadaEn: creadaEn,
          estacion: estacion!.aDominio(),
          ano: ano!,
          contenidoMosaico: contenido,
        );
    }
  }
}
