import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';

/// Mueve los ficheros de medios (fotos hechas por la cámara, fotos
/// elegidas de la galería, dibujos hechos en el lienzo) al directorio
/// privado de la app y devuelve una **ruta relativa** al directorio de
/// documentos para persistirla en `Observacion.fotoRutaLocal` o
/// `Observacion.dibujoRutaLocal`.
///
/// Por qué relativa y no absoluta: Android puede mover el directorio
/// de datos de la app entre actualizaciones (sandbox UUID); las rutas
/// absolutas se vuelven inválidas. Una ruta relativa
/// (`medios/<id>_foto.jpg`) sigue resolviéndose correctamente con
/// [resolverAbsoluta] tras una reinstalación, una migración del
/// dispositivo o un export/import del cuaderno (`ExportadorCuaderno`
/// v2 — A5).
///
/// El almacenador NO toca red ni copia a ningún servicio externo —
/// la frontera de privacidad estructural lo prohíbe (política §2).
/// Las imágenes solo viajan al servidor cuando el adulto active opt-in
/// y, aún entonces, solo viajan los **agregados sin texto libre**
/// (política §4); las fotos en sí mismas siguen siendo locales.
class AlmacenadorMedios {
  /// Provee el directorio raíz donde se guardan los medios. En la app
  /// real este es `getApplicationDocumentsDirectory()`. En tests se
  /// inyecta un directorio temporal para no tocar el filesystem real
  /// del usuario.
  AlmacenadorMedios({Future<Directory> Function()? proveedorDirRaiz})
      : _proveedorDirRaiz = proveedorDirRaiz ?? getApplicationDocumentsDirectory;

  final Future<Directory> Function() _proveedorDirRaiz;

  /// Subdirectorio bajo el directorio raíz donde se almacenan los
  /// medios. Estable para que la ruta relativa persistida sobreviva
  /// reinstalaciones.
  static const String subdirectorioMedios = 'medios';

  /// Copia [rutaOrigen] al subdirectorio de medios con un nombre
  /// derivado de [observacionId] y [tipo]. Devuelve la ruta relativa
  /// al directorio raíz (p. ej. `medios/abc123_foto.jpg`).
  ///
  /// Si ya existía un fichero en el destino (caso de una observación
  /// que se edita y se le cambia la foto), se sobrescribe — el sistema
  /// no necesita historial de fotos por observación.
  Future<String> guardar({
    required String rutaOrigen,
    required String observacionId,
    required TipoMedio tipo,
  }) async {
    final ficheroOrigen = File(rutaOrigen);
    if (!await ficheroOrigen.exists()) {
      throw ArgumentError.value(
        rutaOrigen,
        'rutaOrigen',
        'el fichero de origen no existe',
      );
    }

    final dirRaiz = await _proveedorDirRaiz();
    final dirMedios = Directory('${dirRaiz.path}/$subdirectorioMedios');
    if (!await dirMedios.exists()) {
      await dirMedios.create(recursive: true);
    }

    final extension = _extraerExtension(rutaOrigen, tipo);
    final nombreFichero = '${observacionId}_${tipo.sufijo}$extension';
    final rutaAbsolutaDestino = '${dirMedios.path}/$nombreFichero';

    await ficheroOrigen.copy(rutaAbsolutaDestino);

    return '$subdirectorioMedios/$nombreFichero';
  }

  /// Variante de [guardar] para bytes ya en memoria — el caso típico
  /// es el PNG renderizado por `RepaintBoundary.toImage()` del lienzo
  /// de dibujo (A4). No hay fichero de origen, así que la extensión
  /// se deriva siempre de `tipo.extensionPredeterminada`.
  Future<String> guardarBytes({
    required Uint8List bytes,
    required String observacionId,
    required TipoMedio tipo,
  }) async {
    final dirRaiz = await _proveedorDirRaiz();
    final dirMedios = Directory('${dirRaiz.path}/$subdirectorioMedios');
    if (!await dirMedios.exists()) {
      await dirMedios.create(recursive: true);
    }
    final nombreFichero =
        '${observacionId}_${tipo.sufijo}${tipo.extensionPredeterminada}';
    final rutaAbsolutaDestino = '${dirMedios.path}/$nombreFichero';
    await File(rutaAbsolutaDestino).writeAsBytes(bytes, flush: true);
    return '$subdirectorioMedios/$nombreFichero';
  }

  /// Reconstruye la ruta absoluta a partir de una [rutaRelativa]
  /// previamente devuelta por [guardar]. La pantalla que muestra la
  /// foto la usa para `Image.file()`.
  Future<String> resolverAbsoluta(String rutaRelativa) async {
    final dirRaiz = await _proveedorDirRaiz();
    return '${dirRaiz.path}/$rutaRelativa';
  }

  /// Borra el fichero apuntado por [rutaRelativa] si existe. No es un
  /// error que el fichero ya no esté — el resultado del borrado es
  /// idempotente.
  Future<void> borrar(String rutaRelativa) async {
    final rutaAbsoluta = await resolverAbsoluta(rutaRelativa);
    final fichero = File(rutaAbsoluta);
    if (await fichero.exists()) {
      await fichero.delete();
    }
  }

  /// Borra el subdirectorio entero de medios (fotos + dibujos). Lo
  /// invoca el flujo "borrar mi cuaderno" tras `borrarTodoLoLocal` —
  /// sin esto, las fotos y dibujos quedaban huérfanos en disco
  /// aunque las observaciones que los apuntaban ya no existieran.
  ///
  /// Idempotente: si el directorio no existe (cuaderno virgen, ya
  /// borrado antes), no es error. Devuelve el número de ficheros
  /// borrados para feedback honesto en el snackbar.
  Future<int> borrarTodo() async {
    final dirRaiz = await _proveedorDirRaiz();
    final dirMedios = Directory('${dirRaiz.path}/$subdirectorioMedios');
    if (!await dirMedios.exists()) return 0;
    final entradas = dirMedios.listSync();
    final ficheros = entradas.whereType<File>().length;
    await dirMedios.delete(recursive: true);
    return ficheros;
  }

  /// Extrae la extensión (con punto) del fichero de origen. Si no la
  /// tiene, cae al default razonable según el [tipo] (`.jpg` para foto,
  /// `.png` para dibujo).
  String _extraerExtension(String rutaOrigen, TipoMedio tipo) {
    final ultimoPunto = rutaOrigen.lastIndexOf('.');
    final ultimaBarra = rutaOrigen.lastIndexOf('/');
    if (ultimoPunto > ultimaBarra && ultimoPunto < rutaOrigen.length - 1) {
      return rutaOrigen.substring(ultimoPunto).toLowerCase();
    }
    return tipo.extensionPredeterminada;
  }
}

/// Discrimina entre los dos tipos de media que el cuaderno guarda. La
/// extensión predeterminada se usa cuando el origen no tiene
/// extensión reconocible — fotos suelen tenerla (cámaras, galería),
/// dibujos vienen del lienzo en PNG.
enum TipoMedio {
  foto(sufijo: 'foto', extensionPredeterminada: '.jpg'),
  dibujo(sufijo: 'dibujo', extensionPredeterminada: '.png');

  const TipoMedio({
    required this.sufijo,
    required this.extensionPredeterminada,
  });

  final String sufijo;
  final String extensionPredeterminada;
}
