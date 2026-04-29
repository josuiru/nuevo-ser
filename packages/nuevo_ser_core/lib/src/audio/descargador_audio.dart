import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:crypto/crypto.dart' as crypto;
import 'package:http/http.dart' as http;

/// Estado de descarga del paquete sonoro. Se emite por el stream que
/// devuelve [DescargadorAudio.descargarEInstalar] para que la UI muestre
/// barra de progreso o mensaje de error sin acoplarse al motor sonoro.
sealed class EstadoDescargaAudio {
  const EstadoDescargaAudio();
}

class PreparandoDescargaAudio extends EstadoDescargaAudio {
  const PreparandoDescargaAudio();
}

class DescargandoAudio extends EstadoDescargaAudio {
  final int recibidoBytes;
  final int totalBytes;
  const DescargandoAudio(this.recibidoBytes, this.totalBytes);

  /// 0..1 — útil para una barra. -1 si el servidor no manda Content-Length.
  double get fraccion =>
      totalBytes <= 0 ? -1 : (recibidoBytes / totalBytes).clamp(0.0, 1.0);
}

class VerificandoAudio extends EstadoDescargaAudio {
  const VerificandoAudio();
}

class DescomprimiendoAudio extends EstadoDescargaAudio {
  final int archivoActual;
  final int archivosTotal;
  const DescomprimiendoAudio(this.archivoActual, this.archivosTotal);
}

class DescargaAudioCompletada extends EstadoDescargaAudio {
  final int version;
  final int archivosInstalados;
  const DescargaAudioCompletada(this.version, this.archivosInstalados);
}

class DescargaAudioFallida extends EstadoDescargaAudio {
  final String mensaje;
  const DescargaAudioFallida(this.mensaje);
}

/// Manifest que el servidor expone en
/// `/wp-json/nuevo-ser/v1/audio/manifest`.
class ManifestPaqueteAudio {
  final int version;
  final String urlPaquete;
  final String sha256Hex;
  final int tamanoBytes;

  const ManifestPaqueteAudio({
    required this.version,
    required this.urlPaquete,
    required this.sha256Hex,
    required this.tamanoBytes,
  });

  factory ManifestPaqueteAudio.fromJson(Map<String, dynamic> json) {
    return ManifestPaqueteAudio(
      version: (json['version'] as num).toInt(),
      urlPaquete: json['url'] as String,
      sha256Hex: (json['sha256'] as String).toLowerCase(),
      tamanoBytes: (json['tamano_bytes'] as num).toInt(),
    );
  }

  /// Tamaño formateado en MB con un decimal — para mostrar al niño.
  String get tamanoLegible =>
      '${(tamanoBytes / (1024 * 1024)).toStringAsFixed(1)} MB';
}

/// Cliente del paquete sonoro descargable. Pide el manifest, descarga
/// con progreso, verifica el sha256, y descomprime los archivos en la
/// ruta de cache que devuelva [rutaBaseCache]. Persiste la versión
/// instalada vía los callbacks [escribirVersion]/[leerVersion]; el
/// almacén concreto (shared_preferences, Isar, etc.) lo decide cada
/// juego.
///
/// El descargador NO conoce el motor sonoro — la coordinación
/// (detener loops antes de borrar archivos, recargar cache) la hace el
/// llamador, opcionalmente con la ayuda del callback
/// [invalidarLocalizador] que se invoca tras instalar/borrar.
class DescargadorAudio {
  final Uri urlManifest;

  /// Cabecera `Host` opcional para entornos Local WP donde el dominio
  /// virtual no resuelve y conectamos por IP+puerto con el host puesto
  /// a mano.
  final String? hostOverride;

  /// User-Agent que se envía en todas las peticiones HTTP. Algunos WAF
  /// (mod_security CRS 920330) rechazan peticiones con `User-Agent`
  /// vacío con 406, así que el caller debería pasar uno propio del
  /// juego — p. ej. `'UnoRoto/0.5 (Android)'`.
  final String userAgent;

  /// Devuelve el path absoluto donde se descomprimirán los archivos.
  /// Cada juego tiene su propia raíz (`<docs>/uroto/sonido/`,
  /// `<docs>/lasversiones/sonido/`, etc.).
  final Future<String> Function() rutaBaseCache;

