import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:nuevo_ser_core/nuevo_ser_core.dart';
import 'package:path/path.dart' as path_lib;

/// Tests de caracterización de `GestorFotos`. Cubren los métodos
/// puros (codificar/decodificar) y el método de I/O (borrarSiExiste).
/// El método `tomarOSeleccionar` depende del plugin `image_picker`
/// y queda fuera del alcance de los tests unitarios — patrón
/// estándar en Flutter. Estos 15 tests viajaron desde `apps/agro`
/// con la extracción del módulo al core.
void main() {
  group('GestorFotos.codificar', () {
    test('lista vacía → "[]"', () {
      expect(GestorFotos.codificar(const []), '[]');
    });

    test('una ruta', () {
      expect(GestorFotos.codificar(const ['/tmp/foto.jpg']), '["/tmp/foto.jpg"]');
    });

    test('varias rutas preserva orden', () {
      expect(
        GestorFotos.codificar(const ['/a.jpg', '/b.jpg', '/c.jpg']),
        '["/a.jpg","/b.jpg","/c.jpg"]',
      );
    });
  });

  group('GestorFotos.decodificar', () {
    test('null → lista vacía', () {
      expect(GestorFotos.decodificar(null), const <String>[]);
    });

    test('cadena vacía → lista vacía', () {
      expect(GestorFotos.decodificar(''), const <String>[]);
    });

    test('"[]" → lista vacía', () {
      expect(GestorFotos.decodificar('[]'), const <String>[]);
    });

    test('lista de strings JSON válida', () {
      expect(
        GestorFotos.decodificar('["/a.jpg","/b.jpg"]'),
        ['/a.jpg', '/b.jpg'],
      );
    });

    test('JSON corrupto → lista vacía (auto-curación)', () {
      expect(GestorFotos.decodificar('no es json'), const <String>[]);
    });

    test('JSON válido pero no es lista → lista vacía', () {
      expect(GestorFotos.decodificar('{"clave":"valor"}'), const <String>[]);
    });

    test('lista mixta: filtra los que no son string', () {
      expect(
        GestorFotos.decodificar('["/a.jpg",42,null,"/b.jpg"]'),
        ['/a.jpg', '/b.jpg'],
      );
    });
  });

  group('GestorFotos.borrarSiExiste', () {
    late Directory directorioTemporal;

    setUp(() {
      directorioTemporal = Directory.systemTemp.createTempSync('gestor_fotos_test_');
    });

    tearDown(() {
      if (directorioTemporal.existsSync()) {
        directorioTemporal.deleteSync(recursive: true);
      }
    });

    test('archivo existente queda borrado', () async {
      final fichero = File(path_lib.join(directorioTemporal.path, 'foto.jpg'));
      fichero.writeAsBytesSync([1, 2, 3]);
      expect(fichero.existsSync(), true);

      await GestorFotos.borrarSiExiste(fichero.path);

      expect(fichero.existsSync(), false);
    });

    test('ruta inexistente: no lanza', () async {
      final rutaQueNoExiste = path_lib.join(directorioTemporal.path, 'fantasma.jpg');

      await GestorFotos.borrarSiExiste(rutaQueNoExiste);

      expect(File(rutaQueNoExiste).existsSync(), false);
    });

    test('ruta inválida: no lanza (idempotente, política heredada)', () async {
      // Doble null-byte fuerza un error de I/O en la mayoría de Linux.
      // El gestor lo silencia para no bloquear al usuario por algo no
      // crítico — la fila de la BD ya se borró antes.
      await GestorFotos.borrarSiExiste('/proc/1/imposible/ bad');
      // Si llegamos aquí sin excepción, pasa.
      expect(true, true);
    });
  });

  group('GestorFotos.codificar / decodificar — round-trip', () {
    test('lista vacía sobrevive', () {
      final original = <String>[];
      final ida = GestorFotos.codificar(original);
      final vuelta = GestorFotos.decodificar(ida);
      expect(vuelta, original);
    });

    test('lista de varias rutas sobrevive', () {
      final original = ['/foto1.jpg', '/sub/dir/foto2.png', '/foto con espacios.jpg'];
      final ida = GestorFotos.codificar(original);
      final vuelta = GestorFotos.decodificar(ida);
      expect(vuelta, original);
    });
  });
}
