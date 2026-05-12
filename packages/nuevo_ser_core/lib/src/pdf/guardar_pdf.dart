import 'dart:io';

import 'package:path/path.dart' as path_lib;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

/// Guarda un documento PDF construido con `pdf/widgets` en el
/// directorio temporal de la app, con un nombre único basado en
/// el prefijo + timestamp + ".pdf". Devuelve el `File` para que
/// el llamante lo pase a `share_plus` o `printing`.
///
/// `prefijoNombre` no debe llevar la extensión; se le añade
/// internamente. Espacios y caracteres no seguros en el prefijo
/// se reemplazan por `_` para evitar problemas con visores
/// caprichosos en Android.
Future<File> guardarPdfTemporal({
  required pw.Document documento,
  required String prefijoNombre,
}) async {
  final dir = await getTemporaryDirectory();
  final ahora = DateTime.now();
  final prefijoSeguro = prefijoNombre.replaceAll(RegExp(r'[^A-Za-z0-9_\-]+'), '_');
  final nombre = '$prefijoSeguro-${ahora.millisecondsSinceEpoch}.pdf';
  final fichero = File(path_lib.join(dir.path, nombre));
  await fichero.writeAsBytes(await documento.save());
  return fichero;
}