  /// Lee la versión instalada localmente o `null` si nunca se descargó.
  final Future<int?> Function() leerVersion;

  /// Persiste la versión [v] instalada tras una descarga exitosa.
  final Future<void> Function(int v) escribirVersion;

  /// Borra la versión instalada del almacén (lo invoca [borrarCache]).
  final Future<void> Function() borrarVersion;

  /// Callback opcional que se invoca tras instalar y tras borrar la
  /// cache. Lo típico: el juego usa un singleton de "localizador de
  /// audio" que cachea el path base; aquí se le dice "tu cache puede
  /// estar obsoleta".
  final void Function()? invalidarLocalizador;

  final http.Client _cliente;

  DescargadorAudio({
    required this.urlManifest,
    required this.userAgent,
    required this.rutaBaseCache,
    required this.leerVersion,
    required this.escribirVersion,
    required this.borrarVersion,
    this.invalidarLocalizador,
    this.hostOverride,
    http.Client? cliente,
  }) : _cliente = cliente ?? http.Client();

  Map<String, String> _cabeceras() {
    final base = <String, String>{
      'User-Agent': userAgent,
    };
    if (hostOverride != null && hostOverride!.isNotEmpty) {
      base['Host'] = hostOverride!;
    }
    return base;
  }

  /// Devuelve el manifest del servidor o lanza si la red falla.
  Future<ManifestPaqueteAudio> obtenerManifest() async {
    final respuesta =
        await _cliente.get(urlManifest, headers: _cabeceras()).timeout(
              const Duration(seconds: 15),
            );
    if (respuesta.statusCode != 200) {
      throw HttpException(
        'manifest devolvió ${respuesta.statusCode}',
        uri: urlManifest,
      );
    }
    final cuerpo = jsonDecode(respuesta.body) as Map<String, dynamic>;
    return ManifestPaqueteAudio.fromJson(cuerpo);
  }

  /// Versión instalada localmente o `null` si nunca se descargó.
  Future<int?> versionLocal() => leerVersion();

  /// Tamaño en bytes que ocupa la cache local. 0 si está vacía o no existe.
  Future<int> tamanoCacheBytes() async {
    try {
      final base = await rutaBaseCache();
      final dir = Directory(base);
      if (!await dir.exists()) return 0;
      var total = 0;
      await for (final entidad in dir.list(recursive: true)) {
        if (entidad is File) {
          total += await entidad.length();
        }
      }
      return total;
    } catch (_) {
      return 0;
    }
  }

  /// Borra el directorio de cache. El llamador debe haber detenido los
  /// loops del motor sonoro antes para liberar los archivos.
  Future<void> borrarCache() async {
    try {
      final base = await rutaBaseCache();
      final dir = Directory(base);
      if (await dir.exists()) {
        await dir.delete(recursive: true);
      }
    } catch (_) {
      // Si no se puede borrar (archivo abierto en Windows, p.ej.),
      // dejamos pasar — el siguiente arranque reintentará.
    }
    await borrarVersion();
    invalidarLocalizador?.call();
  }

