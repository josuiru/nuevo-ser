import 'dart:io';

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

  test('extensión del origen .JPG normalizada a minúsculas', () async {
    final origen = await crearOrigen('FOTO.JPG');

    final rutaRelativa = await almacenador.guardar(
      rutaOrigen: origen.path,
      observacionId: 'obs-008',
      tipo: TipoMedio.foto,
    );

    expect(rutaRelativa.endsWith('.jpg'), isTrue);
  });
}
