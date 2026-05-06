import 'package:flutter_test/flutter_test.dart';
import 'package:nuevo_ser_core/nuevo_ser_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:las_versiones/datos/repositorio_reconstruccion.dart';
import 'package:las_versiones/dominio/brecha.dart';

GestorPerfiles _gestorDePrueba() => GestorPerfiles(
      namespace: 'nuevoser.lasversiones',
      sufijoNombreVisible: 'nombre_jugador',
      clavesGlobalesNoMigrables: const {
        'nuevoser.lasversiones.idioma_app',
        'nuevoser.lasversiones.token_backend',
        'nuevoser.lasversiones.email_backend',
      },
    );

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('RepositorioReconstruccion', () {
    test('cargar en almacén limpio devuelve mapa vacío', () async {
      final repositorio = RepositorioReconstruccion(gestor: _gestorDePrueba());
      expect(await repositorio.cargar('1.1'), isEmpty);
    });

    test('guardar y cargar conserva pares idAfirmacion → nivel', () async {
      final repositorio = RepositorioReconstruccion(gestor: _gestorDePrueba());
      await repositorio.guardar('1.1', const {
        'A': NivelConfianza.solido,
        'B': NivelConfianza.disputado,
      });
      final cargado = await repositorio.cargar('1.1');
      expect(cargado.length, 2);
      expect(cargado['A'], NivelConfianza.solido);
      expect(cargado['B'], NivelConfianza.disputado);
    });

    test(
        'clave persistida sigue el namespace '
        'nuevoser.lasversiones.perfil.principal.brecha.<id>.reconstruccion',
        () async {
      final repositorio = RepositorioReconstruccion(gestor: _gestorDePrueba());
      await repositorio.guardar(
        '1.1',
        const {'A': NivelConfianza.solido},
      );
      final prefs = await SharedPreferences.getInstance();
      expect(
        prefs.getString(
          'nuevoser.lasversiones.perfil.principal.brecha.1.1.reconstruccion',
        ),
        isNotNull,
      );
    });

    test('aislamiento entre brechas distintas', () async {
      final repositorio = RepositorioReconstruccion(gestor: _gestorDePrueba());
      await repositorio.guardar('1.1', const {'A': NivelConfianza.solido});
      await repositorio.guardar('1.2', const {'X': NivelConfianza.probable});
      expect(
        (await repositorio.cargar('1.1')).keys,
        equals({'A'}),
      );
      expect(
        (await repositorio.cargar('1.2')).keys,
        equals({'X'}),
      );
    });

    test('blob corrupto → mapa vacío sin propagar excepción', () async {
      SharedPreferences.setMockInitialValues({
        'nuevoser.lasversiones.perfil_activo_id': 'principal',
        'nuevoser.lasversiones.perfiles_lista': <String>['principal'],
        'nuevoser.lasversiones.perfil.principal.brecha.1.1.reconstruccion':
            '{ no es JSON }',
      });
      final repositorio = RepositorioReconstruccion(gestor: _gestorDePrueba());
      expect(await repositorio.cargar('1.1'), isEmpty);
    });

    test('JSON con tipo inesperado (lista, no objeto) → mapa vacío',
        () async {
      SharedPreferences.setMockInitialValues({
        'nuevoser.lasversiones.perfil_activo_id': 'principal',
        'nuevoser.lasversiones.perfiles_lista': <String>['principal'],
        'nuevoser.lasversiones.perfil.principal.brecha.1.1.reconstruccion':
            '["solido"]',
      });
      final repositorio = RepositorioReconstruccion(gestor: _gestorDePrueba());
      expect(await repositorio.cargar('1.1'), isEmpty);
    });

    test('nombres de nivel desconocidos se filtran silenciosamente',
        () async {
      SharedPreferences.setMockInitialValues({
        'nuevoser.lasversiones.perfil_activo_id': 'principal',
        'nuevoser.lasversiones.perfiles_lista': <String>['principal'],
        'nuevoser.lasversiones.perfil.principal.brecha.1.1.reconstruccion':
            '{"A":"solido","B":"inventado"}',
      });
      final repositorio = RepositorioReconstruccion(gestor: _gestorDePrueba());
      final cargado = await repositorio.cargar('1.1');
      expect(cargado.keys, equals({'A'}));
    });

    test('borrar quita el blob sin tocar otras brechas', () async {
      final repositorio = RepositorioReconstruccion(gestor: _gestorDePrueba());
      await repositorio.guardar('1.1', const {'A': NivelConfianza.solido});
      await repositorio.guardar('1.2', const {'X': NivelConfianza.solido});
      await repositorio.borrar('1.1');
      expect(await repositorio.cargar('1.1'), isEmpty);
      expect((await repositorio.cargar('1.2')).keys, equals({'X'}));
    });
  });
}