  /// Descarga el paquete del manifest y lo descomprime en la cache local.
  /// Emite estados de progreso por el stream. Garantiza que el stream
  /// termina con [DescargaAudioCompletada] o [DescargaAudioFallida].
  ///
  /// El llamador debería **detener todas las capas del motor sonoro
  /// antes de invocar este método** — extraer un OGG sobre un archivo
  /// que se está reproduciendo da resultados raros.
  Stream<EstadoDescargaAudio> descargarEInstalar(
    ManifestPaqueteAudio manifest,
  ) async* {
    File? rutaTemporalZip;
    try {
      // 1. Descargar el zip a un archivo temporal con progreso.
      final base = await rutaBaseCache();
      // El zip va a un hermano del directorio base, no dentro, para
      // que la limpieza del directorio no lo borre a media descarga.
      final dirPadre = Directory(base).parent;
      if (!await dirPadre.exists()) {
        await dirPadre.create(recursive: true);
      }
      rutaTemporalZip = File('${dirPadre.path}/audio_descarga.zip');
      if (await rutaTemporalZip.exists()) {
        await rutaTemporalZip.delete();
      }

      // En desarrollo el endpoint devuelve una URL absoluta con el
      // siteurl de WP (p. ej. `http://uno-roto.local/...`) que no es
      // resoluble desde el cliente porque éste habla por IP+puerto del
      // Local WP. Si el host del zip difiere del host del manifest,
      // forzamos el del manifest preservando el path. En producción
      // los hosts coincidirán y este reemplazo será un no-op.
      final urlOriginal = Uri.parse(manifest.urlPaquete);
      final urlEfectiva = (urlOriginal.host == urlManifest.host &&
              urlOriginal.port == urlManifest.port)
          ? urlOriginal
          : urlOriginal.replace(
              scheme: urlManifest.scheme,
              host: urlManifest.host,
              port: urlManifest.hasPort ? urlManifest.port : null,
            );
      final solicitud = http.Request('GET', urlEfectiva)
        ..headers.addAll(_cabeceras());
      final respuesta = await _cliente.send(solicitud).timeout(
            const Duration(seconds: 60),
          );
      if (respuesta.statusCode != 200) {
        yield DescargaAudioFallida(
          'descarga devolvió ${respuesta.statusCode}',
        );
        return;
      }
      final total = respuesta.contentLength ?? manifest.tamanoBytes;
      var recibido = 0;
      final salida = rutaTemporalZip.openWrite();
      try {
        await for (final chunk in respuesta.stream) {
          salida.add(chunk);
          recibido += chunk.length;
          yield DescargandoAudio(recibido, total);
        }
      } finally {
        await salida.flush();
        await salida.close();
      }

      // 2. Verificar sha256.
      yield const VerificandoAudio();
      final hashCalculado = await _calcularSha256(rutaTemporalZip);
      if (hashCalculado != manifest.sha256Hex) {
        yield const DescargaAudioFallida(
          'firma del paquete no coincide — descarga corrupta',
        );
        return;
      }

      // 3. Limpiar cache previa y descomprimir.
      final dirCache = Directory(base);
      if (await dirCache.exists()) {
        await dirCache.delete(recursive: true);
      }
      await dirCache.create(recursive: true);

      final bytesZip = await rutaTemporalZip.readAsBytes();
      final archivo = ZipDecoder().decodeBytes(bytesZip);
      final entradasArchivo = archivo.where((e) => e.isFile).toList();
      var indice = 0;
      for (final entrada in entradasArchivo) {
        indice++;
        // Sanitizar nombre — descartar entradas con `..` para evitar
        // path traversal aunque el zip venga de nuestro servidor.
        final nombre = entrada.name;
        if (nombre.contains('..') || nombre.startsWith('/')) {
          continue;
        }
        final rutaDestino = '$base/$nombre';
        final archivoDestino = File(rutaDestino);
        await archivoDestino.parent.create(recursive: true);
        await archivoDestino.writeAsBytes(entrada.content as List<int>);
        yield DescomprimiendoAudio(indice, entradasArchivo.length);
      }

      // 4. Persistir versión y limpiar.
      await escribirVersion(manifest.version);
      invalidarLocalizador?.call();
      yield DescargaAudioCompletada(manifest.version, entradasArchivo.length);
    } catch (e) {
      yield DescargaAudioFallida(e.toString());
    } finally {
      try {
        if (rutaTemporalZip != null && await rutaTemporalZip.exists()) {
          await rutaTemporalZip.delete();
        }
      } catch (_) {
        // Ignoramos — el archivo temporal puede limpiarse en el próximo
        // intento o al borrar la cache.
      }
    }
  }

  Future<String> _calcularSha256(File archivo) async {
    final salida = AccumulatorSink<crypto.Digest>();
    final entrada = crypto.sha256.startChunkedConversion(salida);
    await for (final chunk in archivo.openRead()) {
      entrada.add(chunk);
    }
    entrada.close();
    return salida.events.single.toString();
  }
}

/// Pequeño helper para acumular el digest streaming sin tirar de un
/// import extra de `convert`.
class AccumulatorSink<T> implements Sink<T> {
  final List<T> events = [];
  @override
  void add(T data) => events.add(data);
  @override
  void close() {}
}
