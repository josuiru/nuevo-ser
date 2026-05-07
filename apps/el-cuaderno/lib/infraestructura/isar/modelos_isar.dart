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
import '../../dominio/pregunta_del_nino.dart';
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

  /// Anclaje opcional a una pregunta del niño (Slice 4 de "Mis
  /// preguntas"). Indexado para que el listado de evidencias por
  /// pregunta no escanee la colección.
  @Index()
  String? preguntaDelNinoId;

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
      ..preguntaDelNinoId = observacion.preguntaDelNinoId
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
      preguntaDelNinoId: preguntaDelNinoId,
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

  /// Cuándo el niño cerró el Misterio para sí. Estado del niño, no del
  /// catálogo (paralelo a [observacionesIds]).
  DateTime? cerradoPorNino;

  /// Lo que el niño anotó al cerrar. Vive aquí porque es por-niño.
  String? respuestaDelNino;

  /// Traducciones provisionales del par pregunta + descripcionCorta a
  /// otros locales (eu, ca). Persistido como JSON string porque Isar 3
  /// Community no soporta `Map<String, EmbeddedObject>` con tipo de
  /// valor compuesto. Vacío `'{}'` cuando no hay traducciones —
  /// retrocompatible con DBs antiguas (Isar inicializa el campo a su
  /// default, que aquí es `'{}'`).
  String traduccionesJson = '{}';

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
      ..regions = List.of(misterio.regions ?? const <String>[])
      ..cerradoPorNino = misterio.cerradoPorNino
      ..respuestaDelNino = misterio.respuestaDelNino
      ..traduccionesJson = _serializarTraducciones(misterio.traducciones);
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
      cerradoPorNino: cerradoPorNino,
      respuestaDelNino: respuestaDelNino,
      traducciones: _deserializarTraducciones(traduccionesJson),
    );
  }

  static String _serializarTraducciones(Map<String, MisterioTexto> mapa) {
    if (mapa.isEmpty) return '{}';
    final crudo = mapa.map(
      (locale, texto) => MapEntry(locale, texto.toJson()),
    );
    return jsonEncode(crudo);
  }

  static Map<String, MisterioTexto> _deserializarTraducciones(String json) {
    if (json.isEmpty || json == '{}') return const <String, MisterioTexto>{};
    try {
      final crudo = jsonDecode(json) as Map<String, dynamic>;
      return crudo.map(
        (locale, texto) => MapEntry(
          locale,
          MisterioTexto.fromJson(texto as Map<String, dynamic>),
        ),
      );
    } catch (_) {
      // JSON corrupto en disco → tratar como sin traducciones para no
      // romper el cuaderno entero. La pregunta canónica castellano
      // sigue funcionando.
      return const <String, MisterioTexto>{};
    }
  }
}

/// Espejo Isar de [PreguntaDelNino]. Estructura mucho más sencilla que
/// [MisterioIsar] porque las preguntas del niño no tienen estado,
/// estación, región ni `abierto` — siempre están abiertas hasta que el
/// niño las cierre con su respuesta.
@collection
class PreguntaDelNinoIsar {
  PreguntaDelNinoIsar();

  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String idDominio;

  late String pregunta;

  /// Cuándo el niño la formuló. Indexado para ordenar las abiertas por
  /// fecha desc sin tener que cargar todas a memoria.
  @Index()
  late DateTime formuladaEn;

  /// IDs de observaciones del niño ancladas como evidencia. Lista
  /// homogénea de strings — Isar la persiste nativa.
  List<String> observacionesIds = const <String>[];

  /// Cuándo el niño cerró la pregunta. Indexado para que el filtro
  /// "abiertas" (cerradaEn IS NULL) y el orden de las cerradas (DESC)
  /// no escaneen toda la colección.
  @Index()
  DateTime? cerradaEn;

  /// Lo que el niño anotó al cerrar. Sin texto, el cierre no es
  /// válido (validado en el dominio).
  String? respuestaDelNino;

  static PreguntaDelNinoIsar desdeDominio(PreguntaDelNino pregunta) {
    return PreguntaDelNinoIsar()
      ..idDominio = pregunta.id
      ..pregunta = pregunta.pregunta
      ..formuladaEn = pregunta.formuladaEn
      ..observacionesIds = List.of(pregunta.observacionesIds)
      ..cerradaEn = pregunta.cerradaEn
      ..respuestaDelNino = pregunta.respuestaDelNino;
  }

  PreguntaDelNino aDominio() {
    return PreguntaDelNino(
      id: idDominio,
      pregunta: pregunta,
      formuladaEn: formuladaEn,
      observacionesIds: List.of(observacionesIds),
      cerradaEn: cerradaEn,
      respuestaDelNino: respuestaDelNino,
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
