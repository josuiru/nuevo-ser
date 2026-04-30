import 'dart:convert';

import 'misterio.dart';
import 'observacion.dart';
import 'sit_spot.dart';

/// Información de un fichero de medios (foto/dibujo) en el momento del
/// export — la usa [ExportadorCuaderno.aJson] para construir el
/// manifiesto de medios del shape v2.
///
/// `existe` es false cuando la observación apuntaba a un fichero que
/// ya no está en disco (caso huérfano: el niño quitó la foto sin que
/// la observación se actualizara, o un export antiguo trajo una ruta
/// que se invalidó). El importador puede ignorar el medio o reportar.
class InfoMedioExportado {
  const InfoMedioExportado({
    required this.rutaRelativa,
    required this.existe,
    this.tamanoBytes,
  });

  final String rutaRelativa;
  final bool existe;
  final int? tamanoBytes;

  Map<String, Object?> toJson() => {
        'ruta_relativa': rutaRelativa,
        'existe': existe,
        if (tamanoBytes != null) 'tamano_bytes': tamanoBytes,
      };

  static InfoMedioExportado fromJson(Map<String, dynamic> json) =>
      InfoMedioExportado(
        rutaRelativa: json['ruta_relativa'] as String,
        existe: json['existe'] as bool,
        tamanoBytes: json['tamano_bytes'] as int?,
      );
}

/// Función que resuelve, para una `rutaRelativa` apuntada por una
/// observación, la información del fichero en disco al momento del
/// export. Si la implementación no puede acceder al filesystem (caso
/// test o navegador sin path_provider), devuelve `null` y el
/// exportador omite el manifiesto.
typedef ResolverMedioExportado =
    Future<InfoMedioExportado> Function(String rutaRelativa);

/// Exportador del cuaderno del niño a un formato portable. **El
/// cuaderno es del niño** (biblia §2.1) — y por tanto el niño debe
/// poder llevárselo consigo cuando deje el juego.
///
/// Formato del MVP: **JSON** versionado. Es portable, sin deps nuevas,
/// inspeccionable a ojo y permite reimportar cuando se migre a otro
/// motor.
///
/// **PDF** está apuntado en el roadmap pero requeriría añadir el
/// paquete `pdf` al pubspec — el CLAUDE.md prescribe discutir nuevas
/// dependencias antes de añadirlas, así que queda como tarea humana
/// pendiente cuando se cierre la decisión sobre tipografía/paleta de
/// impresión (doc 11 §3 sigue sin cerrarse).
///
/// **Versionado**:
/// - **v1** (S8): observaciones + sit_spot + misterios. `fotoRutaLocal`
///   y `dibujoRutaLocal` ya estaban serializadas pero sin
///   manifiesto — el shape sigue siendo aceptado para compat.
/// - **v2** (A5, post-A3+A4): añade un campo `medios` opcional con
///   `{ruta_relativa, existe, tamano_bytes}` por cada ruta apuntada
///   por las observaciones. Da al importador info para distinguir
///   medios presentes de huérfanos. Las rutas siguen siendo relativas
///   al directorio de documentos del perfil (no base64) — para portar
///   el cuaderno a otro dispositivo se hará un export-zip futuro,
///   fuera del alcance de A5.
class ExportadorCuaderno {
  /// Versión del formato actual del export.
  static const int version = 2;

  /// Versiones que [deJson] sabe leer. v1 se lee como migración
  /// silenciosa: el manifiesto de medios queda vacío.
  static const List<int> versionesSoportadas = <int>[1, 2];

  /// Serializa el cuaderno completo del niño a un string JSON
  /// indentado (legible). [exportadoEn] se inyecta para tests
  /// reproducibles. [resolverMedio], si no es null, se llama una vez
  /// por cada ruta de foto/dibujo presente en las observaciones —
  /// el resultado puebla la sección `medios` del export v2.
  static Future<String> aJson({
    required List<Observacion> observaciones,
    SitSpot? sitSpot,
    required List<Misterio> misterios,
    DateTime? exportadoEn,
    ResolverMedioExportado? resolverMedio,
  }) async {
    final fecha = (exportadoEn ?? DateTime.now()).toUtc().toIso8601String();
    final medios = await _construirManifiesto(observaciones, resolverMedio);
    final cuerpo = <String, Object?>{
      'version': version,
      'exportado_en': fecha,
      'observaciones': observaciones.map((o) => o.toJson()).toList(),
      'sit_spot': sitSpot?.toJson(),
      'misterios': misterios.map((m) => m.toJson()).toList(),
      if (medios != null) 'medios': medios.map((m) => m.toJson()).toList(),
    };
    return const JsonEncoder.withIndent('  ').convert(cuerpo);
  }

