import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:las_versiones/datos/repositorio_recoleccion_fuentes.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('RepositorioRecoleccionFuentes', () {
    test('tieneFuente devuelve false en almacén limpio', () async {
      final repositorio = const RepositorioRecoleccionFuentes();
      expect(
        await repositorio.tieneFuente('1.1', 'restos_oseos_in_situ'),
        isFalse,
      );
    });

    test('registrarFuente y leer la marca', () async {
      final repositorio = const RepositorioRecoleccionFuentes();
      await repositorio.registrarFuente('1.1', 'restos_oseos_in_situ');
      expect(
        await repositorio.tieneFuente('1.1', 'restos_oseos_in_situ'),
        isTrue,
      );
    });

    test('aislamiento entre brechas distintas', () async {
      final repositorio = const RepositorioRecoleccionFuentes();
      await repositorio.registrarFuente('1.1', 'restos_oseos_in_situ');
      expect(
        await repositorio.tieneFuente('1.2', 'restos_oseos_in_situ'),
        isFalse,
        reason: 'una fuente con el mismo id en otra Brecha es independiente',
      );
    });

    test('idsFuentesRecogidas devuelve sólo las activas para la brecha pedida',
        () async {
      SharedPreferences.setMockInitialValues({
        'nuevoser.lasversiones.brecha.1.1.fuente.A': true,
        'nuevoser.lasversiones.brecha.1.1.fuente.B': true,
        'nuevoser.lasversiones.brecha.1.2.fuente.X': true,
      });
      final repositorio = const RepositorioRecoleccionFuentes();
      expect(
        await repositorio.idsFuentesRecogidas('1.1'),
        equals({'A', 'B'}),
      );
      expect(
        await repositorio.idsFuentesRecogidas('1.2'),
        equals({'X'}),
      );
    });

    test('clave persistida sigue el namespace '
        'nuevoser.lasversiones.brecha.<id>.fuente.<idFuente>', () async {
      final repositorio = const RepositorioRecoleccionFuentes();
      await repositorio.registrarFuente('1.1', 'restos_oseos_in_situ');
      final prefs = await SharedPreferences.getInstance();
      expect(
        prefs.getBool(
          'nuevoser.lasversiones.brecha.1.1.fuente.restos_oseos_in_situ',
        ),
        isTrue,
      );
    });

    test('borrar quita las fuentes de la brecha y respeta otras', () async {
      SharedPreferences.setMockInitialValues({
        'nuevoser.lasversiones.brecha.1.1.fuente.A': true,
        'nuevoser.lasversiones.brecha.1.2.fuente.X': true,
        'nuevoser.lasversiones.flag.escena_1_0_3_vista': true,
      });
      final repositorio = const RepositorioRecoleccionFuentes();
      await repositorio.borrar('1.1');
      expect(await repositorio.idsFuentesRecogidas('1.1'), isEmpty);
      expect(
        await repositorio.idsFuentesRecogidas('1.2'),
        equals({'X'}),
        reason: 'borrar 1.1 no toca 1.2',
      );
      final prefs = await SharedPreferences.getInstance();
      expect(
        prefs.getBool('nuevoser.lasversiones.flag.escena_1_0_3_vista'),
        isTrue,
        reason: 'flags narrativos no se tocan',
      );
    });
  });
}
