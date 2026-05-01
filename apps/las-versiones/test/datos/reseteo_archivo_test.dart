import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:las_versiones/datos/reseteo_archivo.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('ReseteoArchivo', () {
    test('borrarTodo en almacén vacío devuelve 0 sin lanzar', () async {
      const reseteo = ReseteoArchivo(
        prefs: SharedPreferences.getInstance,
      );
      final clavesBorradas = await reseteo.borrarTodo();
      expect(clavesBorradas, 0);
    });

    test(
      'borrarTodo con claves del namespace nuevoser.lasversiones.* '
      'las elimina y devuelve el conteo',
      () async {
        SharedPreferences.setMockInitialValues({
          'nuevoser.lasversiones.idioma_app': 'es',
          'nuevoser.lasversiones.flag.escena_1_0_1_vista': true,
          'nuevoser.lasversiones.flag.brecha_1_1_completada': true,
          'nuevoser.lasversiones.token_backend': 'jwt-fake',
          'nuevoser.lasversiones.cuaderno.entrada.1_0_1': true,
        });
        const reseteo = ReseteoArchivo(
          prefs: SharedPreferences.getInstance,
        );
        final clavesBorradas = await reseteo.borrarTodo();
        expect(clavesBorradas, 5);

        final almacen = await SharedPreferences.getInstance();
        expect(almacen.getKeys(), isEmpty);
      },
    );

    test(
      'borrarTodo respeta el prefijo — claves de otros namespaces se '
      'preservan (uroto, otra app, etc.)',
      () async {
        SharedPreferences.setMockInitialValues({
          'nuevoser.lasversiones.idioma_app': 'es',
          'nuevoser.lasversiones.flag.escena_1_0_1_vista': true,
          // Convive un hipotético uno-roto en el mismo dispositivo —
          // el reset de las-versiones NO debe tocarlo.
          'uroto.perfil.principal.algun_estado': 'foo',
          'uroto.token_backend': 'otro-jwt',
        });
        const reseteo = ReseteoArchivo(
          prefs: SharedPreferences.getInstance,
        );
        final clavesBorradas = await reseteo.borrarTodo();
        expect(clavesBorradas, 2);

        final almacen = await SharedPreferences.getInstance();
        expect(almacen.getKeys(), {
          'uroto.perfil.principal.algun_estado',
          'uroto.token_backend',
        });
      },
    );

    test(
      'prefijoNamespace personalizable — útil cuando el juego adopte '
      'multi-perfil y el reset apunte sólo al perfil activo',
      () async {
        SharedPreferences.setMockInitialValues({
          'nuevoser.lasversiones.perfil.maren.flag.x': true,
          'nuevoser.lasversiones.perfil.maren.flag.y': true,
          'nuevoser.lasversiones.perfil.tasio.flag.x': true,
          'nuevoser.lasversiones.idioma_app': 'es',
        });
        const reseteo = ReseteoArchivo(
          prefs: SharedPreferences.getInstance,
          prefijoNamespace: 'nuevoser.lasversiones.perfil.maren.',
        );
        final clavesBorradas = await reseteo.borrarTodo();
        expect(clavesBorradas, 2);

        final almacen = await SharedPreferences.getInstance();
        expect(almacen.getKeys(), {
          'nuevoser.lasversiones.perfil.tasio.flag.x',
          'nuevoser.lasversiones.idioma_app',
        });
      },
    );
  });
}