  static Future<List<InfoMedioExportado>?> _construirManifiesto(
    List<Observacion> observaciones,
    ResolverMedioExportado? resolverMedio,
  ) async {
    if (resolverMedio == null) return null;
    final rutasUnicas = <String>{};
    for (final observacion in observaciones) {
      final foto = observacion.fotoRutaLocal;
      if (foto != null && foto.isNotEmpty) rutasUnicas.add(foto);
      final dibujo = observacion.dibujoRutaLocal;
      if (dibujo != null && dibujo.isNotEmpty) rutasUnicas.add(dibujo);
    }
    final manifiesto = <InfoMedioExportado>[];
    for (final ruta in rutasUnicas) {
      manifiesto.add(await resolverMedio(ruta));
    }
    return manifiesto;
  }

  /// Re-hidrata el cuaderno desde un JSON exportado. Devuelve un
  /// objeto [CuadernoImportado] sin tocar el almacén — la decisión de
  /// fusionar/sobrescribir es del call site.
  ///
  /// Lee tanto la versión actual ([version]) como las anteriores
  /// listadas en [versionesSoportadas]. v1 se trata como v2 con
  /// `medios` vacío (las observaciones de v1 ya traen las rutas
  /// relativas en sus campos `fotoRutaLocal`/`dibujoRutaLocal`).
  ///
  /// Lanza [FormatException] si la versión no está soportada o si los
  /// campos críticos faltan.
  static CuadernoImportado deJson(String json) {
    final raiz = jsonDecode(json);
    if (raiz is! Map<String, dynamic>) {
      throw const FormatException(
        'export inválido: la raíz no es un objeto JSON',
      );
    }
    final versionEntrante = raiz['version'];
    if (versionEntrante is! int ||
        !versionesSoportadas.contains(versionEntrante)) {
      throw FormatException(
        'export con versión $versionEntrante, soportadas $versionesSoportadas',
      );
    }
    final observacionesRaw = raiz['observaciones'];
    if (observacionesRaw is! List) {
      throw const FormatException(
        'export inválido: campo "observaciones" no es lista',
      );
    }
    final misteriosRaw = raiz['misterios'];
    if (misteriosRaw is! List) {
      throw const FormatException(
        'export inválido: campo "misterios" no es lista',
      );
    }
    final sitSpotRaw = raiz['sit_spot'];
    final mediosRaw = raiz['medios'];
    final medios = mediosRaw is List
        ? mediosRaw
            .cast<Map<String, dynamic>>()
            .map(InfoMedioExportado.fromJson)
            .toList()
        : const <InfoMedioExportado>[];
    return CuadernoImportado(
      version: versionEntrante,
      exportadoEn: DateTime.parse(raiz['exportado_en'] as String),
      observaciones: observacionesRaw
          .cast<Map<String, dynamic>>()
          .map(Observacion.fromJson)
          .toList(),
      sitSpot: sitSpotRaw == null
          ? null
          : SitSpot.fromJson(sitSpotRaw as Map<String, dynamic>),
      misterios: misteriosRaw
          .cast<Map<String, dynamic>>()
          .map(Misterio.fromJson)
          .toList(),
      medios: medios,
    );
  }
}

/// Resultado de [ExportadorCuaderno.deJson]. Un descriptor inmutable —
/// no toca el almacén; el call site decide qué hacer (fusionar,
/// sobrescribir, descartar).
class CuadernoImportado {
  const CuadernoImportado({
    required this.version,
    required this.exportadoEn,
    required this.observaciones,
    required this.misterios,
    this.sitSpot,
    this.medios = const <InfoMedioExportado>[],
  });

  final int version;
  final DateTime exportadoEn;
  final List<Observacion> observaciones;
  final List<Misterio> misterios;
  final SitSpot? sitSpot;
  final List<InfoMedioExportado> medios;
}
