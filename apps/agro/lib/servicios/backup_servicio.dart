import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path_lib;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:sqflite/sqflite.dart';

import '../datos/base_datos.dart';

/// Empaqueta la BD (`agro.db`) y la carpeta de fotos
/// (`<documents>/fotos/...`) en un zip listo para compartir o guardar
/// fuera del dispositivo. Patrón heredado del monorepo: el archivo
/// vive en `getTemporaryDirectory` para que `share_plus` pueda
/// adjuntarlo sin pedir permisos extra de almacenamiento.
///
/// Restauración: lee un zip elegido por el usuario, lo descomprime en
/// un directorio temporal, valida que tenga `agro.db` dentro y
/// sustituye los archivos. Antes de sobrescribir, hace **un backup
/// automático del estado actual** por si la restauración va mal.
class BackupServicio {
  static const _claveUltimoBackupMs = 'agro.backup.ultimo_ms';
  static const _claveAvisoIntervaloMs = 'agro.backup.intervalo_aviso_ms';

  /// Crea un zip con BD + fotos en getTemporaryDirectory. Devuelve el
  /// fichero. El caller decide si lo comparte (share_plus) o lo copia
  /// a un destino concreto.
  static Future<File> crearZip() async {
    final docs = await getApplicationDocumentsDirectory();
    final tmp = await getTemporaryDirectory();
    final ahora = DateTime.now();
    final marcaTemporal = DateFormat('yyyyMMdd-HHmm').format(ahora);
    final destino = File(path_lib.join(tmp.path, 'solera-backup-$marcaTemporal.zip'));

    // Cerramos la BD antes de empaquetar para que sqflite no mantenga
    // un lock que impida leer el .db. Se reabrirá automáticamente al
    // primer acceso después.
    await BaseDatosAgro.instancia.cerrar();

    final encoder = ZipFileEncoder();
    encoder.create(destino.path);
    try {
      // BD principal (también -wal y -shm si existen, son los logs WAL).
      for (final nombre in const ['agro.db', 'agro.db-wal', 'agro.db-shm']) {
        final f = File(path_lib.join(docs.path, nombre));
        if (await f.exists()) {
          encoder.addFile(f, nombre);
        }
      }
      // Carpeta de fotos.
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

  /// Restaura un zip generado por `crearZip`. Antes de tocar nada,
  /// hace un backup del estado actual ("backup-pre-restore-...") por
  /// si la restauración deja la app inconsistente.
  ///
  /// Si la restauración falla a mitad, intenta auto-rollback desde el
  /// preRestore para no dejar la app con una BD parcialmente borrada.
  /// Si el rollback también falla, propaga el error original junto con
  /// la ruta del preRestore para que el usuario pueda restaurar a
  /// mano. En caso de éxito devuelve el fichero del preRestore por si
  /// el usuario quiere conservarlo.
  static Future<File> restaurarZip(File zipOrigen) async {
    if (!await zipOrigen.exists()) {
      throw Exception('El fichero de backup no existe: ${zipOrigen.path}');
    }

    final bytes = await zipOrigen.readAsBytes();
    final archive = ZipDecoder().decodeBytes(bytes);
    final tieneBd = archive.any((f) => f.name == 'agro.db');
    if (!tieneBd) {
      throw Exception('El zip no contiene agro.db — no parece un backup de Solera.');
    }

    final preRestore = await crearZip();
    final docs = await getApplicationDocumentsDirectory();

    try {
      await BaseDatosAgro.instancia.cerrar();
      for (final nombre in const ['agro.db', 'agro.db-wal', 'agro.db-shm']) {
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
    } catch (errorRestauracion) {
      // Restauración a media → intentamos rollback al estado previo
      // descomprimiendo el preRestore por encima de lo que haya quedado.
      try {
        final bytesPre = await preRestore.readAsBytes();
        final archivePre = ZipDecoder().decodeBytes(bytesPre);
        for (final nombre in const ['agro.db', 'agro.db-wal', 'agro.db-shm']) {
          final f = File(path_lib.join(docs.path, nombre));
          if (await f.exists()) await f.delete();
        }
        for (final entrada in archivePre) {
          if (!entrada.isFile) continue;
          final destino = File(path_lib.join(docs.path, entrada.name));
          await destino.parent.create(recursive: true);
          final contenido = entrada.content as List<int>;
          await destino.writeAsBytes(contenido);
        }
        // Rollback OK: preRestore ya cumplió su función, lo borramos
        // para no dejar zips huérfanos en /tmp.
        try {
          await preRestore.delete();
        } catch (_) {}
        throw Exception(
          'La restauración falló y se ha vuelto al estado previo. '
          'Causa original: $errorRestauracion',
        );
      } catch (_) {
        // Rollback también falló: dejamos el preRestore como salvavidas
        // y propagamos el error con su ruta para que el usuario pueda
        // restaurarlo manualmente.
        throw Exception(
          'La restauración falló y el rollback automático tampoco pudo '
          'completarse. Tu estado previo queda en: ${preRestore.path}. '
          'Causa original: $errorRestauracion',
        );
      }
    }
  }

  /// Devuelve el timestamp del último backup hecho, null si ninguno.
  static Future<DateTime?> ultimoBackup() async {
    final prefs = await SharedPreferences.getInstance();
    final ms = prefs.getInt(_claveUltimoBackupMs);
    if (ms == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(ms);
  }

  /// True si han pasado más días que `intervaloAviso` desde el último
  /// backup. Default 7 días. La pantalla "Hoy" o ajustes pueden usar
  /// esto para sugerir hacer backup, pero **nunca** ejecutarlo
  /// automáticamente — backup destructivo silencioso es mala idea.
  static Future<bool> tocaSugerir({Duration intervaloAviso = const Duration(days: 7)}) async {
    final ultimo = await ultimoBackup();
    if (ultimo == null) return true;
    return DateTime.now().difference(ultimo) > intervaloAviso;
  }

  /// Usuario decide cada cuánto quiere que la app le sugiera backup.
  static Future<void> guardarIntervaloAviso(Duration intervalo) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_claveAvisoIntervaloMs, intervalo.inMilliseconds);
  }

  /// Helper para obtener BD recreada tras restore. No es estrictamente
  /// necesario (el getter `basedatos` del singleton recrea
  /// automáticamente al primer acceso), pero deja explícito el flujo.
  static Future<Database> reabrirBaseDatos() => BaseDatosAgro.instancia.basedatos;
}
