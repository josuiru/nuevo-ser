import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path_lib;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import '../datos/base_datos.dart';

/// Empaqueta la BD (`solera_apicola.db`) y la carpeta de fotos
/// (`<documents>/fotos/...`) en un zip listo para compartir o guardar
/// fuera del dispositivo. El archivo vive en `getTemporaryDirectory`
/// para que `share_plus` pueda adjuntarlo sin pedir permisos extra de
/// almacenamiento.
///
/// Restauración: lee un zip elegido por el usuario, lo descomprime en
/// un directorio temporal, valida que tenga `solera_apicola.db` dentro
/// y sustituye los archivos. Antes de sobrescribir, hace **un backup
/// automático del estado actual** por si la restauración va mal.
class BackupServicio {
  static const _claveUltimoBackupMs = 'solera_apicola.backup.ultimo_ms';
  static const _nombreBd = 'solera_apicola.db';

  /// Crea un zip con BD + fotos en getTemporaryDirectory. Devuelve el
  /// fichero. El caller decide si lo comparte (share_plus) o lo copia
  /// a un destino concreto.
  static Future<File> crearZip() async {
    final docs = await getApplicationDocumentsDirectory();
    final tmp = await getTemporaryDirectory();
    final ahora = DateTime.now();
    final marcaTemporal = DateFormat('yyyyMMdd-HHmm').format(ahora);
    final destino = File(path_lib.join(tmp.path, 'solera-apicola-backup-$marcaTemporal.zip'));

    // Cerramos la BD antes de empaquetar para que sqflite no mantenga
    // un lock que impida leer el .db. Se reabrirá automáticamente al
    // primer acceso después.
    await BaseDatosSoleraApicola.instancia.cerrar();

    final encoder = ZipFileEncoder();
    encoder.create(destino.path);
    try {
      for (final nombre in [_nombreBd, '$_nombreBd-wal', '$_nombreBd-shm']) {
        final f = File(path_lib.join(docs.path, nombre));
        if (await f.exists()) {
          encoder.addFile(f, nombre);
        }
      }
      final dirFotos = Directory(path_lib.join(docs.path, 'fotos'));
      if (await dirFotos.exists()) {
        encoder.addDirectory(dirFotos, includeDirName: true);
      }
    } finally {
      encoder.close();
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_claveUltimoBackupMs, ahora.millisecondsSinceEpoch);
    return destino;
  }

  /// Restaura un zip generado por `crearZip`. Antes de tocar nada, hace
  /// un backup del estado actual ("backup-pre-restore-...") por si la
  /// restauración deja la app inconsistente. Devuelve el fichero del
  /// backup pre-restore para que el usuario lo conserve si lo desea.
  static Future<File> restaurarZip(File zipOrigen) async {
    if (!await zipOrigen.exists()) {
      throw Exception('El fichero de backup no existe: ${zipOrigen.path}');
    }

    final bytes = await zipOrigen.readAsBytes();
    final archive = ZipDecoder().decodeBytes(bytes);
    final tieneBd = archive.any((f) => f.name == _nombreBd);
    if (!tieneBd) {
      throw Exception(
        'El zip no contiene $_nombreBd — no parece un backup de Solera Apícola.',
      );
    }

    final preRestore = await crearZip();

    await BaseDatosSoleraApicola.instancia.cerrar();
    final docs = await getApplicationDocumentsDirectory();
    for (final nombre in [_nombreBd, '$_nombreBd-wal', '$_nombreBd-shm']) {
      final f = File(path_lib.join(docs.path, nombre));
      if (await f.exists()) await f.delete();
    }
    for (final entrada in archive) {
      if (!entrada.isFile) continue;
      final destino = File(path_lib.join(docs.path, entrada.name));
      await destino.parent.create(recursive: true);
      final contenido = entrada.content as List<int>;
      await destino.writeAsBytes(contenido);
    }
    return preRestore;
  }

  /// Devuelve el timestamp del último backup hecho, null si ninguno.
  static Future<DateTime?> ultimoBackup() async {
    final prefs = await SharedPreferences.getInstance();
    final ms = prefs.getInt(_claveUltimoBackupMs);
    if (ms == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(ms);
  }

  /// True si han pasado más días que `intervaloAviso` desde el último
  /// backup. Default 7 días. La pantalla principal puede usar esto para
  /// sugerir hacer backup, pero **nunca** ejecutarlo automáticamente —
  /// backup destructivo silencioso es mala idea.
  static Future<bool> tocaSugerir({Duration intervaloAviso = const Duration(days: 7)}) async {
    final ultimo = await ultimoBackup();
    if (ultimo == null) return true;
    return DateTime.now().difference(ultimo) > intervaloAviso;
  }

  /// Helper para reabrir la BD tras restore. No es estrictamente
  /// necesario (el getter `basedatos` del singleton recrea
  /// automáticamente al primer acceso), pero deja explícito el flujo.
  static Future<Database> reabrirBaseDatos() => BaseDatosSoleraApicola.instancia.basedatos;
}
