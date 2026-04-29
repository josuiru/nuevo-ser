import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:las_versiones/datos/repositorio_cuaderno.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('RepositorioCuaderno', () {
    test('tieneEntrada devuelve false en almacén limpio', () async {
      final repositorio = const RepositorioCuaderno();
      expect(await repositorio.tieneEntrada('cuaderno.1.0.3'), isFalse);
    });

    test('registrarEntrada y leer la marca', () async {
      final repositorio = const RepositorioCuaderno();
      await repositorio.registrarEntrada('cuaderno.1.0.3');
      expect(await repositorio.tieneEntrada('cuaderno.1.0.3'), isTrue);
    });

    test('registrarEntrada es idempotente', () async {
      final repositorio = const RepositorioCuaderno();
      await repositorio.registrarEntrada('cuaderno.1.0.3');
      await repositorio.registrarEntrada('cuaderno.1.0.3');
      expect(await repositorio.tieneEntrada('cuaderno.1.0.3'), isTrue);
      expect(
        (await repositorio.idsRegistrados()).length,
        1,
        reason: 'una sola entrada aunque se registre dos veces',
      );
    });

    test('idsRegistrados devuelve sólo entradas con bool true', () async {
      SharedPreferences.setMockInitialValues({
        'nuevoser.lasversiones.cuaderno.entrada.cuaderno.1.0.3': true,
        'nuevoser.lasversiones.cuaderno.entrada.cuaderno.1.1.7': true,
        // Una entrada explícitamente en false (caso teórico): no se
        // considera activa.
        'nuevoser.lasversiones.cuaderno.entrada.cuaderno.X': false,
      });
      final repositorio = const RepositorioCuaderno();
      final ids = await repositorio.idsRegistrados();
      expect(ids, equals({'cuaderno.1.0.3', 'cuaderno.1.1.7'}));
    });

    test('clave persistida lleva el namespace '
        'nuevoser.lasversiones.cuaderno.entrada.*', () async {
      final repositorio = const RepositorioCuaderno();
      await repositorio.registrarEntrada('cuaderno.1.0.3');
      final prefs = await SharedPreferences.getInstance();
      expect(
        prefs.getBool(
          'nuevoser.lasversiones.cuaderno.entrada.cuaderno.1.0.3',
        ),
        isTrue,
      );
    });

    test('claves de otros namespaces no se mezclan con las del cuaderno',
        () async {
      SharedPreferences.setMockInitialValues({
        'nuevoser.lasversiones.cuaderno.entrada.cuaderno.1.0.3': true,
        'nuevoser.lasversiones.flag.escena_1_0_3_vista': true,
        'uroto.cuaderno.entrada.X': true,
      });
      final repositorio = const RepositorioCuaderno();
      final ids = await repositorio.idsRegistrados();
      expect(ids, equals({'cuaderno.1.0.3'}),
          reason: 'sólo claves bajo nuestro prefijo concreto');
    });

    test('borrarTodas vacía las entradas del cuaderno y respeta otros '
        'namespaces', () async {
      SharedPreferences.setMockInitialValues({
        'nuevoser.lasversiones.cuaderno.entrada.cuaderno.1.0.3': true,
        'nuevoser.lasversiones.cuaderno.entrada.cuaderno.1.1.7': true,
        'nuevoser.lasversiones.flag.escena_1_0_3_vista': true,
      });
      final repositorio = const RepositorioCuaderno();
      await repositorio.borrarTodas();
      expect(await repositorio.idsRegistrados(), isEmpty);
      final prefs = await SharedPreferences.getInstance();
      expect(
        prefs.getBool('nuevoser.lasversiones.flag.escena_1_0_3_vista'),
        isTrue,
        reason: 'flags narrativos viven en otro namespace y no se tocan',
      );
    });
  });
}
