import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path_lib;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../datos/base_datos.dart';

class BackupServicioQuesera {
  static const _claveUltimoBackupMs =
      'solera_quesera.backup.ultimo_ms';
  static const _nombreBd = 'solera_quesera.db';

  static Future<File> crearZip() async {
    final docs = await getApplicationDocumentsDirectory();
    final tmp = await getTemporaryDirectory();
    final ahora = DateTime.now();
    final marcaTemporal =
        DateFormat('yyyyMMdd-HHmm').format(ahora);
    final destino = File(path_lib.join(tmp.path,
        'solera-quesera-backup-$marcaTemporal.zip'));

    await BaseDatosSoleraQuesera.instancia.cerrar();

    final encoder = ZipFileEncoder();
    encoder.create(destino.path);
    try {
      for (final nombre in [
        _nombreBd,
        '$_nombreBd-wal',
        '$_nombreBd-shm'
      ]) {
        final f = File(path_lib.join(docs.path, nombre));
        if (await f.exists()) encoder.addFile(f, nombre);
      }
      final dirFotos =
          Directory(path_lib.join(docs.path, 'fotos'));
      if (await dirFotos.exists()) {
        encoder.addDirectory(dirFotos, includeDirName: true);
      }
    } finally {
      encoder.close();
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(
        _claveUltimoBackupMs, ahora.millisecondsSinceEpoch);
    return destino;
  }

  static Future<File> restaurarZip(File zipOrigen) async {
    if (!await zipOrigen.exists()) {
      throw Exception(
          'El fichero de backup no existe: ${zipOrigen.path}');
    }
    final bytes = await zipOrigen.readAsBytes();
    final archive = ZipDecoder().decodeBytes(bytes);
    final tieneBd =
        archive.any((f) => f.name == _nombreBd);
    if (!tieneBd) {
      throw Exception(
        'El zip no contiene $_nombreBd — no parece un backup '
        'de Solera Quesera.',
      );
    }
    final preRestore = await crearZip();
    await BaseDatosSoleraQuesera.instancia.cerrar();
    final docs = await getApplicationDocumentsDirectory();
    for (final nombre in [
      _nombreBd,
      '$_nombreBd-wal',
      '$_nombreBd-shm'
    ]) {
      final f = File(path_lib.join(docs.path, nombre));
      if (await f.exists()) await f.delete();
    }
    for (final entrada in archive) {
      if (!entrada.isFile) continue;
      final destino =
          File(path_lib.join(docs.path, entrada.name));
      await destino.parent.create(recursive: true);
      final contenido = entrada.content as List<int>;
      await destino.writeAsBytes(contenido);
    }
    return preRestore;
  }

  static Future<DateTime?> ultimoBackup() async {
    final prefs = await SharedPreferences.getInstance();
    final ms = prefs.getInt(_claveUltimoBackupMs);
    if (ms == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(ms);
  }

  static Future<bool> tocaSugerir({
    Duration intervaloAviso = const Duration(days: 7),
  }) async {
    final ultimo = await ultimoBackup();
    if (ultimo == null) return true;
    return DateTime.now().difference(ultimo) > intervaloAviso;
  }
}
