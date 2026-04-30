import 'dart:io';
import 'dart:typed_data';

import 'package:el_cuaderno/datos/almacenador_medios.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late Directory dirRaiz;
  late AlmacenadorMedios almacenador;

  setUp(() async {
    dirRaiz = await Directory.systemTemp.createTemp('el_cuaderno_medios_test_');
    almacenador = AlmacenadorMedios(proveedorDirRaiz: () async => dirRaiz);
  });

  tearDown(() async {
    if (await dirRaiz.exists()) {
      await dirRaiz.delete(recursive: true);
    }
  });

  Future<File> crearOrigen(String nombre, [String contenido = 'foto']) async {
    final origen = File('${dirRaiz.path}/$nombre');
    await origen.writeAsString(contenido);
    return origen;
  }

  test('guardar(foto) copia el fichero a medios/<id>_foto.<ext>', () async {
    final origen = await crearOrigen('camara_temporal.jpg', 'bytes-foto');

    final rutaRelativa = await almacenador.guardar(
      rutaOrigen: origen.path,
      observacionId: 'obs-001',
      tipo: TipoMedio.foto,
    );

    expect(rutaRelativa, 'medios/obs-001_foto.jpg');
    final destino = File('${dirRaiz.path}/$rutaRelativa');
    expect(await destino.exists(), isTrue);
    expect(await destino.readAsString(), 'bytes-foto');
  });

  test('guardar(dibujo) usa sufijo dibujo y extensión PNG por defecto',
      () async {
    final origen = await crearOrigen('dibujo_temporal');

    final rutaRelativa = await almacenador.guardar(
      rutaOrigen: origen.path,
      observacionId: 'obs-002',
      tipo: TipoMedio.dibujo,
    );

    expect(rutaRelativa, 'medios/obs-002_dibujo.png');
  });

  test('guardar() crea el subdirectorio "medios" si no existe', () async {
    final origen = await crearOrigen('foo.jpeg');
    final dirMedios = Directory('${dirRaiz.path}/medios');
    expect(await dirMedios.exists(), isFalse);

    await almacenador.guardar(
      rutaOrigen: origen.path,
      observacionId: 'obs-003',
      tipo: TipoMedio.foto,
    );

    expect(await dirMedios.exists(), isTrue);
  });

  test('guardar() sobreescribe si la observación ya tenía foto', () async {
    final primeraOrigen = await crearOrigen('primera.jpg', 'bytes-uno');
    await almacenador.guardar(
      rutaOrigen: primeraOrigen.path,
      observacionId: 'obs-004',
      tipo: TipoMedio.foto,
    );

    final segundaOrigen = await crearOrigen('segunda.jpg', 'bytes-dos');
    final rutaRelativa = await almacenador.guardar(
      rutaOrigen: segundaOrigen.path,
      observacionId: 'obs-004',
      tipo: TipoMedio.foto,
    );

    final destino = File('${dirRaiz.path}/$rutaRelativa');
    expect(await destino.readAsString(), 'bytes-dos');
  });

  test('guardar() lanza ArgumentError si el origen no existe', () async {
    expect(
      () => almacenador.guardar(
        rutaOrigen: '${dirRaiz.path}/no-existe.jpg',
        observacionId: 'obs-005',
        tipo: TipoMedio.foto,
      ),
      throwsArgumentError,
    );
  });

  test('resolverAbsoluta() concatena dirRaiz + rutaRelativa', () async {
    final ruta = await almacenador.resolverAbsoluta('medios/obs-006_foto.jpg');
    expect(ruta, '${dirRaiz.path}/medios/obs-006_foto.jpg');
  });

  test('borrar() elimina el fichero apuntado', () async {
    final origen = await crearOrigen('para_borrar.jpg', 'x');
    final rutaRelativa = await almacenador.guardar(
      rutaOrigen: origen.path,
      observacionId: 'obs-007',
      tipo: TipoMedio.foto,
    );
    final destino = File('${dirRaiz.path}/$rutaRelativa');
    expect(await destino.exists(), isTrue);

    await almacenador.borrar(rutaRelativa);
    expect(await destino.exists(), isFalse);
  });

  test('borrar() es idempotente — no falla si el fichero ya no estaba',
      () async {
    await almacenador.borrar('medios/inexistente.jpg');
    // sin assert: lo que verifica el test es que no lanza.
  });

  test('guardarBytes(dibujo) escribe los bytes a medios/<id>_dibujo.png',
      () async {
    final bytes = Uint8List.fromList([0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A]);

    final rutaRelativa = await almacenador.guardarBytes(
      bytes: bytes,
      observacionId: 'obs-bytes-001',
      tipo: TipoMedio.dibujo,
    );

    expect(rutaRelativa, 'medios/obs-bytes-001_dibujo.png');
    final destino = File('${dirRaiz.path}/$rutaRelativa');
    expect(await destino.exists(), isTrue);
    expect(await destino.readAsBytes(), bytes);
  });

  test('guardarBytes() crea el subdirectorio si no existe', () async {
    final dirMedios = Directory('${dirRaiz.path}/medios');
    expect(await dirMedios.exists(), isFalse);

    await almacenador.guardarBytes(
      bytes: Uint8List.fromList([1, 2, 3]),
      observacionId: 'obs-bytes-002',
      tipo: TipoMedio.dibujo,
    );

    expect(await dirMedios.exists(), isTrue);
  });

  test('guardarBytes() sobreescribe si ya había dibujo previo', () async {
    await almacenador.guardarBytes(
      bytes: Uint8List.fromList([0x01, 0x02]),
      observacionId: 'obs-bytes-003',
      tipo: TipoMedio.dibujo,
    );
    final rutaRelativa = await almacenador.guardarBytes(
      bytes: Uint8List.fromList([0xFF, 0xEE, 0xDD]),
      observacionId: 'obs-bytes-003',
      tipo: TipoMedio.dibujo,
    );

    final destino = File('${dirRaiz.path}/$rutaRelativa');
    expect(await destino.readAsBytes(), [0xFF, 0xEE, 0xDD]);
  });

  test('extensión del origen .JPG normalizada a minúsculas', () async {
    final origen = await crearOrigen('FOTO.JPG');

    final rutaRelativa = await almacenador.guardar(
      rutaOrigen: origen.path,
      observacionId: 'obs-008',
      tipo: TipoMedio.foto,
    );

    expect(rutaRelativa.endsWith('.jpg'), isTrue);
  });

  test('borrarTodo en directorio inexistente devuelve 0 sin error', () async {
    expect(await almacenador.borrarTodo(), 0);
  });

  test('borrarTodo purga el subdirectorio y devuelve el count de ficheros',
      () async {
    // Sembramos tres ficheros (dos fotos + un dibujo).
    await almacenador.guardar(
      rutaOrigen: (await crearOrigen('a.jpg')).path,
      observacionId: 'obs-1',
      tipo: TipoMedio.foto,
    );
    await almacenador.guardar(
      rutaOrigen: (await crearOrigen('b.jpg')).path,
      observacionId: 'obs-2',
      tipo: TipoMedio.foto,
    );
    await almacenador.guardarBytes(
      bytes: Uint8List.fromList([1, 2, 3]),
      observacionId: 'obs-3',
      tipo: TipoMedio.dibujo,
    );
    final dirMedios = Directory('${dirRaiz.path}/medios');
    expect(await dirMedios.exists(), isTrue);

    final borrados = await almacenador.borrarTodo();

    expect(borrados, 3);
    expect(await dirMedios.exists(), isFalse);
  });

  test('borrarTodo es idempotente: dos llamadas seguidas no fallan',
      () async {
    await almacenador.guardarBytes(
      bytes: Uint8List.fromList([0xAA]),
      observacionId: 'obs-1',
      tipo: TipoMedio.dibujo,
    );
    expect(await almacenador.borrarTodo(), 1);
    expect(await almacenador.borrarTodo(), 0);
  });
}
