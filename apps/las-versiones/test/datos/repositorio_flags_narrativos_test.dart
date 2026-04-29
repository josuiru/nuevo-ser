import 'package:flutter_test/flutter_test.dart';
import 'package:las_versiones/datos/repositorio_flags_narrativos.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  group('RepositorioFlagsNarrativos', () {
    test('estaActivo devuelve false en almacén limpio', () async {
      const repo = RepositorioFlagsNarrativos();
      expect(await repo.estaActivo('met_isaura'), isFalse);
    });

    test('activar y leer un flag', () async {
      const repo = RepositorioFlagsNarrativos();
      await repo.activar('escena_1_0_1_vista');
      expect(await repo.estaActivo('escena_1_0_1_vista'), isTrue);
    });

    test('activar es idempotente — segundo activar no rompe ni desactiva',
        () async {
      const repo = RepositorioFlagsNarrativos();
      await repo.activar('met_begona');
      await repo.activar('met_begona');
      expect(await repo.estaActivo('met_begona'), isTrue);
    });

    test('activos() devuelve el conjunto de flags activos sin el prefijo',
        () async {
      const repo = RepositorioFlagsNarrativos();
      await repo.activar('met_isaura');
      await repo.activar('met_begona');
      await repo.activar('evaluation_passed');
      final activos = await repo.activos();
      expect(activos, {'met_isaura', 'met_begona', 'evaluation_passed'});
    });

    test('activos() ignora claves de otros namespaces — el repositorio '
        'sólo ve los flags propios del juego', () async {
      SharedPreferences.setMockInitialValues({
        'nuevoser.lasversiones.flag.met_isaura': true,
        'uroto.flag.escena_1_1_vista': true,
        'nuevoser.lasversiones.idioma_app': 'es',
      });
      const repo = RepositorioFlagsNarrativos();
      final activos = await repo.activos();
      expect(activos, {'met_isaura'});
    });

    test('clave persistida lleva el namespace nuevoser.lasversiones.flag.*',
        () async {
      const repo = RepositorioFlagsNarrativos();
      await repo.activar('accepted_aspirante');
      final prefs = await SharedPreferences.getInstance();
      expect(
        prefs.getBool('nuevoser.lasversiones.flag.accepted_aspirante'),
        isTrue,
      );
    });

    test('borrarTodos quita los flags propios y respeta claves de otros '
        'namespaces', () async {
      SharedPreferences.setMockInitialValues({
        'nuevoser.lasversiones.flag.met_isaura': true,
        'nuevoser.lasversiones.flag.evaluation_passed': true,
        'nuevoser.lasversiones.idioma_app': 'es',
      });
      const repo = RepositorioFlagsNarrativos();
      await repo.borrarTodos();
      expect(await repo.activos(), isEmpty);
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('nuevoser.lasversiones.idioma_app'), 'es',
          reason: 'el idioma no es un flag y no debe borrarse');
    });
  });
}
