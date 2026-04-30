import 'dart:convert';

import 'misterio.dart';
import 'observacion.dart';
import 'sit_spot.dart';

/// Exportador del cuaderno del niño a un formato portable. **El
/// cuaderno es del niño** (biblia §2.1) — y por tanto el niño debe
/// poder llevárselo consigo cuando deje el juego.
///
/// Formato del MVP: **JSON** versionado. Es portable, sin deps nuevas,
/// inspeccionable a ojo y permite reimportar cuando se migre a Isar
/// nativo (S2 había decidido Isar pero el bootstrap aún usa
/// repositorio en memoria) o a otro motor.
///
/// **PDF** está apuntado en el roadmap pero requeriría añadir el
/// paquete `pdf` al pubspec — el CLAUDE.md prescribe discutir nuevas
/// dependencias antes de añadirlas, así que queda como tarea humana
/// pendiente cuando se cierre la decisión sobre tipografía/paleta de
/// impresión (doc 11 §3 sigue sin cerrarse).
class ExportadorCuaderno {
  /// Versión del formato del export. Bumpar cuando cambie el shape:
  /// el importador tiene que poder distinguir.
  static const int version = 1;

  /// Serializa el cuaderno completo del niño a un string JSON
  /// indentado (legible). [exportadoEn] se inyecta para tests
  /// reproducibles; en producción se deja default y se usa
  /// `DateTime.now()`.
  static String aJson({
    required List<Observacion> observaciones,
    SitSpot? sitSpot,
    required List<Misterio> misterios,
    DateTime? exportadoEn,
  }) {
    final fecha = (exportadoEn ?? DateTime.now()).toUtc().toIso8601String();
    final cuerpo = <String, Object?>{
      'version': version,
      'exportado_en': fecha,
      'observaciones': observaciones.map((o) => o.toJson()).toList(),
      'sit_spot': sitSpot?.toJson(),
      'misterios': misterios.map((m) => m.toJson()).toList(),
    };
    return const JsonEncoder.withIndent('  ').convert(cuerpo);
  }

  /// Re-hidrata el cuaderno desde un JSON exportado. Devuelve un
  /// objeto [CuadernoImportado] sin tocar el almacén — la decisión de
  /// fusionar/sobrescribir es del call site.
  ///
  /// Lanza [FormatException] si el JSON no tiene la versión esperada o
  /// si los campos críticos (observaciones, misterios) faltan.
  static CuadernoImportado deJson(String json) {
    final raiz = jsonDecode(json);
    if (raiz is! Map<String, dynamic>) {
      throw const FormatException(
        'export inválido: la raíz no es un objeto JSON',
      );
    }
    final versionEntrante = raiz['version'];
    if (versionEntrante != version) {
      throw FormatException(
        'export con versión $versionEntrante, esperaba $version',
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
    return CuadernoImportado(
      version: versionEntrante as int,
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
  });

  final int version;
  final DateTime exportadoEn;
  final List<Observacion> observaciones;
  final List<Misterio> misterios;
  final SitSpot? sitSpot;
}
